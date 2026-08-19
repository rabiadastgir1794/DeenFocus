# ADR-008 — Tajweed production model distribution (HF-free, periodic-check, multi-pack-ready)

**Date:** 2026-07-29   **Status:** Accepted — generic downloader framework + Tajweed
adapter implemented and tested on both platforms (see "Implementation" section below).
**Extended by `ADR-009-ai-asset-manager.md`:** the Tajweed-specific
`TajweedAssetSync` adapter described here was refactored into a generic
`AIAssetPlugin` registered with a new shared `AIAssetManager`, so the exact same
download engine documented in this ADR (unchanged) can also serve future Qari
audio / translation / tafsir packs. The final hosting decision (§1 below listed
several vendor options) is **Cloudflare R2** — see ADR-009 §2 for the bucket
layout, upload/release process, and versioning/rollback guide.
**Not yet activated in production**: no real catalog/pack has been hosted or wired up
(`TajweedAssetDistributionConfig.catalogURL`/`catalogUrl` is `nil`/`null` on both
platforms, so `ensureModel()` still falls back to the local `TajweedImport` import path
until a real HTTPS catalog URL is configured). See `memory/current-state.md` PROJECT
FROZEN block for the overall Tajweed AI freeze (HF CoreML weight access still blocked).
**Feature:** tajweed (iOS CoreML + Android ONNX), generic reusable asset-download layer.

## Problem

`ModelStore` (ADR-007) already defines download → verify → activate → rollback, but
Phase 2–3 never had a real host: `ensureModel()` on both platforms currently only
looks for a manually-placed local directory (`Documents/TajweedImport` / adb-pushed
`TajweedImport`) and throws `MODEL_MISSING` otherwise — there is no network fetch.
Hugging Face was only ever used as a **developer-side** download tool
(`tajweed-lab/scripts/download_coreml_offline.py`, `download_model.py`), never
embedded in the shipped app. We need a real production distribution path that:

1. Never bundles the ~200–460 MB model in the app binary.
2. Never re-downloads it on every launch.
3. Checks a tiny remote manifest periodically (open Tajweed, or every 24h) and only
   pulls a new pack when a newer *compatible* version actually exists.
4. Never depends on Hugging Face at runtime.
5. Is ready to host more than one AI pack (language / riwayah) without a redesign,
   even though v1 ships exactly one pack.
6. Does not change `TajweedService`, the MethodChannel/EventChannel contract, the
   ADR-006 score JSON, or `ModelStore`'s existing verify/activate/rollback code path.

## Decision

Implement the periodic-check + download entirely **inside the existing native
`ensureModel()` call** (both platforms), by teaching `ModelStore` to fetch from HTTPS
object storage instead of only looking at a local import directory. No Dart, channel,
or JSON schema changes are required for v1 — this closes the gap ADR-007 already
anticipated in its "Download" lifecycle step, it just had no host to talk to before.

Multi-pack support is designed into the **manifest/hosting schema** from day one (per
reviewer request), but the *Flutter-facing* pack-selection API is explicitly deferred
to a future ADR revision (see "Deferred: multi-pack Flutter API" below) so this
proposal introduces zero Flutter/channel surface area.

---

## 1. Hosting

Any HTTPS-capable object storage works (S3, Cloudflare R2, Firebase Storage, Supabase
Storage) — the design has no vendor lock-in, only "static files over HTTPS + a CDN in
front for the large binaries."

### Bucket / key layout

```
<CDN_BASE>/tajweed/
  catalog.json                              ← tiny (≈1–5 KB), polled by the app
  packs/
    hafs-en-v1/
      1.0.0/
        ios/
          model_manifest.json
          fastconformer-quran-offline-ane.mlpackage/...
          pronunciation-head.mlpackage/...
          tokenizer.model
          tokens.txt
        android/
          model_manifest.json
          model_with_encoder.onnx
          pronunciation_head.onnx
          tokenizer.model
          tokens.txt
      1.1.0/
        ios/...
        android/...
```

Per-platform subfolders exist because the artifact **formats** genuinely differ
(`.mlpackage` vs `.onnx`) even though the pack (language/riwayah/content) is the same
— this mirrors the existing symmetric-but-not-identical native module structure from
ADR-006.

### `catalog.json` (tiny, polled frequently)

