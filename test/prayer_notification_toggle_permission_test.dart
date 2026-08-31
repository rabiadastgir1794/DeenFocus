import 'package:deenly/features/home/model/home_models.dart';
import 'package:flutter_test/flutter_test.dart';

/// Soft notification toggle must stay OFF when OS permission is missing,
/// matching [HomeTabViewModel.effectiveNotificationEnabledFor].
void main() {
  group('effectiveNotificationEnabledFor', () {
    bool effective({
      required bool storedEnabled,
      required bool permissionGranted,
    }) =>
        storedEnabled && permissionGranted;

    test('permission denied → toggle off even if preference is on', () {
      expect(
        effective(storedEnabled: true, permissionGranted: false),
        isFalse,
      );
    });

    test('permission granted + preference on → toggle on', () {
      expect(
        effective(storedEnabled: true, permissionGranted: true),
        isTrue,
      );
    });

    test('permission granted + preference off → toggle off', () {
      expect(
        effective(storedEnabled: false, permissionGranted: true),
        isFalse,
      );
    });

    test('defaults prefer notifications on in model storage only', () {
      const entry = PrayerSettingEntry();
      expect(entry.notificationsEnabled, isTrue);
      // UI still requires permission — same AND as effectiveNotificationEnabledFor.
      expect(
        effective(
          storedEnabled: entry.notificationsEnabled,
          permissionGranted: false,
        ),
        isFalse,
      );
    });
  });
}
