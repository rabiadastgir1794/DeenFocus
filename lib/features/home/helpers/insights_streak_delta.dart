/// Insights streak chips: only show a real increase from today.
abstract final class InsightsStreakDelta {
  /// Counted salah logged today that extended the current prayer streak.
  /// Null when the chip must stay hidden.
  static int? prayerDeltaToday({
    required int prayerStreak,
    required int todaysCountedPrayers,
    required bool isPausedToday,
  }) {
    if (isPausedToday || prayerStreak <= 0 || todaysCountedPrayers <= 0) {
      return null;
    }
    return todaysCountedPrayers < prayerStreak
        ? todaysCountedPrayers
        : prayerStreak;
  }

  /// Day streak only grows by one when today is a full five-prayer day.
  static bool dayStreakGrewToday({
    required int dayStreak,
    required bool todayFullyCompleted,
    required bool isPausedToday,
  }) {
    return !isPausedToday && dayStreak > 0 && todayFullyCompleted;
  }
}
