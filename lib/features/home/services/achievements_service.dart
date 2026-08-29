import 'dart:convert';

import '../../../core/services/storage_service.dart';
import '../../../l10n/app_localizations.dart';
import '../model/home_models.dart';
import 'cycle_mode_policy.dart';
import 'level_service.dart';
import 'prayer_analytics_service.dart';

enum AchievementCategory {
  prayer,
  quran,
  dhikr,
  streak,
  protection,
  consistency,
  journey,
  level,
}

/// Stable achievement IDs. Storage uses [storageId] (snake_case).
enum AchievementId {
  firstPrayer,
  sevenPrayerStreak,
  thirtyPrayerStreak,
  fajrWarrior,
  fajrChampion,
  fiveADay,
  perfectWeek,
  perfectMonth,
  quranReader,
  quranDevotee,
  dhikrStarter,
  dhikrMaster,
  nightWorshipper,
  masjidCompanion,
  distractionDefender,
  cycleGuardian,
  protectedMonth,
  consistencyChampion,
  sixMonthJourney,
  deenfocusMaster,
}

extension AchievementIdX on AchievementId {
  String get storageId {
    final buffer = StringBuffer();
    final name = this.name;
    for (var i = 0; i < name.length; i++) {
      final ch = name[i];
      final lower = ch.toLowerCase();
      if (ch != lower && i > 0) buffer.write('_');
      buffer.write(lower);
    }
    return buffer.toString();
  }

  AchievementCategory get category {
    switch (this) {
      case AchievementId.firstPrayer:
      case AchievementId.fajrWarrior:
      case AchievementId.fajrChampion:
      case AchievementId.fiveADay:
      case AchievementId.nightWorshipper:
      case AchievementId.masjidCompanion:
        return AchievementCategory.prayer;
      case AchievementId.sevenPrayerStreak:
      case AchievementId.thirtyPrayerStreak:
      case AchievementId.perfectWeek:
      case AchievementId.perfectMonth:
        return AchievementCategory.streak;
      case AchievementId.quranReader:
      case AchievementId.quranDevotee:
        return AchievementCategory.quran;
      case AchievementId.dhikrStarter:
      case AchievementId.dhikrMaster:
        return AchievementCategory.dhikr;
      case AchievementId.distractionDefender:
      case AchievementId.cycleGuardian:
      case AchievementId.protectedMonth:
        return AchievementCategory.protection;
      case AchievementId.consistencyChampion:
        return AchievementCategory.consistency;
      case AchievementId.sixMonthJourney:
        return AchievementCategory.journey;
      case AchievementId.deenfocusMaster:
        return AchievementCategory.level;
    }
  }

  int get target {
    switch (this) {
      case AchievementId.firstPrayer:
      case AchievementId.fiveADay:
      case AchievementId.deenfocusMaster:
        return 1;
      case AchievementId.sevenPrayerStreak:
      case AchievementId.perfectWeek:
      case AchievementId.quranReader:
      case AchievementId.dhikrStarter:
      case AchievementId.nightWorshipper:
      case AchievementId.masjidCompanion:
      case AchievementId.distractionDefender:
      case AchievementId.cycleGuardian:
        return 7;
      case AchievementId.fajrWarrior:
        return 14;
      case AchievementId.thirtyPrayerStreak:
      case AchievementId.perfectMonth:
      case AchievementId.fajrChampion:
      case AchievementId.quranDevotee:
      case AchievementId.dhikrMaster:
      case AchievementId.protectedMonth:
        return 30;
      case AchievementId.consistencyChampion:
        return 100;
      case AchievementId.sixMonthJourney:
        return 180;
    }
  }

  static AchievementId? parse(String raw) {
    if (raw == 'firstPrayerStreak' || raw == 'first_prayer_streak') {
      return AchievementId.firstPrayer;
    }
    for (final id in AchievementId.values) {
      if (id.name == raw || id.storageId == raw) return id;
    }
    return null;
  }
}

