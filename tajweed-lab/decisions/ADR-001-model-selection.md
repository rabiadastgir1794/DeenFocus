# ADR-001: Use Muno459/fastconformer-quran as the tajweed backbone

## Status

Accepted — 2026-07-24

## Context

DeenFocus needs offline Quran tajweed coaching: detect wrong recitation and teach the relevant rule. Building ASR + pronunciation scoring from scratch is out of scope.

## Decision

Adopt **Muno459/fastconformer-quran** (NeMo FastConformer CTC + pronunciation head + tajweed engine) as the primary model family, including its ONNX and official CoreML sibling repos.

## Consequences

- Best-in-class Quran ASR on published leakage-free benchmarks.
- Clear offline path (ONNX lab → CoreML iOS).
- License is NPL-1.0 (no-profit) and repos are gated — product/legal follow-up required.
- Hafs-only scope must be communicated in UX.
