import 'package:intl/intl.dart';

import '../helpers/home_prayer_times_helper.dart';
import '../model/home_models.dart';

/// Immutable analytics snapshot — Home, Insights, popups, and achievements
/// must all read these values (never mutate streaks in the UI).
class PrayerAnalyticsSnapshot {
  const PrayerAnalyticsSnapshot({
    required this.prayerStreak,
    required this.dayStreak,
    required this.weeklyCompleted,
    required this.weeklyPossible,
    required this.monthlyCompleted,
    required this.monthlyPossible,
    required this.prayerRatePercent,
    required this.weekDayCounts,
    required this.monthWeekBuckets,
    required this.homeWeekDayCounts,
    this.restoreTarget,
  });

  final int prayerStreak;
  final int dayStreak;
  final int weeklyCompleted;
  final int weeklyPossible;
  final int monthlyCompleted;
  final int monthlyPossible;
  final int prayerRatePercent;
  final List<int> weekDayCounts;
  final List<int> homeWeekDayCounts;
  final List<({String label, int completed, int possible})> monthWeekBuckets;

  /// Most recent break that can be restored (within 24h), if any.
  final RestoreTarget? restoreTarget;

  bool get canRestoreStreak => restoreTarget != null;

  int get weeklyRatePercent => weeklyPossible == 0
      ? 0
      : ((weeklyCompleted / weeklyPossible) * 100).round().clamp(0, 100);

  int get monthlyRatePercent => monthlyPossible == 0
      ? 0
      : ((monthlyCompleted / monthlyPossible) * 100).round().clamp(0, 100);
}

/// A single prayer slot that broke the streak and may be restored.
class RestoreTarget {
  const RestoreTarget({
    required this.date,
    required this.dateKey,
    required this.prayer,
  });

  final DateTime date;
  final String dateKey;
  final TrackablePrayer prayer;
}

/// Single source of truth for prayer analytics.
///
/// UI / ViewModels must only call [calculate] / [RestoreCalculator.apply] —
/// never increment streak counters locally.
abstract class PrayerAnalyticsService {
  static final DateFormat dayKeyFormat = DateFormat('yyyy-MM-dd');
  static const prayersPerDay = 5;
  static const weeklyPossible = 35;
  static const restoreWindow = Duration(hours: 24);

  static String dayKey(DateTime date) => dayKeyFormat.format(date);

  /// On Time and Qadha both count — no separate streak rules between them.
  static bool countsForPrayerStreak(PrayerMarkStatus status) =>
      status == PrayerMarkStatus.onTime || status == PrayerMarkStatus.qada;

  static PrayerAnalyticsSnapshot calculate({
    required DateTime now,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
    bool Function(DateTime date)? isCycleDay,
    bool Function(DateTime date)? isPausedStreakDay,
    bool Function(DateTime date)? isExcludedStatsDay,
    bool pauseStreaks = true,
    bool excludeFromStatistics = true,
    DateTime? Function(TrackablePrayer prayer)? prayerStartTime,
  }) {
    // Prefer explicit policy callbacks (per-interval Cycle Mode history).
    // Legacy tests may pass [isCycleDay] + bool flags instead.
    bool isPausedDay(DateTime d) =>
        isPausedStreakDay?.call(d) ??
        (pauseStreaks && (isCycleDay?.call(d) ?? false));
    bool isExcludedDay(DateTime d) =>
        isExcludedStatsDay?.call(d) ??
        (excludeFromStatistics && (isCycleDay?.call(d) ?? false));

    final prayerStreak = PrayerStreakCalculator.calculate(
      now: now,
      statusHistory: statusHistory,
      isCycleDay: isPausedDay,
      prayerStartTime: prayerStartTime,
    );
    final dayStreak = DayStreakCalculator.calculate(
      now: now,
      statusHistory: statusHistory,
      isCycleDay: isPausedDay,
    );
    final weekly = WeeklyCalculator.calculate(
      now: now,
      statusHistory: statusHistory,
      isCycleDay: isExcludedDay,
    );
    final monthly = MonthlyCalculator.calculate(
      now: now,
      statusHistory: statusHistory,
      isCycleDay: isExcludedDay,
    );
    final rate = PrayerRateCalculator.calculate(
      now: now,
      statusHistory: statusHistory,
      isCycleDay: isExcludedDay,
    );
    final weekDates = WeeklyCalculator.insightsWeekDates(now);
    final weekDayCounts = [
      for (final d in weekDates)
        WeeklyCalculator.completedCountOnDate(d, statusHistory, isExcludedDay),
    ];
    final homeWeekDates = WeeklyCalculator.mondayWeekDates(now);
    final homeWeekDayCounts = [
      for (final d in homeWeekDates)
        WeeklyCalculator.completedCountOnDate(d, statusHistory, isExcludedDay),
    ];

    return PrayerAnalyticsSnapshot(
      prayerStreak: prayerStreak,
      dayStreak: dayStreak,
      weeklyCompleted: weekly.completed,
      weeklyPossible: weekly.possible,
      monthlyCompleted: monthly.completed,
      monthlyPossible: monthly.possible,
      prayerRatePercent: rate,
      weekDayCounts: weekDayCounts,
      homeWeekDayCounts: homeWeekDayCounts,
      monthWeekBuckets: MonthlyCalculator.weekBuckets(
        now,
        statusHistory,
        isExcludedDay,
      ),
      restoreTarget: RestoreCalculator.findTarget(
        now: now,
        statusHistory: statusHistory,
        isCycleDay: isPausedDay,
        prayerStartTime: prayerStartTime,
      ),
    );
  }

