import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/prayer_analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Map<TrackablePrayer, PrayerMarkStatus> onTime(List<TrackablePrayer> prayers) =>
      {for (final p in prayers) p: PrayerMarkStatus.onTime};

  Map<TrackablePrayer, PrayerMarkStatus> allFive() =>
      onTime(TrackablePrayer.values);

  bool neverCycle(DateTime _) => false;

  group('PrayerStreakCalculator', () {
    test('onTime and qada increase streak', () {
      final now = DateTime(2026, 8, 1, 16, 0);
      final key = PrayerAnalyticsService.dayKey(now);
      expect(
        PrayerStreakCalculator.calculate(
          now: now,
          statusHistory: {
            key: {
              TrackablePrayer.fajr: PrayerMarkStatus.onTime,
              TrackablePrayer.dhuhr: PrayerMarkStatus.qada,
              TrackablePrayer.asr: PrayerMarkStatus.onTime,
            },
          },
          isCycleDay: neverCycle,
        ),
        3,
      );
    });

    test('missed tip → streak 0', () {
      final now = DateTime(2026, 8, 1, 23, 0);
      final key = PrayerAnalyticsService.dayKey(now);
      expect(
        PrayerStreakCalculator.calculate(
          now: now,
          statusHistory: {
            key: {
              ...allFive(),
              TrackablePrayer.isha: PrayerMarkStatus.missed,
            },
          },
          isCycleDay: neverCycle,
        ),
        0,
      );
    });

    test('unmarked tip → streak 0', () {
      final now = DateTime(2026, 8, 1, 19, 30);
      expect(
        PrayerStreakCalculator.calculate(
          now: now,
          statusHistory: const {},
          isCycleDay: neverCycle,
        ),
        0,
      );
    });
  });

  group('RestoreCalculator', () {
    test('restores forgotten Isha within 24h and recalculates streak', () {
      // Morning after: before Fajr — tip is yesterday Isha (missed).
      final now = DateTime(2026, 8, 1, 4, 0);
      final yesterday = DateTime(2026, 7, 31);
      final yKey = PrayerAnalyticsService.dayKey(yesterday);

      // Build prior chain: 4 full days before yesterday + yesterday missing Isha.
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{};
      for (var i = 1; i <= 4; i++) {
        final d = yesterday.subtract(Duration(days: i));
        history[PrayerAnalyticsService.dayKey(d)] = allFive();
      }
      history[yKey] = {
        TrackablePrayer.fajr: PrayerMarkStatus.onTime,
        TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
        TrackablePrayer.asr: PrayerMarkStatus.onTime,
        TrackablePrayer.maghrib: PrayerMarkStatus.onTime,
        TrackablePrayer.isha: PrayerMarkStatus.missed,
      };

      expect(
        PrayerStreakCalculator.calculate(
          now: now,
          statusHistory: history,
          isCycleDay: neverCycle,
        ),
        0,
      );

      final target = RestoreCalculator.findTarget(
        now: now,
        statusHistory: history,
        isCycleDay: neverCycle,
      );
      expect(target, isNotNull);
      expect(target!.prayer, TrackablePrayer.isha);
      expect(target.dateKey, yKey);

      final restored = RestoreCalculator.apply(
        statusHistory: history,
        target: target,
      );
      expect(restored[yKey]![TrackablePrayer.isha], PrayerMarkStatus.onTime);

      final snap = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: restored,
        isCycleDay: neverCycle,
      );
      // 5 prior full days including yesterday = 25
      expect(snap.prayerStreak, 25);
      expect(snap.dayStreak, 5);
      // Charts updated — Isha now counts
      expect(snap.weeklyCompleted, greaterThan(0));
      expect(snap.canRestoreStreak, isFalse);
    });

    test('multiple restorations fix newest break first', () {
      final now = DateTime(2026, 8, 1, 12, 53);
      final today = PrayerAnalyticsService.dayKey(now);
      final yesterday = PrayerAnalyticsService.dayKey(
        now.subtract(const Duration(days: 1)),
      );
      final history = {
        yesterday: {
          ...onTime([
            TrackablePrayer.fajr,
            TrackablePrayer.dhuhr,
            TrackablePrayer.asr,
            TrackablePrayer.maghrib,
          ]),
          TrackablePrayer.isha: PrayerMarkStatus.missed,
        },
        today: onTime([TrackablePrayer.fajr]),
      };

      final first = RestoreCalculator.findTarget(
        now: now,
        statusHistory: history,
        isCycleDay: neverCycle,
      );
      // Newest break is today's Dhuhr (started, unmarked).
      expect(first!.prayer, TrackablePrayer.dhuhr);

      final afterFirst = RestoreCalculator.apply(
        statusHistory: history,
        target: first,
      );
      final second = RestoreCalculator.findTarget(
        now: now,
        statusHistory: afterFirst,
        isCycleDay: neverCycle,
      );
      expect(second!.prayer, TrackablePrayer.isha);
    });

    test('break older than 24h cannot be restored', () {
      final now = DateTime(2026, 8, 2, 3, 0); // before Fajr
      final yesterday = DateTime(2026, 8, 1);
      final oldDay = DateTime(2026, 7, 30); // Isha well outside 24h
      final history = {
        PrayerAnalyticsService.dayKey(yesterday): allFive(),
        PrayerAnalyticsService.dayKey(oldDay): {
          ...onTime([
            TrackablePrayer.fajr,
            TrackablePrayer.dhuhr,
            TrackablePrayer.asr,
            TrackablePrayer.maghrib,
          ]),
          TrackablePrayer.isha: PrayerMarkStatus.missed,
        },
      };
      expect(
        RestoreCalculator.findTarget(
          now: now,
          statusHistory: history,
          isCycleDay: neverCycle,
        ),
        isNull,
      );
    });

    test('does not invent other prayers — only the broken slot', () {
      final now = DateTime(2026, 8, 1, 4, 0);
      final yesterday = DateTime(2026, 7, 31);
      final yKey = PrayerAnalyticsService.dayKey(yesterday);
      final history = {
        yKey: {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.isha: PrayerMarkStatus.missed,
        },
      };
      final target = RestoreCalculator.findTarget(
        now: now,
        statusHistory: history,
        isCycleDay: neverCycle,
      )!;
      final restored = RestoreCalculator.apply(
        statusHistory: history,
        target: target,
      );
      expect(restored[yKey]!.keys.toSet(), {
        TrackablePrayer.fajr,
        TrackablePrayer.isha,
      });
      expect(restored[yKey]!.containsKey(TrackablePrayer.dhuhr), isFalse);
    });

    test('fresh install / empty past — no Restore for healthy tip', () {
      // Before default Asr hour so tip is Dhuhr (streak 2), not Asr unmarked.
      final now = DateTime(2026, 8, 11, 14, 30);
      final key = PrayerAnalyticsService.dayKey(now);
      final history = {
        key: {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
        },
      };
      final snap = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: history,
        isCycleDay: neverCycle,
      );
      expect(snap.prayerStreak, 2);
      expect(snap.canRestoreStreak, isFalse);
      expect(
        RestoreCalculator.findTarget(
          now: now,
          statusHistory: history,
          isCycleDay: neverCycle,
        ),
        isNull,
      );
    });

    test('valid unbroken streak — no Restore', () {
      final now = DateTime(2026, 8, 11, 21, 0);
      final today = DateTime(2026, 8, 11);
      final yesterday = DateTime(2026, 8, 10);
      final history = {
        PrayerAnalyticsService.dayKey(yesterday): allFive(),
        PrayerAnalyticsService.dayKey(today): allFive(),
      };
      expect(
        PrayerAnalyticsService.calculate(
          now: now,
          statusHistory: history,
          isCycleDay: neverCycle,
        ).canRestoreStreak,
        isFalse,
      );
    });

    test('broken within 24h with prior chain — Restore appears', () {
      final now = DateTime(2026, 8, 11, 21, 30);
      final today = DateTime(2026, 8, 11);
      final history = {
        PrayerAnalyticsService.dayKey(today): {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
          TrackablePrayer.asr: PrayerMarkStatus.onTime,
          TrackablePrayer.maghrib: PrayerMarkStatus.onTime,
          TrackablePrayer.isha: PrayerMarkStatus.missed,
        },
      };
      final snap = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: history,
        isCycleDay: neverCycle,
      );
      expect(snap.prayerStreak, 0);
      expect(snap.canRestoreStreak, isTrue);
      expect(snap.restoreTarget!.prayer, TrackablePrayer.isha);
    });

    test('does not create a streak from scratch (miss with no older marks)', () {
      final now = DateTime(2026, 8, 11, 10, 0);
      final history = {
        PrayerAnalyticsService.dayKey(now): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
      };
      expect(
        RestoreCalculator.findTarget(
          now: now,
          statusHistory: history,
          isCycleDay: neverCycle,
        ),
        isNull,
      );
    });

    test('Cycle Mode pause skips break on paused day for Restore', () {
      // Morning: yesterday Isha (20:00) still inside 24h window.
      final now = DateTime(2026, 8, 11, 10, 0);
      final today = DateTime(2026, 8, 11);
      final yesterday = DateTime(2026, 8, 10);
      final history = {
        PrayerAnalyticsService.dayKey(yesterday): {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
          TrackablePrayer.asr: PrayerMarkStatus.onTime,
          TrackablePrayer.maghrib: PrayerMarkStatus.onTime,
          TrackablePrayer.isha: PrayerMarkStatus.missed,
        },
      };
      bool pausedToday(DateTime d) =>
          PrayerAnalyticsService.dayKey(d) ==
          PrayerAnalyticsService.dayKey(today);

      final during = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: history,
        isPausedStreakDay: pausedToday,
        isExcludedStatsDay: pausedToday,
      );
      expect(during.canRestoreStreak, isTrue);
      expect(during.restoreTarget!.prayer, TrackablePrayer.isha);
      expect(
        during.restoreTarget!.dateKey,
        PrayerAnalyticsService.dayKey(yesterday),
      );

      // After OFF with healthy tip — no Restore.
      final healthy = {
        PrayerAnalyticsService.dayKey(today): {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
        },
      };
      expect(
        PrayerAnalyticsService.calculate(
          now: DateTime(2026, 8, 11, 14, 30),
          statusHistory: healthy,
          isCycleDay: neverCycle,
        ).canRestoreStreak,
        isFalse,
      );
    });
  });

  group('sync snapshot', () {
    test('single calculate feeds streaks and charts', () {
      final now = DateTime(2026, 8, 1, 16, 0);
      final key = PrayerAnalyticsService.dayKey(now);
      final snap = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: {
          key: onTime([
            TrackablePrayer.fajr,
            TrackablePrayer.dhuhr,
            TrackablePrayer.asr,
          ]),
        },
        isCycleDay: neverCycle,
      );
      expect(snap.prayerStreak, 3);
      expect(snap.weeklyCompleted, 3);
      expect(snap.weekDayCounts.contains(3), isTrue);
      expect(snap.homeWeekDayCounts.contains(3), isTrue);
    });

  });

  group('Cycle mode — paused days', () {
    /// History: Day-2 full, Day-1 cycle (empty/missed marks), Today full.
    /// Streak must bridge across the cycle day unchanged.
    Map<String, Map<TrackablePrayer, PrayerMarkStatus>> bridgeHistory(
      DateTime now,
    ) {
      final today = DateTime(now.year, now.month, now.day);
      final cycleDay = today.subtract(const Duration(days: 1));
      final before = today.subtract(const Duration(days: 2));
      return {
        PrayerAnalyticsService.dayKey(before): allFive(),
        PrayerAnalyticsService.dayKey(cycleDay): {
          // Even if marks exist / are missed, cycle day must be ignored.
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        PrayerAnalyticsService.dayKey(today): allFive(),
      };
    }

    bool Function(DateTime) cycleYesterday(DateTime now) {
      final cycleKey = PrayerAnalyticsService.dayKey(
        DateTime(now.year, now.month, now.day).subtract(const Duration(days: 1)),
      );
      return (DateTime d) => PrayerAnalyticsService.dayKey(d) == cycleKey;
    }

    test('prayer streak continues across cycle day (not reset, not increased)', () {
      final now = DateTime(2026, 8, 1, 23, 0);
      final history = bridgeHistory(now);
      final isCycle = cycleYesterday(now);

      final withCycle = PrayerStreakCalculator.calculate(
        now: now,
        statusHistory: history,
        isCycleDay: isCycle,
      );
      // Today 5 + day-before-cycle 5 = 10. Cycle day skipped.
      expect(withCycle, 10);

      // Without pause, missed Fajr on yesterday would break after today's 5.
      final withoutCycle = PrayerStreakCalculator.calculate(
        now: now,
        statusHistory: history,
        isCycleDay: neverCycle,
      );
      expect(withoutCycle, 5);
    });

    test('day streak continues across cycle day', () {
      final now = DateTime(2026, 8, 1, 23, 0);
      final history = bridgeHistory(now);
      expect(
        DayStreakCalculator.calculate(
          now: now,
          statusHistory: history,
          isCycleDay: cycleYesterday(now),
        ),
        2, // today + day before cycle
      );
    });

    test('cycle day does not increase prayer or day streak', () {
      final now = DateTime(2026, 8, 1, 23, 0);
      final today = DateTime(now.year, now.month, now.day);
      final cycleDay = today.subtract(const Duration(days: 1));
      final before = today.subtract(const Duration(days: 2));
      // Cycle day falsely marked complete — must still not add to streaks.
      final history = {
        PrayerAnalyticsService.dayKey(before): allFive(),
        PrayerAnalyticsService.dayKey(cycleDay): allFive(),
        PrayerAnalyticsService.dayKey(today): allFive(),
      };
      final isCycle = cycleYesterday(now);
      expect(
        PrayerStreakCalculator.calculate(
          now: now,
          statusHistory: history,
          isCycleDay: isCycle,
        ),
        10,
      );
      expect(
        DayStreakCalculator.calculate(
          now: now,
          statusHistory: history,
          isCycleDay: isCycle,
        ),
        2,
      );
    });

    test('weekly stats exclude cycle days from completed and possible', () {
      final now = DateTime(2026, 7, 31, 23, 0); // Friday
      final week = WeeklyCalculator.insightsWeekDates(now);
      // Mark every non-future day complete; pause Saturday.
      final saturday = week[1]; // Fri, Sat, Sun, Mon, Tue, Wed, Thu
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{};
      for (final d in week) {
        history[PrayerAnalyticsService.dayKey(d)] = allFive();
      }
      bool isCycle(DateTime d) =>
          PrayerAnalyticsService.dayKey(d) ==
          PrayerAnalyticsService.dayKey(saturday);

      final weekly = WeeklyCalculator.calculate(
        now: now,
        statusHistory: history,
        isCycleDay: isCycle,
      );
      expect(weekly.possible, 30); // 6 days × 5
      expect(weekly.completed, 30);

      final baseline = WeeklyCalculator.calculate(
        now: now,
        statusHistory: history,
        isCycleDay: neverCycle,
      );
      expect(baseline.possible, 35);
      expect(baseline.completed, 35);
    });

    test('monthly stats exclude cycle days from completed and possible', () {
      final now = DateTime(2026, 7, 31, 23, 0);
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{};
      for (final d in MonthlyCalculator.monthDatesFor(now)) {
        history[PrayerAnalyticsService.dayKey(d)] = allFive();
      }
      final cycleDates = {
        PrayerAnalyticsService.dayKey(DateTime(2026, 7, 10)),
        PrayerAnalyticsService.dayKey(DateTime(2026, 7, 11)),
      };
      bool isCycle(DateTime d) =>
          cycleDates.contains(PrayerAnalyticsService.dayKey(d));

      final monthly = MonthlyCalculator.calculate(
        now: now,
        statusHistory: history,
        isCycleDay: isCycle,
      );
      expect(monthly.possible, 29 * 5); // July 31 − 2 cycle days
      expect(monthly.completed, 29 * 5);
    });

    test('prayer rate excludes cycle days from numerator and denominator', () {
      final now = DateTime(2026, 8, 1, 12, 0);
      final today = DateTime(now.year, now.month, now.day);
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{};
      for (var i = 0; i < 30; i++) {
        final d = today.subtract(Duration(days: i));
        history[PrayerAnalyticsService.dayKey(d)] = allFive();
      }
      final cycleKey = PrayerAnalyticsService.dayKey(
        today.subtract(const Duration(days: 1)),
      );
      bool isCycle(DateTime d) => PrayerAnalyticsService.dayKey(d) == cycleKey;

      final rate = PrayerRateCalculator.calculate(
        now: now,
        statusHistory: history,
        isCycleDay: isCycle,
        lookbackDays: 30,
      );
      expect(rate, 100);

      // Corrupt the cycle day marks — rate must stay 100.
      history[cycleKey] = {TrackablePrayer.fajr: PrayerMarkStatus.missed};
      expect(
        PrayerRateCalculator.calculate(
          now: now,
          statusHistory: history,
          isCycleDay: isCycle,
          lookbackDays: 30,
        ),
        100,
      );
    });

    test('home week bars show 0 on cycle days; streaks bridge pause', () {
      final now = DateTime(2026, 8, 1, 23, 0); // Saturday
      final history = bridgeHistory(now);
      final snap = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: history,
        isCycleDay: cycleYesterday(now),
      );
      // Mon-week: Mon=0 … Fri=4 (cycle yesterday), Sat=5 (today).
      expect(snap.homeWeekDayCounts[4], 0);
      expect(snap.homeWeekDayCounts[5], 5);
      expect(snap.prayerStreak, 10);
      expect(snap.dayStreak, 2);
    });

    test('achievements use paused streak values', () {
      final now = DateTime(2026, 8, 1, 23, 0);
      final inputs = AchievementCalculator.calculate(
        now: now,
        statusHistory: bridgeHistory(now),
        isCycleDay: cycleYesterday(now),
      );
      expect(inputs.prayerStreak, 10);
      expect(inputs.dayStreak, 2);
    });

    test('fajr streak bridges across cycle days', () {
      final now = DateTime(2026, 8, 1, 23, 0);
      final today = DateTime(now.year, now.month, now.day);
      final cycleDay = today.subtract(const Duration(days: 1));
      final before = today.subtract(const Duration(days: 2));
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        PrayerAnalyticsService.dayKey(before): allFive(),
        PrayerAnalyticsService.dayKey(cycleDay): const {},
        PrayerAnalyticsService.dayKey(today): allFive(),
      };
      expect(
        AchievementCalculator.fajrOnTimeStreakDays(
          now: now,
          statusHistory: history,
          isCycleDay: cycleYesterday(now),
        ),
        2,
      );
      expect(
        AchievementCalculator.fajrOnTimeStreakDays(
          now: now,
          statusHistory: history,
          isCycleDay: neverCycle,
        ),
        1, // stops at empty cycle day when not paused
      );
    });

    test('restore ignores breaks on cycle days', () {
      // After Fajr: today complete; yesterday (cycle) has missed Isha in window.
      final now = DateTime(2026, 8, 1, 6, 0);
      final today = DateTime(now.year, now.month, now.day);
      final cycleDay = today.subtract(const Duration(days: 1));
      final history = {
        PrayerAnalyticsService.dayKey(today): onTime([TrackablePrayer.fajr]),
        PrayerAnalyticsService.dayKey(cycleDay): {
          ...onTime([
            TrackablePrayer.fajr,
            TrackablePrayer.dhuhr,
            TrackablePrayer.asr,
            TrackablePrayer.maghrib,
          ]),
          TrackablePrayer.isha: PrayerMarkStatus.missed,
        },
      };
      bool isCycle(DateTime d) =>
          PrayerAnalyticsService.dayKey(d) ==
          PrayerAnalyticsService.dayKey(cycleDay);

      expect(
        RestoreCalculator.findTarget(
          now: now,
          statusHistory: history,
          isCycleDay: isCycle,
        ),
        isNull,
      );
      expect(
        RestoreCalculator.findTarget(
          now: now,
          statusHistory: history,
          isCycleDay: neverCycle,
        ),
        isNotNull,
      );
    });

    test('restore finds non-cycle break while skipping cycle day', () {
      final now = DateTime(2026, 8, 1, 16, 0);
      final today = DateTime(now.year, now.month, now.day);
      final cycleDay = today.subtract(const Duration(days: 1));
      final history = {
        PrayerAnalyticsService.dayKey(today): {
          ...onTime([TrackablePrayer.fajr, TrackablePrayer.dhuhr]),
          TrackablePrayer.asr: PrayerMarkStatus.missed,
        },
        PrayerAnalyticsService.dayKey(cycleDay): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
      };
      bool isCycle(DateTime d) =>
          PrayerAnalyticsService.dayKey(d) ==
          PrayerAnalyticsService.dayKey(cycleDay);

      final target = RestoreCalculator.findTarget(
        now: now,
        statusHistory: history,
        isCycleDay: isCycle,
      );
      expect(target, isNotNull);
      expect(target!.prayer, TrackablePrayer.asr);
      expect(target.dateKey, PrayerAnalyticsService.dayKey(today));
    });

    test('today in cycle mode preserves prior streak (does not reset)', () {
      final now = DateTime(2026, 8, 1, 15, 0);
      final today = DateTime(now.year, now.month, now.day);
      final yesterday = today.subtract(const Duration(days: 1));
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        PrayerAnalyticsService.dayKey(yesterday): allFive(),
        // Today unmarked after Dhuhr — would reset if not paused.
        PrayerAnalyticsService.dayKey(today): const {},
      };
      bool isCycle(DateTime d) =>
          PrayerAnalyticsService.dayKey(d) ==
          PrayerAnalyticsService.dayKey(today);

      expect(
        PrayerStreakCalculator.calculate(
          now: now,
          statusHistory: history,
          isCycleDay: isCycle,
        ),
        5,
      );
      // Unmarked started slots no longer reset a prior chain (only Missed does).
      expect(
        PrayerStreakCalculator.calculate(
          now: now,
          statusHistory: history,
          isCycleDay: neverCycle,
        ),
        5,
      );
      history[PrayerAnalyticsService.dayKey(today)] = {
        TrackablePrayer.fajr: PrayerMarkStatus.missed,
      };
      expect(
        PrayerStreakCalculator.calculate(
          now: now,
          statusHistory: history,
          isCycleDay: neverCycle,
        ),
        0,
      );
    });

    test('full snapshot: rate/weekly/monthly ignore cycle day marks', () {
      final now = DateTime(2026, 7, 31, 23, 0); // Friday
      final today = DateTime(now.year, now.month, now.day);
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{};
      for (var i = 0; i < 40; i++) {
        final d = today.subtract(Duration(days: i));
        history[PrayerAnalyticsService.dayKey(d)] = allFive();
      }
      // Also fill forward week days used by weekly chart.
      for (final d in WeeklyCalculator.insightsWeekDates(now)) {
        history.putIfAbsent(PrayerAnalyticsService.dayKey(d), allFive);
      }
      // Pause today — in week (Fri) and month (July).
      final cycleKey = PrayerAnalyticsService.dayKey(today);
      history[cycleKey] = {TrackablePrayer.fajr: PrayerMarkStatus.missed};
      bool isCycle(DateTime d) => PrayerAnalyticsService.dayKey(d) == cycleKey;

      final snap = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: history,
        isCycleDay: isCycle,
      );
      expect(snap.weeklyPossible, 30); // 7 − 1 cycle
      expect(snap.weeklyCompleted, 30);
      expect(snap.monthlyPossible, 30 * 5); // July 31 − 1 cycle day
      expect(snap.monthlyCompleted, 30 * 5);
      expect(snap.prayerRatePercent, 100);
      expect(snap.weekDayCounts[0], 0); // Friday = cycle
      // Today paused; prior full days still form the streak chain.
      expect(snap.prayerStreak, 39 * 5);
      expect(snap.dayStreak, 39);
    });
  });

  group('Cycle mode — configurable flags', () {
    test('pauseStreaks=false does not bridge; streak can break on cycle day', () {
      final now = DateTime(2026, 8, 1, 23, 0);
      final today = DateTime(now.year, now.month, now.day);
      final cycleDay = today.subtract(const Duration(days: 1));
      final before = today.subtract(const Duration(days: 2));
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        PrayerAnalyticsService.dayKey(before): allFive(),
        PrayerAnalyticsService.dayKey(cycleDay): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        PrayerAnalyticsService.dayKey(today): allFive(),
      };
      bool isCycle(DateTime d) =>
          PrayerAnalyticsService.dayKey(d) ==
          PrayerAnalyticsService.dayKey(cycleDay);

      final paused = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: history,
        isCycleDay: isCycle,
        pauseStreaks: true,
        excludeFromStatistics: true,
      );
      expect(paused.prayerStreak, 10);

      final unpaused = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: history,
        isCycleDay: isCycle,
        pauseStreaks: false,
        excludeFromStatistics: true,
      );
      expect(unpaused.prayerStreak, 5); // breaks at cycle-day miss
    });

    test('excludeFromStatistics=false keeps cycle days in weekly possible', () {
      final now = DateTime(2026, 7, 31, 23, 0); // Friday
      final week = WeeklyCalculator.insightsWeekDates(now);
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        for (final d in week) PrayerAnalyticsService.dayKey(d): allFive(),
      };
      final cycleKey = PrayerAnalyticsService.dayKey(week[0]);
      bool isCycle(DateTime d) => PrayerAnalyticsService.dayKey(d) == cycleKey;

      final excluded = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: history,
        isCycleDay: isCycle,
        pauseStreaks: true,
        excludeFromStatistics: true,
      );
      expect(excluded.weeklyPossible, 30);

      final included = PrayerAnalyticsService.calculate(
        now: now,
        statusHistory: history,
        isCycleDay: isCycle,
        pauseStreaks: true,
        excludeFromStatistics: false,
      );
      expect(included.weeklyPossible, 35);
      expect(included.weeklyCompleted, 35);
      expect(included.weekDayCounts[0], 5);
    });

    test('multi-day cycle window pauses streak across Tue–Thu', () {
      // Mon complete → streak 25 prayers before cycle;
      // Tue–Thu cycle; Fri complete → streak continues then +5.
      final friday = DateTime(2026, 7, 31, 23, 0);
      final monday = DateTime(2026, 7, 27);
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{};
      // Build 5 full days before Monday so Mon tip continues a long chain,
      // then Mon full (=5), Fri full (=5) → streak 10 after pause window.
      for (var i = 1; i <= 4; i++) {
        history[PrayerAnalyticsService.dayKey(
          monday.subtract(Duration(days: i)),
        )] = allFive();
      }
      history[PrayerAnalyticsService.dayKey(monday)] = allFive();
      for (final d in [
        DateTime(2026, 7, 28),
        DateTime(2026, 7, 29),
        DateTime(2026, 7, 30),
      ]) {
        history[PrayerAnalyticsService.dayKey(d)] = {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        };
      }
      history[PrayerAnalyticsService.dayKey(friday)] = allFive();

      final cycleKeys = {
        PrayerAnalyticsService.dayKey(DateTime(2026, 7, 28)),
        PrayerAnalyticsService.dayKey(DateTime(2026, 7, 29)),
        PrayerAnalyticsService.dayKey(DateTime(2026, 7, 30)),
      };
      bool isCycle(DateTime d) =>
          cycleKeys.contains(PrayerAnalyticsService.dayKey(d));

      // After Friday complete: Fri 5 + Mon 5 + 4 prior days = 30.
      expect(
        PrayerStreakCalculator.calculate(
          now: friday,
          statusHistory: history,
          isCycleDay: isCycle,
        ),
        30,
      );

      // During Wednesday (mid-cycle): streak held at Mon chain = 25.
      final wednesday = DateTime(2026, 7, 29, 23, 0);
      expect(
        PrayerStreakCalculator.calculate(
          now: wednesday,
          statusHistory: history,
          isCycleDay: isCycle,
        ),
        25,
      );
    });
  });
}
