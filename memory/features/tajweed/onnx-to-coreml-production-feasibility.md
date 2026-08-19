# Feasibility: Production-quality CoreML from existing ONNX encoder

**Date:** 2026-07-29  
**Scope:** Research only. No production migration. DIY POC remains isolated under
`tajweed-lab/experiments/diy_coreml_poc/`.  
**Question:** Can `models/onnx/model_with_encoder.onnx` be exported to a CoreML
package that satisfies *all* of:

1. Variable-length input **or** the existing bucket strategy  
2. Multifunction interface expected by `OfflineAsrModel` (`predict_T*`)  
3. Correct FP16 inference without NaNs  
4. Transcript parity with the ONNX model  

**Conclusion:** **No — not reasonably, from the artifacts we have.**  
Permanently keep the official
`Muno459/fastconformer-quran-coreml-offline` ANE package as the production iOS
source (ADR-004). Close this investigation.

---

## Executive answer (four requirements)

| Requirement | Feasible from our ONNX? | Why |
| --- | --- | --- |
| Variable length / buckets | Partially (engineering only) | CT can convert fixed shapes + stitch multifunction; flexible `RangeDim` is fragile on this graph. Buckets are *packaging*, not present in ONNX. |
| `predict_T*` multifunction | Not via direct export | `ct.convert` emits a single `main` function. Multifunction is a *post-hoc merge* of N converted packages (`MultiFunctionDescriptor` / `save_multifunction`), iOS 18+. |
| FP16 without NaNs | **No with this graph** | DIY POC: FP16 → all-NaN `logprobs` + MIL `overflow encountered in cast`. ONNX has **full** self-attention, **zero** window nodes. Official pack uses **windowed attention + pos-enc clamps** for ANE/fp16. |
| Transcript parity vs ONNX | Yes only in FP32 host POC | FP32 fixed-T=480 matched ONNX/Android on 3 golden clips. That path fails the FP16 + ANE + multifunction production bar. |

Meeting all four simultaneously from the available ONNX file would require
**re-engineering the encoder** (not a standard conversion), which we do not have
sources/recipes for.

---

## 1. Does CoreML Tools support this export directly?

**Short answer: No.**

### What CT can do today (v9)

- **Direct ONNX import:** Removed. Path is ONNX → `onnx2torch` → `torch.jit.trace` →
  `ct.convert` (as used in the DIY POC).
- **Single conversion:** Produces one `mlprogram` function named `main`, optionally
  with fixed shape or `RangeDim` on time.
- **Multifunction packages:** Supported *separately* via
  `coremltools.utils.MultiFunctionDescriptor` + `save_multifunction` — you convert
  several specialized models, then merge them under names like `predict_T480`,
  sharing weights by hash. This is documented for iOS 18+ / macOS 15+ and matches
  how `OfflineAsrModel` loads `config.functionName = "predict_T\(bucketT)"`.

There is **no** API of the form “convert this ONNX once and emit
`predict_T80…predict_T4800`.”

### What production Swift expects

From `ios/Runner/Tajweed/OfflineAsrModel.swift` + `MelFrontend.padToBucket`:

- Buckets: `[80, 160, 320, 640, 1280, 2560, 4800]`
- Function names: `predict_T80` … `predict_T4800` (those discrete values)
- Compute units: `.cpuAndNeuralEngine` (iOS 16+)
- Input: padded mel `(1, 80, T_bucket)` — **no `length` tensor** in the Swift path
  (unlike ONNX, which takes `audio_signal` + `length`)

So even a successful flexible-shape DIY model would need API reshaping (drop
`length`, pad-only) to match `OfflineAsrModel` without changing production code —
and the user forbade production architecture changes for this investigation.

---

## 2. Would additional graph transformations be required?

**Yes — substantial ones, beyond “run the converter.”**

| Gap | Transformation needed | Available in repo? |
| --- | --- | --- |
| Full attention → ANE-stable attention | Replace / mask self-attn with **windowed attention** (documented upstream requirement) | **No** — ONNX has 0 `window*` nodes; 17 `self_attn/Softmax` layers |
| FP16 overflow / NaNs | **Pos-enc clamps**, careful cast placement, possibly Softmax/attention fp32 islands | **No** recipe; only observed failure mode in DIY POC |
| Dynamic `T_in` + `length` | Specialize per bucket (fixed T), or reliable `RangeDim`; drop `length` for Swift contract | Possible as packaging; not “free” from one ONNX convert |
| Multifunction `predict_T*` | Convert × N bucket shapes, `save_multifunction`, name functions | Possible in CT; expensive; still blocked by FP16 |
| Torch frontend gaps | Register `aten::less`→`lt` (and similar) | Minor; already solved in POC |
| Trace freezing | Avoid `jit.trace` baking dynamic ops as constants (many TracerWarnings in POC) | Needs scripted/export path or per-bucket re-trace |

