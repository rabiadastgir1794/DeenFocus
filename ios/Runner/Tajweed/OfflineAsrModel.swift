import CoreML
import Foundation

struct AsrInferenceResult {
  let logprobs: [[Float]]
  let encoderOutput: [[Float]]
  let bucketT: Int
  /// Mel pad / bucket step only (ms).
  let padMs: Double
  /// Time to resolve/load/compile the CoreML function (ms). Often huge on first call.
  let modelObtainMs: Double
  /// Time to fill `MLMultiArray` input buffers (ms).
  let inputCopyMs: Double
  /// CoreML `prediction` call only (ms).
  let encoderMs: Double
  /// Time to copy CoreML outputs into Swift arrays (ms).
  let outputParseMs: Double
  /// CoreML function used (`predict_T800`, or `__single__` for DIY).
  let functionName: String
  /// Compute units requested when the MLModel was loaded.
  let computeUnits: String
  /// True when this call had to compile/load a new specialized model (cold path).
  let modelWasColdLoad: Bool
}

/// Which CoreML encoder API the **active** on-disk pack exposes. Chosen at
/// runtime from `model_manifest.json` (`ModelStore.encoderApi()`), never at
/// compile time — so Cloudflare catalog/manifest flips can switch DIY ↔
/// official (or any future CoreML variant) without a Swift code change.
///
/// - `multifunction`: official HF offline-ANE style — specialized functions
///   named `"\(functionPrefix)\(T)"` (default prefix `predict_T`) for each
///   mel-time bucket in `buckets`. No separate `length` input.
/// - `singleFunctionFixedLength`: DIY-style single graph with static mel `T`
///   and an explicit `length` input carrying the true (unpadded) frame count.
enum EncoderApi: Equatable {
  case multifunction(buckets: [Int])
  case singleFunctionFixedLength(t: Int)
}

/// Loads the offline FastConformer CoreML package selected by the active
/// `ModelStore` manifest (DIY or official — see `EncoderApi`).
final class OfflineAsrModel {
  private var packageURL: URL?
  private var encoderApi: EncoderApi = .multifunction(buckets: MelFrontend.defaultOfficialBuckets)
  private var functionPrefix: String = "predict_T"
  private var modelsByFunction: [String: MLModel] = [:]
  /// Compute-units string recorded when each specialized model was loaded.
  private var computeUnitsByFunction: [String: String] = [:]
  /// Cached `mlmodelc` URL so we do not re-enter `compileModel` on every cold function load.
  private var compiledModelURL: URL?
  private let lock = NSLock()

  private static let singleFunctionKey = "__single__"

  static func describeComputeUnits(_ units: MLComputeUnits) -> String {
    switch units {
    case .all: return "all"
    case .cpuOnly: return "cpuOnly"
    case .cpuAndGPU: return "cpuAndGPU"
    case .cpuAndNeuralEngine: return "cpuAndNeuralEngine"
    @unknown default: return "unknown(\(units.rawValue))"
    }
  }

  var isLoaded: Bool {
    lock.lock()
    defer { lock.unlock() }
    return packageURL != nil
  }

  var loadedEncoderApi: EncoderApi? {
    lock.lock()
    defer { lock.unlock() }
    return packageURL == nil ? nil : encoderApi
  }

  var loadedPackagePath: String? {
    lock.lock()
    defer { lock.unlock() }
    return packageURL?.path
  }

  var loadedFunctionPrefix: String? {
    lock.lock()
    defer { lock.unlock() }
    return packageURL == nil ? nil : functionPrefix
  }

  /// Number of specialized CoreML functions currently resident in memory.
  var cachedSpecializedModelCount: Int {
    lock.lock()
    defer { lock.unlock() }
    return modelsByFunction.count
  }

  func load(
    packageURL: URL,
    encoderApi: EncoderApi = .multifunction(buckets: MelFrontend.defaultOfficialBuckets),
    functionPrefix: String = "predict_T"
  ) throws {
    lock.lock()
    defer { lock.unlock() }
    let prefix = functionPrefix.isEmpty ? "predict_T" : functionPrefix
    let samePack =
      self.packageURL == packageURL
      && self.encoderApi == encoderApi
      && self.functionPrefix == prefix
    self.packageURL = packageURL
    self.encoderApi = encoderApi
    self.functionPrefix = prefix
    // Keep specialized MLModel instances across idempotent load() calls so a
    // second prepareModel / startRecording does not pay multi-second obtain again.
    if !samePack {
      modelsByFunction.removeAll()
      computeUnitsByFunction.removeAll()
      compiledModelURL = nil
      NSLog(
        "[TajweedCoreML] load cleared specialized cache (pack/api/prefix changed) path=%@",
        packageURL.lastPathComponent
      )
    }
    compiledModelURL = try compiledURLLocked(for: packageURL)
  }

