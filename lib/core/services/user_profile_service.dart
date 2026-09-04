import 'dart:async';

import 'package:flutter/material.dart';

import '../../features/onboarding/model/asr_calculation_option.dart';
import '../../features/onboarding/model/calculation_method_option.dart';
import '../../features/onboarding/model/location_suggestion.dart';
import '../../features/onboarding/model/sect_option.dart';
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
  SectOption _sect = SectOption.sunni;
  CalculationMethodOption _calculationMethod = CalculationMethodOption.karachi;
  AsrCalculationOption _asrMethod = AsrCalculationOption.standard;

  String get userName => _userName;
  String? get locationName => _locationName;
  String? get locationSubtitle => _locationSubtitle;
  double? get latitude => _latitude;
  double? get longitude => _longitude;
  SectOption get sect => _sect;
  CalculationMethodOption get calculationMethod => _calculationMethod;
  AsrCalculationOption get asrMethod => _asrMethod;

  String get locationLabel {
    final name = _locationName?.trim() ?? '';
    final subtitle = _locationSubtitle?.trim() ?? '';
    if (name.isEmpty) return 'Set location';
    if (subtitle.isEmpty) return name;
    final nameLower = name.toLowerCase();
    final subtitleLower = subtitle.toLowerCase();
    if (subtitleLower == nameLower ||
        subtitleLower.startsWith('$nameLower,')) {
      return name;
    }
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
    _sect = _resolveSect(await StorageService.sect);
    _calculationMethod = CalculationMethodOption.fromRaw(
      await StorageService.calculationMethod,
      sectRaw: await StorageService.sect,
    );
    _asrMethod = AsrCalculationOption.fromRaw(await StorageService.asrMethod);
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
    if (value.latitude == null || value.longitude == null) {
      // Refuse name-only updates — Home would show the new city with old times.
      return;
    }
    _locationName = value.title.trim();
    _locationSubtitle = value.subtitle.trim();
    if (_locationSubtitle!.toLowerCase() == _locationName!.toLowerCase() ||
        _locationSubtitle!.toLowerCase().startsWith(
          '${_locationName!.toLowerCase()},',
        )) {
      _locationSubtitle = '';
    }
    _latitude = value.latitude;
    _longitude = value.longitude;
    await StorageService.setUserLocation(
      name: _locationName!,
      subtitle: _locationSubtitle,
      latitude: _latitude,
      longitude: _longitude,
    );
    // Custom wall-clock overrides and cached times belong to the previous city.
    await StorageService.clearHomePrayerCache();
    await DailyRefreshService.instance.refreshNow();
    notifyListeners();
  }

  Future<void> setSect(SectOption value) async {
    if (_sect == value) return;
    _sect = value;
    // Keep calculation method in sync with sect selection.
    if (value == SectOption.shia) {
      _calculationMethod = CalculationMethodOption.tehran;
      await StorageService.setCalculationMethod(CalculationMethodOption.tehran.name);
    } else if (_calculationMethod.isShia) {
      _calculationMethod = CalculationMethodOption.karachi;
      await StorageService.setCalculationMethod(CalculationMethodOption.karachi.name);
    }
    notifyListeners();
    await StorageService.setSect(value.name);
    unawaited(DailyRefreshService.instance.refreshNow());
  }

  Future<void> setCalculationMethod(CalculationMethodOption value) async {
    if (_calculationMethod == value) return;
    _calculationMethod = value;
    // Keep sect in sync for backward-compat code paths.
    _sect = value.isShia ? SectOption.shia : SectOption.sunni;
    await StorageService.setCalculationMethod(value.name);
    await StorageService.setSect(_sect.name);
    notifyListeners();
    unawaited(DailyRefreshService.instance.refreshNow());
  }

  Future<void> setAsrMethod(AsrCalculationOption value) async {
    if (_asrMethod == value) return;
    _asrMethod = value;
    await StorageService.setAsrMethod(value.name);
    notifyListeners();
    unawaited(DailyRefreshService.instance.refreshNow());
  }

  SectOption _resolveSect(String? raw) {
    switch (raw) {
      case 'shia':
        return SectOption.shia;
      case 'preferNotToSay':
        return SectOption.sunni;
      case 'sunni':
      default:
        return SectOption.sunni;
    }
  }
}
