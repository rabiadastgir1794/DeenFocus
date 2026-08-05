import 'dart:convert';

import '../../../core/services/storage_service.dart';
import '../../../l10n/app_localizations.dart';

enum AchievementId {
  firstPrayerStreak,
  sevenPrayerStreak,
  thirtyPrayerStreak,
  fajrWarrior,
  quranReader,
  dhikrMaster,
  consistencyChampion,
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

  bool get isUnlocked => unlockedAt != null || current >= target;
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
        'id': id.name,
        'current': current,
        'target': target,
        'unlockedAt': unlockedAt?.toIso8601String(),
      };

  factory AchievementProgress.fromMap(Map<String, dynamic> map) {
    final id = AchievementId.values.firstWhere(
      (e) => e.name == map['id'],
      orElse: () => AchievementId.firstPrayerStreak,
    );
    return AchievementProgress(
      id: id,
      current: (map['current'] as num?)?.toInt() ?? 0,
      target: (map['target'] as num?)?.toInt() ?? _defaultTarget(id),
      unlockedAt: DateTime.tryParse('${map['unlockedAt'] ?? ''}'),
    );
  }

  static int _defaultTarget(AchievementId id) {
    switch (id) {
      case AchievementId.firstPrayerStreak:
        return 1;
      case AchievementId.sevenPrayerStreak:
        return 7;
      case AchievementId.thirtyPrayerStreak:
        return 30;
      case AchievementId.fajrWarrior:
        return 14;
      case AchievementId.quranReader:
        return 7;
      case AchievementId.dhikrMaster:
        return 30;
      case AchievementId.consistencyChampion:
        return 100;
    }
  }
}

/// Centralized achievement evaluation + persistence.
abstract class AchievementsService {
  static const _storageKey = 'home_achievements_json';

  static List<AchievementProgress> defaults() {
    return AchievementId.values
        .map(
          (id) => AchievementProgress(
            id: id,
            current: 0,
            target: AchievementProgress._defaultTarget(id),
          ),
        )
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

  /// Recompute progress from live app state.
  static List<AchievementProgress> evaluate({
    required List<AchievementProgress> previous,
    required int prayerStreak,
    required int dayStreak,
    required int fajrOnTimeStreak,
    required int quranConsecutiveDays,
    required int dhikrConsecutiveDays,
  }) {
    final now = DateTime.now();
    return previous.map((item) {
      final current = switch (item.id) {
        AchievementId.firstPrayerStreak => prayerStreak.clamp(0, 1),
        AchievementId.sevenPrayerStreak => prayerStreak.clamp(0, 7),
        AchievementId.thirtyPrayerStreak => prayerStreak.clamp(0, 30),
        AchievementId.fajrWarrior => fajrOnTimeStreak.clamp(0, 14),
        AchievementId.quranReader => quranConsecutiveDays.clamp(0, 7),
        AchievementId.dhikrMaster => dhikrConsecutiveDays.clamp(0, 30),
        AchievementId.consistencyChampion => dayStreak.clamp(0, 100),
      };
      final unlocked = item.unlockedAt ??
          (current >= item.target ? now : null);
      return item.copyWith(current: current, unlockedAt: unlocked);
    }).toList(growable: false);
  }

  static String title(AppLocalizations l10n, AchievementId id) {
    switch (id) {
      case AchievementId.firstPrayerStreak:
        return l10n.achievementFirstPrayerStreak;
      case AchievementId.sevenPrayerStreak:
        return l10n.achievementSevenPrayerStreak;
      case AchievementId.thirtyPrayerStreak:
        return l10n.achievementThirtyPrayerStreak;
      case AchievementId.fajrWarrior:
        return l10n.achievementFajrWarrior;
      case AchievementId.quranReader:
        return l10n.achievementQuranReader;
      case AchievementId.dhikrMaster:
        return l10n.achievementDhikrMaster;
      case AchievementId.consistencyChampion:
        return l10n.achievementConsistencyChampion;
    }
  }
}
