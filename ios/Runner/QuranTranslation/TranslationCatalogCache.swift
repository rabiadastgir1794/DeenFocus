import Foundation

/// Production translation-distribution config (ADR-009). Same shared
/// `catalog.json` as Tajweed — translation packs are discovered by
/// `kind == "translation_pack"` and `language`, not hardcoded in the app.
enum TranslationAssetDistributionConfig {
  static var catalogURL: URL? = URL(
    string: "https://pub-470cb85af0ad4c5f92edb5094b8a7dbb.r2.dev/catalog.json"
  )
  static let checkIntervalHours: Double = 24
  static let translationKind = "translation_pack"
}

/// One row from `catalog.json` for a downloadable Quran translation.
struct TranslationCatalogEntry: Equatable {
  let packId: String
  let language: String
  let displayName: String?
  let latestVersion: String
  /// Platform-specific approximate download size from catalog `approxSizeBytes.ios`.
  let approxSizeBytes: Int64?
}

/// Cached shared `catalog.json` with 24h freshness (mirrors AIAssetManager cadence).
final class TranslationCatalogCache {
  static let shared = TranslationCatalogCache()

  private let fetcher = AssetManifestFetcher()
  private let fm = FileManager.default
  private let lock = NSLock()

  private struct CachedCatalog: Codable {
    var fetchedAt: TimeInterval
    var catalog: AssetCatalog
  }

  private var rootURL: URL {
    let base = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    return base.appendingPathComponent("QuranTranslations", isDirectory: true)
  }

  private var cacheFileURL: URL {
    rootURL.appendingPathComponent("catalog_cache.json")
  }

  /// Returns cached catalog when fresh; otherwise fetches and persists.
  func catalog(forceRefresh: Bool = false) throws -> AssetCatalog {
    lock.lock()
    defer { lock.unlock() }

    if !forceRefresh, let cached = readCache(), isFresh(cached.fetchedAt) {
      return cached.catalog
    }
    guard let url = TranslationAssetDistributionConfig.catalogURL else {
      if let cached = readCache() { return cached.catalog }
      throw AssetDownloadError.invalidManifest("Translation catalog URL not configured.")
    }
    let fetched = try fetcher.fetchCatalog(url: url)
    writeCache(CachedCatalog(fetchedAt: Date().timeIntervalSince1970, catalog: fetched))
    return fetched
  }

  func translationEntries(forceRefresh: Bool = false) throws -> [TranslationCatalogEntry] {
    try translationEntries(in: catalog(forceRefresh: forceRefresh))
  }

  func translationEntries(in catalog: AssetCatalog) -> [TranslationCatalogEntry] {
    catalog.packs.compactMap { entry in
      guard entry.kind == TranslationAssetDistributionConfig.translationKind,
        let lang = entry.language, !lang.isEmpty
      else { return nil }
      return TranslationCatalogEntry(
        packId: entry.packId,
        language: lang,
        displayName: entry.displayName,
        latestVersion: entry.latestVersion,
        approxSizeBytes: entry.approxSizeBytes?["ios"]
      )
    }
  }

  func entry(forLanguage languageCode: String, forceRefresh: Bool = false) throws -> TranslationCatalogEntry? {
    try translationEntries(forceRefresh: forceRefresh).first { $0.language == languageCode }
  }

  func entry(forPackId packId: String, in catalog: AssetCatalog) -> TranslationCatalogEntry? {
    translationEntries(in: catalog).first { $0.packId == packId }
  }

  private func isFresh(_ fetchedAt: TimeInterval) -> Bool {
    let elapsedHours = (Date().timeIntervalSince1970 - fetchedAt) / 3600
    return elapsedHours < TranslationAssetDistributionConfig.checkIntervalHours
  }

  private func readCache() -> CachedCatalog? {
    guard let data = try? Data(contentsOf: cacheFileURL) else { return nil }
    return try? JSONDecoder().decode(CachedCatalog.self, from: data)
  }

  private func writeCache(_ cached: CachedCatalog) {
    try? fm.createDirectory(at: rootURL, withIntermediateDirectories: true)
    guard let data = try? JSONEncoder().encode(cached) else { return }
    try? data.write(to: cacheFileURL, options: .atomic)
  }
}
