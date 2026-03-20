import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/services/device_apps_service.dart';
import '../../../core/services/focus_enforcement_service.dart';
import '../../../core/services/storage_service.dart';
import '../../home/helpers/home_prayer_times_helper.dart';
import '../../home/model/home_models.dart';
import '../model/focus_models.dart';

class FocusController extends ChangeNotifier {
  FocusSettings _settings = FocusSettings.defaults();
  FocusLockState _lockState = const FocusLockState.unlocked();
  List<FocusInstalledApp> _installedApps = const <FocusInstalledApp>[];
  bool _isInitialized = false;
  bool _isLoadingApps = false;
  Timer? _refreshTimer;

  double? _cachedLatitude;
  double? _cachedLongitude;

  FocusSettings get settings => _settings;
  FocusLockState get lockState => _lockState;
  List<FocusInstalledApp> get installedApps => _installedApps;
  bool get isLoadingApps => _isLoadingApps;
  bool get hasInstalledApps => _installedApps.isNotEmpty;
  bool get isAnyModeEnabled => _settings.enabledMode != null;
  bool get hasSelectedApps => _settings.hasSelectedApps;
  int get selectedAppCount => _settings.selectedApps.isNotEmpty
      ? _settings.selectedApps.length
      : _settings.iosSelectionCount;
  bool get isAppsLocked => _lockState.isLocked;
  bool get isTemporarilyUnlocked => _lockState.isTemporarilyUnlocked;
  bool get needsLocationForSalah =>
      _settings.salahModeEnabled &&
      (_cachedLatitude == null || _cachedLongitude == null);

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    await _load();
  }

  Future<void> refresh() async {
    await _reloadLocation();
    await _recomputeAndPersist();
  }

  Future<void> requestInstalledApps() async {
    if (_isLoadingApps) return;

    if (Platform.isIOS) {
      final result = await DeviceAppsService.presentIosFamilyPicker();
      if (result == null) return;
      _settings = _settings.copyWith(
        iosSelectionData: result.selectionData,
        iosSelectionCount: result.applicationCount,
        selectedApps: const <String, String>{},
      );
      await _persist();
      await _recomputeAndPersist();
      return;
    }

    _isLoadingApps = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 16));
    _installedApps = await DeviceAppsService.getInstalledApps();

    _isLoadingApps = false;
    notifyListeners();
  }

  Future<void> setSelectedApps(List<FocusInstalledApp> apps) async {
    final selected = <String, String>{
      for (final app in apps) app.packageName: app.appName,
    };
    final selectedIcons = <String, String>{
      for (final app in apps)
        if (app.iconBase64 != null) app.packageName: app.iconBase64!,
    };
    _settings = _settings.copyWith(
      selectedApps: selected,
      selectedAppIcons: selectedIcons,
      childModeEnabled: selected.isEmpty ? false : null,
      nightDisciplineEnabled: selected.isEmpty ? false : null,
      salahModeEnabled: selected.isEmpty ? false : null,
      clearChildLockedUntil: selected.isEmpty,
      clearTemporaryUnlock: selected.isEmpty,
      iosSelectionCount: 0,
      clearIosSelectionData: true,
    );
    await _persist();
    await _recomputeAndPersist();
  }

  Future<void> setChildLockType(ChildLockType value) async {
    _settings = _settings.copyWith(childLockType: value);
    await _persist();
    await _recomputeAndPersist();
  }

  Future<void> setChildLockDuration(int minutes) async {
    _settings = _settings.copyWith(childLockDurationMinutes: minutes);
    await _persist();
    await _recomputeAndPersist();
  }

  Future<void> setNightRange(TimeOfDay start, TimeOfDay end) async {
    _settings = _settings.copyWith(
      nightRange: FocusTimeRange(
        startHour: start.hour,
        startMinute: start.minute,
        endHour: end.hour,
        endMinute: end.minute,
      ),
    );
    await _persist();
    await _recomputeAndPersist();
  }

  Future<void> enableMode(FocusModeType mode) async {
    if (!_settings.hasSelectedApps) return;

    final childLockedUntil =
        mode == FocusModeType.child &&
            _settings.childLockType == ChildLockType.timed
        ? DateTime.now().add(
            Duration(minutes: _settings.childLockDurationMinutes),
          )
        : null;

    _settings = _settings.copyWith(
      childModeEnabled: mode == FocusModeType.child,
      nightDisciplineEnabled: mode == FocusModeType.nightDiscipline,
      salahModeEnabled: mode == FocusModeType.salah,
      childLockedUntil: childLockedUntil,
      clearChildLockedUntil:
          mode != FocusModeType.child ||
          _settings.childLockType == ChildLockType.indefinite,
      clearTemporaryUnlock: true,
    );

    await _persist();
    await _recomputeAndPersist();
  }

  Future<void> disableMode(FocusModeType mode) async {
    switch (mode) {
      case FocusModeType.child:
        _settings = _settings.copyWith(
          childModeEnabled: false,
          clearChildLockedUntil: true,
          clearTemporaryUnlock: true,
        );
        break;
      case FocusModeType.nightDiscipline:
        _settings = _settings.copyWith(
          nightDisciplineEnabled: false,
          clearTemporaryUnlock: true,
        );
        break;
      case FocusModeType.salah:
        _settings = _settings.copyWith(
          salahModeEnabled: false,
          clearTemporaryUnlock: true,
        );
        break;
    }
    await _persist();
    await _recomputeAndPersist();
  }

  Future<void> temporarilyUnlock({
    Duration duration = const Duration(minutes: 15),
  }) async {
    if (!_lockState.isLocked) return;
    _settings = _settings.copyWith(
      temporarilyUnlockedUntil: DateTime.now().add(duration),
    );
    await _persist();
    await _recomputeAndPersist();
  }

  Future<void> disableActiveMode() async {
    final mode = _settings.enabledMode;
    if (mode == null) return;
    await disableMode(mode);
  }

  String selectedAppsSummary() {
    if (Platform.isIOS && _settings.iosSelectionCount > 0) {
      return '${_settings.iosSelectionCount} iOS app${_settings.iosSelectionCount == 1 ? '' : 's'} selected';
    }
    if (_settings.selectedApps.isEmpty) return 'No apps selected';
    final values = _settings.selectedApps.values.toList(growable: false);
    if (values.length <= 3) return values.join(', ');
    return '${values.take(3).join(', ')} +${values.length - 3} more';
  }

  String modeTitle(FocusModeType mode) {
    switch (mode) {
      case FocusModeType.child:
        return 'Child Mode';
      case FocusModeType.nightDiscipline:
        return 'Night Discipline';
      case FocusModeType.salah:
        return 'Salah Mode';
    }
  }

  String modeSubtitle(FocusModeType mode) {
    switch (mode) {
      case FocusModeType.child:
        return _settings.childLockType == ChildLockType.indefinite
            ? 'Lock selected apps until you turn the mode off.'
            : 'Lock selected apps for ${_settings.childLockDurationMinutes} minutes.';
      case FocusModeType.nightDiscipline:
        return 'Lock selected apps every day from ${_formatTime(_settings.nightRange.startHour, _settings.nightRange.startMinute)} to ${_formatTime(_settings.nightRange.endHour, _settings.nightRange.endMinute)}.';
      case FocusModeType.salah:
        return 'Lock selected apps 5 minutes before each prayer until 5 minutes after.';
    }
  }

  String get homeCardTitle {
    if (_lockState.isLocked) return 'Apps Locked';
    if (isAnyModeEnabled) return 'Focus mode armed';
    return 'Set up focus modes';
  }

  String get homeCardSubtitle {
    if (_lockState.isLocked) {
      return _lockState.reason ?? 'Selected apps are blocked right now.';
    }
    if (isAnyModeEnabled) {
      final mode = _settings.enabledMode;
      return mode == null
          ? 'Choose a mode to protect your attention.'
          : '${modeTitle(mode)} is enabled.';
    }
    return 'Choose apps and enable one mode at a time.';
  }

  String get statusCaption {
    if (!_settings.hasSelectedApps) return 'Select apps to start';
    if (_lockState.isLocked) return _lockState.reason ?? 'Apps are locked now';
    if (isTemporarilyUnlocked && _settings.temporarilyUnlockedUntil != null) {
      return 'Unlocked until ${DateFormat.jm().format(_settings.temporarilyUnlockedUntil!)}';
    }
    if (_settings.enabledMode == null) return 'No focus mode enabled';
    return 'Ready to lock $selectedAppCount apps';
  }

  Future<void> _load() async {
    final json = await StorageService.focusSettingsJson;
    _settings = json == null
        ? FocusSettings.defaults()
        : FocusSettings.fromJson(json);
    await _reloadLocation();
    if (Platform.isAndroid && _settings.selectedApps.isNotEmpty) {
      unawaited(_warmInstalledAppsCache());
    }
    await _recomputeAndPersist();
  }

  Future<void> _warmInstalledAppsCache() async {
    final apps = await DeviceAppsService.getInstalledApps();
    if (apps.isEmpty) return;
    _installedApps = apps;
    notifyListeners();
  }

  Future<void> _reloadLocation() async {
    _cachedLatitude = await StorageService.locationLatitude;
    _cachedLongitude = await StorageService.locationLongitude;
  }

  Future<void> _recomputeAndPersist() async {
    final updatedSettings = _normalizeSettings(_settings, DateTime.now());
    final updatedLockState = await _computeLockState(updatedSettings);
    _settings = updatedSettings;
    _lockState = updatedLockState;
    await _persist();
    await FocusEnforcementService.sync(
      settings: _settings,
      lockState: _lockState,
    );
    _scheduleNextRefresh();
    notifyListeners();
  }

  FocusSettings _normalizeSettings(FocusSettings settings, DateTime now) {
    if (settings.childModeEnabled &&
        settings.childLockType == ChildLockType.timed &&
        settings.childLockedUntil != null &&
        !settings.childLockedUntil!.isAfter(now)) {
      return settings.copyWith(
        childModeEnabled: false,
        clearChildLockedUntil: true,
        clearTemporaryUnlock: true,
      );
    }

    if (settings.temporarilyUnlockedUntil != null &&
        !settings.temporarilyUnlockedUntil!.isAfter(now)) {
      return settings.copyWith(clearTemporaryUnlock: true);
    }

    return settings;
  }

  Future<FocusLockState> _computeLockState(FocusSettings settings) async {
    if (!settings.hasSelectedApps) return const FocusLockState.unlocked();

    if (settings.childModeEnabled) {
      final isTempUnlocked = _isTemporaryUnlockActive(settings);
      return FocusLockState(
        isLocked: !isTempUnlocked,
        activeMode: FocusModeType.child,
        reason: settings.childLockType == ChildLockType.indefinite
            ? 'Child mode is locking your selected apps.'
            : 'Child mode is active until ${_formatDateTime(settings.childLockedUntil)}.',
        nextChangeAt: settings.childLockType == ChildLockType.timed
            ? settings.childLockedUntil
            : settings.temporarilyUnlockedUntil,
        isTemporarilyUnlocked: isTempUnlocked,
      );
    }

    if (settings.nightDisciplineEnabled) {
      final now = DateTime.now();
      final isWithinWindow = settings.nightRange.contains(now);
      final tempUnlocked = isWithinWindow && _isTemporaryUnlockActive(settings);
      return FocusLockState(
        isLocked: isWithinWindow && !tempUnlocked,
        activeMode: FocusModeType.nightDiscipline,
        reason: isWithinWindow
            ? 'Night Discipline is blocking selected apps.'
            : 'Night Discipline will start at ${_formatTime(settings.nightRange.startHour, settings.nightRange.startMinute)}.',
        nextChangeAt: _earlierOf(
          tempUnlocked ? settings.temporarilyUnlockedUntil : null,
          _nextNightBoundary(settings.nightRange, now),
        ),
        isTemporarilyUnlocked: tempUnlocked,
      );
    }

    if (settings.salahModeEnabled) {
      final now = DateTime.now();
      final windows = await _salahWindows(now);
      final active = windows.where((window) {
        return !now.isBefore(window.start) && now.isBefore(window.end);
      }).firstOrNull;
      final tempUnlocked = active != null && _isTemporaryUnlockActive(settings);
      return FocusLockState(
        isLocked: active != null && !tempUnlocked,
        activeMode: FocusModeType.salah,
        reason: active == null
            ? 'Salah mode will lock apps around the next prayer.'
            : 'Salah mode is active for ${_prayerLabel(active.prayer.id)}.',
        nextChangeAt: _earlierOf(
          tempUnlocked ? settings.temporarilyUnlockedUntil : null,
          active?.end ?? _nextSalahStart(windows, now),
        ),
        isTemporarilyUnlocked: tempUnlocked,
      );
    }

    return const FocusLockState.unlocked();
  }

  bool _isTemporaryUnlockActive(FocusSettings settings) {
    final until = settings.temporarilyUnlockedUntil;
    return until != null && until.isAfter(DateTime.now());
  }

  DateTime? _nextNightBoundary(FocusTimeRange range, DateTime now) {
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
      if (now.isBefore(todayStart)) return todayStart;
      if (now.isBefore(todayEnd)) return todayEnd;
      return todayStart.add(const Duration(days: 1));
    }

    if (now.isBefore(todayStart)) return todayStart;
    if (now.isBefore(todayEnd)) return todayEnd;
    return todayStart.add(const Duration(days: 1));
  }

  Future<List<SalahWindow>> _salahWindows(DateTime now) async {
    if (_cachedLatitude == null || _cachedLongitude == null) {
      return const <SalahWindow>[];
    }

    final today = await HomePrayerTimesHelper.getOrGeneratePrayerTimes(
      latitude: _cachedLatitude!,
      longitude: _cachedLongitude!,
      now: now,
    );
    final tomorrow = await HomePrayerTimesHelper.getOrGeneratePrayerTimes(
      latitude: _cachedLatitude!,
      longitude: _cachedLongitude!,
      now: now.add(const Duration(days: 1)),
    );

    final prayers = <HomePrayerSlot>[
      ...today.slots.where((slot) => slot.id != HomePrayerId.sunrise),
      ...tomorrow.slots.where((slot) => slot.id == HomePrayerId.fajr).take(1),
    ];

    return prayers
        .map(
          (slot) => SalahWindow(
            prayer: slot,
            start: slot.time.subtract(const Duration(minutes: 5)),
            end: slot.time.add(const Duration(minutes: 5)),
          ),
        )
        .toList(growable: false);
  }

  DateTime? _nextSalahStart(List<SalahWindow> windows, DateTime now) {
    for (final window in windows) {
      if (window.start.isAfter(now)) return window.start;
    }
    return null;
  }

  DateTime? _earlierOf(DateTime? a, DateTime? b) {
    if (a == null) return b;
    if (b == null) return a;
    return a.isBefore(b) ? a : b;
  }

  void _scheduleNextRefresh() {
    _refreshTimer?.cancel();

    final next = _lockState.nextChangeAt;
    if (next == null) return;

    final delay = next.difference(DateTime.now()) + const Duration(seconds: 1);
    if (delay.isNegative) {
      unawaited(_recomputeAndPersist());
      return;
    }

    _refreshTimer = Timer(delay, () async {
      await _reloadLocation();
      await _recomputeAndPersist();
    });
  }

  String _formatTime(int hour, int minute) {
    final now = DateTime.now();
    return DateFormat.jm().format(
      DateTime(now.year, now.month, now.day, hour, minute),
    );
  }

  String _formatDateTime(DateTime? value) {
    if (value == null) return 'soon';
    return DateFormat('MMM d, h:mm a').format(value);
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

  Future<void> _persist() async {
    await StorageService.setFocusSettingsJson(_settings.toJson());
  }

  @override
  void dispose() {
    _refreshTimer?.cancel();
    super.dispose();
  }
}
