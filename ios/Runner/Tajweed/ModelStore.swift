import CryptoKit
import Foundation

/// On-device model pack lifecycle (ADR-007).
final class ModelStore {
  static let shared = ModelStore()

  private let fm = FileManager.default
  private let rootName = "TajweedModels"

  var rootURL: URL {
    let base = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    return base.appendingPathComponent(rootName, isDirectory: true)
  }

  var activeURL: URL { rootURL.appendingPathComponent("active", isDirectory: true) }

  var manifestURL: URL { activeURL.appendingPathComponent("model_manifest.json") }

  func isAvailable() -> Bool {
    guard
      let manifest = readManifest(),
      let encoder = manifest["encoder"] as? String,
      let head = manifest["pronunciationHead"] as? String,
      let tokenizer = manifest["tokenizer"] as? String
    else { return false }
    let tokens = (manifest["tokens"] as? String) ?? "tokens.txt"
    return fm.fileExists(atPath: activeURL.appendingPathComponent(encoder).path)
      && fm.fileExists(atPath: activeURL.appendingPathComponent(head).path)
      && fm.fileExists(atPath: activeURL.appendingPathComponent(tokenizer).path)
      && fm.fileExists(atPath: activeURL.appendingPathComponent(tokens).path)
  }

  /// Removes the on-disk pack (active + staging). Call after disposing the engine.
  func deleteInstalledPack() throws {
    guard fm.fileExists(atPath: rootURL.path) else { return }
    try fm.removeItem(at: rootURL)
  }

  func encoderURL() throws -> URL {
    let m = try requireManifest()
    let name = m["encoder"] as! String
    return activeURL.appendingPathComponent(name)
  }

  func headURL() throws -> URL {
    let m = try requireManifest()
    let name = m["pronunciationHead"] as! String
    return activeURL.appendingPathComponent(name)
  }

  func tokenizerModelURL() throws -> URL {
    let m = try requireManifest()
    let name = m["tokenizer"] as! String
    return activeURL.appendingPathComponent(name)
  }

  func tokensURL() throws -> URL {
    let m = try requireManifest()
    let name = (m["tokens"] as? String) ?? "tokens.txt"
    return activeURL.appendingPathComponent(name)
  }

  /// Encoder API described by the active `model_manifest.json`. Switching
  /// DIY ↔ official (or any future CoreML variant) is done by publishing a
  /// different pack + manifest via Cloudflare catalog — no Swift rebuild.
  ///
  /// Manifest keys:
  /// - `"encoderApi": "single_function_fixed"` + `"encoderFixedT": Int` → DIY
  /// - `"encoderApi": "multifunction"` (or absent) + optional `"encoderBuckets":
  ///   [Int,…]` → official-style multifunction (default buckets =
  ///   `MelFrontend.defaultOfficialBuckets` when the array is omitted)
  /// - optional `"encoderFunctionPrefix": "predict_T"` (default) for
  ///   multifunction entry-point names
  func encoderApi() -> EncoderApi {
    guard let m = readManifest() else {
      return .multifunction(buckets: MelFrontend.defaultOfficialBuckets)
    }
    if (m["encoderApi"] as? String) == "single_function_fixed" {
      let fixedT = (m["encoderFixedT"] as? Int)
        ?? (m["encoderFixedT"] as? NSNumber)?.intValue
        ?? 4800
      return .singleFunctionFixedLength(t: fixedT)
    }
    let buckets = Self.parseEncoderBuckets(m) ?? MelFrontend.defaultOfficialBuckets
    return .multifunction(buckets: buckets)
  }

  /// Prefix for multifunction CoreML entry points (`predict_T` + bucket →
  /// `predict_T800`). Overridable via manifest for future packs.
  func encoderFunctionPrefix() -> String {
    guard let m = readManifest(),
          let prefix = m["encoderFunctionPrefix"] as? String,
          !prefix.isEmpty
    else { return "predict_T" }
    return prefix
  }

  /// Active pack version string from `model_manifest.json` (e.g. `1.2.0`).
  func activeManifestVersion() -> String {
    (readManifest()?["version"] as? String) ?? "unknown"
  }

