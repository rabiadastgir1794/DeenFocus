import 'dart:io';

import 'package:android_intent_plus/android_intent.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../l10n/app_localizations.dart';

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
    final status = await requestNotificationStatus();
    return status.isGranted;
  }

  static Future<PermissionStatus> requestNotificationStatus() async {
    return Permission.notification.request();
  }

  static Future<bool> checkNotification() async {
    final status = await Permission.notification.status;
    return status.isGranted;
  }

  static Future<PermissionStatus> notificationStatus() async {
    return Permission.notification.status;
  }

  static Future<bool> requestMicrophone() async {
    final status = await Permission.microphone.request();
    return status.isGranted;
  }

  static Future<bool> checkMicrophone() async {
    final status = await Permission.microphone.status;
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

  String userFacingMessage(AppLocalizations l10n) {
    switch (errorCode) {
      case 'AUTHENTICATION_METHOD_UNAVAILABLE':
        return l10n.focusScreenTimeAuthPasscodeRequired;
      case 'AUTHORIZATION_CANCELED':
        return l10n.focusScreenTimeAuthCanceled;
      case 'AUTHORIZATION_CONFLICT':
        return l10n.focusScreenTimeAuthConflict;
      case 'INVALID_ACCOUNT_TYPE':
        return l10n.focusScreenTimeAuthInvalidAccount;
      case 'NETWORK_ERROR':
        return l10n.focusScreenTimeAuthNetwork;
      case 'RESTRICTED':
        return l10n.focusScreenTimeAuthRestricted;
      case 'UNAVAILABLE':
        return l10n.focusScreenTimeAuthUnavailable;
      case 'IOS_VERSION_UNSUPPORTED':
        return l10n.focusScreenTimeAuthIosVersion;
      case 'INVALID_ARGUMENT':
        return l10n.focusScreenTimeAuthInvalidArgument;
    }
    return l10n.focusScreenTimeAuthFailedGeneric;
  }
}
