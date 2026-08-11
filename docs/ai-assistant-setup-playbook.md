# The AI-Assistant Project Setup Playbook — DeenFocus

*A reusable guide for configuring Claude, Cursor, or any coding AI assistant so it delivers work the way the DeenFocus team actually works — consistently, safely, and without repeating past mistakes.*

**Project:** DeenFocus (package `deenly`) — a Flutter Muslim lifestyle / focus app for **Android and iOS**.  
**Stack:** Flutter (Dart 3.10+), Provider + ChangeNotifier MVVM, go_router, Hive + SharedPreferences, Superwall, native Focus enforcement via MethodChannels.

This document is the **single source of truth** for AI assistants working on DeenFocus. It is framework-aware (Flutter), platform-aware (Android & iOS), and process-aware (how tickets get shipped). Where Cursor skills under `.cursor/skills/` conflict with this playbook or with the live codebase, **prefer the live codebase**, then this playbook, then update the skill.

---

## 0. The core idea

An AI assistant is only as good as the context and guardrails you give it. Left to defaults it will guess conventions, invent a branching model, over-engineer, and claim "done" without proof. The fix is to treat the assistant's operating environment as a **first-class, version-controlled part of the repo** — five layers that turn a generic model into a teammate who knows *this* codebase.

```
┌─────────────────────────────────────────────────────────────┐
│  1. CLAUDE.md / AGENTS.md   The map — loaded every session    │
│  2. memory/                 The persistent brain — survives  │
│  3. Skills / commands       The playbooks — how we do tasks  │
│  4. Subagents               The specialists — e.g. reviewer  │
│  5. settings + perms        The guardrails — what's allowed  │
└─────────────────────────────────────────────────────────────┘
```

Two principles run through all five:

- **Write down what was hard-won.** Every bug that shipped, every trap in the build system, every "the user actually wanted X not the AC's Y" — captured once, never re-learned.
- **Gates over autonomy.** The assistant pauses at human decision points (approval to push, device testing on Android *and* iOS where relevant, real forks) instead of bulldozing to a finish.

### AI assistant persona (DeenFocus)

Behave like a **senior Flutter engineer who has owned DeenFocus for years**. Before making any change:

1. Understand the requirement.
2. Explore the existing codebase (do not guess where things live).
3. Reuse existing components and services whenever possible.
4. Respect the current architecture (feature-first MVVM + Provider).
5. Avoid unnecessary abstractions — no inventing Clean Architecture layers for every feature.
6. Explain the implementation plan before coding; wait for go-ahead on non-trivial work.
7. Produce clean, production-ready, maintainable code.
8. Consider impact on **both Android and iOS** (UI, permissions, background, Focus, widgets, billing).
9. Never break existing functionality; prefer additive, isolated changes.
10. Ask for clarification when requirements are ambiguous — do not invent product decisions.

Overarching value: **keep it simple and deterministic**. A boring solution that works beats a clever one that's fragile.

---

## 1. Layer 1 — `CLAUDE.md` / `AGENTS.md`: the map

A single file at the repo root, checked into git. Auto-loaded into sessions, so it must be **short, high-signal, and stable**. It is a *map*, not a manual — it tells the assistant where everything is and points to deeper docs (this playbook, `memory/`, `.cursor/skills/`).

### What belongs in it
- One-paragraph description of DeenFocus and its stack (Flutter, Android + iOS).
- **A pointer to the memory system** with a "read these first" table.
- Repo layout — `lib/`, `android/`, `ios/`, assets, where to run commands from.
- Setup / build / test / release commands for Flutter (both platforms).
- Compact architecture overview: layers, key entry points, "don't do X" rules.
- Naming and convention rules the model must follow.
- Link to this playbook: `docs/ai-assistant-setup-playbook.md`.

### What does NOT belong in it
- Anything that changes every sprint (that goes in `memory/current-state.md`).
- Long prose. If it's more than a screen of any one topic, link out.
- Secrets. Reference where they live (`dart_defines.json`, `--dart-define`, env vars), never inline them.

### Template

```markdown
# CLAUDE.md / AGENTS.md

Guidance for AI assistants working in this repo. These instructions OVERRIDE
default behavior — follow them exactly.

## Memory System (Read First)
This project uses a structured memory system. Always read before any task:

| File | Purpose |
|---|---|
| memory/current-state.md          | Current ticket, in-progress work, next action |
| memory/project/project-overview.md | App overview, build, setup |
| memory/project/architecture.md   | Layer architecture, key files |
| memory/project/conventions.md    | Code style, naming, placement rules |
| memory/decisions/                | ADRs — read before changing architecture |
| memory/technical-debt.md         | Known shortcuts and their risks |
| memory/known-risks.md            | Production risks to account for |
| docs/ai-assistant-setup-playbook.md | Full playbook (this project's SSoT) |

Recovery after interruption: current-state.md → feature overview → relevant ADRs → resume.
Update memory/current-state.md at the end of every session.

## Project Layout
lib/ (Dart), android/ (Kotlin + services), ios/ (Swift + extensions), assets/, test/

## Setup / Build / Test / Release
flutter pub get
flutter analyze
flutter test
flutter run                    # debug, connected device/emulator
flutter build apk --dart-define-from-file=dart_defines.json
flutter build ipa --dart-define-from-file=dart_defines.json

## Architecture
Feature-first MVVM + Provider. See playbook § Architecture.

## Conventions
See playbook § Coding conventions and memory/project/conventions.md.
```

