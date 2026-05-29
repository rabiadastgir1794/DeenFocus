import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Locale;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'focus_enforcement_service.dart';
import 'storage_service.dart';
import '../../features/focus/model/focus_models.dart';
import '../../l10n/app_localizations.dart';
import '../../features/home/helpers/home_prayer_times_helper.dart';
import '../../features/home/model/home_models.dart';

void _onNotificationResponse(NotificationResponse response) {
  unawaited(
    FocusEnforcementService.appendDebugLog(
      'notifications.response',
      'id=${response.id} actionId=${response.actionId} payload=${response.payload} input=${response.input} type=${response.notificationResponseType.name}',
    ),
  );
}

class AppNotificationService {
  AppNotificationService._();

  static final AppNotificationService instance = AppNotificationService._();

  static const _prayerChannel = AndroidNotificationChannel(
    'prayer_times',
    'General Reminder',
    description: 'Prayer time reminders from Deenly.',
    importance: Importance.max,
  );

  static const _focusChannel = AndroidNotificationChannel(
    'focus_modes',
    'Focus modes',
    description: 'Sleep time and other focus mode updates from Deenly.',
    importance: Importance.high,
  );

  static const _darwinPrayerDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    threadIdentifier: 'deenly.prayer_reminder',
  );

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static const MethodChannel _focusMethodChannel = MethodChannel(
    'com.app.deenly.deenly/focus',
  );
  bool _initialized = false;
  Future<void> _prayerSyncSerial = Future<void>.value();
  Future<void> _focusSyncSerial = Future<void>.value();
  String? _lastPrayerScheduleSignature;
  String? _lastFocusScheduleSignature;

  /// Forces the next [syncFocusNotifications] to rebuild pending alerts.
  void invalidateFocusScheduleCache() {
    _lastFocusScheduleSignature = null;
  }

  bool _hadIosFocusNotificationPendingCapSkip = false;
  bool _iosFocusNotificationsRetryPending = false;

  Future<void> initialize() async {
    if (_initialized) return;

    tz.initializeTimeZones();
    await _setLocalTimezone();

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    // Do not request notification permission here — that runs from onboarding
    // (or settings). Defaults on DarwinInitializationSettings are all `true`,
    // which would show the system prompt during [initialize] at app launch.
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestSoundPermission: false,
      requestBadgePermission: false,
    );

    await _plugin.initialize(
      const InitializationSettings(
        android: androidSettings,
        iOS: darwinSettings,
        macOS: darwinSettings,
      ),
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(_prayerChannel);
    await androidPlugin?.createNotificationChannel(_focusChannel);

    _initialized = true;
  }

  Future<bool> _hasNotificationPermission() async {
    final enabledByUser = await StorageService.appNotificationsEnabled;
    if (!enabledByUser) return false;
    if (Platform.isAndroid) {
      final androidPlugin = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      final granted = await androidPlugin?.areNotificationsEnabled();
      if (granted == true) return true;
    }
    final status = await Permission.notification.status;
    return status.isGranted || status.isLimited;
  }

  /// Enough IDs for multiple days × 6 prayer indices (sunrise skipped when scheduling).
  static const int _prayerNotificationIdStart = 1000;
  static const int _prayerNotificationIdEnd = 1199;

  /// iOS allows at most 64 pending local notifications per app; leave headroom
  /// so focus transition alerts are not silently dropped after prayer reminders.
  static const int _iosMaxPendingLocalNotifications = 62;

  Future<void> reschedulePrayerNotifications({
    required double latitude,
    required double longitude,
    bool forceReschedule = false,
    int? daysAheadOverride,
  }) async {
    final run = _prayerSyncSerial.then((_) async {
      final isSpanish = await _isSpanishLocale();
      await initialize();
      if (!await _hasNotificationPermission()) {
        _lastPrayerScheduleSignature = null;
        return;
      }
      await _ensureAndroidExactAlarmOrFallback();
      // Match device timezone after travel / DST changes.
      await _setLocalTimezone();

      final now = DateTime.now();
      final int daysAhead;
      if (daysAheadOverride != null) {
        daysAhead = daysAheadOverride.clamp(1, 7);
      } else {
        // iOS: keep the batch small so Salah/Night focus alerts still fit under the
        // 64 pending-notification limit. Android uses the same horizon as focus
        // scheduling; refill extends on Salah home unlock.
        daysAhead = 2;
      }
      final datasets = <({int dayOffset, HomePrayerTimesData data})>[
        for (var d = 0; d < daysAhead; d++)
          (
            dayOffset: d,
            // Keep prayer reminder times deterministic and aligned with focus
            // scheduling. The cached helper can briefly lag across resume/day
            // boundaries, which is enough to fire a reminder that does not line
            // up with the active lock window.
            data: await HomePrayerTimesHelper.generatePrayerTimesForDate(
              latitude: latitude,
              longitude: longitude,
              date: now.add(Duration(days: d)),
            ),
          ),
      ];

      final signature = _buildPrayerScheduleSignature(
        latitude: latitude,
        longitude: longitude,
        datasets: datasets,
      );
      if (_lastPrayerScheduleSignature == signature && !forceReschedule) {
        await FocusEnforcementService.appendDebugLog(
          'notifications.prayer.sync',
          'skipped reschedule because signature is unchanged',
        );
        return;
      }

      // Cancel only our prayer slot IDs. Do not use [cancelAll] — it removes every
      // notification from the tray (delivered + other channels), so reminders and
      // focus notifications would vanish whenever we reschedule (resume, refresh).
      await _cancelRange(_prayerNotificationIdStart, _prayerNotificationIdEnd);

      // Schedule up to [daysAhead] days — stable IDs keep replacements deterministic.
      for (final dataset in datasets) {
        for (final slot in dataset.data.slots.where(
          (slot) => slot.id != HomePrayerId.sunrise,
        )) {
          final id =
              _prayerNotificationIdStart +
              dataset.dayOffset * 20 +
              _slotIndex(slot.id);
          await _scheduleIfFuture(
            id: id,
            when: slot.time,
            title: _prayerTimeTitle(slot.id, isSpanish: isSpanish),
            body: _prayerTimeBody(slot.id, isSpanish: isSpanish),
            details: _prayerNotificationDetails,
            // Avoid alarm-clock UI side effects ("approaching"/upcoming alarm).
            preferAlarmClock: false,
          );
        }
      }

      _lastPrayerScheduleSignature = signature;
    });
    _prayerSyncSerial = run.catchError((Object _) {});
    await run;
  }

  /// Night discipline: one ID per upcoming lock / unlock (same horizon as prayer batch).
  static const int _nightLockNotificationIdStart = 4000;
  static const int _nightUnlockNotificationIdEnd = 4016;
  static const int _salahLockNotificationIdStart = 3000;
  static const int _salahUnlockNotificationIdStart = 3100;
  static const int _salahUnlockNotificationIdEnd = 3139;

  Future<void> syncFocusNotifications({
    required FocusSettings settings,
    required List<Map<String, dynamic>> scheduledTransitions,
  }) async {
    final run = _focusSyncSerial.then((_) async {
      await initialize();
      if (!await _hasNotificationPermission()) {
        _lastFocusScheduleSignature = null;
        _iosFocusNotificationsRetryPending = false;
        await _cancelRange(2000, 2059);
        await _cancelRange(
          _salahLockNotificationIdStart,
          _salahUnlockNotificationIdEnd,
        );
        await _cancelRange(
          _nightLockNotificationIdStart,
          _nightUnlockNotificationIdEnd,
        );
        return;
      }
      await _ensureAndroidExactAlarmOrFallback();
      await _setLocalTimezone();

      const includeUnlockNotifications = true;
      final signature = await _buildFocusScheduleSignature(
        settings: settings,
        includeUnlockNotifications: includeUnlockNotifications,
        scheduledTransitions: scheduledTransitions,
      );
      if (_lastFocusScheduleSignature == signature &&
          !_iosFocusNotificationsRetryPending) {
        await FocusEnforcementService.appendDebugLog(
          'notifications.focus.sync',
          'skipped reschedule because signature is unchanged',
        );
        return;
      }

      await _cancelRange(2000, 2059);
      // Clear legacy Salah/night ID ranges as part of the rebuild so old
      // pending requests cannot pile up after upgrading to the deduped flow.
      await _cancelRange(
        _salahLockNotificationIdStart,
        _salahUnlockNotificationIdEnd,
      );
      await _cancelRange(
        _nightLockNotificationIdStart,
        _nightUnlockNotificationIdEnd,
      );

      await _scheduleFocusTransitionNotifications(
        scheduledTransitions: scheduledTransitions,
        includeUnlockNotifications: includeUnlockNotifications,
      );

      if (_hadIosFocusNotificationPendingCapSkip) {
        _iosFocusNotificationsRetryPending = true;
        await FocusEnforcementService.appendDebugLog(
          'notifications.focus.sync',
          'iOS pending-notification cap hit; will retry on next focus sync',
        );
      } else {
        _iosFocusNotificationsRetryPending = false;
      }
      _lastFocusScheduleSignature = signature;
    });
    _focusSyncSerial = run.catchError((Object _) {});
    await run;
  }

  Future<void> _scheduleFocusTransitionNotifications({
    required List<Map<String, dynamic>> scheduledTransitions,
    required bool includeUnlockNotifications,
  }) async {
    _hadIosFocusNotificationPendingCapSkip = false;
    final l10n = await _focusNotificationsLocalizations();
    final transitions =
        scheduledTransitions
            .where((transition) {
              final atMillis = (transition['atMillis'] as num?)?.toInt() ?? 0;
              if (atMillis <= DateTime.now().millisecondsSinceEpoch) {
                return false;
              }
              final isLocked = transition['isLocked'] as bool? ?? false;
              final mode = transition['activeMode'] as String?;
              if (!isLocked && !includeUnlockNotifications) return false;
              final hint = transition['notificationHint'] as String?;
              // Night already notified; Salah ended — re-lock without a duplicate night alert.
              if (hint == 'nightResumeSilent') {
                unawaited(
                  FocusEnforcementService.appendDebugLog(
                    'notifications.focus.skip',
                    'nightResumeSilent atMillis=$atMillis '
                        '(duplicate night notification suppressed)',
                  ),
                );
                return false;
              }
              // Prayer reminders already cover Salah start; avoid a second alert.
              // Exception: nightLock during an active Salah window (night starts inside prayer).
              if (isLocked &&
                  mode == FocusModeType.salah.name &&
                  hint != 'nightLock') {
                return false;
              }
              final prayerId = transition['prayerId'] as String?;
              // Salah windows do not auto-open apps (shield / latch until Home unlock).
              // Do not schedule Salah-boundary unlock notifications on mobile.
              if (!kIsWeb &&
                  (Platform.isIOS || Platform.isAndroid) &&
                  !isLocked &&
                  prayerId != null) {
                return false;
              }
              return isLocked || includeUnlockNotifications;
            })
            .toList(growable: false)
          ..sort((a, b) {
            final am = (a['atMillis'] as num?)?.toInt() ?? 0;
            final bm = (b['atMillis'] as num?)?.toInt() ?? 0;
            return am.compareTo(bm);
          });

    var lockId = _salahLockNotificationIdStart;
    var unlockId = _salahUnlockNotificationIdStart;
    for (final transition in transitions) {
      final atMillis = (transition['atMillis'] as num?)?.toInt() ?? 0;
      if (atMillis <= 0) continue;
      final isLocked = transition['isLocked'] as bool? ?? false;
      final mode = transition['activeMode'] as String?;
      final notificationHint = transition['notificationHint'] as String?;
      final prayerId = transition['prayerId'] as String?;
      final at = DateTime.fromMillisecondsSinceEpoch(atMillis);
      final id = isLocked ? lockId++ : unlockId++;
      final title = _focusTransitionTitle(
        isLocked: isLocked,
        mode: mode,
        notificationHint: notificationHint,
        prayerId: prayerId,
        l10n: l10n,
      );
      final body = _focusTransitionBody(
        isLocked: isLocked,
        mode: mode,
        notificationHint: notificationHint,
        prayerId: prayerId,
        l10n: l10n,
      );
      await FocusEnforcementService.appendDebugLog(
        'notifications.focusTransition.schedule',
        'id=$id at=${at.toIso8601String()} locked=$isLocked mode=$mode hint=$notificationHint prayerId=$prayerId',
      );
      final scheduled = await _scheduleIfFuture(
        id: id,
        when: at,
        title: title,
        body: body,
        details: _nightTransitionNotificationDetails,
        preferAlarmClock: false,
      );
      if (Platform.isIOS && !scheduled && at.isAfter(DateTime.now())) {
        _hadIosFocusNotificationPendingCapSkip = true;
      }
    }
  }

  Future<AppLocalizations> _focusNotificationsLocalizations() async {
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

  String _focusTransitionTitle({
    required bool isLocked,
    required String? mode,
    required String? notificationHint,
    required String? prayerId,
    required AppLocalizations l10n,
  }) {
    if (notificationHint == 'nightLock') {
      return l10n.focusNotifNightModeTitle;
    }
    if (notificationHint == 'nightMorning') {
      return 'Good Morning';
    }
    if (!isLocked && mode == FocusModeType.salah.name) {
      return l10n.focusNotifSalahCompleteTitle;
    }
    if (isLocked) return l10n.focusNotifAppsLockedTitle;
    return l10n.focusNotifAppsUnlockedTitle;
  }

  String _focusTransitionBody({
    required bool isLocked,
    required String? mode,
    required String? notificationHint,
    required String? prayerId,
    required AppLocalizations l10n,
  }) {
    if (notificationHint == 'nightLock') {
      return l10n.focusNotifNightLockedBody;
    }
    if (notificationHint == 'nightMorning') {
      if (isLocked) {
        return 'Night Focus Mode is complete. Open Deenly to unlock apps when you are ready.';
      }
      return 'Good morning! Apps are now available.';
    }
    if (!isLocked && mode == FocusModeType.salah.name) {
      return l10n.focusNotifSalahCompleteBody;
    }
    if (!isLocked) return l10n.focusNotifAppsNowAvailableBody;
    if (isLocked && mode == FocusModeType.salah.name) {
      return l10n.focusNotifSalahLockedBody;
    }
    if (mode == FocusModeType.nightDiscipline.name) {
      return l10n.focusNotifNightLockedBody;
    }
    return l10n.focusNotifGenericLockedBody;
  }

  NotificationDetails get _nightTransitionNotificationDetails =>
      NotificationDetails(
        android: AndroidNotificationDetails(
          _focusChannel.id,
          _focusChannel.name,
          channelDescription: _focusChannel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          threadIdentifier: 'deenly.focus_transition',
        ),
        macOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          threadIdentifier: 'deenly.focus_transition',
        ),
      );

  NotificationDetails get _prayerNotificationDetails =>
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_times',
          'General Reminder',
          channelDescription: 'Prayer time reminders from Deenly.',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: _darwinPrayerDetails,
        macOS: _darwinPrayerDetails,
      );

  Future<bool> _scheduleIfFuture({
    required int id,
    required DateTime when,
    required String title,
    required String body,
    required NotificationDetails details,
    bool preferAlarmClock = false,
  }) async {
    final safeTitle = title.trim().isEmpty ? 'Deenly' : title.trim();
    final safeBody = body.trim().isEmpty
        ? 'Open Deenly for details.'
        : body.trim();
    final scheduledAt = when.toLocal();
    if (!scheduledAt.isAfter(DateTime.now())) {
      await FocusEnforcementService.appendDebugLog(
        'notifications.skip',
        'id=$id title=$safeTitle scheduledAt=${scheduledAt.toIso8601String()} reason=past',
      );
      return false;
    }

    if (Platform.isIOS) {
      final pending = await _plugin.pendingNotificationRequests();
      if (pending.length >= _iosMaxPendingLocalNotifications) {
        await FocusEnforcementService.appendDebugLog(
          'notifications.skip',
          'id=$id title=$safeTitle reason=ios_pending_cap pending=${pending.length}',
        );
        return false;
      }
    }

    await FocusEnforcementService.appendDebugLog(
      'notifications.schedule',
      'id=$id title=$safeTitle scheduledAt=${scheduledAt.toIso8601String()}',
    );

    final whenTz = tz.TZDateTime.from(scheduledAt, tz.local);

    if (Platform.isAndroid) {
      Future<void> scheduleWith(AndroidScheduleMode mode) {
        return _plugin.zonedSchedule(
          id,
          safeTitle,
          safeBody,
          whenTz,
          details,
          androidScheduleMode: mode,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
        );
      }

      try {
        if (preferAlarmClock) {
          // One alarm per prayer — avoids OEMs collapsing idle exact alarms.
          await scheduleWith(AndroidScheduleMode.alarmClock);
        } else {
          await scheduleWith(AndroidScheduleMode.exactAllowWhileIdle);
        }
      } on PlatformException catch (e, st) {
        assert(() {
          debugPrint(
            'notifications: primary schedule failed ($e), retrying. $st',
          );
          return true;
        }());
        try {
          await scheduleWith(AndroidScheduleMode.exactAllowWhileIdle);
        } on PlatformException catch (e2, st2) {
          assert(() {
            debugPrint(
              'notifications: exact fallback failed ($e2), inexact. $st2',
            );
            return true;
          }());
          await scheduleWith(AndroidScheduleMode.inexactAllowWhileIdle);
        }
      }
    } else {
      await _plugin.zonedSchedule(
        id,
        safeTitle,
        safeBody,
        whenTz,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
    return true;
  }

  /// Exact alarms while idle require [Permission.scheduleExactAlarm] on many
  /// Android 12+ builds; without it, [AndroidScheduleMode.exactAllowWhileIdle]
  /// scheduling fails.
  Future<void> _ensureAndroidExactAlarmOrFallback() async {
    if (!Platform.isAndroid) return;
    final status = await Permission.scheduleExactAlarm.status;
    if (status.isGranted || status.isLimited) return;
    await Permission.scheduleExactAlarm.request();
  }

  Future<void> _cancelRange(int startInclusive, int endInclusive) async {
    // On iOS, `cancel(id)` can remove delivered entries with the same ID from
    // Notification Center. Route through native pending-only cancellation.
    if (Platform.isIOS) {
      try {
        await _focusMethodChannel.invokeMethod<int>(
          'cancelPendingNotificationRange',
          <String, dynamic>{
            'startInclusive': startInclusive,
            'endInclusive': endInclusive,
          },
        );
        return;
      } on PlatformException {
        // Fall back to plugin behavior below.
      }
    }

    // On macOS, limit to pending IDs so delivered notifications are not cleared.
    if (Platform.isMacOS) {
      final pending = await _plugin.pendingNotificationRequests();
      for (final request in pending) {
        final id = request.id;
        if (id < startInclusive || id > endInclusive) continue;
        await _plugin.cancel(id);
      }
      return;
    }

    // Android: `cancel(id)` clears the status bar entry for that id. Cancelling
    // only [pendingNotificationRequests] is unsafe — the plugin cache can
    // disagree with AlarmManager, leaving stale alarms and breaking new
    // schedules. Cancel every id in range, but skip ids currently shown so tray
    // alerts (e.g. night mode) stay until the user dismisses them.
    if (Platform.isAndroid) {
      final activeIds = <int>{};
      try {
        final active = await _plugin.getActiveNotifications();
        for (final n in active) {
          final nid = n.id;
          if (nid != null) activeIds.add(nid);
        }
      } catch (_) {
        // Older API / unsupported: fall through with empty set → full cancel.
      }
      for (var id = startInclusive; id <= endInclusive; id++) {
        if (activeIds.contains(id)) continue;
        await _plugin.cancel(id);
      }
      return;
    }

    for (var id = startInclusive; id <= endInclusive; id++) {
      await _plugin.cancel(id);
    }
  }

  /// Cancels prayer notification ID range (e.g. before focus sync if IDs ever overlap).

  Future<void> _setLocalTimezone() async {
    try {
      final timezoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneName));
    } catch (_) {
      tz.setLocalLocation(tz.UTC);
    }
  }

  int _slotIndex(HomePrayerId id) {
    switch (id) {
      case HomePrayerId.fajr:
        return 0;
      case HomePrayerId.sunrise:
        return 1;
      case HomePrayerId.dhuhr:
        return 2;
      case HomePrayerId.asr:
        return 3;
      case HomePrayerId.maghrib:
        return 4;
      case HomePrayerId.isha:
        return 5;
    }
  }

  String _prayerLabel(HomePrayerId id, {bool isSpanish = false}) {
    if (isSpanish) {
      switch (id) {
        case HomePrayerId.fajr:
          return 'Fajr';
        case HomePrayerId.sunrise:
          return 'Amanecer';
        case HomePrayerId.dhuhr:
          return 'Dhuhr';
        case HomePrayerId.asr:
          return 'Asr';
        case HomePrayerId.maghrib:
          return 'Maghrib';
        case HomePrayerId.isha:
          return 'Isha';
      }
    }
    switch (id) {
      case HomePrayerId.fajr:
        return 'Fajr';
      case HomePrayerId.sunrise:
        return 'Sunrise';
      case HomePrayerId.dhuhr:
        return 'Dhuhr';
      case HomePrayerId.asr:
        return 'Asr';
      case HomePrayerId.maghrib:
        return 'Maghrib';
      case HomePrayerId.isha:
        return 'Isha';
    }
  }

  String _prayerTimeTitle(HomePrayerId id, {required bool isSpanish}) {
    return "It's time for ${_prayerLabel(id, isSpanish: isSpanish)}";
  }

  String _prayerTimeBody(HomePrayerId id, {required bool isSpanish}) {
    return 'Take a moment for ${_prayerLabel(id, isSpanish: isSpanish)} prayer.';
  }

  Future<bool> _isSpanishLocale() async {
    final code = (await StorageService.localeCode)?.toLowerCase();
    return code != null && code.startsWith('es');
  }

  String _buildPrayerScheduleSignature({
    required double latitude,
    required double longitude,
    required List<({int dayOffset, HomePrayerTimesData data})> datasets,
  }) {
    final prayerParts = <String>[
      latitude.toStringAsFixed(4),
      longitude.toStringAsFixed(4),
    ];
    for (final dataset in datasets) {
      for (final slot in dataset.data.slots.where(
        (slot) => slot.id != HomePrayerId.sunrise,
      )) {
        prayerParts.add(
          '${dataset.dayOffset}:${slot.id.name}:${slot.time.toIso8601String()}',
        );
      }
    }
    return prayerParts.join('|');
  }

  /// Stable signature for focus transition + native schedule sync deduplication.
  Future<String> buildFocusScheduleSignature({
    required FocusSettings settings,
    required List<Map<String, dynamic>> scheduledTransitions,
    bool includeUnlockNotifications = true,
  }) {
    return _buildFocusScheduleSignature(
      settings: settings,
      includeUnlockNotifications: includeUnlockNotifications,
      scheduledTransitions: scheduledTransitions,
    );
  }

  Future<String> _buildFocusScheduleSignature({
    required FocusSettings settings,
    required bool includeUnlockNotifications,
    required List<Map<String, dynamic>> scheduledTransitions,
  }) async {
    final localeCode = await StorageService.localeCode ?? 'en';
    final parts = <String>[
      'locale=$localeCode',
      'night=${settings.nightDisciplineEnabled}',
      'salah=${settings.salahModeEnabled}',
      'start=${settings.nightRange.startHour}:${settings.nightRange.startMinute}',
      'end=${settings.nightRange.endHour}:${settings.nightRange.endMinute}',
      'unlock=$includeUnlockNotifications',
      'tempUnlockUntil=${settings.temporarilyUnlockedUntil?.millisecondsSinceEpoch ?? 0}',
      'child=${settings.childModeEnabled}',
      'childUntil=${settings.childLockedUntil?.millisecondsSinceEpoch ?? 0}',
      'salahLatch=${settings.iosSalahShieldLatchEpochMillis ?? 0}',
    ];
    for (final transition in scheduledTransitions) {
      final atMillis = (transition['atMillis'] as num?)?.toInt() ?? 0;
      final isLocked = transition['isLocked'] as bool? ?? false;
      final mode = transition['activeMode'] as String? ?? '';
      final hint = transition['notificationHint'] as String? ?? '';
      final prayerId = transition['prayerId'] as String? ?? '';
      final forceNative = transition['forceNativeNightLock'] == true ? 1 : 0;
      final skipNative = transition['skipNativeSchedule'] == true ? 1 : 0;
      final setsSalahLatch = transition['setsSalahShieldLatch'] == true ? 1 : 0;
      final clearsSalahLatch = transition['clearIosSalahShieldLatch'] == true
          ? 1
          : 0;
      parts.add(
        'transition=$atMillis:${isLocked ? 1 : 0}:$mode:$hint:$prayerId:$forceNative:$skipNative:$setsSalahLatch:$clearsSalahLatch',
      );
    }

    return parts.join('|');
  }
}
