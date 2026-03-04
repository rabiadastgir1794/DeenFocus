import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../core/config/app_config.dart';
import '../model/location_suggestion.dart';

class PlacesApiClient {
  PlacesApiClient({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;

  Future<List<LocationSuggestion>> searchCities(String query) async {
    final trimmedQuery = query.trim();
    if (trimmedQuery.length < 2 || !AppConfig.hasGoogleMapsApiKey) {
      return const [];
    }

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/autocomplete/json',
      <String, String>{
        'input': trimmedQuery,
        'types': '(cities)',
        'key': AppConfig.googleMapsApiKey,
      },
    );

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      return const [];
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final status = decoded['status'] as String?;
    if (status != 'OK' && status != 'ZERO_RESULTS') {
      return const [];
    }

    final predictions = (decoded['predictions'] as List<dynamic>? ?? const []);
    return predictions
        .map((item) {
          final map = item as Map<String, dynamic>;
          final formatting =
              map['structured_formatting'] as Map<String, dynamic>?;
          final mainText = formatting?['main_text'] as String? ?? '';
          final secondaryText = formatting?['secondary_text'] as String? ?? '';
          if (mainText.isEmpty && secondaryText.isEmpty) {
            final description = map['description'] as String? ?? '';
            if (description.isEmpty) return null;
            final parts = description.split(',');
            final title = parts.first.trim();
            final subtitle = parts.skip(1).join(',').trim();
            return LocationSuggestion(
              title: title,
              subtitle: subtitle,
              placeId: map['place_id'] as String?,
            );
          }
          return LocationSuggestion(
            title: mainText,
            subtitle: secondaryText,
            placeId: map['place_id'] as String?,
          );
        })
        .whereType<LocationSuggestion>()
        .toList(growable: false);
  }

  Future<({double latitude, double longitude})?> fetchPlaceCoordinates(
    String placeId,
  ) async {
    final trimmedPlaceId = placeId.trim();
    if (trimmedPlaceId.isEmpty || !AppConfig.hasGoogleMapsApiKey) {
      return null;
    }

    final uri = Uri.https(
      'maps.googleapis.com',
      '/maps/api/place/details/json',
      <String, String>{
        'place_id': trimmedPlaceId,
        'fields': 'geometry',
        'key': AppConfig.googleMapsApiKey,
      },
    );

    final response = await _client.get(uri);
    if (response.statusCode != 200) {
      return null;
    }

    final decoded = jsonDecode(response.body) as Map<String, dynamic>;
    final status = decoded['status'] as String?;
    if (status != 'OK') {
      return null;
    }

    final result = decoded['result'] as Map<String, dynamic>?;
    final geometry = result?['geometry'] as Map<String, dynamic>?;
    final location = geometry?['location'] as Map<String, dynamic>?;
    final lat = (location?['lat'] as num?)?.toDouble();
    final lng = (location?['lng'] as num?)?.toDouble();
    if (lat == null || lng == null) {
      return null;
    }

    return (latitude: lat, longitude: lng);
  }
}
