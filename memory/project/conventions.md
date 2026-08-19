# Conventions

## Code Style

**Dart/Flutter:**
- MVVM. `ViewModel`s extend `ChangeNotifier`. No business logic in widgets.
- State management: `provider` + `ChangeNotifier`. `GetX` is allowed **only**
  for custom dialogs, snackbars, toasts, bottom sheets — never for app state.
- Navigation: `go_router` — use `context.go()` / `context.push()`. Routes
  live in `lib/app/routes/app_router.dart`; names in `route_names.dart`.
  **Known exception:** `SurahDetailBottomSheet` uses `Navigator.push`
  (pre-existing, logged as `memory/technical-debt.md` TD-003) — don't copy
  that pattern into new code; use go_router for new screens.
- Lint rules: `analysis_options.yaml` + `flutter_lints`.

**Python (`tajweed-lab`):**
- PEP 8, type hints on public functions, `from __future__ import annotations`
  at the top of new modules (matches existing files).
- Small, single-responsibility modules under `web/asr/` rather than one large
  file — follow the existing `mel.py` / `decode.py` / `session.py` split.
- No third-party formatter/linter is currently enforced (no `ruff`/`black`
  config found) — match the style of the surrounding file.

**Both:**
- No comments that narrate obvious code (e.g. no `# increment counter`).
  Comments should explain non-obvious intent, trade-offs, or constraints.

## Architecture — layer placement

- New Flutter feature → `lib/features/<name>/{model,view,viewmodel,data}`
  (create only the subfolders you need).
- New shared Flutter capability → `lib/core/services/<name>_service.dart`
  (singleton pattern, matches existing services).
- New native iOS capability → new `FlutterMethodChannel` in
  `ios/Runner/AppDelegate.swift` + matching Dart service in
  `lib/core/services/`, named `com.app.deenly.deenly/<feature>`.
- New tajweed-lab capability → `tajweed-lab/web/` (FastAPI route or `asr/`
  module); vendored upstream code stays under `tajweed-lab/vendor/` and is
  treated as read-only/untouched unless explicitly patching it (log a TD if you do).

## Naming

- `<Feature>ViewModel`, `<Feature>Service`, `<Feature>Screen`,
  `<Feature>LocalRepository` (Dart).
- Python: `snake_case` modules/functions, `PascalCase` classes (e.g.
  `AsrEngine`, `TajweedFullScorer`).

## File Placement

See "Architecture" above — this is the canonical answer to "where does a new
file go."

## Testing

- Flutter: `test/` (currently minimal — no strict per-feature test
  convention established yet; don't invent one, ask if a ticket needs it).
- tajweed-lab: manual smoke test via `scripts/smoke_transcribe.py` — no
  pytest suite exists yet. If you add automated tests, use `pytest` and place
  them under `tajweed-lab/tests/` (does not exist yet — create if needed).

## Git

- Branch off `dev` as `feature/<Name>` (observed pattern: `feature/Quran`,
  `feature-android-fixes`, `feature-ios-fixes` — casing/separator varies
  historically; prefer `feature/<Name>` going forward for consistency).
- PRs target `dev`.
- **Commit locally, wait for explicit human approval before pushing.** This
  is a hard rule for this repo, not just a suggestion — confirmed in practice
  during the tajweed-lab git cleanup (commit `3d1ba0b`, held for review).
- No enforced commit-message trailer — recent history
  (`git log --oneline`) shows short imperative subject lines, no ticket
  prefix, no trailer. Don't invent one; match the existing plain style unless
  told otherwise.

## Documentation

When work completes, update:
1. `memory/current-state.md` (always — this is the recovery anchor).
2. `memory/technical-debt.md` if you took a shortcut.
3. `memory/known-risks.md` if you touched a risk area.
4. The relevant `memory/features/<feature>/overview.md`.
5. A new ADR in `memory/decisions/` (repo-wide) or `tajweed-lab/decisions/`
   (lab-scoped) if you made an architecture call.