  func unload() {
    lock.lock()
    defer { lock.unlock() }
    let n = modelsByFunction.count
    modelsByFunction.removeAll()
    computeUnitsByFunction.removeAll()
    compiledModelURL = nil
    packageURL = nil
    if n > 0 {
      NSLog("[TajweedCoreML] unload dropped %d specialized model(s)", n)
    }
  }

  /// Eagerly load every specialized encoder entry for the active pack so the
  /// first (and later) score paths hit the in-memory cache. Safe / idempotent.
  @discardableResult
  func preloadAllSpecializedModels() throws -> (coldLoads: Int, elapsedMs: Double) {
    lock.lock()
    let api = encoderApi
    let already = modelsByFunction.count
    lock.unlock()

    let t0 = CFAbsoluteTimeGetCurrent()
    var coldLoads = 0
    switch api {
    case .multifunction(let buckets):
      for bucketT in buckets.sorted() {
        let (_, cold) = try modelForBucketTimed(bucketT)
        if cold { coldLoads += 1 }
      }
    case .singleFunctionFixedLength:
      let (_, cold) = try singleFunctionModelTimed()
      if cold { coldLoads += 1 }
    }
    let elapsedMs = (CFAbsoluteTimeGetCurrent() - t0) * 1000
    lock.lock()
    let cacheSize = modelsByFunction.count
    lock.unlock()
    NSLog(
      "[TajweedCoreML] preload done coldLoads=%d cacheBefore=%d cacheAfter=%d elapsedMs=%.1f",
      coldLoads,
      already,
      cacheSize,
      elapsedMs
    )
    return (coldLoads, elapsedMs)
  }

  /// `mel`: unpadded log-mel features, row-major `[80 * time]`. `time`: real
  /// (unpadded) frame count. Padding/bucketing is chosen internally based on
  /// the loaded package's `EncoderApi`.
  func predict(mel: [Float], time: Int) throws -> AsrInferenceResult {
    lock.lock()
    let api = encoderApi
    let prefix = functionPrefix
    lock.unlock()

    switch api {
    case .multifunction(let buckets):
      let tPad0 = CFAbsoluteTimeGetCurrent()
      let (padded, bucketT) = try MelFrontend.padToBucket(mel, time: time, buckets: buckets)
      let padMs = (CFAbsoluteTimeGetCurrent() - tPad0) * 1000
      let functionName = "\(prefix)\(bucketT)"
      return try predictMultifunction(
        melPadded: padded, bucketT: bucketT, padMs: padMs, functionName: functionName
      )
    case .singleFunctionFixedLength(let fixedT):
      let tPad0 = CFAbsoluteTimeGetCurrent()
      let padded = try MelFrontend.padToFixed(mel, time: time, fixedT: fixedT)
      let padMs = (CFAbsoluteTimeGetCurrent() - tPad0) * 1000
      return try predictSingleFunction(
        melPadded: padded, time: time, fixedT: fixedT, padMs: padMs
      )
    }
  }

  private func predictMultifunction(
    melPadded: [Float],
    bucketT: Int,
    padMs: Double,
    functionName: String
  ) throws -> AsrInferenceResult {
    let tObtain0 = CFAbsoluteTimeGetCurrent()
    let (model, cold) = try modelForBucketTimed(bucketT)
    let modelObtainMs = (CFAbsoluteTimeGetCurrent() - tObtain0) * 1000

    let tCopy0 = CFAbsoluteTimeGetCurrent()
    let shaped = try MLMultiArray(shape: [1, 80, NSNumber(value: bucketT)], dataType: .float32)
    MLMultiArrayFloatCopy.copy(melPadded, into: shaped)
    let inputName = model.modelDescription.inputDescriptionsByName.keys.first ?? "audio_signal"
    let provider = try MLDictionaryFeatureProvider(dictionary: [inputName: shaped])
    let inputCopyMs = (CFAbsoluteTimeGetCurrent() - tCopy0) * 1000

    let tEnc0 = CFAbsoluteTimeGetCurrent()
    let out = try model.prediction(from: provider)
    let encoderMs = (CFAbsoluteTimeGetCurrent() - tEnc0) * 1000
    let units = computeUnitsLabel(for: functionName)
    return try parseOutputs(
      out,
      bucketT: bucketT,
      padMs: padMs,
      modelObtainMs: modelObtainMs,
      inputCopyMs: inputCopyMs,
      encoderMs: encoderMs,
      functionName: functionName,
      computeUnits: units,
      modelWasColdLoad: cold
    )
  }

