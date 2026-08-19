# ADR-009 — Generic AI Asset Manager (multi-asset downloader, Cloudflare R2 host)

**Date:** 2026-07-29   **Status:** Accepted — implemented and tested on both platforms.
**Not yet activated in production**: no real Cloudflare R2 bucket exists yet; both
platforms' `catalogUrl` is `nil`/`null`, so every asset plugin's `ensureX()` call is
fully inert (falls through to its existing local/`MISSING` fallback). See
`memory/current-state.md` for the overall Tajweed AI freeze this sits inside of.
**Supersedes/extends:** `ADR-008-tajweed-production-model-distribution.md` — the
"Native Asset Downloader" framework ADR-008 designed and implemented
(`AssetDownload{Error,CatalogModels,Transport,ManifestFetcher,DownloadManager,
IntegrityVerifier,RollbackManager,AtomicInstaller,ProgressNotifier}` on both
platforms) is **unchanged** by this ADR. This ADR adds one new layer *above* it
(`AIAssetManager` + `AIAssetPlugin`) so that framework can be shared, unmodified, by
more than one kind of downloadable asset — Tajweed AI models today, Qari audio /
translation / tafsir packs tomorrow — instead of every future asset type growing its
own copy-pasted "ensureX()" orchestration.

## Problem

ADR-008 built a solid generic *download engine* (resumable, retried, verified,
atomically-activated, rollback-capable) but its only consumer was a
Tajweed-shaped adapter (`TajweedAssetSync`) hand-wired directly into
`ModelStore.ensureModel()`. As DeenFocus grows (Qari audio packs, offline
translation packs, offline tafsir packs, future AI models beyond Tajweed), each
new asset type would otherwise need its own copy of:

- a per-asset "last checked at" freshness clock and 24h cache,
- catalog fetch + version-comparison + staging-directory lifecycle,
- the "isAvailable? fresh? first-install vs. best-effort update-check" state
  machine ADR-008 §2 already specified once for Tajweed.

That's exactly the kind of duplicated download logic the reviewer explicitly asked
to avoid: *"Instead of having separate systems: Tajweed Downloader / Qari Downloader
/ Translation Downloader, use one system: AI Asset Manager."*

## Decision

Insert one new, generic orchestrator — **`AIAssetManager`** — between the ADR-008
download engine and every asset-specific adapter. `AIAssetManager` owns catalog
fetch, freshness/version bookkeeping, and staging-directory lifecycle; it knows
**nothing** about what any given asset actually contains. Every asset type
(Tajweed, future Qari/translation/tafsir packs, future AI models) registers one
**`AIAssetPlugin`** implementation that owns exactly the parts that differ:

```
AIAssetManager (generic, shared, one instance app-wide)
    ├── register(plugin: AIAssetPlugin)
    ├── ensureAsset(assetId) / performFirstInstall(assetId) / checkForUpdateAndInstallIfNeeded(assetId)
    └── plugins:
          ├── TajweedAssetSync         (assetId "hafs-en-v1",  kind "tajweed_model")
          ├── <future> QariAssetSync   (assetId "qari-alafasy", kind "qari_audio")
          ├── <future> TranslationSync (assetId "en-saheeh",    kind "translation_pack")
          └── <future> TafsirSync      (assetId "ibn-kathir-en",kind "tafsir_pack")
```

Each `AIAssetPlugin` implementation supplies:
1. `assetId` / `kind` / `workingDirectory` — identity + where its own state and
   staging live.
2. `isAvailable()` — is a previously verified version currently active.
3. `fileSpecs(manifest, artifactBase)` — turn *its own* manifest shape into
   `(url, relativePath)` pairs for the ADR-008 downloader. Different asset kinds
   can have completely different manifest shapes (Tajweed's fixed
   `encoder`/`pronunciationHead`/`tokenizer`/`tokens` keys vs. e.g. a Qari pack's
   `{"files": ["001.mp3", "002.mp3", ...]}` array) — `AIAssetManager` never
   inspects manifest contents itself, it only hands the whole parsed JSON to the
   plugin.
