import 'dart:convert';

import 'package:adhan_dart/adhan_dart.dart';
import 'package:intl/intl.dart';

import '../../../core/services/storage_service.dart';
import '../../onboarding/model/asr_calculation_option.dart';
import '../../onboarding/model/calculation_method_option.dart';
import '../model/home_models.dart';

abstract class HomePrayerTimesHelper {
  static final DateFormat _dayKeyFormat = DateFormat('yyyy-MM-dd');
  // v4: always anchor slot clock times to the prayer calendar day so a bad
  // cached date component cannot make Dhuhr–Isha look "upcoming" forever.
  static const String _cacheVersion = 'v4';

  /// Wall-clock start of [scheduled] on [now]'s calendar day (ignores date on
  /// [scheduled] so a bad cached year/day cannot skew comparisons).
  static DateTime wallClockOnDay(DateTime scheduled, DateTime now) {
    final local = scheduled.isUtc ? scheduled.toLocal() : scheduled;
    return DateTime(
      now.year,
      now.month,
      now.day,
      local.hour,
      local.minute,
    );
  }

  /// True when [scheduled]'s clock time has been reached on [now]'s calendar day.
  ///
  /// Uses hour:minute only (matches what the Home tiles display) so a wrong
  /// date component on [scheduled] cannot block Mark Prayer for later prayers.
  static bool hasStartedOnDay(DateTime scheduled, DateTime now) {
    return !now.isBefore(wallClockOnDay(scheduled, now));
  }

  /// True when [scheduled]'s clock time is still ahead on [now]'s calendar day.
  static bool isUpcomingOnDay(DateTime scheduled, DateTime now) {
    return wallClockOnDay(scheduled, now).isAfter(now);
  }

  /// Wall-clock time on [day]'s calendar date (year/month/day from [day]).
  static DateTime atDay(DateTime day, DateTime clock) {
    final local = clock.isUtc ? clock.toLocal() : clock;
    return DateTime(
      day.year,
      day.month,
      day.day,
      local.hour,
      local.minute,
    );
  }

  /// Live next/current highlight from [slots] using wall-clock only.
  ///
  /// Prefer this in UI over a baked [HomePrayerTimesData.nextPrayer] so a stale
  /// or wrong date on one slot (e.g. Dhuhr dated tomorrow) cannot keep that
  /// tile green after its clock time has passed.
  static ({HomePrayerId id, DateTime at})? nextPrayerOnDay({
    required List<HomePrayerSlot> slots,
    required DateTime now,
  }) {
    for (final slot in slots) {
      if (isUpcomingOnDay(slot.time, now)) {
        return (id: slot.id, at: wallClockOnDay(slot.time, now));
      }
    }
    final fajr = slots.where((s) => s.id == HomePrayerId.fajr).firstOrNull;
    if (fajr == null) return null;
    return (
      id: HomePrayerId.isha,
      at: wallClockOnDay(fajr.time, now).add(const Duration(days: 1)),
    );
  }

  static Future<HomePrayerTimesData> generatePrayerTimesForDate({
    required double latitude,
    required double longitude,
    required DateTime date,
    String? sectRaw,
  }) async {
    final normalizedDate = DateTime(date.year, date.month, date.day, 12);
    final method = CalculationMethodOption.fromRaw(
      await StorageService.calculationMethod,
      sectRaw: sectRaw ?? await StorageService.sect,
    );
    final asr = AsrCalculationOption.fromRaw(await StorageService.asrMethod);
    // Yield to the event loop before synchronous astronomical computation so
    // frames can render between prayer-time calculations for each day.
    await Future<void>.delayed(Duration.zero);
    final slots = _buildSlots(
      latitude: latitude,
      longitude: longitude,
      currentTime: normalizedDate,
      method: method,
      asr: asr,
    );
    return _buildData(slots, normalizedDate);
  }

  static Future<HomePrayerTimesData> getOrGeneratePrayerTimes({
    required double latitude,
    required double longitude,
    DateTime? now,
  }) async {
    final currentTime = now ?? DateTime.now();
    final dayKey = '${_cacheVersion}_${_dayKeyFormat.format(currentTime)}';

    final cachedDate = await StorageService.homePrayerCacheDate;
    final cachedLat = await StorageService.homePrayerCacheLatitude;
    final cachedLng = await StorageService.homePrayerCacheLongitude;
    final cachedSect = await StorageService.homePrayerCacheSect;
    final cachedJson = await StorageService.homePrayerCacheJson;
    final method = CalculationMethodOption.fromRaw(
      await StorageService.calculationMethod,
      sectRaw: await StorageService.sect,
    );
    final asr = AsrCalculationOption.fromRaw(await StorageService.asrMethod);
    final cacheKey = '${method.name}_${asr.name}';

    final hasMatchingCache =
        cachedDate == dayKey &&
        cachedLat != null &&
        cachedLng != null &&
        cachedSect == cacheKey &&
        cachedJson != null &&
        (cachedLat - latitude).abs() < 0.0001 &&
        (cachedLng - longitude).abs() < 0.0001;

    if (hasMatchingCache) {
      final cached = _fromSerialized(cachedJson, currentTime);
      if (cached != null) {
        return cached;
      }
    }

    final slots = _buildSlots(
      latitude: latitude,
      longitude: longitude,
      currentTime: currentTime,
      method: method,
      asr: asr,
    );

    final data = _buildData(slots, currentTime);
    await StorageService.setHomePrayerCache(
      dateKey: dayKey,
      latitude: latitude,
      longitude: longitude,
      sect: cacheKey,
      serializedTimes: _serialize(slots),
    );
    return data;
  }

