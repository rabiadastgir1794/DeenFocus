import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/services/app_notification_service.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/daily_refresh_service.dart';
import '../model/location_suggestion.dart';
import '../model/sect_option.dart';
import '../model/subscription_plan.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel() {
    _totalSteps = 10;
    _selectedPlan = SubscriptionPlan.yearly;
  }

  /// PageView index for [OnboardingLocationPage] (compulsory).
  static const int locationStepIndex = 6;

  late int _totalSteps;

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  int get totalSteps => _totalSteps;

  bool _didComplete = false;
  bool get didComplete => _didComplete;

  bool _locationGranted = false;
  bool get locationGranted => _locationGranted;

  bool _notificationGranted = false;
  bool get notificationGranted => _notificationGranted;

  SectOption? _selectedSect;
  SectOption? get selectedSect => _selectedSect;

  SubscriptionPlan? _selectedPlan;
  SubscriptionPlan? get selectedPlan => _selectedPlan;

  String _userName = '';
  String get userName => _userName;

  LocationSuggestion? _selectedLocation;
  LocationSuggestion? get selectedLocation => _selectedLocation;
  String _selectedLanguageCode = 'en';

  /// Screens that show Skip on top right.
  bool get showLanguageChangeOption => _currentIndex == 0;
  bool get showSkip => _currentIndex < 4;

  /// Continue disabled: sect (4), name (5), location (6). Notifications (7), screen time (8), and subscription (9) are optional.
  bool get isContinueDisabled {
    if (_currentIndex == 4) return _selectedSect == null;
    if (_currentIndex == 5) return _userName.trim().isEmpty;
    if (_currentIndex == 6) return _selectedLocation == null;
    return false;
  }

  /// Re-check permission state (e.g. when returning from app settings). Call from view on resume.
  bool _notificationRequesting = false;
  bool get notificationRequesting => _notificationRequesting;

  bool _screenTimeRequesting = false;
  bool get screenTimeRequesting => _screenTimeRequesting;

  Future<void> recheckPermissions() async {
    _locationGranted = await PermissionService.checkLocation();
    _notificationGranted = await PermissionService.checkNotification();
    notifyListeners();
  }

  Future<void> requestNotification() async {
    _notificationRequesting = true;
    notifyListeners();
    try {
      await AppNotificationService.instance.initialize();
      _notificationGranted = await PermissionService.requestNotification();
    } finally {
      _notificationRequesting = false;
      notifyListeners();
    }
  }

  Future<ScreenTimeAuthorizationResult> requestScreenTime() async {
    _screenTimeRequesting = true;
    notifyListeners();
    try {
      return await PermissionService.requestScreenTimeAccessDetailed();
    } finally {
      _screenTimeRequesting = false;
      notifyListeners();
    }
  }

  void goNext() {
    if (_currentIndex < _totalSteps - 1) {
      _currentIndex++;
      notifyListeners();
    } else {
      _completeOnboarding();
    }
  }

  Future<void> _completeOnboarding() async {
    await StorageService.setOnboardingCompleted(true);
    await StorageService.setLocaleCode(_selectedLanguageCode);
    if (_userName.trim().isNotEmpty) {
      await StorageService.setUserName(_userName.trim());
    }
    if (_selectedSect != null) {
      await StorageService.setSect(_selectedSect!.name);
    }
    if (_selectedLocation != null) {
      await StorageService.setUserLocation(
        name: _selectedLocation!.title,
        subtitle: _selectedLocation!.subtitle,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
      );
      if (_selectedLocation!.latitude != null &&
          _selectedLocation!.longitude != null) {
        // Do not await: refresh loads prayer data, notifications, widgets and can
        // take multiple seconds. Home tab loads the same data on open anyway.
        unawaited(
          DailyRefreshService.instance.refreshNow().catchError((
            Object e,
            StackTrace st,
          ) {
            assert(() {
              debugPrint('Onboarding: refresh after location failed: $e\n$st');
              return true;
            }());
          }),
        );
      }
    }
    _didComplete = true;
    notifyListeners();
  }

  void setSelectedSect(SectOption? value) {
    _selectedSect = value;
    notifyListeners();
  }

  void setSelectedPlan(SubscriptionPlan? value) {
    if (value == null || value == SubscriptionPlan.yearly) {
      _selectedPlan = SubscriptionPlan.yearly;
      notifyListeners();
    }
  }

  void setUserName(String value) {
    _userName = value;
    notifyListeners();
  }

  void setSelectedLocation(LocationSuggestion? value) {
    _selectedLocation = value;
    notifyListeners();
  }

  void setSelectedLanguageCode(String code) {
    final trimmed = code.trim();
    if (trimmed.isEmpty || _selectedLanguageCode == trimmed) return;
    _selectedLanguageCode = trimmed;
  }

  void setStep(int index) {
    if (index >= 0 && index < _totalSteps) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
