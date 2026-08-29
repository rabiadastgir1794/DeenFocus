/// Compile-time startup probes. Default off so production builds are unchanged.
///
/// Isolate SplashScreen UI (measure runApp → first Flutter frame):
/// `flutter run --dart-define=STARTUP_SIMPLE_SPLASH=true`
///
/// Isolate Impeller (do not ship this):
/// `flutter run --no-enable-impeller`
/// Compare first-frame timestamps in console (`[startup]` / `[startup-probe]`).
abstract final class StartupDiagnostics {
  static const bool simpleSplash = bool.fromEnvironment(
    'STARTUP_SIMPLE_SPLASH',
    defaultValue: false,
  );
}
