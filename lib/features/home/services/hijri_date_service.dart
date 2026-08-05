import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:http/http.dart' as http;

import '../../../core/logger/trace_helpers.dart';
import '../../../core/services/storage_service.dart';
import 'aladhan_calendar_repository.dart';
import 'hijri_local_converter.dart';

/// One Gregorian day mapped to its Hijri counterpart (from Aladhan).
class HijriCalendarDay {
  const HijriCalendarDay({
    required this.gregorian,
    required this.hijriDay,
    required this.hijriMonth,
    required this.hijriMonthEn,
    required this.hijriYear,
    required this.holidays,
  });

  final DateTime gregorian;
  final int hijriDay;
  final int hijriMonth;
  final String hijriMonthEn;
  final int hijriYear;
  final List<String> holidays;
}

/// Moon phase derived from Aladhan Hijri day-of-month (lunar age proxy).
class MoonPhaseInfo {
  const MoonPhaseInfo({
    required this.phaseFraction,
    required this.illuminationPercent,
    required this.hijriDay,
  });

  /// 0 = new moon, ~0.5 = full moon.
  final double phaseFraction;
  final int illuminationPercent;
  final int hijriDay;
}

/// Hijri dates — local Umm-al-Qura for instant UI, Aladhan when available.
class HijriDateService {
  static const String _cacheKeyHijriData = 'hijri_date_cache';
  static const String _cacheKeyLastFetch = 'hijri_date_last_fetch_ms';
  static const String _cacheKeyMoon = 'hijri_moon_phase_cache';

  static const int _cacheValidityMs = 24 * 60 * 60 * 1000;
  static const double _synodicMonth = 29.53058770576;

  static Map<String, dynamic>? _memoryCurrent;

  /// Synchronous best-effort Hijri for today (never blocks on network).
  static Map<String, dynamic> currentHijriLocal([DateTime? date]) =>
      HijriLocalConverter.toHijriMap(date ?? DateTime.now());

  /// Gregorian month grid with local Hijri mapping — instant, no I/O.
  static List<HijriCalendarDay> monthCalendarLocal({
    required int year,
    required int month,
  }) =>
      HijriLocalConverter.monthCalendar(year: year, month: month);

  /// Returns cached → local immediately; refreshes from Aladhan in background
  /// when [refreshNetwork] is true.
  static Future<Map<String, dynamic>> getCurrentHijriDate({
    bool refreshNetwork = true,
  }) async {
    if (_memoryCurrent != null) return _memoryCurrent!;

    final cached = await _loadFromCache();
    if (cached != null) {
      _memoryCurrent = cached;
      if (refreshNetwork && !await _isCacheValid()) {
        unawaited(_refreshCurrentFromNetwork());
      }
      return cached;
    }

    final local = currentHijriLocal();
    _memoryCurrent = local;
    if (refreshNetwork) {
      unawaited(_refreshCurrentFromNetwork());
    }
    return local;
  }

