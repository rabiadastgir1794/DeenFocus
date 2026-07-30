# Phase 4A — Cross-Platform Golden Parity Testing (report)

Date: 2026-07-29 · Branch: `feature/Quran` (uncommitted)

Raw data referenced below lives in `tajweed-lab/parity/` (gitignored, regenerable) and
is mirrored for posterity in `memory/features/tajweed/phase4a-artifacts/`.

## 1. Scope actually achievable in this environment

The user's Phase 4A brief asked for 6 things. Status of each:

| Requirement | Status |
| --- | --- |
| Same golden audio samples on iOS and Android | ✅ Used the 3 existing clips in `tajweed-lab/samples/*.wav` (16kHz mono PCM16, 3.7–4.8s each) on both platforms for mel parity |
| Equivalent transcript/alignment/pronunciation score/confidence/JSON | ❌ **Blocked** — see §3. Only a Python-reference transcript (ground truth) was produced |
| Compare Mel spectrogram output between platforms | ✅ Done — real, meaningful result (§2) |
| Validate model integrity (SHA-256 + manifest) | ⚠️ Done for Android with real weights; iOS blocked (no real weights to hash) |
| Run on ≥1 real iPhone and ≥1 real Android device | ❌ **Not met** — no physical device attached to this dev machine (§3) |
| Automated parity report | ✅ This document + `tajweed-lab/scripts/parity_compare_mel.py` (re-runnable) |

## 2. Mel spectrogram parity (real audio) — the headline result

**Method:** the exact production `MelFrontend` code on each platform computed log-mel
features for the same 3 real Quran-recitation clips; a Python script diffed the dumps.

- Python reference: `tajweed-lab/scripts/parity_dump_mel_reference.py` → `tajweed-lab/parity/python/*.json`
- iOS: `RunnerTests.testPhase4AMelParityDumpOnGoldenSamples` (XCTest, runs on Simulator/host) → `/tmp/tajweed_parity/ios/*.json`
- Android: `TajweedMelParityTest.dumpMelForGoldenSamples` (plain JVM test, runs on host — no emulator needed since `MelFrontend.kt` is pure Kotlin) → `/tmp/tajweed_parity/android/*.json`
- Diff: `tajweed-lab/scripts/parity_compare_mel.py` → `tajweed-lab/parity/reports/mel_parity_report.json`

**Result:**

| sample | pair | max\|Δ\| | mean\|Δ\| | correlation |
| --- | --- | --- | --- | --- |
| 01_alafasy_fatihah | python vs ios | 1.653 | 0.042 | 0.9925 |
| 01_alafasy_fatihah | python vs android | 0.818 | 0.010 | 0.9958 |
| 01_alafasy_fatihah | ios vs android | 1.653 | 0.031 | 0.9982 |
| 02_basfar_ikhlas | python vs ios | 1.466 | 0.038 | 0.9974 |
| 02_basfar_ikhlas | python vs android | 0.400 | 0.005 | 0.9990 |
| 02_basfar_ikhlas | ios vs android | 1.466 | 0.033 | 0.9984 |
| 03_alafasy_naba | python vs ios | 2.364 | 0.038 | 0.9924 |
| 03_alafasy_naba | python vs android | 0.829 | 0.010 | 0.9957 |
| 03_alafasy_naba | ios vs android | 2.364 | 0.028 | 0.9983 |

(Full per-sample data: `phase4a-artifacts/mel_parity_report.json`.)

**Interpretation:**
- **Android reproduces the Python reference almost exactly** (mean|Δ| ~0.5–1.0%, no
  large outliers). This confirms the hand-rolled Kotlin FFT + explicit
  `np.hanning`-matching window (TD-008) works correctly on *real* recitation audio, not
  just the synthetic tone used in Phase 3.
