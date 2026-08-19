# AGENTS.md

Guidance for AI assistants working in this repo. These instructions OVERRIDE
default behavior — follow them exactly. (Cursor's equivalent of a `CLAUDE.md`
map, adapted per `memory/decisions/ADR-000-adopt-ai-assistant-memory-system.md`.)

## Memory System (Read First)

This project uses a structured memory system. Always read before any task:

| File | Purpose |
| --- | --- |
| `memory/current-state.md` | Current work, in-progress branch, next action |
| `memory/project/project-overview.md` | App overview, build, setup, signing |
| `memory/project/architecture.md` | Layer architecture, key files |
| `memory/project/conventions.md` | Code style, naming, placement rules |
| `memory/project/dependencies.md` | Third-party deps and why each exists |
| `memory/decisions/` | Repo-wide ADRs — read before changing architecture |
| `memory/features/<feature>/overview.md` | Per-feature purpose, design decisions |
| `memory/technical-debt.md` | Known shortcuts and their risks |
| `memory/known-risks.md` | Production/business risks to account for |

Recovery after interruption: `current-state.md` → `project/architecture.md` →
relevant `features/*/overview.md` → relevant ADRs → resume.

**Update `memory/current-state.md` at the end of every session that changes code.**

## Project Layout

This repo contains two things:

```
DeenFocus/
├── lib/                 Flutter app source (MVVM) — see project/architecture.md
├── ios/, android/       Platform projects (bundle id com.rnr.deenfocus)
├── assets/              Quran text (quran_paak.json), translations, media
├── test/                Flutter tests
├── tajweed-lab/         Python ASR/tajweed research lab (own venv, own docs)
│   ├── web/             FastAPI + offline ASR + practice UI (source of truth today)
│   ├── scripts/         Env setup + model download
│   ├── vendor/tajweed/  Upstream (HF) tajweed scoring package — vendored, committed
│   ├── docs/, decisions/  Lab-specific docs and ADRs (kept separate, see below)
│   └── models/, samples/, .venv/, .env  Gitignored — downloaded/generated, never committed
├── memory/              Persistent knowledge base (this system, Layer 2)
└── .cursor/             Skills, agents, settings for this repo (Layers 3–5)
```

Run Flutter commands from the repo root. Run `tajweed-lab` commands from
`tajweed-lab/` with its own virtualenv — it does not share Flutter's toolchain.

`tajweed-lab/` has its own `README.md` + `docs/` + `decisions/` because it
started as an isolated research spike (see `tajweed-lab/decisions/ADR-002-lab-isolation.md`).
Those stay where they are; `memory/` covers the whole repo and the *plan to
integrate* the lab's output into the iOS app (see
`memory/features/tajweed/overview.md`).

## Setup / Build / Test / Release

**Flutter app:**
```bash
flutter pub get
flutter run                 # local device/simulator
flutter analyze             # lint
flutter test                # unit/widget tests
flutter build ios --release
flutter build apk --release
```

**Tajweed lab (Python):**
```bash
cd tajweed-lab
cp .env.example .env        # then set HF_TOKEN (accept HF gate first)
./scripts/setup_env.sh --download   # venv + deps + model download in one step
source .venv/bin/activate
uvicorn web.app:app --reload --host 127.0.0.1 --port 8765
```
See `tajweed-lab/docs/SETUP.md` for full detail and troubleshooting.

## Architecture (summary — see `memory/project/architecture.md`)

- **Flutter app**: MVVM. `lib/app/` (go_router routes), `lib/core/` (services,
  theme, widgets, logging), `lib/features/<name>/{model,view,viewmodel,data}`.
  ViewModels extend `ChangeNotifier`; DI via `provider`. UI holds no business logic.
- **Native bridge**: iOS `MethodChannel`s registered in `ios/Runner/AppDelegate.swift`
  (pattern: `com.app.deenly.deenly/<feature>`). No tajweed channel exists yet —
  planned, see `memory/features/tajweed/coreml-ios-integration-plan.md`.
- **Tajweed lab**: standalone Python app. `web/app.py` (FastAPI) →
  `web/asr/session.py` (ONNX Runtime engine) → `web/quran_data.py` (reference
  ayah text + compare). `vendor/tajweed/` is upstream scoring code, not yet wired in.

**Never do:**
- Never commit `tajweed-lab` model weights, `.venv/`, or `.env` into git.
- Never invent a different Flutter architecture than the MVVM layout above —
  it's enforced by `.cursor/skills/flutter_architecture.skill` and friends.
- Never push to any remote without explicit human approval — commit locally
  and wait (see `.cursor/skills/start-task/SKILL.md`).
- Never assume ASR (imlaei) output matches Quran JSON (Uthmani-leaning) text
  byte-for-byte — always compare diacritic-insensitively unless exact match matters.

## Conventions (summary — see `memory/project/conventions.md`)

- Dart: MVVM, `Provider`/`ChangeNotifier`, `go_router` for navigation (one
  known exception logged as `memory/technical-debt.md` TD-003).
- Python (`tajweed-lab`): PEP 8, type hints, small focused modules under `web/`.
- No comments that narrate obvious code.
- Git: branch off `dev` as `feature/<Name>`; PRs target `dev`; commit locally
  and wait for explicit approval before pushing.
