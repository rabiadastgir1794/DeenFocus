import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// Fetches nearby mosques from OpenStreetMap via the public Overpass API (no API key).
@immutable
class NearbyMosque {
  const NearbyMosque({
    required this.id,
    required this.name,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.distanceMeters,
    this.googleMapsUri,
  });

  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distanceMeters;

  /// Optional deep link; not set for OSM-sourced results.
  final String? googleMapsUri;
}

class NearbyMosquesService {
  NearbyMosquesService({http.Client? client})
    : _client = client ?? http.Client();

  static const _overpassInterpreters = <String>[
    'https://overpass-api.de/api/interpreter',
    'https://overpass.kumi.systems/api/interpreter',
  ];

  final http.Client _client;

  Future<List<NearbyMosque>> fetchNearby({
    required double latitude,
    required double longitude,
    double radiusMeters = 5000,
    int maxResultCount = 40,
  }) async {
    final query = '''
[out:json][timeout:25];
(
  node["amenity"="mosque"](around:$radiusMeters,$latitude,$longitude);
  way["amenity"="mosque"](around:$radiusMeters,$latitude,$longitude);
  relation["amenity"="mosque"](around:$radiusMeters,$latitude,$longitude);
  node["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusMeters,$latitude,$longitude);
  way["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusMeters,$latitude,$longitude);
  relation["amenity"="place_of_worship"]["religion"="muslim"](around:$radiusMeters,$latitude,$longitude);
);
out center;
''';

    http.Response? response;
    for (final endpoint in _overpassInterpreters) {
      try {
        response = await _client
            .post(
              Uri.parse(endpoint),
              headers: const <String, String>{
                'Content-Type': 'text/plain; charset=utf-8',
                'Accept': 'application/json',
              },
              body: query,
            )
            .timeout(const Duration(seconds: 35));
        if (response.statusCode >= 200 && response.statusCode < 300) {
          break;
        }
      } catch (_) {}
    }

    if (response == null) {
      throw const NearbyMosquesException(
        'No internet connection or the map service is unreachable. Check your connection and try again.',
      );
    }

    if (response.statusCode == 429) {
      throw const NearbyMosquesException(
        'Too many map requests. Please try again in a minute.',
      );
    }
    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw const NearbyMosquesException(
        'Could not load nearby mosques. Check your internet connection and try again.',
      );
    }

    late final Map<String, dynamic> decoded;
    try {
      final raw = jsonDecode(response.body);
      if (raw is! Map<String, dynamic>) {
        throw const FormatException('not a map');
      }
      decoded = raw;
    } on FormatException {
      throw const NearbyMosquesException(
        'We could not read the mosque list right now. Please try again later.',
      );
    }

    final elements = decoded['elements'] as List<dynamic>? ?? const <dynamic>[];
    final results = <NearbyMosque>[];

    for (final raw in elements) {
      if (raw is! Map<String, dynamic>) continue;
      final type = raw['type'] as String?;
      final id = raw['id'];
      if (type == null || id == null) continue;

      double? lat;
      double? lon;
      if (type == 'node') {
        lat = (raw['lat'] as num?)?.toDouble();
        lon = (raw['lon'] as num?)?.toDouble();
      } else if (type == 'way' || type == 'relation') {
        final center = raw['center'] as Map<String, dynamic>?;
        if (center != null) {
          lat = (center['lat'] as num?)?.toDouble();
          lon = (center['lon'] as num?)?.toDouble();
        }
      }
      if (lat == null || lon == null) continue;

      final tags = raw['tags'] as Map<String, dynamic>? ?? const {};
      final name = _mosqueName(tags);
      final address = _formatAddress(tags);
      final osmId = '$type/$id';

      results.add(
        NearbyMosque(
          id: osmId,
          name: name,
          address: address,
          latitude: lat,
          longitude: lon,
          distanceMeters: _distanceMeters(
            fromLat: latitude,
            fromLng: longitude,
            toLat: lat,
            toLng: lon,
          ),
        ),
      );
    }

    results.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));

    final deduped = <NearbyMosque>[];
    final seen = <String>{};
    for (final m in results) {
      if (seen.add(m.id)) {
        deduped.add(m);
        if (deduped.length >= maxResultCount) break;
      }
    }

    return deduped;
  }

  static String _mosqueName(Map<String, dynamic> tags) {
    for (final key in const ['name', 'name:en', 'official_name']) {
      final v = tags[key];
      if (v is String && v.trim().isNotEmpty) return v.trim();
    }
    return 'Mosque';
  }

  static String _formatAddress(Map<String, dynamic> tags) {
    final full = tags['addr:full'];
    if (full is String && full.trim().isNotEmpty) return full.trim();

    final parts = <String>[
      if (tags['addr:housenumber'] is String) tags['addr:housenumber'] as String,
      if (tags['addr:street'] is String) tags['addr:street'] as String,
      if (tags['addr:city'] is String) tags['addr:city'] as String,
      if (tags['addr:country'] is String) tags['addr:country'] as String,
    ].map((s) => s.trim()).where((s) => s.isNotEmpty).toList();

    if (parts.isNotEmpty) return parts.join(', ');
    return 'OpenStreetMap';
  }

  double _distanceMeters({
    required double fromLat,
    required double fromLng,
    required double toLat,
    required double toLng,
  }) {
    const earthRadius = 6371000.0;
    final dLat = _degreesToRadians(toLat - fromLat);
    final dLng = _degreesToRadians(toLng - fromLng);
    final a =
        (_sinSquared(dLat / 2)) +
        (_cosRadians(fromLat) * _cosRadians(toLat) * _sinSquared(dLng / 2));
    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));
    return earthRadius * c;
  }

  double _degreesToRadians(double degrees) => degrees * 0.017453292519943295;

  double _sinSquared(double value) {
    final sinValue = math.sin(value);
    return sinValue * sinValue;
  }

  double _cosRadians(double degrees) => math.cos(_degreesToRadians(degrees));
}

class NearbyMosquesException implements Exception {
  const NearbyMosquesException(this.message);

  final String message;

  @override
  String toString() => message;
}
