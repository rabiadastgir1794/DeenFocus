import 'dart:async';
import 'package:intl/intl.dart';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/services/app_notification_service.dart';
import '../../../core/services/app_review_service.dart';
import '../../../core/services/location/location_service.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/daily_refresh_service.dart';
import '../helpers/home_daily_verse_helper.dart';
import '../helpers/home_islamic_events_helper.dart';
import '../helpers/home_prayer_times_helper.dart';
import '../model/home_models.dart';

class HomeTabViewModel extends ChangeNotifier {
  String userName = 'User';
  String? locationName;
  String? locationSubtitle;

  double? latitude;
  double? longitude;

  HomeDailyVerse? dailyVerse;
  HomePrayerTimesData? prayerTimes;
  List<HomeIslamicEvent> allIslamicEvents = const <HomeIslamicEvent>[];
  List<HomeIslamicEvent> monthEvents = const <HomeIslamicEvent>[];
  List<HomeIslamicEvent> weekEvents = const <HomeIslamicEvent>[];

  bool isLoading = true;
  bool isEventsLoading = false;
  bool _initialized = false;
  String? _lastAppliedSect;

  DateTime visibleMonth = DateTime.now();
  DateTime? selectedDate;
  bool weeklyCalendar = true;
  int streakDays = 0;
  HomePrayerStreakState _prayerStreakState = const HomePrayerStreakState(
    weekStartDateKey: '',
    weekDays: <HomePrayerChecklistDay>[],
    completedDateKeys: <String>{},
  );

  Timer? _ticker;
  static final DateFormat _dayKeyFormat = DateFormat('yyyy-MM-dd');

  /// Avoids overlapping prayer loads (resume + periodic ticker) so next-prayer
  /// does not briefly flip (e.g. Fajr vs current) when async work completes out of order.
  Future<void> _prayerTimesSerial = Future<void>.value();

  Future<void>? _resumeInFlight;

  bool get isFriday => DateTime.now().weekday == DateTime.friday;
  HomePrayerStreakState get prayerStreakState => _prayerStreakState;
  List<DateTime> get currentWeekDates => _currentWeekDates(DateTime.now());