- **iOS shows a real, localized divergence** from both Python and Android — traced to a
  specific mel bin/frame (`sample=01_alafasy_fatihah`, mel bin 0, frame 246: iOS=6.69 vs
  Android=8.34 vs Python=8.34 — Android and Python agree to 4 decimal places, iOS does
  not). ~3–4% of feature values per sample exceed a 0.15 absolute-difference threshold in
  this CMVN-normalized log domain, even though the overall correlation stays high
  (≥0.992). This is now tracked as **TD-009** in `memory/technical-debt.md` — the
  previously-documented assumption that CMVN would fully cancel the
  `vDSP_HANN_NORM`-vs-plain-Hann difference (Phase 3 notes) does **not** hold in all
  frames on real audio. **Recommended fix before Phase 4B:** switch iOS to the same
  plain Hann window formula as Android/Python (self-contained change in
  `MelFrontend.swift`), then re-run `parity_compare_mel.py` to confirm closure.

## 3. Why full transcript/score/confidence parity and real-device testing could not run

**iOS real inference — blocked by Hugging Face gate (re-confirmed this session).**
`HfApi.model_info("Muno459/fastconformer-quran-coreml-offline")` succeeds (returns file
listing), which looked like access had been granted — but actually downloading the
`.mlpackage` blobs via `hf_hub_download` (i.e. `tajweed-lab/scripts/download_coreml_offline.py`)
still returns `403 Client Error … Access to model … is restricted`. On Hugging Face,
gated-repo *metadata* and *file content* access are apparently gated separately; this
account has the former but not the latter. **No CoreML weights exist on this machine.**
Only `tokenizer.model`/`tokens.txt` (small, apparently-ungated files) are present under
`tajweed-lab/models/coreml/`. Without the encoder/head `.mlpackage` weights, iOS cannot
run real ASR, so no real iOS transcript/alignment/score/confidence exists to compare.
**Unblock:** ask the repo owner to add this HF account to the gate's approved list for
file downloads (not just re-accept the on-page gate, which was apparently already done),
then re-run the download script.

**Android real pronunciation-head inference — blocked by a missing ONNX export.**
The real ONNX **encoder** (`tajweed-lab/models/onnx/model_with_encoder.onnx`, 458MB) is
already present and was used for the Python-reference-transcript run (§4) and the model
integrity test (§5). But `PronunciationHeadModel.kt` needs `pronunciation-head.onnx`,
and only a PyTorch checkpoint (`tajweed-lab/models/head/pronunciation_head.pt`) exists —
no export step has been run (no `torch` in `tajweed-lab/.venv`). Tracked as **TD-010**.
Real on-device encoder-only inference (transcript, no score) was also not attempted this
session: `onnxruntime-android`'s native `.so` only loads inside an actual Android
runtime (confirmed by the `UnsatisfiedLinkError` fix in Phase 3), so exercising it for
real requires either a physical device or a booted emulator plus a new instrumented-test
harness — scoped as follow-up work, not done in this pass.

**Real device testing — not met.** This dev machine currently has **no physical iPhone
or Android device attached**: `xcrun xctrace list devices` lists all real iPhones as
"Offline"; `adb devices` returns an empty list; `flutter devices` only found the iOS
Simulator, macOS, and Chrome. Everything in this report ran on iOS Simulator (mel dump
only — no real inference was possible anyway) and the host JVM/Robolectric (Android unit
tests, which don't require an emulator for pure-Kotlin code, but also can't load the
native ONNX `.so` for real inference — see above). **To finish this requirement:**
connect a physical iPhone (Xcode → Window → Devices, trust device) and a physical
Android device (`adb devices` should list it after enabling USB debugging) and re-run
the relevant test targets from this repo directly on them.

## 4. Python reference transcripts (ground truth for future comparison)

Ran the **same ONNX encoder** Android's `OnnxAsrModel.kt` uses through the existing lab
pipeline (`tajweed-lab/scripts/parity_dump_reference_transcripts.py`):

| sample | transcript | audio | inference |
| --- | --- | --- | --- |
| 01_alafasy_fatihah.wav | مَالِكِ يَوْمِ الدِّينِ | 4.68s | 1070ms (cold) |
| 02_basfar_ikhlas.wav | قُلْ هُوَ اللَّهُ أَحَدٌ | 3.66s | 138ms (warm) |
| 03_alafasy_naba.wav | قُلْ هُوَ نَبَأٌ عَظِيمٌ | 4.75s | 108ms (warm) |