---

## 2. Layer 2 — `memory/`: the persistent brain

The single biggest force-multiplier. Structured markdown that persists knowledge **across sessions, context resets, and team members.** When a session is interrupted, the assistant reads `current-state.md` and resumes exactly where it left off.

### Directory structure

```
memory/
├── current-state.md          # SOURCE OF TRUTH for recovery — read first, updated last
├── technical-debt.md         # Every intentional shortcut, with risk + resolution
├── known-risks.md            # Production risks the assistant must account for
├── project/
│   ├── project-overview.md   # App, platforms, build, signing, stores
│   ├── architecture.md       # Layers, key files, data flow
│   ├── conventions.md        # Code style, naming, placement, git
│   └── dependencies.md       # Third-party deps and why each exists
├── features/
│   └── <feature>/overview.md # Per-feature: purpose, architecture, design decisions
├── decisions/
│   └── ADR-###-<slug>.md     # Architecture Decision Records
└── checkpoints/              # Optional: point-in-time snapshots for big migrations
```

### `current-state.md` — the recovery anchor

```markdown
# Current State
> Source of truth for recovery. Read this first after any interruption.
> Last updated: YYYY-MM-DD — <one-line status>

## Status: <sprint/version> — <current ticket + state>
Branch `feature/...` (off `<base>`), commit `<sha>`, analyze ✓,
Android-tested ✓/pending, iOS-tested ✓/pending, PUSHED/local-only.
N files. <what changed and why, in 3-4 lines>.
⚠️ <any gotcha: platform-only behavior, spec tension, build quirk>

## Prior: <recently shipped work, newest first>
...

## Next action: <the literal next thing to do>
```

Key habits:
- **Absolute dates**, never "yesterday".
- Record **commit sha, analyze/build status, push status**, and **which platforms were device-tested**.
- Flag ⚠️ **spec tensions** and **platform asymmetries** (works on Android, pending iOS Screen Time, etc.).
- Keep a "shipped this cycle" log as an audit trail.

### `technical-debt.md`

```markdown
## TD-### — <short title>
**Description:** what the shortcut is
**Reason:** why it was taken
**Risk:** what could break (call out Android / iOS / both)
**Priority:** High / Medium / Low
**Suggested Resolution:** the real fix
```

Never delete entries — mark **RESOLVED** or **DROPPED** with a dated note.

### `known-risks.md`

Standing production hazards (Focus enforcement races, notification budget on iOS, AlarmManager vs Screen Time divergence, prayer-time edge cases at midnight, Superwall / billing sync, etc.). Format: Area, Severity, Platforms, Status, Description, Mitigation, Remaining risk.

### `decisions/ADR-###-*.md`

```markdown
# ADR-### — <title>
**Date:** YYYY-MM-DD   **Status:** Accepted / Superseded   **Feature:** <area>

## Problem
## Options Considered
## Decision
## Reasoning
## Consequences
## How to apply          ← hard rule for reviewers / implementers
## Related
```

### `features/<feature>/overview.md`

Per-feature living doc: business purpose, architecture, **load-bearing design decisions**, native dependencies (if any), known issues, roadmap. Fresh sessions read this instead of spelunking.

### `project/conventions.md` contract sections

```markdown
## Code Style      — Dart / Flutter rules, null safety, comment policy
## Architecture    — layer placement, Provider rules, MethodChannel ownership
## Naming          — *ViewModel / *Service / *Repository / *Controller
## File Placement  — canonical directory for a new feature
## Platforms       — when to touch android/ vs ios/ vs shared Dart
## Testing         — where tests live, mocks-vs-real policy
## Git             — branch naming, PR target, hook policy
## Documentation   — what to update in memory/ when work completes
```

---

## 3. Layer 3 — Skills / slash commands: the playbooks

Skills (`.cursor/skills/`, `.claude/commands/`, or `.claude/skills/`) are **named, invokable playbooks**. Encode *how this team does a unit of work.*

DeenFocus already ships Cursor skills for architecture, state, storage, navigation, theming, and UI. Treat them as short contracts; this playbook is the long-form authority when they diverge from code.

### The flagship: a "start-ticket" delivery playbook

