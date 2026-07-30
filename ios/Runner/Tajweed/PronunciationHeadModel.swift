import CoreML
import Foundation

/// Offline pronunciation head: pooled encoder + token id → prob_correct.
final class PronunciationHeadModel {
  private var model: MLModel?

  var isLoaded: Bool { model != nil }

  func load(packageURL: URL) throws {
    let compiled: URL
    if packageURL.pathExtension == "mlmodelc" {
      compiled = packageURL
    } else {
      compiled = try MLModel.compileModel(at: packageURL)
    }
    let config = MLModelConfiguration()
    if #available(iOS 16.0, *) {
      config.computeUnits = .cpuAndNeuralEngine
    } else {
      config.computeUnits = .cpuAndGPU
    }
    model = try MLModel(contentsOf: compiled, configuration: config)
  }

  func unload() {
    model = nil
  }

  /// Mean-pool encoder frames [start, end) and score token.
  func score(
    encoder: [[Float]],
    tokenId: Int,
    startFrame: Int,
    endFrame: Int
  ) throws -> Float {
    guard let model else {
      throw TajweedNativeError(TajweedErrorCode.modelLoadFailed, "Head model not loaded.")
    }
    guard !encoder.isEmpty else { return 1.0 }
    let dim = encoder[0].count
    let s = max(0, min(startFrame, encoder.count - 1))
    let e = max(s + 1, min(endFrame, encoder.count))
    var pooled = [Float](repeating: 0, count: dim)
    let count = Float(e - s)
    for t in s..<e {
      for d in 0..<dim {
        pooled[d] += encoder[t][d]
      }
    }
    for d in 0..<dim {
      pooled[d] /= count
    }

    // Feature provider: try common input names from upstream packages.
    let encArr = try MLMultiArray(shape: [1, NSNumber(value: dim)], dataType: .float32)
    for d in 0..<dim {
      encArr[d] = NSNumber(value: pooled[d])
    }
    let tokArr = try MLMultiArray(shape: [1], dataType: .int32)
    tokArr[0] = NSNumber(value: tokenId)

    let inputs = model.modelDescription.inputDescriptionsByName
    var dict: [String: Any] = [:]
    if let encKey = inputs.keys.first(where: { $0.lowercased().contains("enc") })
      ?? inputs.keys.first
    {
      dict[encKey] = encArr
    }
    if let tokKey = inputs.keys.first(where: {
      $0.lowercased().contains("token") || $0.lowercased().contains("id")
    }) {
      dict[tokKey] = tokArr
    } else if inputs.count > 1 {
      let keys = Array(inputs.keys)
      dict[keys[1]] = tokArr
    }

    let provider = try MLDictionaryFeatureProvider(dictionary: dict)
    let out = try model.prediction(from: provider)
    if let name = out.featureNames.first(where: { $0.lowercased().contains("prob") })
      ?? out.featureNames.first,
      let value = out.featureValue(for: name)
    {
      if let arr = value.multiArrayValue {
        return arr[0].floatValue
      }
      return Float(value.doubleValue)
    }
    return 1.0
  }

  static func status(forProb prob: Float) -> String {
    if prob < 0.5 { return "major" }
    if prob < 0.85 { return "minor" }
    return "ok"
  }
}
