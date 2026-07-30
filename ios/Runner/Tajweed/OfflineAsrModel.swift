import CoreML
import Foundation

struct AsrInferenceResult {
  let logprobs: [[Float]]
  let encoderOutput: [[Float]]
  let bucketT: Int
}

/// Which CoreML encoder API a loaded package exposes. The gated official
/// packages are multifunction (`predict_T80…predict_T4800`, no separate
/// `length` input — each function bakes its own fixed T). A self-generated
/// (DIY, non-ANE-optimized) export from `fastconformer-quran.nemo` instead
/// produces a single-function graph with one static `T` and an explicit
/// `length` input (see `memory/features/tajweed/` DIY CoreML reports).
enum EncoderApi: Equatable {
  case multifunction
  case singleFunctionFixedLength(t: Int)
}

/// Loads the offline FastConformer CoreML package (official multifunction ANE
/// pack, or a DIY single-function fallback — see `EncoderApi`).
final class OfflineAsrModel {
  private var packageURL: URL?
  private var encoderApi: EncoderApi = .multifunction
  private var modelsByFunction: [String: MLModel] = [:]
  private let lock = NSLock()

  private static let singleFunctionKey = "__single__"

  var isLoaded: Bool {
    lock.lock()
    defer { lock.unlock() }
    return packageURL != nil
  }

  func load(packageURL: URL, encoderApi: EncoderApi = .multifunction) throws {
    lock.lock()
    defer { lock.unlock() }
    self.packageURL = packageURL
    self.encoderApi = encoderApi
    modelsByFunction.removeAll()
    // Compile once; specialized functions load lazily per bucket.
    _ = try compiledURL(for: packageURL)
  }

  func unload() {
    lock.lock()
    defer { lock.unlock() }
    modelsByFunction.removeAll()
    packageURL = nil
  }

  /// `mel`: unpadded log-mel features, row-major `[80 * time]`. `time`: real
  /// (unpadded) frame count. Padding/bucketing is chosen internally based on
  /// the loaded package's `EncoderApi`.
  func predict(mel: [Float], time: Int) throws -> AsrInferenceResult {
    lock.lock()
    let api = encoderApi
    lock.unlock()

    switch api {
    case .multifunction:
      let (padded, bucketT) = try MelFrontend.padToBucket(mel, time: time)
      return try predictMultifunction(melPadded: padded, bucketT: bucketT)
    case .singleFunctionFixedLength(let fixedT):
      let padded = try MelFrontend.padToFixed(mel, time: time, fixedT: fixedT)
      return try predictSingleFunction(melPadded: padded, time: time, fixedT: fixedT)
    }
  }

  private func predictMultifunction(melPadded: [Float], bucketT: Int) throws -> AsrInferenceResult {
    let model = try modelForBucket(bucketT)
    let shaped = try MLMultiArray(shape: [1, 80, NSNumber(value: bucketT)], dataType: .float32)
    for i in 0..<melPadded.count {
      shaped[i] = NSNumber(value: melPadded[i])
    }

    let inputName = model.modelDescription.inputDescriptionsByName.keys.first ?? "audio_signal"
    let provider = try MLDictionaryFeatureProvider(dictionary: [inputName: shaped])
    let out = try model.prediction(from: provider)
    return try parseOutputs(out, bucketT: bucketT)
  }

  /// DIY single-function encoder: fixed `(1,80,fixedT)` input plus an explicit
  /// `length` input carrying the true (unpadded) frame count — required for
  /// numerically correct output (verified against Android on host; omitting
  /// it or passing `fixedT` instead of the true length measurably changes
  /// the transcript, see `tajweed-lab/experiments/diy_coreml_poc/reports/`).
  private func predictSingleFunction(melPadded: [Float], time: Int, fixedT: Int) throws -> AsrInferenceResult {
    let model = try singleFunctionModel()
    let shaped = try MLMultiArray(shape: [1, 80, NSNumber(value: fixedT)], dataType: .float32)
    for i in 0..<melPadded.count {
      shaped[i] = NSNumber(value: melPadded[i])
    }
    let lengthArr = try MLMultiArray(shape: [1], dataType: .int32)
    lengthArr[0] = NSNumber(value: time)

    let provider = try MLDictionaryFeatureProvider(dictionary: [
      "audio_signal": shaped,
      "length": lengthArr,
    ])
    let out = try model.prediction(from: provider)
    return try parseOutputs(out, bucketT: fixedT)
  }

