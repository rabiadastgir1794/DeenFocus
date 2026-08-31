import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/cycle_mode_policy.dart';
import 'package:deenly/features/home/services/prayer_analytics_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Toggle Cycle Mode must not unexpectedly rewrite an existing tip.
///
/// Marks in [statusHistory] are never mutated by Cycle Mode; only the
/// pause-bridge rules change how they contribute. Same-day enable preserves
/// today's counting tip; mid-cycle days bridge without inflating.
void main() {
  Map<TrackablePrayer, PrayerMarkStatus> allFive() => {
        for (final p in TrackablePrayer.values) p: PrayerMarkStatus.onTime,
      };

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
      isExcludedStatsDay: (d) => policy.shouldExcludeFromStatistics(d, now: now),
    );
  }

  group('Cycle Mode toggle vs prayer streak', () {
    test('OFF → ON → OFF same day: streak X unchanged; marks untouched', () {
      final today = DateTime(2026, 8, 11);
      final now = DateTime(2026, 8, 11, 21);
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(today): allFive(),
      };

      final off = calc(
        now: now,
        history: history,
        data: CycleModeData.disabled(),
      );
      expect(off.prayerStreak, 5);
      expect(off.dayStreak, 1);

      final onData = CycleModeData(
        isEnabled: true,
        startDate: today,
        cycleLength: 4,
        pauseStreaks: true,
      );
      final on = calc(now: now, history: history, data: onData);
      expect(on.prayerStreak, 5);
      expect(on.dayStreak, 1);
      expect(history[key(today)]![TrackablePrayer.fajr], PrayerMarkStatus.onTime);

      final toggledOff = onData.disableOn(today);
      expect(toggledOff.history, isEmpty);
      final again = calc(now: now, history: history, data: toggledOff);
      expect(again.prayerStreak, 5);
      expect(again.dayStreak, 1);
    });

    test('pauseStreaks=false: toggle ON/OFF does not invent a different tip', () {
      final today = DateTime(2026, 8, 11);
      final now = DateTime(2026, 8, 11, 21);
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(today): allFive(),
      };

      final before = calc(
        now: now,
        history: history,
        data: CycleModeData.disabled(),
      );

      final onData = CycleModeData(
        isEnabled: true,
        startDate: today,
        cycleLength: 3,
        pauseStreaks: false,
      );
      final during = calc(now: now, history: history, data: onData);
      expect(during.prayerStreak, before.prayerStreak);
      expect(during.dayStreak, before.dayStreak);

      final after = calc(
        now: now,
        history: history,
        data: onData.disableOn(today),
      );
      expect(after.prayerStreak, before.prayerStreak);
      expect(after.dayStreak, before.dayStreak);
    });

    test('marks before / during / after Cycle Mode stay consistent', () {
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        key(DateTime(2026, 8, 8)): allFive(),
        key(DateTime(2026, 8, 9)): allFive(), // cycle start (same-day counts while today)
        key(DateTime(2026, 8, 10)): {
          TrackablePrayer.fajr: PrayerMarkStatus.missed,
        }, // mid-cycle: bridged, ignored
        key(DateTime(2026, 8, 11)): allFive(), // after cycle
      };

      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 9),
        cycleLength: 2,
        pauseStreaks: true,
      );

      // Same-day start day: today's marks kept with prior tip.
      expect(
        calc(
          now: DateTime(2026, 8, 9, 21),
          history: history,
          data: data,
        ).prayerStreak,
        10,
      );

      // Next paused day: mid-cycle bridge — only pre-cycle tip (Aug 8).
      expect(
        calc(
          now: DateTime(2026, 8, 10, 21),
          history: history,
          data: data,
        ).prayerStreak,
        5,
      );

      data = data.disableOn(DateTime(2026, 8, 11));
      final after = calc(
        now: DateTime(2026, 8, 11, 21),
        history: history,
        data: data,
      );
      // Aug 11 + Aug 8; sealed pause days bridged (miss ignored).
      expect(after.prayerStreak, 10);
      expect(after.dayStreak, 2);
    });

    test('reopening (json round-trip) yields the same streak', () {
      final today = DateTime(2026, 8, 11);
      final now = DateTime(2026, 8, 11, 14);
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
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
      final live = calc(now: now, history: history, data: data);
      final cold = calc(
        now: now,
        history: history,
        data: CycleModeData.fromJson(data.toJsonMap()),
      );
      expect(cold.prayerStreak, live.prayerStreak);
      expect(cold.dayStreak, live.dayStreak);
      expect(cold.prayerStreak, 2);
    });

    test(
      'Home/Insights/AchievementCalculator share PrayerStreakCalculator rules',
      () {
        final now = DateTime(2026, 8, 10, 21);
        final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
          key(DateTime(2026, 8, 8)): allFive(),
          key(DateTime(2026, 8, 9)): allFive(),
          // Mid-cycle mark must not inflate (bridge only).
          key(DateTime(2026, 8, 10)): {
            TrackablePrayer.fajr: PrayerMarkStatus.onTime,
            TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
          },
        };
        final data = CycleModeData(
          isEnabled: true,
          startDate: DateTime(2026, 8, 9),
          cycleLength: 3,
          pauseStreaks: true,
        );
        final policy = CycleModePolicy(data);
        final snap = calc(now: now, history: history, data: data);
        final achievementInputs = AchievementCalculator.calculate(
          now: now,
          statusHistory: history,
          isPausedStreakDay: (d) => policy.shouldPauseStreaks(d, now: now),
        );

        // Pre-cycle tip only (Aug 8); Aug 9–10 bridged.
        expect(snap.prayerStreak, 5);
        expect(snap.dayStreak, 1);
        expect(achievementInputs.prayerStreak, snap.prayerStreak);
        expect(achievementInputs.dayStreak, snap.dayStreak);
      },
    );
  });
}
