/// Central XP → level calculator. Exactly 15 levels; never exceeds 15.
abstract class LevelService {
  static const int maxLevel = 15;
  static const int masterXp = 6400;

  /// Inclusive XP threshold at which [level] begins.
  static const List<int> xpThresholds = <int>[
    0, // 1 New Beginning
    100, // 2 Getting Started
    250, // 3 Building the Habit
    450, // 4 Steady Worshipper
    700, // 5 Consistent Heart
    1000, // 6 Prayer Keeper
    1400, // 7 Dedicated Servant
    1850, // 8 Strong Routine
    2350, // 9 Devoted Worshipper
    2900, // 10 Steadfast
    3500, // 11 Deepening Faith
    4150, // 12 Strong Consistency
    4850, // 13 Devotion Leader
    5600, // 14 Exceptional Consistency
    6400, // 15 DeenFocus Master
  ];

  static const List<String> englishNames = <String>[
    'New Beginning',
    'Getting Started',
    'Building the Habit',
    'Steady Worshipper',
    'Consistent Heart',
    'Prayer Keeper',
    'Dedicated Servant',
    'Strong Routine',
    'Devoted Worshipper',
    'Steadfast',
    'Deepening Faith',
    'Strong Consistency',
    'Devotion Leader',
    'Exceptional Consistency',
    'DeenFocus Master',
  ];

  static int getXPRequiredForLevel(int level) {
    final clamped = level.clamp(1, maxLevel);
    return xpThresholds[clamped - 1];
  }

  static int? getNextLevel(int level) {
    if (level >= maxLevel) return null;
    return level + 1;
  }

  static LevelProgress getLevelFromXP(int totalXP) {
    final xp = totalXP < 0 ? 0 : totalXP;
    var level = 1;
    for (var i = xpThresholds.length - 1; i >= 0; i--) {
      if (xp >= xpThresholds[i]) {
        level = i + 1;
        break;
      }
    }
    if (level > maxLevel) level = maxLevel;
    final currentLevelXP = xpThresholds[level - 1];
    final isMaxLevel = level >= maxLevel;
    final nextLevelXP = isMaxLevel ? null : xpThresholds[level];
    final span = isMaxLevel ? 1 : (nextLevelXP! - currentLevelXP);
    final progressXP = isMaxLevel ? 0 : (xp - currentLevelXP).clamp(0, span);
    final progressPercentage = isMaxLevel
        ? 1.0
        : span <= 0
        ? 1.0
        : (progressXP / span).clamp(0.0, 1.0);
    return LevelProgress(
      totalXP: xp,
      currentLevel: level,
      currentLevelXP: currentLevelXP,
      nextLevelXP: nextLevelXP,
      progressXP: progressXP,
      progressPercentage: progressPercentage,
      isMaxLevel: isMaxLevel,
      xpToNext: isMaxLevel ? 0 : (nextLevelXP! - xp).clamp(0, span),
      xpSpan: isMaxLevel ? 0 : span,
      name: englishNames[level - 1],
    );
  }
}

class LevelProgress {
  const LevelProgress({
    required this.totalXP,
    required this.currentLevel,
    required this.currentLevelXP,
    required this.nextLevelXP,
    required this.progressXP,
    required this.progressPercentage,
    required this.isMaxLevel,
    required this.xpToNext,
    required this.xpSpan,
    required this.name,
  });

  final int totalXP;
  final int currentLevel;
  final int currentLevelXP;
  final int? nextLevelXP;
  final int progressXP;
  final double progressPercentage;
  final bool isMaxLevel;
  final int xpToNext;
  /// XP needed to finish the current level (next threshold − this level's start).
  final int xpSpan;
  final String name;
}
