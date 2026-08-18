import 'package:deenly/core/services/storage_service.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/prayer_settings_service.dart';
import 'package:deenly/features/home/viewmodel/home_tab_view_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  group('PrayerSettingsService — single source of truth', () {
    test('Settings toggle and Home VM read the same Maghrib state', () async {
      final shared = PrayerSettingsService();
      final homeVm = HomeTabViewModel(prayerSettings: shared);

      await shared.setAlertingEnabled(TrackablePrayer.maghrib, true);

      expect(shared.forPrayer(TrackablePrayer.maghrib).alarmEnabled, isTrue);
      expect(
        shared.forPrayer(TrackablePrayer.maghrib).notificationsEnabled,
        isTrue,
      );
      expect(homeVm.settingsFor(TrackablePrayer.maghrib).alarmEnabled, isTrue);
      expect(
        homeVm.settingsFor(TrackablePrayer.maghrib).notificationsEnabled,
        isTrue,
      );
    });

    test('Home toggle is visible to Settings via the same service', () async {
      final shared = PrayerSettingsService();
      final homeVm = HomeTabViewModel(prayerSettings: shared);

      await homeVm.setPrayerAlertingEnabled(TrackablePrayer.fajr, false);

      expect(shared.forPrayer(TrackablePrayer.fajr).alarmEnabled, isFalse);
      expect(
        shared.forPrayer(TrackablePrayer.fajr).notificationsEnabled,
        isFalse,
      );
    });

    test('all five prayers stay synced after individual toggles', () async {
      final shared = PrayerSettingsService();
      for (final prayer in TrackablePrayer.values) {
        await shared.setAlertingEnabled(prayer, false);
      }
      await shared.setAlertingEnabled(TrackablePrayer.asr, true);

      for (final prayer in TrackablePrayer.values) {
        final enabled = prayer == TrackablePrayer.asr;
        final entry = shared.forPrayer(prayer);
        expect(entry.alarmEnabled, enabled, reason: prayer.name);
        expect(entry.notificationsEnabled, enabled, reason: prayer.name);
      }
    });

    test('persists across service reload (restart / resume)', () async {
      final writer = PrayerSettingsService();
      await writer.setAlertingEnabled(TrackablePrayer.maghrib, false);
      await writer.setAlertingEnabled(TrackablePrayer.isha, true);

      final raw = await StorageService.prayerSettingsJson;
      expect(raw, isNotNull);

      final reader = PrayerSettingsService();
      await reader.reload();
      expect(reader.forPrayer(TrackablePrayer.maghrib).alarmEnabled, isFalse);
      expect(
        reader.forPrayer(TrackablePrayer.maghrib).notificationsEnabled,
        isFalse,
      );
      expect(reader.forPrayer(TrackablePrayer.isha).alarmEnabled, isTrue);
      expect(
        reader.forPrayer(TrackablePrayer.isha).notificationsEnabled,
        isTrue,
      );
    });

    test(
      'notifyListeners fires so Home UI can rebuild after Settings write',
      () async {
        final shared = PrayerSettingsService();
        var notified = 0;
        shared.addListener(() => notified++);

        await shared.setAlertingEnabled(TrackablePrayer.dhuhr, false);
        expect(notified, greaterThan(0));
      },
    );
  });
}
