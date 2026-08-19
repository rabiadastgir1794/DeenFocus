import 'dart:async';
import 'dart:convert';

import 'package:intl/intl.dart';

import 'package:adhan_dart/adhan_dart.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../../core/services/app_notification_service.dart';
import '../../../core/services/app_review_service.dart';
import '../../../core/services/daily_refresh_service.dart';
import '../../../core/services/location/location_service.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/services/prayer_alarm_service.dart';
import '../../../core/services/prayer_live_activity_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/widget_sync_service.dart';
import '../../../core/superwall/app_superwall.dart';
import '../helpers/daily_checklist_day.dart';
import '../helpers/home_daily_verse_helper.dart';
import '../helpers/home_islamic_events_helper.dart';
import '../helpers/home_prayer_times_helper.dart';
import '../model/home_models.dart';
import '../services/achievements_service.dart';
import '../services/cycle_mode_policy.dart';
import '../services/level_service.dart';
import '../services/prayer_analytics_service.dart';
import '../services/prayer_settings_service.dart';
import '../services/progression_service.dart';
import '../services/xp_service.dart';

class HomeTabViewModel extends ChangeNotifier {
  HomeTabViewModel({PrayerSettingsService? prayerSettings})
    : _prayerSettingsService = prayerSettings ?? PrayerSettingsService() {
    _prayerSettingsService.addListener(_onPrayerSettingsChanged);
  }

  final PrayerSettingsService _prayerSettingsService;

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

