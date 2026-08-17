import '../model/home_models.dart';

/// Pure planning for the Cycle Mode automatic-expiry OS notification.
///
/// Fire time is local midnight on the first calendar day when
/// [CycleModeData.hasExpiredOn] becomes true:
/// `startDate + cycleLength days` (the day after [CycleModeData.plannedEndDate]).
///
/// Manual disable must not schedule — callers pass disabled [CycleModeData].
abstract final class CycleModeExpiryNotificationPlanner {
  static const String payload = 'cycle_mode:edit';

  /// Local midnight when an active cycle first expires, or null if not active.
  static DateTime? scheduledFireTime(CycleModeData data) {
    if (!data.isEnabled) return null;
    final start = CycleModeData.dateOnly(data.startDate);
    return start.add(Duration(days: data.cycleLength));
  }

  /// Whether a future auto-expiry notification should be scheduled.
  static bool shouldSchedule(CycleModeData data, {DateTime? now}) {
    final when = scheduledFireTime(data);
    if (when == null) return false;
    final at = now ?? DateTime.now();
    final minute = DateTime(
      when.year,
      when.month,
      when.day,
      when.hour,
      when.minute,
    );
    return minute.isAfter(at);
  }

  /// Stable signature for cancel/schedule dedupe across restart/reschedule.
  ///
  /// [timeZoneName] must be included so Android AlarmManager / iOS triggers
  /// are rebuilt after a timezone change (wall-clock midnight shifts in UTC).
  static String scheduleSignature(
    CycleModeData data, {
    required String localeCode,
    String timeZoneName = '',
    DateTime? now,
  }) {
    final when = scheduledFireTime(data);
    final schedule = shouldSchedule(data, now: now);
    if (!schedule || when == null) {
      return 'cancel|${data.isEnabled}|$localeCode|$timeZoneName';
    }
    return 'schedule|'
        '${CycleModeData.dateOnly(data.startDate).toIso8601String()}|'
        '${data.cycleLength}|${when.toIso8601String()}|'
        '$localeCode|$timeZoneName';
  }
}
