---
name: start-task
description: >-
  Operating manual for delivering one DeenFocus task/feature end-to-end —
  prepare, clarify, plan, implement, build, test, ship, debug. Use when
  starting a non-trivial change to the Flutter app or tajweed-lab (adapted
  from a ticket-based playbook since this repo has no ticket tracker — treat
  "task" as "ticket" and substitute a real ticket ID if one exists).
  Interactive: pauses at gates for human answers, testing, and push approval.
---

# Start Task — DeenFocus delivery playbook

You are implementing a task for **DeenFocus** (Flutter/Dart iOS+Android app,
`com.rnr.deenfocus`) or **tajweed-lab** (Python research subproject). Follow
this lifecycle. It is interactive: pause at the gates and hand back to the human.

Overarching value: **KEEP IT SIMPLE AND DETERMINISTIC.** A boring solution
that works beats a clever one that's fragile. When you catch yourself
building elaborate machinery, stop and ask whether a dead-simple version does
the job.

## Non-negotiables (get these wrong and the work is rejected)

1. **Branching**: `dev` is truth. Branch off `dev` as `feature/<Name>`. PRs target `dev`.
2. **Push ONLY after explicit human approval.** Commit locally and wait. On
   "push it" (or equivalent explicit approval), push and return the
   PR-create link — the human opens the PR. This was confirmed as hard policy
   during the tajweed-lab git cleanup (commit `3d1ba0b` held for review).
3. Commit messages: short imperative subject, no enforced trailer (match
   existing `git log` style — see `memory/project/conventions.md`).
4. Repo-specific traps:
   - Never commit `tajweed-lab/.env`, `.venv/`, `models/`, `samples/`, `xet/`.
   - Never invent a different Flutter architecture than MVVM
     (`.cursor/skills/flutter_architecture.skill` and siblings are law).
   - `tajweed-lab/web/quran_data.py` reads Quran JSON via a relative path up
     to the repo root — don't make `tajweed-lab/` a standalone clone.
5. Flutter commands run from repo root; `tajweed-lab` commands run from
   `tajweed-lab/` with its own `.venv` active.
6. Naming: `<Feature>ViewModel`/`<Feature>Service` (Dart), `snake_case`
   modules (Python) — see `memory/project/conventions.md`.

## Lifecycle

1. **Prepare** — read `memory/current-state.md` → `memory/project/architecture.md`
   → relevant `memory/features/<feature>/overview.md` → relevant ADRs → the
   task's requirements. Explore the actual code before planning — don't guess
   where things live.
2. **Clarify** — [GATE] ask only on genuine forks. Surface any conflict
   between a written requirement and what the human said out loud; name the
   divergence, confirm which wins.
3. **Plan** — [GATE] present files-to-touch + approach + blast-radius
   analysis (every consumer of a shared function/service before changing it —
   e.g. changing `QuranLocalRepository` affects the Quran tab, home daily
   verse, and (soon) the tajweed feature). Wait for go-ahead on non-trivial changes.
4. **Implement** — branch off `dev` (or continue on the current feature
   branch). Match surrounding code and existing conventions. Reuse proven
   patterns (e.g. the `MethodChannel` pattern in `AppDelegate.swift` for any
   new native bridge). Keep additive features off shared paths where possible.
5. **Build** — `flutter analyze` / `flutter build` for Dart; run the lab's
   `scripts/smoke_transcribe.py` for tajweed-lab changes. Filter output to
   REAL errors — pre-existing lint noise is not your error.
6. **Register** — Flutter: new assets go in `pubspec.yaml`; new l10n strings
   in all `lib/l10n/app_*.arb` files touched, then regenerate. iOS: new native
   files added via Xcode project, not just dropped in the folder.
7. **Test** — give a grouped test-case checklist (requirements, lifecycle,
   edge cases, offline behavior, non-regression). For flaky behavior:
   **instrument first** — add prefixed logs, let the human run, read logs,
   root-cause. Don't guess.
8. **Ship** — [GATE] optionally invoke the reviewer persona (see
   `.cursor/agents/code-reviewer.md`) before committing. Commit locally with
   a clear message. **DO NOT PUSH.** On explicit "push it": push, return the
   PR-create link, update `memory/current-state.md`.
9. **Debug** — instrument → human runs → read logs → confirm the failing gate
   → minimal fix → rebuild → human re-tests. Never claim "fixed" without proof.

## Mistakes this repo has already made — do not repeat

- Pasting a secret (`HF_TOKEN`) directly into chat instead of a `.env` file
  from the start — see `memory/known-risks.md` RISK-002.
- Shipping a lexical-only compare and treating it as "tajweed scoring" — it
  isn't; see `memory/technical-debt.md` TD-001. Be explicit in status updates
  about what a feature actually detects vs. what it looks like it detects.
- Using imperative `Navigator.push` where go_router was the stated
  convention (`memory/technical-debt.md` TD-003) — don't add a second
  instance of this drift; ask before mixing navigation styles on one screen.
- <add every new trap here as you hit it — this list is the point>

## Cheatsheet

```bash
# Branch off dev
git checkout dev && git pull && git checkout -b feature/<Name>

# Commit only the files you intended (never `git add .` blindly in this repo —
# tajweed-lab has large gitignored artifacts that must never get force-added)
git add <specific files>
git commit -m "<imperative summary>"

# Do NOT push until told to. When told:
git push -u origin feature/<Name>
gh pr create --base dev --title "<title>" --body "<summary>"
```