The decisive missing piece is **not** multifunction stitching. It is the
**ANE/fp16-oriented encoder graph** that upstream built into the official
`.mlpackage` and that is **absent** from `model_with_encoder.onnx`.

---

## 3. Where does the missing behaviour come from?

Blame is shared, but the **blocking** cause is the ONNX artifact’s architecture
relative to ANE, amplified by CT’s FP16 pipeline.

### A. The ONNX model itself (primary for FP16 / ANE)

Evidence from `model_with_encoder.onnx`:

- Inputs: dynamic `audio_signal ['B', 80, 'T_in']` + `length ['B']`
- ~3830 nodes; self-attention Softmax present; **no windowed-attention nodes**
- Exported for ONNX Runtime (Android path), not for Neural Engine

Upstream docs (`tajweed-lab/docs/MODEL.md`, ADR-004, integration plan) state
explicitly that offline CoreML uses **windowed attention for ANE/fp16 stability**,
and that naive full-attention fp16 on ANE yields **empty / broken transcripts**
(e.g. Basmala). Our DIY POC reproduced the numeric half of that story: FP16
conversion → NaN logprobs → `<unk>`.

So: the ONNX file is a valid **CPU/ORT** encoder. It is **not** the same graph as
the production ANE package.

### B. CoreML Tools (primary for “no direct multifunction / ONNX”)

- No direct `source="onnx"` in CT 9
- `compute_precision=FLOAT16` on this graph: MIL overflow warnings + NaN outputs
  (POC evidence)
- Multifunction is merge-only, not convert-from-ONNX
- Flexible shapes via `RangeDim` are not a substitute for upstream’s specialized
  bucket functions and still wouldn’t fix FP16

### C. The conversion pipeline (amplifies both)

- `onnx2torch` + `torch.jit.trace` with fixed example T freezes dynamic behavior
  (TracerWarnings on Shape/Slice/Range/Expand/Pad)
- Extra op-alias shims required
- FP32 path proves weights can round-trip for short clips; FP16 path destroys
  numerics — i.e. the failure is precision/graph, not “wrong weights file”

**Summary attribution**

| Symptom | Dominant cause |
| --- | --- |
| No `predict_T*` out of the box | CoreML Tools + packaging model (solvable with N converts + merge) |
| FP16 NaNs / ANE emptiness risk | ONNX full-attention graph (needs upstream-style transforms we don’t have) |
| Trace / flexible-length fragility | Conversion pipeline |
| Host FP32 parity OK | Confirms weights OK; does **not** unlock production ANE |

---

## 4. Can this realistically replace the official CoreML package?

**No.**

To replace `fastconformer-quran-offline-ane.mlpackage` you would need all of:

1. Windowed-attention (or equivalent) **source** or a validated rewrite of the
   ONNX graph — **not in this repo**
2. FP16-stable conversion that runs on ANE without NaNs / empty transcripts —
   **failed with stock CT on current ONNX**
3. Multifunction `predict_T{80,160,320,640,1280,2560,4800}` matching
   `OfflineAsrModel` — engineering effort only *after* (1–2)
4. On-device parity vs ONNX **and** vs official CoreML golden behavior —
   blocked on (2)
5. Size/latency competitive with upstream ANE pack — FP32 full-attention is the
   wrong product shape for Neural Engine

A hypothetical “convert all 7 buckets in FP32 and ship CPU-only CoreML” would
still **change** the production compute path (abandon ANE), inflate memory, and
violate the locked decision to ship the upstream ANE package. That is a product
architecture change, not a conversion unlock — and it was out of scope here.

### What *did* work (and what it means)

The isolated DIY POC showed: **FP32, fixed T=480, host coremltools** can match
Android/ONNX transcripts and scores on the three golden WAVs. That is useful as
a lab reference. It is **not** a production CoreML substitute.

---

## Recommendation (investigation closed)

1. **Permanently keep** the official Hugging Face / self-hosted
   `fastconformer-quran-coreml-offline` ANE `.mlpackage` as the **only**
   production iOS ASR source (reaffirm ADR-004).
2. **Do not** invest further in ONNX→CoreML productionization from
   `model_with_encoder.onnx` unless upstream releases conversion scripts or a
   windowed-attention PyTorch/ONNX export specifically for ANE.
3. Keep the DIY POC under `tajweed-lab/experiments/diy_coreml_poc/` as archived
   research; do not wire it into `ModelStore` / `OfflineAsrModel`.
4. Resume production iOS validation when official CoreML weights are obtainable
   (HF gate or self-hosted ADR-008 catalog) — not via DIY conversion.

**Investigation status: CLOSED.**
