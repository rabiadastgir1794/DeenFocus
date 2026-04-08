import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'focus_enforcement_service.dart';
import '../../features/focus/model/focus_models.dart';
import '../../features/home/helpers/home_prayer_times_helper.dart';
import '../../features/home/model/home_models.dart';

class AppNotificationService {
  AppNotificationService._();

  static final AppNotificationService instance = AppNotificationService._();

  static const _prayerChannel = AndroidNotificationChannel(
    'prayer_times',
    'Prayer Times',
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
  );

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static const MethodChannel _focusMethodChannel = MethodChannel(
    'com.app.deenly.deenly/focus',
  );
  bool _initialized = false;

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

  /// Enough IDs for 7 days × 6 prayer indices (sunrise skipped when scheduling).
  static const int _prayerNotificationIdStart = 1000;
  static const int _prayerNotificationIdEnd = 1199;

  Future<void> reschedulePrayerNotifications({
    required double latitude,
    required double longitude,
  }) async {
    await initialize();
    if (!await _hasNotificationPermission()) {
      return;
    }
    await _ensureAndroidExactAlarmOrFallback();
    // Match device timezone after travel / DST changes.
    await _setLocalTimezone();
    // Cancel only our prayer slot IDs. Do not use [cancelAll] — it removes every
    // notification from the tray (delivered + other channels), so reminders and
    // focus notifications would vanish whenever we reschedule (resume, refresh).
    await _cancelRange(_prayerNotificationIdStart, _prayerNotificationIdEnd);

    final now = DateTime.now();
    // Schedule a full week — many devices batch or drop inexact alarms; using
    // [AndroidScheduleMode.alarmClock] per-slot avoids only the first firing.
    const daysAhead = 7;
    final datasets = <({int dayOffset, HomePrayerTimesData data})>[
      for (var d = 0; d < daysAhead; d++)
        (
          dayOffset: d,
          data: await HomePrayerTimesHelper.getOrGeneratePrayerTimes(
            latitude: latitude,
            longitude: longitude,
            now: now.add(Duration(days: d)),
          ),
        ),
    ];

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
          title: "It's time for ${_prayerLabel(slot.id)}",
          body: 'Take a moment for ${_prayerLabel(slot.id)} prayer.',
          details: _prayerNotificationDetails,
          // Avoid alarm-clock UI side effects ("approaching"/upcoming alarm).
          preferAlarmClock: false,
        );
      }
    }
  }

  /// Night discipline: one ID per upcoming lock / unlock (same horizon as prayer batch).
  static const int _nightLockNotificationIdStart = 4000;
  static const int _nightUnlockNotificationIdStart = 4010;
  static const int _nightUnlockNotificationIdEnd = 4016;

  Future<void> syncFocusNotifications({required FocusSettings settings}) async {
    await initialize();
    if (!await _hasNotificationPermission()) {
      await _cancelRange(2000, 2059);
      await _cancelRange(3000, 3059);
      await _cancelRange(
        _nightLockNotificationIdStart,
        _nightUnlockNotificationIdEnd,
      );
      return;
    }
    await _ensureAndroidExactAlarmOrFallback();
    await _setLocalTimezone();
    await _cancelRange(2000, 2059);
    await _cancelRange(3000, 3059);
    await _cancelRange(
      _nightLockNotificationIdStart,
      _nightUnlockNotificationIdEnd,
    );

    if (!settings.nightDisciplineEnabled) {
      return;
    }

    final range = settings.nightRange;
    final now = DateTime.now();
    final lockTimes = <DateTime>[];
    final unlockTimes = <DateTime>[];
    var probe = now;
    for (
      var iter = 0;
      iter < 48 && (lockTimes.length < 7 || unlockTimes.length < 7);
      iter++
    ) {
      final w = _nightWindowContainingOrNext(range, probe);
      if (w.start.isAfter(now) && lockTimes.length < 7) {
        lockTimes.add(w.start);
      }
      if (w.end.isAfter(now) && unlockTimes.length < 7) {
        unlockTimes.add(w.end);
      }
      probe = w.end.add(const Duration(seconds: 1));
    }

    var lockId = _nightLockNotificationIdStart;
    for (final at in lockTimes) {
      await FocusEnforcementService.appendDebugLog(
        'notifications.nightLock.schedule',
        'id=$lockId at=${at.toIso8601String()}',
      );
      await _scheduleIfFuture(
        id: lockId,
        when: at,
        title: 'Sleep time',
        body: 'Selected apps are locked for your sleep schedule.',
        details: _nightTransitionNotificationDetails,
        preferAlarmClock: false,
      );
      lockId++;
    }

    var unlockId = _nightUnlockNotificationIdStart;
    for (final at in unlockTimes) {
      await FocusEnforcementService.appendDebugLog(
        'notifications.nightUnlock.schedule',
        'id=$unlockId at=${at.toIso8601String()}',
      );
      await _scheduleIfFuture(
        id: unlockId,
        when: at,
        title: 'Sleep time over',
        body: "Selected apps are unlocked until tonight's sleep time.",
        details: _nightTransitionNotificationDetails,
        preferAlarmClock: false,
      );
      unlockId++;
    }
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
        ),
        macOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
        ),
      );

  /// Matches [FocusController._nightWindowContainingOrNext] — sleep window boundaries.
  ({DateTime start, DateTime end}) _nightWindowContainingOrNext(
    FocusTimeRange range,
    DateTime now,
  ) {
    final todayStart = DateTime(
      now.year,
      now.month,
      now.day,
      range.startHour,
      range.startMinute,
    );
    var todayEnd = DateTime(
      now.year,
      now.month,
      now.day,
      range.endHour,
      range.endMinute,
    );

    if (range.startTotalMinutes >= range.endTotalMinutes) {
      if (!todayEnd.isAfter(todayStart)) {
        todayEnd = todayEnd.add(const Duration(days: 1));
      }

      if (now.isBefore(todayStart)) {
        final previousStart = todayStart.subtract(const Duration(days: 1));
        final previousEnd = todayEnd.subtract(const Duration(days: 1));
        if (!now.isBefore(previousStart) && now.isBefore(previousEnd)) {
          return (start: previousStart, end: previousEnd);
        }
        return (start: todayStart, end: todayEnd);
      }

      if (!now.isBefore(todayStart) && now.isBefore(todayEnd)) {
        return (start: todayStart, end: todayEnd);
      }

      return (
        start: todayStart.add(const Duration(days: 1)),
        end: todayEnd.add(const Duration(days: 1)),
      );
    }

    if (now.isBefore(todayStart)) {
      return (start: todayStart, end: todayEnd);
    }

    if (now.isBefore(todayEnd)) {
      return (start: todayStart, end: todayEnd);
    }

    return (
      start: todayStart.add(const Duration(days: 1)),
      end: todayEnd.add(const Duration(days: 1)),
    );
  }

  NotificationDetails get _prayerNotificationDetails =>
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'prayer_times',
          'Prayer Times',
          channelDescription: 'Prayer time reminders from Deenly.',
          importance: Importance.max,
          priority: Priority.high,
        ),
        iOS: _darwinPrayerDetails,
        macOS: _darwinPrayerDetails,
      );

  Future<void> _scheduleIfFuture({
    required int id,
    required DateTime when,
    required String title,
    required String body,
    required NotificationDetails details,
    bool preferAlarmClock = false,
  }) async {
    final scheduledAt = when.toLocal();
    if (!scheduledAt.isAfter(DateTime.now())) {
      await FocusEnforcementService.appendDebugLog(
        'notifications.skip',
        'id=$id title=$title scheduledAt=${scheduledAt.toIso8601String()} reason=past',
      );
      return;
    }

    await FocusEnforcementService.appendDebugLog(
      'notifications.schedule',
      'id=$id title=$title scheduledAt=${scheduledAt.toIso8601String()}',
    );

    final whenTz = tz.TZDateTime.from(scheduledAt, tz.local);

    if (Platform.isAndroid) {
      Future<void> scheduleWith(AndroidScheduleMode mode) {
        return _plugin.zonedSchedule(
          id,
          title,
          body,
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
        title,
        body,
        whenTz,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
      );
    }
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

    // On macOS we limit to pending IDs first to reduce delivered clearing risk.
    if (Platform.isMacOS) {
      final pending = await _plugin.pendingNotificationRequests();
      for (final request in pending) {
        final id = request.id;
        if (id < startInclusive || id > endInclusive) continue;
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

  String _prayerLabel(HomePrayerId id) {
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
}
