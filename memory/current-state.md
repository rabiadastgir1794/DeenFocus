# Current State
> Source of truth for recovery. Read this first after any interruption.
> Last updated: 2026-07-30 — **DIY CoreML encoder post-training optimization comparison
> complete (palette-8 / INT8 win; FP32 production candidate NOT replaced).**
> Prior: iOS DIY pack on live R2; DIY functional CoreML from `.nemo`; ANE-parity
> feasibility (no); Arabic script parity; normalizeArabic.

## Status: DIY CoreML encoder optimization comparison (2026-07-30)
User asked to evaluate architecture-preserving compressions on the self-generated
encoder **without replacing the production candidate**. Full report:
[`memory/features/tajweed/diy-coreml-encoder-optimization-2026-07-30.md`](features/tajweed/diy-coreml-encoder-optimization-2026-07-30.md)
(lab mirror: `tajweed-lab/experiments/diy_coreml_poc/reports/encoder_optimization_comparison.md`).

**Measured on host (`coremltools` 9.0, `CPU_AND_GPU`, 3 golden clips, same pronunciation head):**

| Technique | Size | Exact transcripts | Mean \|Δpron\| | Verdict |
|---|---:|:---:|---:|---|
| FP32 baseline (current candidate) | 587 MB | 3/3 | 0 | keep as production for now |
| FP16 convert | 294 MB | NaN | — | reject |
| Prune 50% (weight compression) | 240 MB | 0/3 | 0.098 | reject |
| **Palettize 8-bit** | **146 MB** | **3/3** | **0.0034** | **recommended** |
| Palettize 4-bit | 74 MB | 0/3 | 0.019 | reject |
| **Linear INT8** | **149 MB** | **3/3** | **0.0036** | **runner-up** |
| Linear INT4 | — | — | — | needs iOS18 re-convert |

**Recommendation:** prefer `palette_8bit` (or `linear_int8`) for a future R2 version
after real-iPhone validation. Production FP32 weight SHA unchanged
(`f8848ad7…`); R2 `ios/tajweed/v1` untouched. Harness:
`experiments/diy_coreml_poc/evaluate_encoder_optimizations.py`.

**Next action (await approval):** side-load `artifacts/optimization/palette_8bit/`
via `TajweedImport` on a real iPhone → measure latency/ANE → only then publish as
`ios/tajweed/v1.1.0` (immutable; do not overwrite v1).

## Status: iOS Tajweed DIY CoreML pack — migrated to production R2 asset distribution (2026-07-30)
Follow-up to the entry directly below. User asked: is the DIY pack bundled or
downloaded like Android? (Answer: neither — it was a manual `Documents/
TajweedImport` debug-copy path, not in the IPA but also not through the real
downloader.) Migrated it to the real pipeline. Full report:
[`memory/features/tajweed/ios-asset-distribution-migration-2026-07-30.md`](features/tajweed/ios-asset-distribution-migration-2026-07-30.md).

