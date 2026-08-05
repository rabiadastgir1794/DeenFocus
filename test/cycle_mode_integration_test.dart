import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/cycle_mode_policy.dart';
import 'package:deenly/features/home/services/prayer_analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<TrackablePrayer, PrayerMarkStatus> allFive() => {
        for (final p in TrackablePrayer.values) p: PrayerMarkStatus.onTime,
      };

  group('CycleModePolicy — single source of truth', () {
    test('active cycle Aug 1–6 delegates consistently', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 6,
      );
      final policy = CycleModePolicy(data);
      final now = DateTime(2026, 8, 1, 14, 0);

      for (var d = 1; d <= 6; d++) {
        final day = DateTime(2026, 8, d);
        expect(policy.isCycleMember(day), isTrue);
        expect(policy.shouldPauseStreaks(day), isTrue);
        expect(policy.shouldExcludeFromStatistics(day), isTrue);
        expect(policy.isHighlightable(day, now: now), isTrue);
      }
      expect(policy.isCycleMember(DateTime(2026, 8, 7)), isFalse);
      expect(policy.isHighlightable(DateTime(2026, 8, 7), now: now), isFalse);
    });

    test('draft OFF — no highlight, no analytics impact', () {
      final data = CycleModeData.disabled().saveDraft(
        startDate: DateTime(2026, 8, 1),
        cycleLength: 6,
      );
      final policy = CycleModePolicy(data);
      final day = DateTime(2026, 8, 1);

      expect(policy.isHighlightable(day), isFalse);
      expect(policy.shouldPauseStreaks(day), isFalse);
      expect(policy.shouldExcludeFromStatistics(day), isFalse);
    });

    test('historical OFF — no highlight, analytics still apply', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 6,
      ).disableOn(DateTime(2026, 8, 4));
      final policy = CycleModePolicy(data);

      expect(policy.isHighlightable(DateTime(2026, 8, 2)), isFalse);
      expect(policy.shouldPauseStreaks(DateTime(2026, 8, 2)), isTrue);
      expect(policy.shouldExcludeFromStatistics(DateTime(2026, 8, 2)), isTrue);
      expect(policy.isHighlightable(DateTime(2026, 8, 4)), isFalse);
      expect(policy.isCycleMember(DateTime(2026, 8, 4)), isFalse);
    });
  });

  group('Cycle Mode + analytics integration', () {
    final now = DateTime(2026, 8, 1, 16, 0);
    final friday = DateTime(2026, 7, 31);
    final saturday = DateTime(2026, 8, 1);

    CycleModePolicy activePolicy() => CycleModePolicy(
          CycleModeData(
            isEnabled: true,
            startDate: DateTime(2026, 8, 1),
            cycleLength: 6,
          ),
        );

    Map<String, Map<TrackablePrayer, PrayerMarkStatus>> history() => {
          PrayerAnalyticsService.dayKey(friday): allFive(),
          PrayerAnalyticsService.dayKey(saturday): {
            TrackablePrayer.fajr: PrayerMarkStatus.missed,
          },
        };

    test('Case 1 — active cycle pauses streaks and excludes stats', () {
      final policy = activePolicy();
      final snap = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: history(),
        isPausedStreakDay: policy.shouldPauseStreaks,
        isExcludedStatsDay: policy.shouldExcludeFromStatistics,
      );

      // Friday counts; Saturday (cycle) skipped → streak continues from Friday.
      expect(snap.prayerStreak, 5);
      expect(snap.dayStreak, 1);
      expect(snap.weeklyCompleted, 5);
      expect(snap.weeklyPossible, 5);

      final weekDates = WeeklyCalculator.insightsWeekDates(now);
      final highlights = weekDates.map(policy.isHighlightable).toList();
      // Fri–Thu in insights week: Sat Aug 1 through Thu Aug 6 are in-window.
      expect(highlights[1], isTrue); // Sat Aug 1
      expect(highlights[2], isTrue); // Sun Aug 2
      expect(highlights[3], isTrue); // Mon Aug 3
      expect(highlights[4], isTrue); // Tue Aug 4
      expect(highlights[5], isTrue); // Wed Aug 5
      expect(highlights[6], isTrue); // Thu Aug 6
    });

    test('Case 2 — draft leaves analytics unchanged', () {
      final draft = CycleModePolicy(
        CycleModeData.disabled().saveDraft(
          startDate: DateTime(2026, 8, 1),
          cycleLength: 6,
        ),
      );
      final withDraft = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: history(),
        isPausedStreakDay: draft.shouldPauseStreaks,
        isExcludedStatsDay: draft.shouldExcludeFromStatistics,
      );
      final baseline = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: history(),
        isPausedStreakDay: (_) => false,
        isExcludedStatsDay: (_) => false,
      );
      expect(withDraft.prayerStreak, baseline.prayerStreak);
      expect(withDraft.weeklyCompleted, baseline.weeklyCompleted);
    });

    test('Case 3 — historical keeps analytics, no UI highlight', () {
      final historical = CycleModePolicy(
        CycleModeData(
          isEnabled: true,
          startDate: DateTime(2026, 8, 1),
          cycleLength: 6,
        ).disableOn(DateTime(2026, 8, 4)),
      );
      expect(historical.isHighlightable(saturday), isFalse);
      expect(historical.shouldPauseStreaks(saturday), isTrue);

      final snap = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: history(),
        isPausedStreakDay: historical.shouldPauseStreaks,
        isExcludedStatsDay: historical.shouldExcludeFromStatistics,
      );
      expect(snap.prayerStreak, 5);
    });

    test('Case 4 — json round-trip restores active cycle', () {
      final original = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 6,
      );
      final restored = CycleModePolicy(
        CycleModeData.fromJson(original.toJsonMap()),
      );
      expect(restored.isActive, isTrue);
      for (var d = 1; d <= 6; d++) {
        expect(
          restored.isHighlightable(DateTime(2026, 8, d), now: now),
          isTrue,
        );
      }
    });

    test('achievements and Fajr streak respect pause policy', () {
      final policy = activePolicy();
      final statusHistory = {
        PrayerAnalyticsService.dayKey(friday): allFive(),
        PrayerAnalyticsService.dayKey(saturday): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
      };
      final achievements = AchievementCalculator.calculate(
        now: now,
        statusHistory: statusHistory,
        isPausedStreakDay: policy.shouldPauseStreaks,
      );
      final snap = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: statusHistory,
        isPausedStreakDay: policy.shouldPauseStreaks,
        isExcludedStatsDay: policy.shouldExcludeFromStatistics,
      );
      expect(achievements.prayerStreak, snap.prayerStreak);
      expect(achievements.dayStreak, snap.dayStreak);
    });

    test('shouldAllowRestore blocks paused cycle days', () {
      final policy = activePolicy();
      expect(policy.shouldAllowRestore(saturday), isFalse);
      expect(policy.shouldAllowRestore(friday), isTrue);
    });

    test('isTodayProtected and protectsFocusScore on active cycle day', () {
      final policy = activePolicy();
      expect(policy.isTodayProtected(now: now), isTrue);
      expect(policy.protectsFocusScore(now: now), isTrue);
    });
  });

  group('Lifecycle — disable, enable, expiry, restart', () {
    final now = DateTime(2026, 8, 10, 12, 0);

    test('disable seals history; enable starts separate window', () {
      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 6,
      ).disableOn(DateTime(2026, 8, 4));
      final stopped = CycleModePolicy(data);
      expect(stopped.isHighlightable(DateTime(2026, 8, 2)), isFalse);
      expect(stopped.shouldPauseStreaks(DateTime(2026, 8, 2)), isTrue);

      data = data.enableWith(startDate: DateTime(2026, 8, 10), cycleLength: 6);
      final active = CycleModePolicy(data);
      expect(data.history, hasLength(1));
      for (var d = 10; d <= 15; d++) {
        expect(
          active.isHighlightable(DateTime(2026, 8, d), now: now),
          isTrue,
        );
      }
      expect(active.isHighlightable(DateTime(2026, 8, 4), now: now), isFalse);
    });

    test('expiry seals full window once', () {
      final expired = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 6,
      ).expireFully();
      final policy = CycleModePolicy(expired);
      expect(policy.isActive, isFalse);
      expect(policy.isHighlightable(DateTime(2026, 8, 3)), isFalse);
      expect(policy.shouldPauseStreaks(DateTime(2026, 8, 3)), isTrue);
      expect(expired.expireFully().history, expired.history);
    });

    test('restart via json preserves highlight rules', () {
      final raw = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 6,
      );
      final policy = CycleModePolicy(CycleModeData.fromJson(raw.toJsonMap()));
      for (var d = 1; d <= 6; d++) {
        expect(
          policy.isHighlightable(DateTime(2026, 8, d), now: DateTime(2026, 8, 1)),
          isTrue,
        );
      }
    });
  });
}
