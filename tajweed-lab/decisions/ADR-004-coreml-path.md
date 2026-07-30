# ADR-004: Prefer upstream CoreML over custom conversion

## Status
Accepted — 2026-07-24; **reaffirmed 2026-07-29** after DIY ONNX→CoreML POC and
production-feasibility review
(`memory/features/tajweed/onnx-to-coreml-production-feasibility.md`).
Investigation closed: do not attempt to replace official ANE packages from the
local ONNX encoder.

## Context

User goal includes shipping CoreML in the iOS app. Upstream already publishes:

- `Muno459/fastconformer-quran-coreml-offline`
- `Muno459/fastconformer-quran-coreml-streaming`

Custom ONNX→CoreML conversion is error-prone (ANE fp16, attention windows).

## Decision

Validate Python/ONNX first, then integrate **official CoreML packages**. Custom conversion is a fallback only if upstream packages fail size/latency/API needs.

## Consequences

- Faster path to device.
- We inherit upstream ANE workarounds (windowed attention, pos-enc clamps).
- Still need Swift mel/CTC glue and a rules port.
