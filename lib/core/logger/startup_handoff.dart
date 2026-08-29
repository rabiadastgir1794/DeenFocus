import 'dart:async';

/// Destination gates signal after their first painted frame so Superwall,
/// notifications, and Focus recompute do not compete with `loadLibrary` /
/// the first Home (or onboarding) build.
///
/// [firstDestinationIdle] is one extra vsync after that frame so Superwall's
/// WKWebView does not spawn on the same tick as Home's remaining layout.
abstract final class StartupHandoff {
  static final Completer<void> _firstDestinationFrame = Completer<void>();
  static final Completer<void> _firstDestinationIdle = Completer<void>();

  static Future<void> get firstDestinationFrame =>
      _firstDestinationFrame.future;

  static Future<void> get firstDestinationIdle => _firstDestinationIdle.future;

  static void notifyFirstDestinationFrame() {
    if (!_firstDestinationFrame.isCompleted) {
      _firstDestinationFrame.complete();
    }
  }

  static void notifyFirstDestinationIdle() {
    if (!_firstDestinationIdle.isCompleted) {
      _firstDestinationIdle.complete();
    }
  }
}
