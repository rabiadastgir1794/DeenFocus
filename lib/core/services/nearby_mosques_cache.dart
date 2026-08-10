import 'dart:convert';
import 'dart:math' as math;

import 'nearby_mosques_service.dart';
import 'storage_service.dart';

/// Persists last fetch coordinates, time, and results for [NearbyMosquesService].
abstract class NearbyMosquesCache {
  static const Duration ttl = Duration(minutes: 15);
  static const double refreshIfMovedMeters = 500;

  static Future<({double lat, double lng, DateTime fetched, List<NearbyMosque> mosques})?> readValid({
    required double latitude,
    required double longitude,
  }) async {
    final cachedLat = await StorageService.nearbyMosquesCacheLatitude;
    final cachedLng = await StorageService.nearbyMosquesCacheLongitude;
    final fetchedMs = await StorageService.nearbyMosquesCacheFetchedMs;
    final json = await StorageService.nearbyMosquesCacheJson;
    if (cachedLat == null ||
        cachedLng == null ||
        fetchedMs == null ||
        json == null ||
        json.isEmpty) {
      return null;
    }

    final moved = _distanceMeters(
      fromLat: cachedLat,
      fromLng: cachedLng,
      toLat: latitude,
      toLng: longitude,
    );
    if (moved > refreshIfMovedMeters) {
      return null;
    }

    final fetched = DateTime.fromMillisecondsSinceEpoch(fetchedMs, isUtc: false);
    if (DateTime.now().difference(fetched) > ttl) {
      return null;
    }

    final list = _decodeMosques(json);
    return (lat: cachedLat, lng: cachedLng, fetched: fetched, mosques: list);
  }

  static Future<({double lat, double lng, DateTime fetched, List<NearbyMosque> mosques})?> readLatest() async {
    final cachedLat = await StorageService.nearbyMosquesCacheLatitude;
    final cachedLng = await StorageService.nearbyMosquesCacheLongitude;
    final fetchedMs = await StorageService.nearbyMosquesCacheFetchedMs;
    final json = await StorageService.nearbyMosquesCacheJson;
    if (cachedLat == null ||
        cachedLng == null ||
        fetchedMs == null ||
        json == null ||
        json.isEmpty) {
      return null;
    }
    final fetched = DateTime.fromMillisecondsSinceEpoch(fetchedMs, isUtc: false);
    return (
      lat: cachedLat,
      lng: cachedLng,
      fetched: fetched,
      mosques: _decodeMosques(json),
    );
  }

  static Future<void> save({
    required double latitude,
    required double longitude,
    required List<NearbyMosque> mosques,
  }) async {
    await StorageService.setNearbyMosquesCache(
      latitude: latitude,
      longitude: longitude,
      fetchedMs: DateTime.now().millisecondsSinceEpoch,
      json: _encodeMosques(mosques),
    );
  }

  static String _encodeMosques(List<NearbyMosque> mosques) {
    final payload = mosques
        .map(
          (m) => <String, dynamic>{
            'id': m.id,
            'name': m.name,
            'address': m.address,
            'latitude': m.latitude,
            'longitude': m.longitude,
            'distanceMeters': m.distanceMeters,
            'confidence': m.confidence.name,
            'openingHours': m.openingHours,
            'googleMapsUri': m.googleMapsUri,
          },
        )
        .toList(growable: false);
    return jsonEncode(payload);
  }

  static List<NearbyMosque> _decodeMosques(String json) {
    try {
      final parsed = jsonDecode(json) as List<dynamic>;
      return parsed
          .map((row) {
            final map = Map<String, dynamic>.from(row as Map);
            return NearbyMosque(
              id: map['id'] as String? ?? '',
              name: map['name'] as String? ?? 'Mosque',
              address: map['address'] as String? ?? '',
              latitude: (map['latitude'] as num?)?.toDouble() ?? 0,
              longitude: (map['longitude'] as num?)?.toDouble() ?? 0,
              distanceMeters: (map['distanceMeters'] as num?)?.toDouble() ?? 0,
              confidence: _decodeConfidence(map['confidence'] as String?),
              openingHours: map['openingHours'] as String?,
              googleMapsUri: map['googleMapsUri'] as String?,
            );
          })
          .toList(growable: false);
    } catch (_) {
      return const [];
    }
  }

  static NearbyMosqueConfidence _decodeConfidence(String? raw) {
    return NearbyMosqueConfidence.values.firstWhere(
      (value) => value.name == raw,
      orElse: () => NearbyMosqueConfidence.high,
    );
  }

  static double _distanceMeters({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) {
    const earthRadius = 6371000.0;
    final dLat = _degToRad(toLat - fromLat);
    final dLng = _degToRad(toLng - fromLng);
    var a =
        _sin2(dLat / 2) +
        (_cosDeg(fromLat) * _cosDeg(toLat) * _sin2(dLng / 2));
    if (a > 1) a = 1;
    if (a < 0) a = 0;
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  static double _degToRad(double d) => d * 0.017453292519943295;

  static double _sin2(double x) {
    final s = math.sin(x);
    return s * s;
  }

  static double _cosDeg(double degrees) => math.cos(_degToRad(degrees));
}