  String? get qiblaInfo {
    if (latitude == null || longitude == null) return null;
    final coordinates = Coordinates(latitude!, longitude!);
    final qibla = Qibla(coordinates).direction;
    final distanceMeters = Geolocator.distanceBetween(
      latitude!,
      longitude!,
      Qibla.MAKKAH.latitude,
      Qibla.MAKKAH.longitude,
    );
    final distanceKm = distanceMeters / 1000;
    return '${qibla.toStringAsFixed(0)}° • ${distanceKm.toStringAsFixed(0)} km';
  }

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await _loadAll();
    _startTicker();
    unawaited(AppReviewService.onAppResumed());
  }

  Future<void> onAppResumed() {
    if (_resumeInFlight != null) return _resumeInFlight!;
    _resumeInFlight = _onAppResumedBody().whenComplete(() {
      _resumeInFlight = null;
    });
    return _resumeInFlight!;
  }

  Future<void> _onAppResumedBody() async {
    await _loadPrayerTimes();
    await _loadPrayerStreak();
    if (latitude != null && longitude != null) {
      await AppNotificationService.instance.reschedulePrayerNotifications(
        latitude: latitude!,
        longitude: longitude!,
      );
    }
    await AppReviewService.onAppResumed();
    notifyListeners();
  }

  Future<void> _loadAll() async {
    isLoading = true;
    notifyListeners();

    try {
      userName = await StorageService.userName ?? 'User';
      locationName = await StorageService.locationName;
      locationSubtitle = await StorageService.locationSubtitle;
      latitude = await StorageService.locationLatitude;
      longitude = await StorageService.locationLongitude;
      _lastAppliedSect = await StorageService.sect;
      await _loadVerse();
      await _loadPrayerTimes();
      await _loadPrayerStreak();
      _loadEvents();
    } catch (_) {
      // Keep last good state and always release loading to avoid stuck spinner.
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadPrayerStreak() async {
    final now = DateTime.now();
    final weekStart = _startOfWeek(now);
    final weekStartKey = _dayKeyFormat.format(weekStart);
    final raw = await StorageService.homePrayerStreakJson;
    var state = raw == null
        ? HomePrayerStreakState.empty(weekStartDateKey: weekStartKey)
        : HomePrayerStreakState.fromJson(raw);

    if (state.weekStartDateKey != weekStartKey) {
      state = state.copyWith(
        weekStartDateKey: weekStartKey,
        weekDays: const <HomePrayerChecklistDay>[],
      );
    }

    _prayerStreakState = _ensureWeekDays(state, weekStart);
    _recomputeStreakDays(now);
    await _persistPrayerStreak();
  }

  Future<bool> ensureLocationAvailableForFeature() async {
    final hasStoredLocation = latitude != null && longitude != null;
    if (hasStoredLocation) return true;

    final currentStatus = await Permission.location.status;
    if (!currentStatus.isGranted) {
      final requestStatus = await PermissionService.requestLocationStatus();
      if (!requestStatus.isGranted) {
        return false;
      }
    }

    await _captureCurrentLocation();
    return latitude != null && longitude != null;
  }

  Future<void> _captureCurrentLocation() async {
    final location = await LocationService.fetchCurrentCity();
    if (location == null ||
        location.latitude == null ||
        location.longitude == null) {
      return;
    }

    latitude = location.latitude;
    longitude = location.longitude;
    locationName = location.title;
    locationSubtitle = location.subtitle;
    await StorageService.setUserLocation(
      name: location.title,
      subtitle: location.subtitle,
      latitude: location.latitude,
      longitude: location.longitude,
    );
    await DailyRefreshService.instance.refreshNow();
  }

  Future<void> _loadVerse() async {
    final ref = await HomeDailyVerseHelper.getOrGenerateDailyVerseRef();
    dailyVerse = await HomeDailyVerseHelper.loadDailyVerse(ref);
  }

  Future<void> _loadPrayerTimes() {
    final run = _prayerTimesSerial.then((_) => _loadPrayerTimesBody());
    _prayerTimesSerial = run.catchError((Object _) {});
    return run;
  }

  Future<void> _loadPrayerTimesBody() async {
    if (latitude == null || longitude == null) {
      prayerTimes = null;
      return;
    }
    _lastAppliedSect = await StorageService.sect;
    prayerTimes = await HomePrayerTimesHelper.getOrGeneratePrayerTimes(
      latitude: latitude!,
      longitude: longitude!,
    );
  }

  Future<void> syncSectIfChanged(String sect) async {
    if (_lastAppliedSect == sect) return;
    _lastAppliedSect = sect;
    await _loadPrayerTimes();
    notifyListeners();
  }

  Future<void> _loadEvents() async {
    isEventsLoading = true;
    notifyListeners();
    allIslamicEvents = await HomeIslamicEventsHelper.loadIslamicEvents(
      yearsAhead: 0,
    );
    _refreshVisibleEvents();
    isEventsLoading = false;
    notifyListeners();
  }

  void _refreshVisibleEvents() {
    monthEvents = HomeIslamicEventsHelper.eventsForMonth(
      visibleMonth,
      allIslamicEvents,
    );
    weekEvents = HomeIslamicEventsHelper.eventsForWeek(
      DateTime.now(),
      allIslamicEvents,
    );
  }

  void setWeeklyCalendar(bool value) {
    weeklyCalendar = value;
    notifyListeners();
  }

  void goToNextMonth() {
    visibleMonth = DateTime(visibleMonth.year, visibleMonth.month + 1, 1);
    _refreshVisibleEvents();
    notifyListeners();
  }

  void goToPreviousMonth() {
    visibleMonth = DateTime(visibleMonth.year, visibleMonth.month - 1, 1);
    _refreshVisibleEvents();
    notifyListeners();
  }

  void selectDate(DateTime? date) {
    selectedDate = date;
    notifyListeners();
  }

  HomeIslamicEvent? eventForSelectedDate() {
    final current = selectedDate;
    if (current == null) return null;
    return HomeIslamicEventsHelper.eventsForDate(
      current,
      allIslamicEvents,
    ).firstOrNull;
  }

  List<HomeIslamicEvent> eventsForDate(DateTime date) {
    return HomeIslamicEventsHelper.eventsForDate(date, allIslamicEvents);
  }

  List<bool> get weekStreakFlags {
    final dates = currentWeekDates;
    return dates
        .map((date) {
          final dateKey = _dayKeyFormat.format(date);
          return _prayerStreakState.weekDays
                  .where((item) => item.dateKey == dateKey)
                  .firstOrNull
                  ?.isCompleted ??
              false;
        })
        .toList(growable: false);
  }

  List<HomePrayerChecklistDay> get currentWeekChecklistDays =>
      currentWeekDates.map((date) => dayFor(date)).toList(growable: false);

  bool isPrayerDayEditable(DateTime date) {
    final today = DateTime.now();
    final normalizedToday = DateTime(today.year, today.month, today.day);
    final normalizedDate = DateTime(date.year, date.month, date.day);
    return normalizedDate == normalizedToday;
  }

  HomePrayerChecklistDay dayFor(DateTime date) {
    final dateKey = _dayKeyFormat.format(date);
    return _prayerStreakState.weekDays
            .where((item) => item.dateKey == dateKey)
            .firstOrNull ??
        HomePrayerChecklistDay(
          dateKey: dateKey,
          selectedPrayers: <TrackablePrayer>{},
        );
  }

  Future<void> togglePrayerForDay(DateTime date, TrackablePrayer prayer) async {
    if (!isPrayerDayEditable(date)) return;

    final dateKey = _dayKeyFormat.format(date);
    final current = dayFor(date);
    final updatedPrayers = Set<TrackablePrayer>.from(current.selectedPrayers);
    final wasCompleted = current.isCompleted;

    if (updatedPrayers.contains(prayer)) {
      updatedPrayers.remove(prayer);
    } else {
      updatedPrayers.add(prayer);
    }

    final updatedDay = current.copyWith(selectedPrayers: updatedPrayers);
    final updatedWeekDays =
        _prayerStreakState.weekDays
            .where((item) => item.dateKey != dateKey)
            .toList(growable: true)
          ..add(updatedDay);
    updatedWeekDays.sort((a, b) => a.dateKey.compareTo(b.dateKey));

    final completedDates = Set<String>.from(
      _prayerStreakState.completedDateKeys,
    );
    if (!wasCompleted && updatedDay.isCompleted) {
      completedDates.add(dateKey);
    } else if (wasCompleted && !updatedDay.isCompleted) {
      completedDates.remove(dateKey);
    }

    _prayerStreakState = _prayerStreakState.copyWith(
      weekDays: updatedWeekDays,
      completedDateKeys: completedDates,
    );
    _recomputeStreakDays(DateTime.now());
    await _persistPrayerStreak();
    notifyListeners();
  }

  String weekdayLabel(DateTime date) {
    return DateFormat('EEEE').format(date);
  }

  void _recomputeStreakDays(DateTime now) {
    var count = 0;
    var cursor = DateTime(now.year, now.month, now.day);
    while (_prayerStreakState.completedDateKeys.contains(
      _dayKeyFormat.format(cursor),
    )) {
      count += 1;
      cursor = cursor.subtract(const Duration(days: 1));
    }
    streakDays = count;
  }

  HomePrayerStreakState _ensureWeekDays(
    HomePrayerStreakState state,
    DateTime weekStart,
  ) {
    final expectedDates = _currentWeekDates(
      weekStart,
    ).map(_dayKeyFormat.format).toSet();
    final existingByKey = {
      for (final item in state.weekDays)
        if (expectedDates.contains(item.dateKey)) item.dateKey: item,
    };
    final normalizedWeekDays = _currentWeekDates(weekStart)
        .map((date) {
          final key = _dayKeyFormat.format(date);
          return existingByKey[key] ??
              HomePrayerChecklistDay(
                dateKey: key,
                selectedPrayers: <TrackablePrayer>{},
              );
        })
        .toList(growable: false);

    return state.copyWith(weekDays: normalizedWeekDays);
  }

  List<DateTime> _currentWeekDates(DateTime anchor) {
    final start = _startOfWeek(anchor);
    return List<DateTime>.generate(
      7,
      (index) => DateTime(start.year, start.month, start.day + index),
    );
  }

  DateTime _startOfWeek(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    return normalized.subtract(Duration(days: normalized.weekday - 1));
  }

  Future<void> _persistPrayerStreak() async {
    await StorageService.setHomePrayerStreakJson(_prayerStreakState.toJson());
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(minutes: 1), (_) async {
      await _loadPrayerTimes();
      await _loadPrayerStreak();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
