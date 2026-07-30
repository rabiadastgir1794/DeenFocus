# DIY functional CoreML from `fastconformer-quran.nemo` — production-pipeline attempt (2026-07-30)

> Follow-up to `nemo-checkpoint-coreml-feasibility-2026-07-30.md`. That report answered
> "can this `.nemo` reproduce the **official ANE-optimized** package?" (no). This report
> answers a **different, explicitly narrower** question the user asked next: "ignore ANE
> parity — can we get a *functional* self-generated CoreML model wired into the real iOS
> pipeline, and what does it cost?"

## TL;DR

| Question | Answer |
|---|---|
| Does it work (loads, transcribes, scores)? | **Yes**, on host (Mac, `coremltools`) — not yet run on a physical iPhone (see "What still needs a real device" below). |
| Is accuracy acceptable? | **Yes on the 3 golden clips** — exact transcript match, pronunciation-head parity, identical to Android within tolerance. |
| Is latency acceptable? | **Unknown for real usage / likely poor for short clips** — host CPU+GPU latency is 1.6–3.0s per inference because the exported model is a **fixed-shape 48s graph that runs full cost on every clip**, regardless of actual length. iPhone numbers are needed (instrumented and ready — see handoff). |
| CPU, GPU, or ANE? | On this Mac, only `CPU_ONLY`, `CPU_AND_GPU`, or `CPU_AND_NE` build a working execution plan — **`ALL` (CPU+GPU+ANE together) fails to compile** (CoreML partitioner error -6). The existing Swift code already requests `.cpuAndNeuralEngine`, which loads and predicts successfully on host; whether the Neural Engine is *actually* dispatched (vs. silently falling back to CPU) can only be confirmed on a real device via Instruments. |

**Bottom line:** this is a working, verified, self-generated model — a genuine "yes" to
the narrower question asked. It is **not** a drop-in size/latency replacement for the
official ANE package (587 MB vs. the ~210 MB official estimate; full-48s-cost-always vs.
bucketed cost), and real on-device latency/ANE-dispatch is still unmeasured. Treat it as
a validated fallback path, not yet a production launch decision.

## What was verified (this session, all real, no simulated data)

### 1. The `.nemo` checkpoint *is* the source of `models/onnx/model_with_encoder.onnx`
Byte-level tensor comparison (SHA-256 fingerprint of each tensor's raw float32 bytes,
`.nemo`'s `model_weights.ckpt` vs. the ONNX graph's initializers):
- CTC decoder (the actual output/vocabulary head) weight + bias: **byte-identical**.
- All 194 2D encoder weight tensors: **188/194 match** the ONNX initializers either
  directly or transposed (expected — PyTorch `nn.Linear` weight `(out,in)` vs. ONNX
  `MatMul` convention `(in,out)`).
- The remaining 6 "no match" tensors are all **RNNT decoder/joint-network** parameters
  (`decoder.prediction.*`, `joint.*`) that don't exist in the CTC-only ONNX graph at
  all — expected, not a discrepancy.
- **Conclusion:** the existing lab ONNX (already used for Android production) is a
  direct export of this exact `.nemo`'s weights. No new ONNX export was needed to
  honestly claim the resulting CoreML model is "generated from `fastconformer-quran.nemo`."

