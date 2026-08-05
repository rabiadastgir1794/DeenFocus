import Foundation

/// On-disk lifecycle for one downloaded Quran translation language pack.
final class TranslationStore {
  static let shared = TranslationStore()

  private let fm = FileManager.default
  private let installer = AssetAtomicInstaller()

  private var rootURL: URL {
    let base = fm.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
    return base.appendingPathComponent("QuranTranslations", isDirectory: true)
  }

  func languageRoot(_ languageCode: String) -> URL {
    rootURL.appendingPathComponent(languageCode, isDirectory: true)
  }

  func activeURL(_ languageCode: String) -> URL {
    languageRoot(languageCode).appendingPathComponent("active", isDirectory: true)
  }

  func translationFileURL(_ languageCode: String) -> URL {
    activeURL(languageCode).appendingPathComponent("translation.json")
  }

  func isAvailable(_ languageCode: String) -> Bool {
    fm.fileExists(atPath: translationFileURL(languageCode).path)
  }

  /// SHA-256 verify + atomic staging → active (keeps prior version in
  /// `previous/` until success). All downloaded languages are retained on disk.
  func installFromDirectory(
    _ stagingDirectory: URL,
    languageCode: String,
    manifest: [String: Any]
  ) throws {
    let translationName = (manifest["translation"] as? String) ?? "translation.json"
    let stagingFile = stagingDirectory.appendingPathComponent(translationName)
    guard fm.fileExists(atPath: stagingFile.path) else {
      throw AssetDownloadError.invalidManifest("Missing \(translationName) in staging.")
    }
    if let shaMap = manifest["sha256"] as? [String: Any],
      let expected = shaMap["translation"] as? String
    {
      try AssetIntegrityVerifier.verify(fileURL: stagingFile, expectedHex: expected)
    }

    let active = activeURL(languageCode)
    let previous = languageRoot(languageCode).appendingPathComponent("previous", isDirectory: true)

    let tempActive = languageRoot(languageCode)
      .appendingPathComponent("staging-active-\(UUID().uuidString)", isDirectory: true)
    try fm.createDirectory(at: tempActive, withIntermediateDirectories: true)
    try fm.copyItem(at: stagingFile, to: tempActive.appendingPathComponent("translation.json"))
    if let manifestData = try? JSONSerialization.data(withJSONObject: manifest, options: [.prettyPrinted]) {
      try manifestData.write(to: tempActive.appendingPathComponent("translation_manifest.json"))
    }

    try installer.activate(stagingDir: tempActive, activeDir: active, previousDir: previous)
  }

  private static let registerSharedCatalog: Void = {
    if AIAssetManager.shared.catalogURL == nil {
      AIAssetManager.shared.catalogURL = TranslationAssetDistributionConfig.catalogURL
    }
  }()

  func ensureTranslation(
    languageCode: String,
    progress: ((Double) -> Void)? = nil
  ) throws {
    _ = TranslationStore.registerSharedCatalog
    guard let entry = try TranslationCatalogCache.shared.entry(forLanguage: languageCode) else {
      throw AssetDownloadError.invalidManifest(
        "No translation_pack in catalog for language \"\(languageCode)\"."
      )
    }
    let plugin = TranslationAssetSync(assetId: entry.packId, languageCode: languageCode)
    AIAssetManager.shared.register(plugin)
    try AIAssetManager.shared.ensureAsset(assetId: entry.packId, progress: progress)
  }
}
