import '../model/home_models.dart';
import 'nightly_wrap_up_planner.dart';

/// Calendar-day resolution for the Daily Checklist (`yyyy-MM-dd` local).
abstract final class DailyChecklistDay {
  static String dateKeyFor(DateTime now) => NightlyWrapUpPlanner.dateKeyFor(now);

  /// Returns today's checklist state, resetting when [stored] is from another day.
  ///
  /// Yesterday's history is not modified here — callers persist history separately
  /// on toggles. Incomplete items never carry forward.
  static DailyChecklistState resolveForToday({
    required DailyChecklistState? stored,
    required DateTime now,
  }) {
    final today = dateKeyFor(now);
    if (stored == null || stored.dateKey != today) {
      return DailyChecklistState(
        dateKey: today,
        completedItems: const <DailyChecklistItem>{},
      );
    }
    return stored;
  }

  static bool needsReset({
    required DailyChecklistState current,
    required DateTime now,
  }) {
    return current.dateKey != dateKeyFor(now);
  }

  /// Checklist completeness for wrap-up / progress, excluding mirrored Fajr.
  static bool isHabitIncomplete(Set<DailyChecklistItem> completed) {
    for (final item in DailyChecklistItemX.storedHabits) {
      if (!completed.contains(item)) return true;
    }
    return false;
  }

  static int habitTotalCount() => DailyChecklistItemX.storedHabits.length;

  static int habitCompletedCount(Set<DailyChecklistItem> completed) {
    return DailyChecklistItemX.storedHabits.where(completed.contains).length;
  }

  static int progressTotalCount() =>
      TrackablePrayer.values.length + habitTotalCount();

  static int progressCompletedCount({
    required Set<DailyChecklistItem> checklist,
    required int obligatoryPrayersDone,
  }) {
    return obligatoryPrayersDone.clamp(0, TrackablePrayer.values.length) +
        habitCompletedCount(checklist);
  }
}
