import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../core/services/device_apps_service.dart';
import '../../../core/services/app_notification_service.dart';
import '../../../core/services/focus_enforcement_service.dart';
import '../../../core/services/storage_service.dart';
import '../../home/helpers/home_prayer_times_helper.dart';
import '../../home/model/home_models.dart';
import '../model/focus_models.dart';

class FocusController extends ChangeNotifier {
  // TEMP: Salah test mode (keep code, disable for production)
  // static const bool _salahTestModeEnabled = true;
  static const bool _salahTestModeEnabled = false;
  static const int _salahTestWindowCount = 2;
  static const Duration _salahTestInitialDelay = Duration(minutes: 2);
  static const Duration _salahTestLockDuration = Duration(minutes: 4);
  static const Duration _salahTestGapDuration = Duration(minutes: 2);

  FocusSettings _settings = FocusSettings.defaults();
  FocusLockState _lockState = const FocusLockState.unlocked();
  List<FocusInstalledApp> _installedApps = const <FocusInstalledApp>[];
  bool _isInitialized = false;
  bool _isLoadingApps = false;
  Timer? _refreshTimer;

  /// Ensures recomputes never run in parallel (multiple lifecycle observers call
  /// [refresh] on resume, which previously interleaved and flickered lock/unlock UI).
  Future<void> _recomputeSerial = Future<void>.value();

  double? _cachedLatitude;
  double? _cachedLongitude;

  FocusSettings get settings => _settings;
  FocusLockState get lockState => _lockState;
  List<FocusInstalledApp> get installedApps => _installedApps;
  bool get isLoadingApps => _isLoadingApps;
  bool get hasInstalledApps => _installedApps.isNotEmpty;
  bool get isAnyModeEnabled =>
      _settings.childModeEnabled ||
      _settings.nightDisciplineEnabled ||
      _settings.salahModeEnabled;
  bool get hasSelectedApps => _settings.hasSelectedApps;
  int get selectedAppCount => _settings.selectedApps.isNotEmpty
      ? _settings.selectedApps.length
      : _settings.iosSelectionTotalCount;
  bool get isIosPickerSelection =>
      Platform.isIOS &&
      _settings.selectedApps.isEmpty &&
      _settings.iosSelectionTotalCount > 0;
  String get selectedTargetNoun => isIosPickerSelection ? 'item' : 'app';
  String get selectedTargetPhrase =>
      '$selectedAppCount $selectedTargetNoun${selectedAppCount == 1 ? '' : 's'}';
  bool get isAppsLocked => _lockState.isLocked;
  bool get isTemporarilyUnlocked => _lockState.isTemporarilyUnlocked;
  bool get needsLocationForSalah =>
      _settings.salahModeEnabled &&
      (_cachedLatitude == null || _cachedLongitude == null);

