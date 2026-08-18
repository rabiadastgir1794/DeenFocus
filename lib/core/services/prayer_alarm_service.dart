import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../features/home/helpers/home_prayer_times_helper.dart';
import '../../features/home/helpers/prayer_label_helper.dart';
import '../../features/home/model/home_models.dart';
import '../../l10n/app_localizations.dart';
import '../logger/logger_service.dart';
import 'storage_service.dart';

/// Platform capabilities reported by the native Prayer Alarm bridge.
class PrayerAlarmCapabilities {
  const PrayerAlarmCapabilities({
    required this.platform,
    required this.implementation,
    required this.supportsNativeAlarm,
    required this.supportsFullScreen,
    required this.requiresAlarmKitEntitlement,
    this.iosVersion,
    this.androidSdk,
    this.canUseFullScreenIntent,
  });

  factory PrayerAlarmCapabilities.fromMap(Map<dynamic, dynamic> map) {
    return PrayerAlarmCapabilities(
      platform: map['platform'] as String? ?? 'unknown',
      implementation: map['implementation'] as String? ?? 'none',
      supportsNativeAlarm: map['supportsNativeAlarm'] as bool? ?? false,
      supportsFullScreen: map['supportsFullScreen'] as bool? ?? false,
      requiresAlarmKitEntitlement:
          map['requiresAlarmKitEntitlement'] as bool? ?? false,
      iosVersion: map['iosVersion'] as String?,
      androidSdk: map['androidSdk'] as int?,
      canUseFullScreenIntent: map['canUseFullScreenIntent'] as bool?,
    );
  }

  final String platform;
  final String implementation;
  final bool supportsNativeAlarm;
  final bool supportsFullScreen;
  final bool requiresAlarmKitEntitlement;
  final String? iosVersion;
  final int? androidSdk;
  final bool? canUseFullScreenIntent;

  bool get isAlarmKit => implementation == 'alarmkit';
  bool get isFullScreenIntent => implementation == 'fullscreen_intent';
  bool get usesNotificationFallback =>
      implementation == 'notification_fallback' || !supportsNativeAlarm;
}

/// Authorization states mirrored from native (AlarmKit / Android exact+FSI).
enum PrayerAlarmAuthorizationStatus {
  notDetermined,
  authorized,
  denied,
  unavailable,
}

/// Shared Flutter scheduling layer for Prayer Alarms.
///
/// Soft prayer reminders remain in [AppNotificationService]. App Lock / Screen
/// Time shielding remains separate. This service only owns native prayer alarms.
class PrayerAlarmService {
  PrayerAlarmService._();

  static final PrayerAlarmService instance = PrayerAlarmService._();

  static const MethodChannel _channel = MethodChannel(
    'com.app.deenly.deenly/prayer_alarm',
  );

  /// Schedule horizon. Kept modest for AlarmKit limits but long enough that
  /// users who don't open the app for a couple of days still get alarms.
  static const int _daysAhead = 7;