4. `install(stagingDir, manifestJson, progress)` — the asset's own final
   verify + atomic activate (+ rollback on failure). For Tajweed this delegates
   to the **unmodified** `ModelStore.installFromDirectory` (SHA-256 verify,
   atomic staging→active swap, `previous/` rollback) exactly as ADR-008 already
   specified.

This is a pure refactor of the ADR-008 Tajweed adapter into this shape — the
download engine, verify/activate/rollback logic, Flutter contract, MethodChannel/
EventChannel surface, and ADR-006/007 JSON schema are all **100% unchanged**.

## 1. Catalog / manifest schema v2 (additive, backward-compatible with ADR-008 v1)

One shared `catalog.json` now lists assets of *any* kind side by side. The only
schema addition versus ADR-008 §1 is an optional, free-form `"kind"` field per
entry — every other field is unchanged, and a `kind`-less entry (old Tajweed-only
catalog) still parses exactly as before.

```json
{
  "catalogVersion": 1,
  "updatedAt": "2026-07-29T00:00:00Z",
  "recommendedCheckIntervalHours": 24,
  "packs": [
    {
      "packId": "hafs-en-v1",
      "kind": "tajweed_model",
      "displayName": "Hafs (Arabic) + English feedback",
      "language": "en",
      "riwayah": "Hafs",
      "isDefault": true,
      "latestVersion": "1.0.0",
      "minimumAppVersion": "1.0.0",
      "manifestUrl": {
        "ios": "https://assets.deenfocus.app/tajweed/packs/hafs-en-v1/1.0.0/ios/model_manifest.json",
        "android": "https://assets.deenfocus.app/tajweed/packs/hafs-en-v1/1.0.0/android/model_manifest.json"
      },
      "approxSizeBytes": { "ios": 210000000, "android": 465000000 }
    },
    {
      "packId": "qari-alafasy",
      "kind": "qari_audio",
      "displayName": "Mishary Alafasy — full Quran",
      "isDefault": true,
      "latestVersion": "1.0.0",
      "manifestUrl": {
        "ios": "https://assets.deenfocus.app/qari/alafasy/1.0.0/manifest.json",
        "android": "https://assets.deenfocus.app/qari/alafasy/1.0.0/manifest.json"
      },
      "approxSizeBytes": { "ios": 850000000, "android": 850000000 }
    }
  ]
}
```

`kind` is **not interpreted by the framework** — `AIAssetManager` does exact
`packId`-match lookups only (see "Exact assetId matching" below); `kind` exists
purely as descriptive metadata for tooling/future UI (e.g. grouping a future
"Downloads" settings screen by asset type).

Per-asset `model_manifest.json` shape is entirely up to that asset's own plugin —
`AIAssetManager` only requires it to be a JSON object; Tajweed's manifest shape is
unchanged from ADR-008 §1. A future Qari pack manifest might instead look like:

```json
{
  "version": "1.0.0",
  "packId": "qari-alafasy",
  "artifactBaseUrl": "https://assets.deenfocus.app/qari/alafasy/1.0.0/",
  "files": ["001.mp3", "002.mp3", "...", "114.mp3"],
  "sha256": { "001.mp3": "<hex>", "002.mp3": "<hex>", "...": "..." }
}
```

— a shape only `QariAssetSync.fileSpecs()`/`.install()` (a future addition, not
built by this ADR) would ever need to understand.

### Exact assetId matching (both platforms)

`AIAssetManager`'s catalog lookup matches `packId` **exactly** against the
requesting plugin's `assetId` — there is intentionally no "fall back to
`isDefault: true`" behavior (that would have been fine for a Tajweed-only
catalog, but is unsafe now that one catalog can list unrelated asset kinds).
Covered by `testCatalogWithUnrelatedAssetEntryIsIgnored` (iOS) /
`catalogWithUnrelatedAssetEntry_isIgnored` (Android).

## 2. Hosting: Cloudflare R2

**Decision: self-host on Cloudflare R2** (not Firebase Storage — superseding the
placeholder examples in ADR-008 §1, which listed several vendor options before a
final choice was made). Rationale: S3-compatible API (works with the standard AWS
CLI / any S3 SDK, no vendor-specific SDK needed for uploads), zero egress fees
(large model/audio downloads never hit a per-GB egress bill), and trivial fronting
by Cloudflare's own CDN/cache via a custom domain.

