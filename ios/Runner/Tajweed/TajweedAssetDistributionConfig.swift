import Foundation

/// Production model-distribution config (ADR-008/ADR-009). Points at the real
/// Cloudflare R2 public bucket's `catalog.json` — mirrors Android's
/// `TajweedAssetDistributionConfig.kt`, which is the "only switch that turns
/// the previously-inert network path on" (same wording applies here).
///
/// iOS supports a **dual CoreML architecture**: DIY (`single_function_fixed`)
/// and official HF multifunction packs are both first-class. The active pack
/// is chosen by the remote catalog/manifest in Release builds. **Production
/// default (2026-08-03):** Official HF CoreML `ios/tajweed/v1.2.0/` via
/// `catalog.json`. **DEBUG** builds can override Official / DIY / catalog via
/// Settings → iOS CoreML override without changing the live catalog. DIY
/// `ios/tajweed/v1.1.0/` remains on R2 for rollback. See
/// `memory/features/tajweed/ios-dual-coreml-architecture-2026-07-30.md`.
/// Set `catalogURL` back to `nil` to fully disable network downloads again
/// (falls back to Xcode-copied `TajweedImport` or `MODEL_MISSING`).
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