```json
{
  "catalogVersion": 1,
  "updatedAt": "2026-07-29T00:00:00Z",
  "recommendedCheckIntervalHours": 24,
  "catalogSignature": {
    "algorithm": "ed25519",
    "publicKeyId": "prod-ed25519-v1",
    "signatureBase64": "<base64>"
  },
  "packs": [
    {
      "packId": "hafs-en-v1",
      "displayName": "Hafs (Arabic) + English feedback",
      "language": "en",
      "riwayah": "Hafs",
      "isDefault": true,
      "latestVersion": "1.0.0",
      "minimumAppVersion": "1.0.0",
      "manifestUrl": {
        "ios": "<CDN_BASE>/tajweed/packs/hafs-en-v1/1.0.0/ios/model_manifest.json",
        "android": "<CDN_BASE>/tajweed/packs/hafs-en-v1/1.0.0/android/model_manifest.json"
      },
      "approxSizeBytes": { "ios": 210000000, "android": 465000000 }
    }
  ]
}
```

`recommendedCheckIntervalHours` lets ops shorten the interval remotely (e.g. during
an incident) without an app release; the client still hard-floors it at a sane
minimum (e.g. never less than 1h) to avoid abuse.

### Per-pack `model_manifest.json` (additive superset of the existing ADR-007 shape)

```json
{
  "version": "1.0.0",
  "packId": "hafs-en-v1",
  "language": "en",
  "riwayah": "Hafs",
  "encoder": "fastconformer-quran-offline-ane.mlpackage",
  "pronunciationHead": "pronunciation-head.mlpackage",
  "tokenizer": "tokenizer.model",
  "tokens": "tokens.txt",
  "sha256": {
    "encoder": "<hex>",
    "pronunciationHead": "<hex>",
    "tokenizer": "<hex>",
    "tokens": "<hex>"
  },
  "signature": {
    "algorithm": "ed25519",
    "publicKeyId": "prod-ed25519-v1",
    "signatureBase64": "<base64>"
  },
  "minimumAppVersion": "1.0.0",
  "artifactBaseUrl": "<CDN_BASE>/tajweed/packs/hafs-en-v1/1.0.0/ios/"
}
```

**Future-ready digital signatures (v1 reserved, not verified):**
- `catalogSignature` and per-pack `signature` are reserved for **Ed25519** signatures.
- v1 continues to rely exclusively on **SHA-256** integrity verification (already
  implemented in `verifyStaging()` / `verifySHA()`).
- Signature verification can be added later without changing the storage layout,
  verification/activation flow, or any existing Flutter/JSON contracts.

**Why this is safe under "ModelStore unchanged":** `ModelStore.readManifest()` /
`verifyStaging()` on both platforms only ever read specific keys (`encoder`,
`pronunciationHead`, `tokenizer`, `tokens`, `sha256`, `minimumAppVersion`) — see
`ios/Runner/Tajweed/ModelStore.swift` and `android/.../tajweed/ModelStore.kt`. Extra
keys (`packId`, `language`, `riwayah`, `artifactBaseUrl`) are silently ignored by the
existing parsing code today. Adding them requires **zero changes** to
`verifyStaging`/`verifySHA`/activation logic — confirmed by re-reading both files.

---

## 2. Trigger points & check cadence

```
App installed
     │
     ▼
User opens Tajweed  ──────────────►  ensureModel() [UNCHANGED Dart call site,
     │                                already how Phase D's "download gate" works]
     ▼
Native ensureModel():
  1. isAvailable() locally? ──No──► fetch catalog.json → resolve default pack for
     │                              this platform → download manifest → download
     │                              artifacts to staging → verify SHA-256 → activate
     │                              atomically (existing code) → done
    Yes
     │
     ▼
  2. lastCheckedAt within 24h (or server-recommended interval)? ──Yes──► return
     │                                                                    immediately,
     │                                                                    NO network call
    No (stale or never checked)
     │
     ▼
  3. Fetch tiny catalog.json (short timeout, e.g. 3s)
     │
     ├─ fails / times out ──► proceed with existing installed pack, don't update
     │                        lastCheckedAt, no error surfaced to Flutter
     │
     └─ succeeds ──► compare installed packId+version vs catalog latestVersion
                       │
                  same version           newer compatible version exists
                       │                          │
                       ▼                          ▼
              update lastCheckedAt        download new manifest+artifacts to
              only; return                staging → verify SHA-256 → activate
                                           atomically (existing rollback on
                                           failure) → update lastCheckedAt +
                                           installed version pointer → return
```

Key properties:
- **Zero new Flutter/MethodChannel/EventChannel surface.** The periodic check is
  entirely inside the native `ensureModel()` implementation; Dart still calls
  `TajweedService.ensureModel()` exactly as today, with the exact same `void` /
  `MODEL_MISSING` / `MODEL_DOWNLOAD_FAILED` contract.
- **Progress events unchanged.** Downloads (first-install or update) emit the
  already-documented `{"type": "downloadProgress", "progress": 0.0–1.0}` events on
  the existing `tajweed_events` EventChannel (ADR-007 §2) — no new event types.
