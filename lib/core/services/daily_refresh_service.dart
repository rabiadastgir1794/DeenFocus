import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../features/home/helpers/home_daily_verse_helper.dart';
import '../../features/home/helpers/home_prayer_times_helper.dart';
import 'app_notification_service.dart';
import 'prayer_alarm_service.dart';
import 'storage_service.dart';
import 'widget_sync_service.dart';

class DailyRefreshService {
  DailyRefreshService._();

  static final DailyRefreshService instance = DailyRefreshService._();

  Timer? _refreshTimer;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await refreshNow();
    _scheduleNextRefresh();
  }

  Future<void> refreshNow() async {
    await HomeDailyVerseHelper.getOrGenerateDailyVerseRef();

    // Cycle Mode expiry is calendar-based — does not need location. Keep it
    // outside the prayer-times gate so Android boot/resume still reconciles
    // AlarmManager id 5100 when location is missing.
    await AppNotificationService.instance.syncCycleModeExpiryNotification();

    final latitude = await StorageService.locationLatitude;
    final longitude = await StorageService.locationLongitude;
    if (latitude != null && longitude != null) {
      await HomePrayerTimesHelper.getOrGeneratePrayerTimes(
        latitude: latitude,
        longitude: longitude,
      );
      final needsPrayerReschedule =
          await StorageService.needsPrayerNotificationReschedule;
      await AppNotificationService.instance.reschedulePrayerNotifications(
        latitude: latitude,
        longitude: longitude,
        forceReschedule: needsPrayerReschedule,
      );
      await PrayerAlarmService.instance.rescheduleAlarms(
        latitude: latitude,
        longitude: longitude,
        forceReschedule: needsPrayerReschedule,
      );
      await AppNotificationService.instance.syncNightlyWrapUpReminder(
        latitude: latitude,
        longitude: longitude,
      );
    }

    await WidgetSyncService.instance.syncTimeline();
  }

  @visibleForTesting
  void scheduleRefreshFor(DateTime now) {
    _refreshTimer?.cancel();
    final nextRefresh = DateTime(now.year, now.month, now.day + 1);
    final delay = nextRefresh.difference(now);
    _refreshTimer = Timer(delay, () async {
      await refreshNow();
      scheduleRefreshFor(DateTime.now());
    });
  }

  void _scheduleNextRefresh() {
    scheduleRefreshFor(DateTime.now());
  }

  void dispose() {
    _refreshTimer?.cancel();
  }
}