`AssetTransport` on both platforms (`URLSessionAssetTransport` / iOS,
`HttpUrlConnectionAssetTransport` / Android) is a **plain HTTPS GET + `Range`
header** client with zero vendor-specific code — confirmed by re-reading both
implementations. Nothing about this hosting decision requires **any** change to
the native download engine; it is 100% a docs/tooling/config change.

### Bucket layout (same shape as ADR-008 §1, now multi-asset-aware)

```
<R2_BUCKET>/                                    (served via a custom domain, e.g. assets.deenfocus.app)
  catalog.json                                  ← shared across all asset kinds
  tajweed/
    packs/
      hafs-en-v1/
        1.0.0/
          ios/{model_manifest.json, fastconformer-quran-offline-ane.mlpackage/..., ...}
          android/{model_manifest.json, model_with_encoder.onnx, ...}
        1.1.0/
          ios/...
          android/...
  qari/                                          ← future, not built by this ADR
    alafasy/
      1.0.0/{manifest.json, 001.mp3, ..., 114.mp3}
  translations/                                  ← future
    en-saheeh/1.0.0/{manifest.json, translation.json}
  tafsir/                                        ← future
    ibn-kathir-en/1.0.0/{manifest.json, tafsir.json}
```

### R2 setup (one-time)

1. Create the bucket: `wrangler r2 bucket create deenfocus-assets` (or via the
   Cloudflare dashboard).
2. Expose it over HTTPS with a **custom domain** (recommended over the default
   `r2.dev` dev URL, which is rate-limited and unsuitable for production):
   Cloudflare dashboard → R2 → bucket → Settings → Custom Domains → add
   `assets.deenfocus.app` (proxied through Cloudflare, so it's CDN-cached and
   TLS-terminated for free).
3. Set a long `Cache-Control` header on immutable, versioned artifact files
   (`Cache-Control: public, max-age=31536000, immutable` — every artifact lives
   under a version-numbered path and is never overwritten in place, so this is
   safe) and a **short/no-cache** header on `catalog.json`
   (`Cache-Control: public, max-age=60` or `no-cache`) so a new release is
   discoverable promptly without needing a cache purge.
4. No bucket-level auth/signing needed for v1 (public read, same trust model as
   ADR-008's "SHA-256 integrity check replaces needing a private bucket" — a
   tampered file simply fails `verifyStaging`/`verifySHA` and is never
   activated). `catalogSignature`/per-manifest `signature` (Ed25519, reserved in
   ADR-008 §1) remain the future upgrade path if a stronger authenticity
   guarantee is ever required beyond integrity.

### Upload / release process

Any S3-compatible tool works against R2 (S3 API compatibility is the whole point
of choosing it). Using the AWS CLI configured with R2 credentials
(`~/.aws/credentials` profile pointed at the R2 S3 endpoint
`https://<ACCOUNT_ID>.r2.cloudflarestorage.com`):

```bash
# 1. Generate the per-platform model_manifest.json for a new version (see
#    tool/ai_assets/generate_manifest.py below) — computes sha256 for every
#    artifact automatically so a human never hand-types a hash.
python3 tool/ai_assets/generate_manifest.py \
  --spec tool/ai_assets/specs/hafs-en-v1-1.0.0-android.json \
  --out /tmp/release/hafs-en-v1/1.0.0/android/model_manifest.json

# 2. Upload the new version's artifacts (never overwrite an existing version
#    directory — versions are immutable once published).
aws s3 cp /tmp/release/tajweed/packs/hafs-en-v1/1.0.0/ \
  s3://deenfocus-assets/tajweed/packs/hafs-en-v1/1.0.0/ \
  --recursive --endpoint-url https://<ACCOUNT_ID>.r2.cloudflarestorage.com \
  --cache-control "public, max-age=31536000, immutable"

# 3. Regenerate + upload catalog.json LAST, only once every artifact for the
#    new version is confirmed uploaded (this is the single atomic "go live"
#    step — the catalog is the only file clients poll).
python3 tool/ai_assets/generate_catalog.py \
  --spec tool/ai_assets/specs/catalog.json \
  --out /tmp/release/catalog.json
aws s3 cp /tmp/release/catalog.json s3://deenfocus-assets/catalog.json \
  --endpoint-url https://<ACCOUNT_ID>.r2.cloudflarestorage.com \
  --cache-control "public, max-age=60"
```

