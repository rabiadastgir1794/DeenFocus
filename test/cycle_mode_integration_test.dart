import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/cycle_mode_policy.dart';
import 'package:deenly/features/home/services/prayer_analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<TrackablePrayer, PrayerMarkStatus> allFive() => {
        for (final p in TrackablePrayer.values) p: PrayerMarkStatus.onTime,
      };

  String dayKey(DateTime d) => PrayerAnalyticsService.dayKey(d);

  /// Mirrors [HomeTabViewModel._recomputeAnalytics] policy wiring.
  PrayerAnalyticsSnapshot analyticsWithPolicy({
    required DateTime now,
    required CycleModePolicy policy,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> history,
  }) =>
      PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: history,
        isPausedStreakDay: (d) => policy.shouldPauseStreaks(d, now: now),
        isExcludedStatsDay: (d) =>
            policy.shouldExcludeFromStatistics(d, now: now),
      );

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

    test('historical OFF — sealed days stay pink; analytics still apply', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 1),
        cycleLength: 6,
      ).disableOn(DateTime(2026, 8, 4));
      final policy = CycleModePolicy(data);

      expect(policy.isHighlightable(DateTime(2026, 8, 2)), isTrue);
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
      final snap = analyticsWithPolicy(
        now: now,
        policy: policy,
        history: history(),
      );

      // Friday counts; Saturday (cycle) skipped → streak continues from Friday.
      expect(snap.prayerStreak, 5);
      expect(snap.dayStreak, 1);
      expect(snap.weeklyCompleted, 5);
      expect(snap.weeklyPossible, 5);

      final weekDates = WeeklyCalculator.insightsWeekDates(now);
      final highlights = weekDates
          .map((d) => policy.isHighlightable(d, now: now))
          .toList();
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
      final withDraft = analyticsWithPolicy(
        now: now,
        policy: draft,
        history: history(),
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

    test('Case 3 — historical keeps analytics and UI highlight', () {
      final historical = CycleModePolicy(
        CycleModeData(
          isEnabled: true,
          startDate: DateTime(2026, 8, 1),
          cycleLength: 6,
        ).disableOn(DateTime(2026, 8, 4)),
      );
      expect(historical.isHighlightable(saturday), isTrue);
      expect(historical.shouldPauseStreaks(saturday), isTrue);

      final snap = analyticsWithPolicy(
        now: now,
        policy: historical,
        history: history(),
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
        isPausedStreakDay: (d) => policy.shouldPauseStreaks(d, now: now),
      );
      final snap = analyticsWithPolicy(
        now: now,
        policy: policy,
        history: statusHistory,
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

    test('shouldBypassAppLocking while running; ends after planned window', () {
      final policy = activePolicy();
      expect(policy.shouldBypassAppLocking(now: now), isTrue);
      // start Aug 1, length 6 → planned end Aug 6 → bypass until Aug 7 00:00
      expect(
        policy.appLockBypassUntil(now: now),
        DateTime(2026, 8, 7),
      );
      expect(
        policy.shouldBypassAppLocking(now: DateTime(2026, 8, 6, 23)),
        isTrue,
      );
      expect(
        policy.shouldBypassAppLocking(now: DateTime(2026, 8, 7, 9)),
        isFalse,
      );
      expect(
        policy.appLockBypassUntil(now: DateTime(2026, 8, 7, 9)),
        isNull,
      );
    });

    test('app locking bypass does not change streak pause membership', () {
      final policy = activePolicy();
      expect(policy.shouldBypassAppLocking(now: now), isTrue);
      expect(policy.shouldPauseStreaks(saturday, now: now), isTrue);
      expect(policy.isCycleMember(saturday), isTrue);
    });
  });

  group('Cycle Mode flags — pause streaks & exclude statistics', () {
    test('before start: protect prayer streak has no effect', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 29),
        cycleLength: 2,
        pauseStreaks: true,
        excludeFromStatistics: true,
      );
      final now = DateTime(2026, 8, 28, 20, 0);
      final policy = CycleModePolicy(data);
      final history = {
        dayKey(DateTime(2026, 8, 27)): allFive(),
        dayKey(DateTime(2026, 8, 28)): {
          for (final p in TrackablePrayer.values) p: PrayerMarkStatus.missed,
        },
      };
      expect(
        policy.shouldPauseStreaks(DateTime(2026, 8, 29), now: now),
        isFalse,
      );
      expect(
        policy.shouldExcludeFromStatistics(DateTime(2026, 8, 29), now: now),
        isFalse,
      );

      final withFutureCycle = analyticsWithPolicy(
        now: now,
        policy: policy,
        history: history,
      );
      final withoutCycle = analyticsWithPolicy(
        now: now,
        policy: CycleModePolicy(CycleModeData.disabled()),
        history: history,
      );
      // Cycle has not started — same streak outcome as no Cycle Mode at all.
      expect(withFutureCycle.prayerStreak, withoutCycle.prayerStreak);
      expect(withFutureCycle.prayerStreak, 0);
      expect(withFutureCycle.weeklyPossible, withoutCycle.weeklyPossible);
    });

    test('during cycle: protect prayer streak bridges misses on cycle days', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 29),
        cycleLength: 2,
        pauseStreaks: true,
      );
      final now = DateTime(2026, 8, 30, 20, 0);
      final policy = CycleModePolicy(data);

      final result = analyticsWithPolicy(
        now: now,
        policy: policy,
        history: {
          dayKey(DateTime(2026, 8, 27)): allFive(),
          dayKey(DateTime(2026, 8, 28)): allFive(),
          dayKey(DateTime(2026, 8, 29)): {
            TrackablePrayer.fajr: PrayerMarkStatus.missed,
          },
          dayKey(DateTime(2026, 8, 30)): allFive(),
        },
      );
      expect(result.prayerStreak, 10); // Aug 28 (5) + skip Aug 29 + Aug 30 (5)
      expect(result.dayStreak, 2);
    });

    test('during cycle: protect prayer streak off — miss breaks streak', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 29),
        cycleLength: 2,
        pauseStreaks: false,
        excludeFromStatistics: true,
      );
      final now = DateTime(2026, 8, 30, 20, 0);
      final policy = CycleModePolicy(data);

      final result = analyticsWithPolicy(
        now: now,
        policy: policy,
        history: {
          dayKey(DateTime(2026, 8, 27)): allFive(),
          dayKey(DateTime(2026, 8, 28)): allFive(),
          dayKey(DateTime(2026, 8, 29)): {
            TrackablePrayer.fajr: PrayerMarkStatus.missed,
          },
          dayKey(DateTime(2026, 8, 30)): allFive(),
        },
      );
      expect(result.prayerStreak, 5); // broken at Aug 29; only Aug 30 counts
      expect(result.dayStreak, 1);
    });

    test('during cycle: excludeFromStatistics=true shrinks weekly possible', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 29),
        cycleLength: 2,
        pauseStreaks: true,
        excludeFromStatistics: true,
      );
      final now = DateTime(2026, 8, 30, 20, 0);
      final week = WeeklyCalculator.insightsWeekDates(now);
      final policy = CycleModePolicy(data);

      final result = analyticsWithPolicy(
        now: now,
        policy: policy,
        history: {for (final d in week) dayKey(d): allFive()},
      );
      expect(result.weeklyPossible, 25); // 5 normal days × 5 prayers
      expect(result.weeklyCompleted, 25);
    });

    test('during cycle: excludeFromStatistics=false keeps cycle days in stats', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 29),
        cycleLength: 2,
        pauseStreaks: true,
        excludeFromStatistics: false,
      );
      final now = DateTime(2026, 8, 30, 20, 0);
      final week = WeeklyCalculator.insightsWeekDates(now);
      final policy = CycleModePolicy(data);

      final result = analyticsWithPolicy(
        now: now,
        policy: policy,
        history: {for (final d in week) dayKey(d): allFive()},
      );
      expect(result.weeklyPossible, 35); // full week × 5 prayers
      expect(result.weeklyCompleted, 35);
    });

    test('pause and exclude flags are independent per interval', () {
      final now = DateTime(2026, 8, 29, 20, 0);
      final policy = CycleModePolicy(
        CycleModeData(
          isEnabled: true,
          startDate: DateTime(2026, 8, 29),
          cycleLength: 1,
          pauseStreaks: false,
          excludeFromStatistics: false,
        ),
      );
      expect(
        policy.shouldPauseStreaks(DateTime(2026, 8, 29), now: now),
        isFalse,
      );
      expect(
        policy.shouldExcludeFromStatistics(DateTime(2026, 8, 29), now: now),
        isFalse,
      );
    });

    test(
      'protect prayer streak bridges existing streak across cycle without reset',
      () {
        final data = CycleModeData(
          isEnabled: true,
          startDate: DateTime(2026, 8, 29),
          cycleLength: 2,
          pauseStreaks: true,
          excludeFromStatistics: true,
        );
        final policy = CycleModePolicy(data);
        final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
          dayKey(DateTime(2026, 8, 28)): allFive(),
        };
        final aug28Evening = DateTime(2026, 8, 28, 20, 0);

        final aug28 = analyticsWithPolicy(
          now: aug28Evening,
          policy: policy,
          history: history,
        );
        expect(aug28.prayerStreak, 5);
        expect(policy.isRunningOn(aug28Evening), isFalse);
        expect(
          policy.shouldPauseStreaks(DateTime(2026, 8, 29), now: aug28Evening),
          isFalse,
        );

        final aug30 = analyticsWithPolicy(
          now: DateTime(2026, 8, 30, 20, 0),
          policy: policy,
          history: history,
        );
        expect(aug30.prayerStreak, 5);
        expect(aug30.prayerStreak, isNot(0));

        final aug31History = {
          ...history,
          dayKey(DateTime(2026, 8, 31)): {
            TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          },
        };
        final aug31 = analyticsWithPolicy(
          now: DateTime(2026, 8, 31, 10, 0),
          policy: policy,
          history: aug31History,
        );
        expect(aug31.prayerStreak, 6);
        expect(policy.isRunningOn(DateTime(2026, 8, 31)), isFalse);
      },
    );
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
      expect(stopped.isHighlightable(DateTime(2026, 8, 2)), isTrue);
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
      expect(policy.isHighlightable(DateTime(2026, 8, 3)), isTrue);
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
