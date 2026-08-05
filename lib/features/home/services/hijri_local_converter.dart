import 'package:hijri/hijri_calendar.dart';

import 'hijri_date_service.dart';

/// Instant Hijri dates via the local Umm-al-Qura table — no network required.
/// Aladhan API results replace these when available (authoritative for holidays).
abstract class HijriLocalConverter {
  HijriLocalConverter._();

  static Map<String, dynamic> toHijriMap(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    final h = HijriCalendar.fromDate(normalized);
    return {
      'day': '${h.hDay}',
      'month': h.hMonth,
      'monthName': h.longMonthName,
      'monthNameAr': h.shortMonthName,
      'year': '${h.hYear}',
      'weekday': h.dayWeName,
      'designation': 'AH',
      'source': 'local',
    };
  }

  static List<HijriCalendarDay> monthCalendar({
    required int year,
    required int month,
  }) {
    final daysInMonth = DateTime(year, month + 1, 0).day;
    return List<HijriCalendarDay>.generate(daysInMonth, (index) {
      final day = index + 1;
      final gregorian = DateTime(year, month, day);
      final h = HijriCalendar.fromDate(gregorian);
      return HijriCalendarDay(
        gregorian: gregorian,
        hijriDay: h.hDay,
        hijriMonth: h.hMonth,
        hijriMonthEn: h.longMonthName,
        hijriYear: h.hYear,
        holidays: const [],
      );
    }, growable: false);
  }
}