- **`lastCheckedAt` / installed-pack pointer are native-internal state**, not exposed
  to Flutter: a small JSON file beside the manifest (e.g.
  `TajweedModels/update_state.json`), read/written only by `ModelStore`. This avoids
  any Dart-side persistence changes (`StorageService` untouched).
- **Never blocks on network** when a valid local model already exists and the check
  interval hasn't elapsed, or when the network check fails — the app must always be
  usable offline once a pack is installed, per the feature's core "fully offline"
  requirement.

## 3. Download → verify → activate → rollback (reuse, do not modify)

The new native download step feeds into the **existing, unmodified** code paths:

- `installFromDirectory()` / `verifyStaging()` / `verifySHA()` (iOS
  `ModelStore.swift`, Android `ModelStore.kt`) — identical SHA-256-per-artifact
  verification against the manifest, identical atomic `staging → active` swap with
  `previous/` rollback-on-failure.
- The only **new** code is "populate a staging-shaped directory by downloading files
  named exactly as `catalog.json`/`model_manifest.json` say" instead of "copy from
  `Documents/TajweedImport`." Everything past that point (verify/activate/rollback)
  is byte-for-byte the same logic already shipped in Phase 2–3.
- Retries: 3 attempts with backoff per artifact (already specified, ADR-007 §3) —
  carried forward unchanged.
- Resume: use platform-native resumable downloads (`URLSession` background download
  tasks on iOS, a range-aware downloader on Android) for the large encoder file —
  implementation detail for the eventual coding phase, not a contract change.
- Rollback: unchanged. If a new version's activation fails (corrupt download,
  SHA mismatch, disk error), `previous/` is restored automatically — this already
  works today and needs no modification.

## 4. Versioning & safety rules

- Semver `version` strings; the client only ever adopts a version reported as
  `latestVersion` in `catalog.json` for the pack it currently has installed.
- `minimumAppVersion` (existing field) gates whether the *installed app build* is
  allowed to use a given pack version — same check as today, just now actually
  exercised against a real remote manifest.
- **No silent auto-downgrade.** If `catalog.json` reports an older `latestVersion`
  than what's installed (e.g. a bad release was pulled), the client does not
  automatically revert — that requires an explicit kill-switch field (see below).
- **Optional future kill-switch fields** (not required for v1, but reserved in the
  schema so adding them later is additive, not breaking):
  - `"blocklistedVersions": ["1.0.1"]` — forces re-download even if
    `latestVersion` hasn't changed, for emergency invalidation of a bad build.
  - `"minSupportedVersion": "1.0.0"` — installed versions below this are treated as
    stale regardless of `latestVersion` comparison.

## 5. Multi-pack readiness (schema now, Flutter API later)

The catalog/manifest schema above already supports N packs (`packId`, `language`,
`riwayah`, per-pack `manifestUrl`), satisfying the reviewer's request to not need a
storage/manifest redesign when Warsh, Qaloon, Kids Mode, or additional languages are
added later.

**What v1 actually ships:** exactly one pack (`isDefault: true`), fetched
unconditionally by `ensureModel()` — Flutter never sees `packId` and never chooses
one. This keeps the current phase's promise ("Flutter APIs/MethodChannels/JSON
unchanged") strictly true.

### Deferred: multi-pack Flutter API (needs its own future ADR + approval)

Letting a user actually pick a pack (e.g. a language toggle in Reading Settings) is a
**real, separate change** that this ADR intentionally does **not** authorize:

- `ModelStore`'s on-disk layout would need `active/<packId>/` instead of a single
  `active/` directory (native-internal, but a real structural change).
- `TajweedService`/`MethodChannel` would need an additive argument, e.g.
  `ensureModel({String? packId})`, plus a way to list/select installed packs.
- A new `StorageService` preference (parallel to `quranScript`) to persist the user's
  chosen pack.

This is flagged here only so the schema decided today doesn't have to be redesigned
later — implementing it requires a new ADR revision and explicit approval, same as
this one.

## 6. What stays 100% unchanged (explicit checklist)

- `TajweedService` Dart API (`ensureModel`, `prepareModel`, `startRecording`,
  `stopRecordingAndScore`, `cancelRecording`, `getRecordingState`, `dispose`,
  `events()`/`downloadProgress()`).
- `com.app.deenly.deenly/tajweed` MethodChannel and
  `com.app.deenly.deenly/tajweed_events` EventChannel names/methods/event shapes.