  /// SHA-256 of the active encoder `weight.bin` as recorded in the manifest
  /// (not recomputed). Empty if missing.
  func activeEncoderSha256() -> String {
    guard let sha = readManifest()?["sha256"] as? [String: Any] else { return "" }
    return (sha["encoder"] as? String) ?? ""
  }

  /// Human-readable encoder API for logs.
  func activeEncoderApiLabel() -> String {
    switch encoderApi() {
    case .multifunction(let buckets):
      return "multifunction buckets=\(buckets)"
    case .singleFunctionFixedLength(let t):
      return "single_function_fixed T=\(t)"
    }
  }

  /// Sorted ascending mel-time buckets from manifest, or `nil` if absent.
  private static func parseEncoderBuckets(_ m: [String: Any]) -> [Int]? {
    if let ints = m["encoderBuckets"] as? [Int], !ints.isEmpty {
      return ints.sorted()
    }
    if let nums = m["encoderBuckets"] as? [NSNumber], !nums.isEmpty {
      return nums.map(\.intValue).sorted()
    }
    // JSONSerialization sometimes yields [Any] of Int/NSNumber.
    if let any = m["encoderBuckets"] as? [Any], !any.isEmpty {
      let ints = any.compactMap { ($0 as? Int) ?? ($0 as? NSNumber)?.intValue }
      return ints.isEmpty ? nil : ints.sorted()
    }
    return nil
  }

  /// Copy a prepared directory (containing mlpackages + tokenizer + manifest) into active.
  func installFromDirectory(_ source: URL, progress: ((Double) -> Void)? = nil) throws {
    progress?(0.05)
    let staging = rootURL.appendingPathComponent("staging-\(UUID().uuidString)", isDirectory: true)
    try? fm.removeItem(at: staging)
    try fm.createDirectory(at: staging, withIntermediateDirectories: true)
    defer { try? fm.removeItem(at: staging) }

    guard fm.fileExists(atPath: source.path) else {
      throw TajweedNativeError(TajweedErrorCode.modelMissing, "Source directory missing.")
    }

    let contents = try fm.contentsOfDirectory(atPath: source.path)
    for (i, name) in contents.enumerated() {
      let from = source.appendingPathComponent(name)
      let to = staging.appendingPathComponent(name)
      try fm.copyItem(at: from, to: to)
      progress?(0.05 + 0.8 * Double(i + 1) / Double(max(contents.count, 1)))
    }

    // Require manifest or write a default one if packages are present.
    let manifestPath = staging.appendingPathComponent("model_manifest.json")
    if !fm.fileExists(atPath: manifestPath.path) {
      let encoder =
        contents.first(where: { $0.contains("offline-ane") && $0.hasSuffix(".mlpackage") })
        ?? contents.first(where: { $0.hasSuffix(".mlpackage") && !$0.contains("head") })
      let head =
        contents.first(where: { $0.contains("pronunciation-head") && $0.hasSuffix(".mlpackage") })
        ?? contents.first(where: { $0.contains("head") && $0.hasSuffix(".mlpackage") })
      guard let encoder, let head else {
        throw TajweedNativeError(
          TajweedErrorCode.modelDownloadFailed,
          "Could not locate encoder/head mlpackages."
        )
      }
      let manifest: [String: Any] = [
        "version": "1.0.0",
        "encoder": encoder,
        "pronunciationHead": head,
        "tokenizer": "tokenizer.model",
        "tokens": "tokens.txt",
        "sha256": [:],
        "minimumAppVersion": "1.0.0",
      ]
      let data = try JSONSerialization.data(withJSONObject: manifest, options: [.prettyPrinted])
      try data.write(to: manifestPath)
    }

    try verifyStaging(staging)

    try fm.createDirectory(at: rootURL, withIntermediateDirectories: true)
    let previous = rootURL.appendingPathComponent("previous", isDirectory: true)
    try? fm.removeItem(at: previous)
    if fm.fileExists(atPath: activeURL.path) {
      try fm.moveItem(at: activeURL, to: previous)
    }
    do {
      try fm.moveItem(at: staging, to: activeURL)
    } catch {
      if fm.fileExists(atPath: previous.path) {
        try? fm.moveItem(at: previous, to: activeURL)
      }
      throw TajweedNativeError(
        TajweedErrorCode.modelDownloadFailed,
        "Activation failed: \(error.localizedDescription)"
      )
    }
    try? fm.removeItem(at: previous)
    progress?(1.0)
  }

