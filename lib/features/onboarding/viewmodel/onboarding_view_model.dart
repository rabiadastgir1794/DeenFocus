import 'package:flutter/material.dart';

import '../../../core/services/permission_service.dart';
import '../../../core/services/storage_service.dart';
import '../model/sect_option.dart';
import '../model/subscription_plan.dart';

class OnboardingViewModel extends ChangeNotifier {
  OnboardingViewModel() {
    _totalSteps = 11;
  }

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

  /// Screens that show Skip on top right: 0 (Welcome) only. Subscription (9) has no skip.
  bool get showSkip => _currentIndex == 0;

  /// Continue disabled: sect (4), name (5), location (6), notifications (7). Screen time (8) & subscription (9) always enabled.
  bool get isContinueDisabled {
    if (_currentIndex == 4) return _selectedSect == null;
    if (_currentIndex == 5) return _userName.trim().isEmpty;
    if (_currentIndex == 6) return !_locationGranted;
    if (_currentIndex == 7) return !_notificationGranted;
    return false;
  }

  /// Re-check permission state (e.g. when returning from app settings). Call from view on resume.
  bool _locationRequesting = false;
  bool get locationRequesting => _locationRequesting;

  bool _notificationRequesting = false;
  bool get notificationRequesting => _notificationRequesting;

  Future<void> recheckPermissions() async {
    _locationGranted = await PermissionService.checkLocation();
    _notificationGranted = await PermissionService.checkNotification();
    notifyListeners();
  }

  Future<void> requestLocation() async {
    _locationRequesting = true;
    notifyListeners();
    _locationGranted = await PermissionService.requestLocation();
    _locationRequesting = false;
    notifyListeners();
  }

  Future<void> requestNotification() async {
    _notificationRequesting = true;
    notifyListeners();
    _notificationGranted = await PermissionService.requestNotification();
    _notificationRequesting = false;
    notifyListeners();
  }

  void goNext() {
    if (_currentIndex < _totalSteps - 1) {
      _currentIndex++;
      notifyListeners();
    } else {
      _completeOnboarding();
    }
  }

  void skip() {
    _completeOnboarding();
  }

  Future<void> _completeOnboarding() async {
    await StorageService.setOnboardingCompleted(true);
    if (_userName.trim().isNotEmpty) {
      await StorageService.setUserName(_userName.trim());
    }
    if (_selectedSect != null) {
      await StorageService.setSect(_selectedSect!.name);
    }
    _didComplete = true;
    notifyListeners();
  }

  void setSelectedSect(SectOption? value) {
    _selectedSect = value;
    notifyListeners();
  }

  void setSelectedPlan(SubscriptionPlan? value) {
    _selectedPlan = value;
    notifyListeners();
  }

  void setUserName(String value) {
    _userName = value;
    notifyListeners();
  }

  void setStep(int index) {
    if (index >= 0 && index < _totalSteps) {
      _currentIndex = index;
      notifyListeners();
    }
  }
}
