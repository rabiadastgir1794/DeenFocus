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

  // TEMP: Salah test mode (keep code, disable for production)
  // static const bool salahTestModeEnabled = true;
  static const bool salahTestModeEnabled = false;
  static const int _salahTestWindowCount = 2;
  static const Duration _salahTestInitialDelay = Duration(minutes: 2);
  static const Duration _salahTestLockDuration = Duration(minutes: 4);
  static const Duration _salahTestGapDuration = Duration(minutes: 2);

  static final AppNotificationService instance = AppNotificationService._();

  static const _prayerChannel = AndroidNotificationChannel(
    'prayer_times',
    'Prayer Times',
    description: 'Prayer time reminders from Deenly.',
    importance: Importance.max,
  );

  static const _focusChannel = AndroidNotificationChannel(
    'focus_modes',
    'Focus Modes',
    description: 'Focus mode lock and unlock alerts from Deenly.',
    importance: Importance.high,
  );

  static const _darwinPrayerDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );
  static const _darwinFocusDetails = DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
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
          preferAlarmClock: true,
        );
      }
    }
  }

  Future<void> syncFocusNotifications({
    required FocusSettings settings,
    required double? latitude,
    required double? longitude,
  }) async {
    await initialize();
    if (!await _hasNotificationPermission()) {
      await _cancelRange(2000, 2059);
      await _cancelRange(3000, 3059);
      await _cancelRange(4000, 4003);
      return;
    }
    await _ensureAndroidExactAlarmOrFallback();
    await _setLocalTimezone();
    await _cancelRange(2000, 2059);
    await _cancelRange(3000, 3059);
    await _cancelRange(4000, 4003);

    final now = DateTime.now();

    if (settings.salahModeEnabled) {
      if (salahTestModeEnabled) {
        await _scheduleSalahTestNotifications(settings.salahTestAnchorAt ?? now);
      } else if (latitude != null && longitude != null) {
        final datasets = <({int dayOffset, HomePrayerTimesData data})>[
          (
            dayOffset: 0,
            data: await HomePrayerTimesHelper.getOrGeneratePrayerTimes(
              latitude: latitude,
              longitude: longitude,
              now: now,
            ),
          ),
          (
            dayOffset: 1,
            data: await HomePrayerTimesHelper.getOrGeneratePrayerTimes(
              latitude: latitude,
              longitude: longitude,
              now: now.add(const Duration(days: 1)),
            ),
          ),
        ];

        for (final dataset in datasets) {
          for (final slot in dataset.data.slots.where(
            (slot) => slot.id != HomePrayerId.sunrise,
          )) {
            final prayerName = _prayerLabel(slot.id);
            final start = slot.time.subtract(const Duration(minutes: 10));
            final end = slot.time.add(const Duration(minutes: 15));
            final offsetBase = dataset.dayOffset * 10 + _slotIndex(slot.id);

            await _scheduleIfFuture(
              id: 2000 + offsetBase,
              when: start,
              title: 'Salah Focus Mode active',
              body:
                  '$prayerName is approaching, so selected apps are now locked.',
              details: _focusNotificationDetails,
            );
            await _scheduleIfFuture(
              id: 3000 + offsetBase,
              when: end,
              title: 'Salah Focus Mode ended',
              body:
                  '$prayerName focus window has ended, so selected apps are unlocked.',
              details: _focusNotificationDetails,
            );
          }
        }
      } else {
        await FocusEnforcementService.appendDebugLog(
          'notifications.salah',
          'skipped real salah scheduling because location is unavailable',
        );
      }
    }

    if (settings.nightDisciplineEnabled) {
      final start = _nextNightTime(
        now,
        settings.nightRange.startHour,
        settings.nightRange.startMinute,
        preferFutureOnly: false,
      );
      final end = _nextNightEnd(now, settings.nightRange);

      await _scheduleIfFuture(
        id: 4000,
        when: start.isBefore(now) ? start.add(const Duration(days: 1)) : start,
        title: 'Night Discipline active',
        body: 'Selected apps are now locked for your night routine.',
        details: _focusNotificationDetails,
      );
      await _scheduleIfFuture(
        id: 4001,
        when: end,
        title: 'Night Discipline ended',
        body: 'Selected apps are now unlocked.',
        details: _focusNotificationDetails,
      );
    }
  }

  Future<void> showImmediateFocusLockedNotification(FocusModeType mode) async {
    await initialize();
    if (!await _hasNotificationPermission()) {
      return;
    }
    if (mode != FocusModeType.salah && mode != FocusModeType.nightDiscipline) {
      return;
    }

    final title = mode == FocusModeType.salah
        ? 'Salah Focus Mode active'
        : 'Night Discipline active';
    final body = mode == FocusModeType.salah
        ? 'Selected apps are now locked for the active prayer window.'
        : 'Selected apps are now locked for your night routine.';

    await _plugin.show(
      5000 + mode.index,
      title,
      body,
      _focusNotificationDetails,
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

  NotificationDetails get _focusNotificationDetails =>
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'focus_modes',
          'Focus Modes',
          channelDescription: 'Focus mode lock and unlock alerts from Deenly.',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: _darwinFocusDetails,
        macOS: _darwinFocusDetails,
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

  Future<void> _scheduleSalahTestNotifications(DateTime now) async {
    await FocusEnforcementService.appendDebugLog(
      'notifications.salahTest',
      'scheduling $_salahTestWindowCount test windows from ${now.toIso8601String()}',
    );
    for (var index = 0; index < _salahTestWindowCount; index++) {
      final prayerId = _testPrayerIdForIndex(index);
      final prayerName = _prayerLabel(prayerId);
      final start = now.add(
        _salahTestInitialDelay +
            (_salahTestLockDuration + _salahTestGapDuration) * index,
      );
      final end = start.add(_salahTestLockDuration);

      await _scheduleIfFuture(
        id: 2000 + index,
        when: start,
        title: 'Salah Focus Mode active',
        body:
            'Test cycle for $prayerName started, selected apps are now locked.',
        details: _focusNotificationDetails,
      );
      await _scheduleIfFuture(
        id: 3000 + index,
        when: end,
        title: 'Salah Focus Mode ended',
        body:
            'Test cycle for $prayerName ended, selected apps are now unlocked.',
        details: _focusNotificationDetails,
      );
    }
  }

  Future<void> _cancelRange(int startInclusive, int endInclusive) async {
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

  HomePrayerId _testPrayerIdForIndex(int index) {
    const prayerIds = <HomePrayerId>[
      HomePrayerId.fajr,
      HomePrayerId.dhuhr,
      HomePrayerId.asr,
      HomePrayerId.maghrib,
      HomePrayerId.isha,
    ];
    return prayerIds[index % prayerIds.length];
  }

  DateTime _nextNightTime(
    DateTime now,
    int hour,
    int minute, {
    required bool preferFutureOnly,
  }) {
    final today = DateTime(now.year, now.month, now.day, hour, minute);
    if (today.isAfter(now) || (!preferFutureOnly && today == now)) return today;
    return today.add(const Duration(days: 1));
  }

  DateTime _nextNightEnd(DateTime now, FocusTimeRange range) {
    var end = DateTime(
      now.year,
      now.month,
      now.day,
      range.endHour,
      range.endMinute,
    );
    final start = DateTime(
      now.year,
      now.month,
      now.day,
      range.startHour,
      range.startMinute,
    );

    if (range.startTotalMinutes >= range.endTotalMinutes) {
      if (!end.isAfter(start)) {
        end = end.add(const Duration(days: 1));
      }
      if (end.isBefore(now)) {
        end = end.add(const Duration(days: 1));
      }
      return end;
    }

    if (!end.isAfter(now)) {
      end = end.add(const Duration(days: 1));
    }
    return end;
  }
}