  static TrackablePrayer? mostRecentStartedPrayer({
    required DateTime now,
    required DateTime? Function(TrackablePrayer prayer) prayerStartTime,
  }) {
    for (final prayer in TrackablePrayer.values.reversed) {
      final start = prayerStartTime(prayer);
      if (start != null &&
          HomePrayerTimesHelper.hasStartedOnDay(start, now)) {
        return prayer;
      }
    }
    return null;
  }

  static DateTime? slotDateTime({
    required DateTime day,
    required TrackablePrayer prayer,
    required DateTime now,
    DateTime? Function(TrackablePrayer prayer)? prayerStartTime,
  }) {
    final today = DateTime(now.year, now.month, now.day);
    final normalized = DateTime(day.year, day.month, day.day);
    if (normalized == today && prayerStartTime != null) {
      final start = prayerStartTime(prayer);
      if (start != null) {
        return HomePrayerTimesHelper.atDay(today, start);
      }
    }
    final index = TrackablePrayer.values.indexOf(prayer);
    const hours = [5, 12, 15, 18, 20];
    final start = prayerStartTime?.call(prayer);
    if (start != null) {
      return DateTime(
        day.year,
        day.month,
        day.day,
        start.hour,
        start.minute,
      );
    }
    return DateTime(day.year, day.month, day.day, hours[index]);
  }
}

