import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/achievements_service.dart';
import 'package:deenly/features/home/services/cycle_mode_policy.dart';
import 'package:deenly/features/home/services/prayer_analytics_service.dart';
import 'package:deenly/features/home/services/xp_service.dart';
import 'package:flutter_test/flutter_test.dart';

/// Product rules: mid-cycle / sealed Cycle days bridge streaks (zero mid-cycle
/// inflation) and exclude Insights/XP/achievement day counters when configured.
/// Same-day Cycle start keeps today's started slots (unmarked gaps still
/// terminate; Missed does not tip-break).
void main() {
  Map<TrackablePrayer, PrayerMarkStatus> allFive([
    PrayerMarkStatus status = PrayerMarkStatus.onTime,
  ]) =>
      {for (final p in TrackablePrayer.values) p: status};

  String key(DateTime d) => PrayerAnalyticsService.dayKey(d);

  DateTime eve(DateTime day) => DateTime(day.year, day.month, day.day, 21);

  PrayerAnalyticsSnapshot analytics({
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

  List<XpEvent> prayerXpEvents({
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> history,
    required CycleModeData data,
    required DateTime now,
  }) {
    final policy = CycleModePolicy(data);
    return XpService.collectFromActivity(
      now: now,
      statusHistory: history,
      checklistHistory: const {},
      cycleProtectedDays: AchievementsService.protectedDaysUntilToday(
        policy: policy,
        now: now,
      ),
      bestPrayerStreak: 0,
      isExcludedProgressDay: (d) =>
          policy.shouldExcludeFromPrayerProgress(d, now: now),
    );
  }

  int fajrAchievementProgress({
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> history,
    required CycleModeData data,
    required DateTime now,
  }) {
    final policy = CycleModePolicy(data);
    final snap = analytics(now: now, history: history, data: data);
    final activity = AchievementActivitySnapshot(
      now: now,
      prayerStreak: snap.prayerStreak,
      bestPrayerStreak: snap.prayerStreak,
      statusHistory: history,
      checklistHistory: const {},
      cycleProtectedDays: AchievementsService.protectedDaysUntilToday(
        policy: policy,
        now: now,
      ),
      currentLevel: 1,
      isExcludedProgressDay: (d) =>
          policy.shouldExcludeFromPrayerProgress(d, now: now),
    );
    return AchievementsService.progressFor(AchievementId.fajrWarrior, activity);
  }

  group('Cycle Mode × Prayer Streak product rule', () {
    test('1. Normal streak without Cycle Mode', () {
      final today = DateTime(2026, 8, 12);
      final history = {
        key(DateTime(2026, 8, 10)): allFive(),
        key(DateTime(2026, 8, 11)): allFive(),
        key(today): allFive(),
      };
      final snap = analytics(
        now: eve(today),
        history: history,
        data: CycleModeData.disabled(),
      );
      expect(snap.prayerStreak, 15);
      expect(snap.dayStreak, 3);
      expect(snap.weeklyCompleted, greaterThan(0));
    });

    test('2. Cycle Mode in the middle of a streak bridges, does not count', () {
      final history = {
        key(DateTime(2026, 8, 8)): allFive(),
        key(DateTime(2026, 8, 9)): allFive(), // cycle
        key(DateTime(2026, 8, 10)): allFive(), // cycle
        key(DateTime(2026, 8, 11)): allFive(),
      };
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 9),
        cycleLength: 2,
        pauseStreaks: true,
        excludeFromStatistics: true,
      );
      final snap = analytics(
        now: eve(DateTime(2026, 8, 11)),
        history: history,
        data: data,
      );
      expect(snap.prayerStreak, 10); // Aug 11 + Aug 8
      expect(snap.dayStreak, 2);
      expect(
        WeeklyCalculator.completedCountOnDate(
          DateTime(2026, 8, 9),
          history,
          (d) => CycleModePolicy(data).shouldExcludeFromStatistics(d),
        ),
        0,
      );
    });

    test('3. Multiple Cycle Mode days never inflate or break', () {
      final history = {
        key(DateTime(2026, 8, 5)): allFive(),
        for (var d = 6; d <= 10; d++)
          key(DateTime(2026, 8, d)): {
            TrackablePrayer.fajr: PrayerMarkStatus.missed,
            TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
          },
        key(DateTime(2026, 8, 11)): allFive(),
      };
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 6),
        cycleLength: 5,
        pauseStreaks: true,
        excludeFromStatistics: true,
      );
      final snap = analytics(
        now: eve(DateTime(2026, 8, 11)),
        history: history,
        data: data,
      );
      expect(snap.prayerStreak, 10);
      expect(snap.dayStreak, 2);
    });

    test('4. Cycle Mode starting today with prayers already completed', () {
      final today = DateTime(2026, 8, 11);
      final history = {
        key(DateTime(2026, 8, 9)): allFive(),
        key(DateTime(2026, 8, 10)): allFive(),
        key(today): allFive(),
      };
      final before = analytics(
        now: eve(today),
        history: history,
        data: CycleModeData.disabled(),
      );
      expect(before.prayerStreak, 15);
      expect(before.dayStreak, 3);

      final data = CycleModeData(
        isEnabled: true,
        startDate: today,
        cycleLength: 4,
        pauseStreaks: true,
        excludeFromStatistics: true,
      );
      final during = analytics(now: eve(today), history: history, data: data);
      // Same-day start keeps today's completed tip; stats bars still exclude.
      expect(during.prayerStreak, 15);
      expect(during.dayStreak, 3);
      expect(
        during.homeWeekDayCounts[
            WeeklyCalculator.mondayWeekDates(today).indexOf(today)],
        0,
      );
    });

    test('5. Partial prayers on same-day Cycle keep tip; unmarked gaps apply', () {
      final today = DateTime(2026, 8, 11);
      final history = {
        key(DateTime(2026, 8, 10)): allFive(),
        key(today): {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
        },
      };
      final data = CycleModeData(
        isEnabled: true,
        startDate: today,
        cycleLength: 3,
        pauseStreaks: true,
        excludeFromStatistics: true,
      );
      final snap = analytics(
        now: DateTime(2026, 8, 11, 14),
        history: history,
        data: data,
      );
      // Fajr+Dhuhr tip (Asr not started) continues into yesterday.
      expect(snap.prayerStreak, 7);
      expect(snap.dayStreak, 1);
      final xp = prayerXpEvents(history: history, data: data, now: eve(today));
      expect(
        xp.where((e) => e.sourceId.startsWith('prayer:${key(today)}')),
        isEmpty,
      );
    });

    test('6. All prayers completed on same-day Cycle still count for streak',
        () {
      final today = DateTime(2026, 8, 11);
      final history = {
        key(DateTime(2026, 8, 10)): allFive(),
        key(today): allFive(),
      };
      final data = CycleModeData(
        isEnabled: true,
        startDate: today,
        cycleLength: 3,
        pauseStreaks: true,
        excludeFromStatistics: true,
      );
      final snap = analytics(now: eve(today), history: history, data: data);
      expect(snap.prayerStreak, 10);
      expect(snap.dayStreak, 2);

      expect(fajrAchievementProgress(history: history, data: data, now: eve(today)), 1);
      // Only Aug 10 Fajr counts for achievement progress — cycle day Fajr excluded.
    });

    test('7. Cycle Mode disabled same day restores normal streak behavior', () {
      final today = DateTime(2026, 8, 11);
      final history = {key(today): allFive()};
      var data = CycleModeData(
        isEnabled: true,
        startDate: today,
        cycleLength: 4,
        pauseStreaks: true,
        excludeFromStatistics: true,
      );
      expect(
        analytics(now: eve(today), history: history, data: data).prayerStreak,
        5,
      );

      data = data.disableOn(today);
      expect(data.history, isEmpty);
      final after = analytics(now: eve(today), history: history, data: data);
      expect(after.prayerStreak, 5);
      expect(after.dayStreak, 1);
      expect(
        after.homeWeekDayCounts[
            WeeklyCalculator.mondayWeekDates(today).indexOf(today)],
        5,
      );

      final xp = prayerXpEvents(history: history, data: data, now: eve(today));
      expect(
        xp.where((e) => e.sourceId.startsWith('prayer:${key(today)}')).length,
        5,
      );
    });

    test('8. Retroactive sealed history excludes past cycle days', () {
      final history = {
        key(DateTime(2026, 8, 8)): allFive(),
        key(DateTime(2026, 8, 9)): allFive(),
        key(DateTime(2026, 8, 10)): allFive(),
        key(DateTime(2026, 8, 11)): allFive(),
      };
      final data = CycleModeData(
        isEnabled: false,
        startDate: DateTime(2026, 8, 12),
        history: [
          CycleModeInterval(
            startDate: DateTime(2026, 8, 9),
            endDate: DateTime(2026, 8, 10),
          ),
        ],
      );
      final snap = analytics(
        now: eve(DateTime(2026, 8, 11)),
        history: history,
        data: data,
      );
      expect(snap.prayerStreak, 10); // Aug 11 + Aug 8
      expect(snap.dayStreak, 2);
      expect(CycleModePolicy(data).isHighlightable(DateTime(2026, 8, 9)), isTrue);
      expect(CycleModePolicy(data).shouldPauseStreaks(DateTime(2026, 8, 9)), isTrue);
    });

    test('9. App restart (JSON round-trip) keeps same-day tip rules', () {
      final history = {
        key(DateTime(2026, 8, 8)): allFive(),
        key(DateTime(2026, 8, 9)): allFive(),
      };
      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 9),
        cycleLength: 3,
        pauseStreaks: true,
        excludeFromStatistics: true,
      );
      data = CycleModeData.fromJson(data.toJsonMap());
      final snap = analytics(
        now: eve(DateTime(2026, 8, 9)),
        history: history,
        data: data,
      );
      expect(snap.prayerStreak, 10);
      expect(snap.dayStreak, 2);
    });

    test('10. Cycle Mode expiry seals history; pre-cycle tip continues', () {
      final history = {
        key(DateTime(2026, 8, 10)): {
          TrackablePrayer.maghrib: PrayerMarkStatus.onTime,
          TrackablePrayer.isha: PrayerMarkStatus.onTime,
        },
        key(DateTime(2026, 8, 11)): allFive(), // sealed cycle day
        key(DateTime(2026, 8, 12)): allFive(), // sealed
        key(DateTime(2026, 8, 13)): {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
        },
      };
      var data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 11),
        cycleLength: 2,
        pauseStreaks: true,
        excludeFromStatistics: true,
      );
      expect(data.hasExpiredOn(DateTime(2026, 8, 13)), isTrue);
      data = data.expireFully();
      data = CycleModeData.fromJson(data.toJsonMap());

      final snap = analytics(
        now: DateTime(2026, 8, 13, 10),
        history: history,
        data: data,
      );
      // Daily count: today Fajr (1); Aug 10 incomplete (2) stops without adding.
      expect(snap.prayerStreak, 1);
      expect(snap.dayStreak, 0);

      final xp = prayerXpEvents(
        history: history,
        data: data,
        now: DateTime(2026, 8, 13, 10),
      );
      expect(
        xp.where(
          (e) =>
              e.type == XpEventType.prayer ||
              e.type == XpEventType.fajr ||
              e.type == XpEventType.fiveDailyPrayers,
        ).where((e) => e.sourceId.contains('2026-08-11')),
        isEmpty,
      );
      expect(
        xp.where(
          (e) =>
              e.type == XpEventType.prayer ||
              e.type == XpEventType.fajr ||
              e.type == XpEventType.fiveDailyPrayers,
        ).where((e) => e.sourceId.contains('2026-08-12')),
        isEmpty,
      );
      expect(
        xp.any((e) => e.sourceId == 'prayer:2026-08-13:fajr'),
        isTrue,
      );
    });

    test('Insights weekly/monthly/rate exclude Cycle Mode days', () {
      // Wednesday Aug 5 → insights week Fri Aug 1 – Thu Aug 7.
      final now = DateTime(2026, 8, 5, 21);
      final history = {
        for (var d = 1; d <= 7; d++)
          key(DateTime(2026, 8, d)): allFive(),
      };
      final data = CycleModeData(
        isEnabled: true,
        startDate: DateTime(2026, 8, 3),
        cycleLength: 3, // Aug 3–5
        pauseStreaks: true,
        excludeFromStatistics: true,
      );
      final snap = analytics(now: now, history: history, data: data);
      final policy = CycleModePolicy(data);
      expect(policy.shouldExcludeFromStatistics(DateTime(2026, 8, 3), now: now), isTrue);
      expect(policy.shouldExcludeFromStatistics(DateTime(2026, 8, 4), now: now), isTrue);
      expect(policy.shouldExcludeFromStatistics(DateTime(2026, 8, 5), now: now), isTrue);
      expect(policy.shouldExcludeFromStatistics(DateTime(2026, 8, 1), now: now), isFalse);
      expect(
        WeeklyCalculator.completedCountOnDate(
          DateTime(2026, 8, 3),
          history,
          (d) => policy.shouldExcludeFromStatistics(d, now: now),
        ),
        0,
      );
      expect(
        WeeklyCalculator.completedCountOnDate(
          DateTime(2026, 8, 1),
          history,
          (d) => policy.shouldExcludeFromStatistics(d, now: now),
        ),
        5,
      );
      expect(snap.weeklyPossible, lessThan(PrayerAnalyticsService.weeklyPossible));
      expect(snap.weeklyCompleted, lessThanOrEqualTo(snap.weeklyPossible));
      expect(snap.weeklyCompleted, greaterThan(0));
      expect(snap.prayerRatePercent, greaterThan(0));
    });

    test('pauseStreaks=false still allows streak contribution when configured',
        () {
      final today = DateTime(2026, 8, 11);
      final history = {key(today): allFive()};
      final data = CycleModeData(
        isEnabled: true,
        startDate: today,
        cycleLength: 2,
        pauseStreaks: false,
        excludeFromStatistics: true,
      );
      final snap = analytics(now: eve(today), history: history, data: data);
      expect(snap.prayerStreak, 5);
      expect(snap.dayStreak, 1);
      // Stats still exclude when excludeFromStatistics is true.
      expect(
        WeeklyCalculator.completedCountOnDate(
          today,
          history,
          (d) => CycleModePolicy(data).shouldExcludeFromStatistics(d),
        ),
        0,
      );
    });
  });
}
