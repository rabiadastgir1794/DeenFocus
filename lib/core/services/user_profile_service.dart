import 'package:flutter/material.dart';

import '../../features/onboarding/model/location_suggestion.dart';
import 'daily_refresh_service.dart';
import 'storage_service.dart';

class UserProfileService extends ChangeNotifier {
  UserProfileService() {
    _load();
  }

  String _userName = 'User';
  String? _locationName;
  String? _locationSubtitle;
  double? _latitude;
  double? _longitude;

  String get userName => _userName;
  String? get locationName => _locationName;
  String? get locationSubtitle => _locationSubtitle;
  double? get latitude => _latitude;
  double? get longitude => _longitude;

  String get locationLabel {
    final name = _locationName?.trim() ?? '';
    final subtitle = _locationSubtitle?.trim() ?? '';
    if (name.isEmpty) return 'Set location';
    if (subtitle.isEmpty) return name;
    return '$name, $subtitle';
  }

  LocationSuggestion? get locationSuggestion {
    final name = _locationName?.trim() ?? '';
    if (name.isEmpty) return null;
    return LocationSuggestion(
      title: name,
      subtitle: _locationSubtitle ?? '',
      latitude: _latitude,
      longitude: _longitude,
    );
  }

  Future<void> _load() async {
    _userName = await StorageService.userName ?? 'User';
    _locationName = await StorageService.locationName;
    _locationSubtitle = await StorageService.locationSubtitle;
    _latitude = await StorageService.locationLatitude;
    _longitude = await StorageService.locationLongitude;
    notifyListeners();
  }

  Future<void> refresh() async {
    await _load();
  }

  Future<void> setUserName(String value) async {
    final trimmed = value.trim();
    final next = trimmed.isEmpty ? 'User' : trimmed;
    if (_userName == next) return;
    _userName = next;
    await StorageService.setUserName(next);
    notifyListeners();
  }

  Future<void> setLocation(LocationSuggestion value) async {
    _locationName = value.title.trim();
    _locationSubtitle = value.subtitle.trim();
    _latitude = value.latitude;
    _longitude = value.longitude;
    await StorageService.setUserLocation(
      name: _locationName!,
      subtitle: _locationSubtitle,
      latitude: _latitude,
      longitude: _longitude,
    );
    if (_latitude != null && _longitude != null) {
      await DailyRefreshService.instance.refreshNow();
    }
    notifyListeners();
  }
}