**Non-negotiables** (get these wrong = work rejected):
1. **Branching model** — know which branch is truth, what to branch off, what PRs target. Do not invent a model; follow repo practice / ask if unclear.
2. **Push only after explicit human approval.** Commit locally, wait. Human device-tests (Android and/or iOS as relevant), then says "push it."
3. Exact **commit-message** style for the repo.
4. Repo-specific **traps** (never commit secrets / `dart_defines.json` with real keys; never invent Firebase; don't reimplement Focus blocking in Dart alone).
5. Commands run from the **repo root** (`flutter …`).
6. Naming / brand: **Deen Focus** / **Deenly** — keep store vs in-app naming consistent with existing UI strings and l10n.

**Lifecycle** (gated phases):

```
1. Prepare   Read current-state → architecture → feature docs → ADRs → ticket & ACs.
             Explore the actual code before planning.
2. Clarify   Ask ONLY on genuine forks. Surface AC vs spoken conflicts.          ← GATE
3. Plan      Files-to-touch + approach + blast-radius (shared services,
             MethodChannels, both platforms). Wait for go-ahead.                 ← GATE
4. Implement Branch. Match surrounding code. Reuse proven approaches.
             Isolate unrelated working-tree changes.
5. Analyze   flutter analyze (+ targeted builds). Filter to REAL new issues.
6. Register  New Dart files need no Xcode/Gradle registration; new *native*
             files/targets DO (AndroidManifest, Kotlin package, iOS targets,
             Info.plist, entitlements, Podfile).
7. Test      Grouped checklist covering Android + iOS where behavior differs.
             Flaky? INSTRUMENT FIRST — don't guess.
8. Ship      Optional review pass → commit locally → DO NOT PUSH.
             On "push it": push, return PR link. Update current-state.md.         ← GATE
9. Debug     Instrument → human runs on device → read logs → minimal fix →
             retest. Never claim "fixed" without proof.
```

**Mistakes already made — do not repeat** (grow this list):
- Pushing without approval.
- Over-engineering when a simple version satisfies the requirement.
- Fixing the symptom instead of tracing the real cause.
- Claiming done without human/log verification on the affected platform(s).
- Assuming iOS-only or Android-only when shared Dart is enough (or the reverse: changing only Dart when native Focus/widgets need updates).
- Introducing Dio / GetX / Bloc / Firebase without an explicit product decision.
- Accessing Hive or SharedPreferences directly from UI widgets.

### Domain skill library (Flutter-oriented)

Curate on-demand references for what DeenFocus actually uses:

| Skill focus | When to pull in |
|---|---|
| Provider / ChangeNotifier | New ViewModels, rebuild scope |
| go_router | New routes / deep links |
| Hive + SharedPreferences | Persistence |
| flutter_local_notifications | Prayer / Focus schedules |
| MethodChannels | Focus, Screen Time, widgets, compass, location search |
| Superwall / IAP | Paywall / premium gates |
| flutter_screenutil + theming | Responsive UI |
| gen-l10n / ARB | New user-visible strings |
| Android Accessibility + AlarmManager | Focus enforcement Android |
| iOS FamilyControls / DeviceActivity / ManagedSettings | Focus enforcement iOS |

---

## 4. Layer 4 — Subagents: the specialists

A subagent is a focused persona with its own prompt and a minimal tool set. The standout use: a **project-aware code reviewer.**

### Why a custom reviewer beats a generic one
A generic reviewer flags textbook issues. A reviewer that has read *your* bug history catches the *next* instance of bugs you've already shipped.

DeenFocus reviewer expectations:
- Diff against the **PR's real target branch** (merge-base), never a hardcoded stale base.
- Cross-reference `memory/` — TD, RISKs, ADRs.
- Hunt **recurring bug classes** (grow over time), e.g.:
  - Race conditions in Focus recompute / notification reschedule.
  - Dart-only fixes that leave Android Accessibility or iOS Screen Time out of sync.
  - Swallowing `PlatformException` / empty `catch` that hides native failures.
  - Breaking iOS pending-notification budget (~62) when scheduling prayer + Focus alerts.
  - UI business logic that belongs in a ViewModel / service.
  - Hardcoded colors / strings bypassing `AppColors` / l10n.
  - Direct `Navigator.push` instead of go_router.
- Mark findings **CONFIRMED** (traced in code) vs **PLAUSIBLE** (suspicious, unverified).
- Output: one-line verdict + severity-ranked findings with `file:line`, failure scenario, smallest fix.

### Template skeleton

```markdown
---
name: code-reviewer
description: Invoke after substantive changes and before PRs.
tools: Read, Grep, Glob, Bash   # read-only + git; no Edit/Write
---

You are a senior Flutter engineer reviewing DeenFocus (Android + iOS).
You report findings; you do not rewrite code.

## Establish the diff base
## How to run a review
## Recurring bug classes
## Conventions to enforce
## Severity + output format
```

Other useful specialists: Explore (read-only mapping), Plan (architecture), docs-writer. Keep each **narrow** — a reviewer should not have Write.

---

## 5. Layer 5 — settings & permissions: the guardrails

Shared settings (checked in) vs local settings (git-ignored) control what the assistant may do without asking. **Allowlist the safe and repetitive; keep dangerous operations prompted.**

```jsonc
{
  "permissions": {
    "allow": [
      "Bash(flutter analyze *)",
      "Bash(flutter test *)",
      "Bash(flutter pub get *)",
      "Bash(dart format *)",
      "Bash(git show *)",
      "Bash(git diff *)",
      "Bash(git status *)",
      "Bash(git log *)",
      "WebSearch"
    ]
  }
}
```

Guidelines:
- Allowlist read-only / idempotent commands (`flutter analyze`, `flutter test`, `git diff/show/log/status`).
- Keep **prompted**: `git push`, force operations, deletes, store uploads, anything that leaves the machine. **Push stays gated by explicit human approval by policy**, not only by permission prompts.
- Be specific with patterns — `Bash(*)` defeats the purpose.
- Team defaults in checked-in settings; machine-specific paths / device IDs in local settings.

---

## 6. The operating loop — how a sprint actually runs

```
   Human: "/start-ticket <ID>" (or equivalent in Cursor)
                              │
     reads memory/current-state → architecture → feature docs → ADRs
                              │
     PREPARE ──▶ CLARIFY ──▶ PLAN ──▶ IMPLEMENT ──▶ ANALYZE ──▶ TEST ──▶ SHIP
        │          │(GATE)     │(GATE)     │            │         │       │(GATE)
     explore    surface     blast-      match code,  real      Android  commit
      code      AC vs       radius      reuse,       errors    +/or iOS  locally,
              spoken       incl. both   native if    only      checklist WAIT for
              conflicts    platforms    needed                         "push it"
                              │
                    optional code-reviewer subagent
                              │
        on "push it" ──▶ push ──▶ PR link ──▶ update current-state.md
                              │
             if fix doesn't hold ──▶ DEBUG LOOP (instrument→run→logs→fix→retest)
```

The human stays in control at clarify / plan / ship and does device testing. The assistant does the rest deterministically and **writes down what it learned** in `current-state.md` before the session ends.

---

## 7. Project architecture (DeenFocus)

### Pattern

**Feature-first MVVM + Provider**, not full Clean Architecture for every screen.

| Layer | Responsibility | Location |
|---|---|---|
| App shell | Routing, `MaterialApp`, global providers | `lib/main.dart`, `lib/app/` |
| Core | Shared services, theme, config, widgets, logging | `lib/core/` |
| Features | UI + ViewModels + feature data | `lib/features/<feature>/` |
| Native | Focus, widgets, Screen Time, Accessibility | `android/`, `ios/` |

### Feature folder contract

```
lib/features/<feature>/
├── model/          # Immutable / simple data types
├── view/           # Screens + widgets
├── viewmodel/      # ChangeNotifier ViewModels (when state is non-trivial)
├── data/           # Optional: API clients, repositories
├── domain/         # Optional: use cases (only when complexity justifies it)
└── helpers/        # Optional: pure helpers (e.g. home prayer logic)
```

**Rules:**
- ViewModels extend `ChangeNotifier`.
- UI must not own business logic or talk to Hive / SharedPreferences / HTTP directly.
- Prefer existing `core/services/*` over new parallel services.
- Add `data/` / `domain/` only when a feature needs it (onboarding already does). Do **not** invent repositories/use cases for every CRUD screen.
- Features without ViewModels today (e.g. simpler Quran/Tasbih UI) may use repositories + local widget state — when adding complexity, introduce a ViewModel rather than bloating the widget.

### Key entry points

| Concern | Entry |
|---|---|
| App bootstrap | `lib/main.dart` |
| Routes | `lib/app/routes/app_router.dart`, `route_names.dart` |
| Config / secrets | `lib/core/config/app_config.dart` (`String.fromEnvironment`) |
| Prefs | `lib/core/services/storage_service.dart` |
| Notifications | `lib/core/services/app_notification_service.dart` |
| Focus (Dart) | `FocusController` + `FocusEnforcementService` |
| Focus (Android) | Accessibility Service + AlarmManager receivers |
| Focus (iOS) | FamilyControls / DeviceActivity / ManagedSettings extensions |
| Premium | `lib/core/superwall/` + `in_app_purchase` |
| Logging | `lib/core/logger/` |

### Data flow (typical)

```
View ──watch/read──▶ ViewModel / Controller
                         │
                         ├── StorageService (prefs)
                         ├── *Repository (Hive)
                         ├── *Service (HTTP / native channel)
                         └── notifyListeners()
```

---

## 8. Folder structure

```
DeenFocus/
├── lib/
│   ├── main.dart
│   ├── app/routes/              # go_router
│   ├── core/
│   │   ├── config/
│   │   ├── constants/
│   │   ├── logger/
│   │   ├── services/            # cross-cutting services
│   │   ├── superwall/
│   │   ├── theme/
│   │   ├── util/
│   │   └── widgets/             # shared UI kit (+ widgets.dart barrel)
│   ├── features/
│   │   ├── splash/
│   │   ├── onboarding/
│   │   ├── home/
│   │   ├── focus/
│   │   ├── quran/
│   │   └── tasbih/
│   └── l10n/                    # ARB + generated localizations
├── android/                     # Kotlin, Accessibility, widgets, receivers
├── ios/                         # Runner + Focus + WidgetKit extensions
├── assets/
├── test/
├── docs/ai-assistant-setup-playbook.md
├── .cursor/skills/              # short Cursor contracts
├── l10n.yaml
├── analysis_options.yaml
└── pubspec.yaml
```

**Placement rules for new work:**
- New user-facing feature → `lib/features/<name>/…`
- Cross-feature capability → `lib/core/services/` (or `core/widgets/` for UI)
- New user-visible string → ARB files under `lib/l10n/` (never hardcode)
- Platform Focus / widget / permission behavior → update **Dart channel wrapper and** the relevant `android/` / `ios/` code

---

## 9. Coding conventions

- **Null safety** everywhere; avoid `!` unless the invariant is locally obvious.
- **Files:** `snake_case.dart`. **Types:** `PascalCase`. **Members:** `camelCase`.
- **Widgets:** prefer `const` constructors; extract reusable pieces; avoid giant widget files (target ≤ ~250 lines for UI files when practical).
- **No magic numbers** — use `Spacing`, theme, or named constants.
- **Colors:** `AppColors` / theme only — never hardcode brand colors in widgets.
- **Icons:** prefer `iconsax_flutter` over default Material icons when adding new UI.
- **Navigation:** go_router only (`context.go` / `context.push`). No ad-hoc `Navigator.push` for app flows.
- **Async:** prefer explicit sequencing where races matter (Focus, notifications, prayer refresh). Use `unawaited` only intentionally.
- **Comments:** explain non-obvious rationale (especially native bridges, scheduling, billing) — not narrate obvious code.
- **Imports:** follow surrounding file style; keep feature boundaries clean.
- **Secrets:** only via `--dart-define` / `AppConfig`. Never commit real keys.

---

## 10. Clean Architecture principles (applied lightly)

DeenFocus uses Clean Architecture **principles**, not a mandatory four-layer temple:

1. **Depend inward** — UI depends on ViewModels/services; services do not depend on widgets.
2. **UI is dumb** — rendering + user events only.
3. **Single responsibility** — one service/repository per concern; don't dump Focus + Quran into one god class (and don't grow `FocusController` further without extracting).
4. **Replaceable I/O** — HTTP clients and native wrappers should be injectable where tests or alternate backends matter (`http.Client?`, optional native services).
5. **No unnecessary layers** — a use case class is justified when orchestration is non-trivial (see onboarding search); otherwise a ViewModel calling a service is enough.