/// Consecutive individual prayer slots (not days).
///
/// Rules:
/// * [PrayerMarkStatus.onTime] and [PrayerMarkStatus.qada] both count.
/// * Explicit [PrayerMarkStatus.missed] at the tip → streak 0.
/// * Unmarked slots are not a miss: skip them until a logged prayer or an
///   explicit Missed. So the first On Time/Qada always adds 1, even when a
///   later prayer has already started (home sheet, popup, or alarm).
/// * Upcoming (not started, unmarked) slots are ignored — they never break
///   the streak.
/// * Paused Cycle Mode days ([isCycleDay]) bridge the tip chain:
///   - Missed / unmarked slots on paused days never tip-break.
///   - When an older non-paused tip exists, pause-day marks are skipped so they
///     neither inflate nor break a pre-cycle streak.
///   - When the tip lives only on paused day(s), counting marks there are kept
///     so Cycle Mode never resets the streak — and after Cycle Mode ends those
///     marks still continue the chain behind new On Time/Qadha.
abstract class PrayerStreakCalculator {
  static int calculate({
    required DateTime now,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
    required bool Function(DateTime date) isCycleDay,
    DateTime? Function(TrackablePrayer prayer)? prayerStartTime,
  }) {
    var streak = 0;
    var foundTip = false;
    final today = DateTime(now.year, now.month, now.day);
    final order = TrackablePrayer.values;
    // First calendar day after a paused Cycle Mode window: do not tip-break on
    // started-but-unmarked slots. Cycle days are exempt (she does not pray), so
    // the preserved streak must remain until she marks On Time/Qadha or Missed.
    final softBridgeUnmarkedToday = _previousCalendarDayIsPaused(
      today,
      isCycleDay,
    );

    for (var dayOffset = 0; dayOffset < 400; dayOffset++) {
      final date = today.subtract(Duration(days: dayOffset));
      final paused = isCycleDay(date);

      if (paused) {
        // Prefer the older non-paused tip so pause-day marks do not inflate.
        if (_nonPausedTipExists(
          fromDayOffset: dayOffset + 1,
          today: today,
          now: now,
          statusHistory: statusHistory,
          isCycleDay: isCycleDay,
          prayerStartTime: prayerStartTime,
        )) {
          continue;
        }
        // No older non-paused tip — counting marks preserve / continue the tip.
      }

      final statuses = statusHistory[PrayerAnalyticsService.dayKey(date)] ??
          const <TrackablePrayer, PrayerMarkStatus>{};

      final slots = <PrayerMarkStatus>[];
      if (dayOffset == 0) {
        for (var i = 0; i < order.length; i++) {
          final prayer = order[i];
          final status = statuses[prayer] ?? PrayerMarkStatus.none;
          final started = _hasStarted(
            now: now,
            prayer: prayer,
            prayerStartTime: prayerStartTime,
            slotIndex: i,
          );
          if (!started && status == PrayerMarkStatus.none) break;
          if (paused) {
            if (PrayerAnalyticsService.countsForPrayerStreak(status)) {
              slots.add(status);
            }
          } else if (softBridgeUnmarkedToday &&
              status == PrayerMarkStatus.none) {
            // Returning from Cycle Mode — unmarked ≠ missed.
            continue;
          } else {
            slots.add(status);
          }
        }
        _dropTrailingUnmarkedCatchUp(slots);
      } else if (paused) {
        for (final prayer in order) {
          final status = statuses[prayer] ?? PrayerMarkStatus.none;
          if (PrayerAnalyticsService.countsForPrayerStreak(status)) {
            slots.add(status);
          }
        }
      } else {
        for (final prayer in order) {
          slots.add(statuses[prayer] ?? PrayerMarkStatus.none);
        }
      }

      for (var i = slots.length - 1; i >= 0; i--) {
        final status = slots[i];
        final counts = PrayerAnalyticsService.countsForPrayerStreak(status);
        if (!foundTip) {
          if (counts) {
            foundTip = true;
            streak = 1;
          } else if (status == PrayerMarkStatus.none) {
            // Not logged yet — keep walking older slots. Marking Fajr first
            // must count even if Dhuhr/Asr have already started.
            continue;
          } else {
            return 0;
          }
        } else if (counts) {
          streak += 1;
        } else {
          return streak;
        }
      }
    }
    return streak;
  }

  static bool _previousCalendarDayIsPaused(
    DateTime today,
    bool Function(DateTime date) isCycleDay,
  ) {
    final yesterday = today.subtract(const Duration(days: 1));
    return isCycleDay(yesterday);
  }

  /// True when walking older days (skipping paused) would find a counting tip
  /// before a tip-breaking slot — i.e. the streak can bridge past [fromDayOffset].
  static bool _nonPausedTipExists({
    required int fromDayOffset,
    required DateTime today,
    required DateTime now,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
    required bool Function(DateTime date) isCycleDay,
    required DateTime? Function(TrackablePrayer prayer)? prayerStartTime,
  }) {
    final order = TrackablePrayer.values;
    for (var dayOffset = fromDayOffset; dayOffset < 400; dayOffset++) {
      final date = today.subtract(Duration(days: dayOffset));
      if (isCycleDay(date)) continue;

      final statuses = statusHistory[PrayerAnalyticsService.dayKey(date)] ??
          const <TrackablePrayer, PrayerMarkStatus>{};
      final slots = <PrayerMarkStatus>[];
      if (dayOffset == 0) {
        for (var i = 0; i < order.length; i++) {
          final prayer = order[i];
          final status = statuses[prayer] ?? PrayerMarkStatus.none;
          final started = _hasStarted(
            now: now,
            prayer: prayer,
            prayerStartTime: prayerStartTime,
            slotIndex: i,
          );
          if (!started && status == PrayerMarkStatus.none) break;
          slots.add(status);
        }
        _dropTrailingUnmarkedCatchUp(slots);
      } else {
        for (final prayer in order) {
          slots.add(statuses[prayer] ?? PrayerMarkStatus.none);
        }
      }

      if (slots.isEmpty) continue;
      for (var i = slots.length - 1; i >= 0; i--) {
        final status = slots[i];
        if (PrayerAnalyticsService.countsForPrayerStreak(status)) {
          return true;
        }
        if (status != PrayerMarkStatus.none) {
          return false;
        }
      }
    }
    return false;
  }

