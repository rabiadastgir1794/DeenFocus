import 'package:deenly/features/home/helpers/insights_streak_delta.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/achievements_service.dart';
import 'package:deenly/features/home/services/cycle_mode_policy.dart';
import 'package:deenly/features/home/services/level_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('InsightsStreakDelta', () {
    test('hides prayer chip when streak is 0 or nothing logged today', () {
      expect(
        InsightsStreakDelta.prayerDeltaToday(
          prayerStreak: 0,
          todaysCountedPrayers: 2,
          isPausedToday: false,
        ),
        isNull,
      );
      expect(
        InsightsStreakDelta.prayerDeltaToday(
          prayerStreak: 12,
          todaysCountedPrayers: 0,
          isPausedToday: false,
        ),
        isNull,
      );
    });

    test('hides chips on a paused Cycle Mode day', () {
      expect(
        InsightsStreakDelta.prayerDeltaToday(
          prayerStreak: 12,
          todaysCountedPrayers: 2,
          isPausedToday: true,
        ),
        isNull,
      );
      expect(
        InsightsStreakDelta.dayStreakGrewToday(
          dayStreak: 4,
          todayFullyCompleted: true,
          isPausedToday: true,
        ),
        isFalse,
      );
    });

    test('prayer chip is today\'s counted salah, capped by the streak', () {
      expect(
        InsightsStreakDelta.prayerDeltaToday(
          prayerStreak: 40,
          todaysCountedPrayers: 3,
          isPausedToday: false,
        ),
        3,
      );
      expect(
        InsightsStreakDelta.prayerDeltaToday(
          prayerStreak: 2,
          todaysCountedPrayers: 2,
          isPausedToday: false,
        ),
        2,
      );
    });

    test('day chip only when today is a full five-prayer day', () {
      expect(
        InsightsStreakDelta.dayStreakGrewToday(
          dayStreak: 3,
          todayFullyCompleted: true,
          isPausedToday: false,
        ),
        isTrue,
      );
      expect(
        InsightsStreakDelta.dayStreakGrewToday(
          dayStreak: 3,
          todayFullyCompleted: false,
          isPausedToday: false,
        ),
        isFalse,
      );
    });
  });

  group('LevelProgress XP label matches the bar', () {
    test('level 1 uses total XP against the first threshold', () {
      final progress = LevelService.getLevelFromXP(45);
      expect(progress.currentLevel, 1);
      expect(progress.progressXP, 45);
      expect(progress.xpSpan, 100);
      expect(progress.progressPercentage, closeTo(0.45, 0.001));
    });

    test('later levels use XP inside the level, not lifetime total', () {
      final progress = LevelService.getLevelFromXP(680);
      expect(progress.currentLevel, 4);
      expect(progress.totalXP, 680);
      expect(progress.progressXP, 230);
      expect(progress.xpSpan, 250);
      expect(progress.xpToNext, 20);
      expect(progress.progressPercentage, closeTo(230 / 250, 0.001));
    });
  });

  group('Cycle protected days', () {
    test('counts days in the active window, not days remaining', () {
      final now = DateTime(2026, 8, 20);
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 18),
        cycleLength: 6,
      );
      expect(data.daysRemainingOn(now), 4);
      expect(
        AchievementsService.protectedDaysUntilToday(
          policy: CycleModePolicy(data),
          now: now,
        ).length,
        3,
      );
    });

    test('disabled cycle with no history is zero', () {
      final now = DateTime(2026, 8, 20);
      final data = CycleModeData.disabled(startDate: now);
      expect(data.daysRemainingOn(now), greaterThan(0));
      expect(
        AchievementsService.protectedDaysUntilToday(
          policy: CycleModePolicy(data),
          now: now,
        ).length,
        0,
      );
    });
  });
}