If a change would add a new global pattern (Bloc, Riverpod, GetIt, Dio), **stop and ask** — that is an ADR-level decision.

---

## 11. State management conventions

**Stack:** `provider` + `ChangeNotifier`.

- Register app-wide notifiers in `MultiProvider` (`LocaleService`, `ThemeService`, `UserProfileService`, `FocusController`, etc.).
- Feature screens that need scoped state: wrap with `ChangeNotifierProvider` at the feature root.
- Prefer `context.select` / precise `watch` to limit rebuilds.
- Do **not** introduce GetX / Bloc / Riverpod for state.
- Ephemeral UI (tab index, animation controllers) may stay in `StatefulWidget`.
- Side-channel notifiers (e.g. Superwall subscription `ValueNotifier`) are acceptable when documented and localized.

**ViewModel checklist:**
- Extends `ChangeNotifier`
- Owns loading / error / content state for its screen
- Calls services/repositories — not platform channels directly if a service already wraps them
- `dispose()` cancels timers / subscriptions it owns

---

## 12. Dependency injection

**No GetIt / injectable.** Patterns in use:

1. **Provider** for `ChangeNotifier` lifecycles.
2. **Manual singletons** (`Something.instance`) for long-lived services (notifications, logging, daily refresh).
3. **Static utility services** (`StorageService`, `AppConfig`) for prefs/config.
4. **Constructor injection** for testability on clients/use cases (`http.Client?`, optional native collaborators).

