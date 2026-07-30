# DIY ONNX → CoreML proof-of-concept (isolated)

**Status:** research experiment complete (2026-07-29).  
**Does not** modify `ios/Runner/`, Flutter contracts, MethodChannels, or production model packs.

## Verdict

**Host-side FLOAT32 DIY CoreML matches Android** on all three golden clips
(transcript, pronunciation probs, token status, alignment ≤ 1 frame).

**Do not replace** the gated Hugging Face ANE CoreML packages with these POC
artifacts in production. FP16 conversion produces all-NaN logprobs; the package
is fixed `T=480` (not multifunction `predict_T*`); ANE size/latency unproven.

Full report: [`reports/diy_coreml_parity_report.md`](reports/diy_coreml_parity_report.md)  
(also mirrored at `memory/features/tajweed/diy-coreml-poc-parity-report.md`)

## Goal

Convert the existing local ONNX artifacts to CoreML with the standard
`coremltools` pipeline (CT≥8: ONNX → onnx2torch → torch.jit.trace → coremltools),
run the three golden WAVs, and compare transcript / confidence / pronunciation
score / alignment against Android
(`memory/features/tajweed/phase4a-artifacts/tajweed_parity_android.json`).

## Artifacts (gitignored under `artifacts/`)

| Input (already local) | Output |
| --- | --- |
| `models/onnx/model_with_encoder.onnx` | `artifacts/encoder.mlpackage` |
| `models/onnx/pronunciation_head.onnx` | `artifacts/pronunciation_head.mlpackage` |

Inference for this POC runs **in Python via coremltools** on macOS, not through
the production Swift `OfflineAsrModel` path.

## Run

```bash
cd tajweed-lab
source .venv/bin/activate
pip install 'coremltools>=8.0' onnx2torch

# FLOAT32 is required for the encoder (FLOAT16 → NaN logprobs).
python experiments/diy_coreml_poc/convert_onnx_to_coreml.py --fixed-encoder --fp32
python experiments/diy_coreml_poc/run_coreml_e2e.py
python experiments/diy_coreml_poc/compare_to_android.py

# Post-training optimization comparison (does NOT overwrite FP32 candidate):
# python experiments/diy_coreml_poc/evaluate_encoder_optimizations.py
# Report: reports/encoder_optimization_comparison.md
#         memory/features/tajweed/diy-coreml-encoder-optimization-2026-07-30.md
```