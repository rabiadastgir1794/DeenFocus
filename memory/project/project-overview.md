# Project Overview

## App

**DeenFocus** (package name `deenly`, bundle id `com.rnr.deenfocus`) — a
Flutter app for Muslim daily practice: prayer times, Qibla, Quran reader,
tasbih, focus mode, and (in progress) offline Quran tajweed coaching.

## Targets

- **iOS**: `ios/Runner.xcodeproj`, min iOS 14.0, `PRODUCT_BUNDLE_IDENTIFIER =
  com.rnr.deenfocus`, `CODE_SIGN_STYLE = Automatic`. Extra targets:
  `FocusShieldConfiguration/`, `FocusDeviceActivityMonitor/` (Screen Time /
  Family Controls), `DeenlyWidgets/` (home screen widgets).
- **Android**: `android/app`, `applicationId = "com.rnr.deenfocus"`.
- **tajweed-lab**: not a shipped target — a Python research subproject (see
  `tajweed-lab/README.md`). Its output is meant to become an iOS CoreML
  integration, tracked in `memory/features/tajweed/`.

## Build / Test / Release

```bash
flutter pub get
flutter run
flutter analyze
flutter test
flutter build ios --release
flutter build apk --release
```

No CI workflows exist yet (`.github/workflows` absent) and no `fastlane`
setup — releases are manual today. Do not assume CI/fastlane exists; don't
add a release pipeline unless asked.

## Monitoring / Signing

- iOS signing is **Automatic** (Xcode-managed); no fastlane match / manual
  provisioning profiles are checked into the repo.
- No crash/analytics SDK config was found in this pass — if one exists, add
  it here when discovered (don't guess).

## Related subproject: tajweed-lab

`tajweed-lab/` is a self-contained Python workspace (own `.venv`, own
`requirements.txt`) for prototyping offline Quran tajweed coaching before it
becomes an iOS feature. See `tajweed-lab/README.md` and
`memory/features/tajweed/overview.md`. It is **not** part of the Flutter
build and has no effect on `flutter build` output.
