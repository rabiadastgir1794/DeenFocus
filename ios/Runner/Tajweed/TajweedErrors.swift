import Foundation

/// Stable Flutter MethodChannel error codes (ADR-006). Add-only.
enum TajweedErrorCode {
  static let featureDisabled = "FEATURE_DISABLED"
  static let micPermissionDenied = "MIC_PERMISSION_DENIED"
  static let micBusy = "MIC_BUSY"
  static let notRecording = "NOT_RECORDING"
  static let alreadyRecording = "ALREADY_RECORDING"
  static let audioTooShort = "AUDIO_TOO_SHORT"
  static let audioTooLong = "AUDIO_TOO_LONG"
  static let audioQualityPoor = "AUDIO_QUALITY_POOR"
  static let modelMissing = "MODEL_MISSING"
  static let modelDownloadFailed = "MODEL_DOWNLOAD_FAILED"
  static let modelLoadFailed = "MODEL_LOAD_FAILED"
  static let inferenceFailed = "INFERENCE_FAILED"
  static let inferenceCancelled = "INFERENCE_CANCELLED"
  static let interrupted = "INTERRUPTED"
  static let unsupported = "UNSUPPORTED"
  static let invalidArgs = "INVALID_ARGS"
}

enum TajweedRecordingState: String {
  case idle
  case recording
  case scoring
  case cancelling
}

struct TajweedNativeError: Error {
  let code: String
  let message: String

  init(_ code: String, _ message: String) {
    self.code = code
    self.message = message
  }
}
