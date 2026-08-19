import Foundation

/// Generic errors for the reusable native asset-download framework (ADR-008).
/// Intentionally independent of any specific consumer's error codes (e.g. Tajweed's
/// `TajweedErrorCode`) so this framework has zero knowledge of AI inference,
/// CoreML, or Tajweed — consumers translate these into their own error contracts
/// at the adapter boundary (see `TajweedAssetSync`).
enum AssetDownloadError: Error, Equatable {
  case network(String)
  case badStatusCode(Int)
  case decodeFailed(String)
  case timeout
  case cancelled
  case insufficientStorage(requiredBytes: Int64, availableBytes: Int64)
  case diskError(String)
  case integrityMismatch(fileName: String)
  case invalidManifest(String)
}
