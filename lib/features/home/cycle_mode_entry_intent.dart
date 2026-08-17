import 'package:flutter/foundation.dart';

/// Cross-route intent to open Cycle Mode settings after a notification tap.
class CycleModeEntryIntent {
  CycleModeEntryIntent._();

  static final ValueNotifier<bool> pendingOpenSettings =
      ValueNotifier<bool>(false);

  static void requestOpenSettings() {
    pendingOpenSettings.value = true;
  }

  /// Returns and clears the pending open request.
  static bool takePendingOpenSettings() {
    if (!pendingOpenSettings.value) return false;
    pendingOpenSettings.value = false;
    return true;
  }
}
