import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

/// How strongly OSM tags indicate an active mosque (not just a building outline).
enum NearbyMosqueConfidence {
  /// `amenity=mosque` or `place_of_worship` + muslim/islam religion.
  high(0),

  /// `building=mosque` without a stronger amenity tag.
  medium(1),

  /// `building=musalla` only — may be a prayer space, not a full masjid.
  low(2);

  const NearbyMosqueConfidence(this.rank);

  final int rank;
}

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
    this.confidence = NearbyMosqueConfidence.high,
    this.openingHours,
    this.googleMapsUri,
  });

  final String id;
  final String name;
  final String address;
  final double latitude;
  final double longitude;
  final double distanceMeters;
  final NearbyMosqueConfidence confidence;

  /// Raw OSM `opening_hours` when present; not parsed into open/closed status.
  final String? openingHours;

  /// Optional deep link; not set for OSM-sourced results.
  final String? googleMapsUri;
}

/// Result of a nearby search, including the radius that was actually used
/// (may be larger than the preferred radius after auto-expand).
@immutable
class NearbyMosquesQueryResult {
  const NearbyMosquesQueryResult({
    required this.mosques,
    required this.radiusMeters,
  });

  final List<NearbyMosque> mosques;
  final double radiusMeters;

  int get radiusKm => (radiusMeters / 1000).round();
}

class NearbyMosquesService {
  NearbyMosquesService({http.Client? client})
    : _client = client ?? http.Client();

  /// Prefer mirrors that are less often overloaded than the main FOSSGIS instance.
  /// See: https://wiki.openstreetmap.org/wiki/Overpass_API
  static const _overpassInterpreters = <String>[
    'https://overpass.private.coffee/api/interpreter',
    'https://overpass.kumi.systems/api/interpreter',
    'https://overpass-api.de/api/interpreter',
    'https://maps.mail.ru/osm/tools/overpass/api/interpreter',
    'https://overpass.openstreetmap.ru/api/interpreter',
  ];

  static const _overpassUserAgent =
      'Deenly/com.rnr.deenfocus (nearby mosques; +https://www.openstreetmap.org/copyright)';

  /// Preferred first pass, then expand when OSM coverage is thin.
  static const List<double> defaultExpandRadiiMeters = <double>[
    5000,
    10000,
    15000,
  ];

  /// If fewer than this many mosques are found, try the next wider radius.
  static const int sparseResultThreshold = 12;

  /// Stricter bar before expanding to the widest (15 km) radius in dense areas.
  static const int sparseResultThresholdForMaxRadius = 8;

  static const int defaultMaxResultCount = 100;

  final http.Client _client;

  /// Fetches nearby mosques, expanding radius when the area is sparse on OSM.
  Future<NearbyMosquesQueryResult> fetchNearbyExpanding({
    required double latitude,
    required double longitude,
    List<double> radiiMeters = defaultExpandRadiiMeters,
    int sparseThreshold = sparseResultThreshold,
    int maxResultCount = defaultMaxResultCount,
  }) async {
    assert(radiiMeters.isNotEmpty);
    List<NearbyMosque> best = const <NearbyMosque>[];
    var usedRadius = radiiMeters.first;

    for (var i = 0; i < radiiMeters.length; i++) {
      final radius = radiiMeters[i];
      usedRadius = radius;
      final batch = await fetchNearby(
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radius,
        maxResultCount: maxResultCount,
      );
      best = batch;
      final hasWiderRadius = i < radiiMeters.length - 1;
      if (!hasWiderRadius) break;
      final threshold = i == radiiMeters.length - 2
          ? sparseResultThresholdForMaxRadius
          : sparseThreshold;
      if (batch.length >= threshold) break;
    }

    return NearbyMosquesQueryResult(mosques: best, radiusMeters: usedRadius);
  }

