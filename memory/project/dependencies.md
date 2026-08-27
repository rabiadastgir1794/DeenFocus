# Dependencies

Full/authoritative lists are `pubspec.yaml` (Flutter) and
`tajweed-lab/requirements.txt` (Python). This file explains **why** the
notable ones exist — update it when you add or remove a dependency for a
non-obvious reason.

## Flutter (`pubspec.yaml`)

| Package | Why |
| --- | --- |
| `provider` | App-wide state management (ChangeNotifier DI) |
| `go_router` | Declarative navigation |
| `hive` / `hive_flutter` | Local storage for seeded Quran data + app state |
| `just_audio` | Quran recitation playback (remote MP3 CDN) |
| `audio_session` | AVAudioSession / Android audio focus for background recitation |
| `audio_service` | Lock Screen / Control Center / notification media controls |
| `media_kit*` | Video playback (About DeenFocus screen only — not Quran) |
| `permission_handler` | Location + notification permissions today; will
| | need mic permission wiring for the tajweed feature (not yet configured — see `memory/features/tajweed/coreml-ios-integration-plan.md` Phase C) |
| `flutter_local_notifications`, `flutter_timezone`, `timezone` | Prayer time notifications |
| `adhan` | Prayer time calculation |
| `geolocator`, `geocoding`, `flutter_map`, `latlong2` | Location + Qibla/mosque map |
| `superwallkit_flutter`, `in_app_purchase*` | Paywall / subscriptions |
| `flutter_screenutil` | Responsive sizing |
| `share_plus` | Native share sheet for Learning cards (image + intro text) |
| Bundled `PlusJakartaSans` (`assets/fonts/plus_jakarta_sans/`) | App UI typography (no runtime font HTTP) |

## tajweed-lab (`requirements.txt`)

| Package | Why |
| --- | --- |
| `onnxruntime` | Runs the FastConformer CTC ONNX model on CPU |
| `sentencepiece` | Tokenizer matching the model's BPE vocab (1024 pieces + blank) |
| `huggingface_hub` | Downloads gated model artifacts with `HF_TOKEN` |
| `soundfile`, `scipy` | Audio I/O + resampling |
| `fastapi`, `uvicorn` | Local web server for the practice UI |
| `python-multipart` | File/blob upload handling in FastAPI |
| `python-dotenv` | Loads `tajweed-lab/.env` (never commit this file) |

`vendor/tajweed/` (upstream code, not a pip package) additionally expects
`torch` and `numpy` at runtime once `full_scorer.py` / `head_scorer.py` are
actually wired in (TD-001) — not yet added to `requirements.txt` because
nothing imports them today. Add `torch` when TD-001 is resolved.