When adding a dependency:
- Prefer constructor params on new types.
- Prefer Provider if the object is UI-observed state.
- Prefer a singleton only if it must outlive any one screen and already matches existing service style.
- Do not introduce a DI framework without an ADR.

---

## 13. Networking

**Package:** `http` (not Dio).

Current call sites:
- Google Places (when key present) — onboarding data client
- Native location search MethodChannel (preferred path in onboarding use case)
- OpenStreetMap Overpass — nearby mosques
- Groq chat completions — Islamic Q&A (optional key)
- Map tiles via `flutter_map` / configured tile URL

**Conventions:**
- Put HTTP behind small clients/services under `core/services` or `features/*/data`.
- Timeouts, status checks, and graceful empty/null fallbacks over throwing into the UI.
- No shared interceptor stack today — don't invent one unless multiple APIs need identical auth/logging.
- Never log API keys or PII.
- Offline / failure: degrade UI with l10n error strings; don't crash.

---

## 14. Local storage

| Technology | Use for |
|---|---|
| **SharedPreferences** via `StorageService` | Flags, profile, locale, theme, location, Focus JSON, caches, notification prefs |
| **Hive** via feature repositories | Structured collections (Quran, Tasbih) |
| **Assets JSON** | Seed data (Quran) |
| **path_provider** | Log files |
| **iOS App Group** | Widget / shield shared state (`group.com.rnr.deenfocus`) |

**Rules:**
- UI never opens Hive boxes or reads prefs directly.
- Prefs → `StorageService`.
- Structured domain data → dedicated repository (open boxes lazily; `Hive.initFlutter()` already in `main`).
- Serialise Focus / schedule state carefully — both Dart and native sides may read derivatives.
- When changing persisted schemas, plan migration / backwards compatibility and call out RISK/TD.

---

## 15. Firebase integration

**DeenFocus does not use Firebase today** (no Auth, Firestore, FCM, Crashlytics, Analytics packages in tree).

- Monetization / paywalls → **Superwall** + `in_app_purchase`.
- Logging / crashes → local `LoggerService` / `AppLogging` (and platform tools as needed).
- Push → **not used**; local notifications only.

