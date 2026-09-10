import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/cycle_mode_policy.dart';
import 'package:deenly/features/home/services/prayer_analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Regression: Day1 full (5) → Day2 Cycle pause → Day3 two prayers.
/// Expected prayer streak 7 and day streak 1 after save → reload/recalc.
///
/// A stale/partial weekDays row must not erase history-only marks (e.g. Fajr),
/// which previously produced prayer=6 / day=0 after restore.
void main() {
  Map<TrackablePrayer, PrayerMarkStatus> allFive([
    PrayerMarkStatus status = PrayerMarkStatus.onTime,
  ]) =>
      {for (final p in TrackablePrayer.values) p: status};

  String key(DateTime d) => PrayerAnalyticsService.dayKey(d);

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
      isExcludedStatsDay: (d) =>
          policy.shouldExcludeFromStatistics(d, now: now),
    );
  }

  final day1 = DateTime(2026, 9, 1);
  final day2 = DateTime(2026, 9, 2);
  final day3 = DateTime(2026, 9, 3);
  final nowDay3 = DateTime(2026, 9, 3, 14, 30);

  Map<String, Map<TrackablePrayer, PrayerMarkStatus>> scenarioHistory() => {
        key(day1): allFive(),
        key(day3): {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
        },
      };

  CycleModeData sealedDay2Cycle() => CycleModeData(
        isEnabled: true,
        startDate: day2,
        cycleLength: 1,
        pauseStreaks: true,
      ).expireFully();

  group('Cycle Mode bridge: Day1=5, Day2=paused, Day3=2', () {
    test('live calc: prayer 7, day streak 1', () {
      final data = sealedDay2Cycle();
      expect(CycleModePolicy(data).shouldPauseStreaks(day2, now: nowDay3), isTrue);
      expect(
        CycleModePolicy(data).shouldPauseStreaks(day1, now: nowDay3),
        isFalse,
      );

      final snap = calc(
        now: nowDay3,
        history: scenarioHistory(),
        data: data,
      );
      expect(snap.prayerStreak, 7);
      expect(snap.dayStreak, 1);
    });

    test('active (not yet sealed) Day2 cycle: same 7 / 1', () {
      final data = CycleModeData(
        isEnabled: true,
        startDate: day2,
        cycleLength: 1,
        pauseStreaks: true,
      );
      // Day3: window expired but still enabled until expireFully — pause Day2.
      expect(data.hasExpiredOn(nowDay3), isTrue);
      expect(CycleModePolicy(data).shouldPauseStreaks(day2, now: nowDay3), isTrue);

      final snap = calc(
        now: nowDay3,
        history: scenarioHistory(),
        data: data,
      );
      expect(snap.prayerStreak, 7);
      expect(snap.dayStreak, 1);
    });

    test(
      'save → JSON restore → weekDays union merge → still 7 / 1',
      () {
        final data = CycleModeData.fromJson(sealedDay2Cycle().toJsonMap());
        final fullHistory = scenarioHistory();

        // Persist streak JSON with full statusHistory but a stale week row
        // missing Fajr on Day1 (the overwrite bug that produced 6 / 0).
        final persisted = HomePrayerStreakState(
          weekStartDateKey: key(DateTime(2026, 8, 31)), // Monday of that week
          weekDays: [
            HomePrayerChecklistDay(
              dateKey: key(day1),
              selectedPrayers: {
                TrackablePrayer.dhuhr,
                TrackablePrayer.asr,
                TrackablePrayer.maghrib,
                TrackablePrayer.isha,
              },
              prayerStatuses: {
                TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
                TrackablePrayer.asr: PrayerMarkStatus.onTime,
                TrackablePrayer.maghrib: PrayerMarkStatus.onTime,
                TrackablePrayer.isha: PrayerMarkStatus.onTime,
              },
            ),
            HomePrayerChecklistDay(
              dateKey: key(day3),
              selectedPrayers: {
                TrackablePrayer.fajr,
                TrackablePrayer.dhuhr,
              },
              prayerStatuses: {
                TrackablePrayer.fajr: PrayerMarkStatus.onTime,
                TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
              },
            ),
          ],
          completedDateKeys: {key(day1)},
          statusHistory: fullHistory,
        );

        final restored = HomePrayerStreakState.fromJson(persisted.toJson());
        expect(restored.statusHistory[key(day1)]![TrackablePrayer.fajr],
            PrayerMarkStatus.onTime);

        // Old overwrite path (replace) — documents the regression numbers.
        final overwritten = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
          for (final e in restored.statusHistory.entries)
            e.key: Map<TrackablePrayer, PrayerMarkStatus>.from(e.value),
        };
        for (final day in restored.weekDays) {
          final confirmed = <TrackablePrayer, PrayerMarkStatus>{
            for (final p in TrackablePrayer.values)
              if (day.statusFor(p) != PrayerMarkStatus.none) p: day.statusFor(p),
          };
          if (confirmed.isNotEmpty) {
            overwritten[day.dateKey] = confirmed;
          }
        }
        final broken = calc(now: nowDay3, history: overwritten, data: data);
        // Daily-count model: today 2; Day1 incomplete (4) stops without adding.
        expect(broken.prayerStreak, 2);
        expect(broken.dayStreak, 0);

        // Fixed union merge (load + live recalc path).
        final merged = HomePrayerStreakState.mergeWeekDaysIntoHistory(
          statusHistory: restored.statusHistory,
          weekDays: restored.weekDays,
        );
        expect(merged[key(day1)]![TrackablePrayer.fajr], PrayerMarkStatus.onTime);
        expect(merged[key(day1)]!.length, 5);

        final snap = calc(now: nowDay3, history: merged, data: data);
        expect(snap.prayerStreak, 7);
        expect(snap.dayStreak, 1);
      },
    );

    test('Cycle day is bridged — not a miss; Day1 stays counted', () {
      final data = sealedDay2Cycle();
      final history = scenarioHistory();
      // Explicit miss / empty marks on the Cycle day must not break.
      history[key(day2)] = {
        TrackablePrayer.fajr: PrayerMarkStatus.missed,
      };
      final snap = calc(now: nowDay3, history: history, data: data);
      expect(snap.prayerStreak, 7);
      expect(snap.dayStreak, 1);
    });
  });

  group('Non-Cycle streak behavior unchanged', () {
    test('two full days → prayer 10, day streak 2', () {
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(DateTime(2026, 9, 1)): allFive(),
        key(DateTime(2026, 9, 2)): allFive(),
      };
      final snap = calc(
        now: DateTime(2026, 9, 2, 21),
        history: history,
        data: CycleModeData.disabled(),
      );
      expect(snap.prayerStreak, 10);
      expect(snap.dayStreak, 2);
    });

    test('incomplete today does not break prior day streak', () {
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(DateTime(2026, 9, 1)): allFive(),
        key(DateTime(2026, 9, 2)): {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
        },
      };
      final snap = calc(
        now: DateTime(2026, 9, 2, 14, 30),
        history: history,
        data: CycleModeData.disabled(),
      );
      expect(snap.prayerStreak, 7);
      expect(snap.dayStreak, 1);
    });

    test('gap day without Cycle Mode breaks day streak', () {
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(DateTime(2026, 9, 1)): allFive(),
        key(DateTime(2026, 9, 3)): {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
        },
      };
      final snap = calc(
        now: DateTime(2026, 9, 3, 14, 30),
        history: history,
        data: CycleModeData.disabled(),
      );
      expect(snap.prayerStreak, 2);
      expect(snap.dayStreak, 0);
    });

    test('union merge still applies weekDays overlays on matching prayers', () {
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(day3): {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
        },
      };
      final weekDays = [
        HomePrayerChecklistDay(
          dateKey: key(day3),
          selectedPrayers: {TrackablePrayer.fajr, TrackablePrayer.dhuhr},
          prayerStatuses: {
            TrackablePrayer.fajr: PrayerMarkStatus.qada,
            TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
          },
        ),
      ];
      final merged = HomePrayerStreakState.mergeWeekDaysIntoHistory(
        statusHistory: history,
        weekDays: weekDays,
      );
      expect(merged[key(day3)]![TrackablePrayer.fajr], PrayerMarkStatus.qada);
      expect(merged[key(day3)]![TrackablePrayer.dhuhr], PrayerMarkStatus.onTime);
    });
  });
}
