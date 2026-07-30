# ADR-000 — Adopt the AI-assistant memory system (`AGENTS.md` + `memory/`)
**Date:** 2026-07-28   **Status:** Accepted   **Feature:** repo-wide / tooling

## Problem
AI-assisted work on this repo (Flutter app + `tajweed-lab/` Python research)
was losing context across sessions: decisions, shortcuts, and risks lived
only in chat transcripts, not in the repo. Every new session (or a teammate)
had to rediscover state from scratch.

## Options Considered
1. Keep relying on chat history and the existing ad hoc
   `.cursor/skills/*.skill` rule files only.
2. Adopt the 5-layer system from an external playbook
   (`ai-assistant-setup-playbook.md`) verbatim — it's written for Claude Code
   (`CLAUDE.md`, `.claude/commands/`, `.claude/agents/`, `.claude/settings.json`).
3. **Chosen:** Adopt the same 5-layer structure and layer *responsibilities*,
   adapted to what Cursor actually supports.

## Decision
Adopt option 3, per explicit instruction: keep the structure, layer
responsibilities, and workflow from the playbook; adapt only the underlying
*mechanism* where Cursor differs from Claude Code.

| Layer | Playbook mechanism | This repo's mechanism |
| --- | --- | --- |
| 1. Map | `CLAUDE.md` | `AGENTS.md` (Cursor's recognized auto-loaded root file) |
| 2. Memory | `memory/` | `memory/` — identical, filesystem-only convention |
| 3. Skills | `.claude/commands/*.md` | `.cursor/skills/<name>/SKILL.md` (Cursor's real skill format) |
| 4. Subagents | `.claude/agents/<name>.md`, natively loaded | `.cursor/agents/<name>.md` as a **documented persona**; invoked by reading the file and running Cursor's Task tool (`bugbot` / `security-review` / `generalPurpose`) with that persona injected — Cursor has no native custom-subagent loader |
| 5. Settings | `.claude/settings.json` permission allowlist, enforced by the tool | `.cursor/settings.json` documents the same policy; actual enforcement of destructive actions (push, delete, force-ops) is Cursor's own approval/sandbox system, not a file the assistant can use to self-grant permissions |

## Reasoning
- The playbook's core value — write down what was hard-won; gate autonomy at
  human decision points — is tool-agnostic and worth keeping in full.
- Layers 1–3 map cleanly onto real Cursor mechanisms with no loss of function.
- Layers 4–5 don't have a native equivalent in Cursor, so they are
  implemented as **documentation the assistant reads and follows**, not as
  platform-enforced config. This was called out explicitly rather than
  silently dropping the layers.

## Consequences
**Positive:** Session recovery via `current-state.md`, a real audit trail, a
technical-debt register that makes shortcuts visible instead of invisible,
and ADRs that stop decisions from being silently reversed.

**Negative:** More upkeep — if `current-state.md` isn't updated at the end of
a session, the system rots into lies (the playbook's own warning). Layers 4–5
are weaker than in Claude Code: no true persistent custom subagent, no
platform-enforced permission allowlist — both rely on the assistant actually
reading and following the documented files.

## Related
- `AGENTS.md` (Layer 1)
- `memory/` (Layer 2, this ADR's home)
- `.cursor/skills/start-task/SKILL.md` (Layer 3)
- `.cursor/agents/code-reviewer.md` (Layer 4)
- `.cursor/settings.json` (Layer 5)
- `tajweed-lab/decisions/ADR-001..005` (pre-existing, feature-scoped ADRs —
  left in place, not moved or renumbered)
