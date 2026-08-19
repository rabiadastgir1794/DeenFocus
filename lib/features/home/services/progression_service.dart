import 'dart:convert';

import '../../../core/services/storage_service.dart';
import 'achievements_service.dart';
import 'level_service.dart';
import 'xp_service.dart';

class ProgressionSnapshot {
  const ProgressionSnapshot({
    required this.progress,
    required this.level,
    required this.achievements,
    required this.events,
    required this.newlyUnlocked,
    required this.xpGained,
  });

  final UserProgress progress;
  final LevelProgress level;
  final List<AchievementProgress> achievements;
  final List<XpEvent> events;
  final List<AchievementId> newlyUnlocked;
  final int xpGained;
}

/// Orchestrates XP, levels, and achievements. Idempotent.
abstract class ProgressionService {
  static const _progressKey = 'home_user_progress_json';
  static const _xpKey = 'home_xp_events_json';

  static Future<UserProgress> loadProgress() async {
    final raw = await StorageService.getString(_progressKey);
    if (raw == null || raw.isEmpty) return UserProgress.initial();
    try {
      return UserProgress.fromMap(
        Map<String, dynamic>.from(jsonDecode(raw) as Map),
      );
    } catch (_) {
      return UserProgress.initial();
    }
  }

  static Future<List<XpEvent>> loadEvents() async {
    final raw = await StorageService.getString(_xpKey);
    if (raw == null || raw.isEmpty) return const <XpEvent>[];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return [
        for (final row in list)
          XpEvent.fromMap(Map<String, dynamic>.from(row as Map)),
      ];
    } catch (_) {
      return const <XpEvent>[];
    }
  }

  static Future<void> saveProgress(UserProgress progress) async {
    await StorageService.setString(_progressKey, jsonEncode(progress.toMap()));
  }

  static Future<void> saveEvents(List<XpEvent> events) async {
    await StorageService.setString(
      _xpKey,
      jsonEncode(events.map((e) => e.toMap()).toList()),
    );
  }

  static Future<ProgressionSnapshot> evaluateAndPersist({
    required UserProgress previousProgress,
    required List<XpEvent> previousEvents,
    required List<AchievementProgress> previousAchievements,
    required AchievementActivitySnapshot Function(int currentLevel) activityFor,
    DateTime? now,
  }) async {
    final moment = now ?? DateTime.now();
    final activityForXp = activityFor(previousProgress.currentLevel);

    final computed = XpService.collectFromActivity(
      now: moment,
      statusHistory: activityForXp.statusHistory,
      checklistHistory: activityForXp.checklistHistory,
      cycleProtectedDays: activityForXp.cycleProtectedDays,
      bestPrayerStreak: activityForXp.bestPrayerStreak,
    );
    final events = XpService.merge(
      previous: previousEvents,
      computed: computed,
    );
    final computedXp = XpService.totalXp(events);
    final totalXP =
        computedXp < previousProgress.totalXP ? previousProgress.totalXP : computedXp;
    final level = LevelService.getLevelFromXP(totalXP);

    var journeyStart = previousProgress.journeyStartDate;
    final earliest = AchievementsService.earliestQualifyingDate(activityForXp);
    if (earliest != null) {
      if (journeyStart == null || earliest.isBefore(journeyStart)) {
        journeyStart = earliest;
      }
    }

    final activity = AchievementActivitySnapshot(
      now: moment,
      prayerStreak: activityForXp.prayerStreak,
      bestPrayerStreak: activityForXp.bestPrayerStreak,
      statusHistory: activityForXp.statusHistory,
      checklistHistory: activityForXp.checklistHistory,
      cycleProtectedDays: activityForXp.cycleProtectedDays,
      currentLevel: level.currentLevel,
      journeyStartDate: journeyStart,
    );

    final previouslyUnlocked = previousAchievements
        .where((e) => e.isUnlocked)
        .map((e) => e.id)
        .toSet();
    final achievements = AchievementsService.evaluate(
      previous: previousAchievements,
      activity: activity,
    );
    final newlyUnlocked = achievements
        .where((e) => e.isUnlocked && !previouslyUnlocked.contains(e.id))
        .map((e) => e.id)
        .toList(growable: false);

    final pendingUnlocks = <String>{
      ...previousProgress.pendingUnlockIds,
      ...newlyUnlocked.map((id) => id.storageId),
    }.toList(growable: false);

    final isFirstProgressPersist = previousProgress.updatedAt == null;
    final leveledUp = !isFirstProgressPersist &&
        level.currentLevel > previousProgress.lastCelebratedLevel &&
        level.currentLevel > previousProgress.currentLevel;
    final pendingLevelUp = isFirstProgressPersist
        ? null
        : (leveledUp ? level.currentLevel : previousProgress.pendingLevelUp);

    final previousIds = previousEvents.map((e) => e.sourceId).toSet();
    var xpGained = 0;
    for (final event in events) {
      if (!previousIds.contains(event.sourceId)) xpGained += event.amount;
    }

    final progress = previousProgress.copyWith(
      totalXP: totalXP,
      currentLevel: level.currentLevel,
      journeyStartDate: journeyStart,
      lastCelebratedLevel: isFirstProgressPersist
          ? level.currentLevel
          : previousProgress.lastCelebratedLevel,
      pendingUnlockIds: pendingUnlocks,
      pendingLevelUp: pendingLevelUp,
      updatedAt: moment,
    );

    await AchievementsService.save(achievements);
    await saveEvents(events);
    await saveProgress(progress);

    return ProgressionSnapshot(
      progress: progress,
      level: level,
      achievements: achievements,
      events: events,
      newlyUnlocked: newlyUnlocked,
      xpGained: xpGained,
    );
  }

  static Future<UserProgress> acknowledgeCelebrations(
    UserProgress progress,
  ) async {
    final next = progress.copyWith(
      lastCelebratedLevel: progress.currentLevel,
      pendingUnlockIds: const <String>[],
      clearPendingLevelUp: true,
      updatedAt: DateTime.now(),
    );
    await saveProgress(next);
    return next;
  }
}
