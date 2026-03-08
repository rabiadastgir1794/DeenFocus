import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../core/services/storage_service.dart';
import '../model/home_models.dart';

abstract class HomeIslamicEventsHelper {
  static final DateFormat _dayKeyFormat = DateFormat('yyyy-MM-dd');

  static Future<List<HomeIslamicEvent>> loadIslamicEvents({
    int yearsAhead = 5,
    DateTime? now,
  }) async {
    final today = now ?? DateTime.now();
    final currentYear = today.year;
    final targetLastYear = currentYear + yearsAhead;

    final cachedEvents = await _loadFromCache();
    final cachedLastYear = await StorageService.homeIslamicEventsLastYear;
    if (cachedEvents.isNotEmpty && cachedLastYear >= targetLastYear) {
      return cachedEvents;
    }

    try {
      final all = <HomeIslamicEvent>[];
      for (var offset = 0; offset <= yearsAhead; offset++) {
        final yearEvents = await _fetchEventsForYear(currentYear + offset);
        all.addAll(yearEvents);
        await Future<void>.delayed(const Duration(milliseconds: 100));
      }
      final sorted = _dedupeAndSort(all);
      await _saveToCache(sorted, targetLastYear);
      return sorted;
    } catch (_) {
      if (cachedEvents.isNotEmpty) return cachedEvents;
      return _fallbackFridayEvents(currentYear, yearsAhead);
    }
  }

  static Future<List<HomeIslamicEvent>> _fetchEventsForYear(int year) async {
    final events = <HomeIslamicEvent>[];

    for (var month = 1; month <= 12; month++) {
      final uri = Uri.parse(
        'https://api.aladhan.com/v1/gToHCalendar/$month/$year',
      );
      final response = await http.get(uri).timeout(const Duration(seconds: 30));
      if (response.statusCode != 200) continue;

      final decoded = jsonDecode(response.body) as Map<String, dynamic>;
      final data = (decoded['data'] as List<dynamic>?) ?? const <dynamic>[];

      for (final rawDay in data) {
        final dayData = Map<String, dynamic>.from(rawDay as Map);
        final hijri = Map<String, dynamic>.from(
          (dayData['hijri'] as Map?) ?? const <String, dynamic>{},
        );
        final gregorian = Map<String, dynamic>.from(
          (dayData['gregorian'] as Map?) ?? const <String, dynamic>{},
        );
        final holidays =
            (hijri['holidays'] as List<dynamic>?) ?? const <dynamic>[];

        if (holidays.isEmpty) continue;

        final day = int.tryParse('${gregorian['day'] ?? ''}');
        final yearInt = int.tryParse('${gregorian['year'] ?? ''}');
        final monthObj = Map<String, dynamic>.from(
          (gregorian['month'] as Map?) ?? const <String, dynamic>{},
        );
        final monthNumber = (monthObj['number'] as num?)?.toInt();

        if (day == null || yearInt == null || monthNumber == null) continue;

        final date = DateTime(yearInt, monthNumber, day);
        for (final holiday in holidays) {
          final title = '$holiday'.trim();
          if (title.isEmpty) continue;
          events.add(HomeIslamicEvent(date: date, title: title));
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
