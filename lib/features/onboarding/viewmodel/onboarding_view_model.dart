import 'dart:async';

import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/services/app_notification_service.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/daily_refresh_service.dart';
import '../model/location_suggestion.dart';
import '../model/sect_option.dart';
import '../model/subscription_plan.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel() {
    _totalSteps = 11;
    _selectedPlan = SubscriptionPlan.yearly;
  }

  /// PageView index for [OnboardingLocationPage] (compulsory).
  static const int widgetsLiveStepIndex = 2;
  static const int locationStepIndex = 5;
  static const int notificationStepIndex = 6;
  static const int screenTimeStepIndex = 7;
  static const int selectAppsStepIndex = 8;
  static const int appLockDemoStepIndex = 9;
  static const int subscriptionStepIndex = 10;
  static const int sectStepIndex = 3;
  static const int nameStepIndex = 4;

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
  /// Location step omits Skip (App Store 5.1.1(iv) — no dismiss of permission purpose).
  bool get showLanguageChangeOption => _currentIndex == 0;
  bool get showSkip =>
      _currentIndex < 3 ||
      _currentIndex == notificationStepIndex ||
      _currentIndex == screenTimeStepIndex ||
      _currentIndex == selectAppsStepIndex ||
      _currentIndex == appLockDemoStepIndex;
  bool get isLocationStep => _currentIndex == locationStepIndex;
  bool get isNotificationStep => _currentIndex == notificationStepIndex;
  bool get isScreenTimeStep => _currentIndex == screenTimeStepIndex;
  bool get isSelectAppsStep => _currentIndex == selectAppsStepIndex;
  bool get isAppLockDemoStep => _currentIndex == appLockDemoStepIndex;

  bool _selectAppsLoading = false;
  bool get selectAppsLoading => _selectAppsLoading;

  void setSelectAppsLoading(bool value) {
    if (_selectAppsLoading == value) return;
    _selectAppsLoading = value;
    notifyListeners();
  }

  /// Location was resolved via permission and the flow should auto-advance.
  bool _pendingLocationAutoAdvance = false;
  bool get shouldAutoAdvanceFromLocation => _pendingLocationAutoAdvance;

  /// Continue disabled: sect, name, location. Later steps are optional.
  bool get isContinueDisabled {
    if (_currentIndex == sectStepIndex) return _selectedSect == null;
    if (_currentIndex == nameStepIndex) return _userName.trim().isEmpty;
    if (_currentIndex == locationStepIndex) {
      return _selectedLocation == null && !_locationGranted;
    }
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

  Future<PermissionStatus> requestNotification() async {
    _notificationRequesting = true;
    notifyListeners();
    try {
      final current = await PermissionService.notificationStatus();
      if (current.isGranted) {
        _notificationGranted = true;
        return current;
      }

      await AppNotificationService.instance.initialize();
      final status = await PermissionService.requestNotificationStatus();
      _notificationGranted = status.isGranted;
      return status;
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
    if (_selectedLocation != null &&
        _selectedLocation!.latitude != null &&
        _selectedLocation!.longitude != null) {
      await StorageService.setUserLocation(
        name: _selectedLocation!.title,
        subtitle: _selectedLocation!.subtitle,
        latitude: _selectedLocation!.latitude,
        longitude: _selectedLocation!.longitude,
      );
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

  void setLocationGranted(bool value) {
    if (_locationGranted == value) return;
    _locationGranted = value;
    notifyListeners();
  }

  /// Saves a GPS-resolved location after permission grant and requests auto-advance.
  void applyPermissionLocation(LocationSuggestion location) {
    _locationGranted = true;
    _selectedLocation = location;
    _pendingLocationAutoAdvance = true;
    notifyListeners();
  }

  /// Saves a manually chosen city and requests auto-advance (no GPS permission).
  void applyManualLocation(LocationSuggestion location) {
    _selectedLocation = location;
    _pendingLocationAutoAdvance = true;
    notifyListeners();
  }

  void acknowledgeLocationAutoAdvance() {
    if (!_pendingLocationAutoAdvance) return;
    _pendingLocationAutoAdvance = false;
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