If a ticket asks for Firebase, treat it as a **product + architecture decision**: clarify scope, write an ADR, and plan Android `google-services` + iOS `GoogleService-Info.plist` + FlutterFire setup explicitly. Do not silently add Firebase "because most apps have it."

---

## 16. Notifications

**Local notifications** via `flutter_local_notifications` + `timezone` / `flutter_timezone`.

- Central service: `AppNotificationService`.
- Channels: prayer times, focus modes (keep Android channel IDs stable).
- Request permission in onboarding/settings flows — not as a surprise on cold start unless product requires it.
- Reschedule thoughtfully on boot / timezone / locale / profile changes.

### Platform notes

| Topic | Android | iOS |
|---|---|---|
| Exact alarms | Prefer exact where product requires; respect OEM limits | N/A (UNNotification scheduling) |
| Budget | Channel importance / battery exemptions | Pending notification limit (~64) — budget prayer + Focus carefully |
| Boot / time change | Manifest receivers + reschedule | App launch / background fetch paths as implemented |
| Permissions | POST_NOTIFICATIONS (13+), SCHEDULE_EXACT_ALARM as needed | Provisional / alert authorization via existing flows |

Never schedule from random widgets — go through the notification service so both platforms stay consistent.

---

## 17. Background services

Flutter-side timers (`DailyRefreshService`, Focus refresh while foregrounded) are **not** a substitute for OS background work.

### Android
- `FocusAccessibilityService` — foreground app detection / blocking
- `AlarmManager` + receivers — scheduled lock/unlock, widget refresh
- Boot / time / timezone receivers — restore schedules
- Keep `AndroidManifest` permissions and service declarations in sync with Dart assumptions

### iOS
- DeviceActivity monitor extension
- ManagedSettings shield configuration
- FamilyControls authorization via MethodChannel
- WidgetKit timelines via widget sync channel
- Respect App Group identifiers already in use

**Rule:** any change to Focus scheduling, blocking, or widgets must be evaluated on **both** platforms. If a fix is Dart-only, document why native sides remain correct.

---

## 18. Localization

- Flutter gen-l10n (`l10n.yaml` → `lib/l10n/*.arb`).
- Runtime: `AppLocalizations` + `LocaleService` (persisted).
- Supported languages live in `lib/core/constants/app_languages.dart` and matching ARBs.
- **Every new user-visible string** goes into ARBs (start with `app_en.arb`, then other locales as required by the ticket).
- RTL: Arabic locales — verify layout mirrors; don't assume LTR-only padding hacks.
- Do not concatenate translated sentences in ways that break grammar; use l10n placeholders.

---

## 19. Responsive UI & theming

- **ScreenUtil** design size: `390×844` (`ScreenUtilInit` in `main.dart`). Use `.w` / `.h` / `.sp` consistently with surrounding code.
- **Material 3**, light + dark via `ThemeService` and `lib/core/theme/`.
- Brand palette centralized in `AppColors` (primary green family; skills mention `#459075` — follow `AppColors`, not ad-hoc hex).
- Typography: existing Google Fonts theme (Plus Jakarta Sans) — don't introduce a second font system casually.
- Spacing: `lib/core/constants/spacing.dart`.
- Shared controls: `lib/core/widgets/` (`AppButton`, fields, app bars, etc.).
- Corners / padding should match existing components (skills: ≥ 16px rounded where applicable).
- Test critical screens at small phone width and large phone; don't only validate on one emulator skin.

---

## 20. Platform-specific implementation guidelines

### Decision tree

```
Can it be done in shared Dart with existing plugins?
  YES → implement in lib/, verify on Android + iOS
  NO  → add/extend MethodChannel (or EventChannel)
          ├── Android Kotlin in android/… 
          └── iOS Swift in ios/… (+ entitlements/Info.plist as needed)
```

### MethodChannel ownership

Channels use the `com.app.deenly.deenly/…` prefix today. Dart wrappers live under `lib/core/services/`. When extending:
1. Update Dart API with clear method names and typed results.
2. Implement Android + iOS handlers (or explicitly document platform-unsupported with safe no-op / error).
3. Catch `PlatformException` and degrade gracefully.
4. Log enough to diagnose without spamming.

### Android checklist
- Permissions in `AndroidManifest.xml`
- Services / receivers registered
- Package / applicationId consistency (`com.rnr.deenfocus`)
- Accessibility / exact alarm / OEM quirks considered for Focus
- Play Billing / Superwall Android config

### iOS checklist
- Info.plist usage strings
- Entitlements (Screen Time, App Groups)
- Extension targets updated if shield/monitor/widget behavior changes
- Pod install when native deps change
- StoreKit / Superwall iOS config
- Notification authorization copy and budget

### Never
- Ship a Focus-related change tested on only one OS without calling out the gap in `current-state.md`.
- Duplicate business rules in Kotlin and Swift without a shared Dart source of truth for schedule intent.
- Change App Group IDs or channel names casually (breaks widgets / extensions).

---

## 21. Error handling

Existing stack:
- `runZonedGuarded` + `FlutterError.onError` + platform dispatcher hooks → `AppLogging`
- `LoggerService` for durable local logs
- `TraceHelpers` / ANR / performance utilities where used

