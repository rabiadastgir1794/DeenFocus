import '../../../../focus/model/focus_models.dart';

/// Focus mode variant for the interactive App Lock Demo walkthrough.
enum AppLockDemoMode {
  prayer,
  sleep,
  child,
}

extension AppLockDemoModeX on AppLockDemoMode {
  FocusModeType get focusModeType => switch (this) {
        AppLockDemoMode.prayer => FocusModeType.salah,
        AppLockDemoMode.sleep => FocusModeType.nightDiscipline,
        AppLockDemoMode.child => FocusModeType.child,
      };
}
