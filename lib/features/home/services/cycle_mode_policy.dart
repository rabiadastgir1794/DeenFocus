import '../model/home_models.dart';

/// Single source of truth for all Cycle Mode rules.
///
/// Storage holds [CycleModeData]; analytics and UI read [CycleModePolicy] only.
/// Widgets must never branch on cycle dates — use [HomeTabViewModel] getters.
class CycleModePolicy {
  const CycleModePolicy(this.data);

  final CycleModeData data;

  static DateTime _day(DateTime date) => CycleModeData.dateOnly(date);

  bool get isActive => data.isEnabled;
  CycleModePhase get phase => data.phase;

  /// Toggle ON **and** [now] is inside the configured active window.
  bool isRunningOn(DateTime now) => data.isRunningOn(now);

  int daysRemaining({DateTime? now}) =>
      data.daysRemainingOn(now ?? DateTime.now());

  /// Active window or sealed history (never draft-only dates).
  bool isCycleMember(DateTime date) => data.containsDate(_day(date));

  bool _activeWindowHasStarted(DateTime referenceDay) =>
      !_day(referenceDay).isBefore(_day(data.startDate));

  /// Streak pause applies only to cycle days on or before [referenceDay], once
  /// the active window has started.
  bool _appliesActiveWindowStreakRules(
    DateTime date,
    DateTime referenceDay,
  ) {
    final day = _day(date);
    final today = _day(referenceDay);
    final active = data.activeInterval;
    if (active == null || !active.containsDate(day)) return false;
    if (!_activeWindowHasStarted(today)) return false;
    if (day.isAfter(today)) return false;
    return true;
  }

  /// Stats exclusion applies to every day in the active window once the cycle
  /// has started — including future in-window days (weekly denominators).
  bool _appliesActiveWindowStatsRules(
    DateTime date,
    DateTime referenceDay,
  ) {
    final day = _day(date);
    final active = data.activeInterval;
    if (active == null || !active.containsDate(day)) return false;
    if (!_activeWindowHasStarted(_day(referenceDay))) return false;
    return true;
  }

  bool _appliesIntervalRules(
    DateTime date, {
    DateTime? now,
    required bool Function(CycleModeInterval interval) pick,
    required bool Function(DateTime day, DateTime reference) appliesActiveWindow,
  }) {
    final day = _day(date);
    final reference = _day(now ?? DateTime.now());

    for (final interval in data.history) {
      if (interval.containsDate(day)) {
        return pick(interval);
      }
    }

    final active = data.activeInterval;
    if (active != null && active.containsDate(day)) {
      return appliesActiveWindow(day, reference) && pick(active);
    }
    return false;
  }

  /// Pink highlight — **toggle must be ON** (intentional product rule).
  ///
  /// When the toggle is OFF, nothing is pink — including sealed historical days.
  /// History still drives streaks / stats via [isCycleMember]; only UI colour
  /// is suppressed so draft/historical states look inactive.
  ///
  /// When ON:
  /// * Active window: every day start → planned end once the cycle has started
  ///   (future days inside the window count, e.g. Aug 1–2 when today is Aug 1).
  /// * Historical: sealed days ≤ today (shown while a new cycle is active).
  bool isHighlightable(DateTime date, {DateTime? now}) {
    if (!data.isEnabled) return false;

    final day = _day(date);
    final today = _day(now ?? DateTime.now());

    if (_isActiveWindowHighlight(day, today)) return true;

    for (final interval in data.history) {
      if (interval.containsDate(day) && !day.isAfter(today)) {
        return true;
      }
    }
    return false;
  }

  /// Every calendar day in the configured active window, inclusive, once the
  /// cycle has started — including today and future days still inside the window.
  bool _isActiveWindowHighlight(DateTime day, DateTime today) {
    final active = data.activeInterval;
    if (active == null) return false;
    if (today.isBefore(_day(data.startDate))) return false;
    if (today.isAfter(_day(data.plannedEndDate))) return false;
    return active.containsDate(day);
  }

  /// Prayer / day / Fajr streaks — bridge only (zero contribution).
  bool shouldPauseStreaks(DateTime date, {DateTime? now}) =>
      _appliesIntervalRules(
        date,
        now: now,
        pick: (interval) => interval.pauseStreaks,
        appliesActiveWindow: _appliesActiveWindowStreakRules,
      );

  /// Weekly / monthly charts, prayer rate, Home/Insights bars.
  bool shouldExcludeFromStatistics(DateTime date, {DateTime? now}) =>
      _appliesIntervalRules(
        date,
        now: now,
        pick: (interval) => interval.excludeFromStatistics,
        appliesActiveWindow: _appliesActiveWindowStatsRules,
      );

  /// Prayer XP and prayer-related achievement day counters.
  ///
  /// Same membership as [shouldExcludeFromStatistics] so progress surfaces
  /// stay consistent with Insights completion %.
  bool shouldExcludeFromPrayerProgress(DateTime date, {DateTime? now}) =>
      shouldExcludeFromStatistics(date, now: now);

  /// Restore must not repair breaks that fall on paused cycle days.
  bool shouldAllowRestore(DateTime date, {DateTime? now}) =>
      !shouldPauseStreaks(date, now: now);

  /// Today is inside an active cycle window (for protected UI copy).
  bool isTodayProtected({DateTime? now}) => isRunningOn(now ?? DateTime.now());

  /// Focus score prayer component is protected while Cycle Mode is running.
  bool protectsFocusScore({DateTime? now}) => isRunningOn(now ?? DateTime.now());
}
