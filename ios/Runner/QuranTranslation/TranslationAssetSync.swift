import Foundation

/// Quran translation `AIAssetPlugin` (ADR-009). Registered lazily per catalog
/// `packId`; multiple languages coexist on disk (en, ur, fr, …).
final class TranslationAssetSync: AIAssetPlugin {
  let assetId: String
  let languageCode: String
  let kind = TranslationAssetDistributionConfig.translationKind

  init(assetId: String, languageCode: String) {
    self.assetId = assetId
    self.languageCode = languageCode
  }

  var workingDirectory: URL {
    TranslationStore.shared.languageRoot(languageCode)
  }

  func isAvailable() -> Bool {
    TranslationStore.shared.isAvailable(languageCode)
  }

  func fileSpecs(manifest: [String: Any], artifactBase: URL) throws -> [AssetDownloadManager.FileSpec] {
    guard let name = manifest["translation"] as? String else {
      throw AssetDownloadError.invalidManifest("Invalid translation manifest: missing \"translation\" key.")
    }
    return [
      AssetDownloadManager.FileSpec(
        url: artifactBase.appendingPathComponent(name),
        relativePath: name
      ),
    ]
  }

  func install(
    stagingDirectory: URL,
    manifestJSON: [String: Any],
    progress: ((Double) -> Void)? = nil
  ) throws {
    try TranslationStore.shared.installFromDirectory(
      stagingDirectory,
      languageCode: languageCode,
      manifest: manifestJSON
    )
    progress?(1.0)
  }
}