  Future<List<NearbyMosque>> fetchNearby({
    required double latitude,
    required double longitude,
    double radiusMeters = 5000,
    int maxResultCount = defaultMaxResultCount,
  }) async {
    // Broad OSM tagging coverage: amenity=mosque, building=mosque/musalla,
    // and place_of_worship with muslim/islam religion (case-insensitive).
    final query = '''
[out:json][timeout:35];
(
  node["amenity"="mosque"](around:$radiusMeters,$latitude,$longitude);
  way["amenity"="mosque"](around:$radiusMeters,$latitude,$longitude);
  relation["amenity"="mosque"](around:$radiusMeters,$latitude,$longitude);
  node["building"="mosque"](around:$radiusMeters,$latitude,$longitude);
  way["building"="mosque"](around:$radiusMeters,$latitude,$longitude);
  relation["building"="mosque"](around:$radiusMeters,$latitude,$longitude);
  node["building"="musalla"](around:$radiusMeters,$latitude,$longitude);
  way["building"="musalla"](around:$radiusMeters,$latitude,$longitude);
  node["amenity"="place_of_worship"]["religion"~"muslim|islam",i](around:$radiusMeters,$latitude,$longitude);
  way["amenity"="place_of_worship"]["religion"~"muslim|islam",i](around:$radiusMeters,$latitude,$longitude);
  relation["amenity"="place_of_worship"]["religion"~"muslim|islam",i](around:$radiusMeters,$latitude,$longitude);
);
out center tags;
''';

    // Fire all endpoints in parallel — complete on the first 2xx response.
    final completer = Completer<http.Response>();
    int remaining = _overpassInterpreters.length;

    for (final endpoint in _overpassInterpreters) {
      _client
          .post(
            Uri.parse(endpoint),
            headers: const <String, String>{
              'Content-Type': 'text/plain; charset=utf-8',
              'Accept': 'application/json',
              'User-Agent': _overpassUserAgent,
            },
            body: query,
          )
          .timeout(const Duration(seconds: 25))
          .then((r) {
            if (kDebugMode) {
              debugPrint('[NearbyMosques] $endpoint → HTTP ${r.statusCode}');
            }
            if (r.statusCode >= 200 && r.statusCode < 300) {
              if (!completer.isCompleted) completer.complete(r);
            }
          })
          .catchError((Object e) {
            if (kDebugMode) debugPrint('[NearbyMosques] $endpoint → error: $e');
          })
          .whenComplete(() {
            remaining--;
            if (remaining == 0 && !completer.isCompleted) {
              completer.completeError(
                const NearbyMosquesException(
                  'No internet connection or the map service is unreachable. Check your connection and try again.',
                ),
              );
            }
          });
    }

    final http.Response response;
    try {
      response = await completer.future;
    } on NearbyMosquesException {
      rethrow;
    }

    if (response.statusCode == 429) {
      throw const NearbyMosquesException(
        'The public mosque data service is rate-limiting requests from your '
        'network (this can happen on the first try on shared Wi-Fi or '
        'cellular). Try again in a minute or switch network.',
      );
    }
    if (response.statusCode >= 500) {
      throw const NearbyMosquesException(
        'The mosque data service is temporarily unavailable. Please try again in a moment.',
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
      final confidence = _confidenceFromTags(tags);
      final openingHours = _openingHoursFromTags(tags);

      results.add(
        NearbyMosque(
          id: osmId,
          name: name,
          address: address,
          latitude: lat,
          longitude: lon,
          confidence: confidence,
          openingHours: openingHours,
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

    final byId = <NearbyMosque>[];
    final seenIds = <String>{};
    for (final m in results) {
      if (seenIds.add(m.id)) byId.add(m);
    }

    final deduped = _dedupeNearbyDuplicates(byId);
    if (deduped.length <= maxResultCount) return deduped;
    return deduped.sublist(0, maxResultCount);
  }

  static bool _preferNearbyMosque(NearbyMosque candidate, NearbyMosque existing) {
    if (candidate.confidence.rank < existing.confidence.rank) return true;
    if (candidate.confidence.rank > existing.confidence.rank) return false;
    if (existing.name == 'Mosque' && candidate.name != 'Mosque') return true;
    if (candidate.name == 'Mosque' && existing.name != 'Mosque') return false;
    return candidate.distanceMeters < existing.distanceMeters;
  }

  /// Merge OSM node/way duplicates of the same physical mosque (~40 m + similar name).
  static List<NearbyMosque> _dedupeNearbyDuplicates(List<NearbyMosque> sorted) {
    const clusterMeters = 40.0;
    final kept = <NearbyMosque>[];

    for (final candidate in sorted) {
      final candidateKey = _normalizeNameKey(candidate.name);
      var merged = false;
      for (var i = 0; i < kept.length; i++) {
        final existing = kept[i];
        final existingKey = _normalizeNameKey(existing.name);
        final similarName = candidateKey.isNotEmpty &&
            existingKey.isNotEmpty &&
            (candidateKey == existingKey ||
                candidateKey.contains(existingKey) ||
                existingKey.contains(candidateKey));
        if (!similarName) continue;
        final d = _staticDistanceMeters(
          fromLat: existing.latitude,
          fromLng: existing.longitude,
          toLat: candidate.latitude,
          toLng: candidate.longitude,
        );
        if (d <= clusterMeters) {
          if (_preferNearbyMosque(candidate, existing)) {
            kept[i] = candidate;
          }
          merged = true;
          break;
        }
      }
      if (!merged) kept.add(candidate);
    }
    kept.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    return kept;
  }

  static NearbyMosqueConfidence _confidenceFromTags(Map<String, dynamic> tags) {
    final amenity = tags['amenity']?.toString().toLowerCase();
    final religion = tags['religion']?.toString().toLowerCase() ?? '';
    final building = tags['building']?.toString().toLowerCase();

    if (amenity == 'place_of_worship' &&
        (religion.contains('muslim') || religion.contains('islam'))) {
      return NearbyMosqueConfidence.high;
    }
    if (amenity == 'mosque') return NearbyMosqueConfidence.high;
    if (building == 'mosque') return NearbyMosqueConfidence.medium;
    if (building == 'musalla') return NearbyMosqueConfidence.low;
    return NearbyMosqueConfidence.low;
  }

  static String? _openingHoursFromTags(Map<String, dynamic> tags) {
    final value = tags['opening_hours'];
    if (value is String && value.trim().isNotEmpty) return value.trim();
    return null;
  }

  static String _normalizeNameKey(String name) {
    var s = name.toLowerCase().trim();
    if (s == 'mosque' || s == 'masjid') return '';
    s = s
        .replaceAll(RegExp(r'[^a-z0-9\u0600-\u06ff\s]'), ' ')
        .replaceAll(
          RegExp(
            r'\b(jamia|jami|masjid|mosque|markaz|islamic|centre|center|jame)\b',
          ),
          ' ',
        )
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    return s;
  }

  static String _mosqueName(Map<String, dynamic> tags) {
    for (final key in const [
      'name',
      'name:en',
      'official_name',
      'alt_name',
      'name:ur',
      'name:ar',
    ]) {
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
      if (tags['addr:suburb'] is String) tags['addr:suburb'] as String,
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
  }) =>
      _staticDistanceMeters(
        fromLat: fromLat,
        fromLng: fromLng,
        toLat: toLat,
        toLng: toLng,
      );

  static double _staticDistanceMeters({
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

  static double _degreesToRadians(double degrees) =>
      degrees * 0.017453292519943295;

  static double _sinSquared(double value) {
    final sinValue = math.sin(value);
    return sinValue * sinValue;
  }

  static double _cosRadians(double degrees) =>
      math.cos(_degreesToRadians(degrees));
}

class NearbyMosquesException implements Exception {
  const NearbyMosquesException(this.message);

  final String message;

  @override
  String toString() => message;
}
