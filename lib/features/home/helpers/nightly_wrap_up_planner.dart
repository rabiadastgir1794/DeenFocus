import '../model/home_models.dart';

/// Which localized copy to use for the Nightly Daily Wrap-Up reminder.
enum NightlyWrapUpContentKind {
  prayers,
  checklist,
  both,
}

/// Planned OS notification at Isha + 1 hour (or null when nothing should fire).
class NightlyWrapUpPlan {
  const NightlyWrapUpPlan({
    required this.when,
    required this.kind,
  });

  final DateTime when;
  final NightlyWrapUpContentKind kind;
}

/// Pure planning for the Nightly Daily Wrap-Up reminder.
///
/// Sleep / Night Discipline never suppresses this reminder. Cycle Mode skip is
/// decided by the caller using existing [CycleModePolicy] rules.
abstract final class NightlyWrapUpPlanner {
  static DateTime dateKeyDate(DateTime value) =>
      DateTime(value.year, value.month, value.day);

  static String dateKeyFor(DateTime value) {
    final day = dateKeyDate(value);
    final month = day.month.toString().padLeft(2, '0');
    final dayOfMonth = day.day.toString().padLeft(2, '0');
    return '${day.year}-$month-$dayOfMonth';
  }

  /// Wall-clock Isha minute + 1 hour (seconds cleared).
  static DateTime wrapUpTimeFromIsha(DateTime isha) {
    final local = isha.isUtc ? isha.toLocal() : isha;
    final minute = DateTime(
      local.year,
      local.month,
      local.day,
      local.hour,
      local.minute,
    );
    return minute.add(const Duration(hours: 1));
  }

  static bool prayerNeedsAttention(PrayerMarkStatus status) {
    return status == PrayerMarkStatus.none || status == PrayerMarkStatus.missed;
  }

  static bool hasPrayersNeedingAttention(
    Map<TrackablePrayer, PrayerMarkStatus> statuses,
  ) {
    for (final prayer in TrackablePrayer.values) {
      final status = statuses[prayer] ?? PrayerMarkStatus.none;
      if (prayerNeedsAttention(status)) return true;
    }
    return false;
  }

  static bool isChecklistIncomplete(Set<DailyChecklistItem> completed) {
    for (final item in DailyChecklistItemX.storedHabits) {
      if (!completed.contains(item)) return true;
    }
    return false;
  }

  static NightlyWrapUpContentKind? contentKind({
    required bool prayersNeedAttention,
    required bool checklistIncomplete,
  }) {
    if (prayersNeedAttention && checklistIncomplete) {
      return NightlyWrapUpContentKind.both;
    }
    if (prayersNeedAttention) return NightlyWrapUpContentKind.prayers;
    if (checklistIncomplete) return NightlyWrapUpContentKind.checklist;
    return null;
  }

  /// Builds tonight's plan, or `null` when the reminder must not be scheduled.
  static NightlyWrapUpPlan? planForDay({
    required DateTime ishaTime,
    required Map<TrackablePrayer, PrayerMarkStatus> prayerStatuses,
    required Set<DailyChecklistItem> checklistCompleted,
    required bool skipForCycleMode,
  }) {
    if (skipForCycleMode) return null;
    final kind = contentKind(
      prayersNeedAttention: hasPrayersNeedingAttention(prayerStatuses),
      checklistIncomplete: isChecklistIncomplete(checklistCompleted),
    );
    if (kind == null) return null;
    return NightlyWrapUpPlan(
      when: wrapUpTimeFromIsha(ishaTime),
      kind: kind,
    );
  }

  /// Checklist items that count for [dateKey]. Mismatched/missing days are empty.
  static Set<DailyChecklistItem> checklistCompletedForDate({
    required DailyChecklistState? stored,
    required String dateKey,
  }) {
    if (stored == null || stored.dateKey != dateKey) {
      return const <DailyChecklistItem>{};
    }
    return stored.completedItems;
  }
}
