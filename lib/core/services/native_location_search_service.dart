import 'dart:io';

import 'package:flutter/services.dart';

import 'package:deenly/features/onboarding/model/location_suggestion.dart';

/// iOS: [MKLocalSearch]. Android: [Geocoder] with retries (no Google Places API).
class NativeLocationSearchService {
  NativeLocationSearchService();

  static const _channel = MethodChannel('com.app.deenly.deenly/location_search');

  Future<List<LocationSuggestion>> search(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) return const [];

    if (!Platform.isIOS && !Platform.isAndroid) {
      return const [];
    }

    try {
      final raw = await _channel.invokeMethod<List<dynamic>>('search', <String, dynamic>{
        'query': trimmed,
      });
      if (raw == null) return const [];
      return raw
          .map((row) {
            if (row is! Map) return null;
            final map = Map<String, dynamic>.from(row);
            final title = map['title'] as String? ?? '';
            if (title.isEmpty) return null;
            final lat = (map['latitude'] as num?)?.toDouble();
            final lng = (map['longitude'] as num?)?.toDouble();
            if (lat == null || lng == null) return null;
            return LocationSuggestion(
              title: title,
              subtitle: (map['subtitle'] as String?)?.trim() ?? '',
              placeId: null,
              latitude: lat,
              longitude: lng,
            );
          })
          .whereType<LocationSuggestion>()
          .toList(growable: false);
    } on PlatformException {
      return const [];
    }
  }
}
