import 'dart:io';

import 'package:flutter/services.dart';

import '../../features/focus/model/focus_models.dart';

abstract class FocusEnforcementService {
  static const MethodChannel _channel = MethodChannel(
    'com.app.deenly.deenly/focus',
  );

  static Future<void> sync({
    required FocusSettings settings,
    required FocusLockState lockState,
  }) async {
    if (!Platform.isAndroid && !Platform.isIOS) return;

    try {
      await _channel.invokeMethod<void>('syncFocusState', <String, dynamic>{
        'selectedPackages': settings.selectedApps.keys.toList(growable: false),
        'iosSelectionData': settings.iosSelectionData,
        'iosSelectionCount': settings.iosSelectionCount,
        'activeMode': lockState.activeMode?.name,
        'isLocked': lockState.isLocked,
        'lockReason': lockState.reason,
        'nextChangeAt': lockState.nextChangeAt?.toIso8601String(),
      });
    } on PlatformException {
      // Native enforcement is optional in this pass. UI/state remains functional.
    }
  }

  static Future<bool> isBlockingPermissionGranted() async {
    if (!Platform.isAndroid) return true;

    try {
      return await _channel.invokeMethod<bool>('isBlockingPermissionGranted') ??
          false;
    } on PlatformException {
      return false;
    }
  }

  static Future<void> openBlockingPermissionSettings() async {
    if (!Platform.isAndroid) return;

    try {
      await _channel.invokeMethod<void>('openBlockingPermissionSettings');
    } on PlatformException {
      // Best effort only.
    }
  }
}
