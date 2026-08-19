# iOS Tajweed DIY CoreML pack — migrated to production R2 asset distribution (2026-07-30)

## Question asked
"Is the DIY CoreML model currently bundled inside the iOS app, or is it
downloaded at runtime through `ModelStore` exactly like Android? If it is
bundled only for testing, migrate it to the existing runtime asset pipeline...
Do not change inference or scoring — only the asset distribution path."

## Before this session
**Not bundled in the IPA**, but also **not going through the real download
pipeline** — it lived only in
`tajweed-lab/experiments/diy_coreml_poc/device_pack/` (gitignored, lab-only)
and had to be manually copied by a developer into the Simulator/device's
`Documents/TajweedImport` folder, which `ModelStore.ensureModel()` treats as a
debug-only local-import path that takes priority over the network path (see
`ios/Runner/Tajweed/ModelStore.swift`). No Xcode target referenced it, so it
was never part of any build product. `TajweedAssetDistributionConfig.catalogURL`
was `nil`, matching the FROZEN-block precedent that iOS never had a real
Cloudflare R2 catalog activated (Android's was activated 2026-07-29 — see
`memory/current-state.md`).

## What changed (asset distribution path only — inference/scoring untouched)

### 1. Real Cloudflare R2 upload
Uploaded the exact `device_pack/` artifacts (verified via the host CoreML e2e
pass in `memory/features/tajweed/diy-coreml-nemo-production-attempt-2026-07-30.md`)
to the same production bucket (`deenfocus-ai-assets`, public host
`pub-470cb85af0ad4c5f92edb5094b8a7dbb.r2.dev`) Android already uses, mirroring
its existing layout:

```
ios/tajweed/v1/
  model_manifest.json
  diy-fastconformer-encoder.mlpackage/
    Manifest.json
    Data/com.apple.CoreML/model.mlmodel
    Data/com.apple.CoreML/weights/weight.bin   (587 MB)
  diy-pronunciation-head.mlpackage/            (same 3-file shape, 5.1 MB)
  tokenizer.model                              (identical sha256 to Android's copy)
  tokens.txt                                   (identical sha256 to Android's copy)
```

`catalog.json`'s existing `hafs-en-v1` pack entry gained an `"ios"` key
alongside the existing `"android"` key in both `manifestUrl` and
`approxSizeBytes` (621,355,008 bytes ≈ 592MB) — uploaded **last**, after every
artifact + the manifest were confirmed publicly reachable (matches ADR-009 §2's
"catalog.json is the atomic go-live step" ordering).

### 2. New code: unzipped `.mlpackage` directory support in the generic downloader
`AssetDownloadManager`/`AIAssetManager` are single-file-per-artifact by
design (ADR-008/009). A CoreML `.mlpackage` is a *directory* bundle
(`Manifest.json`, `Data/com.apple.CoreML/model.mlmodel`,
`Data/com.apple.CoreML/weights/weight.bin`) — this was a known, previously
undocumented-as-blocking gap (`tool/ai_assets/README.md`'s "Known caveat"
section). Resolved with **zero changes** to the generic
`AssetDownloadManager`/`AIAssetManager` (which already support nested
`relativePath`s and directory-aware SHA-256 verification via
`ModelStore.verifySHA` — both pre-existing, unmodified): only
`TajweedAssetSync.fileSpecs()` (`ios/Runner/Tajweed/TajweedAssetSync.swift`)
changed, to expand a named artifact into its N member files when the manifest
provides an opt-in `"<name>Files"` array (`encoderFiles`/
`pronunciationHeadFiles` — 3 entries each, the standard CoreML mlpackage
layout). Absent that key, an artifact is still fetched as one plain file
exactly as before — fully backward-compatible with Android's existing
single-file `.onnx` manifests and every pre-existing test.

### 3. Activated `TajweedAssetDistributionConfig.catalogURL` (iOS)
Changed from `nil` to the real R2 `catalog.json` URL — the same "one switch"
pattern already used for Android (`ios/Runner/Tajweed/
TajweedAssetDistributionConfig.swift`). Made it a `var` (was `let`) for the
same reason Android's is a `var`: so XCTest can null it out for the duration
of a test run. **Both** `RunnerTests.swift` and `TajweedAssetSyncTests.swift`
now save/restore `TajweedAssetDistributionConfig.catalogURL` **and**
`AIAssetManager.shared.catalogURL` in `setUp`/`tearDown` (the latter matters
because `ModelStore`'s lazy one-time registration reads the config exactly
once per process — nulling only the config after that point would be a no-op).
Without this, the whole `RunnerTests`/`TajweedAssetSyncTests` suites would
silently start making real, multi-hundred-MB network calls during
`xcodebuild test`.

