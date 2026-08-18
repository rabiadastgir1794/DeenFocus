import 'package:deenly/core/services/prayer_alarm_service.dart';
import 'package:deenly/core/services/storage_service.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('prayerAlarmIdFor is stable per prayer and day', () {
    final when = DateTime(2026, 8, 11, 18, 30);
    expect(
      prayerAlarmIdFor(TrackablePrayer.maghrib, when),
      'maghrib_2026-08-11',
    );
    expect(prayerAlarmIdFor(TrackablePrayer.fajr, when), 'fajr_2026-08-11');
  });

  test(
    'PrayerSettingEntry persists alarmEnabled and soft flag independently in map',
    () {
      const entry = PrayerSettingEntry(
        notificationsEnabled: true,
        alarmEnabled: false,
        sound: PrayerNotificationSound.beep,
      );
      final restored = PrayerSettingEntry.fromMap(entry.toMap());
      expect(restored.alarmEnabled, isFalse);
      expect(restored.notificationsEnabled, isTrue);
      expect(restored.sound, PrayerNotificationSound.beep);
      // State-level normalize repairs lockstep for scheduling/UI.
      final synced = restored.normalizeAlertingSync();
      expect(synced.alarmEnabled, isTrue);
      expect(synced.notificationsEnabled, isTrue);
    },
  );

  test('PrayerAlarmCapabilities parses native bridge map', () {
    final caps = PrayerAlarmCapabilities.fromMap(<String, Object?>{
      'platform': 'android',
      'implementation': 'fullscreen_intent',
      'supportsNativeAlarm': true,
      'supportsFullScreen': true,
      'requiresAlarmKitEntitlement': false,
      'androidSdk': 34,
      'canUseFullScreenIntent': true,
    });
    expect(caps.isFullScreenIntent, isTrue);
    expect(caps.supportsNativeAlarm, isTrue);
    expect(caps.usesNotificationFallback, isFalse);
  });

  test('full-screen snooze options match settings durations', () {
    expect(StorageService.prayerAlarmSnoozeOptionMinutes, [5, 10, 15]);
  });
}
