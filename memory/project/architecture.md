# Architecture

## Flutter app (`lib/`) — MVVM

```
lib/
├── app/                 go_router setup: app_router.dart, route_names.dart
├── core/
│   ├── services/        Singletons: StorageService, PermissionService,
│   │                     QiblaCompassService, ThemeService, LocaleService, ...
│   ├── theme/            AppColors, light/dark ThemeData
│   ├── widgets/          Shared UI (buttons, cards, dialogs)
│   ├── logger/           Structured logging, ANR watchdog, perf monitor
│   ├── superwall/        Paywall/premium gate
│   └── config/           App-level config
├── features/<name>/
│   ├── model/            Plain data classes
│   ├── view/             Widgets/screens (no business logic)
│   ├── viewmodel/        ChangeNotifier — all business logic here
│   └── data/             Repositories (e.g. QuranLocalRepository, Hive-backed)
└── main.dart             Entry point, MultiProvider setup
```

Existing features: `home`, `quran`, `focus`, `tasbih`, `onboarding`, `splash`.

### Key entry points
- `lib/main.dart` — app bootstrap, provider wiring.
- `lib/app/routes/app_router.dart` — go_router routes (`/splash`, `/onboarding`, `/`).
- `lib/features/home/view/dashboard_screen.dart` — `IndexedStack` tab host
  (Home, Focus, Tasbih, **Quran**, Settings). The Quran tab is index 3 and is
  **not** itself a go_router route.
- `lib/features/quran/data/quran_local_repository.dart` — Hive-backed
  `SurahSummary`/`AyahRecord` store, seeded from `assets/raw/quran_paak.json`
  + `assets/raw/english_translation.json`. This is the canonical ayah text
  source for anything that needs to display or compare against Quran text
  (including the tajweed feature).
- `lib/features/quran/view/surah_detail_bottom_sheet.dart` — full surah
  reading screen (despite the filename, it's a pushed `Scaffold`, not a
  bottom sheet). Has `just_audio` recitation playback. This is the planned
  attach point for a "Practice Tajweed" entry (see
  `memory/features/tajweed/coreml-ios-integration-plan.md` Phase D). Reached
  via imperative `Navigator.push` — see `memory/technical-debt.md` TD-003.

### Native bridge layer (iOS)
All existing platform channels are registered in
`ios/Runner/AppDelegate.swift`, one `FlutterMethodChannel` per feature, name
pattern `com.app.deenly.deenly/<feature>`:

| Channel | Dart service |
| --- | --- |
| `.../focus` | `FocusEnforcementService`, `AppNotificationService` |
| `.../screen_time` | `PermissionService` |
| `.../qibla_compass_method` (+ `_events`) | `QiblaCompassService` |
| `.../widgets` | `WidgetSyncService` |
| `.../location_search` | `NativeLocationSearchService` |

**No tajweed channel exists yet.** When it's built, follow this exact
pattern: new `FlutterMethodChannel` in `AppDelegate.swift`, new Swift handler
group, new Dart service in `lib/core/services/`. Full plan:
`memory/features/tajweed/coreml-ios-integration-plan.md`.

## Tajweed lab (`tajweed-lab/`) — standalone Python app

```
tajweed-lab/
├── web/
│   ├── app.py            FastAPI routes (health, surahs/ayahs, transcribe, practice)
│   ├── quran_data.py     Loads assets/raw/quran_paak.json (repo-root relative),
│   │                     word-level compare (see TD-001 for its limits)
│   └── asr/
│       ├── mel.py         NeMo-compatible log-mel frontend (NumPy)
│       ├── decode.py       CTC collapse (blank id 1024)
│       ├── session.py     ONNX Runtime engine (lazy-loaded, singleton `ENGINE`)
│       └── audio_io.py     Container decode (soundfile, ffmpeg fallback)
├── scripts/               setup_env.sh, download_model.py, smoke_transcribe.py
├── vendor/tajweed/        Upstream (HF) scoring package — vendored source,
│                          committed; not yet called from web/app.py
├── docs/, decisions/      Lab-scoped docs/ADRs (kept here, not duplicated
│                          into memory/ — see memory/decisions/README.md)
└── models/, samples/, .venv/, .env   Gitignored — downloaded/generated
```

`web/quran_data.py` reads `assets/raw/quran_paak.json` via a **relative path
up from `tajweed-lab/` to the repo root** — this only works when
`tajweed-lab/` stays a subfolder of this DeenFocus checkout, not a standalone
clone. That coupling is intentional (per user decision, 2026-07-28): the lab
exists specifically to feed into DeenFocus.

## Never do
- Never add a second state-management approach to `lib/` (Provider +
  ChangeNotifier only; GetX is allowed **only** for dialogs/snackbars/toasts/
  bottom sheets per `.cursor/skills/flutter_state_management.skill`).
- Never call `vendor/tajweed/*.py` functions directly from `web/app.py`
  without checking `tajweed-lab/decisions/ADR-003-onnx-lab-stack.md` first —
  the aligner/head scorer expect the `model_with_encoder` ONNX graph, not the
  CTC-only one.
- Never assume `tajweed-lab/` can run outside a DeenFocus checkout (see
  path coupling above).