(Full JSON: `phase4a-artifacts/python_reference_transcripts.json`.) These are short
single-ayah clips (not full surahs) — expected given the ~4s durations. This is the
ground truth to diff against once iOS and Android can both run real inference.

## 5. Model integrity (SHA-256 + manifest)

**Android — real, passing.** `TajweedModelIntegrityTest`
(`android/app/src/test/kotlin/com/app/deenly/deenly/tajweed/TajweedModelIntegrityTest.kt`,
Robolectric) drove `ModelStore.installFromDirectory`/`verifyStaging` against the actual
local ONNX artifacts:
- `model_with_encoder.onnx` — sha256 `417da4c1ead548ffe8bd802fd3d256f065ca180fb191818a3914f43f824bef0` (458,253,686 bytes)
- `tokenizer.model` — sha256 `1fcfa104fa448c979cc2537788947c6516827f403ecdc55c4895b77d28630ba`
- `tokens.txt` — sha256 `7e6e2b04eb263747ed13f91c22cdfa948b2bf175b7ed67611a942884535f278`

Two tests: (1) a correctly-hashed manifest installs and activates, `isAvailable()` is
then true; (2) a manifest with a deliberately wrong encoder hash is rejected
(`MODEL_DOWNLOAD_FAILED`) and never becomes the active pack. The pronunciation-head
artifact used in these tests is a small synthetic placeholder (its own SHA-256 is real
and verified; its *content* is not real head weights — see TD-010), since no real head
ONNX exists yet. This still validates the verification *mechanism* end-to-end.

**iOS — not run for real.** No real `.mlpackage` files exist locally (§3), so there is
nothing to hash. iOS's manifest/verify logic itself was already exercised with synthetic
placeholder files in Phase 2 (`testModelStoreReportsUnavailableWhenNothingInstalled`,
etc.) — no new information here.

## 6. Files created/modified this phase

**New:**
- `tajweed-lab/scripts/parity_dump_mel_reference.py`
- `tajweed-lab/scripts/parity_compare_mel.py`
- `tajweed-lab/scripts/parity_dump_reference_transcripts.py`
- `ios/RunnerTests/RunnerTests.swift` — added `testPhase4AMelParityDumpOnGoldenSamples` + helpers (no existing tests changed)
- `android/app/src/test/kotlin/com/app/deenly/deenly/tajweed/TajweedMelParityTest.kt`
- `android/app/src/test/kotlin/com/app/deenly/deenly/tajweed/TajweedModelIntegrityTest.kt`
- `memory/features/tajweed/phase4a-golden-parity-report.md` (this file)
- `memory/features/tajweed/phase4a-artifacts/{mel_parity_report.json,python_reference_transcripts.json}`

**Modified:**
- `.gitignore` — added `tajweed-lab/parity/` (regenerable numeric dumps)
- `memory/current-state.md`, `memory/features/tajweed/overview.md`, `memory/technical-debt.md` (TD-008 updated/downgraded, TD-009 and TD-010 added)

No Flutter, iOS production, or Android production code was touched — only test targets
and lab scripts, per "do not start Flutter UI or new features."

## 7. Performance benchmarks

Cold/warm model load and on-device inference timing (the ADR-007 targets: warm load
<500ms, inference <2s) **still cannot be measured on either platform** — both remain
blocked on real weights being loaded through the actual native engines (iOS: HF gate;
Android: real device/emulator + pronunciation-head export). The one real timing data
point obtained is the **Python-reference** ONNX encoder inference time on this Mac
(§4: ~108–1070ms per ~4s clip, cold vs warm) — useful as a rough sanity check that the
model itself is fast enough, but not a substitute for on-device (especially
mobile-CPU/NNAPI/ANE) measurements.

## 8. Remaining issues / required decisions before Phase 4B

