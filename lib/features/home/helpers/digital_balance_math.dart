import '../model/digital_balance_models.dart';

/// Pure aggregation for Digital Balance. UI formats strings via l10n.
abstract class DigitalBalanceMath {
  static const int defaultGoalMinutes = 60;
  static const int minGoalMinutes = 1;
  static const int maxGoalMinutes = 720;
  static const int previewAppCount = 7;

  static const List<int> goalPresets = <int>[15, 30, 45, 60];

  static DateTime dateOnly(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static DateTime mondayOf(DateTime date) {
    final day = dateOnly(date);
    return day.subtract(Duration(days: day.weekday - 1));
  }

  static String dateKey(DateTime date) {
    final d = dateOnly(date);
    final month = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$month-$day';
  }

  static int percentOf(Duration part, Duration total) {
    if (total.inMilliseconds <= 0) return 0;
    return ((part.inMilliseconds / total.inMilliseconds) * 100).round().clamp(
      0,
      100,
    );
  }

  static String formatDuration(Duration duration) {
    final totalMinutes = duration.inMinutes;
    if (totalMinutes <= 0) return '0m';
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    if (hours <= 0) return '${minutes}m';
    if (minutes <= 0) return '${hours}h';
    return '${hours}h ${minutes}m';
  }

  static int clampGoalMinutes(int minutes) =>
      minutes.clamp(minGoalMinutes, maxGoalMinutes);

  static int? weekDeenIncreasePercent(Duration thisWeek, Duration lastWeek) {
    return _increasePercent(thisWeek, lastWeek);
  }

  static int? yesterdayIncreasePercent(Duration today, Duration yesterday) {
    return _increasePercent(today, yesterday);
  }

  static int? _increasePercent(Duration current, Duration previous) {
    if (previous.inMilliseconds <= 0) return null;
    if (current <= previous) return null;
    return ((current - previous).inMilliseconds / previous.inMilliseconds * 100)
        .round();
  }

  static Duration remainingToGoal(Duration deenToday, int goalMinutes) {
    final goal = Duration(minutes: clampGoalMinutes(goalMinutes));
    final left = goal - deenToday;
    return left.isNegative ? Duration.zero : left;
  }

  static bool goalReached(Duration deenToday, int goalMinutes) {
    return deenToday >= Duration(minutes: clampGoalMinutes(goalMinutes));
  }

  static double niceHourCeiling(Duration maxUsage) {
    final hours = maxUsage.inMinutes / 60.0;
    if (hours <= 0) return 3;
    final stepped = (hours / 3).ceil() * 3;
    return stepped < 3 ? 3.0 : stepped.toDouble();
  }

  static DigitalBalanceInsight insightFor({
    required Duration todayDeen,
    required Duration yesterdayDeen,
    required Duration thisWeekDeen,
    required Duration lastWeekDeen,
  }) {
    final vsYesterday = yesterdayIncreasePercent(todayDeen, yesterdayDeen);
    if (vsYesterday != null) {
      return DigitalBalanceInsight(
        kind: DigitalBalanceInsightKind.increasedVsYesterday,
        percent: vsYesterday,
      );
    }
    if (todayDeen.inMinutes > 0) {
      return DigitalBalanceInsight(
        kind: DigitalBalanceInsightKind.minutesToday,
        duration: todayDeen,
      );
    }
    if (lastWeekDeen.inMilliseconds > 0 && thisWeekDeen > lastWeekDeen) {
      return const DigitalBalanceInsight(
        kind: DigitalBalanceInsightKind.weekHigher,
      );
    }
    if (todayDeen.inMilliseconds <= 0) {
      return const DigitalBalanceInsight(
        kind: DigitalBalanceInsightKind.quietDay,
      );
    }
    return const DigitalBalanceInsight(
      kind: DigitalBalanceInsightKind.keepGoing,
    );
  }

  static List<AppUsageDay> weekDays({
    required DateTime weekStart,
    required Map<String, AppUsageDay> byDate,
  }) {
    return List<AppUsageDay>.generate(7, (index) {
      final date = dateOnly(weekStart.add(Duration(days: index)));
      return byDate[dateKey(date)] ?? AppUsageDay(date: date, apps: const []);
    });
  }

  static List<AppUsageEntry> rankedApps(
    List<AppUsageEntry> apps, {
    int? limit,
  }) {
    final merged = <String, AppUsageEntry>{};
    for (final app in apps) {
      final existing = merged[app.packageName];
      if (existing == null) {
        merged[app.packageName] = app;
      } else {
        merged[app.packageName] = AppUsageEntry(
          info: existing.info,
          usage: existing.usage + app.usage,
          date: existing.date,
        );
      }
    }
    final ranked = merged.values.toList()
      ..sort((a, b) => b.usage.compareTo(a.usage));
    if (limit == null || ranked.length <= limit) return ranked;

    final preview = ranked.take(limit).toList();
    final deen = ranked.where((app) => app.isDeenFocus).firstOrNull;
    if (deen != null && preview.every((app) => !app.isDeenFocus)) {
      preview[preview.length - 1] = deen;
    }
    return preview;
  }

  static DigitalBalanceSnapshot buildSnapshot({
    required AppUsageAvailability availability,
    required List<AppUsageDay> days,
    required DateTime now,
    required int goalMinutes,
  }) {
    final today = dateOnly(now);
    final byDate = <String, AppUsageDay>{
      for (final day in days) dateKey(day.date): day,
    };
    final todayDay =
        byDate[dateKey(today)] ?? AppUsageDay(date: today, apps: const []);
    final thisWeekStart = mondayOf(today);
    final lastWeekStart = thisWeekStart.subtract(const Duration(days: 7));
    final thisWeek = weekDays(weekStart: thisWeekStart, byDate: byDate);
    final lastWeek = weekDays(weekStart: lastWeekStart, byDate: byDate);
    final yesterday = byDate[dateKey(today.subtract(const Duration(days: 1)))];

    final weekDeen = thisWeek.fold<Duration>(
      Duration.zero,
      (sum, day) => sum + day.deenFocusUsage,
    );
    final lastWeekDeen = lastWeek.fold<Duration>(
      Duration.zero,
      (sum, day) => sum + day.deenFocusUsage,
    );

    return DigitalBalanceSnapshot(
      availability: availability,
      today: todayDay,
      thisWeek: thisWeek,
      lastWeek: lastWeek,
      topApps: rankedApps(todayDay.apps, limit: previewAppCount),
      allTodayApps: rankedApps(todayDay.apps),
      insight: insightFor(
        todayDeen: todayDay.deenFocusUsage,
        yesterdayDeen: yesterday?.deenFocusUsage ?? Duration.zero,
        thisWeekDeen: weekDeen,
        lastWeekDeen: lastWeekDeen,
      ),
      goalMinutes: clampGoalMinutes(goalMinutes),
    );
  }
}