  /// After the user has logged On Time/Qada today, later started-but-unmarked
  /// slots are catch-up — trim them so they are not treated as a breaking tip.
  static void _dropTrailingUnmarkedCatchUp(List<PrayerMarkStatus> slots) {
    if (!slots.any(PrayerAnalyticsService.countsForPrayerStreak)) return;
    while (slots.isNotEmpty && slots.last == PrayerMarkStatus.none) {
      slots.removeLast();
    }
  }

  static bool _hasStarted({
    required DateTime now,
    required TrackablePrayer prayer,
    required DateTime? Function(TrackablePrayer prayer)? prayerStartTime,
    required int slotIndex,
  }) {
    final start = prayerStartTime?.call(prayer);
    if (start != null) {
      return HomePrayerTimesHelper.hasStartedOnDay(start, now);
    }
    const hours = [5, 12, 15, 18, 20];
    return now.hour >= hours[slotIndex];
  }
}

/// Consecutive calendar days with all five prayers completed (onTime or qada).
///
/// Today's incomplete day is skipped (does not break a prior day streak).
/// Separate from [PrayerStreakCalculator]. Paused Cycle Mode days are bridged.
abstract class DayStreakCalculator {
  static int calculate({
    required DateTime now,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
    required bool Function(DateTime date) isCycleDay,
  }) {
    var count = 0;
    final today = DateTime(now.year, now.month, now.day);

    for (var dayOffset = 0; dayOffset < 400; dayOffset++) {
      final date = today.subtract(Duration(days: dayOffset));
      if (isCycleDay(date)) continue;

      final complete = isDayFullyCompleted(date, statusHistory);
      if (dayOffset == 0 && !complete) continue;
      if (!complete) break;
      count += 1;
    }
    return count;
  }

  static bool isDayFullyCompleted(
    DateTime date,
    Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
  ) {
    final statuses = statusHistory[PrayerAnalyticsService.dayKey(date)] ??
        const <TrackablePrayer, PrayerMarkStatus>{};
    for (final prayer in TrackablePrayer.values) {
      final status = statuses[prayer] ?? PrayerMarkStatus.none;
      if (!PrayerAnalyticsService.countsForPrayerStreak(status)) {
        return false;
      }
    }
    return true;
  }
}

abstract class WeeklyCalculator {
  static ({int completed, int possible}) calculate({
    required DateTime now,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
    required bool Function(DateTime date) isCycleDay,
  }) {
    var done = 0;
    var possible = 0;
    for (final d in insightsWeekDates(now)) {
      // Cycle days are paused — excluded from both completed and possible.
      if (isCycleDay(d)) continue;
      possible += PrayerAnalyticsService.prayersPerDay;
      done += completedCountOnDate(d, statusHistory, isCycleDay);
    }
    return (completed: done, possible: possible);
  }

  static int completedCountOnDate(
    DateTime date,
    Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
    bool Function(DateTime date) isCycleDay,
  ) {
    if (isCycleDay(date)) return 0;
    final statuses = statusHistory[PrayerAnalyticsService.dayKey(date)] ??
        const <TrackablePrayer, PrayerMarkStatus>{};
    var count = 0;
    for (final prayer in TrackablePrayer.values) {
      if (PrayerAnalyticsService.countsForPrayerStreak(
        statuses[prayer] ?? PrayerMarkStatus.none,
      )) {
        count += 1;
      }
    }
    return count;
  }

  static List<DateTime> insightsWeekDates(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final daysFromFriday = (today.weekday - DateTime.friday + 7) % 7;
    final friday = today.subtract(Duration(days: daysFromFriday));
    return List<DateTime>.generate(
      7,
      (i) => friday.add(Duration(days: i)),
      growable: false,
    );
  }

  static List<DateTime> mondayWeekDates(DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final monday = today.subtract(Duration(days: today.weekday - 1));
    return List<DateTime>.generate(
      7,
      (i) => monday.add(Duration(days: i)),
      growable: false,
    );
  }
}

