import 'dart:async';

import 'package:flutter/foundation.dart';

import '../../features/home/helpers/home_daily_verse_helper.dart';
import '../../features/home/helpers/home_prayer_times_helper.dart';
import 'app_notification_service.dart';
import 'storage_service.dart';

class DailyRefreshService {
  DailyRefreshService._();

  static final DailyRefreshService instance = DailyRefreshService._();

  Timer? _midnightTimer;
  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await refreshNow();
    _scheduleNextMidnightRefresh();
  }

  Future<void> refreshNow() async {
    await HomeDailyVerseHelper.getOrGenerateDailyVerseRef();

    final latitude = await StorageService.locationLatitude;
    final longitude = await StorageService.locationLongitude;
    if (latitude == null || longitude == null) return;

    await HomePrayerTimesHelper.getOrGeneratePrayerTimes(
      latitude: latitude,
      longitude: longitude,
    );
    await AppNotificationService.instance.reschedulePrayerNotifications(
      latitude: latitude,
      longitude: longitude,
    );
  }

  @visibleForTesting
  void scheduleRefreshFor(DateTime now) {
    _midnightTimer?.cancel();
    final nextMidnight = DateTime(now.year, now.month, now.day + 1);
    final delay = nextMidnight.difference(now);
    _midnightTimer = Timer(delay, () async {
      await refreshNow();
      scheduleRefreshFor(DateTime.now());
    });
  }

  void _scheduleNextMidnightRefresh() {
    scheduleRefreshFor(DateTime.now());
  }

  void dispose() {
    _midnightTimer?.cancel();
  }
}
