import 'package:flutter/foundation.dart';

import 'model/focus_models.dart';

/// Cross-route intent to open Focus and run the existing enable/paywall flow.
///
/// Used by Settings App Demo handoff — [FocusTabScreen] consumes the pending
/// mode via the real `_runEnableModeFlow` (PremiumGate / Superwall).
class FocusEntryIntent {
  FocusEntryIntent._();

  static final ValueNotifier<FocusModeType?> pendingModeToEnable =
      ValueNotifier<FocusModeType?>(null);

  static void requestEnableMode(FocusModeType mode) {
    pendingModeToEnable.value = mode;
  }

  /// Returns and clears the pending mode, if any.
  static FocusModeType? takePendingMode() {
    final mode = pendingModeToEnable.value;
    if (mode != null) {
      pendingModeToEnable.value = null;
    }
    return mode;
  }
}
