import 'dart:io';

import 'package:flutter/services.dart';

import '../../features/focus/model/focus_models.dart';

abstract class FocusEnforcementService {
  static const MethodChannel _channel = MethodChannel(
    'com.app.deenly.deenly/focus',
  );

  static Future<void> appendDebugLog(String tag, String message) async {
    if (!Platform.isAndroid && !Platform.isIOS) return;

    try {
      await _channel.invokeMethod<void>(
        'appendFocusDebugLog',
        <String, dynamic>{'tag': tag, 'message': message},
      );
    } on PlatformException {
      // Best effort only.
    }
  }

  static Future<String?> clearDebugLog() async {
    if (!Platform.isAndroid && !Platform.isIOS) return null;

    try {
      return await _channel.invokeMethod<String>('clearFocusDebugLog');
    } on PlatformException {
      return null;
    }
  }

  static Future<String?> debugLogPath() async {
    if (!Platform.isAndroid && !Platform.isIOS) return null;

    try {
      return await _channel.invokeMethod<String>('getFocusDebugLogPath');
    } on PlatformException {
      return null;
    }
  }

  static Future<void> sync({
    required FocusSettings settings,
    required FocusLockState lockState,
    List<Map<String, dynamic>> scheduledTransitions =
        const <Map<String, dynamic>>[],
  }) async {
    if (!Platform.isAndroid && !Platform.isIOS) return;

    try {
      await appendDebugLog(
        'flutter.sync',
        'selected=${settings.selectedApps.length} mode=${lockState.activeMode?.name} isLocked=${lockState.isLocked} nextChangeAt=${lockState.nextChangeAt?.toIso8601String()} transitions=${scheduledTransitions.length}',
      );
      await _channel.invokeMethod<void>('syncFocusState', <String, dynamic>{
        'selectedPackages': settings.selectedApps.keys.toList(growable: false),
        'iosSelectionData': settings.iosSelectionData,
        'iosSelectionCount': settings.iosSelectionCount,
        'nightDisciplineEnabled': settings.nightDisciplineEnabled,
        'nightStartHour': settings.nightRange.startHour,
        'nightStartMinute': settings.nightRange.startMinute,
        'nightEndHour': settings.nightRange.endHour,
        'nightEndMinute': settings.nightRange.endMinute,
        'activeMode': lockState.activeMode?.name,
        'isLocked': lockState.isLocked,
        'lockReason': lockState.reason,
        'nextChangeAt': lockState.nextChangeAt?.toIso8601String(),
        'scheduledTransitions': scheduledTransitions,
      });
    } on PlatformException {
      // Native enforcement is optional in this pass. UI/state remains functional.
    }
  }

  static Future<bool> isBlockingPermissionGranted() async {
    if (!Platform.isAndroid) return true;

    try {
      final granted =
          await _channel.invokeMethod<bool>('isBlockingPermissionGranted') ??
          false;
      await appendDebugLog('flutter.permission.check', 'granted=$granted');
      return granted;
    } on PlatformException {
      return false;
    }
  }

  static Future<void> openBlockingPermissionSettings() async {
    if (!Platform.isAndroid) return;

    try {
      await appendDebugLog(
        'flutter.permission.settings',
        'opening accessibility settings',
      );
      await _channel.invokeMethod<void>('openBlockingPermissionSettings');
    } on PlatformException {
      // Best effort only.
    }
  }
}
