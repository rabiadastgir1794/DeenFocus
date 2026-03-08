import 'dart:async';

import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/services/location/location_service.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/services/storage_service.dart';
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
  bool prayerModeActive = false;
  bool _locationDialogRequired = false;
  bool _initialized = false;

  DateTime visibleMonth = DateTime.now();
  DateTime? selectedDate;
  bool weeklyCalendar = true;
  int streakDays = 0;

  Timer? _ticker;

  bool get isFriday => DateTime.now().weekday == DateTime.friday;

  bool consumeLocationDialogFlag() {
    if (!_locationDialogRequired) return false;
    _locationDialogRequired = false;
    return true;
  }

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
  }

  Future<void> onAppResumed() async {
    await _ensureLocationAccessIfNeeded();
    await _loadPrayerTimes();
    notifyListeners();
  }

  Future<void> _loadAll() async {
    isLoading = true;
    notifyListeners();

    userName = await StorageService.userName ?? 'User';
    locationName = await StorageService.locationName;
    locationSubtitle = await StorageService.locationSubtitle;
    latitude = await StorageService.locationLatitude;
    longitude = await StorageService.locationLongitude;

    await _ensureLocationAccessIfNeeded();
    await _ensureNotificationPrompted();
    await _loadVerse();
    await _loadPrayerTimes();
    _loadEvents();

    isLoading = false;
    notifyListeners();
  }

  Future<void> _ensureLocationAccessIfNeeded() async {
    final hasStoredLocation = latitude != null && longitude != null;
    if (hasStoredLocation) return;

    final currentStatus = await Permission.location.status;
    if (currentStatus.isGranted) {
      await _captureCurrentLocation();
      return;
    }

    final requestStatus = await PermissionService.requestLocationStatus();
    if (requestStatus.isGranted) {
      await _captureCurrentLocation();
      return;
    }

    _locationDialogRequired = true;
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
  }

  Future<void> _ensureNotificationPrompted() async {
    final prompted = await StorageService.homeNotificationPrompted;
    if (prompted) return;
    await PermissionService.requestNotification();
    await StorageService.setHomeNotificationPrompted(true);
  }

  Future<void> _loadVerse() async {
    final ref = await HomeDailyVerseHelper.getOrGenerateDailyVerseRef();
    dailyVerse = await HomeDailyVerseHelper.loadDailyVerse(ref);
  }

  Future<void> _loadPrayerTimes() async {
    if (latitude == null || longitude == null) {
      prayerTimes = null;
      return;
    }
    prayerTimes = await HomePrayerTimesHelper.getOrGeneratePrayerTimes(
      latitude: latitude!,
      longitude: longitude!,
    );
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

  void togglePrayerMode() {
    prayerModeActive = !prayerModeActive;
    notifyListeners();
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
    final todayIndex = DateTime.now().weekday - 1; // Monday = 0
    final completedSlots = streakDays.clamp(0, 7);
    return List<bool>.generate(7, (index) {
      if (index > todayIndex) return false;
      return index < completedSlots;
    });
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(minutes: 1), (_) async {
      await _loadPrayerTimes();
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }
}
