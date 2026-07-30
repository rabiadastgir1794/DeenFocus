# Technical Debt Register
> Every intentional shortcut gets an entry here — if the diff takes a
> shortcut and there's no TD entry, that's a review finding.
> Entries are never deleted. Mark **RESOLVED** or **DROPPED** with a dated note.

## TD-001 — Practice UI uses lexical word-diff, not real pronunciation scoring
**Description:** `tajweed-lab/web/quran_data.py::compare_texts` does a
diacritic-insensitive word diff (`difflib.SequenceMatcher`) between the ASR
transcript and the expected ayah. It does not run the pronunciation head, the
CTC-GOP scorer, or the 27-rule tajweed engine that ship in `vendor/tajweed/`.
**Reason:** Ship a working record → transcribe → compare loop fast, to
validate the ASR model itself before investing in the full scoring pipeline.
**Risk:** Cannot detect real mispronunciation (wrong tafkheem/tarqeeq, missed
ghunnah, dropped qalqalah, etc.) — only "did you say the right words," not
"did you say them correctly."
**Priority:** High
**Suggested Resolution:** Wire `vendor/tajweed/full_scorer.py` (CTC align +
pronunciation head + GOP + rule engine) into `web/app.py`'s `/api/practice`,
per `tajweed-lab/docs/ROADMAP.md` Phase 2, before treating the lab as feature-complete.

## TD-002 — Browser mic capture depends on ffmpeg, not representative of iOS path
**Description:** `tajweed-lab/web/asr/audio_io.py` decodes browser-recorded
audio (webm/opus) via a system `ffmpeg` subprocess when `soundfile` can't read
the container directly.
**Reason:** Fastest path to a working browser demo; avoids writing a native
recorder just for the lab.
**Risk:** Depends on `ffmpeg` being installed on the dev machine; unusual
codec variants fail with a generic error. This is **not** the iOS audio path —
iOS will capture native PCM via `AVAudioEngine`, no ffmpeg involved.
**Priority:** Medium
**Suggested Resolution:** Acceptable to leave as-is in the lab. Do not port the
ffmpeg dependency to iOS — see Phase B ("Audio capture contract") in
`memory/features/tajweed/coreml-ios-integration-plan.md`.

## TD-004 — Continue Reading only tracks ayah tap / audio playback, not silent scrolling
**Description:** `ReadingEngine.reportAyahVisited` (and Page Mode's
`trackPageVisit`) is only called when an ayah is tapped or audio playback
advances to a new ayah/page-change occurs. There is no scroll-position
listener that updates Continue Reading while a user silently scrolls/reads
without tapping or playing audio.
**Reason:** Kept Phase 1 scope bounded; a scroll-based "topmost visible ayah"
tracker adds meaningful complexity (viewport geometry per screen) for
uncertain UX benefit, and no reading app strictly requires it.
**Risk:** A user who reads silently by scrolling through many ayahs/pages
without ever tapping one will not have their Continue Reading position
advance past the last tapped/played ayah.
**Priority:** Low
**Suggested Resolution:** If user feedback wants it, add a debounced
`onNotification: ScrollUpdateNotification` (or similar) handler per reading
screen that calls `ReadingEngine.reportAyahVisited`/`trackPageVisit` for the
topmost visible item.

