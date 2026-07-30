import Foundation

/// A single downloadable AI/media asset registered with `AIAssetManager`
/// (ADR-009). Implementations own their manifest shape and their own final
/// verify/activate/rollback step; `AIAssetManager` and the rest of
/// `AssetDownload/` never know what a "tajweed model", "qari audio pack", or
/// "translation pack" actually contains — that knowledge lives entirely in the
/// plugin. This is what keeps the downloader framework a truly generic,
/// reusable AI Asset Manager rather than something hard-coded to Tajweed.
protocol AIAssetPlugin: AnyObject {
  /// Stable id — MUST match the `packId` used for this asset's entry in the
  /// shared `catalog.json`.
  var assetId: String { get }

  /// Free-form category, e.g. `"tajweed_model"`, `"qari_audio"`,
  /// `"translation_pack"`, `"tafsir_pack"`. Not interpreted by the framework;
  /// reserved for future UI grouping/filtering.
  var kind: String { get }

  /// Directory this asset owns for its persisted sync state (last-checked
  /// timestamp) and download staging — typically the plugin's own storage
  /// root (e.g. Tajweed's `ModelStore.rootURL`), so everything for one asset
  /// lives together on disk and different assets never collide.
  var workingDirectory: URL { get }

  /// True when a previously verified version of this asset is currently
  /// active and usable without any network access.
  func isAvailable() -> Bool

  /// Turn this asset's own manifest shape into concrete files to download.
  /// The first returned spec's `expectedSizeBytes` is filled in by
  /// `AIAssetManager` from the catalog's `approxSizeBytes` when left `nil`.
  func fileSpecs(manifest: [String: Any], artifactBase: URL) throws -> [AssetDownloadManager.FileSpec]

  /// Perform this asset's own final verify + atomic activate (+ rollback on
  /// failure) from a fully-downloaded staging directory. Must throw — and
  /// leave any previously active version untouched — on any integrity
  /// failure.
  func install(stagingDirectory: URL, manifestJSON: [String: Any], progress: ((Double) -> Void)?) throws
}
