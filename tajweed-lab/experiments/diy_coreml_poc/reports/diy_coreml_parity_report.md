# DIY CoreML ↔ Android parity report

> Isolated research experiment. Production iOS/Flutter untouched.

**Verdict:** `HOST_PARITY_OK_BUT_NOT_PRODUCTION_DROP_IN`

DIY CoreML (FP32, fixed mel T=480, host coremltools) matches Android within tolerances on all three golden clips for transcript, pronunciation probs, statuses, and alignment. It does NOT yet replace the gated HF ANE CoreML pack in production: FP16 conversion yields NaN logprobs; the package is not multifunction `predict_T*`; and it is not wired into OfflineAsrModel.

## Tolerances

- Mean |Δprob| ≤ 0.05
- Max |Δprob| ≤ 0.15 (soft)
- Max alignment |Δ| ≤ 0.080001s
- Transcript: diacritic-insensitive exact match vs Android hypothesis
- Token status strings must match when comparing overlapping tokens

## Conversion findings (this POC)

- Pipeline: ONNX → `onnx2torch` → `torch.jit.trace` → `coremltools` 9.0 (direct `source="onnx"` was removed in CT≥8).
- Pronunciation head converts cleanly (small MLP).
- Encoder requires registering `aten::less`→`lt` aliases for CT torch frontend.
- **FLOAT16 encoder is unusable**: all-NaN `logprobs` on golden clip 01 (MIL warning: `overflow encountered in cast`). Hypothesis collapses to `<unk>`.
- **FLOAT32 encoder is numerically faithful** to ONNX on CPU: logprob correlation ≈ 1.0, top-1 argmax agree 100%, CTC token ids identical to ONNX on sample 01.
- Shape: fixed mel `T=480` (covers all three golden clips; not the official multifunction bucket API).
- Runtime for this report: Python `coremltools` host (`ComputeUnit.ALL`), **not** production Swift `OfflineAsrModel`.

## Per-sample

### 01_alafasy_fatihah.wav

- Acceptable: **True**
- Transcript match Android: True
- CoreML exactMatch(expected): True
- Android hyp: `مَالِكِ يَوْمِ الدِّينِ`
- CoreML hyp: `مَالِكِ يَوْمِ الدِّينِ`
- Token counts: android=13 coreml=13
- Mean |Δprob|: 0.0029 (max 0.0219)
- Max |Δalign|: 0.0800s
- Status mismatches: 0

### 02_basfar_ikhlas.wav

- Acceptable: **True**
- Transcript match Android: True
- CoreML exactMatch(expected): True
- Android hyp: `قُلْ هُوَ اللَّهُ أَحَدٌ`
- CoreML hyp: `قُلْ هُوَ اللَّهُ أَحَدٌ`
- Token counts: android=15 coreml=15
- Mean |Δprob|: 0.0000 (max 0.0002)
- Max |Δalign|: 0.0800s
- Status mismatches: 0

### 03_alafasy_naba.wav

- Acceptable: **True**
- Transcript match Android: True
- CoreML exactMatch(expected): True
- Android hyp: `قُلْ هُوَ نَبَأٌ عَظِيمٌ`
- CoreML hyp: `قُلْ هُوَ نَبَأٌ عَظِيمٌ`
- Token counts: android=16 coreml=16
- Mean |Δprob|: 0.0000 (max 0.0000)
- Max |Δalign|: 0.0000s
- Status mismatches: 0

## Recommendation detail

- `all_samples_acceptable`: True
- Conversion notes: `{"encoder": {"pipeline": "onnx\u2192onnx2torch\u2192torch.jit.trace\u2192coremltools", "source": "/Users/rabiadastgir/DeenFocus/tajweed-lab/models/onnx/model_with_encoder.onnx", "flexible": false, "compute_precision": "ComputePrecision.FLOAT32", "t_min": 4800, "t_max": 4800, "seconds": 34.96966290473938, "coremltools": "9.0", "torch": "2.13.0"}, "status": {"coremltools": "9.0", "torch": "2.13.0", "pipeline": "onnx\u2192onnx2torch\u2192torch.jit.trace\u2192coremltools", "compute_precision": "FLOA…`

## Can this replace the gated HF CoreML model?

**Host-side numeric parity: yes. Production drop-in replacement for the gated HF ANE packages: no (not yet).**

Reasons it cannot replace HF ANE packs yet:

1. **FP16 conversion is broken** — default `compute_precision=FLOAT16` produces all-NaN `logprobs` (observed during this POC; MIL pipeline also emitted `overflow encountered in cast`). Only FLOAT32 works.
2. **Not the production API** — official packages expose multifunction `predict_T80…T4800` buckets expected by `OfflineAsrModel.swift`. This DIY artifact is a single fixed `T=480` graph.
3. **ANE / size / latency unproven** — FP32 full-attention FastConformer is unlikely to match upstream ANE windowed-attention packages on device.
4. **Tracer freezing risk** — onnx2torch+jit.trace emitted many TracerWarnings; dynamic length behavior beyond the traced T=480 shape is not guaranteed.

Recommendation: keep ADR-004 (prefer upstream CoreML). Treat this DIY path as a lab unblocker for host-side experiments only. If HF access never arrives, a *separate* productionization project would be required (FP32 or carefully quantized ANE graph, multifunction wrappers, on-device QA) — not a swap of these POC artifacts into `ModelStore`.
