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
