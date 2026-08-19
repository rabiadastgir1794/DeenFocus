/// Pure eligibility rules for the automatic in-app review prompt.
///
/// Manual Settings → Rate is not gated by these rules.
abstract class AppReviewPolicy {
  static const int minSessions = 3;
  static const int minCompletedPrayers = 3;
  static const int maxAutomaticPerYear = 3;
  static const Duration cooldown = Duration(days: 30);
  static const Duration sessionGap = Duration(minutes: 30);
  static const Duration year = Duration(days: 365);

  static bool shouldStartNewSession({
    required DateTime now,
    DateTime? lastSessionAt,
  }) {
    if (lastSessionAt == null) return true;
    return !now.difference(lastSessionAt).isNegative &&
        now.difference(lastSessionAt) >= sessionGap;
  }

  static int sessionCountAfterRecording({
    required int currentCount,
    required bool startedNewSession,
  }) {
    final safe = currentCount < 0 ? 0 : currentCount;
    if (!startedNewSession) return safe;
    return safe + 1;
  }

  static List<DateTime> promptsWithinYear({
    required List<DateTime> timestamps,
    required DateTime now,
  }) {
    return timestamps
        .where((stamp) => now.difference(stamp) < year && !stamp.isAfter(now))
        .toList(growable: false);
  }

  static bool isAutomaticEligible({
    required int sessionCount,
    required int completedPrayers,
    required bool hasUnlockedAchievement,
    required DateTime now,
    DateTime? lastAutomaticPromptAt,
    List<DateTime> automaticPromptAt = const <DateTime>[],
    bool celebrationsBlocking = false,
  }) {
    if (celebrationsBlocking) return false;
    if (sessionCount < minSessions) return false;
    if (completedPrayers < minCompletedPrayers) return false;
    if (!hasUnlockedAchievement) return false;
    if (lastAutomaticPromptAt != null &&
        now.difference(lastAutomaticPromptAt) < cooldown) {
      return false;
    }
    final recent = promptsWithinYear(timestamps: automaticPromptAt, now: now);
    if (recent.length >= maxAutomaticPerYear) return false;
    return true;
  }
}
