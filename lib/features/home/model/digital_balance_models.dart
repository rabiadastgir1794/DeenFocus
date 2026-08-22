import 'dart:typed_data';

/// Whether platform app-usage data can be shown.
enum AppUsageAvailability { granted, denied, unsupported }

class AppUsageAppInfo {
  const AppUsageAppInfo({
    required this.packageName,
    required this.appName,
    required this.isDeenFocus,
    this.iconBytes,
  });

  final String packageName;
  final String appName;
  final bool isDeenFocus;
  final Uint8List? iconBytes;
}

class AppUsageEntry {
  const AppUsageEntry({
    required this.info,
    required this.usage,
    required this.date,
  });

  final AppUsageAppInfo info;
  final Duration usage;
  final DateTime date;

  String get appName => info.appName;
  String get packageName => info.packageName;
  bool get isDeenFocus => info.isDeenFocus;
  Uint8List? get iconBytes => info.iconBytes;
}

class AppUsageDay {
  const AppUsageDay({required this.date, required this.apps});

  final DateTime date;
  final List<AppUsageEntry> apps;

  Duration get totalPhoneUsage =>
      apps.fold<Duration>(Duration.zero, (sum, app) => sum + app.usage);

  Duration get deenFocusUsage => apps
      .where((app) => app.isDeenFocus)
      .fold<Duration>(Duration.zero, (sum, app) => sum + app.usage);

  Duration get otherAppsUsage {
    final total = totalPhoneUsage - deenFocusUsage;
    return total.isNegative ? Duration.zero : total;
  }
}

enum DigitalBalanceInsightKind {
  minutesToday,
  increasedVsYesterday,
  weekHigher,
  quietDay,
  keepGoing,
}

class DigitalBalanceInsight {
  const DigitalBalanceInsight({
    required this.kind,
    this.duration = Duration.zero,
    this.percent,
  });

  final DigitalBalanceInsightKind kind;
  final Duration duration;
  final int? percent;
}

class DigitalBalanceSnapshot {
  const DigitalBalanceSnapshot({
    required this.availability,
    required this.today,
    required this.thisWeek,
    required this.lastWeek,
    required this.topApps,
    required this.allTodayApps,
    required this.insight,
    required this.goalMinutes,
  });

  final AppUsageAvailability availability;
  final AppUsageDay today;
  final List<AppUsageDay> thisWeek;
  final List<AppUsageDay> lastWeek;
  final List<AppUsageEntry> topApps;
  final List<AppUsageEntry> allTodayApps;
  final DigitalBalanceInsight insight;
  final int goalMinutes;

  Duration get todayPhone => today.totalPhoneUsage;
  Duration get todayDeen => today.deenFocusUsage;
  Duration get todayOther => today.otherAppsUsage;

  Duration get weekPhone => thisWeek.fold<Duration>(
    Duration.zero,
    (sum, day) => sum + day.totalPhoneUsage,
  );

  Duration get weekDeen => thisWeek.fold<Duration>(
    Duration.zero,
    (sum, day) => sum + day.deenFocusUsage,
  );

  Duration get lastWeekDeen => lastWeek.fold<Duration>(
    Duration.zero,
    (sum, day) => sum + day.deenFocusUsage,
  );
}
