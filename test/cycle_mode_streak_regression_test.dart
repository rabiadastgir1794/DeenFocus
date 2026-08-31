import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/cycle_mode_policy.dart';
import 'package:deenly/features/home/services/prayer_analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Final regression: Cycle Mode lifecycle must never create, remove, duplicate,
/// or reset prayer/day streaks incorrectly. Streaks are always recomputed from
/// stored prayer history + pause intervals (never incremental counters).
void main() {
  Map<TrackablePrayer, PrayerMarkStatus> allFive([
    PrayerMarkStatus status = PrayerMarkStatus.onTime,
  ]) =>
      {for (final p in TrackablePrayer.values) p: status};

  Map<TrackablePrayer, PrayerMarkStatus> mixedDay() => {
        TrackablePrayer.fajr: PrayerMarkStatus.onTime,
        TrackablePrayer.dhuhr: PrayerMarkStatus.qada,
        TrackablePrayer.asr: PrayerMarkStatus.onTime,
        TrackablePrayer.maghrib: PrayerMarkStatus.qada,
        TrackablePrayer.isha: PrayerMarkStatus.onTime,
      };

  String key(DateTime d) => PrayerAnalyticsService.dayKey(d);

  DateTime eve(DateTime day) =>
      DateTime(day.year, day.month, day.day, 21);

  CycleModeData coldStart(CycleModeData data) =>
      CycleModeData.fromJson(data.toJsonMap());

  PrayerAnalyticsSnapshot calc({
    required DateTime now,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> history,
    required CycleModeData data,
  }) {
    final policy = CycleModePolicy(data);
    return PrayerAnalyticsService.calculate(
      now: now,
      statusHistory: history,
      isPausedStreakDay: (d) => policy.shouldPauseStreaks(d, now: now),
      isExcludedStatsDay: (d) => policy.shouldExcludeFromStatistics(d, now: now),
    );
  }

  /// Proves recalculation is pure: same inputs → same streak (no +1 leakage).
  void expectStableRecalc({
    required DateTime now,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> history,
    required CycleModeData data,
    required int prayerStreak,
    required int dayStreak,
  }) {
    final a = calc(now: now, history: history, data: data);
    final b = calc(now: now, history: history, data: data);
    expect(a.prayerStreak, prayerStreak);
    expect(a.dayStreak, dayStreak);
    expect(b.prayerStreak, a.prayerStreak);
    expect(b.dayStreak, a.dayStreak);
  }

  group('Cycle Mode streak lifecycle regression', () {
    test(
      'streak tip on today preserved: ON → 4 paused days → OFF (bug regression)',
      () {
        final today = DateTime(2026, 8, 11);
        final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
          key(today): {
            TrackablePrayer.fajr: PrayerMarkStatus.onTime,
            TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
          },
        };

        // Before Cycle Mode: Fajr + Dhuhr → prayer streak 2.
        expectStableRecalc(
          now: DateTime(2026, 8, 11, 13),
          history: history,
          data: CycleModeData.disabled(),
          prayerStreak: 2,
          dayStreak: 0,
        );

        // Cycle ON for 4 days starting today — streak must stay 2 (pink UI).
        var data = CycleModeData(
          isEnabled: true,
          startDate: today,
          cycleLength: 4,
          pauseStreaks: true,
        );
        expectStableRecalc(
          now: DateTime(2026, 8, 11, 13),
          history: history,
          data: data,
          prayerStreak: 2,
          dayStreak: 0,
        );

        // Across remaining paused days with no new marks — still 2.
        for (final day in [
          DateTime(2026, 8, 12),
          DateTime(2026, 8, 13),
          DateTime(2026, 8, 14),
        ]) {
          expectStableRecalc(
            now: eve(day),
            history: history,
            data: data,
            prayerStreak: 2,
            dayStreak: 0,
          );
        }

        // Manual OFF after the window — sealed pause history; tip preserved.
        data = data.disableOn(DateTime(2026, 8, 15));
        expect(data.isEnabled, isFalse);
        expect(data.history, hasLength(1));
        expect(data.history.single.startDate, today);
        expect(data.history.single.endDate, DateTime(2026, 8, 14));
        expect(
          CycleModePolicy(data).shouldPauseStreaks(today),
          isTrue,
        );
        expect(
          CycleModePolicy(data).shouldPauseStreaks(DateTime(2026, 8, 15)),
          isFalse,
        );

        // Early morning before Fajr tip rules: preserved tip still 2.
        expectStableRecalc(
          now: DateTime(2026, 8, 15, 4),
          history: history,
          data: data,
          prayerStreak: 2,
          dayStreak: 0,
        );
      },
    );

    test('same-day enable then disable seals nothing; tip + week bars kept', () {
      final today = DateTime(2026, 8, 11);
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(today): {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.dhuhr: PrayerMarkStatus.qada,
        },
      };

      var data = CycleModeData(
        isEnabled: true,
        startDate: today,
        cycleLength: 4,
        pauseStreaks: true,
        excludeFromStatistics: true,
      );
      expectStableRecalc(
        now: DateTime(2026, 8, 11, 13),
        history: history,
        data: data,
        prayerStreak: 2,
        dayStreak: 0,
      );

      data = data.disableOn(today);
      expect(data.isEnabled, isFalse);
      expect(data.history, isEmpty);
      expect(CycleModePolicy(data).shouldPauseStreaks(today), isFalse);
      expect(CycleModePolicy(data).shouldExcludeFromStatistics(today), isFalse);

      final after = calc(
        now: DateTime(2026, 8, 11, 13),
        history: history,
        data: data,
      );
      expect(after.prayerStreak, 2);
      // Tuesday home bar must still show 2 completed prayers (not forced to 0).
      final tueIndex = WeeklyCalculator.mondayWeekDates(
        DateTime(2026, 8, 11, 13),
      ).indexWhere(
        (d) => PrayerAnalyticsService.dayKey(d) == key(today),
      );
      expect(tueIndex, greaterThanOrEqualTo(0));
      expect(after.homeWeekDayCounts[tueIndex], 2);
    });

    test(
      'fresh install: mark Fajr+Dhuhr → Cycle ON → OFF keeps streak + graph',
      () {
        final today = DateTime(2026, 8, 11);
        // Before Asr (default 15:00) so tip remains Dhuhr — matches device
        // times where Asr is still upcoming (e.g. 3:16 with Asr at 3:47).
        final now = DateTime(2026, 8, 11, 14, 30);
        final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
          key(today): {
            TrackablePrayer.fajr: PrayerMarkStatus.onTime,
            TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
          },
        };

        expectStableRecalc(
          now: now,
          history: history,
          data: CycleModeData.disabled(),
          prayerStreak: 2,
          dayStreak: 0,
        );

        var data = CycleModeData(
          isEnabled: true,
          startDate: today,
          cycleLength: 6,
          pauseStreaks: true,
          excludeFromStatistics: true,
        );
        expectStableRecalc(
          now: now,
          history: history,
          data: data,
          prayerStreak: 2,
          dayStreak: 0,
        );

        data = data.disableOn(now);
        expect(data.history, isEmpty);

        final after = calc(now: now, history: history, data: data);
        expect(after.prayerStreak, 2);
        expect(history[key(today)]![TrackablePrayer.fajr], PrayerMarkStatus.onTime);
        expect(history[key(today)]![TrackablePrayer.dhuhr], PrayerMarkStatus.onTime);
        final tueIndex = WeeklyCalculator.mondayWeekDates(now).indexWhere(
          (d) => PrayerAnalyticsService.dayKey(d) == key(today),
        );
        expect(after.homeWeekDayCounts[tueIndex], 2);
        expect(after.canRestoreStreak, isFalse);
      },
    );

    test('auto-expiry preserves tip that lived on paused days', () {
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(DateTime(2026, 8, 11)): {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
        },
      };
      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 11),
        cycleLength: 4,
        pauseStreaks: true,
      );
      expect(data.hasExpiredOn(DateTime(2026, 8, 15)), isTrue);
      data = data.expireFully();
      expectStableRecalc(
        now: DateTime(2026, 8, 15, 4),
        history: history,
        data: coldStart(data),
        prayerStreak: 2,
        dayStreak: 0,
      );
    });

    group('after Cycle Mode ends — preserve streak; miss breaks; On Time continues',
        () {
      Map<String, Map<TrackablePrayer, PrayerMarkStatus>> tipOnPausedDay() => {
            key(DateTime(2026, 8, 11)): {
              TrackablePrayer.fajr: PrayerMarkStatus.onTime,
              TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
            },
          };

      CycleModeData fourDayCycleEnded({required bool manualOff}) {
        final active = CycleModeData(
          isEnabled: true,
          startDate: DateTime(2026, 8, 11),
          cycleLength: 4,
          pauseStreaks: true,
        );
        // No marks during Aug 12–14.
        if (manualOff) {
          return active.disableOn(DateTime(2026, 8, 15));
        }
        expect(active.hasExpiredOn(DateTime(2026, 8, 15)), isTrue);
        return active.expireFully();
      }

      void expectPreservedThroughUnmarkedThenNormalRules({
        required CycleModeData ended,
        required bool coldRestart,
      }) {
        final history = tipOnPausedDay();
        final data = coldRestart ? coldStart(ended) : ended;

        // Before any post-cycle tip — preserved.
        expectStableRecalc(
          now: DateTime(2026, 8, 15, 4),
          history: history,
          data: data,
          prayerStreak: 2,
          dayStreak: 0,
        );

        // Started-but-unmarked after Cycle Mode must NOT wipe the streak
        // (Cycle days are exempt — unmarked ≠ missed).
        expectStableRecalc(
          now: DateTime(2026, 8, 15, 6),
          history: history,
          data: data,
          prayerStreak: 2,
          dayStreak: 0,
        );
        expectStableRecalc(
          now: DateTime(2026, 8, 15, 13),
          history: history,
          data: data,
          prayerStreak: 2,
          dayStreak: 0,
        );

        // Explicit Missed after end → breaks.
        history[key(DateTime(2026, 8, 15))] = {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        };
        expectStableRecalc(
          now: DateTime(2026, 8, 15, 13),
          history: history,
          data: data,
          prayerStreak: 0,
          dayStreak: 0,
        );

        // On Time / Qadha after end continues the preserved tip (2 + new).
        history[key(DateTime(2026, 8, 15))] = {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.dhuhr: PrayerMarkStatus.qada,
        };
        expectStableRecalc(
          now: DateTime(2026, 8, 15, 13),
          history: history,
          data: data,
          prayerStreak: 4, // Aug 15 Fajr+Dhuhr + Aug 11 Fajr+Dhuhr
          dayStreak: 0,
        );
      }

      test('manual OFF → preserve through unmarked; miss breaks; On Time continues',
          () {
        expectPreservedThroughUnmarkedThenNormalRules(
          ended: fourDayCycleEnded(manualOff: true),
          coldRestart: false,
        );
      });

      test(
          'auto-expiry → preserve through unmarked; miss breaks; On Time continues',
          () {
        expectPreservedThroughUnmarkedThenNormalRules(
          ended: fourDayCycleEnded(manualOff: false),
          coldRestart: false,
        );
      });

      test('app restart while Cycle Mode active keeps tip; unmarked after end preserves',
          () {
        final history = tipOnPausedDay();
        var data = CycleModeData(
          isEnabled: true,
          startDate: DateTime(2026, 8, 11),
          cycleLength: 4,
          pauseStreaks: true,
        );

        expectStableRecalc(
          now: eve(DateTime(2026, 8, 13)),
          history: history,
          data: data,
          prayerStreak: 2,
          dayStreak: 0,
        );

        data = coldStart(data);
        expect(data.isEnabled, isTrue);
        expectStableRecalc(
          now: eve(DateTime(2026, 8, 13)),
          history: history,
          data: data,
          prayerStreak: 2,
          dayStreak: 0,
        );

        data = data.disableOn(DateTime(2026, 8, 15));
        data = coldStart(data);
        expectStableRecalc(
          now: DateTime(2026, 8, 15, 4),
          history: history,
          data: data,
          prayerStreak: 2,
          dayStreak: 0,
        );
        expectStableRecalc(
          now: DateTime(2026, 8, 15, 6),
          history: history,
          data: data,
          prayerStreak: 2,
          dayStreak: 0,
        );
      });

      test('app restart after expiry keeps tip through unmarked; miss breaks', () {
        expectPreservedThroughUnmarkedThenNormalRules(
          ended: fourDayCycleEnded(manualOff: false),
          coldRestart: true,
        );
      });

      test(
        'reported bug: streak 2 → 2-day Cycle → auto-expiry → stays 2 after Fajr',
        () {
          // Realistic tip of 2: Maghrib+Isha before Cycle Mode (trailing slots).
          final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
            key(DateTime(2026, 8, 13)): {
              TrackablePrayer.maghrib: PrayerMarkStatus.onTime,
              TrackablePrayer.isha: PrayerMarkStatus.onTime,
            },
          };
          var data = CycleModeData(
            isEnabled: true,
            startDate: DateTime(2026, 8, 14),
            cycleLength: 2,
            pauseStreaks: true,
            excludeFromStatistics: true,
          );

          expectStableRecalc(
            now: eve(DateTime(2026, 8, 13)),
            history: history,
            data: CycleModeData.disabled(),
            prayerStreak: 2,
            dayStreak: 0,
          );
          expectStableRecalc(
            now: eve(DateTime(2026, 8, 14)),
            history: history,
            data: data,
            prayerStreak: 2,
            dayStreak: 0,
          );
          expectStableRecalc(
            now: eve(DateTime(2026, 8, 15)),
            history: history,
            data: data,
            prayerStreak: 2,
            dayStreak: 0,
          );

          expect(data.hasExpiredOn(DateTime(2026, 8, 16)), isTrue);
          data = data.expireFully();
          data = coldStart(data);

          // Insights: sealed cycle days excluded from weekly possible.
          final after = calc(
            now: DateTime(2026, 8, 16, 6),
            history: history,
            data: data,
          );
          expect(after.prayerStreak, 2);
          expect(after.dayStreak, 0);
          expect(
            CycleModePolicy(data).shouldExcludeFromStatistics(
              DateTime(2026, 8, 14),
            ),
            isTrue,
          );
          expect(
            CycleModePolicy(data).shouldExcludeFromStatistics(
              DateTime(2026, 8, 16),
            ),
            isFalse,
          );

          expectStableRecalc(
            now: DateTime(2026, 8, 16, 4),
            history: history,
            data: data,
            prayerStreak: 2,
            dayStreak: 0,
          );
          expectStableRecalc(
            now: DateTime(2026, 8, 16, 6),
            history: history,
            data: data,
            prayerStreak: 2,
            dayStreak: 0,
          );
          expectStableRecalc(
            now: DateTime(2026, 8, 16, 21),
            history: history,
            data: data,
            prayerStreak: 2,
            dayStreak: 0,
          );

          // Next normal day: unmarked Aug 16 is skipped; Maghrib+Isha still count.
          expectStableRecalc(
            now: DateTime(2026, 8, 17, 6),
            history: history,
            data: data,
            prayerStreak: 2,
            dayStreak: 0,
          );
        },
      );

      test('multi-day Cycle Mode with zero marks never invents streak slots', () {
        final history = tipOnPausedDay();
        final data = CycleModeData(
          isEnabled: true,
          startDate: DateTime(2026, 8, 11),
          cycleLength: 4,
          pauseStreaks: true,
        );
        // Empty paused days must not become "valid" prayers.
        for (final day in [
          DateTime(2026, 8, 12),
          DateTime(2026, 8, 13),
          DateTime(2026, 8, 14),
        ]) {
          expect(history.containsKey(key(day)), isFalse);
          expectStableRecalc(
            now: eve(day),
            history: history,
            data: data,
            prayerStreak: 2,
            dayStreak: 0,
          );
        }
        final ended = data.expireFully();
        history[key(DateTime(2026, 8, 15))] = {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        };
        expectStableRecalc(
          now: DateTime(2026, 8, 15, 13),
          history: history,
          data: ended,
          prayerStreak: 0,
          dayStreak: 0,
        );
      });

      test('Cycle Mode mid-streak: pause bridges; after end miss breaks', () {
        final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
          key(DateTime(2026, 8, 7)): mixedDay(),
          key(DateTime(2026, 8, 8)): mixedDay(),
        };
        var data = CycleModeData(
          isEnabled: true,
          startDate: DateTime(2026, 8, 9),
          cycleLength: 3,
          pauseStreaks: true,
        );
        expectStableRecalc(
          now: eve(DateTime(2026, 8, 11)),
          history: history,
          data: data,
          prayerStreak: 10,
          dayStreak: 2,
        );

        data = data.disableOn(DateTime(2026, 8, 12));
        expectStableRecalc(
          now: DateTime(2026, 8, 12, 4),
          history: history,
          data: data,
          prayerStreak: 10,
          dayStreak: 2,
        );

        history[key(DateTime(2026, 8, 12))] = {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        };
        expectStableRecalc(
          now: DateTime(2026, 8, 12, 13),
          history: history,
          data: data,
          prayerStreak: 0, // normal tip rules: miss breaks prayer streak
          dayStreak: 2, // incomplete today does not break prior day streak
        );
      });

      test('Cycle Mode with no existing streak stays 0; unmarked after end stays 0',
          () {
        final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{};
        var data = CycleModeData(
          isEnabled: true,
          startDate: DateTime(2026, 8, 11),
          cycleLength: 4,
          pauseStreaks: true,
        );
        expectStableRecalc(
          now: eve(DateTime(2026, 8, 13)),
          history: history,
          data: data,
          prayerStreak: 0,
          dayStreak: 0,
        );

        data = data.expireFully();
        expectStableRecalc(
          now: DateTime(2026, 8, 15, 6),
          history: history,
          data: coldStart(data),
          prayerStreak: 0,
          dayStreak: 0,
        );
      });

      test(
          'paused-day miss/unmarked never become valid after Cycle Mode ends',
          () {
        final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
          key(DateTime(2026, 8, 11)): {
            TrackablePrayer.fajr: PrayerMarkStatus.onTime,
            TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
            // Explicit miss on paused day — must never count.
            TrackablePrayer.asr: PrayerMarkStatus.missed,
          },
          // Empty / unmarked slots on later paused days — never count.
          key(DateTime(2026, 8, 12)): {
            TrackablePrayer.fajr: PrayerMarkStatus.missed,
          },
          key(DateTime(2026, 8, 13)): {
            TrackablePrayer.dhuhr: PrayerMarkStatus.none,
          },
        };
        final data = CycleModeData(
          isEnabled: true,
          startDate: DateTime(2026, 8, 11),
          cycleLength: 4,
          pauseStreaks: true,
        ).expireFully();

        // Still only the two counting marks from Aug 11.
        expectStableRecalc(
          now: DateTime(2026, 8, 15, 4),
          history: history,
          data: data,
          prayerStreak: 2,
          dayStreak: 0,
        );

        // Post-cycle On Time continues from those 2 only (misses stay ignored).
        history[key(DateTime(2026, 8, 15))] = {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
        };
        expectStableRecalc(
          now: DateTime(2026, 8, 15, 10),
          history: history,
          data: data,
          prayerStreak: 3,
          dayStreak: 0,
        );
      });
    });

    test('Normal → Cycle ON → Cycle OFF (pauseStreaks=true)', () {
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(DateTime(2026, 8, 7)): mixedDay(),
        key(DateTime(2026, 8, 8)): mixedDay(),
      };

      // Normal: two full mixed days.
      expectStableRecalc(
        now: eve(DateTime(2026, 8, 8)),
        history: history,
        data: CycleModeData.disabled(),
        prayerStreak: 10,
        dayStreak: 2,
      );

      // Cycle ON Aug 9–11 (3 days), pause streaks.
      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 9),
        cycleLength: 3,
        pauseStreaks: true,
      );
      history[key(DateTime(2026, 8, 9))] = {
        TrackablePrayer.fajr: PrayerMarkStatus.missed,
      };
      history[key(DateTime(2026, 8, 10))] = allFive(); // marks ignored while paused
      history[key(DateTime(2026, 8, 11))] = {
        TrackablePrayer.isha: PrayerMarkStatus.missed,
      };

      expectStableRecalc(
        now: eve(DateTime(2026, 8, 11)),
        history: history,
        data: data,
        prayerStreak: 10, // Aug 8+7 only; cycle days skipped
        dayStreak: 2,
      );

      // Manual OFF on Aug 12 → seals 9–11; Aug 12 normal.
      data = data.disableOn(DateTime(2026, 8, 12));
      history[key(DateTime(2026, 8, 12))] = mixedDay();

      expectStableRecalc(
        now: eve(DateTime(2026, 8, 12)),
        history: history,
        data: data,
        prayerStreak: 15, // Aug 12 + 8 + 7; sealed paused days still skipped
        dayStreak: 3,
      );
      expect(data.history, hasLength(1));
      expect(data.history.single.endDate, DateTime(2026, 8, 11));
    });

    test('Normal → Cycle ON → auto-expire → normal', () {
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(DateTime(2026, 8, 7)): allFive(),
        key(DateTime(2026, 8, 8)): mixedDay(),
        key(DateTime(2026, 8, 9)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        key(DateTime(2026, 8, 10)): allFive(PrayerMarkStatus.qada),
        key(DateTime(2026, 8, 11)): {
          TrackablePrayer.dhuhr: PrayerMarkStatus.missed,
        },
      };

      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 9),
        cycleLength: 3,
        pauseStreaks: true,
      );

      expectStableRecalc(
        now: eve(DateTime(2026, 8, 11)),
        history: history,
        data: data,
        prayerStreak: 10,
        dayStreak: 2,
      );

      expect(data.hasExpiredOn(DateTime(2026, 8, 12)), isTrue);
      data = data.expireFully();
      expect(data.isEnabled, isFalse);

      history[key(DateTime(2026, 8, 12))] = mixedDay();
      expectStableRecalc(
        now: eve(DateTime(2026, 8, 12)),
        history: history,
        data: data,
        prayerStreak: 15,
        dayStreak: 3,
      );

      // Expire again must not duplicate history or change streak.
      final again = data.expireFully();
      expect(again.history, data.history);
      expectStableRecalc(
        now: eve(DateTime(2026, 8, 12)),
        history: history,
        data: again,
        prayerStreak: 15,
        dayStreak: 3,
      );
    });

    test('Cycle ON across multiple days with mixed On Time + Qadha', () {
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(DateTime(2026, 8, 5)): mixedDay(),
        key(DateTime(2026, 8, 6)): mixedDay(),
        // Cycle Aug 7–10
        key(DateTime(2026, 8, 7)): mixedDay(),
        key(DateTime(2026, 8, 8)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        key(DateTime(2026, 8, 9)): allFive(),
        key(DateTime(2026, 8, 10)): mixedDay(),
        key(DateTime(2026, 8, 11)): mixedDay(),
      };

      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 7),
        cycleLength: 4,
        pauseStreaks: true,
      );

      expectStableRecalc(
        now: eve(DateTime(2026, 8, 11)),
        history: history,
        data: data,
        // Aug 11 + Aug 6 + Aug 5; Aug 7–10 paused regardless of marks.
        prayerStreak: 15,
        dayStreak: 3,
      );
    });

    test('Cycle started/stopped mid-streak without create/remove/duplicate', () {
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(DateTime(2026, 8, 6)): mixedDay(),
        key(DateTime(2026, 8, 7)): mixedDay(),
        key(DateTime(2026, 8, 8)): mixedDay(),
      };

      // Mid-streak enable.
      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 8),
        cycleLength: 2,
        pauseStreaks: true,
      );
        expectStableRecalc(
          now: eve(DateTime(2026, 8, 8)),
          history: history,
          data: data,
          prayerStreak: 15, // Aug 8+7+6 preserved when Cycle starts today
          dayStreak: 3, // Aug 8–7–6 preserved when Cycle starts today
        );

      history[key(DateTime(2026, 8, 9))] = {
        TrackablePrayer.fajr: PrayerMarkStatus.missed,
      };
      expectStableRecalc(
        now: eve(DateTime(2026, 8, 9)),
        history: history,
        data: data,
        prayerStreak: 10,
        dayStreak: 2,
      );

      // Mid-streak stop (manual disable on Aug 10).
      data = data.disableOn(DateTime(2026, 8, 10));
      history[key(DateTime(2026, 8, 10))] = mixedDay();
      expectStableRecalc(
        now: eve(DateTime(2026, 8, 10)),
        history: history,
        data: data,
        prayerStreak: 15, // Aug 10 + 7 + 6; Aug 8–9 sealed paused
        dayStreak: 3,
      );
      expect(data.history, hasLength(1));
    });

    test('App restart while Cycle Mode active', () {
      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 9),
        cycleLength: 3,
        pauseStreaks: true,
      );
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(DateTime(2026, 8, 8)): mixedDay(),
        key(DateTime(2026, 8, 9)): allFive(),
        key(DateTime(2026, 8, 10)): {
          TrackablePrayer.fajr: PrayerMarkStatus.qada,
          TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
          TrackablePrayer.asr: PrayerMarkStatus.qada,
          TrackablePrayer.maghrib: PrayerMarkStatus.onTime,
          TrackablePrayer.isha: PrayerMarkStatus.qada,
        },
      };

      final before = calc(
        now: eve(DateTime(2026, 8, 10)),
        history: history,
        data: data,
      );

      data = coldStart(data);
      final after = calc(
        now: eve(DateTime(2026, 8, 10)),
        history: history,
        data: data,
      );

      expect(after.prayerStreak, before.prayerStreak);
      expect(after.dayStreak, before.dayStreak);
      expect(after.prayerStreak, 5); // only Aug 8
      expect(after.dayStreak, 1);
      expect(data.isEnabled, isTrue);
    });

    test('App restart after auto-expiry', () {
      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 9),
        cycleLength: 3,
        pauseStreaks: true,
      ).expireFully();

      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(DateTime(2026, 8, 8)): mixedDay(),
        key(DateTime(2026, 8, 9)): allFive(),
        key(DateTime(2026, 8, 10)): mixedDay(),
        key(DateTime(2026, 8, 11)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        key(DateTime(2026, 8, 12)): mixedDay(),
      };

      final before = calc(
        now: eve(DateTime(2026, 8, 12)),
        history: history,
        data: data,
      );

      data = coldStart(data);
      final after = calc(
        now: eve(DateTime(2026, 8, 12)),
        history: history,
        data: data,
      );

      expect(data.isEnabled, isFalse);
      expect(after.prayerStreak, before.prayerStreak);
      expect(after.dayStreak, before.dayStreak);
      expect(after.prayerStreak, 10); // Aug 12 + Aug 8
      expect(after.dayStreak, 2);
      expect(CycleModePolicy(data).shouldPauseStreaks(DateTime(2026, 8, 10)), isTrue);
      expect(CycleModePolicy(data).shouldPauseStreaks(DateTime(2026, 8, 12)), isFalse);
    });

    test('pauseStreaks=false — cycle days count and can break streak', () {
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(DateTime(2026, 8, 8)): mixedDay(),
        key(DateTime(2026, 8, 9)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        },
        key(DateTime(2026, 8, 10)): mixedDay(),
      };

      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 9),
        cycleLength: 1,
        pauseStreaks: false,
      );

      expectStableRecalc(
        now: eve(DateTime(2026, 8, 10)),
        history: history,
        data: data,
        prayerStreak: 5, // Aug 10 only; broken at Aug 9 miss
        dayStreak: 1,
      );

      // After OFF, same history still breaks the same way (Aug 9 sealed with pause=false).
      final off = data.disableOn(DateTime(2026, 8, 10));
      // disableOn Aug 10 with start Aug 9 → seals Aug 9 only; Aug 10 normal.
      expectStableRecalc(
        now: eve(DateTime(2026, 8, 10)),
        history: history,
        data: off,
        prayerStreak: 5,
        dayStreak: 1,
      );
    });

    test('Mixed On Time + Qadha before, during, and after Cycle Mode', () {
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        // Before
        key(DateTime(2026, 8, 6)): mixedDay(),
        key(DateTime(2026, 8, 7)): mixedDay(),
        // During (paused)
        key(DateTime(2026, 8, 8)): mixedDay(),
        key(DateTime(2026, 8, 9)): {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.dhuhr: PrayerMarkStatus.qada,
          TrackablePrayer.asr: PrayerMarkStatus.missed,
          TrackablePrayer.maghrib: PrayerMarkStatus.onTime,
          TrackablePrayer.isha: PrayerMarkStatus.qada,
        },
        // After
        key(DateTime(2026, 8, 10)): mixedDay(),
      };

      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 8),
        cycleLength: 2,
        pauseStreaks: true,
      );

      // During last paused day.
      expectStableRecalc(
        now: eve(DateTime(2026, 8, 9)),
        history: history,
        data: data,
        prayerStreak: 10, // Aug 7+6 only
        dayStreak: 2,
      );

      data = data.expireFully();
      expectStableRecalc(
        now: eve(DateTime(2026, 8, 10)),
        history: history,
        data: data,
        prayerStreak: 15, // Aug 10 + 7 + 6; during marks ignored
        dayStreak: 3,
      );

      // Pure recompute: toggling data off again must not change counts.
      expectStableRecalc(
        now: eve(DateTime(2026, 8, 10)),
        history: history,
        data: data.disableOn(DateTime(2026, 8, 10)),
        prayerStreak: 15,
        dayStreak: 3,
      );
    });
  });
}
