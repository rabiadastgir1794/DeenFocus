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

/// Parsed OSM `denomination` for a Muslim place of worship.
///
/// Prefer the OSM tag. When the tag is missing or only the broad `sunni`
/// token, a clear Ahl-e-Hadith marker in the mosque name may refine the
/// label — OSM often tags Ahle Hadees masajid as `denomination=sunni`.
@immutable
class NearbyMosqueDenomination {
  const NearbyMosqueDenomination._(this.rawValues);

  /// Empty = tag missing / blank (UI should hide the denomination row).
  static const NearbyMosqueDenomination unspecified =
      NearbyMosqueDenomination._(<String>[]);

  /// Canonical tokens in tag order, de-duplicated.
  final List<String> rawValues;

  bool get isSpecified => rawValues.isNotEmpty;

  /// Parses OSM `denomination` (supports `;`, `,`, `/`, `|` separators).
  factory NearbyMosqueDenomination.fromOsmTag(String? raw) {
    if (raw == null) return unspecified;
    final trimmed = raw.trim();
    if (trimmed.isEmpty) return unspecified;

    final seen = <String>{};
    final out = <String>[];
    for (final part in trimmed.split(RegExp(r'[;,/|]+'))) {
      final token = _normalizeRawToken(part);
      if (token.isEmpty) continue;
      final canonical = _canonicalizeToken(token);
      if (seen.add(canonical)) out.add(canonical);
    }
    if (out.isEmpty) return unspecified;
    return NearbyMosqueDenomination._(List<String>.unmodifiable(out));
  }

  /// OSM tags with optional name refinement for Ahl-e-Hadith.
  static NearbyMosqueDenomination fromTags(Map<String, dynamic> tags) {
    final value = tags['denomination'];
    String? osmRaw;
    if (value is String) {
      osmRaw = value;
    } else if (value != null) {
      osmRaw = value.toString();
    }
    return resolve(osmTag: osmRaw, name: tags['name']?.toString());
  }

  /// Combines an OSM denomination tag with an optional mosque name.
  ///
  /// If the name clearly identifies Ahl-e-Hadith / Ahle Hadees and OSM is
  /// blank or only generic `sunni`, the more specific label wins.
  static NearbyMosqueDenomination resolve({String? osmTag, String? name}) {
    final fromOsm = NearbyMosqueDenomination.fromOsmTag(osmTag);
    final fromName = _ahlEHadithFromName(name);
    if (fromName == null) return fromOsm;
    if (!fromOsm.isSpecified) return fromName;
    final onlyGenericSunni =
        fromOsm.rawValues.length == 1 && fromOsm.rawValues.single == 'sunni';
    if (onlyGenericSunni) return fromName;
    if (fromOsm.rawValues.contains('ahl_e_hadith')) return fromOsm;
    final merged = <String>[
      for (final t in fromOsm.rawValues)
        if (t != 'sunni') t,
      'ahl_e_hadith',
    ];
    final seen = <String>{};
    final out = <String>[
      for (final t in merged)
        if (seen.add(t)) t,
    ];
    return NearbyMosqueDenomination._(List<String>.unmodifiable(out));
  }

  /// True when this denomination includes a Sunni token.
  bool get includesSunni => rawValues.any(_isSunniToken);

  /// True when this denomination includes a Shia token.
  bool get includesShia => rawValues.any(_isShiaToken);

  /// True when this denomination includes an Ahl-e-Hadith token.
  bool get includesAhlEHadith => rawValues.any(_isAhlEHadithToken);

  /// Human-facing labels for known kinds; unknown tokens are title-cased.
  List<String> displayLabels({
    required String sunniLabel,
    required String shiaLabel,
    required String ahlEHadithLabel,
  }) {
    if (!isSpecified) return const <String>[];
    return rawValues
        .map((token) {
          if (_isAhlEHadithToken(token)) return ahlEHadithLabel;
          if (_isSunniToken(token)) return sunniLabel;
          if (_isShiaToken(token)) return shiaLabel;
          return _titleCaseToken(token);
        })
        .toList(growable: false);
  }