  /// Registers Tajweed as an asset with the shared, generic `AIAssetManager`
  /// (ADR-009) on first use. Idempotent — `register` is safe to call
  /// repeatedly, and `Void`-typed `static let`s in Swift only ever run once.
  private static let registerTajweedAsset: Void = {
    AIAssetManager.shared.register(TajweedAssetSync.shared)
    AIAssetManager.shared.catalogURL = TajweedAssetDistributionConfig.catalogURL
    AIAssetManager.shared.checkIntervalHours = TajweedAssetDistributionConfig.checkIntervalHours
  }()

  /// Installs / updates the active Tajweed pack via Cloudflare catalog (or a
  /// DEBUG Official/DIY override). `Documents/TajweedImport` still takes
  /// priority for manual QA. Release always uses production `catalog.json`.
  func ensureModel(progress: ((Double) -> Void)? = nil) throws {
    _ = ModelStore.registerTajweedAsset
    let assetId = TajweedAssetDistributionConfig.assetId

    TajweedDevModelOverride.applyToAssetManager()
    if TajweedDevModelOverride.isAllowed,
       TajweedDevModelOverride.consumePendingForceResync()
         || !TajweedDevModelOverride.activePackMatchesSelection(manifest: readManifest())
    {
      try forceReinstallFromCurrentCatalog(assetId: assetId, progress: progress)
      return
    }

    if isAvailable() {
      if AIAssetManager.shared.isCheckFresh(assetId: assetId) {
        progress?(1.0)
        return
      }
      // Offline-first: a failed/absent update check must never break an
      // already-working, already-verified installed model.
      try? AIAssetManager.shared.checkForUpdateAndInstallIfNeeded(assetId: assetId, progress: progress)
      progress?(1.0)
      return
    }
    // Optional debug path: shared app group / Documents/TajweedImport
    let importDir = fm.urls(for: .documentDirectory, in: .userDomainMask).first!
      .appendingPathComponent("TajweedImport", isDirectory: true)
    if fm.fileExists(atPath: importDir.path) {
      try installFromDirectory(importDir, progress: progress)
      return
    }
    do {
      try AIAssetManager.shared.performFirstInstall(assetId: assetId, progress: progress)
      return
    } catch let e as TajweedNativeError {
      throw e
    } catch {
      // Distribution not configured / unreachable — fall through.
    }
    throw TajweedNativeError(
      TajweedErrorCode.modelMissing,
      "Model pack not installed. Accept HF access to fastconformer-quran-coreml-offline, copy packages into Documents/TajweedImport (or use TajweedDebugRunner.install), then retry ensureModel."
    )
  }

  /// Wipe active pack + update state, then first-install from the current
  /// (possibly DEBUG-overridden) catalog. Enables Official↔DIY including
  /// version downgrade.
  func forceReinstallFromCurrentCatalog(
    assetId: String,
    progress: ((Double) -> Void)?
  ) throws {
    AIAssetManager.shared.clearUpdateState(assetId: assetId)
    let previous = rootURL.appendingPathComponent("previous", isDirectory: true)
    try? fm.removeItem(at: previous)
    if fm.fileExists(atPath: activeURL.path) {
      try? fm.moveItem(at: activeURL, to: previous)
    }
    do {
      try AIAssetManager.shared.performFirstInstall(assetId: assetId, progress: progress)
      try? fm.removeItem(at: previous)
    } catch {
      if fm.fileExists(atPath: previous.path) {
        try? fm.removeItem(at: activeURL)
        try? fm.moveItem(at: previous, to: activeURL)
      }
      throw error
    }
  }