  /// Replaces calculated slot times with any per-prayer custom time overrides
  /// (e.g. user-adjusted Fajr time for their local masjid), then recomputes
  /// which prayer is "next" so the home tiles and countdown stay accurate.
  static HomePrayerTimesData applyCustomOverrides({
    required HomePrayerTimesData data,
    required Map<TrackablePrayer, int> overridesMinutesSinceMidnight,
    required DateTime referenceTime,
  }) {
    final day = DateTime(
      referenceTime.year,
      referenceTime.month,
      referenceTime.day,
    );
    final updatedSlots = data.slots.map((slot) {
      final trackable = slot.id.trackablePrayer;
      final overrideMinutes = trackable == null
          ? null
          : overridesMinutesSinceMidnight[trackable];
      if (overrideMinutes != null) {
        return HomePrayerSlot(
          id: slot.id,
          time: day.add(Duration(minutes: overrideMinutes)),
        );
      }
      // Keep calculated slots on the reference calendar day.
      return HomePrayerSlot(
        id: slot.id,
        time: atDay(referenceTime, slot.time),
      );
    }).toList(growable: false);

    return _buildData(updatedSlots, referenceTime);
  }

  /// Calculated times for [date], with the same custom wall-clock overrides
  /// used on Home, notifications, and alarms.
  static Future<HomePrayerTimesData> generatePrayerTimesForDateWithOverrides({
    required double latitude,
    required double longitude,
    required DateTime date,
    required Map<TrackablePrayer, int> overridesMinutesSinceMidnight,
    String? sectRaw,
  }) async {
    final day = DateTime(date.year, date.month, date.day);
    return applyCustomOverrides(
      data: await generatePrayerTimesForDate(
        latitude: latitude,
        longitude: longitude,
        date: day,
        sectRaw: sectRaw,
      ),
      overridesMinutesSinceMidnight: overridesMinutesSinceMidnight,
      referenceTime: DateTime(day.year, day.month, day.day, 12),
    );
  }

  static CalculationParameters _buildParameters(
    CalculationMethodOption method,
    AsrCalculationOption asr,
    double latitude,
    double longitude,
  ) {
    final params = method.toParams();
    if (!method.isShia) {
      params.madhab = asr.madhab;
    }
    params.highLatitudeRule = HighLatitudeRule.recommended(
      Coordinates(latitude, longitude),
    );
    return params;
  }

  static List<HomePrayerSlot> _buildSlots({
    required double latitude,
    required double longitude,
    required DateTime currentTime,
    required CalculationMethodOption method,
    required AsrCalculationOption asr,
  }) {
    final coordinates = Coordinates(latitude, longitude);
    final params = _buildParameters(method, asr, latitude, longitude);
    final prayerTimes = PrayerTimes(
      date: currentTime,
      coordinates: coordinates,
      calculationParameters: params,
    );

    DateTime normalizeToMinute(DateTime value) {
      // Always pin to [currentTime]'s calendar day so every tile is "today".
      return atDay(currentTime, value.toLocal());
    }

    return <HomePrayerSlot>[
      HomePrayerSlot(id: HomePrayerId.fajr, time: normalizeToMinute(prayerTimes.fajr)),
      HomePrayerSlot(id: HomePrayerId.sunrise, time: normalizeToMinute(prayerTimes.sunrise)),
      HomePrayerSlot(id: HomePrayerId.dhuhr, time: normalizeToMinute(prayerTimes.dhuhr)),
      HomePrayerSlot(id: HomePrayerId.asr, time: normalizeToMinute(prayerTimes.asr)),
      HomePrayerSlot(id: HomePrayerId.maghrib, time: normalizeToMinute(prayerTimes.maghrib)),
      HomePrayerSlot(id: HomePrayerId.isha, time: normalizeToMinute(prayerTimes.isha)),
    ];
  }

  static String _serialize(List<HomePrayerSlot> slots) {
    final payload = slots
        .map(
          (slot) => <String, dynamic>{
            'id': slot.id.name,
            'time': slot.time.toIso8601String(),
          },
        )
        .toList(growable: false);
    return jsonEncode(payload);
  }

  static HomePrayerTimesData? _fromSerialized(String json, DateTime now) {
    try {
      final parsed = jsonDecode(json) as List<dynamic>;
      final slots = parsed
          .map((row) => Map<String, dynamic>.from(row as Map))
          .map((row) {
            final id = HomePrayerId.values.firstWhere(
              (value) => value.name == row['id'],
            );
            final parsed = DateTime.parse(row['time'] as String).toLocal();
            // Re-anchor to [now]'s day so stale/wrong dates cannot leak in.
            return HomePrayerSlot(id: id, time: atDay(now, parsed));
          })
          .toList(growable: false);
      return _buildData(slots, now);
    } catch (_) {
      return null;
    }
  }

  static HomePrayerTimesData _buildData(
    List<HomePrayerSlot> slots,
    DateTime currentTime,
  ) {
    // Wall-clock only — never compare full DateTimes. A slot whose date
    // component drifted to tomorrow (stale cache / UTC mishap) used to keep
    // Dhuhr highlighted all evening while Isha was actually next.
    final next = nextPrayerOnDay(slots: slots, now: currentTime);
    if (next == null) {
      return HomePrayerTimesData(
        slots: slots,
        nextPrayer: null,
        nextPrayerTime: null,
        remaining: Duration.zero,
      );
    }
    final remaining = next.at.difference(currentTime);
    return HomePrayerTimesData(
      slots: slots,
      nextPrayer: next.id,
      nextPrayerTime: next.at,
      remaining: remaining.isNegative ? Duration.zero : remaining,
    );
  }
}