**Conventions for new code:**
- Prefer typed, local handling at boundaries (network, channels, IAP).
- Don't silently `catch (_)` on paths that can strand Focus or notification state — log with context.
- Surface user-facing failures via l10n strings, not raw exceptions.
- Do not add a global Result/Either framework unless ADR'd; match existing null/empty/fallback style.
- Never claim a native bug is fixed because Dart stopped throwing.

---

## 22. Performance optimization

- Limit rebuilds (`context.select`, smaller widgets, `const`).
- Avoid heavy work on the UI isolate; keep prayer calc / JSON parse off hot build paths when possible.
- Be careful with timers and listeners — cancel in `dispose`.
- Images / video: use existing media stack; don't decode huge assets on every frame.
- Hive: open boxes once; avoid repeated full-box scans on build.
- Notifications: batch reschedules; don't thrash exact alarms.
- Profile before micro-optimizing; fix jank with evidence (DevTools / logs).

---

## 23. Testing strategy

Current baseline is thin (smoke widget test). Raise the bar on the code you touch:

| Layer | Prefer |
|---|---|
| Pure helpers / use cases | Unit tests with injected fakes |
| ViewModels | Unit tests with fake services |
| Widgets | Widget tests for critical UI states |
| Native bridges | Manual device checklist + instrumented logs |
| Focus / notifications | Device matrix Android + iOS |

**Policy:**
- Don't block every tiny UI tweak on full coverage, but **do** add tests when fixing a regression-prone bug or extracting pure logic.
- Prefer fakes over hitting network / Hive in unit tests.
- Never delete a failing test to "go green" — fix the cause or quarantine with a TD entry and reason.
- Manual test checklists in the ticket response should group: ACs, lifecycle, offline, permissions, localization, **Android**, **iOS**, non-regression.

---

## 24. Code review checklist

Use before "ready for review" / when running the review subagent:

- [ ] Matches feature MVVM + Provider conventions; no drive-by architecture rewrites
- [ ] Reuses existing services/widgets; no parallel abstractions
- [ ] No secrets committed; config via `AppConfig` / dart-defines
- [ ] Strings localized; colors/spacing from theme/constants
- [ ] Navigation via go_router
- [ ] Storage only through StorageService / repositories
- [ ] Platform impact assessed; native files updated if needed
- [ ] Notifications / Focus / widgets: scheduling and permissions still coherent
- [ ] Errors logged meaningfully; UI degrades safely
- [ ] `flutter analyze` clean for touched areas
- [ ] Manual test notes for Android and/or iOS
- [ ] TD / RISK / ADR / `current-state.md` updated when applicable
- [ ] Diff scoped to the ticket — no unrelated churn

---

## 25. Development workflow

### Day-to-day commands

```bash
flutter pub get
flutter analyze
flutter test
flutter run -d <device>
flutter build apk --dart-define-from-file=dart_defines.json
flutter build ipa --dart-define-from-file=dart_defines.json
```

### Ticket flow (summary)

1. Read memory + explore code  
2. Clarify ambiguities  
3. Plan (blast radius, both platforms)  
4. Implement  
5. Analyze / run  
6. Human device-tests  
7. Commit locally  
8. Push only on approval  
9. Update `memory/current-state.md`

### Git hygiene
- Follow existing branch naming / PR targets for this repo (ask if unclear — do not invent).
- Commit messages: concise, why-focused, match repo history style.
- Do not use `--no-verify`, force-push to main, or rewrite shared history unless explicitly requested.
- Do not commit `dart_defines.json` with production secrets, keystores, or credentials.

---

## 26. Documentation standards

| When you… | Update… |
|---|---|
| Finish a session | `memory/current-state.md` |
| Take a shortcut | `memory/technical-debt.md` (same change set) |
| Make an architecture call | `memory/decisions/ADR-###-*.md` |
| Discover a production hazard | `memory/known-risks.md` |
| Ship / change a feature's shape | `memory/features/<feature>/overview.md` |
| Add a third-party package | `memory/project/dependencies.md` + justify in PR |
| Learn a repeatable trap | start-ticket "mistakes" list + reviewer bug classes |

Docs are part of the deliverable. Code without memory updates is incomplete for multi-session work.

---

## 27. AI assistant behaviour & decision-making rules

### Always
- Explore before editing.
- Prefer reuse over invention.
- Plan non-trivial work and wait for approval at gates.
- Think Android **and** iOS.
- Keep diffs focused on the request.
- Verify with `flutter analyze` / tests / instrumentation as appropriate.
- Ask when product behavior is ambiguous.

### Never
- Push without explicit approval.
- Claim "fixed" / "done" without evidence.
- Introduce Firebase, Dio, Bloc, GetX-for-state, or a DI framework casually.
- Reimplement Focus blocking purely in Dart.
- Hardcode secrets, colors, or user-facing English strings.
- Silently expand scope ("while I was there").
- Ignore existing `.cursor/skills/` contracts without reconciling to code reality.

### Ambiguity protocol
If AC text and spoken instruction diverge: **name the divergence**, present options, and wait. Do not pick silently.

### Blast-radius protocol
Before changing a shared service (`StorageService`, notifications, Focus, theme, router): list consumers and platform touchpoints. If the radius is large, propose the smallest safe seam.

