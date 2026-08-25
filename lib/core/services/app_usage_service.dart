import 'dart:io';

import 'package:flutter/services.dart';

import '../../features/home/helpers/digital_balance_math.dart';
import '../../features/home/model/digital_balance_models.dart';

/// Platform app-usage bridge. Android aggregates UsageEvents (with a
/// per-day UsageStats fallback). iOS uses Family Controls authorization;
/// per-app durations cannot be exported from the iPhoneOS 26.2 SDK
/// (see IosAppUsageBridge).
abstract class AppUsageService {
  static const MethodChannel _channel = MethodChannel(
    'com.app.deenly.deenly/app_usage',
  );

  static bool get _hasNativeBridge => Platform.isAndroid || Platform.isIOS;

  static Future<AppUsageAvailability> availability() async {
    if (!_hasNativeBridge) return AppUsageAvailability.unsupported;
    try {
      final raw = await _channel.invokeMapMethod<dynamic, dynamic>(
        'getAvailability',
      );
      return parseAvailability(raw?['status'] as String?);
    } on PlatformException {
      return AppUsageAvailability.denied;
    }
  }

  static Future<AppUsageAvailability> requestAccess() async {
    if (!_hasNativeBridge) return AppUsageAvailability.unsupported;
    try {
      final raw = await _channel.invokeMapMethod<dynamic, dynamic>(
        'requestAccess',
      );
      return parseAvailability(raw?['status'] as String?);
    } on PlatformException {
      return AppUsageAvailability.denied;
    }
  }

  static Future<({AppUsageAvailability availability, List<AppUsageDay> days})>
  queryUsage({DateTime? now}) async {
    final clock = now ?? DateTime.now();
    if (!_hasNativeBridge) {
      return (
        availability: AppUsageAvailability.unsupported,
        days: const <AppUsageDay>[],
      );
    }

    try {
      final raw = await _channel
          .invokeMapMethod<dynamic, dynamic>('queryUsage', <String, dynamic>{
            'startDate': DigitalBalanceMath.dateKey(
              DigitalBalanceMath.mondayOf(
                clock,
              ).subtract(const Duration(days: 7)),
            ),
            'endDate': DigitalBalanceMath.dateKey(clock),
          });
      if (raw == null) {
        return (
          availability: AppUsageAvailability.denied,
          days: const <AppUsageDay>[],
        );
      }
      final availability = parseAvailability(raw['status'] as String?);
      if (availability != AppUsageAvailability.granted) {
        return (availability: availability, days: const <AppUsageDay>[]);
      }
      return (availability: availability, days: parseDays(raw));
    } on PlatformException {
      return (
        availability: AppUsageAvailability.denied,
        days: const <AppUsageDay>[],
      );
    }
  }

  static AppUsageAvailability parseAvailability(String? status) {
    switch (status) {
      case 'granted':
        return AppUsageAvailability.granted;
      case 'unsupported':
        return AppUsageAvailability.unsupported;
      default:
        return AppUsageAvailability.denied;
    }
  }

  static bool isDeenFocus({
    required String packageName,
    required bool flagged,
    String? hostBundleId,
  }) {
    if (flagged) return true;
    final host = hostBundleId?.trim();
    if (host == null || host.isEmpty) return false;
    return packageName == host;
  }

  static List<AppUsageDay> parseDays(Map<dynamic, dynamic> raw) {
    final catalog = <String, AppUsageAppInfo>{};
    final appsRaw = raw['apps'];
    if (appsRaw is Map) {
      for (final entry in appsRaw.entries) {
        final packageName = entry.key.toString();
        final value = entry.value;
        if (value is! Map) continue;
        catalog[packageName] = AppUsageAppInfo(
          packageName: packageName,
          appName: (value['appName'] as String?)?.trim().isNotEmpty == true
              ? value['appName'] as String
              : packageName,
          isDeenFocus: isDeenFocus(
            packageName: packageName,
            flagged: value['isDeenFocus'] as bool? ?? false,
          ),
          iconBytes: _bytes(value['iconBytes']),
        );
      }
    }

    final daysRaw = raw['days'];
    if (daysRaw is! List) return const <AppUsageDay>[];

    return daysRaw
        .whereType<Map>()
        .map((day) {
          final date = parseDate(day['date'] as String?);
          if (date == null) return null;
          final usage = day['usage'];
          if (usage is! Map) {
            return AppUsageDay(date: date, apps: const []);
          }
          final apps = <AppUsageEntry>[];
          for (final entry in usage.entries) {
            final packageName = entry.key.toString();
            final usageMs = (entry.value as num?)?.toInt() ?? 0;
            if (usageMs <= 0) continue;
            final info =
                catalog[packageName] ??
                AppUsageAppInfo(
                  packageName: packageName,
                  appName: packageName,
                  isDeenFocus: isDeenFocus(
                    packageName: packageName,
                    flagged: false,
                  ),
                );
            apps.add(
              AppUsageEntry(
                info: info,
                usage: Duration(milliseconds: usageMs),
                date: date,
              ),
            );
          }
          return AppUsageDay(date: date, apps: apps);
        })
        .whereType<AppUsageDay>()
        .toList(growable: false);
  }

  static DateTime? parseDate(String? raw) {
    if (raw == null || raw.length < 10) return null;
    final parts = raw.split('-');
    if (parts.length != 3) return null;
    final year = int.tryParse(parts[0]);
    final month = int.tryParse(parts[1]);
    final day = int.tryParse(parts[2]);
    if (year == null || month == null || day == null) return null;
    return DateTime(year, month, day);
  }

  static Uint8List? _bytes(Object? raw) {
    if (raw is Uint8List) return raw;
    if (raw is List<int>) return Uint8List.fromList(raw);
    return null;
  }
}
