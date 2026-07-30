# Decisions (ADRs)

App-wide, repo-level architecture decisions live here as `ADR-###-<slug>.md`.

**Feature/lab-scoped decisions stay with their feature.** The tajweed
research lab already has its own ADR set at
[`tajweed-lab/decisions/`](../../tajweed-lab/decisions/):

- `ADR-001-model-selection.md`
- `ADR-002-lab-isolation.md`
- `ADR-003-onnx-lab-stack.md`
- `ADR-004-coreml-path.md`
- `ADR-005-license-npl.md`

Don't duplicate or renumber those here — link to them instead. Add a new ADR
in this folder only when the decision affects the whole repo (tooling,
cross-feature architecture, branching policy, etc.), not something scoped to
one feature or subproject.

Repo-wide tajweed product ADRs (Flutter ↔ native):

- `ADR-006-tajweed-cross-platform-contract.md`
- `ADR-007-tajweed-model-lifecycle.md`
- `ADR-008-tajweed-production-model-distribution.md` (Proposed — design only, not
  yet implemented; see `memory/current-state.md`)