---

## 28. Bootstrapping / adoption checklist

- [ ] Root `CLAUDE.md` or `AGENTS.md` (map only) linking to this playbook + memory table
- [ ] `memory/` skeleton: `current-state.md`, `project/*`, empty TD/RISK registers
- [ ] `start-ticket` skill filled with DeenFocus branching, Flutter commands, mistakes list
- [ ] Project-aware `code-reviewer` subagent with Flutter + dual-platform bug classes
- [ ] Permissions allowlist for `flutter analyze` / `test` / read-only git
- [ ] Keep `.cursor/skills/` short contracts aligned with this playbook over time
- [ ] Encode org brand/security rules as org-level instructions if applicable

### Minimal viable version
If time is short: (1) this playbook + a short root map file, and (2) `memory/current-state.md` updated every session. Add start-ticket and reviewer as soon as workflow or bugs start repeating.

---

## 29. Maintenance rituals

1. **End every session by updating `current-state.md`.**
2. **Shortcut → TD entry** in the same change set.
3. **Architecture call → ADR** with "How to apply."
4. **Worth-not-repeating bug → reviewer catalogue + known-risks if relevant.**

Six months of honesty beats a perfect template that rots.

---

## Appendix A — `start-ticket.md` skill template (Flutter / DeenFocus)

```markdown
---
name: start-ticket
description: "Operating manual for delivering one DeenFocus ticket end-to-end —
prepare, clarify, plan, implement, analyze, test, ship, debug. Interactive:
pauses at gates for human answers, device testing, and push approval."
---

# Start Ticket — DeenFocus delivery playbook

You are implementing a ticket for DeenFocus (Flutter, Android + iOS). Follow this
lifecycle. Pause at gates and hand back to the human.

Overarching value: KEEP IT SIMPLE AND DETERMINISTIC. A boring solution that works
beats a clever one that's fragile.

## Non-negotiables
1. Branching: follow repo truth branch / sprint base; ask if unclear. PRs target the agreed base.
2. Push ONLY after explicit human approval. Commit locally and wait.
3. Match existing commit-message style.
4. Never commit secrets or real dart-define keys. Never add Firebase/Dio/Bloc casually.
5. Run Flutter commands from repo root.
6. Consider Android and iOS for Focus, notifications, widgets, permissions, billing.

## Lifecycle
1. Prepare  — memory → architecture → feature docs → ADRs → ticket ACs → explore code
2. Clarify  — [GATE] genuine forks only; surface AC vs spoken conflicts
3. Plan     — [GATE] files + approach + blast radius (Dart + android/ + ios/)
4. Implement— match surrounding code; reuse services/widgets; isolate unrelated changes
5. Analyze  — flutter analyze; filter to real new issues
6. Register — native manifests/targets/entitlements if needed
7. Test     — grouped checklist; instrument flaky paths; human runs on device(s)
8. Ship     — [GATE] optional review; commit locally; on "push it" push + PR link;
              update memory/current-state.md
9. Debug    — instrument → run → logs → minimal fix → retest; no "fixed" without proof

## Mistakes already made — do not repeat
- Pushing without approval
- Over-engineering
- Symptom-only fixes
- Claiming done without platform verification
- Dart-only Focus fixes that leave native out of sync
- <add every new trap here>

## Cheatsheet
<exact git + flutter commands for branch, commit-your-files, push, PR>
```

## Appendix B — file inventory

```
repo/
├── CLAUDE.md / AGENTS.md            # Layer 1 — the map
├── docs/ai-assistant-setup-playbook.md
├── memory/                          # Layer 2 — persistent brain
│   ├── current-state.md
│   ├── technical-debt.md
│   ├── known-risks.md
│   ├── project/{project-overview,architecture,conventions,dependencies}.md
│   ├── features/<feature>/overview.md
│   ├── decisions/ADR-###-*.md
│   └── checkpoints/
├── .cursor/skills/                  # Layer 3 — short Cursor contracts
├── .claude/
│   ├── commands/ or skills/         # Layer 3 — playbooks (start-ticket, …)
│   ├── agents/                      # Layer 4 — specialists (code-reviewer)
│   ├── settings.json                # Layer 5 — shared guardrails
│   └── settings.local.json          # per-user (git-ignored)
├── lib/ …                           # Flutter app
├── android/ …                       # Android native
└── ios/ …                           # iOS native + extensions
```

## Appendix C — feature map (quick navigation)

| Feature | Primary entry | State | Notes |
|---|---|---|---|
| Splash | `features/splash/` | — | Onboarding gate |
| Onboarding | `features/onboarding/` | `OnboardingViewModel` | Permissions, location search |
| Home | `features/home/` | `HomeTabViewModel` | Prayer times, settings widgets |
| Focus | `features/focus/` | `FocusController` | Native enforcement critical |
| Quran | `features/quran/` | Local + repository | Hive + audio |
| Tasbih | `features/tasbih/` | Local + repository | Hive |
| Shell / tabs | `dashboard_screen` | Stateful tab index | go_router: splash / onboarding / home |

---

*End of playbook. Prefer updating this file when process or architecture truths change; keep `.cursor/skills/` as short mirrors, not competing authorities.*
