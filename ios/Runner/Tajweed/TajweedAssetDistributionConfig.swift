import Foundation

/// Production model-distribution config (ADR-008/ADR-009). Points at the real
/// Cloudflare R2 public bucket's `catalog.json` — mirrors Android's
/// `TajweedAssetDistributionConfig.kt`, which is the "only switch that turns
/// the previously-inert network path on" (same wording applies here). The
/// `ios` manifest currently served from this catalog is the DIY
/// self-generated CoreML pack (see
/// `memory/features/tajweed/diy-coreml-nemo-production-attempt-2026-07-30.md`
/// and `memory/features/tajweed/ios-asset-distribution-migration-2026-07-30.md`),
/// not the official ANE-optimized package. Set back to `nil` to fully disable
/// network downloads again (falls back to Xcode-copied `TajweedImport` or
/// `MODEL_MISSING`, exactly as before this was configured).
///
/// `var` (not `let`) solely so XCTest can null this out for the duration of a
/// test (see `RunnerTests`/`TajweedAssetSyncTests` `setUp`/`tearDown`) —
/// without that, any test that calls the real `ModelStore.shared.ensureModel()`
/// would make a genuine network call to production Cloudflare R2 during
/// `xcodebuild test`, which is both slow and non-deterministic in CI/sandboxed
/// environments. Production call sites only ever read this value; nothing in
/// production code ever writes to it.
enum TajweedAssetDistributionConfig {
  static var catalogURL: URL? = URL(string: "https://pub-470cb85af0ad4c5f92edb5094b8a7dbb.r2.dev/catalog.json")
  /// Also the `assetId` this pack registers itself under with `AIAssetManager`
  /// (ADR-009) — must match its `packId` entry in the shared `catalog.json`.
  static let assetId = "hafs-en-v1"
  static let checkIntervalHours: Double = 24
}
