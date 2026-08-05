import 'dart:convert';

import 'package:intl/intl.dart';

import '../../../core/logger/trace_helpers.dart';
import '../../../core/services/storage_service.dart';
import '../model/home_models.dart';
import '../services/hijri_date_service.dart';
import 'islamic_event_catalog.dart';

abstract class HomeIslamicEventsHelper {
  static final DateFormat _dayKeyFormat = DateFormat('yyyy-MM-dd');

  /// Fast path — persisted events only (no network).
  static Future<List<HomeIslamicEvent>> loadCachedEvents() async =>
      _loadFromCache();

  static Future<List<HomeIslamicEvent>> loadIslamicEvents({
    int yearsAhead = 2,
    DateTime? now,
  }) async {
    final today = now ?? DateTime.now();
    final currentYear = today.year;
    final targetLastYear = currentYear + yearsAhead;

    final cachedEvents = await _loadFromCache();
    final cachedLastYear = await StorageService.homeIslamicEventsLastYear;
    final cacheHasWhiteDays =
        cachedEvents.any((e) => e.title.toLowerCase() == 'white days');
    if (cachedEvents.isNotEmpty &&
        cachedLastYear >= targetLastYear &&
        cacheHasWhiteDays) {
      return cachedEvents;
    }

    try {
      final all = <HomeIslamicEvent>[];
      for (var offset = 0; offset <= yearsAhead; offset++) {
        final yearEvents = await _fetchEventsForYear(currentYear + offset);
        all.addAll(yearEvents);
      }
      final sorted = _dedupeAndSort(all);
      await _saveToCache(sorted, targetLastYear);
      return sorted;
    } catch (e, st) {
      TraceHelpers.traceNetworkFailure(
        'loadIslamicEvents',
        e,
        stackTrace: st,
      );
      if (cachedEvents.isNotEmpty) return cachedEvents;
      return _fallbackFridayEvents(currentYear, yearsAhead);
    }
  }

  /// Next occurrence of each major Islamic event on or after [from].
  static List<HomeIslamicEvent> majorUpcomingEvents(
    List<HomeIslamicEvent> allEvents, {
    DateTime? from,
  }) {
    final anchor = from ?? DateTime.now();
    final start = DateTime(anchor.year, anchor.month, anchor.day);
    final byKind = <IslamicEventKind, HomeIslamicEvent>{};

    for (final event in allEvents) {
      final day = DateTime(event.date.year, event.date.month, event.date.day);
      if (day.isBefore(start)) continue;
      final kind = IslamicEventCatalog.kindForTitle(event.title);
      if (!IslamicEventCatalog.isMajor(kind)) continue;
      final existing = byKind[kind];
      if (existing == null || event.date.isBefore(existing.date)) {
        byKind[kind] = event;
      }
    }

    final ordered = <HomeIslamicEvent>[];
    for (final kind in IslamicEventCatalog.majorKinds) {
      final event = byKind[kind];
      if (event != null) ordered.add(event);
    }
    ordered.sort((a, b) => a.date.compareTo(b.date));
    return ordered;
  }

  /// Observances in the calendar week containing [dayInWeek].
  static List<HomeIslamicEvent> thisWeekObservances(
    DateTime dayInWeek,
    List<HomeIslamicEvent> allEvents,
  ) {
    return eventsForWeek(dayInWeek, allEvents).where((event) {
      final kind = IslamicEventCatalog.kindForTitle(event.title);
      return IslamicEventCatalog.isThisWeekObservance(kind);
    }).toList(growable: false);
  }

  static Future<List<HomeIslamicEvent>> _fetchEventsForYear(int year) async {
    final events = <HomeIslamicEvent>[];

    for (var month = 1; month <= 12; month++) {
      final days = await HijriDateService.getMonthCalendar(
        year: year,
        month: month,
      );

      for (final day in days) {
        for (final holiday in day.holidays) {
          final title = holiday.trim();
          if (title.isEmpty) continue;
          events.add(HomeIslamicEvent(date: day.gregorian, title: title));
        }

        if (day.hijriDay >= 13 && day.hijriDay <= 15) {
          events.add(
            HomeIslamicEvent(date: day.gregorian, title: 'White Days'),
          );
        }
      }
    }

    events.addAll(_fridaysForYear(year));
    return _dedupeAndSort(events);
  }

