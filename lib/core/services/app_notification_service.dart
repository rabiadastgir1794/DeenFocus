import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

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
    const darwinSettings = DarwinInitializationSettings();

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

  Future<void> reschedulePrayerNotifications({
    required double latitude,
    required double longitude,
  }) async {
    await initialize();
    await _cancelRange(1000, 1039);

    final now = DateTime.now();
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
        final id = 1000 + dataset.dayOffset * 10 + _slotIndex(slot.id);
        await _scheduleIfFuture(
          id: id,
          when: slot.time,
          title: "It's time for ${_prayerLabel(slot.id)}",
          body: 'Take a moment for ${_prayerLabel(slot.id)} prayer.',
          details: _prayerNotificationDetails,
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
    await _cancelRange(2000, 2059);
    await _cancelRange(3000, 3059);
    await _cancelRange(4000, 4003);

    final now = DateTime.now();

    if (settings.salahModeEnabled && latitude != null && longitude != null) {
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
  }) async {
    final scheduledAt = when.toLocal();
    if (!scheduledAt.isAfter(DateTime.now())) return;

    await _plugin.zonedSchedule(
      id,
      title,
      body,
      tz.TZDateTime.from(scheduledAt, tz.local),
      details,
      androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  Future<void> _cancelRange(int startInclusive, int endInclusive) async {
    for (var id = startInclusive; id <= endInclusive; id++) {
      await _plugin.cancel(id);
    }
  }

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
