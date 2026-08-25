import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/cycle_mode_policy.dart';
import 'package:deenly/features/home/services/prayer_analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Simulates cold-start reload via JSON round-trip.
CycleModeData coldStart(CycleModeData data) =>
    CycleModeData.fromJson(data.toJsonMap());

void main() {
  Map<TrackablePrayer, PrayerMarkStatus> allFive() => {
        for (final p in TrackablePrayer.values) p: PrayerMarkStatus.onTime,
      };

  group('Policy verification', () {
    test('toggle OFF — no pink on historical days (intentional)', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 6,
      ).disableOn(DateTime(2026, 8, 4));
      final policy = CycleModePolicy(data);

      expect(policy.isActive, isFalse);
      expect(policy.isCycleMember(DateTime(2026, 8, 2)), isTrue);
      expect(policy.shouldPauseStreaks(DateTime(2026, 8, 2)), isTrue);
      expect(policy.isHighlightable(DateTime(2026, 8, 2)), isFalse);
    });

    test('active window — future days inside range are highlightable', () {
      final policy = CycleModePolicy(
        CycleModeData(
          isEnabled: true,
          startDate: DateTime(2026, 8, 1),
          cycleLength: 6,
        ),
      );
      final today = DateTime(2026, 8, 1);
      for (var d = 1; d <= 6; d++) {
        expect(
          policy.isHighlightable(DateTime(2026, 8, d), now: today),
          isTrue,
          reason: 'Aug $d is inside the active window',
        );
        expect(policy.isCycleMember(DateTime(2026, 8, d)), isTrue);
      }
      expect(
        policy.isHighlightable(DateTime(2026, 8, 7), now: today),
        isFalse,
      );
    });
  });

  group('Full restart sequence', () {
    final aug1 = DateTime(2026, 8, 1, 16, 0);
    final aug2 = DateTime(2026, 8, 2, 16, 0);
    final aug5 = DateTime(2026, 8, 5, 16, 0);

    test('enable → restart → mark → disable → enable → restart', () {
      // 1. Enable cycle mode (1 Aug, 6 days).
      var data = CycleModeData.disabled()
          .saveDraft(startDate: DateTime(2026, 8, 1), cycleLength: 6)
          .enableWith(startDate: DateTime(2026, 8, 1), cycleLength: 6);

      // 2. Close app / cold start.
      data = coldStart(data);
      var policy = CycleModePolicy(data);
      expect(policy.isActive, isTrue);
      for (var d = 1; d <= 6; d++) {
        expect(
          policy.isHighlightable(DateTime(2026, 8, d), now: aug1),
          isTrue,
        );
      }

      // 3. Mark a prayer on 1 Aug (Fajr on time).
      var statusHistory = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        PrayerAnalyticsService.dayKey(DateTime(2026, 7, 31)): allFive(),
        PrayerAnalyticsService.dayKey(DateTime(2026, 8, 1)): {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
        },
      };

      var snap = PrayerAnalyticsService.calculate(
        now: aug1,
        statusHistory: statusHistory,
        isPausedStreakDay: policy.shouldPauseStreaks,
        isExcludedStatsDay: policy.shouldExcludeFromStatistics,
      );
      expect(snap.prayerStreak, 6); // Jul 31 + Aug 1 Fajr when Cycle starts today
      expect(snap.weeklyCompleted, 5);
      expect(snap.weeklyPossible, 5);

      // 4. Disable on 2 Aug (seals 1 Aug only).
      data = data.disableOn(DateTime(2026, 8, 2));
      policy = CycleModePolicy(data);
      expect(data.history, hasLength(1));
      expect(policy.isHighlightable(DateTime(2026, 8, 1)), isFalse);
      expect(policy.isCycleMember(DateTime(2026, 8, 1)), isTrue);

      statusHistory = {
        ...statusHistory,
        PrayerAnalyticsService.dayKey(DateTime(2026, 8, 2)): allFive(),
      };

      snap = PrayerAnalyticsService.calculate(
        now: aug2,
        statusHistory: statusHistory,
        isPausedStreakDay: policy.shouldPauseStreaks,
        isExcludedStatsDay: policy.shouldExcludeFromStatistics,
      );
      expect(snap.prayerStreak, 10); // Jul 31 (5) + Aug 2 (5); Aug 1 skipped

      // 5. Enable again (5 Aug, 6 days) — separate from first cycle.
      data = data.enableWith(startDate: DateTime(2026, 8, 5), cycleLength: 6);
      policy = CycleModePolicy(data);
      expect(data.history, hasLength(1));
      expect(data.history.single.endDate, DateTime(2026, 8, 1));

      // 6. Second cold start.
      data = coldStart(data);
      policy = CycleModePolicy(data);

      statusHistory = {
        ...statusHistory,
        PrayerAnalyticsService.dayKey(DateTime(2026, 8, 4)): allFive(),
        PrayerAnalyticsService.dayKey(DateTime(2026, 8, 5)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
      };

      snap = PrayerAnalyticsService.calculate(
        now: aug5,
        statusHistory: statusHistory,
        isPausedStreakDay: policy.shouldPauseStreaks,
        isExcludedStatsDay: policy.shouldExcludeFromStatistics,
      );
      final achievements = AchievementCalculator.calculate(
        now: aug5,
        statusHistory: statusHistory,
        isPausedStreakDay: policy.shouldPauseStreaks,
      );

      expect(snap.prayerStreak, achievements.prayerStreak);
      expect(snap.dayStreak, achievements.dayStreak);
      expect(snap.prayerRatePercent, isNonNegative);
      expect(snap.monthlyPossible, isPositive);
      expect(data.history, hasLength(1)); // no duplicate history

      // Restore skips cycle day; finds break on 4 Aug if within window.
      expect(policy.shouldAllowRestore(DateTime(2026, 8, 5)), isFalse);
      expect(policy.shouldAllowRestore(DateTime(2026, 8, 4)), isTrue);

      final restoreTarget = RestoreCalculator.findTarget(
        now: DateTime(2026, 8, 5, 20, 0),
        statusHistory: {
          ...statusHistory,
          PrayerAnalyticsService.dayKey(DateTime(2026, 8, 5)): {
            TrackablePrayer.isha: PrayerMarkStatus.missed,
          },
        },
        isCycleDay: (d) => !policy.shouldAllowRestore(d),
        prayerStartTime: (p) => DateTime(2026, 8, 5, 10 + p.index),
      );
      expect(restoreTarget, isNull); // break is on cycle day Aug 5
    });
  });
}