  String joinedDisplayLabel({
    required String sunniLabel,
    required String shiaLabel,
    required String ahlEHadithLabel,
    String separator = ' · ',
  }) {
    return displayLabels(
      sunniLabel: sunniLabel,
      shiaLabel: shiaLabel,
      ahlEHadithLabel: ahlEHadithLabel,
    ).join(separator);
  }

  static String _normalizeRawToken(String part) {
    return part
        .trim()
        .toLowerCase()
        .replaceAll(RegExp(r'[\s\-]+'), '_')
        .replaceAll(RegExp(r'_+'), '_');
  }

  static String _canonicalizeToken(String token) {
    if (_isAhlEHadithToken(token)) return 'ahl_e_hadith';
    if (_isSunniToken(token)) return 'sunni';
    if (_isShiaToken(token)) return 'shia';
    return token;
  }

  static bool _isSunniToken(String token) {
    if (_isAhlEHadithToken(token)) return false;
    return token == 'sunni' ||
        token == 'sunnah' ||
        token == 'ahlussunnah' ||
        token == 'ahl_al_sunnah' ||
        token == 'ahle_sunnat' ||
        token == 'ahle_sunnah';
  }

  static bool _isShiaToken(String token) {
    return token == 'shia' ||
        token == 'shiite' ||
        token == "shi'a" ||
        token == 'shi’a' ||
        token == 'shiism' ||
        token == 'twelver' ||
        token == 'jaafari' ||
        token == 'jafari' ||
        token == 'ismaili';
  }

  static bool _isAhlEHadithToken(String token) {
    return token == 'ahl_e_hadith' ||
        token == 'ahle_hadith' ||
        token == 'ahle_hadees' ||
        token == 'ahle_hadis' ||
        token == 'ahl_e_hadees' ||
        token == 'ahl_e_hadis' ||
        token == 'ahlalhadith' ||
        token == 'ahlehadith' ||
        token == 'ahlehadees' ||
        token == 'ahl_al_hadith' ||
        token == 'ahl_al_hadees' ||
        token == 'salafi' ||
        token == 'salafiyya' ||
        token == 'salafism';
  }

