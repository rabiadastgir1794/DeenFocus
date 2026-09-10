import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/cycle_mode_policy.dart';
import 'package:deenly/features/home/services/prayer_analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Product rules for Prayer Streak / Day Streak / Cycle Mode — acceptance tests.
void main() {
  Map<TrackablePrayer, PrayerMarkStatus> onTime(List<TrackablePrayer> prayers) =>
      {for (final p in prayers) p: PrayerMarkStatus.onTime};

  Map<TrackablePrayer, PrayerMarkStatus> allFive([
    PrayerMarkStatus status = PrayerMarkStatus.onTime,
  ]) =>
      {for (final p in TrackablePrayer.values) p: status};

  String key(DateTime d) => PrayerAnalyticsService.dayKey(d);

  bool neverPause(DateTime _) => false;

  /// Fallback hours used when no schedule is injected: 5, 12, 15, 18, 20.
  DateTime atHour(DateTime day, int hour, [int minute = 0]) =>
      DateTime(day.year, day.month, day.day, hour, minute);

  PrayerAnalyticsSnapshot snap({
    required DateTime now,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> history,
    bool Function(DateTime date)? isPaused,
  }) {
    return PrayerAnalyticsService.calculate(
      now: now,
      statusHistory: history,
      isPausedStreakDay: isPaused ?? neverPause,
      isExcludedStatsDay: isPaused ?? neverPause,
    );
  }

  group('Prayer Count — daily aggregation', () {
    test('today 0/5 through 5/5 grow prayer count by day total', () {
      final day = DateTime(2026, 8, 10);
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{};

      expect(snap(now: atHour(day, 21), history: history).prayerStreak, 0);

      history[key(day)] = onTime([TrackablePrayer.fajr]);
      expect(snap(now: atHour(day, 21), history: history).prayerStreak, 1);

      history[key(day)] = onTime([
        TrackablePrayer.fajr,
        TrackablePrayer.dhuhr,
      ]);
      expect(snap(now: atHour(day, 21), history: history).prayerStreak, 2);

      history[key(day)] = onTime([
        TrackablePrayer.fajr,
        TrackablePrayer.dhuhr,
        TrackablePrayer.asr,
      ]);
      expect(snap(now: atHour(day, 21), history: history).prayerStreak, 3);

      history[key(day)] = onTime([
        TrackablePrayer.fajr,
        TrackablePrayer.dhuhr,
        TrackablePrayer.asr,
        TrackablePrayer.maghrib,
      ]);
      expect(snap(now: atHour(day, 21), history: history).prayerStreak, 4);

      history[key(day)] = allFive();
      final full = snap(now: atHour(day, 21), history: history);
      expect(full.prayerStreak, 5);
      expect(full.dayStreak, 1);
    });

    test('Missed position within the day does not change the count', () {
      final day = DateTime(2026, 8, 10);
      final four = onTime([
        TrackablePrayer.fajr,
        TrackablePrayer.dhuhr,
        TrackablePrayer.asr,
        TrackablePrayer.maghrib,
      ]);

      for (final missed in [
        TrackablePrayer.fajr,
        TrackablePrayer.dhuhr,
        TrackablePrayer.asr,
        TrackablePrayer.maghrib,
      ]) {
        final history = {
          key(day): {
            ...four,
            missed: PrayerMarkStatus.missed,
          },
        };
        expect(
          snap(now: atHour(day, 21), history: history).prayerStreak,
          3,
          reason: 'Missed at $missed must leave count 3',
        );
      }

      final ishaMissed = {
        key(day): {
          ...allFive(),
          TrackablePrayer.isha: PrayerMarkStatus.missed,
        },
      };
      expect(
        snap(now: atHour(day, 21), history: ishaMissed).prayerStreak,
        4,
      );
    });

    test('Qada counts as completed', () {
      final day = DateTime(2026, 8, 10);
      final history = {
        key(day): {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.dhuhr: PrayerMarkStatus.qada,
          TrackablePrayer.asr: PrayerMarkStatus.onTime,
        },
      };
      expect(
        snap(now: atHour(day, 16), history: history).prayerStreak,
        3,
      );
      final qadaDay = {
        key(DateTime(2026, 8, 9)): allFive(PrayerMarkStatus.qada),
        key(day): allFive(PrayerMarkStatus.qada),
      };
      final s = snap(now: atHour(day, 21), history: qadaDay);
      expect(s.prayerStreak, 10);
      expect(s.dayStreak, 2);
    });

    test('yesterday 5 + today 4 → prayer count 9, day streak 1', () {
      final day = DateTime(2026, 8, 10);
      final history = {
        key(DateTime(2026, 8, 9)): allFive(),
        key(day): onTime([
          TrackablePrayer.fajr,
          TrackablePrayer.dhuhr,
          TrackablePrayer.asr,
          TrackablePrayer.maghrib,
        ]),
      };
      final s = snap(now: atHour(day, 21), history: history);
      expect(s.prayerStreak, 9);
      expect(s.dayStreak, 1);
    });

    test('yesterday 5 + today 3 → prayer count 8, day streak 1', () {
      final day = DateTime(2026, 8, 10);
      final history = {
        key(DateTime(2026, 8, 9)): allFive(),
        key(day): onTime([
          TrackablePrayer.fajr,
          TrackablePrayer.dhuhr,
          TrackablePrayer.asr,
        ]),
      };
      final s = snap(now: atHour(day, 16), history: history);
      expect(s.prayerStreak, 8);
      expect(s.dayStreak, 1);
    });

    test('two full days → 10 prayers and day streak 2', () {
      final day = DateTime(2026, 8, 10);
      final history = {
        key(DateTime(2026, 8, 9)): allFive(),
        key(day): allFive(),
      };
      final s = snap(now: atHour(day, 21), history: history);
      expect(s.prayerStreak, 10);
      expect(s.dayStreak, 2);
    });

    test('past incomplete day stops historical aggregation', () {
      final day = DateTime(2026, 8, 12);
      final history = {
        key(DateTime(2026, 8, 9)): allFive(),
        key(DateTime(2026, 8, 10)): onTime([
          TrackablePrayer.fajr,
          TrackablePrayer.dhuhr,
        ]),
        key(DateTime(2026, 8, 11)): allFive(),
        key(day): onTime([TrackablePrayer.fajr]),
      };
      // Today 1 + Aug 11 (5) = 6; Aug 10 incomplete stops before Aug 9.
      expect(
        snap(now: atHour(day, 10), history: history).prayerStreak,
        6,
      );
    });

    test('incomplete past day with Missed does not glue older full days', () {
      final day = DateTime(2026, 8, 10);
      final history = {
        key(DateTime(2026, 8, 9)): {
          ...onTime([
            TrackablePrayer.fajr,
            TrackablePrayer.dhuhr,
            TrackablePrayer.asr,
            TrackablePrayer.maghrib,
          ]),
          TrackablePrayer.isha: PrayerMarkStatus.missed,
        },
        key(day): onTime([TrackablePrayer.fajr]),
      };
      // Today 1; yesterday 4 < 5 → stop. Do not reach older history.
      expect(snap(now: atHour(day, 10), history: history).prayerStreak, 1);
    });

    test('Isha Missed with four earlier completed keeps count 4 (+ prior days)',
        () {
      final day = DateTime(2026, 8, 10);
      final history = {
        key(DateTime(2026, 8, 9)): allFive(),
        key(day): {
          ...onTime([
            TrackablePrayer.fajr,
            TrackablePrayer.dhuhr,
            TrackablePrayer.asr,
            TrackablePrayer.maghrib,
          ]),
          TrackablePrayer.isha: PrayerMarkStatus.missed,
        },
      };
      final s = snap(now: atHour(day, 21), history: history);
      expect(s.prayerStreak, 9); // 4 today + 5 yesterday
      expect(s.dayStreak, 1);
    });

    test('Fajr Missed with later completed still counts those prayers', () {
      final day = DateTime(2026, 8, 10);
      final history = {
        key(DateTime(2026, 8, 9)): allFive(),
        key(day): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
          TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
          TrackablePrayer.asr: PrayerMarkStatus.qada,
        },
      };
      // Today 2 + yesterday 5 = 7 (not trailing-segment 2).
      expect(snap(now: atHour(day, 16), history: history).prayerStreak, 7);
    });

    test('uncheck reduces daily count without tip-walk collapse', () {
      final day = DateTime(2026, 8, 10);
      final history = {
        key(DateTime(2026, 8, 9)): allFive(),
        key(day): onTime([
          TrackablePrayer.fajr,
          TrackablePrayer.dhuhr,
          TrackablePrayer.asr,
        ]),
      };
      expect(snap(now: atHour(day, 16), history: history).prayerStreak, 8);

      history[key(day)] = onTime([
        TrackablePrayer.fajr,
        TrackablePrayer.dhuhr,
      ]);
      expect(snap(now: atHour(day, 16), history: history).prayerStreak, 7);

      history[key(day)] = {
        TrackablePrayer.fajr: PrayerMarkStatus.onTime,
        TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
        TrackablePrayer.asr: PrayerMarkStatus.missed,
      };
      expect(snap(now: atHour(day, 16), history: history).prayerStreak, 7);
    });

    test(
      'uncheck Fajr with later prayers marked + full yesterday → 9 becomes 8',
      () {
        final day = DateTime(2026, 8, 10);
        final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
          key(DateTime(2026, 8, 9)): allFive(),
          key(day): onTime([
            TrackablePrayer.fajr,
            TrackablePrayer.dhuhr,
            TrackablePrayer.asr,
            TrackablePrayer.maghrib,
          ]),
        };
        expect(
          snap(now: atHour(day, 19, 30), history: history).prayerStreak,
          9,
        );

        history[key(day)] = onTime([
          TrackablePrayer.dhuhr,
          TrackablePrayer.asr,
          TrackablePrayer.maghrib,
        ]);
        expect(
          snap(now: atHour(day, 19, 30), history: history).prayerStreak,
          8,
        );
      },
    );

    test(
      'checklist Fajr uncheck matches Home Fajr uncheck prayer count',
      () {
        final day = DateTime(2026, 8, 10);
        final now = atHour(day, 19, 30);
        final base = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
          key(DateTime(2026, 8, 9)): allFive(),
          key(day): onTime([
            TrackablePrayer.fajr,
            TrackablePrayer.dhuhr,
            TrackablePrayer.asr,
            TrackablePrayer.maghrib,
          ]),
        };

        final homeHistory = {
          for (final e in base.entries)
            e.key: Map<TrackablePrayer, PrayerMarkStatus>.from(e.value),
        };
        homeHistory[key(day)]!.remove(TrackablePrayer.fajr);

        final checklistHistory = {
          for (final e in base.entries)
            e.key: Map<TrackablePrayer, PrayerMarkStatus>.from(e.value),
        };
        checklistHistory[key(day)]![TrackablePrayer.fajr] =
            PrayerMarkStatus.none;
        checklistHistory[key(day)]!.removeWhere(
          (_, s) => s == PrayerMarkStatus.none,
        );

        expect(
          snap(now: now, history: homeHistory).prayerStreak,
          snap(now: now, history: checklistHistory).prayerStreak,
        );
        expect(snap(now: now, history: homeHistory).prayerStreak, 8);
      },
    );

    test('empty today still keeps prior full days in prayer count', () {
      final yesterday = DateTime(2026, 8, 10);
      final today = DateTime(2026, 8, 11);
      final history = {
        key(DateTime(2026, 8, 9)): allFive(),
        key(yesterday): allFive(),
      };
      expect(
        snap(now: atHour(today, 4), history: history).prayerStreak,
        10,
      );
      expect(
        snap(now: atHour(today, 5, 30), history: history).prayerStreak,
        10,
      );
    });

    test(
      'complete today then uncheck one prayer preserves previous Day Streak',
      () {
        final day = DateTime(2026, 8, 10);
        final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
          key(DateTime(2026, 8, 8)): allFive(),
          key(DateTime(2026, 8, 9)): allFive(),
          key(day): allFive(),
        };
        final complete = snap(now: atHour(day, 21), history: history);
        expect(complete.dayStreak, 3);
        expect(complete.prayerStreak, 15);

        history[key(day)] = onTime([
          TrackablePrayer.fajr,
          TrackablePrayer.dhuhr,
          TrackablePrayer.asr,
          TrackablePrayer.maghrib,
        ]);
        final afterUncheck = snap(now: atHour(day, 21), history: history);
        expect(afterUncheck.dayStreak, 2);
        expect(afterUncheck.prayerStreak, 14);
      },
    );

    test('multiple consecutive full days', () {
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{};
      for (var d = 1; d <= 5; d++) {
        history[key(DateTime(2026, 8, d))] = allFive();
      }
      final s = snap(now: atHour(DateTime(2026, 8, 5), 21), history: history);
      expect(s.prayerStreak, 25);
      expect(s.dayStreak, 5);
    });

    test('Day Streak stays separate and ignores incomplete today', () {
      final history = {
        key(DateTime(2026, 8, 8)): allFive(),
        key(DateTime(2026, 8, 9)): allFive(),
        key(DateTime(2026, 8, 10)): onTime([TrackablePrayer.fajr]),
      };
      final s = snap(
        now: atHour(DateTime(2026, 8, 10), 10),
        history: history,
      );
      expect(s.prayerStreak, 11); // 10 prior + Fajr
      expect(s.dayStreak, 2); // Aug 8–9; today skipped
    });

    test('AchievementCalculator reads the same prayer count', () {
      final day = DateTime(2026, 8, 10);
      final history = {
        key(DateTime(2026, 8, 9)): allFive(),
        key(day): onTime([
          TrackablePrayer.fajr,
          TrackablePrayer.dhuhr,
          TrackablePrayer.asr,
          TrackablePrayer.maghrib,
        ]),
      };
      final s = snap(now: atHour(day, 21), history: history);
      final achievements = AchievementCalculator.calculate(
        now: atHour(day, 21),
        statusHistory: history,
        isPausedStreakDay: neverPause,
      );
      expect(s.prayerStreak, 9);
      expect(achievements.prayerStreak, s.prayerStreak);
      expect(achievements.dayStreak, s.dayStreak);
    });
  });

  group('Restore', () {
    test('restores newest break within 24h and recalculates', () {
      final now = atHour(DateTime(2026, 8, 11), 4);
      final yesterday = DateTime(2026, 8, 10);
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(DateTime(2026, 8, 9)): allFive(),
        key(yesterday): {
          ...onTime([
            TrackablePrayer.fajr,
            TrackablePrayer.dhuhr,
            TrackablePrayer.asr,
            TrackablePrayer.maghrib,
          ]),
          TrackablePrayer.isha: PrayerMarkStatus.missed,
        },
      };
      expect(snap(now: now, history: history).prayerStreak, 0);
      // Today empty; yesterday 4/5 incomplete → run stops at 0.

      final target = RestoreCalculator.findTarget(
        now: now,
        statusHistory: history,
        isCycleDay: neverPause,
      );
      expect(target!.prayer, TrackablePrayer.isha);

      final restored = RestoreCalculator.apply(
        statusHistory: history,
        target: target,
      );
      final s = snap(now: now, history: restored);
      expect(s.prayerStreak, 10);
      expect(s.dayStreak, 2);
    });
  });

  group('Cycle Mode — Prayer + Day Streak', () {
    Map<String, Map<TrackablePrayer, PrayerMarkStatus>> historyAroundCycle() {
      // Aug 8 full, Aug 9–11 cycle window candidates, Aug 12 full.
      return {
        key(DateTime(2026, 8, 8)): allFive(),
        key(DateTime(2026, 8, 9)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        key(DateTime(2026, 8, 10)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        key(DateTime(2026, 8, 11)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        key(DateTime(2026, 8, 12)): allFive(),
      };
    }

    test('paused today keeps tip from counting marks (no older tip)', () {
      final today = DateTime(2026, 8, 11);
      final history = {
        key(today): {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
        },
      };
      final data = CycleModeData(
        isEnabled: true,
        startDate: today,
        cycleLength: 4,
        pauseStreaks: true,
      );
      final s = snap(
        now: atHour(today, 13),
        history: history,
        isPaused: CycleModePolicy(data).shouldPauseStreaks,
      );
      expect(s.prayerStreak, 2);
      expect(s.dayStreak, 0);

      final off = data.disableOn(today);
      expect(off.history, isEmpty);
      expect(CycleModePolicy(off).shouldPauseStreaks(today), isFalse);
      final after = snap(
        now: atHour(today, 13),
        history: history,
        isPaused: CycleModePolicy(off).shouldPauseStreaks,
      );
      expect(after.prayerStreak, 2);
    });

    test(
      'same-day Cycle ON preserves prayer 5 + day 1 when today is fully complete',
      () {
        final today = DateTime(2026, 8, 11);
        final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
          key(today): allFive(),
        };
        final before = snap(
          now: atHour(today, 21),
          history: history,
        );
        expect(before.prayerStreak, 5);
        expect(before.dayStreak, 1);

        final data = CycleModeData(
          isEnabled: true,
          startDate: today,
          cycleLength: 4,
          pauseStreaks: true,
        );
        final during = snap(
          now: atHour(today, 21),
          history: history,
          isPaused: CycleModePolicy(data).shouldPauseStreaks,
        );
        expect(during.prayerStreak, 5);
        expect(during.dayStreak, 1);

        final off = data.disableOn(today);
        final after = snap(
          now: atHour(today, 21),
          history: history,
          isPaused: CycleModePolicy(off).shouldPauseStreaks,
        );
        expect(after.prayerStreak, 5);
        expect(after.dayStreak, 1);
      },
    );

    test(
      'same-day Cycle ON preserves multi-day streak when today completes the chain',
      () {
        final today = DateTime(2026, 8, 11);
        final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
          key(DateTime(2026, 8, 9)): allFive(),
          key(DateTime(2026, 8, 10)): allFive(),
          key(today): allFive(),
        };
        final data = CycleModeData(
          isEnabled: true,
          startDate: today,
          cycleLength: 4,
          pauseStreaks: true,
        );
        final during = snap(
          now: atHour(today, 21),
          history: history,
          isPaused: CycleModePolicy(data).shouldPauseStreaks,
        );
        expect(during.prayerStreak, 15);
        expect(during.dayStreak, 3);
      },
    );

    test(
      'next-day Cycle ON preserves day streak from prior complete days',
      () {
        final today = DateTime(2026, 8, 12);
        final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
          key(DateTime(2026, 8, 11)): allFive(),
        };
        final data = CycleModeData(
          isEnabled: true,
          startDate: today,
          cycleLength: 4,
          pauseStreaks: true,
        );
        final during = snap(
          now: atHour(today, 10),
          history: history,
          isPaused: CycleModePolicy(data).shouldPauseStreaks,
        );
        expect(during.dayStreak, 1);
      },
    );

    test('ON + pauseStreaks=true skips cycle days and bridges streak', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 9),
        cycleLength: 3,
        pauseStreaks: true,
      );
      final policy = CycleModePolicy(data);
      final s = snap(
        now: atHour(DateTime(2026, 8, 12), 21),
        history: historyAroundCycle(),
        isPaused: policy.shouldPauseStreaks,
      );
      // Aug 12 (5) + Aug 8 (5); Aug 9–11 skipped.
      expect(s.prayerStreak, 10);
      expect(s.dayStreak, 2);
    });

    test('ON + prayers marked on paused day do not add or break streak', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 10),
        cycleLength: 1,
        pauseStreaks: true,
      );
      final policy = CycleModePolicy(data);
      final history = {
        key(DateTime(2026, 8, 9)): allFive(),
        key(DateTime(2026, 8, 10)): allFive(), // marked during pause
        key(DateTime(2026, 8, 11)): allFive(),
      };
      final s = snap(
        now: atHour(DateTime(2026, 8, 11), 21),
        history: history,
        isPaused: policy.shouldPauseStreaks,
      );
      expect(s.prayerStreak, 10); // Aug 11 + Aug 9 only
      expect(s.dayStreak, 2);
    });

    test('manual OFF returns to normal; sealed history still paused', () {
      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 9),
        cycleLength: 3,
        pauseStreaks: true,
      );
      // Disable on Aug 12 → seals Aug 9–11; Aug 12 is a normal day.
      data = data.disableOn(DateTime(2026, 8, 12));
      expect(data.isEnabled, isFalse);
      final policy = CycleModePolicy(data);

      expect(policy.shouldPauseStreaks(DateTime(2026, 8, 10)), isTrue);
      expect(policy.shouldPauseStreaks(DateTime(2026, 8, 12)), isFalse);

      final history = historyAroundCycle();
      final s = snap(
        now: atHour(DateTime(2026, 8, 12), 21),
        history: history,
        isPaused: policy.shouldPauseStreaks,
      );
      expect(s.prayerStreak, 10);
      expect(s.dayStreak, 2);

      // Completing prayers after OFF still skips sealed paused history.
      history[key(DateTime(2026, 8, 12))] = allFive();
      final after = snap(
        now: atHour(DateTime(2026, 8, 12), 21),
        history: history,
        isPaused: policy.shouldPauseStreaks,
      );
      expect(after.prayerStreak, 10);
    });

    test('automatic expire seals full window; streak bridges history', () {
      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 9),
        cycleLength: 3,
        pauseStreaks: true,
      );
      expect(data.hasExpiredOn(DateTime(2026, 8, 12)), isTrue);
      data = data.expireFully();
      expect(data.isEnabled, isFalse);
      expect(data.history.single.startDate, DateTime(2026, 8, 9));
      expect(data.history.single.endDate, DateTime(2026, 8, 11));

      final policy = CycleModePolicy(data);
      final s = snap(
        now: atHour(DateTime(2026, 8, 12), 21),
        history: historyAroundCycle(),
        isPaused: policy.shouldPauseStreaks,
      );
      expect(s.prayerStreak, 10);
      expect(s.dayStreak, 2);
    });

    test('cycle starts mid-streak and stops mid-streak without duplicating', () {
      // Aug 7–8 full (streak 10). Enable cycle Aug 9–10. Aug 11 full.
      final history = {
        key(DateTime(2026, 8, 7)): allFive(),
        key(DateTime(2026, 8, 8)): allFive(),
        key(DateTime(2026, 8, 9)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        key(DateTime(2026, 8, 10)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        key(DateTime(2026, 8, 11)): allFive(),
      };

      final active = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 9),
        cycleLength: 2,
        pauseStreaks: true,
      );
      final during = snap(
        now: atHour(DateTime(2026, 8, 10), 21),
        history: history,
        isPaused: CycleModePolicy(active).shouldPauseStreaks,
      );
      // Today (Aug 10) paused → tip from Aug 8 chain = 10.
      expect(during.prayerStreak, 10);
      expect(during.dayStreak, 2);

      final expired = active.expireFully();
      final after = snap(
        now: atHour(DateTime(2026, 8, 11), 21),
        history: history,
        isPaused: CycleModePolicy(expired).shouldPauseStreaks,
      );
      expect(after.prayerStreak, 15); // Aug 11 + Aug 8 + Aug 7
      expect(after.dayStreak, 3);
    });

    test('multi-day active cycle across restart (JSON round-trip)', () {
      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 9),
        cycleLength: 3,
        pauseStreaks: true,
      );
      data = CycleModeData.fromJson(data.toJsonMap());
      final policy = CycleModePolicy(data);
      final s = snap(
        now: atHour(DateTime(2026, 8, 12), 21),
        history: historyAroundCycle(),
        isPaused: policy.shouldPauseStreaks,
      );
      expect(s.prayerStreak, 10);
      expect(s.dayStreak, 2);
    });

    test('restart after automatic expire preserves historical pause', () {
      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 9),
        cycleLength: 3,
        pauseStreaks: true,
      ).expireFully();
      data = CycleModeData.fromJson(data.toJsonMap());
      expect(data.isEnabled, isFalse);

      final policy = CycleModePolicy(data);
      final s = snap(
        now: atHour(DateTime(2026, 8, 12), 21),
        history: historyAroundCycle(),
        isPaused: policy.shouldPauseStreaks,
      );
      expect(s.prayerStreak, 10);
      expect(policy.shouldPauseStreaks(DateTime(2026, 8, 10)), isTrue);
      expect(policy.shouldPauseStreaks(DateTime(2026, 8, 12)), isFalse);
    });

    test('manual disable then complete prayers — no reset/duplicate', () {
      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 9),
        cycleLength: 3,
        pauseStreaks: true,
      );
      final during = snap(
        now: atHour(DateTime(2026, 8, 11), 12),
        history: historyAroundCycle(),
        isPaused: CycleModePolicy(data).shouldPauseStreaks,
      );
      expect(during.prayerStreak, 5); // Aug 8 only (today paused)

      data = data.disableOn(DateTime(2026, 8, 12));
      final history = historyAroundCycle();
      history[key(DateTime(2026, 8, 12))] = allFive();

      final after = snap(
        now: atHour(DateTime(2026, 8, 12), 21),
        history: history,
        isPaused: CycleModePolicy(data).shouldPauseStreaks,
      );
      expect(after.prayerStreak, 10);
      expect(after.dayStreak, 2);
      // Turning OFF must not invent extra streak from paused marks.
      expect(after.prayerStreak, isNot(15));
    });

    test('pauseStreaks=false does not bridge — miss on cycle day breaks', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 10),
        cycleLength: 1,
        pauseStreaks: false,
      );
      final history = {
        key(DateTime(2026, 8, 9)): allFive(),
        key(DateTime(2026, 8, 10)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        key(DateTime(2026, 8, 11)): allFive(),
      };
      final s = snap(
        now: atHour(DateTime(2026, 8, 11), 21),
        history: history,
        isPaused: CycleModePolicy(data).shouldPauseStreaks,
      );
      expect(s.prayerStreak, 5); // only Aug 11; broken at Aug 10
    });

    test('Cycle-paused day bridges and contributes 0', () {
      final history = {
        key(DateTime(2026, 8, 8)): allFive(),
        key(DateTime(2026, 8, 9)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        key(DateTime(2026, 8, 10)): allFive(),
      };
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 9),
        cycleLength: 1,
        pauseStreaks: true,
      );
      final s = snap(
        now: atHour(DateTime(2026, 8, 10), 21),
        history: history,
        isPaused: CycleModePolicy(data).shouldPauseStreaks,
      );
      expect(s.prayerStreak, 10); // Aug 10 + bridge Aug 9 + Aug 8
      expect(s.dayStreak, 2);
    });

    test(
      'after pause ends, started-unmarked soft-bridges; missed still breaks',
      () {
        final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
          key(DateTime(2026, 8, 10)): {
            TrackablePrayer.maghrib: PrayerMarkStatus.onTime,
            TrackablePrayer.isha: PrayerMarkStatus.onTime,
          },
        };
        final ended = CycleModeData(
          isEnabled: true,
          startDate: DateTime(2026, 8, 11),
          cycleLength: 2,
          pauseStreaks: true,
        ).expireFully();
        final policy = CycleModePolicy(ended);

        // Aug 13 is first day after sealed Aug 11–12.
        // Past incomplete day (Aug 10 has 2) is not added; paused days bridge.
        expect(
          snap(
            now: atHour(DateTime(2026, 8, 13), 6),
            history: history,
            isPaused: policy.shouldPauseStreaks,
          ).prayerStreak,
          0,
        );

        history[key(DateTime(2026, 8, 13))] = {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        };
        expect(
          snap(
            now: atHour(DateTime(2026, 8, 13), 10),
            history: history,
            isPaused: policy.shouldPauseStreaks,
          ).prayerStreak,
          0,
        );
      },
    );
  });
}
