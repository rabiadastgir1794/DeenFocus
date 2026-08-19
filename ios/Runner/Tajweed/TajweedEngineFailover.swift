import Foundation

/// Session-scoped Official → DIY CoreML failover (**production**, all builds).
///
/// Works in Debug, Profile, and Release — not gated by `#if DEBUG` / `kDebugMode`.
/// Production prefers Official HF CoreML from `catalog.json`. On any Official
/// load / init / inference failure, [markDiyForSession] switches the process to
/// DIY CoreML (`ios/tajweed/v1.1.0/`, `single_function_fixed`) for the rest of
/// this launch. The flag is **in-memory only** — the next cold start tries
/// Official again.
///
/// Note: iOS has no ONNX runtime. “DIY” here is the DIY **CoreML** pack on R2
/// (not Android ONNX, not an IPA-bundled model).
enum TajweedEngineFailover {
  private static let r2Base = "https://pub-470cb85af0ad4c5f92edb5094b8a7dbb.r2.dev"
  private static let lock = NSLock()
  private static var _sessionUsesDiy = false
  private static var _lastReason: String?

  /// True after Official failed this process; DIY is preferred for remaining calls.
  static var sessionUsesDiy: Bool {
    lock.lock()
    defer { lock.unlock() }
    return _sessionUsesDiy
  }

  static var lastReason: String? {
    lock.lock()
    defer { lock.unlock() }
    return _lastReason
  }

  static func markDiyForSession(reason: String) {
    lock.lock()
    _sessionUsesDiy = true
    _lastReason = reason
    lock.unlock()
    NSLog("[TajweedFailover] session → DIY CoreML reason=%@", reason)
  }

  /// Materialize a local catalog that points only at DIY CoreML v1.1.0.
  /// Usable in Release (unlike `TajweedDevModelOverride`, which is Debug-gated).
  static func diyCatalogFileURL() -> URL? {
    let payload: [String: Any] = [
      "catalogVersion": 1,
      "updatedAt": "2026-08-03T00:00:00Z",
      "recommendedCheckIntervalHours": 24,
      "packs": [
        [
          "packId": TajweedAssetDistributionConfig.assetId,
          "kind": "tajweed_model",
          "displayName": "Hafs (Arabic) + English feedback (DIY failover)",
          "language": "en",
          "riwayah": "Hafs",
          "isDefault": true,
          "latestVersion": "1.1.0",
          "minimumAppVersion": "1.0.0",
          "manifestUrl": [
            "ios": "\(r2Base)/ios/tajweed/v1.1.0/model_manifest.json",
          ],
          "approxSizeBytes": [
            "ios": 158_789_625,
          ],
        ],
      ],
    ]
    let dir = ModelStore.shared.rootURL
    try? FileManager.default.createDirectory(at: dir, withIntermediateDirectories: true)
    let url = dir.appendingPathComponent("failover_catalog_diy.json")
    guard let data = try? JSONSerialization.data(withJSONObject: payload, options: [.prettyPrinted])
    else { return nil }
    try? data.write(to: url, options: .atomic)
    return url
  }
}