  Future<void> initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    await FocusEnforcementService.appendDebugLog(
      'focus.initialize',
      'initializing controller',
    );
    await _load();
  }

  Future<void> refresh() async {
    await FocusEnforcementService.appendDebugLog(
      'focus.refresh',
      'manual refresh start',
    );
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
        iosSelectionCount: result.selectionCount,
        iosApplicationSelectionCount: result.applicationCount,
        iosCategorySelectionCount: result.categoryCount,
        iosWebDomainSelectionCount: result.webDomainCount,
        selectedApps: const <String, String>{},
        selectedAppIcons: const <String, String>{},
      );
      await _persist();
      await _recomputeAndPersist();
      return;
    }

    _isLoadingApps = true;
    notifyListeners();

    await Future<void>.delayed(const Duration(milliseconds: 16));
    final rawApps = await DeviceAppsService.getInstalledApps();
    _installedApps = _normalizeInstalledApps(rawApps);

    _isLoadingApps = false;
    notifyListeners();
  }

  Future<void> toggleSelectedApp(FocusInstalledApp app) async {
    final selected = Map<String, String>.from(_settings.selectedApps);
    final selectedIcons = Map<String, String>.from(_settings.selectedAppIcons);
    final isSelected = selected.containsKey(app.packageName);
    if (isSelected) {
      selected.remove(app.packageName);
      selectedIcons.remove(app.packageName);
    } else {
      selected[app.packageName] = app.appName;
      final iconBase64 = app.iconBase64;
      if (iconBase64 != null) {
        selectedIcons[app.packageName] = iconBase64;
      }
    }

    _settings = _settings.copyWith(
      selectedApps: selected,
      selectedAppIcons: selectedIcons,
      childModeEnabled: selected.isEmpty ? false : null,
      nightDisciplineEnabled: selected.isEmpty ? false : null,
      salahModeEnabled: selected.isEmpty ? false : null,
      clearChildLockedUntil: selected.isEmpty,
      clearTemporaryUnlock: selected.isEmpty,
      iosSelectionCount: 0,
      iosApplicationSelectionCount: 0,
      iosCategorySelectionCount: 0,
      iosWebDomainSelectionCount: 0,
      clearIosSelectionData: true,
    );
    await _recomputeAndPersist();
  }

  Future<void> setSelectedApps(List<FocusInstalledApp> apps) async {
    await FocusEnforcementService.appendDebugLog(
      'focus.setSelectedApps',
      'count=${apps.length} packages=${apps.map((app) => app.packageName).join(",")}',
    );
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
      iosApplicationSelectionCount: 0,
      iosCategorySelectionCount: 0,
      iosWebDomainSelectionCount: 0,
      clearIosSelectionData: true,
    );
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
    await FocusEnforcementService.appendDebugLog(
      'focus.nightRange.update',
      'sleep=${start.hour.toString().padLeft(2, "0")}:${start.minute.toString().padLeft(2, "0")} wake=${end.hour.toString().padLeft(2, "0")}:${end.minute.toString().padLeft(2, "0")}',
    );
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
    unawaited(
      FocusEnforcementService.appendDebugLog(
        'focus.enableMode',
        'before mode=${mode.name} selected=${_settings.selectedApps.keys.join(",")} childType=${_settings.childLockType.name} tempUnlockUntil=${_settings.temporarilyUnlockedUntil?.toIso8601String()}',
      ),
    );

    if (mode == FocusModeType.salah) {
      await _reloadLocation();
    }

    final childLockedUntil =
        mode == FocusModeType.child &&
            _settings.childLockType == ChildLockType.timed
        ? DateTime.now().add(
            Duration(minutes: _settings.childLockDurationMinutes),
          )
        : null;

    final now = DateTime.now();
    if (mode == FocusModeType.child) {
      _settings = _settings.copyWith(
        childModeEnabled: true,
        nightDisciplineEnabled: false,
        salahModeEnabled: false,
        salahTestAnchorAt: _salahTestModeEnabled
            ? (_settings.salahTestAnchorAt ?? now)
            : null,
        clearSalahTestAnchorAt: !_salahTestModeEnabled,
        childLockedUntil: childLockedUntil,
        clearChildLockedUntil:
            _settings.childLockType == ChildLockType.indefinite,
        clearTemporaryUnlock: true,
      );
    } else {
      _settings = _settings.copyWith(
        childModeEnabled: false,
        clearChildLockedUntil: true,
        nightDisciplineEnabled: mode == FocusModeType.nightDiscipline
            ? true
            : _settings.nightDisciplineEnabled,
        salahModeEnabled: mode == FocusModeType.salah
            ? true
            : _settings.salahModeEnabled,
        salahTestAnchorAt: _salahTestModeEnabled && mode == FocusModeType.salah
            ? (_settings.salahTestAnchorAt ?? now)
            : null,
        clearSalahTestAnchorAt:
            mode != FocusModeType.salah || !_salahTestModeEnabled,
        clearTemporaryUnlock: true,
      );
    }

    await _recomputeAndPersist();
    unawaited(
      FocusEnforcementService.appendDebugLog(
        'focus.enableMode',
        'after mode=${mode.name} active=${_settings.enabledMode?.name} locked=${_lockState.isLocked} nextChangeAt=${_lockState.nextChangeAt?.toIso8601String()} reason=${_lockState.reason}',
      ),
    );
  }

  Future<void> disableMode(FocusModeType mode) async {
    unawaited(
      FocusEnforcementService.appendDebugLog(
        'focus.disableMode',
        'before mode=${mode.name} active=${_settings.enabledMode?.name} locked=${_lockState.isLocked}',
      ),
    );
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
          clearSalahTestAnchorAt: true,
          clearTemporaryUnlock: true,
        );
        break;
    }
    await _recomputeAndPersist();
    unawaited(
      FocusEnforcementService.appendDebugLog(
        'focus.disableMode',
        'after mode=${mode.name} active=${_settings.enabledMode?.name} locked=${_lockState.isLocked}',
      ),
    );
  }

  Future<void> temporarilyUnlock({
    Duration duration = const Duration(minutes: 15),
  }) async {
    if (!_lockState.isLocked) return;
    await FocusEnforcementService.appendDebugLog(
      'focus.temporarilyUnlock',
      'duration=${duration.inMinutes} currentMode=${_lockState.activeMode?.name}',
    );
    _settings = _settings.copyWith(
      temporarilyUnlockedUntil: DateTime.now().add(duration),
    );
    await _persist();
    await _recomputeAndPersist();
  }

  Future<void> disableActiveMode() async {
    final mode = _lockState.activeMode;
    if (mode == null) return;
    await disableMode(mode);
  }

  String selectedAppsSummary() {
    if (Platform.isIOS && _settings.iosSelectionTotalCount > 0) {
      final parts = <String>[];
      if (_settings.iosApplicationSelectionCount > 0) {
        parts.add(
          '${_settings.iosApplicationSelectionCount} app${_settings.iosApplicationSelectionCount == 1 ? '' : 's'}',
        );
      }
      if (_settings.iosCategorySelectionCount > 0) {
        parts.add(
          '${_settings.iosCategorySelectionCount} categor${_settings.iosCategorySelectionCount == 1 ? 'y' : 'ies'}',
        );
      }
      if (_settings.iosWebDomainSelectionCount > 0) {
        parts.add(
          '${_settings.iosWebDomainSelectionCount} website${_settings.iosWebDomainSelectionCount == 1 ? '' : 's'}',
        );
      }
      if (parts.isNotEmpty) {
        return '${parts.join(', ')} selected';
      }
      final totalCount = _settings.iosSelectionTotalCount;
      return '$totalCount iOS item${totalCount == 1 ? '' : 's'} selected';
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

  List<FocusInstalledApp> _normalizeInstalledApps(
    List<FocusInstalledApp> apps,
  ) {
    if (apps.isEmpty) return const <FocusInstalledApp>[];
    final byPackage = <String, FocusInstalledApp>{};
    for (final app in apps) {
      final packageName = app.packageName.trim();
      if (packageName.isEmpty) continue;
      final appName = app.appName.trim().isEmpty ? packageName : app.appName;
      final normalized = FocusInstalledApp(
        packageName: packageName,
        appName: appName,
        isSystemApp: app.isSystemApp,
        iconBytes: app.iconBytes,
      );
      final existing = byPackage[packageName];
      if (existing == null ||
          (existing.isSystemApp && !normalized.isSystemApp)) {
        byPackage[packageName] = normalized;
      }
    }

    final result = byPackage.values.toList(growable: true);
    result.sort(
      (a, b) => a.appName.toLowerCase().compareTo(b.appName.toLowerCase()),
    );
    return result;
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
        return _salahTestModeEnabled
            ? 'Testing mode: lock starts in 2 minutes for 4 minutes, twice.'
            : 'Lock selected apps at prayer time until 15 minutes after.';
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
      if (_settings.childModeEnabled) {
        return '${modeTitle(FocusModeType.child)} is enabled.';
      }
      final parts = <String>[];
      if (_settings.nightDisciplineEnabled) {
        parts.add(modeTitle(FocusModeType.nightDiscipline));
      }
      if (_settings.salahModeEnabled) {
        parts.add(modeTitle(FocusModeType.salah));
      }
      if (parts.isEmpty) {
        return 'Choose a mode to protect your attention.';
      }
      if (parts.length == 1) {
        return '${parts.first} is enabled.';
      }
      return '${parts.join(' and ')} are enabled.';
    }
    return 'Choose apps and enable focus modes.';
  }

  String get statusCaption {
    if (!_settings.hasSelectedApps) return 'Select apps to start';
    if (_lockState.isLocked) return _lockState.reason ?? 'Apps are locked now';
    if (isTemporarilyUnlocked && _settings.temporarilyUnlockedUntil != null) {
      return 'Unlocked until ${DateFormat.jm().format(_settings.temporarilyUnlockedUntil!)}';
    }
    if (!isAnyModeEnabled) return 'No focus mode enabled';
    return 'Ready to lock $selectedTargetPhrase';
  }

  Future<void> _load() async {
    final json = await StorageService.focusSettingsJson;
    _settings = json == null
        ? FocusSettings.defaults()
        : FocusSettings.fromJson(json);
    await FocusEnforcementService.appendDebugLog(
      'focus.load',
      'loaded mode=${_settings.enabledMode?.name} selected=${_settings.selectedApps.keys.join(",")} night=${_settings.nightDisciplineEnabled} salah=${_settings.salahModeEnabled}',
    );
    await _reloadLocation();
    if (Platform.isAndroid && _settings.selectedApps.isNotEmpty) {
      unawaited(_warmInstalledAppsCache());
    }
    notifyListeners();
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
    await FocusEnforcementService.appendDebugLog(
      'focus.location',
      'lat=$_cachedLatitude lng=$_cachedLongitude',
    );
  }

  Future<void> _recomputeAndPersist() {
    final run = _recomputeSerial.then((_) => _recomputeAndPersistBody());
    _recomputeSerial = run.catchError((Object _) {});
    return run;
  }

  Future<void> _recomputeAndPersistBody() async {
    unawaited(
      FocusEnforcementService.appendDebugLog(
        'focus.recompute',
        'start mode=${_settings.enabledMode?.name} selected=${_settings.selectedApps.keys.join(",")} tempUnlock=${_settings.temporarilyUnlockedUntil?.toIso8601String()}',
      ),
    );
    final recomputeNow = DateTime.now();
    final updatedSettings = _normalizeSettings(_settings, recomputeNow);
    Future<List<SalahWindow>>? memoizedSalahWindows;
    Future<List<SalahWindow>> salahWindowsOnce() {
      memoizedSalahWindows ??= _salahWindows(recomputeNow);
      return memoizedSalahWindows!;
    }

    final updatedLockState = await _computeLockState(
      updatedSettings,
      recomputeNow,
      salahWindowsOnce,
    );
    final scheduledTransitions = await _buildScheduledTransitions(
      updatedSettings,
      recomputeNow,
      salahWindowsOnce,
    );
    _settings = updatedSettings;
    _lockState = updatedLockState;
    await _persist();
    notifyListeners();
    unawaited(
      FocusEnforcementService.sync(
        settings: _settings,
        lockState: _lockState,
        scheduledTransitions: scheduledTransitions,
      ),
    );
    unawaited(
      AppNotificationService.instance
          .syncFocusNotifications(
            settings: _settings,
            latitude: _cachedLatitude,
            longitude: _cachedLongitude,
          )
          .catchError((Object e, StackTrace st) {
            assert(() {
              debugPrint('focus: syncFocusNotifications failed: $e\n$st');
              return true;
            }());
          }),
    );
    unawaited(
      FocusEnforcementService.appendDebugLog(
        'focus.recompute',
        'done mode=${_lockState.activeMode?.name} locked=${_lockState.isLocked} nextChangeAt=${_lockState.nextChangeAt?.toIso8601String()} transitions=${scheduledTransitions.length} reason=${_lockState.reason}',
      ),
    );
    _scheduleNextRefresh();
  }

  FocusSettings _normalizeSettings(FocusSettings settings, DateTime now) {
    var s = settings;
    if (s.childModeEnabled &&
        (s.nightDisciplineEnabled || s.salahModeEnabled)) {
      s = s.copyWith(nightDisciplineEnabled: false, salahModeEnabled: false);
    }

    if (s.childModeEnabled &&
        s.childLockType == ChildLockType.timed &&
        s.childLockedUntil != null &&
        !s.childLockedUntil!.isAfter(now)) {
      return s.copyWith(
        childModeEnabled: false,
        clearChildLockedUntil: true,
        clearTemporaryUnlock: true,
      );
    }

    if (s.temporarilyUnlockedUntil != null &&
        !s.temporarilyUnlockedUntil!.isAfter(now)) {
      return s.copyWith(clearTemporaryUnlock: true);
    }

    return s;
  }

  Future<FocusLockState> _computeLockState(
    FocusSettings settings,
    DateTime now,
    Future<List<SalahWindow>> Function() getSalahWindows,
  ) async {
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

    final windows = settings.salahModeEnabled
        ? await getSalahWindows()
        : const <SalahWindow>[];
    return _lockStateAtInstant(settings, now, windows);
  }

  /// Same rules as live lock state, for an arbitrary instant (used for iOS schedules).
  FocusLockState _lockStateAtInstant(
    FocusSettings settings,
    DateTime at,
    List<SalahWindow> windows,
  ) {
    if (!settings.hasSelectedApps) return const FocusLockState.unlocked();

    if (settings.childModeEnabled) {
      final isTempUnlocked = _isTemporaryUnlockActiveAt(settings, at);
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

    if (!settings.nightDisciplineEnabled && !settings.salahModeEnabled) {
      return const FocusLockState.unlocked();
    }

    final nightLocked =
        settings.nightDisciplineEnabled && settings.nightRange.contains(at);
    SalahWindow? activeSalah;
    if (settings.salahModeEnabled) {
      activeSalah = windows.where((window) {
        return !at.isBefore(window.start) && at.isBefore(window.end);
      }).firstOrNull;
    }
    final salahLocked = activeSalah != null;
    final inScheduledWindow = nightLocked || salahLocked;
    final tempUnlocked =
        inScheduledWindow && _isTemporaryUnlockActiveAt(settings, at);

    if (!nightLocked && !salahLocked) {
      DateTime? nextChange;
      String reason;
      if (settings.nightDisciplineEnabled && settings.salahModeEnabled) {
        nextChange = _earlierOf(
          _nextNightBoundary(settings.nightRange, at),
          _nextSalahStart(windows, at),
        );
        reason =
            'Night Discipline and Salah mode will lock apps at their scheduled times.';
      } else if (settings.nightDisciplineEnabled) {
        nextChange = _nextNightBoundary(settings.nightRange, at);
        reason =
            'Night Discipline will start at ${_formatTime(settings.nightRange.startHour, settings.nightRange.startMinute)}.';
      } else {
        nextChange = _nextSalahStart(windows, at);
        reason = 'Salah mode will lock apps around the next prayer.';
      }
      return FocusLockState(
        isLocked: false,
        activeMode: settings.nightDisciplineEnabled
            ? FocusModeType.nightDiscipline
            : FocusModeType.salah,
        reason: reason,
        nextChangeAt: nextChange,
        isTemporarilyUnlocked: false,
      );
    }

    final isLocked = !tempUnlocked;
    final FocusModeType displayMode;
    final String reason;
    if (salahLocked && nightLocked) {
      displayMode = FocusModeType.salah;
      reason = 'Night Discipline and Salah mode are blocking selected apps.';
    } else if (salahLocked) {
      displayMode = FocusModeType.salah;
      reason =
          'Salah mode is active for ${_prayerLabel(activeSalah.prayer.id)}.';
    } else {
      displayMode = FocusModeType.nightDiscipline;
      reason = 'Night Discipline is blocking selected apps.';
    }

    DateTime? nextChangeAt = tempUnlocked
        ? settings.temporarilyUnlockedUntil
        : null;
    if (salahLocked) {
      nextChangeAt = _earlierOf(nextChangeAt, activeSalah.end);
    }
    if (nightLocked) {
      nextChangeAt = _earlierOf(
        nextChangeAt,
        _nextNightBoundary(settings.nightRange, at),
      );
    }

    return FocusLockState(
      isLocked: isLocked,
      activeMode: displayMode,
      reason: reason,
      nextChangeAt: nextChangeAt,
      isTemporarilyUnlocked: tempUnlocked,
    );
  }

  bool _isTemporaryUnlockActive(FocusSettings settings) {
    return _isTemporaryUnlockActiveAt(settings, DateTime.now());
  }

  bool _isTemporaryUnlockActiveAt(FocusSettings settings, DateTime at) {
    final until = settings.temporarilyUnlockedUntil;
    return until != null && until.isAfter(at);
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
    if (_salahTestModeEnabled) {
      final anchor = _settings.salahTestAnchorAt ?? now;
      final windows = List<SalahWindow>.generate(_salahTestWindowCount, (
        index,
      ) {
        final start = anchor.add(
          _salahTestInitialDelay +
              (_salahTestLockDuration + _salahTestGapDuration) * index,
        );
        final end = start.add(_salahTestLockDuration);
        return SalahWindow(
          prayer: HomePrayerSlot(id: _testPrayerIdForIndex(index), time: start),
          start: start,
          end: end,
        );
      }, growable: false);
      await FocusEnforcementService.appendDebugLog(
        'focus.salahWindows',
        'testMode=true anchor=${anchor.toIso8601String()} now=${now.toIso8601String()} windows=${windows.map((window) => "${window.prayer.id.name}:${window.start.toIso8601String()}->${window.end.toIso8601String()}").join("|")}',
      );
      return windows;
    }

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
            start: slot.time,
            end: slot.time.add(const Duration(minutes: 15)),
          ),
        )
        .toList(growable: false);
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

  Future<List<Map<String, dynamic>>> _buildScheduledTransitions(
    FocusSettings settings,
    DateTime now,
    Future<List<SalahWindow>> Function() getSalahWindows,
  ) async {
    final windows = settings.salahModeEnabled
        ? await getSalahWindows()
        : const <SalahWindow>[];
    final events = <Map<String, dynamic>>[];

    if (settings.nightDisciplineEnabled) {
      events.addAll(
        _buildNightScheduledTransitions(settings, now, windows),
      );
    }

    if (settings.salahModeEnabled) {
      events.addAll(
        _buildSalahScheduledTransitions(settings, now, windows),
      );
    }

    events.sort(
      (a, b) => DateTime.parse(
        a['at'] as String,
      ).compareTo(DateTime.parse(b['at'] as String)),
    );
    return _dedupeTransitionsByTimestamp(events);
  }

  /// When night and salah overlap, two transitions can share the same instant
  /// (e.g. salah window end and sleep window end). Prefer lock so we never
  /// clear the shield while another mode still requires blocking.
  List<Map<String, dynamic>> _dedupeTransitionsByTimestamp(
    List<Map<String, dynamic>> events,
  ) {
    if (events.length <= 1) return events;
    final out = <Map<String, dynamic>>[];
    var i = 0;
    while (i < events.length) {
      final ms = events[i]['atMillis'] as int;
      var j = i + 1;
      var anyLock = events[i]['isLocked'] as bool;
      while (j < events.length && events[j]['atMillis'] == ms) {
        anyLock = anyLock || (events[j]['isLocked'] as bool);
        j++;
      }
      final pick = anyLock
          ? events.sublist(i, j).firstWhere((e) => e['isLocked'] == true)
          : events[i];
      out.add(Map<String, dynamic>.from(pick));
      i = j;
    }
    return out;
  }

  List<Map<String, dynamic>> _buildNightScheduledTransitions(
    FocusSettings settings,
    DateTime now,
    List<SalahWindow> windows,
  ) {
    final range = settings.nightRange;
    final events = <Map<String, dynamic>>[];
    final window = _nightWindowContainingOrNext(range, now);
    if (window == null) return events;

    final isWithinWindow = range.contains(now);
    if (window.start.isAfter(now)) {
      final snap = _lockStateAtInstant(settings, window.start, windows);
      if (snap.isLocked) {
        events.add(
          _scheduledTransition(
            at: window.start,
            isLocked: true,
            activeMode: snap.activeMode ?? FocusModeType.nightDiscipline,
            reason: snap.reason ?? 'Night Discipline is blocking selected apps.',
            nextChangeAt: snap.nextChangeAt ?? window.end,
          ),
        );
      }
    }

    if (window.end.isAfter(now)) {
      final snap = _lockStateAtInstant(settings, window.end, windows);
      final nextWindow = _nightWindowContainingOrNext(
        range,
        window.end.add(const Duration(seconds: 1)),
      );
      events.add(
        _scheduledTransition(
          at: window.end,
          isLocked: snap.isLocked,
          activeMode: snap.activeMode ?? FocusModeType.nightDiscipline,
          reason: snap.reason ??
              'Night Discipline will start at ${_formatTime(range.startHour, range.startMinute)}.',
          nextChangeAt: snap.nextChangeAt ?? nextWindow?.start,
        ),
      );
    }

    if (isWithinWindow &&
        settings.temporarilyUnlockedUntil != null &&
        settings.temporarilyUnlockedUntil!.isAfter(now) &&
        settings.temporarilyUnlockedUntil!.isBefore(window.end)) {
      final snap = _lockStateAtInstant(
        settings,
        settings.temporarilyUnlockedUntil!,
        windows,
      );
      if (snap.isLocked) {
        events.add(
          _scheduledTransition(
            at: settings.temporarilyUnlockedUntil!,
            isLocked: true,
            activeMode: snap.activeMode ?? FocusModeType.nightDiscipline,
            reason: snap.reason ?? 'Night Discipline is blocking selected apps.',
            nextChangeAt: snap.nextChangeAt ?? window.end,
          ),
        );
      }
    }

    return events;
  }

  List<Map<String, dynamic>> _buildSalahScheduledTransitions(
    FocusSettings settings,
    DateTime now,
    List<SalahWindow> windows,
  ) {
    if (windows.isEmpty) return const <Map<String, dynamic>>[];

    final events = <Map<String, dynamic>>[];
    for (var index = 0; index < windows.length; index++) {
      final window = windows[index];
      final nextWindow = index + 1 < windows.length ? windows[index + 1] : null;

      if (window.start.isAfter(now)) {
        final snap = _lockStateAtInstant(settings, window.start, windows);
        if (snap.isLocked) {
          events.add(
            _scheduledTransition(
              at: window.start,
              isLocked: true,
              activeMode: snap.activeMode ?? FocusModeType.salah,
              reason: snap.reason ??
                  'Salah mode is active for ${_prayerLabel(window.prayer.id)}.',
              nextChangeAt: snap.nextChangeAt ?? window.end,
            ),
          );
        }
      }

      if (window.end.isAfter(now)) {
        final snap = _lockStateAtInstant(settings, window.end, windows);
        events.add(
          _scheduledTransition(
            at: window.end,
            isLocked: snap.isLocked,
            activeMode: snap.activeMode ?? FocusModeType.salah,
            reason: snap.reason ??
                'Salah mode will lock apps around the next prayer.',
            nextChangeAt: snap.nextChangeAt ?? nextWindow?.start,
          ),
        );
      }
    }

    final activeWindow = windows.where((window) {
      return !now.isBefore(window.start) && now.isBefore(window.end);
    }).firstOrNull;
    if (activeWindow != null &&
        settings.temporarilyUnlockedUntil != null &&
        settings.temporarilyUnlockedUntil!.isAfter(now) &&
        settings.temporarilyUnlockedUntil!.isBefore(activeWindow.end)) {
      final snap = _lockStateAtInstant(
        settings,
        settings.temporarilyUnlockedUntil!,
        windows,
      );
      if (snap.isLocked) {
        events.add(
          _scheduledTransition(
            at: settings.temporarilyUnlockedUntil!,
            isLocked: true,
            activeMode: snap.activeMode ?? FocusModeType.salah,
            reason: snap.reason ??
                'Salah mode is active for ${_prayerLabel(activeWindow.prayer.id)}.',
            nextChangeAt: snap.nextChangeAt ?? activeWindow.end,
          ),
        );
      }
    }

    return events;
  }

  ({DateTime start, DateTime end})? _nightWindowContainingOrNext(
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

  Map<String, dynamic> _scheduledTransition({
    required DateTime at,
    required bool isLocked,
    required FocusModeType activeMode,
    required String reason,
    required DateTime? nextChangeAt,
  }) {
    return <String, dynamic>{
      'at': at.toIso8601String(),
      'atMillis': at.millisecondsSinceEpoch,
      'isLocked': isLocked,
      'activeMode': activeMode.name,
      'lockReason': reason,
      'nextChangeAt': nextChangeAt?.toIso8601String(),
      if (nextChangeAt != null)
        'nextChangeAtMillis': nextChangeAt.millisecondsSinceEpoch,
    };
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
