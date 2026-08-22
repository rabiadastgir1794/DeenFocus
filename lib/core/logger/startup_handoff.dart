import 'dart:async';

/// Destination gates signal after their first painted frame so Superwall,
/// notifications, and Focus recompute do not compete with `loadLibrary` /
/// the first Home (or onboarding) build.
abstract final class StartupHandoff {
  static final Completer<void> _firstDestinationFrame = Completer<void>();

  static Future<void> get firstDestinationFrame =>
      _firstDestinationFrame.future;

  static void notifyFirstDestinationFrame() {
    if (!_firstDestinationFrame.isCompleted) {
      _firstDestinationFrame.complete();
    }
  }
}
