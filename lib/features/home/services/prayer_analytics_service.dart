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

/// Current prayer count: sum of completed obligatory prayers by calendar day.
///
/// Not a consecutive-slot tip-walk. Each day scores 0–5:
/// * [PrayerMarkStatus.onTime] / [PrayerMarkStatus.qada] → +1
/// * [PrayerMarkStatus.missed] / [PrayerMarkStatus.none] → +0
/// Missed/unmarked **position** within a day never changes the daily total.
///
/// Aggregation:
/// * Always add today's partial count (0–5).
/// * Walk older days: add 5 for each full day; stop on a past non-paused day
///   with fewer than 5 completions (that day's partial is not added).
/// * Cycle-paused days ([isCycleDay]) bridge — contribute 0, do not break.
///
/// [prayerStartTime] is accepted for call-site compatibility and ignored;
/// daily counts come only from [statusHistory].
abstract class PrayerStreakCalculator {
  static int calculate({
    required DateTime now,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
    required bool Function(DateTime date) isCycleDay,
    DateTime? Function(TrackablePrayer prayer)? prayerStartTime,
  }) {
    var total = 0;
    final today = DateTime(now.year, now.month, now.day);
    // Counting helper returns 0 on paused days; we skip those explicitly so
    // a paused today still bridges into prior full days.
    bool neverPaused(DateTime _) => false;

    for (var dayOffset = 0; dayOffset < 400; dayOffset++) {
      final date = today.subtract(Duration(days: dayOffset));
      if (isCycleDay(date)) {
        // Same-day Cycle Mode start: keep today's partial count (toggle must
        // not drop marks). Mid-cycle / sealed paused days bridge with 0.
        final sameDayCycleStart = dayOffset == 0 &&
            !isCycleDay(date.subtract(const Duration(days: 1)));
        if (sameDayCycleStart) {
          total += WeeklyCalculator.completedCountOnDate(
            date,
            statusHistory,
            neverPaused,
          );
        }
        continue;
      }

      final count = WeeklyCalculator.completedCountOnDate(
        date,
        statusHistory,
        neverPaused,
      );

      if (dayOffset == 0) {
        total += count;
        continue;
      }

      if (count == PrayerAnalyticsService.prayersPerDay) {
        total += count;
      } else {
        break;
      }
    }
    return total;
  }
}

/// Consecutive calendar days with all five prayers completed (onTime or qada).
///
/// Today's incomplete day is skipped (does not break a prior day streak).
/// Separate from [PrayerStreakCalculator]. Paused Cycle Mode days are bridged:
/// incomplete paused days never break; a fully completed **today** while paused
/// still counts when Cycle Mode also starts today so same-day enable does not
/// zero the day streak.
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
      if (isCycleDay(date)) {
        // Bridge incomplete paused days. A fully completed today counts only
        // when Cycle Mode also starts today (yesterday not paused) so same-day
        // enable preserves the streak without extending it mid-cycle later.
        if (dayOffset == 0 && isDayFullyCompleted(date, statusHistory)) {
          final yesterday = date.subtract(const Duration(days: 1));
          if (!isCycleDay(yesterday)) {
            count += 1;
          }
        }
        continue;
      }

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
