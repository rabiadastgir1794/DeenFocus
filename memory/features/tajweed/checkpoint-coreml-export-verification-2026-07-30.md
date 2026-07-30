# Verification: can our own checkpoints export production CoreML directly?

**Date:** 2026-07-30
**Scope:** Read-only verification. No application code changed. No model files
modified. Answers whether `models/conformer/checkpoint.pt` +
`models/conformer/export_coreml.py` and `models/head/pronunciation_head.pt` +
`models/head/export_coreml.py` (as referenced by the request) can generate
production `.mlpackage` files without depending on the Hugging Face CoreML repo.

## Verdict

| Referenced file | Exists in repo? | Can it produce production CoreML directly? |
| --- | --- | --- |
| `models/conformer/checkpoint.pt` | **No** | N/A — file does not exist |
| `models/conformer/export_coreml.py` | **No** | N/A — file does not exist |
| `models/head/pronunciation_head.pt` | **Yes** — `tajweed-lab/models/head/pronunciation_head.pt` | **Partially** — via an existing two-hop pipeline, not a single script |
| `models/head/export_coreml.py` | **No** (as a single script) | See below — the pipeline exists as two chained scripts |

**Bottom line: the conformer encoder cannot be exported to CoreML from artifacts
we currently own — not because a script is missing, but because the underlying
PyTorch/NeMo checkpoint itself is missing and the architecture transform
(windowed attention for ANE/FP16) is undocumented and unavailable to us. The
pronunciation head *can* be exported to a working `.mlpackage` today using
existing lab scripts (already run once, artifact already on disk), but not via
a single "export_coreml.py" — it's `pt → onnx → coreml` across two existing
scripts.**

---

## 1. Conformer encoder — missing dependency chain

Searched the entire repo (`find . -iname "*.pt" -o -iname "*.nemo"`, excluding
`.venv`): the **only** artifacts we own for the encoder are:

- `tajweed-lab/models/onnx/model_with_encoder.onnx` (437 MB, ONNX Runtime export)
- `tajweed-lab/models/coreml/fastconformer-quran-offline-ane.mlpackage` (the
  **official upstream HF CoreML pack**, downloaded via
  `scripts/download_coreml_offline.py` — this *is* the Hugging Face dependency
  the request wants to avoid)

There is **no raw PyTorch `checkpoint.pt` and no NeMo `.nemo` checkpoint**
anywhere in this repo, gitignored or not. Per `tajweed-lab/docs/MODEL.md`, the
upstream repo's own checkpoint format is `nemo/fastconformer-quran.nemo` (NeMo,
not a plain `.pt` state dict) — we never downloaded or vendored that file, only
its ONNX export and the official CoreML export.

Missing, in order of what would need to exist before any export script could run:

1. **The checkpoint itself** — `nemo/fastconformer-quran.nemo` (or an
   equivalent raw PyTorch state dict). Not present locally; would require
   downloading it from the gated HF repo (the exact dependency being avoided),
   since it was never vendored.
2. **The NeMo toolkit** — `tajweed-lab/requirements.txt` has no `nemo_toolkit`
   entry; the lab venv cannot load a `.nemo` file today even if one existed.
3. **An export script** — no `export_coreml.py` exists for the conformer
   anywhere in the repo (`find . -iname "export_coreml*.py"` → 0 results). The
   closest artifact is the *research* script
   `tajweed-lab/experiments/diy_coreml_poc/convert_onnx_to_coreml.py`, which
   converts the **ONNX** encoder (not a `.pt`/`.nemo` checkpoint) via
   `onnx2torch → torch.jit.trace → coremltools`.
4. **The ANE/FP16 architecture transform** — even with (1)–(3), the closed
   investigation in
   [`onnx-to-coreml-production-feasibility.md`](onnx-to-coreml-production-feasibility.md)
   found the official CoreML pack uses **windowed attention** for ANE/FP16
   stability that is **absent** from our ONNX graph (0 window nodes; full
   self-attention). Converting our ONNX/checkpoint with stock `coremltools` in
   FP16 produces **all-NaN logprobs**; only FP32 (CPU-only, non-ANE, single
   fixed shape, no multifunction) round-trips numerically. That is a research
   artifact, not a production-shippable pack (see ADR-004, reaffirmed).

**Conclusion:** this is not a "missing script" problem for the encoder — it's a
missing-checkpoint + missing-toolkit + missing-architecture-recipe problem.
Nothing here can be fixed by writing an `export_coreml.py`; the source weights
and the ANE-safe graph design are not artifacts we possess.

---

## 2. Pronunciation head — works, but as two existing scripts, not one

`tajweed-lab/models/head/pronunciation_head.pt` **does exist** (a small
1.33M-param MLP, no attention/ANE concerns). There's no single
`models/head/export_coreml.py`, but a working `pt → CoreML` **pipeline already
exists and has already been run successfully**, entirely from files we own:

| Step | Script (already in repo) | Input | Output |
| --- | --- | --- | --- |
| 1 | `tajweed-lab/scripts/export_pronunciation_head_onnx.py` | `models/head/pronunciation_head.pt` | `models/onnx/pronunciation_head.onnx` |
| 2 | `tajweed-lab/experiments/diy_coreml_poc/convert_onnx_to_coreml.py --head-only` | `models/onnx/pronunciation_head.onnx` | `experiments/diy_coreml_poc/artifacts/pronunciation_head.mlpackage` |