abstract class MonthlyCalculator {
  static ({int completed, int possible}) calculate({
    required DateTime now,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
    required bool Function(DateTime date) isCycleDay,
  }) {
    var done = 0;
    var possible = 0;
    for (final d in monthDatesFor(now)) {
      if (isCycleDay(d)) continue;
      possible += PrayerAnalyticsService.prayersPerDay;
      done += WeeklyCalculator.completedCountOnDate(d, statusHistory, isCycleDay);
    }
    return (completed: done, possible: possible);
  }

  static List<DateTime> monthDatesFor(DateTime now) {
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    return List<DateTime>.generate(
      daysInMonth,
      (i) => DateTime(now.year, now.month, i + 1),
      growable: false,
    );
  }

  static List<({String label, int completed, int possible})> weekBuckets(
    DateTime now,
    Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
    bool Function(DateTime date) isCycleDay,
  ) {
    final daysInMonth = DateTime(now.year, now.month + 1, 0).day;
    final buckets = <({String label, int completed, int possible})>[];
    for (var week = 0; week < 5; week++) {
      final startDay = week * 7 + 1;
      if (startDay > daysInMonth) break;
      final endDay = (startDay + 6).clamp(1, daysInMonth);
      var completed = 0;
      var possible = 0;
      for (var d = startDay; d <= endDay; d++) {
        final date = DateTime(now.year, now.month, d);
        if (isCycleDay(date)) continue;
        possible += PrayerAnalyticsService.prayersPerDay;
        completed += WeeklyCalculator.completedCountOnDate(
          date,
          statusHistory,
          isCycleDay,
        );
      }
      buckets.add((
        label: 'W${week + 1}',
        completed: completed,
        possible: possible,
      ));
    }
    return buckets;
  }
}

abstract class PrayerRateCalculator {
  static int calculate({
    required DateTime now,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
    required bool Function(DateTime date) isCycleDay,
    int lookbackDays = 30,
  }) {
    var possible = 0;
    var done = 0;
    final today = DateTime(now.year, now.month, now.day);
    for (var i = 0; i < lookbackDays; i++) {
      final date = today.subtract(Duration(days: i));
      if (isCycleDay(date)) continue;
      possible += PrayerAnalyticsService.prayersPerDay;
      done += WeeklyCalculator.completedCountOnDate(
        date,
        statusHistory,
        isCycleDay,
      );
    }
    if (possible == 0) return 0;
    return ((done / possible) * 100).round().clamp(0, 100);
  }
}

/// Snapchat-style restore: fix the most recent break within 24 hours.
abstract class RestoreCalculator {
  /// Finds the most recent reconnectable streak break whose scheduled start is
  /// within the last 24 hours.
  ///
  /// A slot is eligible only when it is started + non-counting **and** there is
  /// at least one older counting mark (so Restore never invents a streak on a
  /// fresh install / empty history).
  static RestoreTarget? findTarget({
    required DateTime now,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
    required bool Function(DateTime date) isCycleDay,
    DateTime? Function(TrackablePrayer prayer)? prayerStartTime,
  }) {
    final windowStart = now.subtract(PrayerAnalyticsService.restoreWindow);
    final today = DateTime(now.year, now.month, now.day);
    final order = TrackablePrayer.values;

    // Walk newest → oldest; first reconnectable non-counting started slot.
    for (var dayOffset = 0; dayOffset <= 1; dayOffset++) {
      final date = today.subtract(Duration(days: dayOffset));
      if (isCycleDay(date)) continue;

      final statuses = statusHistory[PrayerAnalyticsService.dayKey(date)] ??
          const <TrackablePrayer, PrayerMarkStatus>{};

      for (var i = order.length - 1; i >= 0; i--) {
        final prayer = order[i];
        final slotTime = PrayerAnalyticsService.slotDateTime(
          day: date,
          prayer: prayer,
          now: now,
          prayerStartTime: prayerStartTime,
        );
        if (slotTime == null) continue;
        if (slotTime.isAfter(now)) continue; // future
        if (slotTime.isBefore(windowStart)) continue; // older than 24h

        final status = statuses[prayer] ?? PrayerMarkStatus.none;
        if (PrayerAnalyticsService.countsForPrayerStreak(status)) continue;
        if (!_hasOlderCountingMark(
          candidateDate: date,
          candidateIndex: i,
          statusHistory: statusHistory,
          isCycleDay: isCycleDay,
        )) {
          continue;
        }
        return RestoreTarget(
          date: date,
          dateKey: PrayerAnalyticsService.dayKey(date),
          prayer: prayer,
        );
      }
    }
    return null;
  }

