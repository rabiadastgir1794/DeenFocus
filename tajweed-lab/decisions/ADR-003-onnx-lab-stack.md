# ADR-003: Lab inference stack = ONNX Runtime + SentencePiece

## Status

Accepted — 2026-07-24

## Context

Full NeMo is heavy. The public demo Space already runs CTC via ONNX Runtime on `model_with_encoder.onnx`.

## Decision

Phase-1 lab uses:

- `onnxruntime` (CPU)
- NumPy mel frontend matching NeMo FilterbankFeatures
- SentencePiece tokenizer
- FastAPI web UI

Prefer `model_with_encoder` so we can add pronunciation scoring without changing the ASR graph later. Fall back to `.q8` if disk/RAM is tight.

## Consequences

- Fast local iteration without GPU/NeMo.
- Same preprocessing contract we will need for CoreML validation.
- PyTorch only needed later for `pronunciation_head.pt` (or we convert head to ONNX/CoreML).
