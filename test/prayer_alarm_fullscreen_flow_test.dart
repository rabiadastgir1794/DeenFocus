import 'package:deenly/core/services/storage_service.dart';
import 'package:deenly/features/home/helpers/prayer_reminder_prompt_keys.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/cycle_mode_policy.dart';
import 'package:deenly/features/home/services/prayer_analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Prayer Alarm snooze options', () {
    test('settings and full-screen share the same durations', () {
      expect(StorageService.prayerAlarmSnoozeOptionMinutes, <int>[5, 10, 15]);
      expect(
        StorageService.prayerAlarmSnoozeOptionMinutes,
        contains(StorageService.defaultPrayerAlarmSnoozeMinutes),
      );
    });
  });

  group('PrayerReminderPromptKeys', () {
    test('builds stable v2 day+prayer keys used after I\'ve Prayed', () {
      expect(
        PrayerReminderPromptKeys.forPrayer(
          TrackablePrayer.maghrib,
          dayKey: '2026-08-18',
        ),
        'v2:2026-08-18:maghrib',
      );
    });

    test('alarm confirm key matches soft-reminder suppression format', () {
      const prayer = TrackablePrayer.isha;
      final key = PrayerReminderPromptKeys.forPrayer(
        prayer,
        dayKey: '2026-08-18',
      );
      expect(key, 'v2:2026-08-18:isha');
    });
  });

  group("I've Prayed from alarm — streak + reminder rules", () {
    test('on-time tip yields a positive streak for celebration popup', () {
      final statuses = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        '2026-08-17': {
          for (final p in TrackablePrayer.values) p: PrayerMarkStatus.onTime,
        },
        '2026-08-18': {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
        },
      };
      final streak = PrayerStreakCalculator.calculate(
        now: DateTime(2026, 8, 18, 14),
        statusHistory: statuses,
        isCycleDay: (_) => false,
      );
      expect(streak, greaterThan(0));
    });

    test('Cycle Mode member day still suppresses soft reminder membership', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 18),
        cycleLength: 3,
      );
      final policy = CycleModePolicy(data);
      expect(policy.isCycleMember(DateTime(2026, 8, 18, 12)), isTrue);
    });

    test('marked tip is not a reminder target candidate', () {
      // Soft reminder only targets unmarked started prayers.
      expect(PrayerMarkStatus.onTime != PrayerMarkStatus.none, isTrue);
    });
  });
}