  /// Explicit name markers only — no loose guessing from "Jamia" etc.
  static NearbyMosqueDenomination? _ahlEHadithFromName(String? name) {
    if (name == null) return null;
    final normalized = name
        .toLowerCase()
        .replaceAll(RegExp(r'[^\w\s\-]'), ' ')
        .replaceAll('-', ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
    if (normalized.isEmpty) return null;

    const markers = <String>[
      'ahle hadees',
      'ahle hadith',
      'ahle hadis',
      'ahl e hadees',
      'ahl e hadith',
      'ahl e hadis',
      'ahlel hadees',
      'ahlehadees',
      'ahlehadith',
      'ahl al hadith',
      'ahl al hadees',
      'jamat ahle hadith',
      'jamaat ahle hadith',
      'markazi jamiat ahle hadith',
    ];
    for (final marker in markers) {
      if (normalized.contains(marker)) {
        return const NearbyMosqueDenomination._(<String>['ahl_e_hadith']);
      }
    }
    final compact = name.toLowerCase().replaceAll(RegExp(r'[^a-z]'), '');
    if (compact.contains('ahlehadees') ||
        compact.contains('ahlehadith') ||
        compact.contains('ahlalhadith') ||
        compact.contains('ahlehadis')) {
      return const NearbyMosqueDenomination._(<String>['ahl_e_hadith']);
    }
    return null;
  }

  static String _titleCaseToken(String token) {
    final parts = token
        .replaceAll('_', ' ')
        .replaceAll('-', ' ')
        .split(RegExp(r'\s+'))
        .where((p) => p.isNotEmpty);
    return parts
        .map((p) {
          if (p.length == 1) return p.toUpperCase();
          return '${p[0].toUpperCase()}${p.substring(1)}';
        })
        .join(' ');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is NearbyMosqueDenomination &&
        listEquals(other.rawValues, rawValues);
  }

  @override
  int get hashCode => Object.hashAll(rawValues);
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
    this.denomination = NearbyMosqueDenomination.unspecified,
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

  /// OSM `denomination` only — never inferred from other metadata.
  final NearbyMosqueDenomination denomination;

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

  /// VK Maps answers when the FOSSGIS instance is at capacity.
  /// kumi.systems is the old name of private.coffee, and
  /// overpass.openstreetmap.ru was not connecting, so they are not queried.
  /// See: https://wiki.openstreetmap.org/wiki/Overpass_API
  static const _overpassInterpreters = <String>[
    'https://maps.mail.ru/osm/tools/overpass/api/interpreter',
    'https://overpass.private.coffee/api/interpreter',
    'https://overpass-api.de/api/interpreter',
  ];

  static const _overpassRetryEndpoint =
      'https://maps.mail.ru/osm/tools/overpass/api/interpreter';

  static const _overpassUserAgent =
      'Deenly/com.rnr.deenfocus (nearby mosques; +https://www.openstreetmap.org/copyright)';

  /// Preferred first pass, then expand when OSM coverage is thin.
  /// 25 km is only reached when 15 km is still sparse.
  static const List<double> defaultExpandRadiiMeters = <double>[
    5000,
    10000,
    15000,
    25000,
  ];

  /// If fewer than this many mosques are found, try the next wider radius.
  static const int sparseResultThreshold = 12;

  /// Stricter bar before expanding to the widest (25 km) radius in dense areas.
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
    // Indexed tags first. A name scan of every object in a dense city makes
    // Overpass time out, and the client used to report that as no internet.
    final indexed = await _fetchOverpassJson(
      _indexedMosqueQuery(
        latitude: latitude,
        longitude: longitude,
        radiusMeters: radiusMeters,
      ),
    );
    var mosques = _mosquesFromOverpass(
      indexed,
      latitude: latitude,
      longitude: longitude,
    );
    if (mosques.length < sparseResultThreshold) {
      try {
        final named = await _fetchOverpassJson(
          _nameMosqueQuery(
            latitude: latitude,
            longitude: longitude,
            radiusMeters: radiusMeters,
          ),
          retryOnBusy: false,
        );
        mosques = _combineMosques(
          mosques,
          _mosquesFromOverpass(named, latitude: latitude, longitude: longitude),
        );
      } on NearbyMosquesException {
        // Tagged mosques already in hand are more useful than a failed name scan.
      }
    }
    if (mosques.length <= maxResultCount) return mosques;
    return mosques.sublist(0, maxResultCount);
  }

  /// Overpass POSIX regex is byte-oriented and rejects multibyte characters.
  /// "mosqu..e" matches French "mosquée" (é is two bytes).
  static const _namePattern =
      'masjid|mosque|musalla|musallah|mosqu..e|'
      'islamic cent(re|er)|muslim cent(re|er)|jamatkhana';

  static String _indexedMosqueQuery({
    required double latitude,
    required double longitude,
    required double radiusMeters,
  }) {
    final around = 'around:$radiusMeters,$latitude,$longitude';
    return '''
[out:json][timeout:20];
(
  nwr["amenity"="mosque"]($around);
  nwr["building"="mosque"]($around);
  nwr["amenity"="musalla"]($around);
  nwr["building"="musalla"]($around);
  nwr["amenity"="place_of_worship"]["religion"~"muslim|islam|moslem",i]($around);
);
out center tags;
''';
  }

