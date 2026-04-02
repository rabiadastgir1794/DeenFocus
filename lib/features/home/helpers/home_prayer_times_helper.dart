import 'dart:convert';

import 'package:adhan/adhan.dart';
import 'package:intl/intl.dart';

import '../../../core/services/storage_service.dart';
import '../../onboarding/model/sect_option.dart';
import '../model/home_models.dart';

abstract class HomePrayerTimesHelper {
  static final DateFormat _dayKeyFormat = DateFormat('yyyy-MM-dd');

  static Future<HomePrayerTimesData> generatePrayerTimesForDate({
    required double latitude,
    required double longitude,
    required DateTime date,
    String? sectRaw,
  }) async {
    final normalizedDate = DateTime(date.year, date.month, date.day, 12);
    final sect = _resolveSect(sectRaw ?? await StorageService.sect);
    final slots = _buildSlots(
      latitude: latitude,
      longitude: longitude,
      currentTime: normalizedDate,
      sect: sect,
    );
    return _buildData(slots, normalizedDate);
  }

  static Future<HomePrayerTimesData> getOrGeneratePrayerTimes({
    required double latitude,
    required double longitude,
    DateTime? now,
  }) async {
    final currentTime = now ?? DateTime.now();
    final dayKey = _dayKeyFormat.format(currentTime);

    final cachedDate = await StorageService.homePrayerCacheDate;
    final cachedLat = await StorageService.homePrayerCacheLatitude;
    final cachedLng = await StorageService.homePrayerCacheLongitude;
    final cachedSect = await StorageService.homePrayerCacheSect;
    final cachedJson = await StorageService.homePrayerCacheJson;
    final storedSect = await StorageService.sect;
    final sect = _resolveSect(storedSect);

    final hasMatchingCache =
        cachedDate == dayKey &&
        cachedLat != null &&
        cachedLng != null &&
        cachedSect == sect.name &&
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
      sect: sect,
    );

    final data = _buildData(slots, currentTime);
    await StorageService.setHomePrayerCache(
      dateKey: dayKey,
      latitude: latitude,
      longitude: longitude,
      sect: sect.name,
      serializedTimes: _serialize(slots),
    );
    return data;
  }

  static SectOption _resolveSect(String? raw) {
    switch (raw) {
      case 'shia':
        return SectOption.shia;
      case 'sunni':
        return SectOption.sunni;
      case 'preferNotToSay':
      default:
        return SectOption.sunni;
    }
  }

  static CalculationParameters _parametersForSect(SectOption sect) {
    if (sect == SectOption.shia) {
      return CalculationMethod.tehran.getParameters();
    }

    return CalculationMethod.karachi.getParameters()..madhab = Madhab.shafi;
  }

  static List<HomePrayerSlot> _buildSlots({
    required double latitude,
    required double longitude,
    required DateTime currentTime,
    required SectOption sect,
  }) {
    final coordinates = Coordinates(latitude, longitude);
    final params = _parametersForSect(sect);
    final prayerTimes = PrayerTimes(
      coordinates,
      DateComponents.from(currentTime),
      params,
    );

    DateTime normalizeToMinute(DateTime value) =>
        DateTime(value.year, value.month, value.day, value.hour, value.minute);

    return <HomePrayerSlot>[
      HomePrayerSlot(
        id: HomePrayerId.fajr,
        time: normalizeToMinute(prayerTimes.fajr),
      ),
      HomePrayerSlot(
        id: HomePrayerId.sunrise,
        time: normalizeToMinute(prayerTimes.sunrise),
      ),
      HomePrayerSlot(
        id: HomePrayerId.dhuhr,
        time: normalizeToMinute(prayerTimes.dhuhr),
      ),
      HomePrayerSlot(
        id: HomePrayerId.asr,
        time: normalizeToMinute(prayerTimes.asr),
      ),
      HomePrayerSlot(
        id: HomePrayerId.maghrib,
        time: normalizeToMinute(prayerTimes.maghrib),
      ),
      HomePrayerSlot(
        id: HomePrayerId.isha,
        time: normalizeToMinute(prayerTimes.isha),
      ),
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