  bool _initialized = false;
  Future<void> _syncSerial = Future<void>.value();
  String? _lastScheduleSignature;
  PrayerAlarmCapabilities? _cachedCapabilities;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    try {
      _cachedCapabilities = await getCapabilities();
    } catch (error, stack) {
      LoggerService.instance.warning(
        'PRAYER_ALARM',
        'initialize capabilities failed: $error',
        error: error,
        stackTrace: stack,
      );
    }
  }

  Future<PrayerAlarmCapabilities> getCapabilities({
    bool forceRefresh = false,
  }) async {
    if (!forceRefresh && _cachedCapabilities != null) {
      return _cachedCapabilities!;
    }
    try {
      final raw = await _channel.invokeMethod<Map<dynamic, dynamic>>(
        'getCapabilities',
      );
      _cachedCapabilities = PrayerAlarmCapabilities.fromMap(
        raw ?? const <dynamic, dynamic>{},
      );
    } on MissingPluginException {
      _cachedCapabilities = PrayerAlarmCapabilities(
        platform: Platform.isIOS
            ? 'ios'
            : Platform.isAndroid
            ? 'android'
            : 'unknown',
        implementation: 'none',
        supportsNativeAlarm: false,
        supportsFullScreen: false,
        requiresAlarmKitEntitlement: false,
      );
    } catch (error, stack) {
      LoggerService.instance.warning(
        'PRAYER_ALARM',
        'getCapabilities failed: $error',
        error: error,
        stackTrace: stack,
      );
      _cachedCapabilities = PrayerAlarmCapabilities(
        platform: 'unknown',
        implementation: 'none',
        supportsNativeAlarm: false,
        supportsFullScreen: false,
        requiresAlarmKitEntitlement: false,
      );
    }
    return _cachedCapabilities!;
  }

  Future<PrayerAlarmAuthorizationStatus> getAuthorizationStatus() async {
    try {
      final raw = await _channel.invokeMethod<String>('getAuthorizationStatus');
      return _parseAuth(raw);
    } on MissingPluginException {
      return PrayerAlarmAuthorizationStatus.unavailable;
    } catch (error, stack) {
      LoggerService.instance.warning(
        'PRAYER_ALARM',
        'getAuthorizationStatus failed: $error',
        error: error,
        stackTrace: stack,
      );
      return PrayerAlarmAuthorizationStatus.unavailable;
    }
  }

  Future<PrayerAlarmAuthorizationStatus> requestAuthorization() async {
    try {
      final raw = await _channel.invokeMethod<String>('requestAuthorization');
      return _parseAuth(raw);
    } on MissingPluginException {
      return PrayerAlarmAuthorizationStatus.unavailable;
    } catch (error, stack) {
      LoggerService.instance.warning(
        'PRAYER_ALARM',
        'requestAuthorization failed: $error',
        error: error,
        stackTrace: stack,
      );
      return PrayerAlarmAuthorizationStatus.denied;
    }
  }

  Future<bool> openFullScreenIntentSettings() async {
    if (!Platform.isAndroid) return false;
    try {
      final opened = await _channel.invokeMethod<bool>(
        'openFullScreenIntentSettings',
      );
      return opened ?? false;
    } catch (error, stack) {
      LoggerService.instance.warning(
        'PRAYER_ALARM',
        'openFullScreenIntentSettings failed: $error',
        error: error,
        stackTrace: stack,
      );
      return false;
    }
  }

  /// Opens Android exact-alarm settings (API 31+). No-op on other platforms.
  Future<bool> openExactAlarmSettings() async {
    if (!Platform.isAndroid) return false;
    try {
      final opened = await _channel.invokeMethod<bool>(
        'openExactAlarmSettings',
      );
      return opened ?? false;
    } catch (error, stack) {
      LoggerService.instance.warning(
        'PRAYER_ALARM',
        'openExactAlarmSettings failed: $error',
        error: error,
        stackTrace: stack,
      );
      return false;
    }
  }

  /// True when native scheduling is allowed for the current platform.
  Future<bool> isSchedulingAuthorized() async {
    final capabilities = await getCapabilities();
    if (!capabilities.supportsNativeAlarm) return false;
    final auth = await getAuthorizationStatus();
    return auth == PrayerAlarmAuthorizationStatus.authorized;
  }

  Future<bool> canUseFullScreenIntent() async {
    if (!Platform.isAndroid) return false;
    try {
      final allowed = await _channel.invokeMethod<bool>(
        'canUseFullScreenIntent',
      );
      return allowed ?? false;
    } catch (_) {
      return false;
    }
  }

  /// Consumes a pending "I've Prayed" action written by native alarm UI.
  Future<TrackablePrayer?> consumePendingPrayedAction() async {
    try {
      final prayerName = await _channel.invokeMethod<String>(
        'consumePendingPrayedAction',
      );
      if (prayerName == null || prayerName.isEmpty) return null;
      return TrackablePrayer.values
          .where((value) => value.name == prayerName)
          .firstOrNull;
    } on MissingPluginException {
      return null;
    } catch (error, stack) {
      LoggerService.instance.warning(
        'PRAYER_ALARM',
        'consumePendingPrayedAction failed: $error',
        error: error,
        stackTrace: stack,
      );
      return null;
    }
  }

  Future<void> cancelAll() async {
    _lastScheduleSignature = null;
    try {
      await _channel.invokeMethod<void>('cancelAll');
    } on MissingPluginException {
      // No native bridge in tests / unsupported platforms.
    } catch (error, stack) {
      LoggerService.instance.warning(
        'PRAYER_ALARM',
        'cancelAll failed: $error',
        error: error,
        stackTrace: stack,
      );
    }
  }

  /// Rebuilds native prayer alarms from current prayer times + settings.
  Future<void> rescheduleAlarms({
    required double latitude,
    required double longitude,
    bool forceReschedule = false,
    AppLocalizations? localizations,
  }) async {
    final run = _syncSerial.then((_) async {
      await initialize();
      final enabled = await StorageService.prayerAlarmsEnabled;
      if (!enabled) {
        await cancelAll();
        return;
      }

      final capabilities = await getCapabilities(forceRefresh: true);
      if (!capabilities.supportsNativeAlarm) {
        // Soft reminders already cover pre-AlarmKit / unsupported devices.
        await cancelAll();
        LoggerService.instance.info(
          'PRAYER_ALARM',
          'native alarms unavailable; using notification fallback only '
              '(implementation=${capabilities.implementation})',
        );
        return;
      }

      final auth = await getAuthorizationStatus();
      if (auth == PrayerAlarmAuthorizationStatus.denied ||
          auth == PrayerAlarmAuthorizationStatus.unavailable) {
        // Permission revoked — remove any leftover native alarms.
        await cancelAll();
        LoggerService.instance.info(
          'PRAYER_ALARM',
          'cancel schedule; authorization=$auth',
        );
        return;
      }
      if (auth == PrayerAlarmAuthorizationStatus.notDetermined) {
        // Wait for an explicit settings prompt; avoid surprising system sheets.
        return;
      }

      final prayerSettingsRaw = await StorageService.prayerSettingsJson;
      final prayerSettings = prayerSettingsRaw == null
          ? PrayerSettingsState.defaults()
          : PrayerSettingsState.fromJson(prayerSettingsRaw);
      final snoozeMinutes = await StorageService.prayerAlarmSnoozeMinutes;
      final l10n = localizations ?? await _resolveLocalizations();
      final calculationMethod = await StorageService.calculationMethod ?? '';
      final asrMethod = await StorageService.asrMethod ?? '';
      final now = DateTime.now();
      final timeZoneName = now.timeZoneName;
      final alarms = <Map<String, dynamic>>[];
      final signatureParts = <String>[
        latitude.toStringAsFixed(4),
        longitude.toStringAsFixed(4),
        snoozeMinutes.toString(),
        calculationMethod,
        asrMethod,
        timeZoneName,
        l10n.localeName,
        capabilities.implementation,
      ];

      // Calendar-day iteration (not Duration) so DST transitions cannot skip a day.
      final today = DateTime(now.year, now.month, now.day);
      for (var dayOffset = 0; dayOffset < _daysAhead; dayOffset++) {
        final day = DateTime(today.year, today.month, today.day + dayOffset);
        final data = HomePrayerTimesHelper.applyCustomOverrides(
          data: await HomePrayerTimesHelper.generatePrayerTimesForDate(
            latitude: latitude,
            longitude: longitude,
            date: day,
          ),
          overridesMinutesSinceMidnight: prayerSettings.customTimeOverrides,
          referenceTime: DateTime(day.year, day.month, day.day, 12),
        );

        for (final slot in data.slots) {
          final prayer = slot.id.trackablePrayer;
          if (prayer == null) continue;
          final entry = prayerSettings.forPrayer(prayer);
          if (!entry.alarmEnabled) continue;
          if (!slot.time.isAfter(now)) continue;
          // AlarmKit cannot present a truly silent alarm; skip mute for native.
          if (entry.sound == PrayerNotificationSound.mute &&
              capabilities.isAlarmKit) {
            continue;
          }

          final dayKey =
              '${slot.time.year}-${slot.time.month.toString().padLeft(2, '0')}-${slot.time.day.toString().padLeft(2, '0')}';
          final alarmId = '${prayer.name}_$dayKey';
          final prayerLabel = prayer.label(l10n);
          final snoozeOptions = StorageService.prayerAlarmSnoozeOptionMinutes;
          final payload = <String, dynamic>{
            'id': alarmId,
            'prayer': prayer.name,
            'fireAtMs': slot.time.millisecondsSinceEpoch,
            'title': l10n.prayerAlarmTitle(prayerLabel),
            'subtitle': l10n.prayerAlarmSubtitle,
            'prayerLabel': prayerLabel,
            'badgeLabel': l10n.prayerAlarmBadge,
            'ivePrayedLabel': l10n.prayerAlarmIvePrayed,
            'dismissLabel': l10n.prayerAlarmDismiss,
            'snoozeLabel': l10n.prayerAlarmSnooze,
            'snoozeSectionLabel': l10n.prayerAlarmsSnoozeLabel,
            'snoozeOptionMinutes': snoozeOptions,
            'snoozeOptionLabels': [
              for (final minutes in snoozeOptions)
                l10n.prayerAlarmsSnoozeMinutes(minutes),
            ],
            'sound': entry.sound.name,
            'snoozeMinutes': snoozeMinutes,
          };
          alarms.add(payload);
          signatureParts.add(
            '$alarmId@${slot.time.millisecondsSinceEpoch}:${entry.sound.name}',
          );
        }
      }

      final signature = signatureParts.join('|');
      // Identical alarm set → keep pending setAlarmClock entries. Resume / NTP
      // dirty flags must not cancel upcoming Fajr→Isha alarms.
      if (signature == _lastScheduleSignature) {
        return;
      }

      try {
        await _channel.invokeMethod<void>('scheduleAlarms', {
          'alarms': alarms,
          'replaceAll': true,
        });
        _lastScheduleSignature = signature;
        LoggerService.instance.info(
          'PRAYER_ALARM',
          'scheduled ${alarms.length} alarms '
              '(implementation=${capabilities.implementation})',
        );
      } on PlatformException catch (error, stack) {
        LoggerService.instance.error(
          'PRAYER_ALARM',
          'scheduleAlarms failed: ${error.message}',
          error: error,
          stackTrace: stack,
        );
      } on MissingPluginException {
        // Unsupported in current runtime.
      }
    });
    _syncSerial = run.catchError((Object _) {});
    await run;
  }

  PrayerAlarmAuthorizationStatus _parseAuth(String? raw) {
    switch (raw) {
      case 'authorized':
        return PrayerAlarmAuthorizationStatus.authorized;
      case 'denied':
        return PrayerAlarmAuthorizationStatus.denied;
      case 'notDetermined':
        return PrayerAlarmAuthorizationStatus.notDetermined;
      case 'unavailable':
      default:
        return PrayerAlarmAuthorizationStatus.unavailable;
    }
  }

  Future<AppLocalizations> _resolveLocalizations() async {
    final code = await StorageService.localeCode;
    try {
      return lookupAppLocalizations(_localeFromPrefsCode(code));
    } catch (_) {
      return lookupAppLocalizations(const Locale('en'));
    }
  }

  Locale _localeFromPrefsCode(String? code) {
    if (code == null || code.isEmpty) return const Locale('en');
    final primary = code.replaceAll('_', '-').split('-').first.toLowerCase();
    return Locale(primary);
  }
}

@visibleForTesting
String prayerAlarmIdFor(TrackablePrayer prayer, DateTime when) {
  final dayKey =
      '${when.year}-${when.month.toString().padLeft(2, '0')}-${when.day.toString().padLeft(2, '0')}';
  return '${prayer.name}_$dayKey';
}