  static String _nameMosqueQuery({
    required double latitude,
    required double longitude,
    required double radiusMeters,
  }) {
    final around = 'around:$radiusMeters,$latitude,$longitude';
    return '''
[out:json][timeout:20];
(
  nwr["building"]["religion"~"muslim|islam|moslem",i]($around);
  nwr["name"~"$_namePattern",i]($around);
  nwr["name:en"~"$_namePattern",i]($around);
  nwr["name:fr"~"$_namePattern",i]($around);
  nwr["name:ur"~"$_namePattern",i]($around);
  nwr["name:ar"~"$_namePattern",i]($around);
  nwr["alt_name"~"$_namePattern",i]($around);
  nwr["official_name"~"$_namePattern",i]($around);
);
out center tags;
''';
  }

  Future<Map<String, dynamic>> _fetchOverpassJson(
    String query, {
    bool retryOnBusy = true,
  }) async {
    try {
      return await _raceOverpass(query, _overpassInterpreters);
    } on NearbyMosquesException catch (error) {
      if (!retryOnBusy || !error.retryable) rethrow;
      await Future<void>.delayed(const Duration(seconds: 2));
      return _raceOverpass(query, const <String>[_overpassRetryEndpoint]);
    }
  }

  Future<Map<String, dynamic>> _raceOverpass(
    String query,
    List<String> endpoints,
  ) {
    // Prefer the first complete result. An empty timeout from a fast mirror
    // must not hide a slower mirror that actually returned mosques.
    final completer = Completer<Map<String, dynamic>>();
    var remaining = endpoints.length;
    var sawRateLimit = false;
    var sawQueryError = false;
    var sawHttp = false;
    Map<String, dynamic>? fallbackBody;
    var fallbackCount = -1;

    for (final endpoint in endpoints) {
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
            if (completer.isCompleted) return;
            if (r.statusCode == 429) {
              sawRateLimit = true;
              sawHttp = true;
              return;
            }
            if (r.statusCode < 200 || r.statusCode >= 300) {
              sawHttp = true;
              return;
            }
            final decoded = _decodeOverpassBody(r.body);
            if (decoded == null) {
              sawHttp = true;
              return;
            }
            sawHttp = true;
            final count = _elementCount(decoded);
            final remark = decoded['remark']?.toString().toLowerCase() ?? '';
            final incomplete =
                remark.contains('timeout') || remark.contains('runtime error');
            // A remark with no elements is a failed query, not an empty area.
            if (incomplete && count == 0) {
              sawQueryError = true;
              return;
            }
            if (count > 0 && !incomplete) {
              completer.complete(decoded);
              return;
            }
            if (count > fallbackCount) {
              fallbackCount = count;
              fallbackBody = decoded;
            }
          })
          .catchError((Object e) {
            if (kDebugMode) debugPrint('[NearbyMosques] $endpoint → error: $e');
          })
          .whenComplete(() {
            remaining--;
            if (remaining > 0 || completer.isCompleted) return;
            final fallback = fallbackBody;
            if (fallback != null) {
              completer.complete(fallback);
              return;
            }
            if (sawRateLimit) {
              completer.completeError(
                const NearbyMosquesException(
                  'The public mosque data service is rate-limiting requests from your '
                  'network (this can happen on the first try on shared Wi-Fi or '
                  'cellular). Try again in a minute or switch network.',
                ),
              );
              return;
            }
            if (sawQueryError) {
              completer.completeError(
                const NearbyMosquesException(
                  'The map service could not return nearby mosques. Please try again.',
                ),
              );
              return;
            }
            completer.completeError(
              NearbyMosquesException(
                sawHttp
                    ? 'The mosque service is busy right now. Please try again.'
                    : 'No internet connection or the map service is unreachable. Check your connection and try again.',
                retryable: true,
              ),
            );
          });
    }

    return completer.future;
  }

  List<NearbyMosque> _mosquesFromOverpass(
    Map<String, dynamic> decoded, {
    required double latitude,
    required double longitude,
  }) {
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
      if (!_acceptMosqueTags(tags)) continue;
      final name = _mosqueName(tags);
      final address = _formatAddress(tags);
      final osmId = '$type/$id';
      final confidence = _confidenceFromTags(tags);
      final openingHours = _openingHoursFromTags(tags);
      final denomination = NearbyMosqueDenomination.fromTags(tags);

      results.add(
        NearbyMosque(
          id: osmId,
          name: name,
          address: address,
          latitude: lat,
          longitude: lon,
          confidence: confidence,
          openingHours: openingHours,
          denomination: denomination,
          distanceMeters: _distanceMeters(
            fromLat: latitude,
            fromLng: longitude,
            toLat: lat,
            toLng: lon,
          ),
        ),
      );
    }

    return _combineMosques(results, const <NearbyMosque>[]);
  }

  List<NearbyMosque> _combineMosques(
    List<NearbyMosque> first,
    List<NearbyMosque> second,
  ) {
    final byId = <String, NearbyMosque>{};
    for (final mosque in first) {
      byId[mosque.id] = mosque;
    }
    for (final mosque in second) {
      byId.putIfAbsent(mosque.id, () => mosque);
    }
    final sorted = byId.values.toList()
      ..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
    return dedupeNearbyDuplicates(sorted);
  }

  static bool _preferNearbyMosque(
    NearbyMosque candidate,
    NearbyMosque existing,
  ) {
    if (candidate.confidence.rank < existing.confidence.rank) return true;
    if (candidate.confidence.rank > existing.confidence.rank) return false;
    if (existing.name == 'Mosque' && candidate.name != 'Mosque') return true;
    if (candidate.name == 'Mosque' && existing.name != 'Mosque') return false;
    if (candidate.denomination.isSpecified &&
        !existing.denomination.isSpecified) {
      return true;
    }
    if (!candidate.denomination.isSpecified &&
        existing.denomination.isSpecified) {
      return false;
    }
    return candidate.distanceMeters < existing.distanceMeters;
  }

  /// Merge duplicates of the same physical mosque (~40 m + similar name).
  static List<NearbyMosque> dedupeNearbyDuplicates(List<NearbyMosque> sorted) =>
      _dedupeNearbyDuplicates(sorted);

  static List<NearbyMosque> _dedupeNearbyDuplicates(List<NearbyMosque> sorted) {
    const clusterMeters = 40.0;
    final kept = <NearbyMosque>[];

    for (final candidate in sorted) {
      final candidateKey = _normalizeNameKey(candidate.name);
      var merged = false;
      for (var i = 0; i < kept.length; i++) {
        final existing = kept[i];
        final existingKey = _normalizeNameKey(existing.name);
        final similarName =
            candidateKey.isNotEmpty &&
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

  static final RegExp _mosqueNamePattern = RegExp(
    r'masjid|mosque|musalla|musallah|masallaci|mosqu[eé]e|'
    r'islamic\s+cent(?:re|er)|muslim\s+cent(?:re|er)|jamatkhana|مسجد',
    caseSensitive: false,
  );

  static const Set<String> _otherFeatureKeys = <String>{
    'highway',
    'railway',
    'waterway',
    'aerialway',
    'route',
    'shop',
    'office',
    'craft',
    'leisure',
    'landuse',
    'natural',
    'tourism',
    'man_made',
    'power',
    'barrier',
  };

  static const Set<String> _otherAmenities = <String>{
    'restaurant',
    'cafe',
    'fast_food',
    'food_court',
    'bar',
    'pub',
    'school',
    'college',
    'university',
    'kindergarten',
    'hospital',
    'clinic',
    'pharmacy',
    'fuel',
    'bank',
    'atm',
    'parking',
    'bus_station',
  };

  static Map<String, dynamic>? _decodeOverpassBody(String body) {
    try {
      final raw = jsonDecode(body);
      if (raw is Map<String, dynamic>) return raw;
      if (raw is Map) return Map<String, dynamic>.from(raw);
    } on FormatException {
      return null;
    }
    return null;
  }

  static int _elementCount(Map<String, dynamic> decoded) {
    final elements = decoded['elements'];
    return elements is List ? elements.length : 0;
  }

  static bool _acceptMosqueTags(Map<String, dynamic> tags) {
    if (_isClosedFeature(tags)) return false;
    if (_isTaggedMosque(tags)) return true;
    return _nameLooksLikeMosque(tags) && !_isOtherFeature(tags);
  }

  static bool _isClosedFeature(Map<String, dynamic> tags) {
    if (tags['ruins']?.toString() == 'yes') return true;
    if (tags['historic']?.toString() == 'ruins') return true;
    for (final key in tags.keys) {
      final name = key.toString();
      const prefixes = <String>[
        'disused:',
        'abandoned:',
        'demolished:',
        'razed:',
        'removed:',
        'was:',
      ];
      for (final prefix in prefixes) {
        if (!name.startsWith(prefix)) continue;
        final rest = name.substring(prefix.length);
        if (rest == 'amenity' ||
            rest == 'building' ||
            rest == 'religion' ||
            rest.startsWith('name')) {
          return true;
        }
      }
    }
    return false;
  }

  static bool _isTaggedMosque(Map<String, dynamic> tags) {
    final amenity = tags['amenity']?.toString().toLowerCase();
    final building = tags['building']?.toString().toLowerCase() ?? '';
    if (amenity == 'mosque' || amenity == 'musalla') return true;
    if (building == 'mosque' || building == 'musalla') return true;
    if (!_religionIsMuslim(tags['religion']?.toString())) return false;
    return amenity == 'place_of_worship' ||
        (building.isNotEmpty && building != 'no');
  }

  static bool _religionIsMuslim(String? religion) {
    if (religion == null || religion.trim().isEmpty) return false;
    final value = religion.toLowerCase();
    return value.contains('muslim') ||
        value.contains('islam') ||
        value.contains('moslem');
  }

  static bool _nameLooksLikeMosque(Map<String, dynamic> tags) {
    for (final key in const <String>[
      'name',
      'name:en',
      'name:fr',
      'name:ur',
      'name:ar',
      'alt_name',
      'official_name',
    ]) {
      final value = tags[key]?.toString();
      if (value != null && _mosqueNamePattern.hasMatch(value)) return true;
    }
    return false;
  }

  static bool _isOtherFeature(Map<String, dynamic> tags) {
    for (final key in _otherFeatureKeys) {
      if (!tags.containsKey(key)) continue;
      if (key == 'landuse' &&
          tags['landuse']?.toString().toLowerCase() == 'religious') {
        continue;
      }
      return true;
    }
    final amenity = tags['amenity']?.toString().toLowerCase();
    if (amenity == null) return false;
    if (_otherAmenities.contains(amenity)) return true;
    return amenity == 'place_of_worship' &&
        !_religionIsMuslim(tags['religion']?.toString());
  }

  static NearbyMosqueConfidence _confidenceFromTags(Map<String, dynamic> tags) {
    final amenity = tags['amenity']?.toString().toLowerCase();
    final building = tags['building']?.toString().toLowerCase();

    if (amenity == 'place_of_worship' &&
        _religionIsMuslim(tags['religion']?.toString())) {
      return NearbyMosqueConfidence.high;
    }
    if (amenity == 'mosque') return NearbyMosqueConfidence.high;
    if (building == 'mosque') return NearbyMosqueConfidence.medium;
    if (_religionIsMuslim(tags['religion']?.toString()) &&
        building != null &&
        building.isNotEmpty &&
        building != 'no') {
      return NearbyMosqueConfidence.medium;
    }
    if (building == 'musalla' || amenity == 'musalla') {
      return NearbyMosqueConfidence.low;
    }
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
      'name:fr',
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
      if (tags['addr:housenumber'] is String)
        tags['addr:housenumber'] as String,
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
  }) => _staticDistanceMeters(
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
  const NearbyMosquesException(this.message, {this.retryable = false});

  final String message;

  /// True when another attempt may succeed (capacity or a dropped connection).
  final bool retryable;

  @override
  String toString() => message;
}