## TD-005 — Mushaf Page Mode bypasses `ReadingEngine.openPage()` for rendering
**Description:** `MushafPageScreen` preloads all 604 pages' ayahs once (one
Hive scan via `getAllAyahs()` + `MushafMetadata.ayahsOnPage`) for jank-free
swiping, and calls `ReadingEngine.trackPageVisit()` (not `openPage()`) purely
for Continue Reading/progress persistence. `openPage()` still exists and
works (used by tests / potential future callers) but Page Mode's actual
content flow doesn't go through it.
**Reason:** `openPage()` does a per-open Hive key lookup; calling it on every
PageView swipe would be async and could introduce visible jank exactly where
the spec calls for "no UI jank."
**Risk:** Two code paths exist for "get a page's ayahs" (`openPage()` and
`MushafPageScreen`'s local preload) that must be kept behaviorally
consistent if `MushafMetadata`'s page logic ever changes.
**Priority:** Low
**Suggested Resolution:** If this bifurcation becomes a real maintenance
problem, consider having `ReadingEngine` itself own the whole-book preload
for Page Mode (cache `Map<int, List<AyahRecord>>` internally) so there's a
single code path.

## TD-006 — Mushaf Page Mode translation shown as a "current ayah" strip, not inline
**Description:** `MushafPageText` (used by `MushafPageScreen`) renders each
page as continuous justified Arabic text, matching the Athan Pro / Muslim Pro
"real Mushaf page" look. When `showEnglish` is on, the translation is **not**
interleaved into the Arabic flow (that would break the page's authentic
look); instead a `_TranslationStrip` shows only the actively playing/tapped
ayah's translation above the footer.
**Reason:** Real Mushaf-style apps keep the Quran page pure Arabic; showing
every ayah's translation inline would visually break the "printed page"
effect the user explicitly asked for.
**Risk:** Users who want to read translations for every ayah on a page (not
just the one they tapped) need to switch to Surah/Juz mode, or tap through
each ayah one at a time in Page mode.
**Priority:** Low
**Suggested Resolution:** If requested, add a toggle to show a translation
list below the page (outside the Mushaf-style block) instead of only a
single-ayah strip.

## TD-007 — Android Tajweed has no GPU execution provider (NNAPI → XNNPACK → CPU only)
**Description:** `android/.../tajweed/OnnxAsrModel.kt` and `PronunciationHeadModel.kt`
try `SessionOptions.addNnapi()`, then fall back to `addXnnpack()`/plain CPU. The Phase 3
spec asked for "Prefer NNAPI, fallback to GPU delegate, fallback CPU," but the stock
`onnxruntime-android` AAR does not ship a standalone GPU execution provider (unlike
TFLite's GPU delegate).
**Reason:** No first-party ORT Mobile Android GPU EP exists in the artifact used
(`com.microsoft.onnxruntime:onnxruntime-android:1.19.2`) without a custom/vendor build.
**Risk:** On devices where NNAPI isn't available or performs poorly, inference falls
straight to CPU (with XNNPACK acceleration) instead of GPU — likely slower than the
iOS ANE path on low-end Android hardware.
**Priority:** Medium
**Suggested Resolution:** Investigate `onnxruntime-android-qnn` (Qualcomm) or a custom
ORT build with a GPU EP if benchmark targets (ADR-007) aren't met on mid-tier devices
during Phase 4A/QA.

## TD-008 — Android mel frontend uses a hand-rolled FFT, not Accelerate/vDSP
**Description:** `android/.../tajweed/MelFrontend.kt` implements its own iterative
radix-2 Cooley-Tukey FFT (`Fft.forward`) in `Fft.kt`-equivalent object, since Android
has no first-party vDSP-equivalent.
**Reason:** No native FFT library ships with the Android/Kotlin standard library;
writing one directly against the reference formula (rather than depending on a new
native dependency) keeps the module dependency-light and auditable.
**Risk:** Subtle numerical drift vs. the Python pipeline is possible on edge-case audio.
**Status (Phase 4A, resolved/verified):** Cross-checked against the Python reference on
the 3 real golden Quran recitation clips (`tajweed-lab/samples/*.wav`), not just a
synthetic tone — see `TajweedMelParityTest.dumpMelForGoldenSamples` +
`tajweed-lab/scripts/parity_compare_mel.py`. Result: Android vs. Python mean|Δ| ≈
0.005–0.010, correlation ≥ 0.996 on real audio — Android's hand-rolled FFT + explicit
`np.hanning`-matching window reproduces the Python reference log-mel almost exactly.
No further action needed here; see TD-009 for the (different, iOS-side) discrepancy
this same test run uncovered.
**Priority:** Low (downgraded after Phase 4A verification)

## TD-009 — iOS mel frontend measurably diverged from Python/Android on real audio (RESOLVED 2026-07-29)
**Original description:** Phase 4A's real-audio mel parity check found iOS's
`MelFrontend.swift` (using `vDSP_hann_window(..., vDSP_HANN_NORM)`) differed from the
Python reference / Android (`np.hanning`-equivalent) log-mel output by up to
max|Δ| ≈ 1.5–2.4 (CMVN-normalized log-mel units) on ~3–4% of feature values across the 3
real golden clips.
**Fix applied:** `ios/Runner/Tajweed/MelFrontend.swift` now computes the Hann window
manually with the exact same formula as `MelFrontend.kt`/`mel.py`
(`0.5 - 0.5*cos(2*pi*i/(N-1))`, `Double` precision then cast to `Float`), cached once as
a `private static let hannWindow`, instead of calling `vDSP_hann_window(...,
vDSP_HANN_NORM)`. No other part of the pipeline (FFT packing/scale, mel filterbank,
CMVN) changed.
**Verification (re-ran Phase 4A's mel parity harness after the fix):**

| sample | pair | max\|Δ\| before → after | mean\|Δ\| before → after | corr before → after |
| --- | --- | --- | --- | --- |
| 01_alafasy_fatihah | ios_vs_android | 1.653 → **0.160** | 0.031 → **0.002** | 0.9982 → **0.9998** |
| 02_basfar_ikhlas | ios_vs_android | 1.466 → **0.003** | 0.033 → **0.0000** | 0.9984 → **1.0000** |
| 03_alafasy_naba | ios_vs_android | 2.364 → **0.160** | 0.028 → **0.002** | 0.9983 → **0.9998** |

Full updated report: `memory/features/tajweed/phase4a-artifacts/mel_parity_report.json`.

The tiny residual max|Δ| (~0.16, only on samples 01/03) was root-caused: it is
**confined to exactly one mel bin (index 2) and constant across every time frame** —
Android outputs exactly `0.0` there because that bin's pre-normalization value is
constant across time (a near-DC, degenerate/very-narrow filterbank triangle), so its
variance is ~0 and CMVN's `1/(std+1e-5)` blows up any residual floating-point-level
noise from the FFT implementation into an arbitrary-looking value in that one channel.
This is a numerically ill-conditioned normalization edge case shared by all three
implementations on an essentially uninformative bin, not a remaining windowing/signal
bug — confirmed by the fact it affects 100% of frames identically (a per-bin constant),
not audio-content-dependent frames/bins like the original bug did.
**Scope confirmation:** touched only `MelFrontend.swift` (an internal computation
detail). No changes to the Flutter API, `TajweedService`, MethodChannel/EventChannel
names or payloads, JSON schema (ADR-006), or any Android/Kotlin file — all 21 existing
iOS XCTests (including JSON-shape and threading tests) still pass unmodified.
**Performance impact:** neutral-to-positive — the window is now computed once (cached
static) instead of via an Accelerate call on every `logMel()` invocation.
**Priority:** Closed.

## TD-010 — Android pronunciation-head model is only available as a PyTorch checkpoint, not ONNX (RESOLVED 2026-07-29)
**Original description:** Only `tajweed-lab/models/head/pronunciation_head.pt` existed;
`PronunciationHeadModel.kt` required an ONNX file.
**Fix applied:**
- Added `tajweed-lab/scripts/export_pronunciation_head_onnx.py` — wraps
  `PronunciationHead` + baked-in `feature_table` Embedding so mobile I/O stays
  `enc_feature` + `token_id` → `prob_correct` (matches CoreML/native API).
- Produced `models/onnx/pronunciation_head.onnx` (~5.4 MB) + refreshed
  `models/onnx/model_manifest.json` with real SHA-256 digests.
- Android: int64 token ids; transpose ONNX `encoder_output` `(512,T)`→`(T,512)`;
  skip CoreML-style mel bucket padding for ONNX dynamic T; ModelStore external-dir
  + rename activate; `TajweedDebugRunner` + instrumented parity test.
**Verification:** Pixel_7 emulator, all 3 golden clips `exactMatch=true`,
`wordAccuracy=1.0`, ADR-006 JSON shape. See `ai-readiness-report.md`.
**Priority:** Closed.

## TD-011 — iOS `URLSessionAssetTransport.fetchAppending` buffers the whole response body in memory (FIXED 2026-07-30, Android sibling fixed 2026-07-29)
**Description:** `ios/Runner/AssetDownload/AssetTransport.swift`'s
`URLSessionAssetTransport.fetchAppending` used `session.dataTask(with:)` with an
open-ended `bytes=N-` Range request, which hands the **entire remaining response body**
to the completion handler as one in-memory `Data` object before any bytes are written to
disk. For a multi-hundred-MB Tajweed model pack this risked an OOM/jetsam kill, and
separately (the failure mode actually hit) a hard-coded 30s `timeoutInterval` per request
that a single-shot multi-hundred-MB transfer can easily exceed even on a healthy
connection, surfacing as `AssetDownloadError.timeout`.
**How it was found:** iOS's DIY-pack production R2 migration (2026-07-30, see
`memory/features/tajweed/ios-asset-distribution-migration-2026-07-30.md`) was the first
time `catalogURL` was ever set to a real bucket — a live end-to-end fresh-install test
(temporary `XCTestCase`, real network, real ~592MB pack, deleted after use) failed with
`ensureModel failed: timeout` on the ~587MB encoder file. Root cause traced to the fixed
30s per-request timeout applied to a request whose Range header had no upper bound (one
HTTP response covering the whole remaining file).
**Fix:** `fetchAppending` now requests bounded 8MB chunks (`bytes=N-(N+8MB-1)`) instead of
an open-ended range. `AssetDownloadManager`'s existing `while !isComplete` resume loop
already handled multi-chunk transfers correctly (it was simply never exercised before,
since every prior response arrived as a single chunk) — no caller changes needed. This
also fixes the original memory-buffering concern as a side effect: peak per-request
buffer is now ~8MB instead of the full artifact size.
**Verification:** re-ran the same live fresh-install test after the fix — **passed**,
downloaded+verified+activated the real ~592MB pack from production R2 in ~104s. Full
`xcodebuild test -only-testing:RunnerTests` suite (58 tests across `RunnerTests`,
`AssetDownloadManagerTests`, `AIAssetManagerTests`, `TajweedAssetSyncTests`) still green —
no regressions; existing `FakeAssetTransport`-based tests are unaffected since they mock
`AssetTransport` at the protocol level, not `URLSessionAssetTransport`'s internals.
**Priority:** Closed.

## TD-003 — Quran surah detail screen bypasses go_router
**Description:** `lib/features/quran/view/surah_detail_bottom_sheet.dart` is
opened via imperative `Navigator.push` from `QuranTabScreen`, not
`context.go()`/`context.push()`.
**Reason:** Pre-existing, predates this memory system. The Quran tab lives
inside a `IndexedStack` (not a routed screen), and the detail is presented as
a full-screen push on top of the tab bar.
**Risk:** Inconsistent with the documented navigation convention (see
`memory/project/conventions.md`); makes deep-linking into a specific
surah/ayah (relevant for a future "Practice Tajweed" entry point) harder.
**Priority:** Low
**Suggested Resolution:** Leave as-is unless deep-linking or a routed practice
screen is required. If touched, migrate to a go_router route at that time
rather than adding another imperative push nearby.