- ADR-006 score JSON schema and error codes.
- ADR-007's manifest keys, verify/activate/rollback semantics, and benchmark targets.
- `ModelStore.installFromDirectory` / `verifyStaging` / `verifySHA` implementations
  on both platforms (reused as-is; only their **input source** changes from "local
  import folder" to "downloaded staging folder").
- No Hugging Face dependency anywhere in the shipped app (already true today — HF was
  only ever a lab/dev tool).

## Consequences

- Requires a small new native module per platform (an HTTP downloader feeding
  `installFromDirectory`-shaped staging dirs) — **implemented** as a generic,
  Tajweed-independent `AssetDownload` framework (see "Implementation" below), consumed
  by a thin Tajweed-specific adapter. Any future large downloadable asset (translations,
  TTS voices, OCR models, additional Quran AI packs) can reuse the same framework.
- Requires provisioning real object storage (**Cloudflare R2**, per ADR-009 §2) and
  uploading the **official** CoreML/ONNX packs once available — this ADR does not change the
  decision in `tajweed-lab/decisions/ADR-004-coreml-path.md` to use upstream CoreML
  rather than a DIY conversion. Until a real bucket exists and
  `TajweedAssetDistributionConfig` points at it, the code path is inert (no network
  calls) and `ensureModel()` behaves exactly as before (local import dir or
  `MODEL_MISSING`).
- Multi-pack Flutter selection is explicitly out of scope until a follow-up ADR.

## Implementation (2026-07-29)

Implemented as designed, isolated from the AI inference engine, with no changes to
Flutter APIs, MethodChannels, EventChannels, ADR-006 JSON schema, ADR-007 lifecycle
semantics, or `ModelStore`'s verify/activate/rollback/SHA-256 logic.

**Generic framework (reusable by any future asset consumer):**
- iOS: `ios/Runner/AssetDownload/{AssetDownloadError,AssetCatalogModels,AssetTransport,
  AssetManifestFetcher,AssetDownloadManager,AssetIntegrityVerifier,AssetRollbackManager,
  AssetAtomicInstaller,AssetProgressNotifier}.swift`
- Android: `android/app/src/main/kotlin/.../assetdownload/{AssetDownloadError,
  AssetCatalogModels,AssetTransport,AssetManifestFetcher,AssetDownloadManager,
  AssetIntegrityVerifier,AssetRollbackManager,AssetAtomicInstaller,
  AssetProgressNotifier}.kt`
- Resumable downloads via HTTP Range + `.part` files, retry-with-backoff, cancellation,
  pre-flight insufficient-storage checks (using `approxSizeBytes` from the catalog
  entry), SHA-256 verification, all off the main/UI thread.

**Tajweed adapter (thin, orchestration-only):**
- iOS: `ios/Runner/Tajweed/{TajweedAssetDistributionConfig,TajweedAssetSync}.swift`
- Android: `android/app/src/main/kotlin/.../tajweed/{TajweedAssetDistributionConfig,
  TajweedAssetSync}.kt`
- `ModelStore.ensureModel()` on both platforms now: if a model is already active and the
  24h catalog-check is fresh, no-op; if stale, best-effort check-for-update (never breaks
  an already-working model on failure); if nothing is active, try the local
  `TajweedImport` path first (dev/debug), then `TajweedAssetSync.performFirstInstall`;
  if that also fails (e.g. `catalogURL == nil`), fall through to the original
  `MODEL_MISSING` error message unchanged.
- Staging directories are cleaned up after a successful install on both platforms.

**Tests (all passing, listed by scenario from the approval prompt):**
- iOS (`ios/RunnerTests/{FakeAssetTransport,AssetDownloadManagerTests,
  TajweedAssetSyncTests}.swift`) and Android
  (`android/app/src/test/kotlin/.../assetdownload/{FakeAssetTransport,
  AssetDownloadManagerTest}.kt`, `.../tajweed/TajweedAssetSyncTest.kt`) both cover: first
  install, update (newer version detected + activated), same-version no-redownload,
  resume after interrupted download, checksum-mismatch rejection, failed-update rollback
  (previous model stays active), offline/catalog-unavailable (existing model keeps
  working), and insufficient storage (fails before any network call, nothing partially
  installed).
- Full existing Tajweed suites re-run with no regressions: iOS 21 pre-existing
  `RunnerTests` + 15 new downloader/sync tests (`AssetDownloadManagerTests` ×7,
  `TajweedAssetSyncTests` ×8) = **36/36 passing** (`xcodebuild test`, iPhone 16
  Simulator); Android 24 pre-existing Tajweed tests (`TajweedAlgorithmTest` ×11,
  `TajweedEngineRobolectricTest` ×10, `TajweedModelIntegrityTest` ×2,
  `TajweedMelParityTest` ×1) + 15 new downloader/sync tests
  (`AssetDownloadManagerTest` ×7, `TajweedAssetSyncTest` ×8) = **39/39 passing**, all
  via `./gradlew :app:testDebugUnitTest` (JUnit XML confirms 0 failures/errors).
- Added new source files to `ios/Runner.xcodeproj/project.pbxproj` (Runner target for
  framework/adapter sources, RunnerTests target for the 3 new test files).
