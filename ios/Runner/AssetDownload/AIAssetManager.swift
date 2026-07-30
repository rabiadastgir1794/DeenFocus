import Foundation

/// Generic, multi-asset orchestrator built on top of the AssetDownload
/// framework (ADR-008 / ADR-009 "AI Asset Manager"). One shared `catalog.json`
/// can list any number of independently versioned assets — Tajweed AI models,
/// Qari audio packs, translation packs, tafsir packs, future AI models — each
/// registering its own `AIAssetPlugin`. This class owns: catalog fetch,
/// per-asset "last checked" freshness, version comparison, staging-directory
/// lifecycle, and progress weighting. It knows nothing about what any
/// registered asset actually contains — all of that lives in the asset's own
/// plugin. Tajweed (`TajweedAssetSync`, see `ios/Runner/Tajweed/`) is the
/// first asset registered with this manager.
final class AIAssetManager {
  static let shared = AIAssetManager()

  /// Root HTTPS URL of the shared `catalog.json`. `nil` until infrastructure
  /// is provisioned — every method below is then fully inert for assets that
  /// rely on it (never touches the network).
  var catalogURL: URL?
  var checkIntervalHours: Double = 24

  private let platformKey = "ios"
  private let fetcher: AssetManifestFetcher
  private let downloader: AssetDownloadManager
  private let fm = FileManager.default
  private let lock = NSLock()
  private var plugins: [String: AIAssetPlugin] = [:]

  init(
    fetcher: AssetManifestFetcher = AssetManifestFetcher(),
    downloader: AssetDownloadManager = AssetDownloadManager()
  ) {
    self.fetcher = fetcher
    self.downloader = downloader
  }

  /// Registers (or replaces) the plugin responsible for `plugin.assetId`.
  /// Safe to call multiple times — e.g. idempotent lazy registration at first
  /// use from a consumer's own `ensureModel()`-style entry point.
  func register(_ plugin: AIAssetPlugin) {
    lock.lock()
    defer { lock.unlock() }
    plugins[plugin.assetId] = plugin
  }

  func plugin(for assetId: String) -> AIAssetPlugin? {
    lock.lock()
    defer { lock.unlock() }
    return plugins[assetId]
  }

  private struct UpdateState: Codable {
    var lastCheckedAt: TimeInterval
    var installedVersion: String
  }

  private func stateURL(_ plugin: AIAssetPlugin) -> URL {
    plugin.workingDirectory.appendingPathComponent("update_state.json")
  }

  private func readState(_ plugin: AIAssetPlugin) -> UpdateState? {
    guard let data = try? Data(contentsOf: stateURL(plugin)) else { return nil }
    return try? JSONDecoder().decode(UpdateState.self, from: data)
  }

  private func writeState(_ plugin: AIAssetPlugin, _ state: UpdateState) {
    guard let data = try? JSONEncoder().encode(state) else { return }
    try? fm.createDirectory(at: plugin.workingDirectory, withIntermediateDirectories: true)
    try? data.write(to: stateURL(plugin), options: .atomic)
  }

  /// True when the last successful catalog check for `assetId` happened
  /// within `intervalHours` — gates "don't hit the network every launch, only
  /// check a tiny manifest at most once a day."
  func isCheckFresh(assetId: String, intervalHours: Double? = nil) -> Bool {
    guard let plugin = plugin(for: assetId), let state = readState(plugin) else { return false }
    let elapsedHours = (Date().timeIntervalSince1970 - state.lastCheckedAt) / 3600
    return elapsedHours < (intervalHours ?? checkIntervalHours)
  }

  /// Called when nothing is installed for `assetId` yet. Throws a generic
  /// `AssetDownloadError` — never a feature-specific error type — if the
  /// asset isn't registered, distribution isn't configured, or the network or
  /// verification fails. Callers translate that at their own adapter boundary
  /// (see `ModelStore.ensureModel()`), exactly as before this refactor.
  func performFirstInstall(
    assetId: String,
    catalogURL overrideURL: URL? = nil,
    progress: ((Double) -> Void)? = nil
  ) throws {
    guard let plugin = plugin(for: assetId) else {
      throw AssetDownloadError.invalidManifest("No AIAssetPlugin registered for assetId \(assetId).")
    }
    guard let url = overrideURL ?? catalogURL else {
      throw AssetDownloadError.invalidManifest("Asset distribution not configured for \(assetId).")
    }
    try syncFromCatalog(plugin: plugin, catalogURL: url, forceInstall: true, progress: progress)
  }

  /// Called when a verified asset is already active. Best-effort only: any
  /// failure here must never affect an already-working install — callers
  /// should swallow (not surface) errors from this method.
  func checkForUpdateAndInstallIfNeeded(
    assetId: String,
    catalogURL overrideURL: URL? = nil,
    progress: ((Double) -> Void)? = nil
  ) throws {
    guard let plugin = plugin(for: assetId) else { return }
    guard let url = overrideURL ?? catalogURL else { return }
    try syncFromCatalog(plugin: plugin, catalogURL: url, forceInstall: false, progress: progress)
  }