This `.mlpackage` is already on disk
(`tajweed-lab/experiments/diy_coreml_poc/artifacts/pronunciation_head.mlpackage`)
and was already numerically verified against the Android ONNX head in
[`diy_coreml_parity_report.md`](../../../tajweed-lab/experiments/diy_coreml_poc/reports/diy_coreml_parity_report.md):
mean |Δprob| 0.0000–0.0029, 0 status mismatches, across all 3 golden clips.
No HF dependency was used to produce it.

**Caveat:** this head `.mlpackage` alone is not sufficient for production —
`docs/COREML_CONTRACT.md` requires "always pair offline ANE encoder ↔ offline
head," and the encoder side is blocked per §1. The head conversion working in
isolation does not unblock shipping CoreML without the encoder.

---

## 3. Step-by-step guide

### 3a. Pronunciation head — CoreML from our own checkpoint (works today)

```bash
cd tajweed-lab
source .venv/bin/activate   # requires torch, onnx, onnxruntime, coremltools, onnx2torch

# Step 1: pt -> onnx (already-existing script, ADR-007/TD-010)
python scripts/export_pronunciation_head_onnx.py
#   reads:  models/head/pronunciation_head.pt
#   writes: models/onnx/pronunciation_head.onnx
#   prints an ORT-vs-PyTorch numeric smoke check (should be ~1e-6 or less)

# Step 2: onnx -> coreml (already-existing DIY POC script)
python experiments/diy_coreml_poc/convert_onnx_to_coreml.py --head-only
#   reads:  models/onnx/pronunciation_head.onnx
#   writes: experiments/diy_coreml_poc/artifacts/pronunciation_head.mlpackage
```

### 3b. Conformer encoder — blocked; what would be needed

Not runnable from artifacts we own today. To make it runnable you would need,
in order:

1. Obtain `nemo/fastconformer-quran.nemo` (or an equivalent raw checkpoint) —
   currently only obtainable from the gated HF repo, i.e. the exact dependency
   this task asked to avoid. There is no local/offline alternative source.
2. Add `nemo_toolkit[asr]` to `tajweed-lab/requirements.txt` and install it (to
   load a `.nemo` checkpoint at all — NeMo is not currently a lab dependency).
3. Write a genuinely new `export_coreml.py` that either:
   - calls NeMo's own CoreML/ONNX export path and then converts, or
   - re-implements the ANE windowed-attention graph transform upstream used
     for `fastconformer-quran-coreml-offline` (no recipe for this exists in
     our repo or docs).
4. Validate FP16 stability on the exported graph (our only attempt, via the
   ONNX path, produced NaNs in FP16 — see feasibility report).
5. Wrap the result as multifunction `predict_T80…predict_T4800` to match
   `OfflineAsrModel.swift`'s existing contract (`docs/COREML_CONTRACT.md`).

None of steps 1–5 can be completed with files currently in this repo. This
mirrors the closed investigation in ADR-004 / `onnx-to-coreml-production-
feasibility.md`, reached independently by working from the checkpoint side
instead of the ONNX side.

### 3c. Verifying CoreML inputs/outputs match Android ONNX

Once any CoreML package exists (head today; encoder only if 3b is solved),
verify contract parity against the same names/shapes Android's ONNX Runtime
session uses (`OnnxAsrModel.kt` / `PronunciationHeadModel.kt`):

| Model | Android ONNX I/O | Expected CoreML I/O |
| --- | --- | --- |
| Encoder | in: `audio_signal` `(1,80,T)` f32, `length` `(1,)` i64 → out: `logprobs` `(1,T/8,1025)` f32, `encoder_output` `(1,512,T/8)` f32 | same names/shapes; `.mlpackage` may downcast `length`/`token_id` to int32 — check both |
| Head | in: `enc_feature` `(1,512)` f32, `token_id` `(1,)` i64 → out: `prob_correct` `(1,)` f32 | same names/shapes |

Use the existing lab scripts to do this numerically, not just by shape:

```bash
# Regenerates Android-comparable scores from the CoreML artifacts on the
# same 3 golden WAVs already used for Android parity:
python experiments/diy_coreml_poc/run_coreml_e2e.py
# Diffs against memory/features/tajweed/phase4a-artifacts/tajweed_parity_android.json:
python experiments/diy_coreml_poc/compare_to_android.py
# Writes reports/diy_coreml_parity_report.{md,json} with per-sample
# transcript/prob/status/alignment deltas and pass/fail tolerances.
```

Tolerances already encoded in `compare_to_android.py`: mean |Δprob| ≤ 0.05,
max |Δprob| ≤ 0.15, max alignment |Δ| ≤ 0.08s, transcripts diacritic-insensitive
exact match, token statuses must match exactly.

---

## Affected files this session

None — investigation only, no code or model files modified. This document is
new (`memory/features/tajweed/checkpoint-coreml-export-verification-2026-07-30.md`).
