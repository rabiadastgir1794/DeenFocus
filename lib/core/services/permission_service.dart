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
    if (Platform.isAndroid) {
      try {
        await openUsageAccessSettings();
        return true;
      } on PlatformException {
        return false;
      }
    }

    if (Platform.isIOS) {
      try {
        final granted = await _screenTimeChannel.invokeMethod<bool>(
          'requestScreenTime',
        );
        return granted ?? false;
      } on PlatformException {
        return false;
      }
    }

    return false;
  }
}