  /// High-level convenience: no-op if already available and the catalog check
  /// is still fresh, best-effort update check if stale, full first-install if
  /// nothing is active yet. This is what any registered asset's own
  /// `ensureXyz()` entry point should call.
  func ensureAsset(
    assetId: String,
    catalogURL overrideURL: URL? = nil,
    progress: ((Double) -> Void)? = nil
  ) throws {
    guard let plugin = plugin(for: assetId) else {
      throw AssetDownloadError.invalidManifest("No AIAssetPlugin registered for assetId \(assetId).")
    }
    if plugin.isAvailable() {
      if isCheckFresh(assetId: assetId) {
        progress?(1.0)
        return
      }
      try? checkForUpdateAndInstallIfNeeded(assetId: assetId, catalogURL: overrideURL, progress: progress)
      progress?(1.0)
      return
    }
    try performFirstInstall(assetId: assetId, catalogURL: overrideURL, progress: progress)
  }

  private func syncFromCatalog(
    plugin: AIAssetPlugin,
    catalogURL: URL,
    forceInstall: Bool,
    progress: ((Double) -> Void)?
  ) throws {
    let notifier = AssetProgressNotifier(
      phaseWeights: [("catalog", 0.05), ("manifest", 0.05), ("download", 0.85), ("install", 0.05)],
      onProgress: { p in progress?(p) }
    )

    let catalog: AssetCatalog
    do {
      catalog = try fetcher.fetchCatalog(url: catalogURL)
      notifier.update("catalog", fraction: 1.0)
    } catch {
      if forceInstall { throw error }
      return  // Offline-first: keep using the already-installed, already-verified asset.
    }

    // Exact assetId match only — no "fall back to any default entry". That
    // Tajweed-only convenience would be unsafe now that one shared catalog
    // can list many unrelated assets (Qari packs, translations, ...).
    guard let entry = catalog.entry(forPackId: plugin.assetId) else {
      if forceInstall {
        throw AssetDownloadError.invalidManifest("Catalog has no entry for assetId \(plugin.assetId).")
      }
      return
    }
    guard let manifestURLString = entry.manifestUrl[platformKey],
      let manifestURL = URL(string: manifestURLString)
    else {
      if forceInstall {
        throw AssetDownloadError.invalidManifest(
          "Catalog entry \(plugin.assetId) has no manifest for platform \(platformKey)."
        )
      }
      return
    }

    if !forceInstall, let installed = readState(plugin),
      !isNewerVersion(entry.latestVersion, than: installed.installedVersion)
    {
      // Same version already active — just record that we checked, no download.
      writeState(
        plugin,
        UpdateState(lastCheckedAt: Date().timeIntervalSince1970, installedVersion: installed.installedVersion)
      )
      return
    }

    let manifestJSON: [String: Any]
    do {
      manifestJSON = try fetcher.fetchManifestJSON(url: manifestURL)
      notifier.update("manifest", fraction: 1.0)
    } catch {
      if forceInstall { throw error }
      return
    }

    let artifactBase =
      (manifestJSON["artifactBaseUrl"] as? String).flatMap(URL.init) ?? manifestURL.deletingLastPathComponent()
    var specs = try plugin.fileSpecs(manifest: manifestJSON, artifactBase: artifactBase)
    // Attach the catalog's approximate total size to the first file only (if
    // the plugin didn't already), so AssetDownloadManager's pre-flight
    // free-space check covers the whole asset without needing a per-file
    // size breakdown in the manifest.
    if let approxTotalSize = entry.approxSizeBytes?[platformKey], let first = specs.first,
      first.expectedSizeBytes == nil
    {
      specs[0] = AssetDownloadManager.FileSpec(
        url: first.url,
        relativePath: first.relativePath,
        expectedSizeBytes: approxTotalSize
      )
    }

    // Stable (non-UUID) staging path so an interrupted download resumes
    // correctly even after an app relaunch — see AssetDownloadManager's
    // `.part`-file resume.
    let stagingDir =
      plugin.workingDirectory
      .appendingPathComponent("download-staging", isDirectory: true)
      .appendingPathComponent("\(plugin.assetId)-\(entry.latestVersion)", isDirectory: true)

    try downloader.downloadFiles(specs, into: stagingDir) { p in notifier.update("download", fraction: p) }
    try plugin.install(stagingDirectory: stagingDir, manifestJSON: manifestJSON) { p in
      notifier.update("install", fraction: p)
    }
    try? fm.removeItem(at: stagingDir)

    writeState(
      plugin,
      UpdateState(lastCheckedAt: Date().timeIntervalSince1970, installedVersion: entry.latestVersion)
    )
  }

  private func isNewerVersion(_ candidate: String, than current: String) -> Bool {
    func parts(_ v: String) -> [Int] { v.split(separator: ".").map { Int($0) ?? 0 } }
    let c = parts(candidate)
    let k = parts(current)
    for i in 0..<max(c.count, k.count) {
      let a = i < c.count ? c[i] : 0
      let b = i < k.count ? k[i] : 0
      if a != b { return a > b }
    }
    return false
  }
}