**Why catalog.json is uploaded last:** clients only ever discover a new version
by re-polling `catalog.json` (ADR-008 §2's 24h cadence). Uploading artifacts
first, catalog last, means a client can never observe a `catalog.json` that
points at artifacts still mid-upload.

### Versioning rules (unchanged from ADR-008 §4)

- Semver `latestVersion`; a version directory, once published, is **immutable**
  — a bad release is fixed by publishing a **new** version, never by overwriting
  an existing one in place (R2's long `Cache-Control` on versioned paths depends
  on this).
- No silent auto-downgrade: the client never reverts on its own if
  `catalog.json` reports an older `latestVersion` than what's installed.

### Rollback (operator-side "pull a bad release")

Client-side rollback (a corrupt/failed *download*) is already handled entirely
by the existing, unmodified `AssetRollbackManager`/`installFromDirectory` logic
(ADR-008 §3) — nothing new here. **Operator-side** rollback (a release that
installs fine but turns out to be functionally bad, e.g. a mis-trained model)
is a `catalog.json`-only edit:

1. Edit `catalog.json`'s `latestVersion` for the affected `packId` back to the
   last-known-good version (or edit `manifestUrl` to point at the previous
   version's manifest).
2. Re-upload just `catalog.json` (step 3 above). No artifact re-upload needed —
   the previous version's files are still present at their immutable path.
3. Already-updated clients keep running the bad version until they see the
   corrected catalog (worst case: `recommendedCheckIntervalHours`, hard-floored
   client-side at 1h) — there is no forced-downgrade push mechanism in v1. If an
   emergency kill-switch is ever needed faster than that, see ADR-008 §4's
   reserved (not-yet-implemented) `blocklistedVersions`/`minSupportedVersion`
   fields — adding real enforcement for those is a future, separate change, not
   part of this ADR.

## 3. Manifest / catalog generation tooling

`tool/ai_assets/generate_manifest.py` and `tool/ai_assets/generate_catalog.py`
(Python, no new dependencies beyond the stdlib) — see `tool/ai_assets/README.md`
for full usage. Deliberately asset-kind-agnostic: the manifest generator takes a
JSON "spec" mapping friendly names to local file paths plus arbitrary pass-through
metadata, computes SHA-256 for each named file, and emits a manifest JSON —
it does not hardcode Tajweed's `encoder`/`pronunciationHead`/... key names, so the
exact same script works for a future Qari/translation/tafsir manifest shape.

## 4. What stays 100% unchanged (explicit checklist, extends ADR-008 §6)

- Everything in ADR-008 §6's checklist (Flutter/`TajweedService` API,
  MethodChannel/EventChannel contract, ADR-006 JSON schema, ADR-007 lifecycle
  semantics, `ModelStore` verify/activate/rollback/SHA-256 code).
- The ADR-008 `AssetDownload*` framework files, unmodified.
- `TajweedAssetSync`'s manifest key names, install semantics, and its delegation
  to `ModelStore.installFromDirectory` — it is now shaped as an `AIAssetPlugin`
  but performs exactly the same work as the ADR-008 adapter it replaces.

## Consequences

- One new small file pair per platform (`AIAssetPlugin` protocol/interface +
  `AIAssetManager` class) sits between `ModelStore`/`TajweedAssetSync` and the
  ADR-008 download engine. `TajweedAssetSync` changed from a standalone adapter
  directly wired into `ModelStore` to an `AIAssetPlugin` implementation
  registered with `AIAssetManager.shared` — `ModelStore.ensureModel()`'s
  observable behavior, error codes, and fallback order are unchanged.
- Adding a second asset type (e.g. Qari audio) in the future requires: one new
  `AIAssetPlugin` implementation (its own `fileSpecs`/`install`), one
  `register()` call, and a new `catalog.json` entry — **zero** changes to
  `AIAssetManager`, the ADR-008 download engine, or any existing asset's plugin.
  Proven by `AIAssetManagerTest`/`AIAssetManagerTests`' `FakePlugin`-based tests,
  which exercise a plugin with no knowledge of Tajweed at all.
- Hosting is pinned to Cloudflare R2 for the eventual real bucket; until that
  bucket exists and `catalogUrl` is configured, every registered plugin's
  `ensureAsset()` is inert exactly like ADR-008 described (falls through to
  each plugin's own pre-existing local/`MISSING` fallback).
- Multi-pack **Flutter-facing** selection (letting a user pick a specific Qari,
  translation, or Tajweed language pack in-app) is still out of scope — same
  deferral as ADR-008 §5's "Deferred: multi-pack Flutter API." This ADR only
  makes the **native download infrastructure** multi-asset-ready.

## Implementation (2026-07-29)

**Generic manager layer (new, this ADR):**
- iOS: `ios/Runner/AssetDownload/{AIAssetPlugin,AIAssetManager}.swift`
- Android: `android/app/src/main/kotlin/.../assetdownload/{AIAssetPlugin,AIAssetManager}.kt`
- `AssetCatalogModels` (`AssetCatalogEntry`) on both platforms gained one optional
  `kind: String?` field; all other parsing is unchanged.

**Tajweed adapter, refactored to be the first registered plugin:**
- iOS: `TajweedAssetSync` now conforms to `AIAssetPlugin`; `TajweedAssetDistributionConfig.defaultPackId`
  renamed to `.assetId`. `ModelStore.ensureModel()` lazily registers
  `TajweedAssetSync.shared` with `AIAssetManager.shared` on first use, then calls
  `AIAssetManager.shared.{isCheckFresh,checkForUpdateAndInstallIfNeeded,performFirstInstall}`
  instead of calling the old standalone `TajweedAssetSync` methods directly.
- Android: `TajweedAssetSync` (now a class, not an object, so it can hold a
  `ModelStore` reference) implements `AIAssetPlugin` the same way;
  `TajweedAssetDistributionConfig.DEFAULT_PACK_ID` renamed to `.ASSET_ID`;
  `ModelStore.ensureModel()` updated symmetrically via `AIAssetManager.shared`.
- `MODEL_MISSING` fallback contract preserved exactly: any `AIAssetManager`
  failure that isn't a genuine content/verification error
  (`TajweedNativeError`/`TajweedNativeException`) is caught at the
  `ModelStore.ensureModel()` boundary and still surfaces as the original
  `MODEL_MISSING` message — Flutter-visible behavior is unchanged.

**Tests (all passing, no regressions):**
- iOS: `ios/RunnerTests/AIAssetManagerTests.swift` (new, `FakePlugin`-based,
  proves genericness: unregistered-plugin error, two independent assets sharing
  one catalog without interference, first-install-when-unavailable) +
  `TajweedAssetSyncTests.swift` (updated to drive `TajweedAssetSync` through a
  real `AIAssetManager` instance instead of calling it directly; added
  `testCatalogWithUnrelatedAssetEntryIsIgnored`). Full suite: **40/40 passing**
  (`xcodebuild test`, iPhone 16 Simulator) — 36 pre-existing + 4 new.
- Android: `android/app/src/test/kotlin/.../assetdownload/AIAssetManagerTest.kt`
  (new, same `FakePlugin` scenarios, Robolectric-backed for real `org.json`
  behavior) + `TajweedAssetSyncTest.kt` (same update pattern as iOS, plus
  `catalogWithUnrelatedAssetEntry_isIgnored`). Full suite: **BUILD SUCCESSFUL**,
  `./gradlew :app:testDebugUnitTest`, 0 failures across all Tajweed +
  assetdownload tests.
- `ios/Runner.xcodeproj/project.pbxproj` updated to include the 2 new Swift
  source files (Runner target) and 1 new test file (RunnerTests target).

**Tooling (new, this ADR):** `tool/ai_assets/{generate_manifest.py,
generate_catalog.py,README.md}` — see §3 above.
