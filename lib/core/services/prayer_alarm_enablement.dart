import 'dart:io';

import 'permission_service.dart';
import 'prayer_alarm_service.dart';
import 'storage_service.dart';

/// Outcome of turning the Prayer Alarms master schedule path on.
enum PrayerAlarmEnablementStatus {
  /// Native alarms can schedule (or soft fallback when native is unavailable).
  ready,

  /// Notification permission denied (Android alarm presentation path).
  notificationDenied,

  /// Alarm / exact-alarm permission denied.
  denied,

  /// User left for system Settings; complete on resume.
  awaitingSettings,
}

/// Result of [PrayerAlarmEnablement.ensureReadyToSchedule].
class PrayerAlarmEnablementResult {
  const PrayerAlarmEnablementResult({
    required this.status,
    required this.authorization,
    required this.capabilities,
    this.canUseFullScreenIntent,
  });

  final PrayerAlarmEnablementStatus status;
  final PrayerAlarmAuthorizationStatus authorization;
  final PrayerAlarmCapabilities capabilities;
  final bool? canUseFullScreenIntent;

  bool get isReady =>
      status == PrayerAlarmEnablementStatus.ready ||
      status == PrayerAlarmEnablementStatus.awaitingSettings;

  bool get canShowAlarmOn => status == PrayerAlarmEnablementStatus.ready;
}

/// Shared gate used by Home and Settings so enabling a prayer alarm always
/// requests permission and flips the master schedule flag the same way.
abstract final class PrayerAlarmEnablement {
  /// Whether the UI may show a prayer alarm toggle as ON.
  static bool canSchedule({
    required bool masterEnabled,
    required PrayerAlarmCapabilities? capabilities,
    required PrayerAlarmAuthorizationStatus authorization,
  }) {
    if (!masterEnabled) return false;
    if (capabilities == null) return false;
    if (!capabilities.supportsNativeAlarm) return true;
    return authorization == PrayerAlarmAuthorizationStatus.authorized;
  }

  static bool effectiveAlarmEnabled({
    required bool storedAlarmEnabled,
    required bool masterEnabled,
    required PrayerAlarmCapabilities? capabilities,
    required PrayerAlarmAuthorizationStatus authorization,
  }) {
    return storedAlarmEnabled &&
        canSchedule(
          masterEnabled: masterEnabled,
          capabilities: capabilities,
          authorization: authorization,
        );
  }

  /// Turns master scheduling ON and requests platform permissions.
  ///
  /// On denial, master is stored OFF and native alarms are cancelled.
  static Future<PrayerAlarmEnablementResult> ensureReadyToSchedule() async {
    if (Platform.isAndroid) {
      final notificationsOk = await PermissionService.requestNotification();
      if (!notificationsOk) {
        await StorageService.setPrayerAlarmsEnabled(false);
        await PrayerAlarmService.instance.cancelAll();
        final capabilities = await PrayerAlarmService.instance.getCapabilities(
          forceRefresh: true,
        );
        final auth = await PrayerAlarmService.instance.getAuthorizationStatus();
        return PrayerAlarmEnablementResult(
          status: PrayerAlarmEnablementStatus.notificationDenied,
          authorization: auth,
          capabilities: capabilities,
          canUseFullScreenIntent: await PrayerAlarmService.instance
              .canUseFullScreenIntent(),
        );
      }
    }

    await StorageService.setPrayerAlarmsEnabled(true);

    final capabilities = await PrayerAlarmService.instance.getCapabilities(
      forceRefresh: true,
    );
    final fsi = Platform.isAndroid
        ? await PrayerAlarmService.instance.canUseFullScreenIntent()
        : null;

    if (!capabilities.supportsNativeAlarm) {
      await PrayerAlarmService.instance.cancelAll();
      return PrayerAlarmEnablementResult(
        status: PrayerAlarmEnablementStatus.ready,
        authorization: PrayerAlarmAuthorizationStatus.unavailable,
        capabilities: capabilities,
        canUseFullScreenIntent: fsi,
      );
    }

    var auth = await PrayerAlarmService.instance.getAuthorizationStatus();
    var requested = auth;
    if (auth != PrayerAlarmAuthorizationStatus.authorized) {
      requested = await PrayerAlarmService.instance.requestAuthorization();
    }
    auth = await PrayerAlarmService.instance.getAuthorizationStatus();
    if (requested == PrayerAlarmAuthorizationStatus.authorized) {
      auth = PrayerAlarmAuthorizationStatus.authorized;
    }

    if (auth == PrayerAlarmAuthorizationStatus.authorized) {
      return PrayerAlarmEnablementResult(
        status: PrayerAlarmEnablementStatus.ready,
        authorization: auth,
        capabilities: capabilities,
        canUseFullScreenIntent: fsi,
      );
    }

    if (requested == PrayerAlarmAuthorizationStatus.notDetermined) {
      // Intent stays ON in storage; UI stays off until resume confirms auth.
      return PrayerAlarmEnablementResult(
        status: PrayerAlarmEnablementStatus.awaitingSettings,
        authorization: auth,
        capabilities: capabilities,
        canUseFullScreenIntent: fsi,
      );
    }

    await StorageService.setPrayerAlarmsEnabled(false);
    await PrayerAlarmService.instance.cancelAll();
    return PrayerAlarmEnablementResult(
      status: PrayerAlarmEnablementStatus.denied,
      authorization: auth,
      capabilities: capabilities,
      canUseFullScreenIntent: fsi,
    );
  }

  static Future<void> disableScheduling() async {
    await StorageService.setPrayerAlarmsEnabled(false);
    await PrayerAlarmService.instance.cancelAll();
  }
}