  /// True when any older slot (same day earlier, or prior non-paused days) has
  /// an On Time / Qadha mark — i.e. restoring would reconnect a real tip.
  static bool _hasOlderCountingMark({
    required DateTime candidateDate,
    required int candidateIndex,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
    required bool Function(DateTime date) isCycleDay,
  }) {
    final order = TrackablePrayer.values;
    final day = DateTime(
      candidateDate.year,
      candidateDate.month,
      candidateDate.day,
    );

    final sameDay =
        statusHistory[PrayerAnalyticsService.dayKey(day)] ??
        const <TrackablePrayer, PrayerMarkStatus>{};
    for (var i = candidateIndex - 1; i >= 0; i--) {
      final status = sameDay[order[i]] ?? PrayerMarkStatus.none;
      if (PrayerAnalyticsService.countsForPrayerStreak(status)) return true;
    }

    for (var dayOffset = 1; dayOffset < 400; dayOffset++) {
      final date = day.subtract(Duration(days: dayOffset));
      if (isCycleDay(date)) continue;
      final statuses = statusHistory[PrayerAnalyticsService.dayKey(date)] ??
          const <TrackablePrayer, PrayerMarkStatus>{};
      for (final prayer in order) {
        final status = statuses[prayer] ?? PrayerMarkStatus.none;
        if (PrayerAnalyticsService.countsForPrayerStreak(status)) return true;
      }
    }
    return false;
  }

  /// Returns a new status history with [target] marked onTime.
  /// Does not invent other prayers — only repairs that one break.
  static Map<String, Map<TrackablePrayer, PrayerMarkStatus>> apply({
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
    required RestoreTarget target,
  }) {
    final next = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
      for (final e in statusHistory.entries)
        e.key: Map<TrackablePrayer, PrayerMarkStatus>.from(e.value),
    };
    final day = Map<TrackablePrayer, PrayerMarkStatus>.from(
      next[target.dateKey] ?? const <TrackablePrayer, PrayerMarkStatus>{},
    );
    day[target.prayer] = PrayerMarkStatus.onTime;
    next[target.dateKey] = day;
    return next;
  }
}

abstract class AchievementCalculator {
  static ({
    int prayerStreak,
    int dayStreak,
    int fajrOnTimeStreak,
  }) calculate({
    required DateTime now,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
    bool Function(DateTime date)? isCycleDay,
    bool Function(DateTime date)? isPausedStreakDay,
    bool pauseStreaks = true,
    DateTime? Function(TrackablePrayer prayer)? prayerStartTime,
  }) {
    bool isPausedDay(DateTime d) =>
        isPausedStreakDay?.call(d) ??
        (pauseStreaks && (isCycleDay?.call(d) ?? false));
    return (
      prayerStreak: PrayerStreakCalculator.calculate(
        now: now,
        statusHistory: statusHistory,
        isCycleDay: isPausedDay,
        prayerStartTime: prayerStartTime,
      ),
      dayStreak: DayStreakCalculator.calculate(
        now: now,
        statusHistory: statusHistory,
        isCycleDay: isPausedDay,
      ),
      fajrOnTimeStreak: fajrOnTimeStreakDays(
        now: now,
        statusHistory: statusHistory,
        isCycleDay: isPausedDay,
      ),
    );
  }

  static int fajrOnTimeStreakDays({
    required DateTime now,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
    required bool Function(DateTime date) isCycleDay,
  }) {
    var count = 0;
    final today = DateTime(now.year, now.month, now.day);
    for (var i = 0; i < 400; i++) {
      final date = today.subtract(Duration(days: i));
      if (isCycleDay(date)) continue;
      final statuses = statusHistory[PrayerAnalyticsService.dayKey(date)] ??
          const <TrackablePrayer, PrayerMarkStatus>{};
      final fajr = statuses[TrackablePrayer.fajr] ?? PrayerMarkStatus.none;
      if (fajr == PrayerMarkStatus.onTime || fajr == PrayerMarkStatus.qada) {
        count += 1;
      } else if (i == 0) {
        continue;
      } else {
        break;
      }
    }
    return count;
  }
}