  /// True when the on-disk active pack is DIY CoreML (`single_function_fixed`).
  func isDiyPackActive() -> Bool {
    (readManifest()?["encoderApi"] as? String) == "single_function_fixed"
  }

  /// Install / activate DIY CoreML v1.1.0 for session failover (Release-safe).
  /// Skips download when DIY is already active. Restores the normal catalog URL
  /// afterward so the next launch still polls production Official.
  func ensureDiyFailoverPack(progress: ((Double) -> Void)? = nil) throws {
    _ = ModelStore.registerTajweedAsset
    let assetId = TajweedAssetDistributionConfig.assetId

    if isAvailable(), isDiyPackActive() {
      progress?(1.0)
      return
    }

    guard let diyCatalog = TajweedEngineFailover.diyCatalogFileURL() else {
      throw TajweedNativeError(
        TajweedErrorCode.modelDownloadFailed,
        "Could not materialize DIY failover catalog."
      )
    }

    let previousCatalog = AIAssetManager.shared.catalogURL
    AIAssetManager.shared.catalogURL = diyCatalog
    defer {
      // Prefer DEBUG override catalog when allowed; else production Official.
      if TajweedDevModelOverride.isAllowed {
        TajweedDevModelOverride.applyToAssetManager()
      } else {
        AIAssetManager.shared.catalogURL = previousCatalog
          ?? TajweedAssetDistributionConfig.catalogURL
      }
    }

    NSLog("[TajweedFailover] installing DIY CoreML pack from failover catalog")
    try forceReinstallFromCurrentCatalog(assetId: assetId, progress: progress)
  }

  private func requireManifest() throws -> [String: Any] {
    guard let m = readManifest() else {
      throw TajweedNativeError(TajweedErrorCode.modelMissing, "No active model manifest.")
    }
    return m
  }

  private func readManifest() -> [String: Any]? {
    guard let data = try? Data(contentsOf: manifestURL),
          let obj = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
    else { return nil }
    return obj
  }

  private func verifyStaging(_ staging: URL) throws {
    guard let data = try? Data(contentsOf: staging.appendingPathComponent("model_manifest.json")),
          let manifest = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
          let encoder = manifest["encoder"] as? String,
          let head = manifest["pronunciationHead"] as? String,
          let tokenizer = manifest["tokenizer"] as? String
    else {
      throw TajweedNativeError(TajweedErrorCode.modelDownloadFailed, "Invalid staging manifest.")
    }
    let tokens = (manifest["tokens"] as? String) ?? "tokens.txt"
    for name in [encoder, head, tokenizer, tokens] {
      let path = staging.appendingPathComponent(name)
      guard fm.fileExists(atPath: path.path) else {
        throw TajweedNativeError(
          TajweedErrorCode.modelDownloadFailed,
          "Missing artifact: \(name)"
        )
      }
    }
    if let sha = manifest["sha256"] as? [String: String] {
      try verifySHA(staging: staging, name: encoder, expected: sha["encoder"])
      try verifySHA(staging: staging, name: head, expected: sha["pronunciationHead"])
      try verifySHA(staging: staging, name: tokenizer, expected: sha["tokenizer"])
    }
  }

  private func verifySHA(staging: URL, name: String, expected: String?) throws {
    guard let expected, !expected.isEmpty, expected != "PENDING_AFTER_HF_ACCESS" else { return }
    let url = staging.appendingPathComponent(name)
    // For directories (.mlpackage), hash the weight.bin if present.
    let fileURL: URL
    if (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true {
      let weight = url.appendingPathComponent("Data/com.apple.CoreML/weights/weight.bin")
      fileURL = fm.fileExists(atPath: weight.path) ? weight : url
    } else {
      fileURL = url
    }
    let data = try Data(contentsOf: fileURL)
    let digest = SHA256.hash(data: data)
    let hex = digest.map { String(format: "%02x", $0) }.joined()
    if hex != expected.lowercased() {
      throw TajweedNativeError(
        TajweedErrorCode.modelDownloadFailed,
        "SHA-256 mismatch for \(name)"
      )
    }
  }
}