  private func predictSingleFunction(
    melPadded: [Float],
    time: Int,
    fixedT: Int,
    padMs: Double
  ) throws -> AsrInferenceResult {
    let tObtain0 = CFAbsoluteTimeGetCurrent()
    let (model, cold) = try singleFunctionModelTimed()
    let modelObtainMs = (CFAbsoluteTimeGetCurrent() - tObtain0) * 1000

    let tCopy0 = CFAbsoluteTimeGetCurrent()
    let shaped = try MLMultiArray(shape: [1, 80, NSNumber(value: fixedT)], dataType: .float32)
    MLMultiArrayFloatCopy.copy(melPadded, into: shaped)
    let lengthArr = try MLMultiArray(shape: [1], dataType: .int32)
    lengthArr[0] = NSNumber(value: time)
    let provider = try MLDictionaryFeatureProvider(dictionary: [
      "audio_signal": shaped,
      "length": lengthArr,
    ])
    let inputCopyMs = (CFAbsoluteTimeGetCurrent() - tCopy0) * 1000

    let tEnc0 = CFAbsoluteTimeGetCurrent()
    let out = try model.prediction(from: provider)
    let encoderMs = (CFAbsoluteTimeGetCurrent() - tEnc0) * 1000
    let units = computeUnitsLabel(for: Self.singleFunctionKey)
    return try parseOutputs(
      out,
      bucketT: fixedT,
      padMs: padMs,
      modelObtainMs: modelObtainMs,
      inputCopyMs: inputCopyMs,
      encoderMs: encoderMs,
      functionName: Self.singleFunctionKey,
      computeUnits: units,
      modelWasColdLoad: cold
    )
  }

  private func computeUnitsLabel(for key: String) -> String {
    lock.lock()
    defer { lock.unlock() }
    return computeUnitsByFunction[key] ?? "unknown"
  }

