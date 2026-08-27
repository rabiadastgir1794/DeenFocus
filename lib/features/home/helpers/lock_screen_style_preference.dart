import '../../../core/services/storage_service.dart';
import '../../../core/superwall/app_superwall.dart';
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

  /// Style used for the live prayer reminder. Invalid, empty, or unpaid
  /// premium selections fall back to Classic without presenting a paywall.
  static Future<LockScreenStyle> resolveForReminder() async {
    final stored = await ensureSelected();
    if (!stored.requiresPremium) return stored;
    if (AppSuperwall.subscriptionActiveNotifier.value) return stored;
    return LockScreenStyle.classic;
  }
}
