package com.rnr.deenfocus.assetdownload

/**
 * Generic exceptions for the reusable native asset-download framework (ADR-008).
 * Intentionally independent of any specific consumer's error codes (e.g. Tajweed's
 * `TajweedErrorCode`) so this framework has zero knowledge of AI inference, ONNX,
 * or Tajweed — consumers translate these into their own error contracts at the
 * adapter boundary (see `TajweedAssetSync`).
 */
sealed class AssetDownloadException(message: String) : Exception(message) {
    class Network(message: String) : AssetDownloadException(message)
    class BadStatusCode(val code: Int) : AssetDownloadException("HTTP $code")
    class DecodeFailed(message: String) : AssetDownloadException(message)
    object Timeout : AssetDownloadException("Timed out")
    object Cancelled : AssetDownloadException("Cancelled")
    class InsufficientStorage(val requiredBytes: Long, val availableBytes: Long) :
        AssetDownloadException("Need $requiredBytes bytes, only $availableBytes available")
    class DiskError(message: String) : AssetDownloadException(message)
    class IntegrityMismatch(val fileName: String) : AssetDownloadException("SHA-256 mismatch for $fileName")
    class InvalidManifest(message: String) : AssetDownloadException(message)
}