  private func singleFunctionModel() throws -> MLModel {
    lock.lock()
    if let existing = modelsByFunction[Self.singleFunctionKey] {
      lock.unlock()
      return existing
    }
    guard let packageURL else {
      lock.unlock()
      throw TajweedNativeError(TajweedErrorCode.modelLoadFailed, "ASR model not loaded.")
    }
    lock.unlock()

    let compiled = try compiledURL(for: packageURL)
    let config = MLModelConfiguration()
    // The DIY (full-attention, non-ANE-optimized) encoder failed to build an
    // execution plan under `.all` on host verification (CoreML partitioner
    // error -6 combining CPU+GPU+ANE); `.cpuAndNeuralEngine` alone works, so
    // keep the same configuration as the official multifunction path.
    if #available(iOS 16.0, *) {
      config.computeUnits = .cpuAndNeuralEngine
    } else {
      config.computeUnits = .cpuAndGPU
    }
    let model = try MLModel(contentsOf: compiled, configuration: config)

    lock.lock()
    modelsByFunction[Self.singleFunctionKey] = model
    lock.unlock()
    return model
  }

  private func modelForBucket(_ bucketT: Int) throws -> MLModel {
    let functionName = "predict_T\(bucketT)"
    lock.lock()
    if let existing = modelsByFunction[functionName] {
      lock.unlock()
      return existing
    }
    guard let packageURL else {
      lock.unlock()
      throw TajweedNativeError(TajweedErrorCode.modelLoadFailed, "ASR model not loaded.")
    }
    lock.unlock()

    let compiled = try compiledURL(for: packageURL)
    let config = MLModelConfiguration()
    if #available(iOS 16.0, *) {
      config.computeUnits = .cpuAndNeuralEngine
    } else {
      config.computeUnits = .cpuAndGPU
    }
    if #available(iOS 18.0, *) {
      config.functionName = functionName
    }
    let model = try MLModel(contentsOf: compiled, configuration: config)

    lock.lock()
    modelsByFunction[functionName] = model
    lock.unlock()
    return model
  }

  private func compiledURL(for packageURL: URL) throws -> URL {
    if packageURL.pathExtension == "mlmodelc" { return packageURL }
    return try MLModel.compileModel(at: packageURL)
  }

  private func parseOutputs(_ out: MLFeatureProvider, bucketT: Int) throws -> AsrInferenceResult {
    let names = out.featureNames
    guard let lpName = names.first(where: { $0.lowercased().contains("logprob") }) ?? names.first,
          let lp = out.featureValue(for: lpName)?.multiArrayValue
    else {
      throw TajweedNativeError(TajweedErrorCode.inferenceFailed, "Missing logprobs output.")
    }

    let frames = lp.shape.count >= 3 ? lp.shape[1].intValue : lp.shape[0].intValue
    let vocab = lp.shape.count >= 3 ? lp.shape[2].intValue : lp.shape[1].intValue
    var logprobs: [[Float]] = Array(repeating: Array(repeating: 0, count: vocab), count: frames)
    for t in 0..<frames {
      for v in 0..<vocab {
        logprobs[t][v] = lp[t * vocab + v].floatValue
      }
    }

    var encoder: [[Float]] = []
    if let encName = names.first(where: { $0.lowercased().contains("encoder") }),
       let enc = out.featureValue(for: encName)?.multiArrayValue
    {
      // Layout varies by export path: official multifunction packs are documented
      // as (1, T, 512); the DIY ONNX-derived export instead keeps ONNX's
      // channel-first (1, 512, T). Detect from shape rather than assuming.
      let dims = enc.shape.count >= 3 ? [enc.shape[1].intValue, enc.shape[2].intValue] : [enc.shape[0].intValue, 1]
      let channelFirst = dims[0] == 512 && dims[1] != 512
      let eFrames = channelFirst ? dims[1] : dims[0]
      let dim = channelFirst ? dims[0] : dims[1]
      encoder = Array(repeating: Array(repeating: 0, count: dim), count: eFrames)
      if channelFirst {
        for d in 0..<dim {
          for t in 0..<eFrames {
            encoder[t][d] = enc[d * eFrames + t].floatValue
          }
        }
      } else {
        for t in 0..<eFrames {
          for d in 0..<dim {
            encoder[t][d] = enc[t * dim + d].floatValue
          }
        }
      }
    }

    return AsrInferenceResult(logprobs: logprobs, encoderOutput: encoder, bucketT: bucketT)
  }
}
