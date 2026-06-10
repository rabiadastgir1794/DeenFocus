import 'dart:convert';

import 'package:adhan_dart/adhan_dart.dart';
import 'package:intl/intl.dart';

import '../../../core/services/storage_service.dart';
import '../../onboarding/model/asr_calculation_option.dart';
import '../../onboarding/model/calculation_method_option.dart';
import '../model/home_models.dart';

abstract class HomePrayerTimesHelper {
  static final DateFormat _dayKeyFormat = DateFormat('yyyy-MM-dd');
  static const String _cacheVersion = 'v3';

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
      final local = value.toLocal();
      return DateTime(local.year, local.month, local.day, local.hour, local.minute);
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
            final time = DateTime.parse(row['time'] as String).toLocal();
            return HomePrayerSlot(id: id, time: time);
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
    HomePrayerSlot? nextSlot;
    for (final slot in slots) {
      if (slot.time.isAfter(currentTime)) {
        nextSlot = slot;
        break;
      }
    }

    if (nextSlot != null) {
      final remaining = nextSlot.time.difference(currentTime);
      return HomePrayerTimesData(
        slots: slots,
        nextPrayer: nextSlot.id,
        nextPrayerTime: nextSlot.time,
        remaining: remaining.isNegative ? Duration.zero : remaining,
      );
    }

    // All prayers for today have passed. Keep Isha highlighted in today's list,
    // but count down to tomorrow's Fajr instead of midnight.
    final fajr = slots.firstWhere(
      (s) => s.id == HomePrayerId.fajr,
      orElse: () => slots.first,
    );
    final nextFajr = fajr.time.add(const Duration(days: 1));
    final remaining = nextFajr.difference(currentTime);

    return HomePrayerTimesData(
      slots: slots,
      nextPrayer: HomePrayerId.isha,
      nextPrayerTime: nextFajr,
      remaining: remaining.isNegative ? Duration.zero : remaining,
    );
  }
}