class AchievementProgress {
  const AchievementProgress({
    required this.id,
    required this.current,
    required this.target,
    this.unlockedAt,
  });

  final AchievementId id;
  final int current;
  final int target;
  final DateTime? unlockedAt;

  bool get isUnlocked => unlockedAt != null;
  double get fraction => target <= 0 ? 0 : (current / target).clamp(0.0, 1.0);

  AchievementProgress copyWith({
    int? current,
    int? target,
    DateTime? unlockedAt,
    bool clearUnlocked = false,
  }) {
    return AchievementProgress(
      id: id,
      current: current ?? this.current,
      target: target ?? this.target,
      unlockedAt: clearUnlocked ? null : (unlockedAt ?? this.unlockedAt),
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id.storageId,
    'current': current,
    'target': target,
    'unlockedAt': unlockedAt?.toIso8601String(),
  };

  factory AchievementProgress.fromMap(Map<String, dynamic> map) {
    final id =
        AchievementIdX.parse('${map['id'] ?? ''}') ?? AchievementId.firstPrayer;
    return AchievementProgress(
      id: id,
      current: (map['current'] as num?)?.toInt() ?? 0,
      target: (map['target'] as num?)?.toInt() ?? id.target,
      unlockedAt: DateTime.tryParse('${map['unlockedAt'] ?? ''}'),
    );
  }
}

class UserProgress {
  const UserProgress({
    required this.totalXP,
    required this.currentLevel,
    this.journeyStartDate,
    this.lastCelebratedLevel = 1,
    this.pendingUnlockIds = const <String>[],
    this.pendingLevelUp,
    this.updatedAt,
  });

  factory UserProgress.initial() =>
      const UserProgress(totalXP: 0, currentLevel: 1);

  final int totalXP;
  final int currentLevel;
  final DateTime? journeyStartDate;
  final int lastCelebratedLevel;
  final List<String> pendingUnlockIds;
  final int? pendingLevelUp;
  final DateTime? updatedAt;

