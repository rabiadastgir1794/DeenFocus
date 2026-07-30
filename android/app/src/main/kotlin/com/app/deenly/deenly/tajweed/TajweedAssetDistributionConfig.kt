package com.rnr.deenfocus.tajweed

/**
 * Production model-distribution config (ADR-008/ADR-009). Points at the real
 * Cloudflare R2 public bucket URL for `catalog.json` — `TajweedAssetSync` /
 * `AIAssetManager` are otherwise unmodified; this is the only switch that turns
 * the previously-inert network path on. Set back to `null` to fully disable
 * network downloads again (falls back to adb-pushed `TajweedImport` or
 * `MODEL_MISSING`, exactly as before this was configured).
 *
 * `var` (not `val`) solely so JVM unit tests can null this out for the
 * duration of a test (see `TajweedAssetSyncTest`/`TajweedEngineRobolectricTest`
 * `@Before`/`@After`) — without that, any test that calls the real
 * `ModelStore.ensureModel()` would make a genuine network call to production
 * Cloudflare R2 during `./gradlew testDebugUnitTest`, which is both slow and
 * non-deterministic in CI/sandboxed environments. Production call sites only
 * ever read this value; nothing in production code ever writes to it.
 */
object TajweedAssetDistributionConfig {
    var catalogUrl: String? = "https://pub-470cb85af0ad4c5f92edb5094b8a7dbb.r2.dev/catalog.json"

    /**
     * Also the `assetId` this pack registers itself under with
     * [com.rnr.deenfocus.assetdownload.AIAssetManager] (ADR-009) — must
     * match its `packId` entry in the shared `catalog.json`.
     */
    const val ASSET_ID = "hafs-en-v1"
    const val CHECK_INTERVAL_HOURS = 24.0
}
