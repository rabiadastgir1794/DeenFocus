import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/achievements_service.dart';
import 'package:deenly/features/home/services/level_service.dart';
import 'package:deenly/features/home/services/prayer_analytics_service.dart';
import 'package:deenly/features/home/services/xp_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('LevelService', () {
    test('thresholds', () {
      expect(LevelService.getLevelFromXP(0).currentLevel, 1);
      expect(LevelService.getLevelFromXP(99).currentLevel, 1);
      expect(LevelService.getLevelFromXP(100).currentLevel, 2);
      expect(LevelService.getLevelFromXP(249).currentLevel, 2);
      expect(LevelService.getLevelFromXP(250).currentLevel, 3);
      expect(LevelService.getLevelFromXP(6400).currentLevel, 15);
      expect(LevelService.getLevelFromXP(10000).currentLevel, 15);
      expect(LevelService.getLevelFromXP(10000).isMaxLevel, isTrue);
    });

    test('progress within a level', () {
      final progress = LevelService.getLevelFromXP(680);
      expect(progress.currentLevel, 4);
      expect(progress.currentLevelXP, 450);
      expect(progress.nextLevelXP, 700);
      expect(progress.progressXP, 230);
      expect(progress.xpToNext, 20);
      expect(progress.isMaxLevel, isFalse);
    });
  });

  group('Achievement evaluation', () {
    AchievementActivitySnapshot snapshot({
      int prayerStreak = 0,
      int bestPrayerStreak = 0,
      Map<String, Map<TrackablePrayer, PrayerMarkStatus>> history = const {},
      Map<String, Set<DailyChecklistItem>> checklist = const {},
      List<DateTime> cycleDays = const [],
      int currentLevel = 1,
      DateTime? journeyStart,
      DateTime? now,
    }) {
      return AchievementActivitySnapshot(
        now: now ?? DateTime(2026, 8, 19),
        prayerStreak: prayerStreak,
        bestPrayerStreak: bestPrayerStreak,
        statusHistory: history,
        checklistHistory: checklist,
        cycleProtectedDays: cycleDays,
        currentLevel: currentLevel,
        journeyStartDate: journeyStart,
      );
    }

    Map<TrackablePrayer, PrayerMarkStatus> allFive() => {
      for (final p in TrackablePrayer.values) p: PrayerMarkStatus.onTime,
    };

    test('there are exactly 20 achievements', () {
      expect(AchievementId.values.length, 20);
      expect(AchievementsService.totalCount, 20);
    });

    test('first prayer unlocks from a single counted prayer', () {
      final activity = snapshot(
        history: {
          '2026-08-01': {TrackablePrayer.dhuhr: PrayerMarkStatus.onTime},
        },
      );
      expect(
        AchievementsService.progressFor(AchievementId.firstPrayer, activity),
        1,
      );
    });

    test('prayer streak achievements use the existing streak', () {
      final activity = snapshot(prayerStreak: 7, bestPrayerStreak: 7);
      expect(
        AchievementsService.progressFor(
          AchievementId.sevenPrayerStreak,
          activity,
        ),
        7,
      );
      expect(
        AchievementsService.progressFor(
          AchievementId.thirtyPrayerStreak,
          activity,
        ),
        7,
      );
      final long = snapshot(prayerStreak: 12, bestPrayerStreak: 30);
      expect(
        AchievementsService.progressFor(
          AchievementId.thirtyPrayerStreak,
          long,
        ),
        30,
      );
    });

    test('fajr counts unique days, not repeats on the same day', () {
      final activity = snapshot(
        history: {
          '2026-08-01': {TrackablePrayer.fajr: PrayerMarkStatus.onTime},
          '2026-08-02': {TrackablePrayer.fajr: PrayerMarkStatus.qada},
        },
      );
      expect(
        AchievementsService.progressFor(AchievementId.fajrWarrior, activity),
        2,
      );
    });

    test('quran and dhikr count unique qualifying days', () {
      final activity = snapshot(
        checklist: {
          '2026-08-01': {DailyChecklistItem.quran, DailyChecklistItem.dhikr},
          '2026-08-02': {DailyChecklistItem.quran},
          '2026-08-03': {DailyChecklistItem.morningAdhkar},
        },
      );
      expect(
        AchievementsService.progressFor(AchievementId.quranReader, activity),
        2,
      );
      expect(
        AchievementsService.progressFor(AchievementId.dhikrStarter, activity),
        2,
      );
    });

    test('consistency champion counts unique qualifying days', () {
      final activity = snapshot(
        history: {
          '2026-08-01': {TrackablePrayer.asr: PrayerMarkStatus.onTime},
        },
        checklist: {
          '2026-08-01': {DailyChecklistItem.quran},
          '2026-08-02': {DailyChecklistItem.dhikr},
        },
      );
      expect(
        AchievementsService.progressFor(
          AchievementId.consistencyChampion,
          activity,
        ),
        2,
      );
    });

    test('perfect week uses consecutive all-five days', () {
      final history = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
        for (var i = 1; i <= 7; i++)
          '2026-08-0$i': allFive(),
      };
      final activity = snapshot(history: history);
      expect(
        AchievementsService.progressFor(AchievementId.perfectWeek, activity),
        7,
      );
      expect(
        AchievementsService.progressFor(AchievementId.fiveADay, activity),
        1,
      );
    });

    test('six-month journey uses calendar days since start', () {
      final activity = snapshot(
        checklist: {
          '2026-02-20': {DailyChecklistItem.quran},
        },
        journeyStart: DateTime(2026, 2, 20),
        now: DateTime(2026, 8, 19),
      );
      expect(
        AchievementsService.progressFor(
          AchievementId.sixMonthJourney,
          activity,
        ),
        180,
      );
    });

    test('never resets an unlocked achievement', () {
      final previous = [
        AchievementProgress(
          id: AchievementId.sevenPrayerStreak,
          current: 7,
          target: 7,
          unlockedAt: DateTime(2026, 7, 1),
        ),
      ];
      final next = AchievementsService.evaluate(
        previous: previous,
        activity: snapshot(prayerStreak: 0, bestPrayerStreak: 0),
      );
      final item = next.firstWhere(
        (e) => e.id == AchievementId.sevenPrayerStreak,
      );
      expect(item.isUnlocked, isTrue);
      expect(item.unlockedAt, DateTime(2026, 7, 1));
    });

    test('masjid companion stays at zero without visit data', () {
      expect(
        AchievementsService.progressFor(
          AchievementId.masjidCompanion,
          snapshot(),
        ),
        0,
      );
    });

    test('deenfocus master unlocks at level 15', () {
      expect(
        AchievementsService.progressFor(
          AchievementId.deenfocusMaster,
          snapshot(currentLevel: 15),
        ),
        1,
      );
      expect(
        AchievementsService.progressFor(
          AchievementId.deenfocusMaster,
          snapshot(currentLevel: 14),
        ),
        0,
      );
    });

    test('migrates legacy firstPrayerStreak id', () {
      final parsed = AchievementIdX.parse('firstPrayerStreak');
      expect(parsed, AchievementId.firstPrayer);
      expect(AchievementId.firstPrayer.storageId, 'first_prayer');
    });
  });

  group('XpService', () {
    test('does not award duplicate XP for the same event', () {
      final history = {
        '2026-08-01': {
          TrackablePrayer.fajr: PrayerMarkStatus.onTime,
          TrackablePrayer.dhuhr: PrayerMarkStatus.onTime,
        },
      };
      final first = XpService.collectFromActivity(
        now: DateTime(2026, 8, 1),
        statusHistory: history,
        checklistHistory: const {},
        cycleProtectedDays: const [],
        bestPrayerStreak: 0,
      );
      final second = XpService.collectFromActivity(
        now: DateTime(2026, 8, 1),
        statusHistory: history,
        checklistHistory: const {},
        cycleProtectedDays: const [],
        bestPrayerStreak: 0,
      );
      final merged = XpService.merge(previous: first, computed: second);
      expect(XpService.totalXp(merged), XpService.totalXp(first));
      expect(merged.length, first.length);
    });

    test('quran XP is once per day', () {
      final events = XpService.collectFromActivity(
        now: DateTime(2026, 8, 1),
        statusHistory: const {},
        checklistHistory: {
          '2026-08-01': {DailyChecklistItem.quran},
        },
        cycleProtectedDays: const [],
        bestPrayerStreak: 0,
      );
      final quran = events.where((e) => e.type == XpEventType.quran);
      expect(quran.length, 1);
      expect(quran.first.amount, 10);
    });

    test('streak milestone XP is awarded once', () {
      final events = XpService.collectFromActivity(
        now: DateTime(2026, 8, 1),
        statusHistory: const {},
        checklistHistory: const {},
        cycleProtectedDays: const [],
        bestPrayerStreak: 30,
      );
      expect(
        events.where((e) => e.sourceId == 'streak_milestone:7').length,
        1,
      );
      expect(
        events.where((e) => e.sourceId == 'streak_milestone:30').length,
        1,
      );
    });
  });

  test('day key matches prayer analytics', () {
    expect(
      PrayerAnalyticsService.dayKey(DateTime(2026, 8, 1)),
      '2026-08-01',
    );
  });
}
