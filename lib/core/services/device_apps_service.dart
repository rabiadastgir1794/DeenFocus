import 'dart:io';

import 'package:flutter/services.dart';

import '../../features/focus/model/focus_models.dart';

abstract class DeviceAppsService {
  static const MethodChannel _channel = MethodChannel(
    'com.app.deenly.deenly/focus',
  );

  static Future<List<FocusInstalledApp>> getInstalledApps() async {
    if (!Platform.isAndroid) return const <FocusInstalledApp>[];

    try {
      final raw = await _channel.invokeListMethod<dynamic>('getInstalledApps');
      if (raw == null) return const <FocusInstalledApp>[];
      return raw
          .whereType<Map<Object?, Object?>>()
          .map(FocusInstalledApp.fromMap)
          .where((app) => app.packageName.isNotEmpty)
          .toList(growable: false);
    } on PlatformException {
      return const <FocusInstalledApp>[];
    }
  }

  static Future<IosFocusSelectionResult?> presentIosFamilyPicker() async {
    if (!Platform.isIOS) return null;

    try {
      final raw = await _channel.invokeMapMethod<dynamic, dynamic>(
        'presentFamilyActivityPicker',
      );
      if (raw == null) return null;
      return IosFocusSelectionResult(
        selectionData: raw['selectionData'] as String?,
        selectionCount:
            (raw['selectionCount'] as num?)?.toInt() ??
            (raw['applicationCount'] as num?)?.toInt() ??
            0,
        applicationCount: (raw['applicationCount'] as num?)?.toInt() ?? 0,
        categoryCount: (raw['categoryCount'] as num?)?.toInt() ?? 0,
        webDomainCount: (raw['webDomainCount'] as num?)?.toInt() ?? 0,
      );
    } on PlatformException {
      return null;
    }
  }
}

class IosFocusSelectionResult {
  const IosFocusSelectionResult({
    required this.selectionData,
    required this.selectionCount,
    required this.applicationCount,
    required this.categoryCount,
    required this.webDomainCount,
  });

  final String? selectionData;
  final int selectionCount;
  final int applicationCount;
  final int categoryCount;
  final int webDomainCount;
}