1. **Fix TD-009** (iOS Hann window) and re-run `parity_compare_mel.py` to confirm it closes the gap.
2. **Unblock the HF gate for real file downloads** (metadata access ≠ download access) — needs the repo owner's action, not something fixable from this environment.
3. **Export `pronunciation_head.pt` → ONNX** for Android (TD-010).
4. **Get physical iPhone + Android hardware** connected for real-device validation once 1–3 are resolved.
5. Once 2–4 are done, re-run full Phase 4A (transcript/alignment/score/confidence parity, on-device benchmarks) for real before Phase 4B/5 UI work.

Given the scope of what's actually achievable right now, recommend treating this as
**Phase 4A partial** and deciding explicitly whether to (a) proceed to Phase 4B/5 with
these known gaps clearly flagged, (b) pause until the HF gate + ONNX export are
resolved, or (c) fix TD-009 now (small, low-risk) while waiting on the rest.

---

## Addendum (2026-07-29) — TD-009 fixed and re-verified

Per approval, fixed TD-009 before any Flutter/UI work. See `memory/technical-debt.md`
TD-009 for full detail. Summary:

**Change:** `ios/Runner/Tajweed/MelFrontend.swift` — replaced
`vDSP_hann_window(..., vDSP_HANN_NORM)` with a manually-computed Hann window using the
exact same formula as `MelFrontend.kt`/`mel.py` (`0.5 - 0.5*cos(2*pi*i/(N-1))`), cached
once as a `private static let`. Nothing else in the pipeline changed.

**Re-verified parity** (same harness, same 3 real golden clips, iOS dumps regenerated
via a fresh `xcodebuild test` run):

| sample | pair | max\|Δ\| | mean\|Δ\| | correlation |
| --- | --- | --- | --- | --- |
| 01_alafasy_fatihah | ios vs android | 0.160 (was 1.653) | 0.002 (was 0.031) | 0.9998 (was 0.9982) |
| 02_basfar_ikhlas | ios vs android | 0.003 (was 1.466) | 0.0000 (was 0.033) | 1.0000 (was 0.9984) |
| 03_alafasy_naba | ios vs android | 0.160 (was 2.364) | 0.002 (was 0.028) | 0.9998 (was 0.9983) |

python vs ios also improved (mean|Δ| 0.038→0.012, correlation 0.992→0.994).

**Root-cause of the tiny residual (0.16 max):** confirmed via a targeted diff that it's
confined to exactly one mel bin (index 2), identically across every time frame in a
sample. Android returns exactly `0.0` there because that bin's raw value is constant
across time for these clips (a near-DC/degenerate filterbank triangle), so its variance
is ~0 and CMVN's `1/(std+1e-5)` term amplifies ordinary FFT-implementation-level
floating-point noise into an arbitrary-looking value in that one channel — on all three
platforms independently (Python itself shows a large value there too, e.g. -0.82,
different again from both iOS and Android). This is a shared numerical edge case on an
essentially uninformative bin, not a remaining cross-platform bug: the previous
error was audio-content-correlated across many bins/frames; this one is a constant,
isolated single-bin artifact.

**Scope confirmation:** only `ios/Runner/Tajweed/MelFrontend.swift` changed. No changes
to `TajweedService`/Flutter, MethodChannel/EventChannel method names or payloads, the
ADR-006 JSON schema, or any Android/Kotlin file. All 21 existing iOS XCTests
(`ios/RunnerTests/RunnerTests.swift`, including the JSON-shape and threading tests)
pass unmodified — re-ran the full `RunnerTests` target after the fix, not just the new
parity test.

**Performance impact:** neutral-to-slightly-positive. The Hann window is now computed
once per process (cached static), versus once per `logMel()` call via an Accelerate
API call before. No inference-path (FFT, mel projection, CMVN) code changed.

**Conclusion:** iOS and Android mel/preprocessing are now equivalent for practical
purposes. Remaining Phase 4A gaps (HF gate blocking real iOS weights, TD-010 blocking
Android's pronunciation head, no physical device in this environment) are unchanged by
this fix — see §3 above.