**What changed (asset distribution path only — zero inference/scoring changes):**
- Uploaded the verified DIY `device_pack/` artifacts (~592MB: encoder + head
  `.mlpackage`s, tokenizer, tokens) to the **same real Cloudflare R2 bucket**
  Android already uses (`deenfocus-ai-assets`), under `ios/tajweed/v1/`,
  mirroring Android's exact layout. `catalog.json`'s existing `hafs-en-v1` pack
  gained an `"ios"` key (uploaded last, per ADR-009's atomic-go-live ordering).
- `TajweedAssetSync.fileSpecs()` now supports unzipped `.mlpackage` **directory**
  bundles via an opt-in `"<name>Files"` manifest array (3 member files:
  `Manifest.json`, `Data/com.apple.CoreML/model.mlmodel`,
  `.../weights/weight.bin`) — zero changes needed to the generic
  `AssetDownloadManager`/`AIAssetManager` (already directory/nested-path-aware).
  Fully backward-compatible: absent the new key, single-file behavior is
  unchanged (verified by the full pre-existing test suite still passing).
- **`TajweedAssetDistributionConfig.catalogURL` (iOS) is now LIVE** — changed
  `nil` → the real R2 catalog URL, the same "one switch" pattern Android's
  used since 2026-07-29. Made it `var` (was `let`) + added test isolation
  (`RunnerTests`/`TajweedAssetSyncTests` `setUp`/`tearDown` null out both the
  config **and** `AIAssetManager.shared.catalogURL` directly, since the latter
  is set once via `ModelStore`'s lazy registration) so the test suites stay
  fully offline/deterministic.
- **Found + fixed a real bug** (TD-011, now closed): `URLSessionAssetTransport
  .fetchAppending` requested each artifact's entire remaining bytes in **one
  open-ended Range request** under a fixed 30s timeout — invisible with
  Android's smaller files, and never before exercised on iOS since `catalogURL`
  was always `nil`. The very first live fresh-install test against the real
  ~587MB encoder timed out. Fixed by bounding each request to an 8MB chunk;
  `AssetDownloadManager`'s existing multi-chunk resume loop already handled
  this correctly, it just had never been exercised. Generic downloader fix,
  not Tajweed/CoreML-specific.

**Verified real, end-to-end, no simulation:**
- New unit test `testPerformFirstInstallDownloadsMultiFileMlpackageBundle`
  (offline, `FakeAssetTransport`) + full existing suite —
  `xcodebuild test -only-testing:RunnerTests` **all green**, no regressions.
- **Live fresh-install test against production R2** (temporary `XCTestCase`,
  deleted after use): wiped `ModelStore.shared.rootURL`, called the exact
  `AIAssetManager.performFirstInstall` path a real first launch takes against
  the live `catalogURL`. Downloaded catalog → manifest → all 8 real files →
  verified real SHA-256 → activated → `isAvailable()==true` →
  `encoderApi()==.singleFunctionFixedLength(4800)` → confirmed the installed
  model path is **outside** `Bundle.main.bundlePath` (never embedded in the
  IPA). ~104s for ~592MB. Confirmed via `curl` that every uploaded artifact is
  publicly reachable at the expected byte size.
- Untouched: `OfflineAsrModel`, `MelFrontend`, `TajweedEngine`,
  `TajweedLexicalScoring`, `PronunciationHeadModel`, `ModelStore.installFromDirectory
  /verifyStaging/verifySHA`, `AssetDownloadManager`/`AIAssetManager` core logic, Android.

**Still open (unchanged from the entry below — this migration is distribution-path
only, does not re-validate inference):** this is still the DIY non-ANE encoder
(~592MB vs. official ~210MB estimate); real-iPhone cold/warm/inference timing
and an Instruments ANE-dispatch trace are still outstanding.

**Next action:** decide whether to keep `catalogURL` live for broader QA/rollout,
or revert to `nil` pending real-iPhone latency validation (see report's
"Rollback" section — one-line change, no R2 cleanup needed either way).

## Status: DIY functional CoreML from fastconformer-quran.nemo, wired into iOS (2026-07-30)
Follow-up to the entry directly below, after the user explicitly said: ignore parity with
the official ANE package, just get a *working* self-generated model into the real
pipeline. Full report:
[`memory/features/tajweed/diy-coreml-nemo-production-attempt-2026-07-30.md`](features/tajweed/diy-coreml-nemo-production-attempt-2026-07-30.md).

**Verified (real weights, real audio, no simulation):**
- Byte-level tensor diff proves `models/onnx/model_with_encoder.onnx` (used by Android
  production today) *is* an export of this exact `.nemo`'s weights (CTC head
  byte-identical; 188/194 2D encoder tensors match direct-or-transposed; the only 6
  non-matches are RNNT decoder/joint params not present in the CTC-only ONNX at all).
- Regenerated a **functional, non-ANE** CoreML encoder (FP32, fixed `(1,80,4800)` +
  explicit `length` input, single-function, 587 MB) from that ONNX via the existing
  `onnx2torch→coremltools` lab pipeline. Confirmed the `RangeDim` (dynamic-length) export
  *converts* but **fails at runtime** for non-traced lengths — fixed-shape is the only
  option with this pipeline.
- Host `coremltools` e2e on the 3 real golden clips: **3/3 exact transcript match**,
  pronunciation-head scores within tolerance of Android — verdict
  `HOST_PARITY_OK_BUT_NOT_PRODUCTION_DROP_IN`.
- **`ComputeUnit.ALL` fails to build an execution plan for this model on this Mac**
  (partitioner error -6); `CPU_ONLY`/`CPU_AND_GPU`/`CPU_AND_NE` each work individually.
  Production Swift already requests `.cpuAndNeuralEngine`, matching the working
  `CPU_AND_NE` config.
- **Made the minimal Swift changes** so `OfflineAsrModel`/`ModelStore`/`TajweedEngine`
  can load *either* the official multifunction ANE package (unchanged, default) *or* this
  DIY single-function fixed-length package, selected by a new optional manifest field
  (`encoderApi`/`encoderFixedT`) — zero behavior change when the field is absent. Also
  fixed a latent output-layout bug (`encoder_output` channel-first vs. batch-first)
  surfaced while wiring this.
- `xcodebuild build` — **BUILD SUCCEEDED**; `xcodebuild test -only-testing:RunnerTests` —
  **53/53 passing**, no regressions.
- Assembled an install-ready device pack:
  `tajweed-lab/experiments/diy_coreml_poc/device_pack/`.

**Not yet done — needs a real iPhone (handoff instructions in the report):** on-device
cold/warm/inference timing via the existing `TajweedDebugRunner` harness, and an
Instruments Core ML trace to confirm whether the Neural Engine is actually dispatched
(vs. silent CPU/GPU fallback) — `MLModelConfiguration.computeUnits` is a request, not a
guarantee. This dev machine currently has no attached physical iPhone.

**Known cost of this path vs. the official package:** ~587 MB vs. ~210 MB estimated, and
latency scales with the fixed 48s cap regardless of actual clip length (always pays
worst-case cost) — real tradeoffs of skipping ANE windowed-attention optimization, not
implementation bugs.

## Status: fastconformer-quran.nemo vs production iOS CoreML (2026-07-30)
Downloaded checkpoint: `/Users/rabiadastgir/Downloads/fastconformer-quran.nemo`.
Full report:
[`memory/features/tajweed/nemo-checkpoint-coreml-feasibility-2026-07-30.md`](features/tajweed/nemo-checkpoint-coreml-feasibility-2026-07-30.md).

**Verdict: cannot replace HF CoreML dependency from this `.nemo` alone.**

- Tokenizer SHA + encoder YAML (`att_context_size=[-1,-1]`, 17×512, CTC 1025)
  match Android ONNX / lab tokenizer — good SoT for the **Android/full-attn** path.
- Production iOS ANE pack is a **different** windowed fine-tune (`[32,32]` +
  pos-enc clamp + multifunction `predict_T*`) — not in this checkpoint.
- NeMo has **no CoreML exporter** (ONNX/TensorRT only). DIY full-attn→CoreML
  FP16/ANE already failed (prior DIY POC).
- Full `restore_from` not completed here (Python 3.13 / NeMo ASR dep chain);
  structural torch/config evidence is sufficient for the verdict.

No production code or production model assets changed. Scratch only under
`tajweed-lab/experiments/nemo_coreml_investigation/`.

## Status: Tajweed Arabic script parity with settings (2026-07-30)
Recording/result pages were showing wrong Arabic *presentation*: no Quran
font on recording (system default), result hardcoded `UthmanicHafs`.

Fix: `TajweedEntryPoint.open` resolves text + font from Reading Settings
(`QuranScript` → `QuranScriptTexts` + `fontFamily`) so practice matches the
surah listing 100%. Recording + result views use `args.arabicFontFamily`.

## Status: normalizeArabic Uthmani↔Imlaei fix (2026-07-30)
Root cause of all-`sub` on correct recitation was orthographic mismatch between
expected Uthmani (`uthmani.json`) and ASR Imlaei — not Levenshtein/FA/head.

**Fix (canonical normalization only; no architecture change):**
`TajweedLexicalScoring.normalizeArabic` on Android + iOS now:
1. Map U+0670 dagger alif / U+0671 alef wasla → ا
2. Strip tashkeel + Quranic sukun U+06E1 + annotations U+06D6..U+06ED + tatweel
3. Fold أ/إ/آ → ا and ى → ي
Does **not** merge bare `ملك` with `مالك`, or `قل`/`قال`, or `رب`/`ربك`.

Verified: Fatiha 1:4 Uthmani ↔ Imlaei ASR → 3/3 MATCH, wordAccuracy 1.0.
Regression tests in `TajweedAlgorithmTest` + iOS `RunnerTests`.
Untouched: ASR, ONNX, mel, tokenizer, alignWords DP, pronunciation head, Flutter UI, download.

Diagnosis dump retained: `memory/features/tajweed/lexical-match-failure-diagnosis-2026-07-30.md`.

## Status: Lexical-first scoring implemented (2026-07-30)
Approved design from `lexical-first-scoring-design.md` is now in native engines:

- Word-level Levenshtein alignment first (`TajweedLexicalScoring` kt/swift).
- Distinct wire status `sub` (not overloaded `major`).
- Additive token fields `lexical` + `pronunciation`.
- `wordAccuracy` = matched expected words ÷ expected words (pronunciation severity ignored).
- Pronunciation head + FA only on lexically matched hyp words (FA of hypothesis CTC ids).
- Untouched: Mel, ASR/ONNX models, tokenizer, ModelStore, downloader, AI asset manager.
- ADR-006 revised; Dart `TajweedTokenStatus.sub` + result legend colors updated.
- Regression unit tests: wrong-ayah → 0% lexical accuracy; matched+major still counts
  lexically; instrumented `TajweedMismatchDiagnosticTest` asserts accuracy &lt; 0.15.

## Status: Tajweed "wrong ayah still scores high" — root-cause investigation (2026-07-30)
**Investigation only, per explicit instruction — no UI/download-infra/Flutter code
changed.** Full report:
[`memory/features/tajweed/android-ios-scoring-investigation-2026-07-30.md`](features/tajweed/android-ios-scoring-investigation-2026-07-30.md).

**Finding: not an Android-vs-iOS parity bug.** Reproduced with real on-device audio
+ real production ONNX weights (new diagnostic instrumented test, not in CI):
reciting a completely different, zero-shared-word ayah than the one requested still
scores 75–100% `wordAccuracy`. Confirmed the raw ASR transcription (`hypothesis`,
before any scoring) is **accurate** in every case — the ASR/preprocessing/decoding
stack is not at fault. The bug is entirely downstream, in scoring:
1. CTC forced-alignment has no reject state — it always forces *some* alignment of
   the expected text onto the audio, however bad the fit (measured: the DP's own
   internal path likelihood is ~4x worse for wrong-ayah pairings, but this signal
   is computed and then thrown away on both platforms).
2. The pronunciation head is a goodness-of-pronunciation classifier (assumes the
   right word was said, asks "how well?") — it was never trained to detect "wrong
   word entirely," so it defaults to near-ceiling "correct" probabilities for
   content it wasn't trained to reject.
3. `wordAccuracy` is built purely from per-word pronunciation-head statuses; the
   already-computed sentence-level `exactMatch` (hypothesis vs. expected text) is
   never factored in.

Verified this is **not an ONNX-export/conversion defect**: re-ran the exact same
mismatch scenario through the DIY CoreML re-export of the *same* pronunciation-head
weights (`tajweed-lab/experiments/diy_coreml_poc/`) and got the same per-piece
probabilities as ONNX/Android. Also: iOS has never run real-weight CoreML inference
in production (still HF-gated, per `features/tajweed/overview.md`), so there is no
actual iOS baseline to be "at parity with" today — the only real CoreML numbers
available (the DIY re-export) already show the identical bug. No fix was
implemented — see the report's "what this means for fixing it" section for
evidence-backed candidate directions (surfacing the discarded alignment
log-likelihood; folding `exactMatch` into `wordAccuracy`; retraining the head with
wrong-word negatives) left for a follow-up decision.

New artifact (diagnostic only, not wired into CI): `android/app/src/androidTest/
kotlin/com/app/deenly/deenly/tajweed/TajweedMismatchDiagnosticTest.kt`.

## Status: Tajweed word-level scoring + result UI fix (2026-07-29)
Two real bugs found via on-device QA (physical low-RAM Android device, model `V2149`)
and fixed cross-platform (Kotlin + Swift, kept behaviourally identical per ADR-006),
plus a presentation rewrite requested on top:

1. **"Model could not be loaded" after a successful recording.** Root cause: Android's
   `onTrimMemory(TRIM_MEMORY_RUNNING_LOW)` → `TajweedEngine.onMemoryWarning()` can unload
   the ASR/pronunciation-head ONNX sessions *while the user is mid-recording* (confirmed via
   a captured stack trace: `OnnxAsrModel.predict` → "ASR model not loaded."). `stopRecording
   AndScore()` never re-checked this before scoring. Fix: it now re-warms (reloads
   tokenizer/encoder/head) if anything got unloaded before scoring the already-captured
   audio, instead of discarding the user's recording.
   (`android/app/src/main/kotlin/.../tajweed/TajweedEngine.kt`, `OnnxAsrModel.kt` unchanged;
   also added `Log.e`/`Log.d` diagnostics around model load/score failures.)
2. **Result screen showed per-piece "chips" (looked like colored letters/phonemes) and
   could show 0% accuracy while most pieces were "ok".** Investigated per explicit ask:
   - The pronunciation head scores individual **SentencePiece subword pieces** (from CTC
     forced-alignment onto the expected text), not phonemes and not whole words — so the
     old UI was, in effect, "coloring each phoneme/sub-word unit."
   - Word boundaries *were* implicitly known (the tokenizer's `▁` SentencePiece word-start
     marker, produced when `expectedArabic` was encoded) but were discarded before reaching
     the JSON (`piece()` stripped `▁`) and never used for grouping — so this was a data-
     plumbing gap, not a missing-model problem.
   - Fix (native, both platforms): `CtcAligner.TokenInterval` gained a `tokenIndex` (position
     in the encoded sequence — needed since vocab ids repeat); `SentencePieceTokenizer`
     gained `startsNewWord(id)`; `TajweedEngine.score()`/`buildWordLevelTokens` now groups
     per-piece forced-align intervals by word (worst-piece-wins probability) and emits **one
     token per Quran word** (`text` = the literal ayah word, never reconstructed from pieces)
     with a single ok/minor/major/miss status. A word whose pieces the aligner skips entirely
     is now explicitly "miss" instead of silently vanishing.
   - Fix (the 0% bug): `wordAccuracy` was computed from a **separate, disconnected** ASR-
     hypothesis-text-vs-expected-text diff (`TajweedLexicalScoring.wordAccuracyScore`), which
     could disagree with the token statuses shown to the user. Now `TajweedLexicalScoring.
     wordAccuracyFromTokens(tokens, expectedWordCount)` derives the percentage directly from
     the same per-word statuses (ok+minor ÷ expected word count) — the number and the
     word-by-word feedback can no longer contradict each other.
   - Dart: `TajweedResultView` no longer renders boxed per-token chips. It renders the ayah
     as one continuous `Text.rich` paragraph (`UthmanicHafs` font, RTL) with a soft per-word
     background highlight + color for non-"ok" words (no boxes — avoids breaking Arabic
     ligatures/letter connections); tapping a word shows its status via a SnackBar. Any
     "extra" tokens (lexical-fallback-only) are shown as a separate line below rather than
     interleaved into the reference ayah text.
   - Added/updated unit tests both platforms: `TajweedAlgorithmTest.kt` (`startsNewWord`,
     `wordAccuracyFromTokens`, `tokenIndex`) and `RunnerTests.swift` (same, plus a full
     `xcodebuild test` run on iOS Simulator — **TEST SUCCEEDED**, all suites green). Android
     `./gradlew :app:testDebugUnitTest` — green.
   - Not done: no native change to the CTC-aligner's DP itself, no retraining/re-export of
     the pronunciation head — this was purely aggregation/reporting + presentation, per the
     "preserve the native inference and scoring engine" instruction.

## Status: Flutter Tajweed practice UI — Phase 5 started (2026-07-29)
Per explicit instruction, started the production Flutter UI on top of the existing,
**unchanged** native engines (Phases 2-3) and **unchanged** AI Asset Manager/downloader
(ADR-008/009). This supersedes the "wait for FROZEN gate" note below for UI work only —
iOS production model validation is still blocked on the HF CoreML gate (see FROZEN block),
so this UI is exercised for real only on Android today; on iOS `ensureModel()` will
surface `MODEL_MISSING`/download-screen errors gracefully (no catalog provisioned there).

**What was built (Dart only — no native/downloader changes):**
- `lib/features/tajweed/model/tajweed_practice_args.dart` — nav payload (surah, ayah,
  arabic text, optional surah name/translation), passed via go_router `extra`.
- `lib/features/tajweed/viewmodel/tajweed_practice_view_model.dart` — `ChangeNotifier`
  state machine: `checkingModel` → (`isAvailable()` fast path, else `downloadingModel`
  via `ensureModel()` + `downloadProgress()`) → `recordingReady` ⇄ `recording` →
  `scoring` → `result`. Wraps mic permission request, native event stream
  (`interrupted`/`modelUnloaded`), per-`TajweedErrorCode` friendly messages, and saves
  a `TajweedHistoryEntry` via the existing `TajweedHistoryStore` on successful scoring.
- `lib/features/tajweed/view/tajweed_practice_screen.dart` +
  `view/widgets/{tajweed_download_view,tajweed_recording_view,tajweed_result_view}.dart`
  — one screen, body swapped by stage: one-time download-progress view (auto-continues
  to recording on success, Retry/Not-now on failure), record/stop mic UI with live
  elapsed timer and error banners (incl. "Open app settings" for mic-permission-denied),
  and a results view (word-accuracy %, exact-match badge, colored per-token chips using
  the existing ADR-006 `TajweedToken`/`TajweedTokenStatus` schema, Try Again/Done).
- New go_router route `RouteNames.tajweedPractice` (`/tajweed/practice`) registered in
  `app_router.dart`; `lib/features/tajweed/tajweed_entry_point.dart` is a small shared
  helper (`isEnabled()` + `open()`) used by all entry points below.
- **Entry points:** (1) Settings → new "AI Tajweed Practice (Beta)" toggle (production,
  not debug-gated) writing `StorageService.tajweedEnabled` — this is now the real
  rollout switch, separate from the temporary Android debug harness below. (2) A mic
  icon per ayah, shown only when the toggle is on, in `SurahDetailBottomSheet` (inline
  ayah rows) and `AyahCard` (used by `JuzReadingScreen`) — both navigate to
  `TajweedPracticeScreen` with that ayah's surah/ayah/arabic text/translation.
  `MushafPageScreen` has no per-ayah entry (renders whole pages, not ayah rows).
- Audio recording → ONNX inference pipeline itself required **no new native code** —
  it was already fully implemented and validated in Phases 2-3
  (`TajweedService.startRecording`/`stopRecordingAndScore` already drive the complete
  record → mel → ONNX ASR → CTC decode/align → pronunciation head → lexical scoring →
  JSON pipeline on Android, CoreML equivalent on iOS). This session only added the
  Flutter UI/ViewModel layer consuming that existing contract.

**Verified:** `flutter analyze` clean (only pre-existing, unrelated warnings/infos
remain); `flutter build apk --debug` — **BUILD SUCCESSFUL**.

**Not done / explicitly out of scope this pass:**
- No l10n strings added for the new screens (plain English, matching the existing debug
  screen's precedent) — follow-up if this ships broadly.
- `MushafPageScreen` (page-image reading mode) has no Tajweed entry point (no per-ayah
  row to attach it to).
- No on-device/emulator manual QA of the new screens yet (build-verified only this pass).
- iOS: nothing native changed; the UI will only reach `recordingReady` on iOS once its
  `catalogURL` is provisioned (still blocked — see FROZEN block) or a local
  `TajweedImport` debug pack is present.

**Next action:** manual QA on a real Android device/emulator with the model installed
(full record → score → result loop, permission-denied path, interrupted-recording path),
then decide on l10n and the Mushaf-page entry point.

## Status: Temporary Android Tajweed Asset Debug UI (2026-07-29)
Temporary harness for manual download QA — **not** product UI.
- Screen: `lib/features/tajweed/view/tajweed_asset_debug_screen.dart`
- Entry: Settings row, gated `kDebugMode && Platform.isAndroid` in
  `settings_tab_screen.dart`
- Actions: `ensureModel()` (auto-enables `StorageService.tajweedEnabled`), live
  `TajweedService.downloadProgress()` bar, `isAvailable()` status, delete
  `…/files/TajweedModels` after `dispose()` for repeat first-install tests
- **Remove** this screen + Settings row when download QA is done

## Status: Android production AI asset downloading — ENABLED + verified on real Cloudflare R2 (2026-07-29)
`TajweedAssetDistributionConfig.catalogUrl` (Android only) now points at the real,
live bucket: `https://pub-470cb85af0ad4c5f92edb5094b8a7dbb.r2.dev/catalog.json`
(1 pack: `hafs-en-v1`, kind `tajweed_model`, v1.0.0, ~464MB). iOS is **unchanged** —
`catalogURL` still `nil` there; this activation is Android-only per instruction.

**Critical bug found and fixed:** `HttpUrlConnectionAssetTransport.fetchAppending()`
(`android/.../assetdownload/AssetTransport.kt`) used
`connection.inputStream.use { it.readBytes() }` — buffering the **entire remaining
HTTP response body in one in-memory `ByteArray`**. This OOM-crashed on first real
contact with the real ~464MB/458MB encoder file (confirmed via `am instrument`:
`java.lang.OutOfMemoryError: Failed to allocate a 134217744 byte allocation`). Fixed by
streaming in bounded 8MB chunks (64KB buffer) directly to the destination `RandomAccessFile`,
returning `isComplete=false` between chunks so `AssetDownloadManager`'s existing outer
loop issues a fresh Range request per chunk — same public contract, no caller changes
needed. **This bug would have hit on iOS too if not for CoreML's different (streaming)
transport path being unexercised at this size until now; **confirmed iOS's
`URLSessionAssetTransport.fetchAppending` (`ios/Runner/AssetDownload/AssetTransport.swift`)
has the exact same class of bug** — `session.dataTask(with:)` buffers the whole response
`Data` in memory before the completion handler fires. Not fixed this pass (out of scope —
Android-only activation was requested and iOS's `catalogURL` is still `nil`/inert), but
must be fixed (same bounded-chunk streaming approach, or switch to
`URLSession.downloadTask`) before iOS's catalog is ever activated — logged as new
technical debt, see `memory/technical-debt.md`. Unit tests (`FakeAssetTransport`-based,
both platforms) never caught this because the fake doesn't touch real HTTP/large
payloads — this is now a known test-coverage gap on both platforms.

**Test-isolation fix (also required):** `AIAssetManager.shared` is a process-wide
singleton, and `ModelStore`'s lazy `assetSync` always overwrites
`AIAssetManager.shared.catalogUrl` with `TajweedAssetDistributionConfig.catalogUrl` on
first touch. Once that config pointed at a real URL, `TajweedAssetSyncTest` and
`TajweedEngineRobolectricTest` (which call the real `ModelStore`/`TajweedEngine`, not a
fake) started making **real network calls during `./gradlew testDebugUnitTest`** (one
even OOM'd in the JVM sandbox). Fixed by making `TajweedAssetDistributionConfig.catalogUrl`
a `var` (was `val`) and adding `@Before`/`@After` in both test files to null it out for
the duration of each test — no `AIAssetManager`/`ModelStore` production logic changed,
only test hygiene. **Any new test that calls the real `ModelStore.ensureModel()`/
`TajweedEngine.ensureModel()` must do the same or it will hit real network.**

**Detailed logging added** (additive `Log.i`/`Log.d`/`Log.w`/`Log.e` only, no behavior
changes) across `AIAssetManager.kt`, `AssetDownloadManager.kt`, `AssetTransport.kt`,
`ModelStore.kt`, `TajweedAssetSync.kt` for: catalog fetch, manifest fetch, per-file
download (incl. resume-from-`.part` and retry/backoff), SHA-256 verification (per
artifact), activation, and cache-hit short-circuits. Also added automatic cleanup of a
corrupted/failed staged download in `AIAssetManager.syncFromCatalog` (a real gap: a
failed `plugin.install()` previously left the downloaded-but-unverified files on disk
indefinitely instead of deleting them immediately).

**On-device validation (Pixel_7 emulator, real network to the real R2 bucket, no
mocks):** new `android/app/src/androidTest/kotlin/.../assetdownload/
ProductionCatalogDownloadTest.kt` drives the exact production singletons
(`TajweedEngine`/`ModelStore`/`AIAssetManager.shared`) an eventual Flutter
`ensureModel()` call would reach. **4/4 passing** (`am instrument`, ~121s total):
1. First install with **no local model** + a simulated interrupted prior download
   (pre-seeded 5MB `.part` file) — resumes via HTTP Range from byte 5,242,880 instead of
   restarting, downloads all 4 artifacts, SHA-256-verifies all of them against the real
   manifest hashes, activates. A broken resume would have failed SHA-256 verification
   and failed this test.
2. Cache-hit fully offline (wifi+data disabled via shell) — completed in 7ms, zero
   network.
3. Model survives a fresh `ModelStore` instance (proxy for app-restart persistence) with
   correct SHA-256 still matching.
4. Version re-check against the live catalog (cache window forced stale) — same version
   detected, **no re-download** of the 464MB artifact (0.7s vs. the ~114s full download).

Corrupted-file detection was **not** re-validated on-device this pass (impractical
against an immutable real R2 bucket) — already covered by existing, still-passing JVM/
Robolectric tests exercising the identical `verifyStaging`/`verifySha` code path:
`TajweedAssetSyncTest.checksumMismatch_onFirstInstall_neverActivates`,
`TajweedModelIntegrityTest.tamperedEncoderHashIsRejected`.

**Full test suites re-verified green after all fixes:** `./gradlew :app:testDebugUnitTest`
— BUILD SUCCESSFUL, 0 failures.

**Explicitly NOT done this session (per instruction):** no Flutter Tajweed UI. iOS
`catalogURL` left `nil` (Android-only activation as requested).

**Next action (await explicit approval):** decide whether to activate iOS's catalog too
(after auditing `URLSessionAssetTransport` for the same large-file-buffering risk), or
proceed to Flutter Tajweed UI (Phase 5), or hold per the FROZEN block below.

## 🔒 PROJECT FROZEN: Tajweed AI — resume only when HF CoreML access is granted
**Superseded for Flutter UI work only, 2026-07-29** (explicit instruction to start
Phase 5 — see "Flutter Tajweed practice UI — Phase 5 started" status block above).
The native-engine/model-validation gate below still applies as-is for iOS; do not
change native Tajweed engine code or the downloader based on this override — it
covers Dart/UI work only.
**Do not modify the Tajweed implementation, start the Flutter Tajweed UI, or add
features. Bug fixes only.** Approved-complete checklist:
- ✅ Flutter architecture / shared contracts (`TajweedService`, models, history store)
- ✅ iOS native implementation (`ios/Runner/Tajweed/`)
- ✅ Android native implementation (`android/.../tajweed/`)
- ✅ Android end-to-end validation (Pixel_7 emulator, 3/3 golden clips exact-match)
- ✅ Cross-platform mel preprocessing parity (TD-009 fixed, corr ≥ 0.9998)
- ✅ ADRs (006, 007) and JSON contract frozen
- ⏳ **iOS production validation** — blocked on HF gated download access to
  `Muno459/fastconformer-quran-coreml-offline` (metadata/LICENSE access works;
  `.mlpackage` weight blobs 403 — re-confirmed 2026-07-29, see
  `memory/features/tajweed/ai-readiness-report.md` §8)

**Exact resume steps once HF grants download access** (do these in order, nothing
else, then stop for approval again):
1. Run `tajweed-lab/scripts/download_coreml_offline.py`; install the pack for iOS
   Simulator/device (`Documents/TajweedImport`).
2. Run the existing iOS validation suite (`ios/RunnerTests/RunnerTests.swift`) plus
   `TajweedDebugRunner` against the real weights.
3. Run inference on the same 3 golden clips Android used
   (`tajweed-lab/samples/*.wav`, same set as `tajweed_parity_android.json`).
4. Compare iOS vs Android: transcript, alignment, pronunciation score, confidence,
   JSON schema (reuse `tajweed-lab/scripts/parity_compare_mel.py` pattern / write an
   equivalent e2e comparator like `parity_dump_onnx_e2e.py`).
5. Run validation on a physical iPhone (not Simulator).
6. Record final benchmarks: cold load, warm load, inference time, peak memory, CPU.
7. Produce a final production validation report (extend
   `memory/features/tajweed/ai-readiness-report.md`).

**If and only if all of the above pass:** mark the AI engine **Production Ready**
in this file and `memory/features/tajweed/overview.md`, then begin the full-screen
Flutter Tajweed UI (Phase 5). Do not skip ahead to UI work before this gate clears.

**ADR-008/ADR-009 downloader + AI Asset Manager — now implemented (2026-07-29), but
not yet activated:** `memory/decisions/ADR-008-tajweed-production-model-distribution.md`
(generic native download engine) + `memory/decisions/ADR-009-ai-asset-manager.md`
(generic multi-asset orchestrator — `AIAssetManager`/`AIAssetPlugin`, Tajweed as the
first registered plugin, Cloudflare R2 as the chosen host) document and record the
full implementation on both iOS/`ios/Runner/AssetDownload/` +
`ios/Runner/Tajweed/{TajweedAssetSync,TajweedAssetDistributionConfig}.swift` and
Android/`.../assetdownload/` + `.../tajweed/{TajweedAssetSync,
TajweedAssetDistributionConfig}.kt`. Reuses the existing `ensureModel()` Dart call and
`ModelStore` verify/activate/rollback/SHA-256 code **unchanged** — no Flutter,
MethodChannel, EventChannel, or JSON-schema changes. Full unit test coverage (first
install, update, resume-after-interruption, checksum mismatch, rollback,
offline/catalog-unavailable, insufficient storage, generic multi-plugin isolation)
passes on both platforms with no regressions (iOS 40/40, Android full suite green).
**Still inert in practice:** `TajweedAssetDistributionConfig.catalogURL`/`catalogUrl`
is `nil`/`null` on both platforms (no real Cloudflare R2 bucket/catalog exists yet),
so `ensureModel()` falls straight through to the pre-existing local-import-dir /
`MODEL_MISSING` behavior — this is intentional and safe, and does not unblock the HF
CoreML weight problem above (that's a separate, still-open blocker: even once a
catalog/bucket exists, it can only host the **official** CoreML pack, which this dev
account still cannot download). Next real step for this thread: once HF access is
granted and the official `.mlpackage`/ONNX packs are in hand, provision the real
Cloudflare R2 bucket (ADR-009 §2), use `tool/ai_assets/{generate_manifest,
generate_catalog}.py` to populate `catalog.json` + per-pack manifests, and point
`TajweedAssetDistributionConfig.catalogURL` at it — do not do this before then.

## Status: Tajweed — ADR-009 generic AI Asset Manager implemented & tested (2026-07-29)
Refactored the ADR-008 Tajweed-only downloader into a generic, multi-asset
**AI Asset Manager** per reviewer request ("one system: AI Asset Manager ├── Tajweed
Models ├── Qari Audio Packs ├── Translation Packs ├── Tafsir Packs ├── Future AI
Models" instead of separate downloaders per asset kind). Full design + Cloudflare R2
hosting/release/rollback guide: `memory/decisions/ADR-009-ai-asset-manager.md`.

**What changed (both platforms, symmetric):**
- New generic layer: `AIAssetPlugin` protocol/interface (identity + isAvailable +
  fileSpecs + install) and `AIAssetManager` class (catalog fetch, per-asset 24h
  freshness cache, version comparison, staging lifecycle, exact-`assetId` catalog
  lookup — no fallback-to-default across unrelated assets). Neither file references
  Tajweed, ONNX, or ModelStore.
  - iOS: `ios/Runner/AssetDownload/{AIAssetPlugin,AIAssetManager}.swift`
  - Android: `android/app/src/main/kotlin/.../assetdownload/{AIAssetPlugin,AIAssetManager}.kt`
- `AssetCatalogModels`/`AssetCatalogEntry` gained one optional `kind: String?` field
  (free-form, e.g. `"tajweed_model"`/`"qari_audio"`) on both platforms — additive,
  backward-compatible with the ADR-008 v1 catalog shape.
- `TajweedAssetSync` refactored from a standalone adapter into the first registered
  `AIAssetPlugin` (assetId `"hafs-en-v1"`, kind `"tajweed_model"`); its manifest
  key names, install semantics, and delegation to the **unmodified**
  `ModelStore.installFromDirectory` are unchanged.
  `TajweedAssetDistributionConfig.defaultPackId`/`DEFAULT_PACK_ID` renamed to
  `.assetId`/`.ASSET_ID`. `ModelStore.ensureModel()` on both platforms now lazily
  registers `TajweedAssetSync` with `AIAssetManager.shared` on first use and calls
  through the manager instead of the adapter directly — the `MODEL_MISSING`
  fallback contract and all other observable behavior is byte-for-byte unchanged.
- **Hosting decision finalized: Cloudflare R2** (not Firebase Storage — the user
  corrected this mid-session). Zero native code impact: both platforms' transport
  layers (`URLSessionAssetTransport` / `HttpUrlConnectionAssetTransport`) are plain
  HTTPS GET + `Range`-header clients with no vendor-specific code, confirmed by
  re-reading both. Only docs/tooling reference the host.
- New Phase A release tooling (stdlib-only Python, asset-kind-agnostic):
  `tool/ai_assets/{generate_manifest.py,generate_catalog.py,README.md,specs/*.example.json}`
  — computes SHA-256 per artifact and `approxSizeBytes` per platform automatically;
  manually smoke-tested end-to-end (happy path + duplicate-packId + missing-file
  error paths) outside the app tree.

**Tests (no regressions):**
- iOS: `ios/RunnerTests/AIAssetManagerTests.swift` (new, generic `FakePlugin`-driven:
  unregistered-plugin error, two independent assets sharing one catalog without
  interference, first-install-when-unavailable) + `TajweedAssetSyncTests.swift`
  (updated to drive `TajweedAssetSync` through a real `AIAssetManager` instance;
  added `testCatalogWithUnrelatedAssetEntryIsIgnored`). **40/40 passing**
  (`xcodebuild test`, iPhone 16 Simulator).
- Android: `android/app/src/test/kotlin/.../assetdownload/AIAssetManagerTest.kt` (new,
  Robolectric-backed for real `org.json` behavior — plain JUnit hit the Android SDK's
  stub `org.json` returning nulls) + `TajweedAssetSyncTest.kt` (same update pattern +
  `catalogWithUnrelatedAssetEntry_isIgnored`). `./gradlew :app:testDebugUnitTest` —
  **BUILD SUCCESSFUL**, 0 failures across the full Tajweed + assetdownload suite.
- `ios/Runner.xcodeproj/project.pbxproj` updated for the 2 new Runner sources + 1 new
  RunnerTests file.

**Not activated in production:** same as ADR-008 before it — no real Cloudflare R2
bucket/catalog exists yet, `catalogUrl`/`catalogURL` stays `nil`/`null` on both
platforms, so every plugin's `ensureAsset()` is inert. Only Tajweed is registered
today; Qari audio / translation / tafsir packs are designed-for but not built (no
new plugin implementations were added for them, per instruction to stop after the
downloader + asset manager are complete and tested).

**Explicitly NOT done this session (per instruction):** Flutter Tajweed UI — no
Dart/UI files touched. Qari/translation/tafsir `AIAssetPlugin` implementations —
architecture supports them (proven generic by the `FakePlugin` tests) but none were
built; that's future work once a concrete asset (e.g. a specific Qari's audio pack)
is scoped.

**Next action (await explicit approval):** either (a) provision the real Cloudflare
R2 bucket once official Tajweed model weights are available (still blocked on the HF
gate — see FROZEN block above) and cut the first real release via
`tool/ai_assets/`, or (b) scope and build the first non-Tajweed `AIAssetPlugin`
(e.g. a Qari audio pack) using this same infrastructure.

## Status: Tajweed — ONNX→production CoreML feasibility CLOSED (2026-07-29)
Research-only follow-up to the DIY POC. Question: can
`model_with_encoder.onnx` become a production CoreML pack with variable/bucket
input, `predict_T*` multifunction API, FP16 without NaNs, and ONNX transcript
parity?

**Answer: No.** CT does not export multifunction `predict_T*` from ONNX in one
shot (merge-only via `MultiFunctionDescriptor`). The ONNX graph is full
self-attention with **no** windowed-attention nodes; official ANE packs require
windowed attention + pos-enc clamps. Stock FP16 conversion yields NaN logprobs.
FP32 host parity does not unlock ANE production.

**Action:** Permanently keep official CoreML as production source (ADR-004
reaffirmed). Close DIY productionization track. Report:
`memory/features/tajweed/onnx-to-coreml-production-feasibility.md`.

## Status: Tajweed — DIY ONNX→CoreML research POC (lab-only, 2026-07-29)
Isolated experiment under `tajweed-lab/experiments/diy_coreml_poc/`. **No production
iOS/Flutter/Android code changed.** Converted local ONNX encoder + pronunciation head
via onnx2torch→coremltools; ran 3 golden WAVs; compared to Android parity JSON.

- FLOAT16 encoder: **all-NaN logprobs** → garbage `<unk>` transcripts.
- FLOAT32 fixed-T=480 encoder: **3/3 transcript exact match vs Android**; mean |Δprob|
  ≤ 0.003; alignment ≤ 1 frame (80 ms); token statuses identical.
- Verdict: `HOST_PARITY_OK_BUT_NOT_PRODUCTION_DROP_IN` — do **not** swap into
  `ModelStore` / replace HF ANE packages. Keep ADR-004.
- Report: `memory/features/tajweed/diy-coreml-poc-parity-report.md`

## Status: Tajweed — ADR-008 generic asset-download framework implemented & tested
Implemented the full ADR-008 design: a generic, Tajweed-independent
`AssetDownload` framework on both platforms (download manager with resumable
`.part`-file HTTP Range downloads, retry/backoff, cancellation, pre-flight
insufficient-storage checks, SHA-256 integrity verification, rollback manager, atomic
installer, progress notifier, catalog/manifest models + fetcher, transport
abstraction), plus a thin Tajweed-specific adapter (`TajweedAssetDistributionConfig` +
`TajweedAssetSync`) wired into `ModelStore.ensureModel()` on both iOS and Android. No
Flutter API, MethodChannel, EventChannel, ADR-006 JSON schema, or ADR-007
lifecycle/verify/activate/rollback code was touched — the adapter only supplies a new
**input source** (downloaded staging dir) to the existing `installFromDirectory` flow.

**Files added:**
- iOS framework: `ios/Runner/AssetDownload/*.swift` (9 files)
- iOS adapter: `ios/Runner/Tajweed/{TajweedAssetDistributionConfig,TajweedAssetSync}.swift`
- iOS tests: `ios/RunnerTests/{FakeAssetTransport,AssetDownloadManagerTests,
  TajweedAssetSyncTests}.swift`
- Android framework: `android/app/src/main/kotlin/.../assetdownload/*.kt` (9 files)
- Android adapter: `android/app/src/main/kotlin/.../tajweed/{TajweedAssetDistributionConfig,
  TajweedAssetSync}.kt`
- Android tests: `android/app/src/test/kotlin/.../assetdownload/{FakeAssetTransport,
  AssetDownloadManagerTest}.kt`, `.../tajweed/TajweedAssetSyncTest.kt`
- `ios/Runner.xcodeproj/project.pbxproj` updated to register all new Swift files
  (Runner target for framework/adapter, RunnerTests target for the 3 new test files).

**Files modified:** `ModelStore.swift` (iOS) and `ModelStore.kt` (Android) —
`ensureModel()` now delegates to `TajweedAssetSync` for update-checks and first
installs, with the original `MODEL_MISSING` behavior preserved as the final fallback.

**Test results (no regressions):**
- iOS: `xcodebuild -workspace Runner.xcworkspace -scheme Runner -destination
  'platform=iOS Simulator,name=iPhone 16' -only-testing:RunnerTests test` — **36/36
  passing** (21 pre-existing Tajweed tests + 7 `AssetDownloadManagerTests` +
  8 `TajweedAssetSyncTests` = 15 new). Covers: first install, update detected + activated,
  same-version no-redownload, resumed-after-interruption, transient-network-blip retry,
  checksum-mismatch rejection
  (never activates), failed-update rollback (previous model stays active),
  catalog-unreachable (keeps existing model working), insufficient storage (fails before
  any network call), cancellation.
- Android: full Tajweed + downloader suite — **39/39 passing** (24 pre-existing:
  `TajweedAlgorithmTest` ×11, `TajweedEngineRobolectricTest` ×10,
  `TajweedModelIntegrityTest` ×2, `TajweedMelParityTest` ×1; + 15 new:
  `AssetDownloadManagerTest` ×7, `TajweedAssetSyncTest` ×8) via
  `./gradlew :app:testDebugUnitTest`, JUnit XML reports confirmed 0 failures/errors —
  same scenario coverage as iOS.

**Not activated in production:** `TajweedAssetDistributionConfig.catalogURL`
(iOS)/`catalogUrl` (Android) is still `nil`/`null` — no real object-storage bucket or
catalog has been provisioned. Until that's set, `ensureModel()` behaves exactly as
before this change (local `TajweedImport` import dir, or `MODEL_MISSING`). See
`memory/decisions/ADR-008-tajweed-production-model-distribution.md` "Implementation"
section for full detail.

**Next action:** wait for explicit approval before integrating this with the Flutter
UI (per reviewer instruction) — no Flutter Tajweed UI work has started. The framework
and adapter are otherwise complete and dormant until (a) HF grants CoreML weight
access (separate, still-open blocker) and (b) real object storage + a populated
catalog are provisioned and pointed to by `TajweedAssetDistributionConfig`.

## Status: Tajweed — AI engine "Implementation Complete – Pending Production Model Validation"
Per reviewer instruction: Android AI pipeline is **approved**. The only remaining
blocker for iOS production validation (and therefore for cross-platform parity,
real-device QA, and final benchmarks) is Hugging Face gated-download access to
`Muno459/fastconformer-quran-coreml-offline` — re-verified today by re-running
`tajweed-lab/scripts/download_coreml_offline.py`, still `403 Client Error` on
`Manifest.json`/encoder/head weight blobs (metadata/LICENSE access works; file
download does not). No code, Flutter API, MethodChannel/EventChannel, or ADR was
touched this pass since no further engine work is possible without the weights.

**Blocked downstream of the HF gate (cannot start until it's resolved):**
1. iOS end-to-end inference with production CoreML weights.
2. iOS vs Android parity comparison (transcript, pronunciation score, alignment,
   confidence, JSON schema) using production models on both platforms.
3. Physical iPhone validation (device was reachable wirelessly in a prior session
   but has no CoreML pack to run; not re-checked this pass since it's moot until
   weights exist).
4. Final iOS benchmarks (cold/warm load, inference, peak memory, CPU).

Android's equivalents (2–4, for Android) are already done — see the entry below and
`memory/features/tajweed/ai-readiness-report.md`.

**Next action:** wait for Hugging Face to grant download access to the gated CoreML
repo (not just metadata access) for the token in `tajweed-lab/.env`, then resume at
step 1 above. Do **not** start the Flutter Tajweed UI until iOS production validation
completes or you explicitly waive it.

## Status: Tajweed — Android AI pipeline ready; iOS CoreML still blocked; awaiting UI approval
Full report: `memory/features/tajweed/ai-readiness-report.md`.

**Done this session:**
- TD-010: exported `pronunciation_head.onnx`, wired into Android (int64 tokens, encoder
  transpose, no mel-bucket pad for ONNX, ModelStore rename-activate).
- Host + Pixel_7 emulator e2e on 3 golden clips: all `exactMatch=true`, ADR-006 JSON.
- Benchmarks (emulator): ensureModel ~1s, first warm ~1.2s, inference 130–275ms.
- Flutter API / MethodChannel / JSON schema untouched.

**Still blocked:**
- iOS CoreML weight download (HF 403 on `.mlpackage` blobs).
- Physical Android / iPhone inference QA (no physical Android; iPhone online but no CoreML pack).
- Peak memory / CPU instrumentation not collected.

**Next action (await explicit approval):** Flutter full-screen Tajweed UI (Phase 5), or
pause until HF CoreML access + physical-device QA.

## Status: Tajweed — TD-009 fixed (iOS/Android mel preprocessing now equivalent)
`ios/Runner/Tajweed/MelFrontend.swift`'s Hann window now uses the exact same formula as
Android/Python (see `memory/technical-debt.md` TD-009, now closed) instead of
`vDSP_hann_window(..., vDSP_HANN_NORM)`. Re-ran the Phase 4A mel parity harness on the
same 3 real golden clips: iOS vs Android correlation improved from ≥0.998 to
**≥0.9998** (one sample hits **1.0000**), mean|Δ| dropped from ~0.03 to **~0.002 or
better**, max|Δ| dropped from up to 2.36 to at most 0.16 — and that residual is fully
explained (one numerically-degenerate, near-silent mel bin, constant across all frames,
not a signal-processing bug — detail in TD-009). All 21 iOS XCTests still pass
unmodified; only `MelFrontend.swift` changed — no Flutter, MethodChannel/EventChannel,
JSON schema, or Android/Kotlin changes. **iOS and Android mel preprocessing are now
equivalent for practical purposes.**

Only `MelFrontend.swift` changed for this fix; the rest of the Phase 4A picture from
2026-07-28 (below) is unchanged — full transcript/score/confidence parity and real
model integrity for iOS are still blocked on the HF gate (metadata access ≠ file-
download access — confirmed twice now), Android's pronunciation head still needs a
PyTorch→ONNX export (TD-010), and no physical iPhone/Android device is attached to this
dev machine.

**Next action (await explicit approval):** decide whether to proceed to Phase 4B/5
(Flutter UI) with the remaining known gaps (HF gate, TD-010, no real device) still open
and flagged, or pause further until those are resolved.

## Status: Tajweed — Phase 4A (Golden Parity Testing) partially complete, approved with TD-009 fix required (now done, see above)
Branch `feature/Quran` (uncommitted). Scope actually achievable in this dev environment
was constrained by two hard blockers discovered/reconfirmed during this phase — see
"Blockers" below. Full results, commands to reproduce, and raw data:
`tajweed-lab/parity/reports/` (gitignored — see report doc for a mirror in memory).

**What Phase 4A actually validated (real, on real golden audio, real weights where available):**
1. **Mel spectrogram parity** (`tajweed-lab/scripts/parity_compare_mel.py` diffing
   `tajweed-lab/parity/python/*.json` vs `/tmp/tajweed_parity/{ios,android}/*.json`,
   produced by `RunnerTests.testPhase4AMelParityDumpOnGoldenSamples` and
   `TajweedMelParityTest.dumpMelForGoldenSamples` on the real
   `tajweed-lab/samples/*.wav` clips): **Android matches the Python reference almost
   exactly** (mean|Δ| ≈ 0.005–0.010, corr ≥ 0.996). **iOS shows a real, non-trivial
   divergence** from both Python and Android (max|Δ| up to ~2.4, ~3–4% of values exceed
   a 0.15 tolerance, corr still ≥ 0.992) — this is TD-009 (new), a confirmed, measurable
   version of the mel-windowing-convention risk flagged in Phase 3. **Action needed
   before Phase 4B:** fix `MelFrontend.swift`'s Hann window per TD-009 and re-run this
   comparison.
2. **Model integrity (SHA-256 + manifest)** — Android only, for real:
   `TajweedModelIntegrityTest` (`android/app/src/test/kotlin/.../tajweed/`) ran
   `ModelStore.installFromDirectory`/`verifyStaging` against the **real** ONNX encoder
   already present locally (`tajweed-lab/models/onnx/model_with_encoder.onnx`, 458MB,
   sha256 `417da4c1...`) plus real tokenizer/tokens, confirmed a correct-hash pack
   installs and activates, and confirmed a tampered-hash pack is rejected
   (`MODEL_DOWNLOAD_FAILED`) and never becomes active. iOS-side real integrity check is
   still blocked (no real `.mlpackage` files downloadable — see Blockers).
3. **Python reference transcripts** for the 3 golden clips, using the *same* ONNX
   encoder Android's `OnnxAsrModel.kt` uses (`tajweed-lab/scripts/parity_dump_reference_transcripts.py`
   → `tajweed-lab/parity/reports/python_reference_transcripts.json`): established ground
   truth for future iOS/Android transcript comparison once both native engines can run
   real inference (see Blockers — neither could yet).

**What Phase 4A could NOT complete, and why (hard blockers, not skipped by choice):**
- **iOS real inference (transcript/alignment/pronunciation-score/confidence) — BLOCKED.**
  HF access to `Muno459/fastconformer-quran-coreml-offline` now resolves via
  `HfApi.model_info()` (metadata/file listing succeeds), but `hf_hub_download` for the
  actual `.mlpackage` blobs (`model.mlmodel`, `weight.bin` for both encoder and head)
  still 403s — confirmed by re-running `tajweed-lab/scripts/download_coreml_offline.py`
  in this session. Only `tokenizer.model`/`tokens.txt` (small, ungated-in-practice files)
  are present; no CoreML weights exist on this machine. **Unblock:** the repo owner needs
  to add this HF account to the gate's approved-members list (metadata access ≠ file
  download access on HF for gated repos); then re-run the download script.
- **Android real pronunciation-head inference — BLOCKED.** Only a PyTorch checkpoint
  (`tajweed-lab/models/head/pronunciation_head.pt`) exists; no ONNX export. See TD-010.
  Encoder-only (transcript) inference on-device was not attempted this session either —
  the ONNX Android AAR's native libs only run inside an Android runtime (confirmed by
  the Phase 3 `UnsatisfiedLinkError` fix), so a real on-device/emulator instrumented-test
  run is still open work, not just a code change.
- **Real device testing — NOT MET.** This dev machine has no physical iPhone or Android
  device currently connected (`xcrun xctrace list devices` shows all real iPhones as
  "Offline"; `adb devices` returns empty; `flutter devices` only finds the iOS
  Simulator). All Phase 4A work above ran on iOS Simulator + JVM/Robolectric (Android
  unit tests execute on the host JVM, not an emulator). The mel/integrity code paths
  exercised are the exact same production Swift/Kotlin, so this is strong evidence but
  not a substitute for real-hardware validation (NNAPI/ANE-specific behavior, real mic
  input, thermal/battery conditions are all untested).

**Next action (await explicit approval):** fix TD-009 (iOS Hann window) and re-run
`parity_compare_mel.py`; once the HF gate is actually approved for downloads and/or a
physical device + pronunciation-head ONNX export are available, re-run Phase 4A's
transcript/score/confidence comparisons for real. Do not start Phase 4B/5 (Flutter UI)
until those are resolved or explicitly waived.

## Status: Tajweed — Phase 3 (Android ONNX Runtime) complete, approved
Branch `feature/Quran` (uncommitted). Android debug APK **BUILD SUCCESSFUL**
(`flutter build apk --debug`, `./gradlew :app:assembleDebug`).

Phase 3 delivered — symmetric to `ios/Runner/Tajweed/`:
- Full Kotlin engine under `android/app/src/main/kotlin/com/app/deenly/deenly/tajweed/`
  (AudioRecorder using `AudioRecord`, MelFrontend with a hand-rolled radix-2 FFT,
  CtcDecoder, SentencePieceTokenizer, CtcAligner, OnnxAsrModel, PronunciationHeadModel,
  ModelStore, TajweedEngine, TajweedChannelHandler, TajweedLexicalScoring)
- ONNX Runtime Mobile (`onnxruntime-android:1.19.2`); NNAPI preferred, XNNPACK/CPU
  fallback (no standalone GPU delegate ships in the stock AAR — documented deviation,
  see Risks below)
- `RECORD_AUDIO` permission added to `AndroidManifest.xml`
- Channel wiring replaces Phase 1 placeholders in `MainActivity.kt` (Flutter contract
  unchanged); `onTrimMemory` / `onPause` forward to the engine like iOS's memory-warning
  / background notifications
- Unit tests: `android/app/src/test/kotlin/.../tajweed/` — 21 tests, all passing
  (`TajweedAlgorithmTest` pure-JVM: CTC decode/align, mel bucket shape, tokenizer
  round-trip, **mel golden-vector numeric parity against `tajweed-lab/web/asr/mel.py`**;
  `TajweedEngineRobolectricTest`: functional/error-mapping/threading, mirrors
  `ios/RunnerTests/RunnerTests.swift`)
- Fixed a **pre-existing** `android/app/build.gradle.kts` bug: the release
  `signingConfig` block crashed *any* Gradle invocation (including `assembleDebug`)
  on a fresh checkout with no keystore in `local.properties`. Now guarded by
  `hasReleaseSigning`.

**Blocker for on-device inference QA (same as iOS):** no ONNX encoder/pronunciation-head
weights bundled (no HF token in the app). `ModelStore.ensureModel()` looks for
`getExternalFilesDir(null)/TajweedImport` (adb-push debug path) and otherwise fails with
`MODEL_MISSING` — verified correct via `TajweedEngineRobolectricTest`.

**Next action (await explicit approval):** Phase 4A — Golden Parity Tests (iOS vs
Android, same audio samples vs `tajweed-lab/models/coreml/golden_transcripts.json`) —
**before any Flutter UI (Phase 5) work**, per reviewer's explicit request. Do not start
Phase 5 yet.

### Risks / deviations to review in Phase 4A
- **Mel windowing convention differs by design, not by mistake:** iOS uses
  `vDSP_hann_window(..., vDSP_HANN_NORM)` (power-normalized), Android/Kotlin uses the
  plain symmetric Hann matching `tajweed-lab/web/asr/mel.py` (`np.hanning`) exactly —
  confirmed via a hardcoded golden-vector test comparing Android's mel output to the
  Python reference on a synthetic tone (see `TajweedAlgorithmTest.melFrontendMatchesPythonReferenceOnSyntheticTone`).
  The two conventions differ by a constant per-frame power-scale factor, which the
  shared per-bin mean/var (CMVN) normalization step should cancel out — but this has
  **not** been cross-validated iOS vs Android on the same real audio yet. Do this first
  in Phase 4A.
- **No GPU delegate on Android.** The stock `onnxruntime-android` AAR doesn't ship a
  distinct GPU execution provider (unlike TFLite). Implemented fallback chain is
  NNAPI → XNNPACK → default CPU, not NNAPI → GPU → CPU as literally requested. NNAPI can
  itself route to GPU/DSP on some vendors' devices, but this isn't guaranteed.
- Android's `TajweedAudioRecorder` uses `AudioManager` focus-loss as the
  "interruption" signal (closest Android equivalent of iOS's
  `AVAudioSession.interruptionNotification`); not identically triggered (e.g. a phone
  call is one of several possible causes, not the only one).

## Status: Tajweed — Phase 2 (iOS CoreML) validated
iOS validation pass complete (see `ios/RunnerTests/RunnerTests.swift`, 20 tests, all
passing): functional (`ensureModel`/`prepareModel`/`startRecording`/
`stopRecordingAndScore`/`cancelRecording`/`dispose` state machine incl. `MODEL_MISSING`
/ `NOT_RECORDING` paths without a model pack installed), JSON shape (lexical token
report keys match ADR-006, no platform-specific fields), memory (20x
ensure/dispose cycles stable, `dispose()` idempotent), threading (engine completions
verified off the main thread — `TajweedChannelHandler` hops back to main exactly once
per call via `deliver`/`deliverJSON`, now with `[weak self]` throughout), error mapping
(`TajweedNativeError` → `FlutterError` code preserved, no raw Swift errors leak).
Real on-device transcription accuracy still blocked on the same HF gate as before.

Phase 2 delivered (recap):
- Full Swift engine under `ios/Runner/Tajweed/` (AudioRecorder, Mel, SP tokenizer,
  CTC decode/align, OfflineAsrModel, PronunciationHead, ModelStore, TajweedEngine,
  TajweedChannelHandler)
- DEBUG harness: `ios/Runner/Tajweed/Debug/TajweedDebugRunner.swift`
- Contract doc: `tajweed-lab/docs/COREML_CONTRACT.md`
- Download helper: `tajweed-lab/scripts/download_coreml_offline.py`
- Mic: Info.plist copy + Podfile `PERMISSION_MICROPHONE=1` +
  `PermissionService.requestMicrophone()`

**Blocker for on-device inference QA:** HF gate on
`Muno459/fastconformer-quran-coreml-offline` — current token got 403.
Accept access in browser, run `download_coreml_offline.py`, copy pack to
Simulator `Documents/TajweedImport`, then `ensureModel` / DebugRunner.

## Status: Tajweed Phase 1 — approved
Shared Flutter contract + ADR-006/007 landed previously.

## Status: Quran 2.0 Phase 1 — implemented, pending manual QA
Still in the same working tree.

## Performance measurements (Phases 2–3)
Cold/warm/inference timings are **not yet measurable** on either platform without the
real weight packs installed (same HF-gate blocker for both CoreML and ONNX artifacts).
`TajweedDebugRunner` (iOS) prints `coldSetupMs` / `totalWarmPathMs` / `inferenceMs` once
models are installed; Android's `TajweedEngine.scorePcmForDebug` returns the equivalent
`warmOrReuseMs` / `inferenceMs` map but has no bundled CLI harness yet (candidate for
Phase 4A). Targets remain ADR-007: warm load &lt;500ms, inference &lt;2s.
