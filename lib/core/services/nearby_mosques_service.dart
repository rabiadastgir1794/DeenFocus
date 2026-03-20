import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../config/app_config.dart';

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
  final String? googleMapsUri;
}

class NearbyMosquesService {
  NearbyMosquesService({http.Client? client})
    : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<NearbyMosque>> fetchNearby({
    required double latitude,
    required double longitude,
    double radiusMeters = 5000,
    int maxResultCount = 12,
  }) async {
    if (!AppConfig.hasGoogleMapsApiKey) {
      throw const NearbyMosquesException(
        'Add a Google Maps API key to load nearby mosques.',
      );
    }

    final uri = Uri.parse(
      'https://places.googleapis.com/v1/places:searchNearby',
    );
    final response = await _client
        .post(
          uri,
          headers: <String, String>{
            'Content-Type': 'application/json',
            'X-Goog-Api-Key': AppConfig.googleMapsApiKey,
            'X-Goog-FieldMask':
                'places.id,places.displayName,places.formattedAddress,places.location,places.googleMapsUri',
          },
          body: jsonEncode(<String, dynamic>{
            'includedTypes': const <String>['mosque'],
            'maxResultCount': maxResultCount,
            'locationRestriction': <String, dynamic>{
              'circle': <String, dynamic>{
                'center': <String, double>{
                  'latitude': latitude,
                  'longitude': longitude,
                },
                'radius': radiusMeters,
              },
            },
          }),
        )
        .timeout(const Duration(seconds: 25));

    if (response.statusCode < 200 || response.statusCode >= 300) {
      throw NearbyMosquesException(
        'Google Places request failed (${response.statusCode}).',
      );
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final places = decoded['places'] as List<dynamic>? ?? const <dynamic>[];

    return places
        .whereType<Map<String, dynamic>>()
        .map((place) {
          final location =
              place['location'] as Map<String, dynamic>? ?? const {};
          final lat = (location['latitude'] as num?)?.toDouble();
          final lng = (location['longitude'] as num?)?.toDouble();
          final nameMap =
              place['displayName'] as Map<String, dynamic>? ?? const {};
          final name = (nameMap['text'] as String?)?.trim() ?? '';
          final address = (place['formattedAddress'] as String?)?.trim() ?? '';
          if (lat == null || lng == null || name.isEmpty) {
            return null;
          }

          return NearbyMosque(
            id: (place['id'] as String?)?.trim() ?? name,
            name: name,
            address: address,
            latitude: lat,
            longitude: lng,
            distanceMeters: _distanceMeters(
              fromLat: latitude,
              fromLng: longitude,
              toLat: lat,
              toLng: lng,
            ),
            googleMapsUri: (place['googleMapsUri'] as String?)?.trim(),
          );
        })
        .whereType<NearbyMosque>()
        .toList(growable: false)
      ..sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
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
