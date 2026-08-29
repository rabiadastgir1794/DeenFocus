import '../model/home_models.dart';
import 'prayer_analytics_service.dart';

enum XpEventType {
  prayer,
  fajr,
  fiveDailyPrayers,
  quran,
  dhikr,
  protectedPrayer,
  cycleMode,
  nightPrayer,
  streakMilestone,
}

class XpEvent {
  const XpEvent({
    required this.sourceId,
    required this.type,
    required this.amount,
    required this.createdAt,
  });

  final String sourceId;
  final XpEventType type;
  final int amount;
  final DateTime createdAt;

  Map<String, dynamic> toMap() => <String, dynamic>{
    'sourceId': sourceId,
    'type': type.name,
    'amount': amount,
    'createdAt': createdAt.toIso8601String(),
  };

  factory XpEvent.fromMap(Map<String, dynamic> map) {
    final typeName = '${map['type'] ?? ''}';
    final type = XpEventType.values.firstWhere(
      (e) => e.name == typeName,
      orElse: () => XpEventType.prayer,
    );
    return XpEvent(
      sourceId: '${map['sourceId'] ?? ''}',
      type: type,
      amount: (map['amount'] as num?)?.toInt() ?? 0,
      createdAt: DateTime.tryParse('${map['createdAt'] ?? ''}') ?? DateTime.now(),
    );
  }
}

/// Suggested XP values from the 15-level plan. One award per unique [sourceId].
abstract class XpService {
  static const prayerXp = 10;
  static const fajrXp = 15;
  static const fiveDailyBonusXp = 20;
  static const quranDayXp = 10;
  static const dhikrDayXp = 5;
  static const protectedPrayerXp = 5;
  static const cycleModeDayXp = 3;
  static const nightPrayerXp = 10;
  static const streak7Xp = 30;
  static const streak30Xp = 75;

  static const _dhikrItems = <DailyChecklistItem>[
    DailyChecklistItem.morningAdhkar,
    DailyChecklistItem.eveningAdhkar,
    DailyChecklistItem.dhikr,
    DailyChecklistItem.istighfar,
    DailyChecklistItem.salawat,
  ];

  /// Merge newly computed events into [previous] by [XpEvent.sourceId].
  /// Existing amounts are never reduced.
  static List<XpEvent> merge({
    required List<XpEvent> previous,
    required List<XpEvent> computed,
  }) {
    final byId = <String, XpEvent>{
      for (final event in previous)
        if (event.sourceId.isNotEmpty) event.sourceId: event,
    };
    for (final event in computed) {
      if (event.sourceId.isEmpty || event.amount <= 0) continue;
      final existing = byId[event.sourceId];
      if (existing == null) {
        byId[event.sourceId] = event;
      }
    }
    return byId.values.toList(growable: false);
  }

  static int totalXp(Iterable<XpEvent> events) {
    var sum = 0;
    for (final event in events) {
      if (event.amount > 0) sum += event.amount;
    }
    return sum;
  }

  /// Deterministic XP from recorded activity. Safe to call repeatedly.
  ///
  /// [isExcludedProgressDay] must come from [CycleModePolicy.shouldExcludeFromPrayerProgress]
  /// so Cycle Mode days never award prayer / Fajr / five-daily XP.
  static List<XpEvent> collectFromActivity({
    required DateTime now,
    required Map<String, Map<TrackablePrayer, PrayerMarkStatus>> statusHistory,
    required Map<String, Set<DailyChecklistItem>> checklistHistory,
    required Iterable<DateTime> cycleProtectedDays,
    required int bestPrayerStreak,
    bool Function(DateTime date)? isExcludedProgressDay,
  }) {
    final createdAt = now;
    final events = <XpEvent>[];

    final keys = <String>{
      ...statusHistory.keys,
      ...checklistHistory.keys,
    };

    bool isExcludedKey(String key) {
      if (isExcludedProgressDay == null) return false;
      final parsed = DateTime.tryParse(key);
      if (parsed == null) return false;
      return isExcludedProgressDay(
        DateTime(parsed.year, parsed.month, parsed.day),
      );
    }

    for (final key in keys) {
      final prayers =
          statusHistory[key] ?? const <TrackablePrayer, PrayerMarkStatus>{};
      final excludePrayerXp = isExcludedKey(key);
      var completedCount = 0;
      if (!excludePrayerXp) {
        for (final prayer in TrackablePrayer.values) {
          final status = prayers[prayer] ?? PrayerMarkStatus.none;
          if (!PrayerAnalyticsService.countsForPrayerStreak(status)) continue;
          completedCount += 1;
          if (prayer == TrackablePrayer.fajr) {
            events.add(
              XpEvent(
                sourceId: 'prayer:$key:fajr',
                type: XpEventType.fajr,
                amount: fajrXp,
                createdAt: createdAt,
              ),
            );
          } else {
            events.add(
              XpEvent(
                sourceId: 'prayer:$key:${prayer.name}',
                type: XpEventType.prayer,
                amount: prayerXp,
                createdAt: createdAt,
              ),
            );
          }
        }
        if (completedCount >= TrackablePrayer.values.length) {
          events.add(
            XpEvent(
              sourceId: 'five_daily_prayers:$key',
              type: XpEventType.fiveDailyPrayers,
              amount: fiveDailyBonusXp,
              createdAt: createdAt,
            ),
          );
        }
      }

      final checklist =
          checklistHistory[key] ?? const <DailyChecklistItem>{};
      if (checklist.contains(DailyChecklistItem.quran)) {
        events.add(
          XpEvent(
            sourceId: 'quran:$key',
            type: XpEventType.quran,
            amount: quranDayXp,
            createdAt: createdAt,
          ),
        );
      }
      if (_dhikrItems.any(checklist.contains)) {
        events.add(
          XpEvent(
            sourceId: 'dhikr:$key',
            type: XpEventType.dhikr,
            amount: dhikrDayXp,
            createdAt: createdAt,
          ),
        );
      }
      if (checklist.contains(DailyChecklistItem.tahajjud)) {
        events.add(
          XpEvent(
            sourceId: 'night_prayer:$key',
            type: XpEventType.nightPrayer,
            amount: nightPrayerXp,
            createdAt: createdAt,
          ),
        );
      }
      if (checklist.contains(DailyChecklistItem.noMusicToday) ||
          checklist.contains(DailyChecklistItem.noSocialMediaBeforeIsha) ||
          checklist.contains(DailyChecklistItem.controlAngerSpeakKindly)) {
        events.add(
          XpEvent(
            sourceId: 'protected_prayer:$key',
            type: XpEventType.protectedPrayer,
            amount: protectedPrayerXp,
            createdAt: createdAt,
          ),
        );
      }
    }

    for (final day in cycleProtectedDays) {
      final key = PrayerAnalyticsService.dayKey(day);
      events.add(
        XpEvent(
          sourceId: 'cycle_mode:$key',
          type: XpEventType.cycleMode,
          amount: cycleModeDayXp,
          createdAt: createdAt,
        ),
      );
    }

    if (bestPrayerStreak >= 7) {
      events.add(
        XpEvent(
          sourceId: 'streak_milestone:7',
          type: XpEventType.streakMilestone,
          amount: streak7Xp,
          createdAt: createdAt,
        ),
      );
    }
    if (bestPrayerStreak >= 30) {
      events.add(
        XpEvent(
          sourceId: 'streak_milestone:30',
          type: XpEventType.streakMilestone,
          amount: streak30Xp,
          createdAt: createdAt,
        ),
      );
    }

    return events;
  }
}