  static Future<void> _refreshCurrentFromNetwork() async {
    try {
      final now = DateTime.now();
      final url = Uri.parse(
        'https://api.aladhan.com/v1/gToH/'
        '${now.day}-${now.month}-${now.year}',
      );

      final response = await http.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) return;

      final data = json.decode(response.body) as Map<String, dynamic>;
      final hijriData = data['data']['hijri'] as Map<String, dynamic>;
      final result = {
        'day': hijriData['day'] as String,
        'month': hijriData['month']['number'] as int,
        'monthName': hijriData['month']['en'] as String,
        'monthNameAr': hijriData['month']['ar'] as String,
        'year': hijriData['year'] as String,
        'weekday': hijriData['weekday']['en'] as String,
        'designation': hijriData['designation']['abbreviated'] as String,
        'source': 'aladhan',
      };

      _memoryCurrent = result;
      await _saveToCache(result);
    } catch (e, st) {
      TraceHelpers.traceNetworkFailure(
        'HijriDateService._refreshCurrentFromNetwork',
        e,
        stackTrace: st,
      );
    }
  }

  /// Converts a Gregorian date to Hijri date.
  static Future<Map<String, dynamic>?> convertToHijri(DateTime date) async {
    try {
      final url = Uri.parse(
        'https://api.aladhan.com/v1/gToH/'
        '${date.day}-${date.month}-${date.year}',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 10),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        final hijriData = data['data']['hijri'] as Map<String, dynamic>;

        return {
          'day': hijriData['day'] as String,
          'month': hijriData['month']['number'] as int,
          'monthName': hijriData['month']['en'] as String,
          'monthNameAr': hijriData['month']['ar'] as String,
          'year': hijriData['year'] as String,
          'weekday': hijriData['weekday']['en'] as String,
          'designation': hijriData['designation']['abbreviated'] as String,
        };
      }

      return null;
    } catch (e, st) {
      TraceHelpers.traceNetworkFailure(
        'HijriDateService.convertToHijri',
        e,
        stackTrace: st,
      );
      return null;
    }
  }

  /// Month grid: local data immediately, then network/refined cache.
  static Future<List<HijriCalendarDay>> getMonthCalendar({
    required int year,
    required int month,
  }) async {
    final local = monthCalendarLocal(year: year, month: month);
    final rows = await AladhanCalendarRepository.monthDays(
      year: year,
      month: month,
    );
    if (rows.isEmpty) return local;
    return _parseMonthRows(rows, fallback: local);
  }

  static List<HijriCalendarDay> _parseMonthRows(
    List<Map<String, dynamic>> rows, {
    required List<HijriCalendarDay> fallback,
  }) {
    final days = <HijriCalendarDay>[];
    for (final dayData in rows) {
      final parsed = _parseDayRow(dayData);
      if (parsed != null) days.add(parsed);
    }
    return days.isEmpty ? fallback : days;
  }

  static HijriCalendarDay? _parseDayRow(Map<String, dynamic> dayData) {
    final hijri = Map<String, dynamic>.from(
      (dayData['hijri'] as Map?) ?? const <String, dynamic>{},
    );
    final gregorian = Map<String, dynamic>.from(
      (dayData['gregorian'] as Map?) ?? const <String, dynamic>{},
    );
    final holidays =
        ((hijri['holidays'] as List<dynamic>?) ?? const <dynamic>[])
            .map((e) => '$e'.trim())
            .where((e) => e.isNotEmpty)
            .toList(growable: false);

    final gDay = int.tryParse('${gregorian['day'] ?? ''}');
    final gYear = int.tryParse('${gregorian['year'] ?? ''}');
    final gMonthObj = Map<String, dynamic>.from(
      (gregorian['month'] as Map?) ?? const <String, dynamic>{},
    );
    final gMonth = (gMonthObj['number'] as num?)?.toInt();
    final hDay = int.tryParse('${hijri['day'] ?? ''}');
    final hYear = int.tryParse('${hijri['year'] ?? ''}');
    final hMonthObj = Map<String, dynamic>.from(
      (hijri['month'] as Map?) ?? const <String, dynamic>{},
    );
    final hMonth = (hMonthObj['number'] as num?)?.toInt();
    final hMonthEn = '${hMonthObj['en'] ?? ''}';

    if (gDay == null ||
        gYear == null ||
        gMonth == null ||
        hDay == null ||
        hYear == null ||
        hMonth == null) {
      return null;
    }

    return HijriCalendarDay(
      gregorian: DateTime(gYear, gMonth, gDay),
      hijriDay: hDay,
      hijriMonth: hMonth,
      hijriMonthEn: hMonthEn,
      hijriYear: hYear,
      holidays: holidays,
    );
  }

  /// Moon phase for today, derived from Hijri day (local first, API refines).
  static Future<MoonPhaseInfo> getTodayMoonPhase() async {
    final cachedRaw = await StorageService.getString(_cacheKeyMoon);
    if (cachedRaw != null) {
      try {
        final map = jsonDecode(cachedRaw) as Map<String, dynamic>;
        final dayKey = '${map['dayKey'] ?? ''}';
        final todayKey =
            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
        if (dayKey == todayKey) {
          return MoonPhaseInfo(
            phaseFraction: (map['phase'] as num?)?.toDouble() ?? 0,
            illuminationPercent: (map['illumination'] as num?)?.toInt() ?? 0,
            hijriDay: (map['hijriDay'] as num?)?.toInt() ?? 1,
          );
        }
      } catch (_) {}
    }

    final hijri = await getCurrentHijriDate(refreshNetwork: false);
    final hijriDay = int.tryParse('${hijri['day'] ?? '1'}') ?? 1;
    final info = moonPhaseFromHijriDay(hijriDay);

    await StorageService.setString(
      _cacheKeyMoon,
      jsonEncode({
        'dayKey':
            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
        'phase': info.phaseFraction,
        'illumination': info.illuminationPercent,
        'hijriDay': info.hijriDay,
      }),
    );
    return info;
  }

  static MoonPhaseInfo moonPhaseFromHijriDay(int hijriDay) {
    final age = (hijriDay - 1).clamp(0, 29).toDouble();
    final phaseFraction = (age / _synodicMonth).clamp(0.0, 1.0);
    final illumination = ((1 - math.cos(2 * math.pi * age / _synodicMonth)) /
            2 *
            100)
        .round()
        .clamp(0, 100);
    return MoonPhaseInfo(
      phaseFraction: phaseFraction,
      illuminationPercent: illumination,
      hijriDay: hijriDay,
    );
  }

  static Future<Map<String, dynamic>?> _loadFromCache() async {
    final jsonStr = await StorageService.getString(_cacheKeyHijriData);
    if (jsonStr == null) return null;

    try {
      return json.decode(jsonStr) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  static Future<void> _saveToCache(Map<String, dynamic> data) async {
    final jsonStr = json.encode(data);
    await StorageService.setString(_cacheKeyHijriData, jsonStr);
    await StorageService.setInt(
      _cacheKeyLastFetch,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static Future<bool> _isCacheValid() async {
    final lastFetchMs = await StorageService.getInt(_cacheKeyLastFetch);
    if (lastFetchMs == null) return false;

    final now = DateTime.now().millisecondsSinceEpoch;
    return (now - lastFetchMs) < _cacheValidityMs;
  }

  static Future<void> clearCache() async {
    _memoryCurrent = null;
    AladhanCalendarRepository.clearMemory();
    await StorageService.remove(_cacheKeyHijriData);
    await StorageService.remove(_cacheKeyLastFetch);
    await StorageService.remove(_cacheKeyMoon);
  }
}