### 4. Real bug found + fixed: `URLSessionAssetTransport` 30s timeout on unbounded-range requests
See `memory/technical-debt.md` TD-011 (now closed) for full detail. Summary:
`fetchAppending` requested the entire remaining file in one open-ended
`bytes=N-` Range request under a fixed 30s timeout — invisible with Android's
smaller per-file `.onnx` artifacts and never exercised on iOS before (catalog
was always `nil`). The first live end-to-end test against the real ~587MB
encoder failed with a timeout. Fixed by bounding each request to an 8MB chunk
(`ios/Runner/AssetDownload/AssetTransport.swift`) — `AssetDownloadManager`'s
existing multi-chunk resume loop already supported this, it just had never
been exercised. This is a **generic downloader fix, not Tajweed- or
CoreML-specific** — it benefits any future large single-file artifact on
either platform's iOS path.

## Verification performed

**Unit tests (offline, `FakeAssetTransport`):**
- Added `testPerformFirstInstallDownloadsMultiFileMlpackageBundle` to
  `TajweedAssetSyncTests.swift` — proves the new `encoderFiles`/
  `pronunciationHeadFiles` expansion produces correct nested `FileSpec`s,
  downloads all member files, verifies the directory-aware SHA-256 check
  (hashes `weight.bin`), and confirms `ModelStore.encoderApi()` correctly
  reads `singleFunctionFixedLength(4800)` from the manifest.
- Full suite re-run: `xcodebuild test -only-testing:RunnerTests` — **all
  passing** (`RunnerTests`, `AssetDownloadManagerTests`, `AIAssetManagerTests`,
  `TajweedAssetSyncTests`), no regressions.

**Real end-to-end fresh-install verification (live network, live R2, temporary
test deleted after use):** a throwaway `XCTestCase` wiped `ModelStore.shared
.rootURL` (simulating a fresh install/uninstall), pointed `AIAssetManager
.shared` at the live production `catalogURL`, and called the exact same
`AIAssetManager.performFirstInstall` path a real fresh app launch takes.
- First run (before the TD-011 fix): failed with a timeout on the encoder file
  — this is what surfaced the bug above.
- After the fix: **passed** — downloaded catalog → manifest → all 8 files
  (3 encoder + 3 head + tokenizer + tokens) → verified SHA-256 for encoder,
  pronunciation head, and tokenizer → activated → `ModelStore.isAvailable()
  == true` → `ModelStore.encoderApi() == .singleFunctionFixedLength(4800)`.
  Total time ~104s for ~592MB (~5.7MB/s effective, reasonable for a
  simulator-hosted download in this environment). Also explicitly asserted
  the installed encoder path does **not** live under `Bundle.main.bundlePath`
  — confirming the model is not, and cannot become, embedded in the IPA.
- Confirmed via direct `curl` against the public R2 URLs that every uploaded
  file (manifest + both mlpackage member files + tokenizer + tokens) is
  publicly reachable with the exact expected byte size.

## What did NOT change
- `OfflineAsrModel.swift`, `MelFrontend.swift`, `TajweedEngine.swift`,
  `TajweedLexicalScoring`, `PronunciationHeadModel.swift`, CTC decode/align —
  zero inference/scoring code touched.
- `ModelStore.installFromDirectory`/`verifyStaging`/`verifySHA` — zero
  changes; the new multi-file mlpackage download slots into the exact same
  unmodified verify/activate/rollback path Android's single-file artifacts
  already use.
- `AssetDownloadManager`/`AIAssetManager` — zero changes (the mlpackage
  support lives entirely in the Tajweed-specific `TajweedAssetSync.fileSpecs`
  adapter, per the existing "generic downloader knows nothing about Tajweed"
  design).
- Android — untouched. Its `.onnx`-based pack and `TajweedAssetDistributionConfig.kt`
  are unaffected by any of the above.

## Known caveats carried forward (see also `memory/current-state.md`)
This is still the **DIY, non-ANE-optimized** encoder (FP32, single-function,
fixed `(1,80,4800)` shape, ~592MB vs. the official package's estimated
~210MB) — not the official Hugging-Face-gated ANE package. Real-iPhone
cold/warm/inference timing and an Instruments Core ML trace (to confirm actual
Neural Engine dispatch vs. silent CPU/GPU fallback) are still outstanding —
see `memory/features/tajweed/diy-coreml-nemo-production-attempt-2026-07-30.md`.
This migration only proves the **distribution path** works exactly like
Android's; it does not change or re-validate the inference/accuracy findings
already reported there.

## Rollback
Set `TajweedAssetDistributionConfig.catalogURL` back to `nil` in
`ios/Runner/Tajweed/TajweedAssetDistributionConfig.swift` to fully re-disable
the iOS network path (falls back to `Documents/TajweedImport` or
`MODEL_MISSING`, byte-for-byte as before this session) — no artifact deletion
from R2 is required, since `catalog.json` simply wouldn't be polled for the
`ios` key anymore. Android's `"ios"` bystander entry in `catalog.json` is
inert for Android (it only reads its own `"android"` key).
