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
}
