import '../../../core/services/storage_service.dart';
import '../view/widgets/lock_screen_options/lock_screen_style.dart';

/// Load / save / resolve the user's Lock Screen Style preference.
abstract final class LockScreenStylePreference {
  static Future<LockScreenStyle?> loadSelected() async {
    return LockScreenStyle.tryParse(await StorageService.lockScreenStyle);
  }

  static Future<void> save(LockScreenStyle style) {
    return StorageService.setLockScreenStyle(style.name);
  }

  /// Always returns a persisted style. First launch writes Classic so the
  /// picker radio is never empty after restart.
  static Future<LockScreenStyle> ensureSelected() async {
    final stored = await loadSelected();
    if (stored != null) return stored;
    await save(LockScreenStyle.classic);
    return LockScreenStyle.classic;
  }

  /// Style used for the live prayer reminder.
  ///
  /// Paid styles are gated when saving in the picker (`PremiumGate`). Do not
  /// re-check Superwall here: the reminder can fire on cold start before
  /// configure / cache hydrate, which used to silently swap Tasbih (etc.)
  /// for Classic.
  static Future<LockScreenStyle> resolveForReminder() {
    return ensureSelected();
  }
}