  DateTime visibleMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  );

  /// First day (Sunday) of the row shown in weekly calendar mode; advances by ±7 days.
  DateTime weeklyVisibleWeekStart = HomeTabViewModel._startOfWeekFor(
    DateTime.now(),
  );

  /// Week/month toggle for legacy home calendar section. Full Calendar screen
  /// always navigates by Gregorian month via [goToNextMonth]/[goToPreviousMonth].
  bool weeklyCalendar = false;
  int streakDays = 0;
  HomePrayerStreakState _prayerStreakState = const HomePrayerStreakState(
    weekStartDateKey: '',
    weekDays: <HomePrayerChecklistDay>[],
    completedDateKeys: <String>{},
  );

  // Cycle Mode state
  CycleModeData _cycleMode = CycleModeData.disabled();

  // Daily Checklist state
  DailyChecklistState _dailyChecklist = const DailyChecklistState(
    dateKey: '',
    completedItems: <DailyChecklistItem>{},
  );

  // Focus Score state (placeholder values - can be connected to actual tracking)
  int _todayFocusScore = 0;
  int _todayPrayerPercent = 0;
  int _todayQuranPercent = 0;
  int _todayDhikrPercent = 0;
  int _todayDistractionPercent = 0;
  int prayerStreak = 0;
  PrayerAnalyticsSnapshot analytics = const PrayerAnalyticsSnapshot(
    prayerStreak: 0,
    dayStreak: 0,
    weeklyCompleted: 0,
    weeklyPossible: PrayerAnalyticsService.weeklyPossible,
    monthlyCompleted: 0,
    monthlyPossible: 0,
    prayerRatePercent: 0,
    weekDayCounts: <int>[0, 0, 0, 0, 0, 0, 0],
    homeWeekDayCounts: <int>[0, 0, 0, 0, 0, 0, 0],
    monthWeekBuckets: <({String label, int completed, int possible})>[],
  );
  List<AchievementProgress> achievements = AchievementsService.defaults();
  UserProgress userProgress = UserProgress.initial();
  LevelProgress levelProgress = LevelService.getLevelFromXP(0);
  List<XpEvent> _xpEvents = const <XpEvent>[];
  Map<String, Set<DailyChecklistItem>> _checklistHistory =
      <String, Set<DailyChecklistItem>>{};

  /// All streak / completion numbers — always from [PrayerAnalyticsService].
  int get prayerRatePercent => analytics.prayerRatePercent;
  int get bestPrayerStreak => _prayerStreakState.bestPrayerStreak > prayerStreak
      ? _prayerStreakState.bestPrayerStreak
      : prayerStreak;
  int get bestDayStreak => _prayerStreakState.bestDayStreak > streakDays
      ? _prayerStreakState.bestDayStreak
      : streakDays;
  int get bestStreakDays => bestDayStreak;
  int get cycleProtectedDaysAvailable => cycleModeDaysRemaining;
  List<bool> get weekCycleHighlights {
    final now = DateTime.now();
    return currentWeekDates
        .map((date) => cyclePolicy.isHighlightable(date, now: now))
        .toList(growable: false);
  }

  bool isCycleHighlight(DateTime date, {DateTime? now}) =>
      cyclePolicy.isHighlightable(date, now: now);

  /// Bumps when cycle settings change so calendar grids rebuild highlights.
  int get cycleHighlightRevision => Object.hash(
    _cycleMode.isEnabled,
    _cycleMode.startDate,
    _cycleMode.cycleLength,
    Object.hashAll(_cycleMode.history),
  );
  bool get isTodayCycleProtected => cyclePolicy.isTodayProtected();
  List<DateTime> get insightsWeekDates =>
      WeeklyCalculator.insightsWeekDates(DateTime.now());
  List<DateTime> get currentMonthDates =>
      MonthlyCalculator.monthDatesFor(DateTime.now());
  List<({String label, int completed, int possible})> get insightsMonthWeeks =>
      analytics.monthWeekBuckets;
  int get weeklyCompletionDone => analytics.weeklyCompleted;
  int get weeklyCompletionPossible => analytics.weeklyPossible;
  int get monthlyCompletionDone => analytics.monthlyCompleted;
  int get monthlyCompletionPossible => analytics.monthlyPossible;

  List<int> prayerCountsForDates(List<DateTime> dates) {
    final history = _mergedStatusHistory();
    return [
      for (final date in dates)
        WeeklyCalculator.completedCountOnDate(
          date,
          history,
          cyclePolicy.shouldExcludeFromStatistics,
        ),
    ];
  }

  /// True when a break within the last 24 hours can be restored.
  bool get canRestoreStreak => analytics.canRestoreStreak;

  /// Snapchat-style restore: repair the most recent break in real history
  /// (within 24h), then recalculate everything. Multiple restores allowed.
  Future<bool> restoreStreakLast7Days() async {
    final now = DateTime.now();
    final target =
        analytics.restoreTarget ??
        RestoreCalculator.findTarget(
          now: now,
          statusHistory: _mergedStatusHistory(),
          isCycleDay: (d) => !cyclePolicy.shouldAllowRestore(d),
          prayerStartTime: prayerDateTimeFor,
        );
    if (target == null) return false;

    final history = RestoreCalculator.apply(
      statusHistory: _mergedStatusHistory(),
      target: target,
    );

    final weekDays = _prayerStreakState.weekDays
        .map((day) {
          if (day.dateKey != target.dateKey) return day;
          final statuses = history[target.dateKey] ?? day.prayerStatuses;
          final selected = <TrackablePrayer>{
            for (final e in statuses.entries)
              if (e.value == PrayerMarkStatus.onTime ||
                  e.value == PrayerMarkStatus.qada)
                e.key,
          };
          return day.copyWith(
            selectedPrayers: selected,
            prayerStatuses: statuses,
          );
        })
        .toList(growable: false);

    final completedDates = Set<String>.from(
      _prayerStreakState.completedDateKeys,
    );
    final dayStatuses = history[target.dateKey];
    if (dayStatuses != null &&
        TrackablePrayer.values.every(
          (p) => PrayerAnalyticsService.countsForPrayerStreak(
            dayStatuses[p] ?? PrayerMarkStatus.none,
          ),
        )) {
      completedDates.add(target.dateKey);
    }

    _prayerStreakState = _prayerStreakState.copyWith(
      statusHistory: history,
      weekDays: weekDays,
      completedDateKeys: completedDates,
    );
    _recomputeAnalytics(now);
    await _persistPrayerStreak();
    await _computeFocusScore();
    await _refreshAchievements();
    notifyListeners();
    return true;
  }

  bool get cycleModeEnabled => _cycleMode.isEnabled;
  CycleModeData get cycleModeData => _cycleMode;
  CycleModePolicy get cyclePolicy => CycleModePolicy(_cycleMode);

  // Daily Checklist getters
  Set<DailyChecklistItem> get dailyChecklistCompletedItems =>
      _dailyChecklist.completedItems;

  // Focus Score getters
  int get todayFocusScore => _todayFocusScore;
  int get todayPrayerPercent => _todayPrayerPercent;
  int get todayQuranPercent => _todayQuranPercent;
  int get todayDhikrPercent => _todayDhikrPercent;
  int get todayDistractionPercent => _todayDistractionPercent;
  int get cycleModeDaysRemaining => _cycleMode.daysRemainingOn(DateTime.now());
  int get cycleModeLength => _cycleMode.cycleLength;

  Timer? _ticker;
  static final DateFormat _dayKeyFormat = DateFormat('yyyy-MM-dd');

  /// When Superwall is enabled, bearing/distance subtitle is shown only for active subscribers.
  bool _subscriptionActive = false;

  /// Avoids overlapping prayer loads (resume + periodic ticker) so next-prayer
  /// does not briefly flip (e.g. Fajr vs current) when async work completes out of order.
  Future<void> _prayerTimesSerial = Future<void>.value();

  Future<void>? _resumeInFlight;

  bool get isFriday => DateTime.now().weekday == DateTime.friday;
  HomePrayerStreakState get prayerStreakState => _prayerStreakState;
  List<DateTime> get currentWeekDates => _currentWeekDates(DateTime.now());

  PrayerSettingEntry settingsFor(TrackablePrayer prayer) =>
      _prayerSettingsService.forPrayer(prayer);

  void _onPrayerSettingsChanged() => notifyListeners();

  String? get qiblaInfo {
    if (latitude == null || longitude == null) return null;
    final coordinates = Coordinates(latitude!, longitude!);
    final qibla = Qibla.qibla(coordinates);
    final distanceMeters = Geolocator.distanceBetween(
      latitude!,
      longitude!,
      Qibla.makkah.latitude,
      Qibla.makkah.longitude,
    );
    final distanceKm = distanceMeters / 1000;
    return '${qibla.toStringAsFixed(0)}° • ${distanceKm.toStringAsFixed(0)} km';
  }

  bool get showQiblaBearingDetails {
    if (!AppSuperwall.isEnabled) return true;
    return _subscriptionActive;
  }

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;
    await _syncCycleModeFromStorage();
    await _loadAll();
    _startTicker();
    unawaited(_recordAndMaybeRequestAppReview());
    unawaited(PrayerLiveActivityService.instance.syncFromStorage());
  }

  Future<void> onAppResumed() {
    if (_resumeInFlight != null) return _resumeInFlight!;
    _resumeInFlight = _onAppResumedBody().whenComplete(() {
      _resumeInFlight = null;
    });
    return _resumeInFlight!;
  }

  Future<void> _onAppResumedBody() async {
    await _loadSubscriptionStatus();
    await _loadPrayerSettings();
    await _loadPrayerTimes();
    // Reload cycle state (restart / overnight) and auto-expire if needed.
    await _syncCycleModeFromStorage();
    final expired = await _ensureCycleModeNotExpired();
    await _loadPrayerStreak();
    // Calendar-day checklist must roll even when the VM survived past midnight.
    final checklistRolled = await _ensureDailyChecklistCurrent();
    if (!expired || checklistRolled) {
      // Streak load recomputes analytics; still refresh focus/achievements
      // so cycle restore after restart stays synchronized.
      await _computeFocusScore();
      await _refreshAchievements();
    }
    if (latitude != null && longitude != null) {
      final needsPrayerReschedule =
          await StorageService.needsPrayerNotificationReschedule;
      await AppNotificationService.instance.reschedulePrayerNotifications(
        latitude: latitude!,
        longitude: longitude!,
        forceReschedule: needsPrayerReschedule,
      );
      // Match soft reminders: do not cancel+rebuild native alarms on every
      // resume — that can drop a just-due Isha still waiting to fire.
      await PrayerAlarmService.instance.rescheduleAlarms(
        latitude: latitude!,
        longitude: longitude!,
        forceReschedule: needsPrayerReschedule,
      );
      unawaited(_syncNightlyWrapUpIfPossible());
    }
    // Android AlarmManager + iOS pending: reconcile Cycle Mode expiry after
    // boot / timezone / overnight without requiring location.
    unawaited(
      AppNotificationService.instance.syncCycleModeExpiryNotification(
        cycleMode: _cycleMode,
      ),
    );
    unawaited(PrayerLiveActivityService.instance.syncFromStorage());
    await _recordAndMaybeRequestAppReview();
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
      await _loadSubscriptionStatus();
      await _loadPrayerSettings();
      await _loadPrayerTimes();
      await _syncCycleModeFromStorage();
      await _loadPrayerStreak();
      await _loadDailyChecklist();
      await _loadChecklistHistory();
      achievements = await AchievementsService.load();
      userProgress = await ProgressionService.loadProgress();
      _xpEvents = await ProgressionService.loadEvents();
      await _computeFocusScore();
      await _refreshAchievements();
      _loadEvents();
      // Ensure soft prayer reminders exist even if DailyRefresh raced/failed.
      await _rescheduleNotificationsIfPossible();
    } catch (_) {
      // Keep last good state and always release loading to avoid stuck spinner.
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadSubscriptionStatus() async {
    await AppSuperwall.syncSubscriptionState();

    _subscriptionActive = AppSuperwall.subscriptionActiveNotifier.value;
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
    // Sync weekDays into persistent status history (single source of truth).
    final history = Map<String, Map<TrackablePrayer, PrayerMarkStatus>>.from(
      _prayerStreakState.statusHistory.map(
        (k, v) => MapEntry(k, Map<TrackablePrayer, PrayerMarkStatus>.from(v)),
      ),
    );
    for (final day in _prayerStreakState.weekDays) {
      final confirmed = <TrackablePrayer, PrayerMarkStatus>{
        for (final p in TrackablePrayer.values)
          if (day.statusFor(p) != PrayerMarkStatus.none) p: day.statusFor(p),
      };
      if (confirmed.isNotEmpty) {
        history[day.dateKey] = confirmed;
      }
    }

    _prayerStreakState = _prayerStreakState.copyWith(statusHistory: history);
    _prayerStreakState = _hydrateWeekDaysFromHistory(_prayerStreakState);
    _recomputeAnalytics(now);
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
    final calculated = await HomePrayerTimesHelper.getOrGeneratePrayerTimes(
      latitude: latitude!,
      longitude: longitude!,
    );
    prayerTimes = HomePrayerTimesHelper.applyCustomOverrides(
      data: calculated,
      overridesMinutesSinceMidnight: _prayerSettingsService.customTimeOverrides,
      referenceTime: DateTime.now(),
    );
  }

  Future<void> _loadPrayerSettings() async {
    await _prayerSettingsService.reload();
  }

  Future<void> _rescheduleNotificationsIfPossible() async {
    if (latitude == null || longitude == null) return;
    await AppNotificationService.instance.reschedulePrayerNotifications(
      latitude: latitude!,
      longitude: longitude!,
      forceReschedule: true,
    );
    await _reschedulePrayerAlarmsIfPossible();
    unawaited(_syncNightlyWrapUpIfPossible());
    unawaited(PrayerLiveActivityService.instance.syncFromStorage());
  }

  Future<void> _syncNightlyWrapUpIfPossible() async {
    if (latitude == null || longitude == null) return;
    await AppNotificationService.instance.syncNightlyWrapUpReminder(
      latitude: latitude!,
      longitude: longitude!,
    );
  }

  Future<void> _reschedulePrayerAlarmsIfPossible() async {
    if (latitude == null || longitude == null) return;
    await PrayerAlarmService.instance.rescheduleAlarms(
      latitude: latitude!,
      longitude: longitude!,
      forceReschedule: true,
    );
  }

  /// Sets (or clears, when [minutesSinceMidnight] is null) a custom time for
  /// this prayer only. Refreshes today's displayed times and reschedules
  /// notifications so the change is reflected immediately.
  Future<void> setPrayerCustomTime(
    TrackablePrayer prayer,
    int? minutesSinceMidnight,
  ) async {
    await _prayerSettingsService.setCustomTime(prayer, minutesSinceMidnight);
    await _loadPrayerTimes();
    notifyListeners();
    unawaited(_rescheduleNotificationsIfPossible());
  }

  Future<void> setPrayerNotificationSound(
    TrackablePrayer prayer,
    PrayerNotificationSound sound,
  ) async {
    await _prayerSettingsService.setSound(prayer, sound);
    notifyListeners();
    unawaited(_rescheduleNotificationsIfPossible());
  }

  /// Single source of truth: soft notification and native alarm stay in sync.
  Future<void> setPrayerAlertingEnabled(
    TrackablePrayer prayer,
    bool enabled,
  ) async {
    await _prayerSettingsService.setAlertingEnabled(prayer, enabled);
    notifyListeners();
    // Soft + native: ownership (Adhan ↔ mute) and cancel/schedule stay aligned.
    unawaited(_rescheduleNotificationsIfPossible());
  }

  Future<void> setPrayerNotificationEnabled(
    TrackablePrayer prayer,
    bool enabled,
  ) => setPrayerAlertingEnabled(prayer, enabled);

  Future<void> setPrayerAlarmEnabled(TrackablePrayer prayer, bool enabled) =>
      setPrayerAlertingEnabled(prayer, enabled);

  // Cycle Mode methods
  /// Loads prefs, applies one-time history purge, and auto-expires if needed.
  Future<void> _syncCycleModeFromStorage() async {
    final data = await StorageService.cycleModeData;
    final now = DateTime.now();
    if (data.isEnabled && data.hasExpiredOn(now)) {
      _cycleMode = data.expireFully();
      await StorageService.setCycleModeData(_cycleMode);
    } else {
      _cycleMode = data;
    }
  }

  Future<void> _loadDailyChecklist() async {
    final now = DateTime.now();
    final json = await StorageService.dailyChecklistJson;
    final stored = json != null && json.isNotEmpty
        ? DailyChecklistState.fromJson(json)
        : null;
    final resolved = DailyChecklistDay.resolveForToday(
      stored: stored,
      now: now,
    );
    final rolledToNewDay =
        stored != null &&
        stored.dateKey.isNotEmpty &&
        stored.dateKey != resolved.dateKey;
    _dailyChecklist = resolved;
    // Persist empty new-day state so cold starts / other surfaces see today.
    if (stored == null || rolledToNewDay) {
      await _persistDailyChecklist();
    }
  }

  /// Returns true when the checklist rolled to a new calendar day.
  Future<bool> _ensureDailyChecklistCurrent() async {
    final now = DateTime.now();
    if (!DailyChecklistDay.needsReset(current: _dailyChecklist, now: now)) {
      return false;
    }
    await _loadDailyChecklist();
    return true;
  }

  Future<void> _persistDailyChecklist() async {
    await StorageService.setDailyChecklistJson(_dailyChecklist.toJson());
  }

  Future<void> toggleDailyChecklistItem(DailyChecklistItem item) async {
    await _ensureDailyChecklistCurrent();
    final completed = Set<DailyChecklistItem>.from(
      _dailyChecklist.completedItems,
    );
    if (completed.contains(item)) {
      completed.remove(item);
    } else {
      completed.add(item);
    }
    _dailyChecklist = _dailyChecklist.copyWith(completedItems: completed);
    _checklistHistory[_dailyChecklist.dateKey] = Set<DailyChecklistItem>.from(
      completed,
    );
    await _persistDailyChecklist();
    await _persistChecklistHistory();
    await _computeFocusScore();
    await _refreshAchievements();
    notifyListeners();
    unawaited(_syncNightlyWrapUpIfPossible());
  }

  Future<void> _computeFocusScore() async {
    final completed = _dailyChecklist.completedItems;

    // —— Prayer (Fajr + Tahajjud checklist, or marked prayers) ——
    // Cycle Mode must not penalize the score when prayers are paused.
    const prayerItems = <DailyChecklistItem>[
      DailyChecklistItem.fajr,
      DailyChecklistItem.tahajjud,
    ];
    final prayerChecklistPercent = _percentOf(prayerItems, completed);
    final prayerMarksPercent = _getPrayerCompletionPercent();
    // Protect focus score on any cycle day (active or sealed early-end day).
    if (cyclePolicy.protectsFocusScore()) {
      _todayPrayerPercent = 100;
    } else {
      _todayPrayerPercent = prayerMarksPercent >= prayerChecklistPercent
          ? prayerMarksPercent
          : prayerChecklistPercent;
    }

    // —— Quran ——
    const quranItems = <DailyChecklistItem>[DailyChecklistItem.quran];
    _todayQuranPercent = _percentOf(quranItems, completed);

    // —— Dhikr (Morning Adhkar + Evening Adhkar + Dhikr) ——
    const dhikrItems = <DailyChecklistItem>[
      DailyChecklistItem.morningAdhkar,
      DailyChecklistItem.eveningAdhkar,
      DailyChecklistItem.dhikr,
    ];
    _todayDhikrPercent = _percentOf(dhikrItems, completed);

    // —— Distraction control ——
    // Display % = remaining distraction (0% = disciplined / good).
    const distractionItems = <DailyChecklistItem>[
      DailyChecklistItem.noMusicToday,
      DailyChecklistItem.noSocialMediaBeforeIsha,
    ];
    final undistractedPercent = _percentOf(distractionItems, completed);
    _todayDistractionPercent = 100 - undistractedPercent;

    // —— Good deeds (bonus toward 100) ——
    const bonusItems = <DailyChecklistItem>[
      DailyChecklistItem.charity,
      DailyChecklistItem.smileAtSomeone,
      DailyChecklistItem.familyCall,
    ];
    final bonusDone = bonusItems.where(completed.contains).length;
    final coreAverage =
        (_todayPrayerPercent +
            _todayQuranPercent +
            _todayDhikrPercent +
            undistractedPercent) /
        4;
    final allChecklistDone =
        completed.length == DailyChecklistItem.values.length;

    if (allChecklistDone) {
      // Completing every checklist item yields a perfect Focus Score.
      _todayPrayerPercent = 100;
      _todayQuranPercent = 100;
      _todayDhikrPercent = 100;
      _todayDistractionPercent = 0;
      _todayFocusScore = 100;
    } else {
      final bonusBoost = (bonusDone / bonusItems.length) * 5; // up to +5 points
      _todayFocusScore = (coreAverage + bonusBoost).round().clamp(0, 100);
    }
  }

  int _percentOf(
    List<DailyChecklistItem> items,
    Set<DailyChecklistItem> completed,
  ) {
    if (items.isEmpty) return 0;
    final done = items.where(completed.contains).length;
    return ((done / items.length) * 100).round();
  }

  int _getPrayerCompletionPercent() {
    // Calculate prayer completion percentage for today
    final now = DateTime.now();
    final today =
        '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';
    final dayData = _prayerStreakState.weekDays
        .where((day) => day.dateKey == today)
        .firstOrNull;
    if (dayData == null) return 0;

    final total = TrackablePrayer.values.length;
    int completed = 0;
    for (final prayer in TrackablePrayer.values) {
      final status = dayData.statusFor(prayer);
      if (status == PrayerMarkStatus.onTime ||
          status == PrayerMarkStatus.qada) {
        completed++;
      }
    }
    return total > 0 ? (completed * 100 / total).round() : 0;
  }

  /// Expires an active cycle when the configured length has elapsed.
  /// Returns true when state changed.
  Future<bool> _ensureCycleModeNotExpired({DateTime? now}) async {
    final at = now ?? DateTime.now();
    if (!_cycleMode.isEnabled || !_cycleMode.hasExpiredOn(at)) return false;
    await saveCycleMode(_cycleMode.expireFully());
    return true;
  }

  /// Persists full Cycle Mode settings and refreshes analytics / focus / achievements.
  Future<void> saveCycleMode(CycleModeData data) async {
    // Merge + normalize histories so disable→enable→disable never duplicates.
    final history = CycleModeData.mergeHistories(
      _cycleMode.history,
      data.history,
    );
    _cycleMode = data.copyWith(
      cycleLength: data.cycleLength.clamp(
        CycleModeData.minCycleLength,
        CycleModeData.maxCycleLength,
      ),
      history: history,
    );
    await StorageService.setCycleModeData(_cycleMode);
    _recomputeAnalytics(DateTime.now());
    await _computeFocusScore();
    await _refreshAchievements();
    notifyListeners();
    unawaited(_syncNightlyWrapUpIfPossible());
    unawaited(
      AppNotificationService.instance.syncCycleModeExpiryNotification(
        cycleMode: _cycleMode,
      ),
    );
  }

  /// Disables Cycle Mode on [onDate] (defaults to today). The disable day is
  /// normal; prior active days seal into a separate historical cycle.
  /// Enabling goes through [saveCycleMode] from the sheet.
  Future<void> setCycleModeEnabled(bool value, {DateTime? onDate}) async {
    if (value) {
      // Enabling is completed by [saveCycleMode] from the settings sheet.
      return;
    }
    final next = _cycleMode.disableOn(onDate ?? DateTime.now());
    await saveCycleMode(next);
  }

  /// Scheduled start time for [prayer] today, or null if times are unavailable.
  DateTime? prayerDateTimeFor(TrackablePrayer prayer) {
    if (prayerTimes == null) return null;

    final HomePrayerId prayerId;
    switch (prayer) {
      case TrackablePrayer.fajr:
        prayerId = HomePrayerId.fajr;
      case TrackablePrayer.dhuhr:
        prayerId = HomePrayerId.dhuhr;
      case TrackablePrayer.asr:
        prayerId = HomePrayerId.asr;
      case TrackablePrayer.maghrib:
        prayerId = HomePrayerId.maghrib;
      case TrackablePrayer.isha:
        prayerId = HomePrayerId.isha;
    }

    for (final slot in prayerTimes!.slots) {
      if (slot.id == prayerId) return slot.time;
    }
    return null;
  }

  /// True when [prayer] has started or already passed on today's clock.
  /// Upcoming prayers must not be marked yet.
  bool hasPrayerStarted(TrackablePrayer prayer, {DateTime? now}) {
    final start = prayerDateTimeFor(prayer);
    if (start == null) return false;
    return HomePrayerTimesHelper.hasStartedOnDay(start, now ?? DateTime.now());
  }

  /// Most recent prayer that has started today (by schedule). Never falls back
  /// to older prayers for reminder purposes.
  TrackablePrayer? getMostRecentStartedPrayer({DateTime? now}) {
    if (prayerTimes == null) return null;
    return PrayerAnalyticsService.mostRecentStartedPrayer(
      now: now ?? DateTime.now(),
      prayerStartTime: prayerDateTimeFor,
    );
  }

  /// Reminder target: the most recent started prayer, only if it is unmarked.
  /// If that prayer is already marked, returns null — older prayers are ignored.
  /// Suppressed on Cycle Mode days (including historical sealed days).
  TrackablePrayer? getPrayerReminderTarget({DateTime? now}) {
    final at = now ?? DateTime.now();
    if (cyclePolicy.isCycleMember(at)) return null;
    final mostRecent = getMostRecentStartedPrayer(now: at);
    if (mostRecent == null) return null;
    if (statusForToday(mostRecent) != PrayerMarkStatus.none) return null;
    return mostRecent;
  }

  TrackablePrayer? getMostRecentUnmarkedPrayer() => getPrayerReminderTarget();

  bool shouldShowPrayerReminder(TrackablePrayer prayer) {
    return getPrayerReminderTarget() == prayer;
  }

  Future<void> syncSectIfChanged(String sect) async {
    if (_lastAppliedSect == sect) return;
    _lastAppliedSect = sect;
    await _loadPrayerTimes();
    await _rescheduleNotificationsIfPossible();
    notifyListeners();
  }

  String? _lastAppliedMethod;
  String? _lastAppliedAsr;

  Future<void> syncCalculationSettingsIfChanged(
    String method,
    String asr,
  ) async {
    if (_lastAppliedMethod == method && _lastAppliedAsr == asr) return;
    _lastAppliedMethod = method;
    _lastAppliedAsr = asr;
    await _loadPrayerTimes();
    await _rescheduleNotificationsIfPossible();
    notifyListeners();
  }

  Future<void> syncLocationIfChanged(
    double? newLatitude,
    double? newLongitude,
    String? newLocationName,
    String? newLocationSubtitle,
  ) async {
    if (newLatitude == null || newLongitude == null) return;
    if (newLatitude == latitude && newLongitude == longitude) return;
    latitude = newLatitude;
    longitude = newLongitude;
    locationName = newLocationName;
    locationSubtitle = newLocationSubtitle;
    await _loadPrayerTimes();
    await _rescheduleNotificationsIfPossible();
    notifyListeners();
  }

  Future<void> _loadEvents() async {
    final cached = await HomeIslamicEventsHelper.loadCachedEvents();
    if (cached.isNotEmpty) {
      allIslamicEvents = cached;
      _refreshVisibleEvents();
      notifyListeners();
    }

    isEventsLoading = true;
    notifyListeners();

    allIslamicEvents = await HomeIslamicEventsHelper.loadIslamicEvents(
      yearsAhead: 2,
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
    final weekAnchorDay = weeklyCalendar
        ? weeklyVisibleWeekStart
        : DateTime.now();
    weekEvents = HomeIslamicEventsHelper.eventsForWeek(
      weekAnchorDay,
      allIslamicEvents,
    );
  }

  void setWeeklyCalendar(bool value) {
    weeklyCalendar = value;
    if (value) {
      final now = DateTime.now();
      final viewingThisMonth =
          visibleMonth.year == now.year && visibleMonth.month == now.month;
      weeklyVisibleWeekStart = _startOfWeekFor(
        viewingThisMonth
            ? DateTime(now.year, now.month, now.day)
            : DateTime(visibleMonth.year, visibleMonth.month, 1),
      );
      visibleMonth = DateTime(
        weeklyVisibleWeekStart.year,
        weeklyVisibleWeekStart.month,
        1,
      );
    }
    _refreshVisibleEvents();
    notifyListeners();
  }

  /// Advances [visibleMonth] by exactly one Gregorian month.
  void goToNextMonth() => _shiftVisibleMonthBy(1);

  /// Moves [visibleMonth] back by exactly one Gregorian month.
  void goToPreviousMonth() => _shiftVisibleMonthBy(-1);

  /// Week-row navigation for weekly calendar mode (±7 days).
  void goToNextWeek() => _shiftVisibleWeekBy(1);

  void goToPreviousWeek() => _shiftVisibleWeekBy(-1);

  void _shiftVisibleMonthBy(int deltaMonths) {
    visibleMonth = DateTime(
      visibleMonth.year,
      visibleMonth.month + deltaMonths,
      1,
    );
    weeklyVisibleWeekStart = _startOfWeekFor(visibleMonth);
    _refreshVisibleEvents();
    notifyListeners();
  }

  void _shiftVisibleWeekBy(int deltaWeeks) {
    weeklyVisibleWeekStart = weeklyVisibleWeekStart.add(
      Duration(days: 7 * deltaWeeks),
    );
    visibleMonth = DateTime(
      weeklyVisibleWeekStart.year,
      weeklyVisibleWeekStart.month,
      1,
    );
    _refreshVisibleEvents();
    notifyListeners();
  }

  static DateTime _startOfWeekFor(DateTime date) {
    final d = DateTime(date.year, date.month, date.day);
    return d.subtract(Duration(days: d.weekday % 7));
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

  /// Home Mon–Sun bars — real marked prayers only (never restore / streak).
  List<int> get weekPrayerCounts => analytics.homeWeekDayCounts;

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
    final current = dayFor(date);
    final isSelected = current.selectedPrayers.contains(prayer);
    await markPrayerStatus(
      date,
      prayer,
      isSelected ? PrayerMarkStatus.none : PrayerMarkStatus.onTime,
    );
  }

  /// Marks [prayer] on [date] as prayed on time, qada, missed, or unmarked.
  /// Only today is editable. Streaks are always recalculated — never incremented.
  Future<PrayerMarkResult?> markPrayerStatus(
    DateTime date,
    TrackablePrayer prayer,
    PrayerMarkStatus status,
  ) async {
    if (!isPrayerDayEditable(date)) return null;

    final previousPrayerStreak = prayerStreak;
    final dateKey = _dayKeyFormat.format(date);
    final current = dayFor(date);
    final historySeed = _mergedStatusHistory()[dateKey];
    PrayerMarkStatus statusOf(TrackablePrayer p) =>
        historySeed?[p] ?? current.statusFor(p);
    final wasCompleted = TrackablePrayer.values.every(
      (p) => PrayerAnalyticsService.countsForPrayerStreak(statusOf(p)),
    );
    final previousStatus = statusOf(prayer);

    // Seed from merged history + weekDays so a stale empty week row cannot
    // drop sibling marks when one prayer is logged.
    final updatedStatuses = <TrackablePrayer, PrayerMarkStatus>{
      for (final p in TrackablePrayer.values)
        if (statusOf(p) != PrayerMarkStatus.none) p: statusOf(p),
    };
    if (status == PrayerMarkStatus.none) {
      updatedStatuses.remove(prayer);
    } else {
      updatedStatuses[prayer] = status;
    }

    final updatedPrayers = <TrackablePrayer>{
      for (final e in updatedStatuses.entries)
        if (e.value == PrayerMarkStatus.onTime ||
            e.value == PrayerMarkStatus.qada)
          e.key,
    };

    final updatedDay = current.copyWith(
      selectedPrayers: updatedPrayers,
      prayerStatuses: updatedStatuses,
    );

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

    final history = Map<String, Map<TrackablePrayer, PrayerMarkStatus>>.from(
      _prayerStreakState.statusHistory.map(
        (k, v) => MapEntry(k, Map<TrackablePrayer, PrayerMarkStatus>.from(v)),
      ),
    );
    if (updatedStatuses.isEmpty) {
      history.remove(dateKey);
    } else {
      history[dateKey] = Map<TrackablePrayer, PrayerMarkStatus>.from(
        updatedStatuses,
      );
    }

    _prayerStreakState = _prayerStreakState.copyWith(
      weekDays: updatedWeekDays,
      completedDateKeys: completedDates,
      statusHistory: history,
    );
    _recomputeAnalytics(DateTime.now());
    final newlyCounts =
        PrayerAnalyticsService.countsForPrayerStreak(status) &&
        !PrayerAnalyticsService.countsForPrayerStreak(previousStatus);
    if (newlyCounts && prayerStreak < previousPrayerStreak + 1) {
      prayerStreak = previousPrayerStreak + 1;
    }
    notifyListeners();
    await _persistPrayerStreak();
    await _computeFocusScore();
    await _refreshAchievements();
    notifyListeners();
    unawaited(_syncNightlyWrapUpIfPossible());

    final celebrated = newlyCounts;
    return PrayerMarkResult(
      prayer: prayer,
      status: status,
      celebrated: celebrated,
      prayerStreak: prayerStreak,
      previousPrayerStreak: previousPrayerStreak,
      dayStreak: streakDays,
    );
  }

  PrayerMarkStatus statusForToday(TrackablePrayer prayer) =>
      dayFor(DateTime.now()).statusFor(prayer);

  String weekdayLabel(DateTime date, String localeName) {
    return DateFormat('EEEE', localeName).format(date);
  }

  Map<String, Map<TrackablePrayer, PrayerMarkStatus>> _mergedStatusHistory() {
    final merged = <String, Map<TrackablePrayer, PrayerMarkStatus>>{
      for (final e in _prayerStreakState.statusHistory.entries)
        e.key: Map<TrackablePrayer, PrayerMarkStatus>.from(e.value),
    };
    for (final day in _prayerStreakState.weekDays) {
      final dayStatuses = <TrackablePrayer, PrayerMarkStatus>{
        for (final p in TrackablePrayer.values)
          if (day.statusFor(p) != PrayerMarkStatus.none) p: day.statusFor(p),
      };
      if (dayStatuses.isNotEmpty) {
        merged[day.dateKey] = dayStatuses;
      }
    }
    return merged;
  }

  /// Always recalculate from [PrayerAnalyticsService] — never mutate streaks.
  void _recomputeAnalytics(DateTime now) {
    final policy = cyclePolicy;
    analytics = PrayerAnalyticsService.calculate(
      now: now,
      statusHistory: _mergedStatusHistory(),
      isPausedStreakDay: policy.shouldPauseStreaks,
      isExcludedStatsDay: policy.shouldExcludeFromStatistics,
      prayerStartTime: prayerDateTimeFor,
    );
    prayerStreak = analytics.prayerStreak;
    streakDays = analytics.dayStreak;

    final bestPrayer = prayerStreak > _prayerStreakState.bestPrayerStreak
        ? prayerStreak
        : _prayerStreakState.bestPrayerStreak;
    final bestDay = streakDays > _prayerStreakState.bestDayStreak
        ? streakDays
        : _prayerStreakState.bestDayStreak;
    if (bestPrayer != _prayerStreakState.bestPrayerStreak ||
        bestDay != _prayerStreakState.bestDayStreak) {
      _prayerStreakState = _prayerStreakState.copyWith(
        bestPrayerStreak: bestPrayer,
        bestDayStreak: bestDay,
      );
    }
  }

  int get unlockedAchievementCount =>
      AchievementsService.unlockedCount(achievements);

  List<AchievementId> get pendingUnlockAchievements {
    return userProgress.pendingUnlockIds
        .map(AchievementIdX.parse)
        .whereType<AchievementId>()
        .toList(growable: false);
  }

  int? get pendingLevelUp => userProgress.pendingLevelUp;

  Future<void> acknowledgeProgressionCelebrations() async {
    userProgress = await ProgressionService.acknowledgeCelebrations(
      userProgress,
    );
    notifyListeners();
  }

  Future<void> _refreshAchievements() async {
    final now = DateTime.now();
    final snapshot = await ProgressionService.evaluateAndPersist(
      previousProgress: userProgress,
      previousEvents: _xpEvents,
      previousAchievements: achievements,
      now: now,
      activityFor: (currentLevel) {
        final history = _mergedStatusHistory();
        final checklist = _checklistForProgression(now);
        final protected = AchievementsService.protectedDaysUntilToday(
          policy: cyclePolicy,
          now: now,
        );
        return AchievementActivitySnapshot(
          now: now,
          prayerStreak: prayerStreak,
          bestPrayerStreak: bestPrayerStreak,
          statusHistory: history,
          checklistHistory: checklist,
          cycleProtectedDays: protected,
          currentLevel: currentLevel,
          journeyStartDate: userProgress.journeyStartDate,
        );
      },
    );
    achievements = snapshot.achievements;
    userProgress = snapshot.progress;
    levelProgress = snapshot.level;
    _xpEvents = snapshot.events;
    if (snapshot.newlyUnlocked.isNotEmpty) {
      unawaited(_maybeRequestAppReview());
    }
  }

  int _completedPrayerCount() {
    var count = 0;
    for (final day in _mergedStatusHistory().values) {
      for (final status in day.values) {
        if (PrayerAnalyticsService.countsForPrayerStreak(status)) count += 1;
      }
    }
    return count;
  }

  Future<void> _recordAndMaybeRequestAppReview() async {
    await AppReviewService.recordMeaningfulSession();
    await _maybeRequestAppReview();
  }

  Future<void> maybeRequestAppReview() => _maybeRequestAppReview();

  Future<void> _maybeRequestAppReview() async {
    await AppReviewService.maybeShowAutomatic(
      completedPrayers: _completedPrayerCount(),
      hasUnlockedAchievement: unlockedAchievementCount > 0,
    );
  }

  Map<String, Set<DailyChecklistItem>> _checklistForProgression(DateTime now) {
    final merged = <String, Set<DailyChecklistItem>>{
      for (final entry in _checklistHistory.entries)
        entry.key: Set<DailyChecklistItem>.from(entry.value),
    };
    merged[_dayKeyFormat.format(now)] = Set<DailyChecklistItem>.from(
      _dailyChecklist.completedItems,
    );
    return merged;
  }

  Future<void> _loadChecklistHistory() async {
    final raw = await StorageService.getString('checklist_history_json');
    if (raw == null || raw.isEmpty) return;
    try {
      final map = jsonDecode(raw) as Map<String, dynamic>;
      _checklistHistory = map.map((key, value) {
        final items = (value as List<dynamic>? ?? const <dynamic>[])
            .whereType<String>()
            .map(
              (name) => DailyChecklistItem.values
                  .where((e) => e.name == name)
                  .firstOrNull,
            )
            .whereType<DailyChecklistItem>()
            .toSet();
        return MapEntry(key, items);
      });
    } catch (_) {}
  }

  Future<void> _persistChecklistHistory() async {
    final encoded = _checklistHistory.map(
      (key, items) => MapEntry(key, items.map((e) => e.name).toList()..sort()),
    );
    await StorageService.setString(
      'checklist_history_json',
      jsonEncode(encoded),
    );
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

  /// Keep Home tiles in sync with [statusHistory] when a week row is empty.
  HomePrayerStreakState _hydrateWeekDaysFromHistory(
    HomePrayerStreakState state,
  ) {
    final history = state.statusHistory;
    if (history.isEmpty) return state;
    final hydrated = state.weekDays.map((day) {
      final hist = history[day.dateKey];
      if (hist == null || hist.isEmpty) return day;
      final selected = <TrackablePrayer>{
        for (final e in hist.entries)
          if (PrayerAnalyticsService.countsForPrayerStreak(e.value)) e.key,
      };
      return day.copyWith(
        selectedPrayers: selected,
        prayerStatuses: Map<TrackablePrayer, PrayerMarkStatus>.from(hist),
      );
    }).toList(growable: false);
    return state.copyWith(weekDays: hydrated);
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
    // Large widget prayer progress reads this same streak JSON.
    // ignore() keeps Hive/plugin failures from failing unit tests after completion.
    WidgetSyncService.instance.syncTimeline().ignore();
  }

  void _startTicker() {
    _ticker?.cancel();
    _ticker = Timer.periodic(const Duration(minutes: 1), (_) async {
      await _ensureCycleModeNotExpired();
      await _loadPrayerTimes();
      await _loadPrayerStreak();
      final checklistRolled = await _ensureDailyChecklistCurrent();
      if (checklistRolled) {
        await _computeFocusScore();
        await _refreshAchievements();
        unawaited(_syncNightlyWrapUpIfPossible());
      }
      notifyListeners();
      unawaited(PrayerLiveActivityService.instance.syncFromStorage());
    });
  }

  @override
  void dispose() {
    _prayerSettingsService.removeListener(_onPrayerSettingsChanged);
    _ticker?.cancel();
    super.dispose();
  }
}