  private func preferredComputeUnits() -> (MLComputeUnits, String) {
    if #available(iOS 16.0, *) {
      return (.cpuAndNeuralEngine, Self.describeComputeUnits(.cpuAndNeuralEngine))
    }
    return (.cpuAndGPU, Self.describeComputeUnits(.cpuAndGPU))
  }

  private func singleFunctionModelTimed() throws -> (MLModel, Bool) {
    lock.lock()
    if let existing = modelsByFunction[Self.singleFunctionKey] {
      lock.unlock()
      return (existing, false)
    }
    guard let packageURL else {
      lock.unlock()
      throw TajweedNativeError(TajweedErrorCode.modelLoadFailed, "ASR model not loaded.")
    }
    lock.unlock()

    NSLog("[TajweedCoreML] modelObtain cacheMISS function=%@", Self.singleFunctionKey)
    let t0 = CFAbsoluteTimeGetCurrent()
    let compiled = try compiledURL(for: packageURL)
    let config = MLModelConfiguration()
    let (units, unitsLabel) = preferredComputeUnits()
    config.computeUnits = units
    let model = try MLModel(contentsOf: compiled, configuration: config)
    let obtainMs = (CFAbsoluteTimeGetCurrent() - t0) * 1000

    lock.lock()
    modelsByFunction[Self.singleFunctionKey] = model
    computeUnitsByFunction[Self.singleFunctionKey] = unitsLabel
    lock.unlock()
    NSLog(
      "[TajweedCoreML] modelObtain loaded function=%@ units=%@ ms=%.1f",
      Self.singleFunctionKey,
      unitsLabel,
      obtainMs
    )
    return (model, true)
  }

  private func modelForBucketTimed(_ bucketT: Int) throws -> (MLModel, Bool) {
    lock.lock()
    let prefix = functionPrefix
    lock.unlock()
    let functionName = "\(prefix)\(bucketT)"
    lock.lock()
    if let existing = modelsByFunction[functionName] {
      lock.unlock()
      return (existing, false)
    }
    guard let packageURL else {
      lock.unlock()
      throw TajweedNativeError(TajweedErrorCode.modelLoadFailed, "ASR model not loaded.")
    }
    lock.unlock()

    NSLog("[TajweedCoreML] modelObtain cacheMISS function=%@", functionName)
    let t0 = CFAbsoluteTimeGetCurrent()
    let compiled = try compiledURL(for: packageURL)
    let config = MLModelConfiguration()
    let (units, unitsLabel) = preferredComputeUnits()
    config.computeUnits = units
    if #available(iOS 18.0, *) {
      config.functionName = functionName
    }
    let model = try MLModel(contentsOf: compiled, configuration: config)
    let obtainMs = (CFAbsoluteTimeGetCurrent() - t0) * 1000

    lock.lock()
    modelsByFunction[functionName] = model
    computeUnitsByFunction[functionName] = unitsLabel
    lock.unlock()
    NSLog(
      "[TajweedCoreML] modelObtain loaded function=%@ units=%@ ms=%.1f",
      functionName,
      unitsLabel,
      obtainMs
    )
    return (model, true)
  }

  private func compiledURL(for packageURL: URL) throws -> URL {
    lock.lock()
    defer { lock.unlock() }
    return try compiledURLLocked(for: packageURL)
  }

  /// Caller must hold `lock`, or invoke only when exclusive ownership is guaranteed.
  private func compiledURLLocked(for packageURL: URL) throws -> URL {
    if packageURL.pathExtension == "mlmodelc" {
      compiledModelURL = packageURL
      return packageURL
    }
    if let cached = compiledModelURL {
      return cached
    }
    let t0 = CFAbsoluteTimeGetCurrent()
    let compiled = try MLModel.compileModel(at: packageURL)
    let ms = (CFAbsoluteTimeGetCurrent() - t0) * 1000
    compiledModelURL = compiled
    NSLog(
      "[TajweedCoreML] compileModel package=%@ → %@ ms=%.1f",
      packageURL.lastPathComponent,
      compiled.lastPathComponent,
      ms
    )
    return compiled
  }

  private func parseOutputs(
    _ out: MLFeatureProvider,
    bucketT: Int,
    padMs: Double,
    modelObtainMs: Double,
    inputCopyMs: Double,
    encoderMs: Double,
    functionName: String,
    computeUnits: String,
    modelWasColdLoad: Bool
  ) throws -> AsrInferenceResult {
    let tParse0 = CFAbsoluteTimeGetCurrent()
    let names = out.featureNames
    guard let lpName = names.first(where: { $0.lowercased().contains("logprob") }) ?? names.first,
          let lp = out.featureValue(for: lpName)?.multiArrayValue
    else {
      throw TajweedNativeError(TajweedErrorCode.inferenceFailed, "Missing logprobs output.")
    }

    let frames = lp.shape.count >= 3 ? lp.shape[1].intValue : lp.shape[0].intValue
    let vocab = lp.shape.count >= 3 ? lp.shape[2].intValue : lp.shape[1].intValue
    let logprobs = MLMultiArrayFloatCopy.copyRows(from: lp, rows: frames, cols: vocab)

    var encoder: [[Float]] = []
    if let encName = names.first(where: { $0.lowercased().contains("encoder") }),
       let enc = out.featureValue(for: encName)?.multiArrayValue
    {
      let dims = enc.shape.count >= 3
        ? [enc.shape[1].intValue, enc.shape[2].intValue]
        : [enc.shape[0].intValue, 1]
      let channelFirst = dims[0] == 512 && dims[1] != 512
      let eFrames = channelFirst ? dims[1] : dims[0]
      let dim = channelFirst ? dims[0] : dims[1]
      if channelFirst {
        encoder = MLMultiArrayFloatCopy.copyChannelFirstToTimeMajor(from: enc, dim: dim, frames: eFrames)
      } else {
        encoder = MLMultiArrayFloatCopy.copyRows(from: enc, rows: eFrames, cols: dim)
      }
    }
    let outputParseMs = (CFAbsoluteTimeGetCurrent() - tParse0) * 1000

    return AsrInferenceResult(
      logprobs: logprobs,
      encoderOutput: encoder,
      bucketT: bucketT,
      padMs: padMs,
      modelObtainMs: modelObtainMs,
      inputCopyMs: inputCopyMs,
      encoderMs: encoderMs,
      outputParseMs: outputParseMs,
      functionName: functionName,
      computeUnits: computeUnits,
      modelWasColdLoad: modelWasColdLoad
    )
  }
}