  UserProgress copyWith({
    int? totalXP,
    int? currentLevel,
    DateTime? journeyStartDate,
    int? lastCelebratedLevel,
    List<String>? pendingUnlockIds,
    int? pendingLevelUp,
    bool clearPendingLevelUp = false,
    DateTime? updatedAt,
  }) {
    return UserProgress(
      totalXP: totalXP ?? this.totalXP,
      currentLevel: currentLevel ?? this.currentLevel,
      journeyStartDate: journeyStartDate ?? this.journeyStartDate,
      lastCelebratedLevel: lastCelebratedLevel ?? this.lastCelebratedLevel,
      pendingUnlockIds: pendingUnlockIds ?? this.pendingUnlockIds,
      pendingLevelUp: clearPendingLevelUp
          ? null
          : (pendingLevelUp ?? this.pendingLevelUp),
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toMap() => <String, dynamic>{
    'totalXP': totalXP,
    'currentLevel': currentLevel,
    'journeyStartDate': journeyStartDate?.toIso8601String(),
    'lastCelebratedLevel': lastCelebratedLevel,
    'pendingUnlockIds': pendingUnlockIds,
    'pendingLevelUp': pendingLevelUp,
    'updatedAt': updatedAt?.toIso8601String(),
  };

  factory UserProgress.fromMap(Map<String, dynamic> map) {
    final pending = (map['pendingUnlockIds'] as List<dynamic>? ?? const [])
        .map((e) => '$e')
        .where((e) => e.isNotEmpty)
        .toList(growable: false);
    return UserProgress(
      totalXP: (map['totalXP'] as num?)?.toInt() ?? 0,
      currentLevel: (map['currentLevel'] as num?)?.toInt() ?? 1,
      journeyStartDate: DateTime.tryParse('${map['journeyStartDate'] ?? ''}'),
      lastCelebratedLevel: (map['lastCelebratedLevel'] as num?)?.toInt() ?? 1,
      pendingUnlockIds: pending,
      pendingLevelUp: (map['pendingLevelUp'] as num?)?.toInt(),
      updatedAt: DateTime.tryParse('${map['updatedAt'] ?? ''}'),
    );
  }
}

class AchievementActivitySnapshot {
  const AchievementActivitySnapshot({
    required this.now,
    required this.prayerStreak,
    required this.bestPrayerStreak,
    required this.statusHistory,
    required this.checklistHistory,
    required this.cycleProtectedDays,
    required this.currentLevel,
    this.journeyStartDate,
    this.isExcludedProgressDay,
  });

  final DateTime now;
  final int prayerStreak;
  final int bestPrayerStreak;
  final Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory;
  final Map<String, Set<DailyChecklistItem>> checklistHistory;
  final List<DateTime> cycleProtectedDays;
  final int currentLevel;
  final DateTime? journeyStartDate;

  /// From [CycleModePolicy.shouldExcludeFromPrayerProgress] — Cycle Mode days
  /// must not count toward prayer-related achievement progress.
  final bool Function(DateTime date)? isExcludedProgressDay;
}

/// Centralized achievement evaluation + persistence.
abstract class AchievementsService {
  static const _storageKey = 'home_achievements_json';
  static const totalCount = 20;

  static const _dhikrItems = <DailyChecklistItem>[
    DailyChecklistItem.morningAdhkar,
    DailyChecklistItem.eveningAdhkar,
    DailyChecklistItem.dhikr,
    DailyChecklistItem.istighfar,
    DailyChecklistItem.salawat,
  ];

  static List<AchievementProgress> defaults() {
    return AchievementId.values
        .map((id) => AchievementProgress(id: id, current: 0, target: id.target))
        .toList(growable: false);
  }

  static Future<List<AchievementProgress>> load() async {
    final raw = await StorageService.getString(_storageKey);
    if (raw == null || raw.isEmpty) return defaults();
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      final byId = <AchievementId, AchievementProgress>{};
      for (final row in list) {
        final item = AchievementProgress.fromMap(
          Map<String, dynamic>.from(row as Map),
        );
        byId[item.id] = item;
      }
      return AchievementId.values
          .map((id) => byId[id] ?? defaults().firstWhere((e) => e.id == id))
          .toList(growable: false);
    } catch (_) {
      return defaults();
    }
  }

  static Future<void> save(List<AchievementProgress> items) async {
    await StorageService.setString(
      _storageKey,
      jsonEncode(items.map((e) => e.toMap()).toList()),
    );
  }

  static int unlockedCount(List<AchievementProgress> items) =>
      items.where((e) => e.isUnlocked).length;

  /// Recompute progress from live app state. Never clears an unlock.
  static List<AchievementProgress> evaluate({
    required List<AchievementProgress> previous,
    required AchievementActivitySnapshot activity,
  }) {
    final now = activity.now;
    final byId = <AchievementId, AchievementProgress>{
      for (final item in previous) item.id: item,
    };
    return AchievementId.values
        .map((id) {
          final previousItem =
              byId[id] ??
              AchievementProgress(id: id, current: 0, target: id.target);
          final current = progressFor(id, activity).clamp(0, id.target);
          final unlockedAt =
              previousItem.unlockedAt ?? (current >= id.target ? now : null);
          return previousItem.copyWith(
            current: current,
            target: id.target,
            unlockedAt: unlockedAt,
          );
        })
        .toList(growable: false);
  }

  static int progressFor(
    AchievementId id,
    AchievementActivitySnapshot activity,
  ) {
    switch (id) {
      case AchievementId.firstPrayer:
        return _hasAnyCountedPrayer(activity) ? 1 : 0;
      case AchievementId.sevenPrayerStreak:
        return _streakProgress(activity, 7);
      case AchievementId.thirtyPrayerStreak:
        return _streakProgress(activity, 30);
      case AchievementId.fajrWarrior:
        return _uniqueFajrDays(activity).clamp(0, 14);
      case AchievementId.fajrChampion:
        return _uniqueFajrDays(activity).clamp(0, 30);
      case AchievementId.fiveADay:
        return _perfectDayCount(activity) >= 1 ? 1 : 0;
      case AchievementId.perfectWeek:
        return _longestPerfectStreak(activity).clamp(0, 7);
      case AchievementId.perfectMonth:
        return _longestPerfectStreak(activity).clamp(0, 30);
      case AchievementId.quranReader:
        return _uniqueChecklistDays(
          activity.checklistHistory,
          const <DailyChecklistItem>[DailyChecklistItem.quran],
        ).clamp(0, 7);
      case AchievementId.quranDevotee:
        return _uniqueChecklistDays(
          activity.checklistHistory,
          const <DailyChecklistItem>[DailyChecklistItem.quran],
        ).clamp(0, 30);
      case AchievementId.dhikrStarter:
        return _uniqueChecklistDays(
          activity.checklistHistory,
          _dhikrItems,
        ).clamp(0, 7);
      case AchievementId.dhikrMaster:
        return _uniqueChecklistDays(
          activity.checklistHistory,
          _dhikrItems,
        ).clamp(0, 30);
      case AchievementId.nightWorshipper:
        return _uniqueChecklistDays(
          activity.checklistHistory,
          const <DailyChecklistItem>[DailyChecklistItem.tahajjud],
        ).clamp(0, 7);
      case AchievementId.masjidCompanion:
        // No reliable masjid-visit event exists yet — never fake progress.
        return 0;
      case AchievementId.distractionDefender:
        return _uniqueChecklistDays(
          activity.checklistHistory,
          const <DailyChecklistItem>[
            DailyChecklistItem.noMusicToday,
            DailyChecklistItem.noSocialMediaBeforeIsha,
            DailyChecklistItem.controlAngerSpeakKindly,
          ],
        ).clamp(0, 7);
      case AchievementId.cycleGuardian:
        return activity.cycleProtectedDays.length.clamp(0, 7);
      case AchievementId.protectedMonth:
        return activity.cycleProtectedDays.length.clamp(0, 30);
      case AchievementId.consistencyChampion:
        return uniqueQualifyingDays(activity).length.clamp(0, 100);
      case AchievementId.sixMonthJourney:
        return _sixMonthProgress(activity).clamp(0, 180);
      case AchievementId.deenfocusMaster:
        return activity.currentLevel >= LevelService.maxLevel ? 1 : 0;
    }
  }

  static int _streakProgress(AchievementActivitySnapshot activity, int cap) {
    final best = activity.bestPrayerStreak > activity.prayerStreak
        ? activity.bestPrayerStreak
        : activity.prayerStreak;
    return best.clamp(0, cap);
  }

  static bool _isExcludedDayKey(
    AchievementActivitySnapshot activity,
    String key,
  ) {
    final excluded = activity.isExcludedProgressDay;
    if (excluded == null) return false;
    final parsed = DateTime.tryParse(key);
    if (parsed == null) return false;
    return excluded(DateTime(parsed.year, parsed.month, parsed.day));
  }

  static bool _hasAnyCountedPrayer(AchievementActivitySnapshot activity) {
    for (final entry in activity.statusHistory.entries) {
      if (_isExcludedDayKey(activity, entry.key)) continue;
      for (final status in entry.value.values) {
        if (PrayerAnalyticsService.countsForPrayerStreak(status)) return true;
      }
    }
    return false;
  }

  static int _uniqueFajrDays(AchievementActivitySnapshot activity) {
    var count = 0;
    for (final entry in activity.statusHistory.entries) {
      if (_isExcludedDayKey(activity, entry.key)) continue;
      final fajr = entry.value[TrackablePrayer.fajr] ?? PrayerMarkStatus.none;
      if (PrayerAnalyticsService.countsForPrayerStreak(fajr)) count += 1;
    }
    return count;
  }

  static bool _isPerfectDay(Map<TrackablePrayer, PrayerMarkStatus> day) {
    for (final prayer in TrackablePrayer.values) {
      final status = day[prayer] ?? PrayerMarkStatus.none;
      if (!PrayerAnalyticsService.countsForPrayerStreak(status)) return false;
    }
    return true;
  }

  static int _perfectDayCount(AchievementActivitySnapshot activity) {
    var count = 0;
    for (final entry in activity.statusHistory.entries) {
      if (_isExcludedDayKey(activity, entry.key)) continue;
      if (_isPerfectDay(entry.value)) count += 1;
    }
    return count;
  }

  static int _longestPerfectStreak(AchievementActivitySnapshot activity) {
    final days = <DateTime>[];
    for (final entry in activity.statusHistory.entries) {
      if (_isExcludedDayKey(activity, entry.key)) continue;
      final parsed = DateTime.tryParse(entry.key);
      if (parsed == null) continue;
      if (_isPerfectDay(entry.value)) {
        days.add(DateTime(parsed.year, parsed.month, parsed.day));
      }
    }
    if (days.isEmpty) return 0;
    days.sort();
    var longest = 1;
    var run = 1;
    for (var i = 1; i < days.length; i++) {
      final gap = days[i].difference(days[i - 1]).inDays;
      if (gap == 1) {
        run += 1;
        if (run > longest) longest = run;
      } else if (gap != 0) {
        run = 1;
      }
    }
    return longest;
  }

  static int _uniqueChecklistDays(
    Map<String, Set<DailyChecklistItem>> history,
    List<DailyChecklistItem> anyOf,
  ) {
    var count = 0;
    for (final items in history.values) {
      if (anyOf.any(items.contains)) count += 1;
    }
    return count;
  }

  static Set<String> uniqueQualifyingDays(
    AchievementActivitySnapshot activity,
  ) {
    final days = <String>{};
    for (final entry in activity.statusHistory.entries) {
      if (_isExcludedDayKey(activity, entry.key)) continue;
      final counted = entry.value.values.any(
        PrayerAnalyticsService.countsForPrayerStreak,
      );
      if (counted) days.add(entry.key);
    }
    for (final entry in activity.checklistHistory.entries) {
      final items = entry.value;
      if (items.contains(DailyChecklistItem.quran) ||
          items.contains(DailyChecklistItem.tahajjud) ||
          _dhikrItems.any(items.contains)) {
        days.add(entry.key);
      }
    }
    return days;
  }

  static DateTime? earliestQualifyingDate(
    AchievementActivitySnapshot activity,
  ) {
    DateTime? earliest;
    for (final key in uniqueQualifyingDays(activity)) {
      final parsed = DateTime.tryParse(key);
      if (parsed == null) continue;
      final day = DateTime(parsed.year, parsed.month, parsed.day);
      if (earliest == null || day.isBefore(earliest)) earliest = day;
    }
    return earliest;
  }

  static int _sixMonthProgress(AchievementActivitySnapshot activity) {
    final qualifying = uniqueQualifyingDays(activity);
    if (qualifying.isEmpty) return 0;
    final start = activity.journeyStartDate ?? earliestQualifyingDate(activity);
    if (start == null) return 0;
    final today = DateTime(
      activity.now.year,
      activity.now.month,
      activity.now.day,
    );
    final origin = DateTime(start.year, start.month, start.day);
    final days = today.difference(origin).inDays;
    return days < 0 ? 0 : days;
  }

  static List<DateTime> protectedDaysUntilToday({
    required CycleModePolicy policy,
    required DateTime now,
  }) {
    final today = DateTime(now.year, now.month, now.day);
    final seen = <String>{};
    final days = <DateTime>[];
    for (final interval in policy.data.effectiveIntervals) {
      if (!interval.pauseStreaks) continue;
      var cursor = interval.startDate;
      while (!cursor.isAfter(interval.endDate) && !cursor.isAfter(today)) {
        final key = PrayerAnalyticsService.dayKey(cursor);
        if (seen.add(key)) {
          days.add(DateTime(cursor.year, cursor.month, cursor.day));
        }
        cursor = cursor.add(const Duration(days: 1));
      }
    }
    return days;
  }

  static String title(AppLocalizations l10n, AchievementId id) {
    switch (id) {
      case AchievementId.firstPrayer:
        return l10n.achievementFirstPrayer;
      case AchievementId.sevenPrayerStreak:
        return l10n.achievementSevenPrayerStreak;
      case AchievementId.thirtyPrayerStreak:
        return l10n.achievementThirtyPrayerStreak;
      case AchievementId.fajrWarrior:
        return l10n.achievementFajrWarrior;
      case AchievementId.fajrChampion:
        return l10n.achievementFajrChampion;
      case AchievementId.fiveADay:
        return l10n.achievementFiveADay;
      case AchievementId.perfectWeek:
        return l10n.achievementPerfectWeek;
      case AchievementId.perfectMonth:
        return l10n.achievementPerfectMonth;
      case AchievementId.quranReader:
        return l10n.achievementQuranReader;
      case AchievementId.quranDevotee:
        return l10n.achievementQuranDevotee;
      case AchievementId.dhikrStarter:
        return l10n.achievementDhikrStarter;
      case AchievementId.dhikrMaster:
        return l10n.achievementDhikrMaster;
      case AchievementId.nightWorshipper:
        return l10n.achievementNightWorshipper;
      case AchievementId.masjidCompanion:
        return l10n.achievementMasjidCompanion;
      case AchievementId.distractionDefender:
        return l10n.achievementDistractionDefender;
      case AchievementId.cycleGuardian:
        return l10n.achievementCycleGuardian;
      case AchievementId.protectedMonth:
        return l10n.achievementProtectedMonth;
      case AchievementId.consistencyChampion:
        return l10n.achievementConsistencyChampion;
      case AchievementId.sixMonthJourney:
        return l10n.achievementSixMonthJourney;
      case AchievementId.deenfocusMaster:
        return l10n.achievementDeenFocusMaster;
    }
  }

  static String description(AppLocalizations l10n, AchievementId id) {
    switch (id) {
      case AchievementId.firstPrayer:
        return l10n.achievementDescFirstPrayer;
      case AchievementId.sevenPrayerStreak:
        return l10n.achievementDescSevenPrayerStreak;
      case AchievementId.thirtyPrayerStreak:
        return l10n.achievementDescThirtyPrayerStreak;
      case AchievementId.fajrWarrior:
        return l10n.achievementDescFajrWarrior;
      case AchievementId.fajrChampion:
        return l10n.achievementDescFajrChampion;
      case AchievementId.fiveADay:
        return l10n.achievementDescFiveADay;
      case AchievementId.perfectWeek:
        return l10n.achievementDescPerfectWeek;
      case AchievementId.perfectMonth:
        return l10n.achievementDescPerfectMonth;
      case AchievementId.quranReader:
        return l10n.achievementDescQuranReader;
      case AchievementId.quranDevotee:
        return l10n.achievementDescQuranDevotee;
      case AchievementId.dhikrStarter:
        return l10n.achievementDescDhikrStarter;
      case AchievementId.dhikrMaster:
        return l10n.achievementDescDhikrMaster;
      case AchievementId.nightWorshipper:
        return l10n.achievementDescNightWorshipper;
      case AchievementId.masjidCompanion:
        return l10n.achievementDescMasjidCompanion;
      case AchievementId.distractionDefender:
        return l10n.achievementDescDistractionDefender;
      case AchievementId.cycleGuardian:
        return l10n.achievementDescCycleGuardian;
      case AchievementId.protectedMonth:
        return l10n.achievementDescProtectedMonth;
      case AchievementId.consistencyChampion:
        return l10n.achievementDescConsistencyChampion;
      case AchievementId.sixMonthJourney:
        return l10n.achievementDescSixMonthJourney;
      case AchievementId.deenfocusMaster:
        return l10n.achievementDescDeenFocusMaster;
    }
  }
}