### 2. Regenerated a functional (non-ANE) CoreML encoder, fixed at the full 48s cap
Prior DIY POC artifacts used a small fixed shape (`T=480` mel frames ≈ 4.8s), which is
too short for real Tajweed practice clips (production allows up to 48s / `T=4800`,
matching the official multifunction package's largest bucket). Re-ran the existing
`tajweed-lab/experiments/diy_coreml_poc/convert_onnx_to_coreml.py` pipeline
(`ONNX → onnx2torch → torch.jit.trace → coremltools`) with a new configurable `fixed_t`:
- **FP32, fixed `(1, 80, 4800)` `audio_signal` input + explicit `(1,) int32 length` input.**
- Attempted a `RangeDim` (dynamic-length) export first — it *converts* without error, but
  **fails at runtime** for any length other than the traced example (`"Error in
  dynamically resizing for sequence length (error: -7)"`). Confirms the pre-existing
  "tracer freezing risk" finding: this pipeline cannot produce a true dynamic-shape
  model, only fixed-shape ones. Stuck with fixed `T=4800`.
- Verified the `length` input is **not optional** — passing the padded shape (4800)
  instead of the true unpadded frame count measurably corrupts output (a real example:
  correct length gives `مَالِكِ يَوْمِ الدِّينِ`, wrong length gives `مَالِكِ يَوْمِ الدِّين` — dropped
  final vowel mark). The Swift wiring passes the true length.
- Artifacts: `tajweed-lab/experiments/diy_coreml_poc/artifacts/encoder.mlpackage`
  (587 MB) + `pronunciation_head.mlpackage` (5.1 MB, unchanged from the prior POC).

### 3. Host-side pipeline verification (transcript + lexical + pronunciation), fresh run
Reused the existing `run_coreml_e2e.py` / `compare_to_android.py` harness (same mel /
CTC / forced-alignment / scoring code as the Python reference and as production), fixed
shapes updated to `T=4800`:

```
01_alafasy_fatihah.wav: hyp='مَالِكِ يَوْمِ الدِّينِ' exact=True acc=1.00 tokens=13 infer=2975ms
02_basfar_ikhlas.wav:   hyp='قُلْ هُوَ اللَّهُ أَحَدٌ'   exact=True acc=1.00 tokens=15 infer=1583ms
03_alafasy_naba.wav:    hyp='قُلْ هُوَ نَبَأٌ عَظِيمٌ'    exact=True acc=1.00 tokens=16 infer=1896ms
```

`compare_to_android.py` verdict: **`HOST_PARITY_OK_BUT_NOT_PRODUCTION_DROP_IN`** — all 3
samples pass transcript, pronunciation-probability (mean |Δprob| ≤ tolerance), alignment,
and token-status-match checks against the real Android golden parity JSON. This confirms:
transcription works, lexical-first scoring works (exact match against expected text), and
pronunciation-head scoring works, on real audio, with real weights, end-to-end — just not
yet through the Swift pipeline (until this session's changes) and not yet on a phone.

Full reports (regenerated this session):
`tajweed-lab/experiments/diy_coreml_poc/reports/diy_coreml_e2e_scores.json` and
`diy_coreml_parity_report.{md,json}`.

**Compute-unit finding (host):** `ct.ComputeUnit.ALL` fails to build an execution plan
for this model on this Mac (`error: -6`, MIL partitioner), while `CPU_ONLY`,
`CPU_AND_GPU`, and `CPU_AND_NE` each work individually for both loading *and*
`predict()`. The host harness now uses `CPU_AND_GPU`.

### 4. Minimal iOS Swift changes to load a single-function DIY package
Made the smallest change set that lets `OfflineAsrModel`/`TajweedEngine` load *either*
the official multifunction ANE package *or* a DIY single-function fixed-length package,
selected by a new manifest field (no other production behavior changed):

- `ios/Runner/Tajweed/OfflineAsrModel.swift` — new `EncoderApi` enum
  (`.multifunction` / `.singleFunctionFixedLength(t:)`); `predict(mel:time:)` replaces
  `predict(melPadded:bucketT:)` and internally branches: multifunction keeps the
  original bucket-function-name dispatch untouched; single-function pads to the fixed
  `T`, builds an explicit `length` `MLMultiArray`, and loads the model once with
  `.cpuAndNeuralEngine` (same compute-unit config as before — validated to work on host
  as `CPU_AND_NE`). Also fixed a latent output-layout bug while adding this: the DIY
  export's `encoder_output` is `(1, 512, T)` (ONNX channel-first) vs. the assumed
  `(1, T, 512)` — `parseOutputs` now detects the layout from shape instead of assuming.
- `ios/Runner/Tajweed/MelFrontend.swift` — added `padToFixed(_:time:fixedT:)` alongside
  the untouched `padToBucket`.
- `ios/Runner/Tajweed/ModelStore.swift` — added `encoderApi()` reading two new optional
  manifest keys (`encoderApi`, `encoderFixedT`); absent → `.multifunction` (zero behavior
  change for the official package / existing manifests).
- `ios/Runner/Tajweed/TajweedEngine.swift` — `score()` now calls
  `asr.predict(mel:time:)` directly (bucket/fixed-shape decision moved into
  `OfflineAsrModel`); `warmLoadLocked()` passes `ModelStore.shared.encoderApi()` into
  `asr.load(packageURL:encoderApi:)`.

**Verified no regressions:** `xcodebuild ... -scheme Runner -sdk iphonesimulator build`
— **BUILD SUCCEEDED**. `xcodebuild ... test -only-testing:RunnerTests` — **TEST
SUCCEEDED, 53/53 passing** (all pre-existing Tajweed/mel/asset-manager suites, including
`testMelFrontendProducesExpectedFrameCountAndBucket`,
`testMelFrontendRejectsAudioLongerThan48Seconds`, and the Phase 4A mel-parity dump).

### 5. DIY device pack assembled for on-device install
`tajweed-lab/experiments/diy_coreml_poc/device_pack/` — ready to copy to the app's
`Documents/TajweedImport` on a real device:
- `diy-fastconformer-encoder.mlpackage` (587 MB), `diy-pronunciation-head.mlpackage` (5.1 MB)
- `tokenizer.model`, `tokens.txt` (identical SHA-256 to production lab copies)
- `model_manifest.json` with `"encoderApi": "single_function_fixed"`,
  `"encoderFixedT": 4800`, empty `"sha256": {}` (skips hash gating for this debug pack).

## What this does *not* claim / known limitations

1. **Size: 587 MB vs. ~210 MB official estimate** (`ADR-008` §catalog example). This is
   an FP32, full-utterance, non-quantized, always-full-length graph — a real cost of
   skipping ANE optimization, not a bug.
2. **Latency scales with the fixed cap, not the clip.** Because the graph is a single
   fixed `T=4800` (48s) shape, a 3-second recitation pays the same compute as a
   48-second one. Host CPU+GPU: 1.6–3.0s/clip on this Mac. A phone's real number could be
   better (dedicated GPU/ANE silicon) or worse (thermal/power limits) — genuinely unknown
   until measured on-device.
3. **The dynamic-length (`RangeDim`) export does not work at runtime** on this
   onnx2torch→coremltools pipeline (converts, but fails at inference for non-traced
   lengths) — confirmed by direct test this session, not just inferred. A per-bucket
   multi-package approach (like the official `predict_T80…T4800`) was *not* attempted —
   it would require 7 separate ~500 MB+ exports, an unreasonable multiple of app size for
   this iteration.
4. **`ComputeUnit.ALL` does not work for this graph on this Mac.** The Swift code already
   avoids this (`.cpuAndNeuralEngine`, not `.all`), and that specific combination is
   confirmed to build/predict correctly on host — but "does CoreML actually schedule any
   ops onto the ANE, or silently run 100% CPU/GPU" is not observable from `coremltools`
   or plain Swift code; it requires an Instruments Core ML trace on a real device.
5. **No real iPhone was used this session** — this dev environment has no attached
   physical device or usable iOS Simulator boot in some runs (CoreSimulator sandboxing
   issues, unrelated to this change; a plain iPhone 15 simulator did successfully run the
   full unit-test suite). All latency/accuracy numbers above are **host Mac**, not device.

## What still needs a real device (handoff)

The existing `#if DEBUG` harness (`ios/Runner/Tajweed/Debug/TajweedDebugRunner.swift`,
unchanged) already does exactly this measurement — cold/warm timings, JSON score
report — it just needs to be triggered on real hardware:

1. Build `Runner` to your iPhone in Xcode (Debug config, your device as the run
   destination).
2. Copy `tajweed-lab/experiments/diy_coreml_poc/device_pack/` onto the device via
   Xcode's **Window → Devices and Simulators → (your device) → Installed Apps → Deenly →
   Download/Add Files** into the app's `Documents/TajweedImport` folder (create it if
   needed) — this is the same debug import path `ModelStore.ensureModel()` already checks
   first, so no code change is needed to pick it up.
3. Also copy one or more of `tajweed-lab/samples/*.wav` onto the device (e.g. into the
   same `Documents/` folder via the same Devices window).
4. Temporarily add one call (not a permanent commit — revert after testing) inside
   `AppDelegate.swift`'s `application(_:didFinishLaunchingWithOptions:)`, guarded by
   `#if DEBUG`:
   ```swift
   #if DEBUG
   let docs = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
   TajweedDebugRunner.runSamplePipeline(
     modelDirectory: docs.appendingPathComponent("TajweedImport"),
     wavPath: docs.appendingPathComponent("01_alafasy_fatihah.wav"),
     expectedArabic: "مَالِكِ يَوْمِ الدِّينِ",
     surah: 1, ayah: 4
   )
   #endif
   ```
5. Run on the device, watch the Xcode console for
   `[TajweedDebug] === score JSON ===` (full ADR-006 report incl. `wordAccuracy`,
   `exactMatch`, per-token pronunciation) and
   `[TajweedDebug] timings coldSetupMs=... totalWarmPathMs=... detail=[...]`
   (`warmOrReuseMs`, `inferenceMs`).
6. For CPU/GPU/ANE dispatch: **Xcode → Product → Profile → Core ML template**
   (Instruments), reproduce the same run, and read the "Neural Engine"/"GPU"/"CPU"
   utilization lanes — this is the only reliable way to confirm actual ANE usage; the
   `MLModelConfiguration.computeUnits` setting is a *request*, not a guarantee.

## Files touched this session

**Production Swift (minimal, backward-compatible — official-package path byte-for-byte
unchanged when `encoderApi` manifest key is absent):**
- `ios/Runner/Tajweed/OfflineAsrModel.swift`
- `ios/Runner/Tajweed/MelFrontend.swift`
- `ios/Runner/Tajweed/ModelStore.swift`
- `ios/Runner/Tajweed/TajweedEngine.swift`

**Lab-only (no production impact):**
- `tajweed-lab/experiments/diy_coreml_poc/convert_onnx_to_coreml.py` (added `fixed_t` param)
- `tajweed-lab/experiments/diy_coreml_poc/run_coreml_e2e.py` (fixed `FIXED_T=4800`,
  swapped `ComputeUnit.ALL`→`CPU_AND_GPU` after confirming `ALL` fails to compile here)
- `tajweed-lab/experiments/diy_coreml_poc/artifacts/encoder.mlpackage` (regenerated,
  T=4800 instead of T=480)
- `tajweed-lab/experiments/diy_coreml_poc/device_pack/` (new — install-ready pack)
- `tajweed-lab/experiments/diy_coreml_poc/reports/*` (regenerated)

No Flutter/Dart, Android/Kotlin, or ADR-006 JSON schema changes.
