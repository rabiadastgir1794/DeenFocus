import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../../../features/onboarding/model/location_suggestion.dart';
import '../permission_service.dart';

abstract class LocationService {
  static Future<LocationSuggestion?> fetchCurrentCity() async {
    final hasPermission = await PermissionService.checkLocation();
    if (!hasPermission) {
      return null;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );

    final placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    final placemark = placemarks.isNotEmpty ? placemarks.first : null;
    final city = _firstNonEmpty(<String?>[
      placemark?.locality,
      placemark?.subAdministrativeArea,
      placemark?.administrativeArea,
    ]);

    final country = _firstNonEmpty(<String?>[placemark?.country]);

    if (city == null) {
      return null;
    }

    return LocationSuggestion(
      title: city,
      subtitle: country ?? '',
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  /// Current GPS coordinates with optional placemark. Unlike [fetchCurrentCity],
  /// this still returns a result when locality lookup is empty (e.g. rural areas).
  static Future<LocationSuggestion?> fetchCurrentCoordinates() async {
    final hasPermission = await PermissionService.checkLocation();
    if (!hasPermission) {
      return null;
    }

    final serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return null;
    }

    final position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    ).timeout(const Duration(seconds: 30));

    String title = '';
    String subtitle = '';
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      ).timeout(const Duration(seconds: 12));
      final placemark = placemarks.isNotEmpty ? placemarks.first : null;
      title = _firstNonEmpty(<String?>[
            placemark?.locality,
            placemark?.subAdministrativeArea,
            placemark?.administrativeArea,
          ]) ??
          '';
      subtitle = _firstNonEmpty(<String?>[placemark?.country]) ?? '';
    } catch (_) {}

    return LocationSuggestion(
      title: title,
      subtitle: subtitle,
      latitude: position.latitude,
      longitude: position.longitude,
    );
  }

  static String? _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim() ?? '';
      if (trimmed.isNotEmpty) {
        return trimmed;
      }
    }
    return null;
  }
}