  static List<HomeIslamicEvent> eventsForMonth(
    DateTime monthDate,
    List<HomeIslamicEvent> allEvents,
  ) {
    final first = DateTime(monthDate.year, monthDate.month, 1);
    final next = DateTime(monthDate.year, monthDate.month + 1, 1);
    return allEvents
        .where((e) => !e.date.isBefore(first) && e.date.isBefore(next))
        .toList(growable: false)
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  static List<HomeIslamicEvent> eventsForWeek(
    DateTime dayInWeek,
    List<HomeIslamicEvent> allEvents,
  ) {
    final start = DateTime(
      dayInWeek.year,
      dayInWeek.month,
      dayInWeek.day,
    ).subtract(Duration(days: dayInWeek.weekday % 7));
    final end = start.add(const Duration(days: 7));

    return allEvents
        .where((e) => !e.date.isBefore(start) && e.date.isBefore(end))
        .toList(growable: false)
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  static List<HomeIslamicEvent> eventsForDate(
    DateTime date,
    List<HomeIslamicEvent> allEvents,
  ) {
    final key = _dayKeyFormat.format(date);
    return allEvents
        .where((e) => _dayKeyFormat.format(e.date) == key)
        .toList(growable: false);
  }

  static List<HomeIslamicEvent> _fridaysForYear(int year) {
    final events = <HomeIslamicEvent>[];
    var date = DateTime(year, 1, 1);
    final end = DateTime(year, 12, 31);

    while (!date.isAfter(end)) {
      if (date.weekday == DateTime.friday) {
        events.add(HomeIslamicEvent(date: date, title: 'Jumu\'ah'));
      }
      date = date.add(const Duration(days: 1));
    }

    return events;
  }

  static List<HomeIslamicEvent> _dedupeAndSort(List<HomeIslamicEvent> input) {
    final map = <String, HomeIslamicEvent>{};
    for (final event in input) {
      final dateKey = _dayKeyFormat.format(event.date);
      final key = '$dateKey|${event.title.toLowerCase()}';
      map[key] = event;
    }

    final deduped = map.values.toList(growable: false)
      ..sort((a, b) => a.date.compareTo(b.date));
    return deduped;
  }

  static Future<void> _saveToCache(
    List<HomeIslamicEvent> events,
    int lastYear,
  ) async {
    final payload = events
        .map(
          (e) => <String, dynamic>{
            'title': e.title,
            'date': e.date.toIso8601String(),
          },
        )
        .toList(growable: false);

    await StorageService.setHomeIslamicEventsJson(jsonEncode(payload));
    await StorageService.setHomeIslamicEventsLastYear(lastYear);
  }

  static Future<List<HomeIslamicEvent>> _loadFromCache() async {
    final raw = await StorageService.homeIslamicEventsJson;
    if (raw == null || raw.isEmpty) return const <HomeIslamicEvent>[];

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final events = decoded
          .map((row) {
            final map = Map<String, dynamic>.from(row as Map);
            final title = '${map['title'] ?? ''}'.trim();
            final date = DateTime.tryParse('${map['date'] ?? ''}');
            if (title.isEmpty || date == null) {
              return null;
            }
            return HomeIslamicEvent(date: date, title: title);
          })
          .whereType<HomeIslamicEvent>()
          .toList(growable: false);
      return _dedupeAndSort(events);
    } catch (_) {
      return const <HomeIslamicEvent>[];
    }
  }

  static List<HomeIslamicEvent> _fallbackFridayEvents(
    int currentYear,
    int yearsAhead,
  ) {
    final events = <HomeIslamicEvent>[];
    for (var i = 0; i <= yearsAhead; i++) {
      events.addAll(_fridaysForYear(currentYear + i));
    }
    return _dedupeAndSort(events);
  }
}
