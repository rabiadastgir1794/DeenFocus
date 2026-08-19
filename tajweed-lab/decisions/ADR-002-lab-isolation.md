# ADR-002: Isolate work in `tajweed-lab/`

## Status

Accepted — 2026-07-24

## Context

DeenFocus is a Flutter app. ML experimentation (Python, multi-hundred-MB weights) should not pollute `lib/` or inflate git history.

## Decision

Keep all research, docs, decisions, Python inference, and web testing under `tajweed-lab/`. Flutter integration happens only after the lab path is proven.

## Consequences

- Clean separation of concerns; large artifacts gitignored.
- Duplicate effort later to port UI/logic into Flutter/Swift — acceptable.
- Contributors know where docs/progress live.
