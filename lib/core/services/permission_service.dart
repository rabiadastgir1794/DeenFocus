import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

/// Centralized permission requests and checks. Used by onboarding ViewModel.
abstract class PermissionService {
  static const MethodChannel _screenTimeChannel = MethodChannel(
    'com.app.deenly.deenly/screen_time',
  );

  static Future<bool> requestLocation() async {
    final status = await Permission.location.request();
    return status.isGranted;
  }

  static Future<PermissionStatus> requestLocationStatus() async {
    return Permission.location.request();
  }

  static Future<bool> checkLocation() async {
    final status = await Permission.location.status;
    return status.isGranted;
  }

  static Future<bool> requestNotification() async {
    final status = await Permission.notification.request();
    return status.isGranted;
  }

  static Future<bool> checkNotification() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  static Future<bool> openAppSettingsAsync() async {
    return await openAppSettings();
  }

  static Future<bool> openLocationSettings() async {
    if (Platform.isIOS) {
      try {
        final opened = await _screenTimeChannel.invokeMethod<bool>(
          'openAppSettings',
        );
        return opened ?? false;
      } on PlatformException {
        return false;
      }
    }

    return await openAppSettings();
  }

  static Future<void> openUsageAccessSettings() async {
    const intent = AndroidIntent(
      action: 'android.settings.USAGE_ACCESS_SETTINGS',
    );
    await intent.launch();
  }

  static Future<bool> requestScreenTimeAccess() async {
    final result = await requestScreenTimeAccessDetailed();
    return result.granted;
  }

  static Future<ScreenTimeAuthorizationResult>
  requestScreenTimeAccessDetailed() async {
    if (Platform.isAndroid) {
      try {
        await openUsageAccessSettings();
        return const ScreenTimeAuthorizationResult(granted: true);
      } on PlatformException {
        return const ScreenTimeAuthorizationResult(
          granted: false,
          errorCode: 'ANDROID_SETTINGS_OPEN_FAILED',
        );
      }
    }

    if (Platform.isIOS) {
      try {
        final raw = await _screenTimeChannel.invokeMapMethod<dynamic, dynamic>(
          'requestScreenTime',
        );
        if (raw == null) {
          return const ScreenTimeAuthorizationResult(granted: false);
        }
        return ScreenTimeAuthorizationResult(
          granted: raw['authorized'] as bool? ?? false,
          errorCode: raw['errorCode'] as String?,
          errorMessage: raw['errorMessage'] as String?,
        );
      } on PlatformException {
        return const ScreenTimeAuthorizationResult(granted: false);
      }
    }

    return const ScreenTimeAuthorizationResult(granted: false);
  }
}

class ScreenTimeAuthorizationResult {
  const ScreenTimeAuthorizationResult({
    required this.granted,
    this.errorCode,
    this.errorMessage,
  });

  final bool granted;
  final String? errorCode;
  final String? errorMessage;

  String? userFacingMessage() {
    switch (errorCode) {
      case 'AUTHENTICATION_METHOD_UNAVAILABLE':
        return 'This iPhone needs a device passcode before Apple will allow Screen Time access. Set a passcode in iPhone Settings, then try again.';
      case 'AUTHORIZATION_CANCELED':
        return 'Screen Time access was canceled before Apple finished granting it. Please try again and complete the Apple prompt.';
      case 'AUTHORIZATION_CONFLICT':
        return 'Another app is already managing Family Controls on this iPhone. Turn that off first, then try again.';
      case 'INVALID_ACCOUNT_TYPE':
        return 'Sign in with a valid iCloud account on this iPhone, then try Screen Time access again.';
      case 'NETWORK_ERROR':
        return 'This iPhone needs an internet connection before Apple can grant Screen Time access.';
      case 'RESTRICTED':
        return 'Family Controls is restricted on this iPhone, so Deenly cannot request Screen Time access here.';
      case 'UNAVAILABLE':
        return 'Family Controls is currently unavailable on this iPhone.';
      case 'IOS_VERSION_UNSUPPORTED':
        return 'Screen Time app blocking requires iOS 16 or later.';
    }

    if (errorMessage != null && errorMessage!.trim().isNotEmpty) {
      return errorMessage;
    }
    return 'Screen Time access could not be granted on this iPhone.';
  }
}
