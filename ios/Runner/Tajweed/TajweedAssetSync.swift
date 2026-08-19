import Foundation

/// The Tajweed-specific `AIAssetPlugin` (ADR-009) registered with the shared,
/// generic `AIAssetManager` (ADR-008 framework). Tajweed is the first asset
/// registered with the AI Asset Manager; future assets (Qari audio packs,
/// translation packs, tafsir packs, ...) register their own plugin the same
/// way and reuse the exact same download/verify/rollback engine. All
/// Tajweed-aware glue lives here — manifest key names (`encoder`/
/// `pronunciationHead`/`tokenizer`/`tokens`/`sha256`) and delegating final
/// verify/activate to `ModelStore.installFromDirectory` (unmodified). Neither
/// `AIAssetManager` nor anything under `AssetDownload/` imports or references
/// this file, or anything Tajweed/CoreML/ASR-related — keeping the downloader
/// fully isolated from the AI inference engine, per the reviewer's explicit
/// requirement.
final class TajweedAssetSync: AIAssetPlugin {
  static let shared = TajweedAssetSync()

  let assetId = TajweedAssetDistributionConfig.assetId
  let kind = "tajweed_model"

  var workingDirectory: URL { ModelStore.shared.rootURL }

  func isAvailable() -> Bool {
    ModelStore.shared.isAvailable()
  }

  func fileSpecs(manifest: [String: Any], artifactBase: URL) throws -> [AssetDownloadManager.FileSpec] {
    guard
      let encoderName = manifest["encoder"] as? String,
      let headName = manifest["pronunciationHead"] as? String,
      let tokenizerName = manifest["tokenizer"] as? String
    else {
      throw TajweedNativeError(TajweedErrorCode.modelDownloadFailed, "Invalid remote manifest.")
    }
    let tokensName = (manifest["tokens"] as? String) ?? "tokens.txt"
    var specs: [AssetDownloadManager.FileSpec] = []
    specs.append(contentsOf: bundleFileSpecs(name: encoderName, filesKey: "encoderFiles", manifest: manifest, artifactBase: artifactBase))
    specs.append(contentsOf: bundleFileSpecs(name: headName, filesKey: "pronunciationHeadFiles", manifest: manifest, artifactBase: artifactBase))
    specs.append(AssetDownloadManager.FileSpec(url: artifactBase.appendingPathComponent(tokenizerName), relativePath: tokenizerName))
    specs.append(AssetDownloadManager.FileSpec(url: artifactBase.appendingPathComponent(tokensName), relativePath: tokensName))
    return specs
  }

  /// A named artifact is normally a single remote file (e.g. Android's
  /// `.onnx` files, or an official iOS multifunction `.mlpackage` zipped by
  /// the release pipeline). A CoreML `.mlpackage` is actually a *directory*
  /// bundle (`Manifest.json`, `Data/com.apple.CoreML/model.mlmodel`,
  /// `Data/com.apple.CoreML/weights/weight.bin`, ...) — the DIY
  /// self-generated pack (see `memory/features/tajweed/`) ships it unzipped
  /// and lists its internal member paths under `"<name>Files"` in the
  /// manifest so the generic, single-file-per-artifact `AssetDownloadManager`
  /// can fetch each member into the right nested `relativePath` with zero
  /// changes to the generic downloader. Absent that key, `name` is fetched as
  /// one plain file exactly as before.
  private func bundleFileSpecs(
    name: String, filesKey: String, manifest: [String: Any], artifactBase: URL
  ) -> [AssetDownloadManager.FileSpec] {
    guard let members = manifest[filesKey] as? [String], !members.isEmpty else {
      return [AssetDownloadManager.FileSpec(url: artifactBase.appendingPathComponent(name), relativePath: name)]
    }
    return members.map { member in
      AssetDownloadManager.FileSpec(
        url: artifactBase.appendingPathComponent(name).appendingPathComponent(member),
        relativePath: "\(name)/\(member)"
      )
    }
  }

  func install(stagingDirectory: URL, manifestJSON: [String: Any], progress: ((Double) -> Void)?) throws {
    // Write the manifest into staging so ModelStore's OWN (unmodified)
    // verifyStaging/verifySHA performs the real, authoritative integrity +
    // shape check before any activation — this adapter never bypasses that gate.
    let manifestData = try JSONSerialization.data(withJSONObject: manifestJSON, options: [.prettyPrinted])
    try manifestData.write(to: stagingDirectory.appendingPathComponent("model_manifest.json"))
    try ModelStore.shared.installFromDirectory(stagingDirectory, progress: progress)
  }
}
