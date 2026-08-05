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

  int daysRemaining({DateTime? now}) =>
      data.daysRemainingOn(now ?? DateTime.now());

  /// Active window or sealed history (never draft-only dates).
  bool isCycleMember(DateTime date) => data.containsDate(_day(date));

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
    return active.containsDate(day);
  }

  /// Prayer / day / Fajr streaks and achievements.
  bool shouldPauseStreaks(DateTime date) =>
      data.intervalFor(_day(date))?.pauseStreaks ?? false;

  /// Weekly / monthly charts, prayer rate, focus denominators.
  bool shouldExcludeFromStatistics(DateTime date) =>
      data.intervalFor(_day(date))?.excludeFromStatistics ?? false;

  /// Restore must not repair breaks that fall on paused cycle days.
  bool shouldAllowRestore(DateTime date) => !shouldPauseStreaks(date);

  /// Today is inside an active cycle window (for protected UI copy).
  bool isTodayProtected({DateTime? now}) {
    if (!data.isEnabled) return false;
    return isCycleMember(now ?? DateTime.now());
  }

  /// Focus score prayer component is protected on any cycle member day.
  bool protectsFocusScore({DateTime? now}) =>
      isCycleMember(now ?? DateTime.now());
}
