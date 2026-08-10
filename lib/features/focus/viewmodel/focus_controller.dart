import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:intl/intl.dart';

import '../../../core/services/device_apps_service.dart';
import '../../../core/services/app_notification_service.dart';
import '../../../core/services/focus_enforcement_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../l10n/app_localizations.dart';
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

  /// Keep Salah / night native schedules and the [AppNotificationService] prayer
  /// batch on the same rolling horizon (both platforms).
  static const int _rollingScheduleDays = 2;

  static int get _scheduleHorizonDays => _rollingScheduleDays;

  FocusSettings _settings = FocusSettings.defaults();
  FocusLockState _lockState = const FocusLockState.unlocked();
  List<FocusInstalledApp> _installedApps = const <FocusInstalledApp>[];
  bool _isInitialized = false;
  Future<void>? _initializeFuture;
  Future<void>? _refreshFuture;
  bool _isLoadingApps = false;
  Timer? _refreshTimer;
  String? _lastEnforcedScheduleSignature;
  DateTime? _allowNativeNightTempUnlockUntilOnce;

  /// Ensures recomputes never run in parallel (multiple lifecycle observers call
  /// [refresh] on resume, which previously interleaved and flickered lock/unlock UI).
  Future<void> _recomputeSerial = Future<void>.value();

  double? _cachedLatitude;
  double? _cachedLongitude;

  // Salah windows are stable for a full day at a fixed location. Cache them to
  // avoid rerunning prayer-time computation on every _recomputeAndPersist call.
  List<SalahWindow>? _cachedSalahWindows;
  DateTime? _cachedSalahWindowsDate;
  double? _cachedSalahWindowsLat;
  double? _cachedSalahWindowsLng;

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
    if (_initializeFuture != null) {
      await _initializeFuture;
      return;
    }
    _initializeFuture = _initialize();
    await _initializeFuture;
  }

  Future<void> _initialize() async {
    if (_isInitialized) return;
    _isInitialized = true;
    await FocusEnforcementService.appendDebugLog(
      'focus.initialize',
      'initializing controller',
    );
    await _load();
  }

  Future<void> refresh() async {
    if (_refreshFuture != null) {
      await _refreshFuture;
      return;
    }
    _refreshFuture = _refreshBody();
    try {
      await _refreshFuture;
    } finally {
      _refreshFuture = null;
    }
  }

  Future<void> _refreshBody() async {
    // Refresh can be triggered by multiple lifecycle listeners. Ensure any
    // in-flight initialize/load has completed to avoid persisting defaults
    // over previously saved mode settings.
    await initialize();
    await FocusEnforcementService.appendDebugLog(
      'focus.refresh',
      'manual refresh start',
    );
    await _reloadLocation();
    await _recomputeAndPersist();
  }

  /// Refills the prayer reminder batch after a Salah unlock from Home so the
  /// next slots stay scheduled under the rolling horizon (same on iOS and Android).
  Future<void> _maybeRefillPrayerNotificationsAfterSalahHomeUnlock(
    bool hadActiveSalahWindow,
  ) async {
    if (!hadActiveSalahWindow) return;
    final lat = _cachedLatitude;
    final lng = _cachedLongitude;
    if (lat == null || lng == null) return;
    await AppNotificationService.instance.reschedulePrayerNotifications(
      latitude: lat,
      longitude: lng,
      forceReschedule: true,
      daysAheadOverride: _rollingScheduleDays,
    );
  }

  Future<void> requestInstalledApps() async {
    if (_isLoadingApps) return;

    if (Platform.isIOS) {
      _isLoadingApps = true;
      final result = await DeviceAppsService.presentIosFamilyPicker(
        existingSelectionData: _settings.iosSelectionData,
      );
      _isLoadingApps = false;
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
      clearNightDisciplineBeforeChild: selected.isEmpty,
      clearSalahModeBeforeChild: selected.isEmpty,
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
      clearNightDisciplineBeforeChild: selected.isEmpty,
      clearSalahModeBeforeChild: selected.isEmpty,
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
    _invalidateEnforcedScheduleCaches();
    await _persist();
    await _recomputeAndPersist();
  }

  void _invalidateEnforcedScheduleCaches() {
    AppNotificationService.instance.invalidateFocusScheduleCache();
    _lastEnforcedScheduleSignature = null;
  }

  Future<void> enableMode(FocusModeType mode) async {
    if (!_settings.hasSelectedApps) return;
    _invalidateEnforcedScheduleCaches();
    unawaited(
      FocusEnforcementService.appendDebugLog(
        'focus.enableMode',
        'before mode=${mode.name} selected=${_settings.selectedApps.keys.join(",")} childType=${_settings.childLockType.name} tempUnlockUntil=${_settings.temporarilyUnlockedUntil?.toIso8601String()}',
      ),
    );

    _settings = _buildEnabledModeSettings(mode, baseSettings: _settings);
    // Publish immediate switch state first so loader/controls remain responsive.
    notifyListeners();
    await _yieldForUiFrame();
    if (mode == FocusModeType.salah) {
      await _reloadLocation();
    }
    await _recomputeAndPersist();
    unawaited(
      FocusEnforcementService.appendDebugLog(
        'focus.enableMode',
        'after mode=${mode.name} active=${_settings.enabledMode?.name} locked=${_lockState.isLocked} nextChangeAt=${_lockState.nextChangeAt?.toIso8601String()} reason=${_lockState.reason}',
      ),
    );
  }

  FocusSettings _buildEnabledModeSettings(
    FocusModeType mode, {
    required FocusSettings baseSettings,
  }) {
    final childLockedUntil =
        mode == FocusModeType.child &&
            baseSettings.childLockType == ChildLockType.timed
        ? DateTime.now().add(
            Duration(minutes: baseSettings.childLockDurationMinutes),
          )
        : null;
    final now = DateTime.now();
    if (mode == FocusModeType.child) {
      return baseSettings.copyWith(
        childModeEnabled: true,
        nightDisciplineBeforeChild: baseSettings.nightDisciplineEnabled,
        salahModeBeforeChild: baseSettings.salahModeEnabled,
        nightDisciplineEnabled: false,
        salahModeEnabled: false,
        salahTestAnchorAt: _salahTestModeEnabled
            ? (baseSettings.salahTestAnchorAt ?? now)
            : null,
        clearSalahTestAnchorAt: !_salahTestModeEnabled,
        childLockedUntil: childLockedUntil,
        clearChildLockedUntil:
            baseSettings.childLockType == ChildLockType.indefinite,
        clearTemporaryUnlock: true,
      );
    }

    final childWasOn = baseSettings.childModeEnabled;
    final stashedNight = baseSettings.nightDisciplineBeforeChild;
    final stashedSalah = baseSettings.salahModeBeforeChild;

    final bool nextNight;
    final bool nextSalah;
    if (childWasOn) {
      nextNight = mode == FocusModeType.nightDiscipline
          ? true
          : (stashedNight ?? false);
      nextSalah = mode == FocusModeType.salah ? true : (stashedSalah ?? false);
    } else {
      nextNight = mode == FocusModeType.nightDiscipline
          ? true
          : baseSettings.nightDisciplineEnabled;
      nextSalah = mode == FocusModeType.salah
          ? true
          : baseSettings.salahModeEnabled;
    }

    return baseSettings.copyWith(
      childModeEnabled: false,
      clearChildLockedUntil: true,
      nightDisciplineEnabled: nextNight,
      salahModeEnabled: nextSalah,
      salahTestAnchorAt: _salahTestModeEnabled && nextSalah
          ? (baseSettings.salahTestAnchorAt ?? now)
          : null,
      clearSalahTestAnchorAt: !nextSalah || !_salahTestModeEnabled,
      clearTemporaryUnlock: true,
      clearNightDisciplineBeforeChild: childWasOn,
      clearSalahModeBeforeChild: childWasOn,
    );
  }

  Future<void> _yieldForUiFrame() async {
    await SchedulerBinding.instance.endOfFrame;
    await Future<void>.delayed(Duration.zero);
  }

  Future<void> disableMode(FocusModeType mode) async {
    _invalidateEnforcedScheduleCaches();
    unawaited(
      FocusEnforcementService.appendDebugLog(
        'focus.disableMode',
        'before mode=${mode.name} active=${_settings.enabledMode?.name} locked=${_lockState.isLocked}',
      ),
    );
    switch (mode) {
      case FocusModeType.child:
        await _disableChildModeWithUnlockThenRestore();
        unawaited(
          FocusEnforcementService.appendDebugLog(
            'focus.disableMode',
            'after mode=${mode.name} active=${_settings.enabledMode?.name} locked=${_lockState.isLocked}',
          ),
        );
        return;
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
          clearIosSalahShieldLatch: true,
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

  Future<void> _disableChildModeWithUnlockThenRestore() async {
    final restoreNight = _settings.nightDisciplineBeforeChild ?? false;
    final restoreSalah = _settings.salahModeBeforeChild ?? false;
    final now = DateTime.now();

    _settings = _settings.copyWith(
      childModeEnabled: false,
      clearChildLockedUntil: true,
      clearTemporaryUnlock: true,
      nightDisciplineEnabled: false,
      salahModeEnabled: false,
      clearSalahTestAnchorAt: true,
    );
    await _recomputeAndPersist();

    _settings = _settings.copyWith(
      nightDisciplineEnabled: restoreNight,
      salahModeEnabled: restoreSalah,
      salahTestAnchorAt: _salahTestModeEnabled && restoreSalah
          ? (_settings.salahTestAnchorAt ?? now)
          : null,
      clearSalahTestAnchorAt: !restoreSalah || !_salahTestModeEnabled,
      clearNightDisciplineBeforeChild: true,
      clearSalahModeBeforeChild: true,
    );
    await _recomputeAndPersist();
  }

  Future<void> temporarilyUnlock({
    Duration duration = const Duration(minutes: 15),
    bool clearIosSalahShieldLatch = false,
  }) async {
    if (!_lockState.isLocked) return;
    await FocusEnforcementService.appendDebugLog(
      'focus.temporarilyUnlock',
      'duration=${duration.inMinutes} currentMode=${_lockState.activeMode?.name}',
    );
    _settings = _settings.copyWith(
      temporarilyUnlockedUntil: DateTime.now().add(duration),
      clearIosSalahShieldLatch: clearIosSalahShieldLatch,
    );
    await _persist();
    await _recomputeAndPersist();
  }

  Future<void> disableActiveMode() async {
    final mode = _lockState.activeMode;
    if (mode == null) return;
    await disableMode(mode);
  }

  Future<void> disableModesForInactiveSubscription() async {
    await initialize();
    if (!isAnyModeEnabled &&
        _settings.childLockedUntil == null &&
        _settings.temporarilyUnlockedUntil == null &&
        _settings.iosSalahShieldLatchEpochMillis == null &&
        _settings.nightDisciplineBeforeChild != true &&
        _settings.salahModeBeforeChild != true) {
      return;
    }

    _invalidateEnforcedScheduleCaches();
    unawaited(
      FocusEnforcementService.appendDebugLog(
        'focus.subscription.disableModes',
        'subscription inactive active=${_settings.enabledMode?.name} locked=${_lockState.isLocked}',
      ),
    );
    _settings = _settings.copyWith(
      childModeEnabled: false,
      nightDisciplineEnabled: false,
      salahModeEnabled: false,
      clearChildLockedUntil: true,
      clearTemporaryUnlock: true,
      clearIosSalahShieldLatch: true,
      clearSalahTestAnchorAt: true,
      clearNightDisciplineLastEndedAt: true,
      clearNightDisciplineBeforeChild: true,
      clearSalahModeBeforeChild: true,
    );
    await _recomputeAndPersist();
  }

  /// Home "unlock" action: does **not** turn off Salah or Night Discipline — it
  /// only sets [FocusSettings.temporarilyUnlockedUntil] until the end of the
  /// current prayer window and/or current night window so blocking resumes on
  /// the next schedule. Child mode is fully disabled here (parents expect that).
  Future<void> unlockFromHome() async {
    if (!_lockState.isLocked) return;
    final mode = _lockState.activeMode;
    if (mode == FocusModeType.child) {
      await disableActiveMode();
      return;
    }

    final now = DateTime.now();
    final windows = _settings.salahModeEnabled
        ? await _salahWindows(now)
        : const <SalahWindow>[];
    SalahWindow? activeSalahNow;

    if (_settings.salahModeEnabled) {
      activeSalahNow = windows.where((SalahWindow w) {
        return !now.isBefore(w.start) && now.isBefore(w.end);
      }).firstOrNull;
    }
    final hadActiveSalahWindow = activeSalahNow != null;
    final until = _homeTemporaryUnlockBoundary(_settings, now, windows);

    if (until != null && !until.isAfter(now)) {
      _settings = _settings.copyWith(clearIosSalahShieldLatch: true);
      await _recomputeAndPersist();
      await _maybeRefillPrayerNotificationsAfterSalahHomeUnlock(
        hadActiveSalahWindow,
      );
      return;
    }
    if (until == null) {
      await temporarilyUnlock(clearIosSalahShieldLatch: true);
      await _maybeRefillPrayerNotificationsAfterSalahHomeUnlock(
        hadActiveSalahWindow,
      );
      return;
    }

    await FocusEnforcementService.appendDebugLog(
      'focus.unlockFromHome',
      'until=${until.toIso8601String()} mode=${mode?.name}',
    );
    _allowNativeNightTempUnlockUntilOnce = until;
    _settings = _settings.copyWith(
      temporarilyUnlockedUntil: until,
      clearIosSalahShieldLatch: true,
    );
    await _persist();
    await _recomputeAndPersist();
    await _maybeRefillPrayerNotificationsAfterSalahHomeUnlock(
      hadActiveSalahWindow,
    );
  }

  DateTime? _homeTemporaryUnlockBoundary(
    FocusSettings settings,
    DateTime now,
    List<SalahWindow> windows,
  ) {
    DateTime? until;
    if (settings.salahModeEnabled) {
      final nextPrayerStart = _nextSalahStart(windows, now);
      until = nextPrayerStart;

      if (until == null) {
        final activeSalah = _activeSalahReminderAt(now, windows);
        until = activeSalah?.end;
      }
    }

    if (settings.nightDisciplineEnabled) {
      final nightWindow = _nightWindowContainingOrNext(
        settings.nightRange,
        now,
      );
      if (nightWindow != null) {
        final DateTime nightBoundary;
        if (settings.nightRange.contains(now) &&
            !now.isBefore(nightWindow.start)) {
          nightBoundary = nightWindow.end;
        } else {
          nightBoundary = nightWindow.start;
        }
        if (nightBoundary.isAfter(now)) {
          until = _earlierOf(until, nightBoundary);
        }
      }
    }

    return until;
  }

  /// Home action while temporarily unlocked: clear temporary unlock and enforce
  /// the currently active scheduled lock immediately.
  Future<void> relockNowFromHome() async {
    if (!_lockState.isTemporarilyUnlocked) return;
    await FocusEnforcementService.appendDebugLog(
      'focus.relockFromHome',
      'tempUnlockUntil=${_settings.temporarilyUnlockedUntil?.toIso8601String()} activeMode=${_lockState.activeMode?.name}',
    );
    _settings = _settings.copyWith(clearTemporaryUnlock: true);
    await _persist();
    await _recomputeAndPersist();
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

  String modeTitle(FocusModeType mode, AppLocalizations l10n) {
    switch (mode) {
      case FocusModeType.child:
        return l10n.focusChildModeTitle;
      case FocusModeType.nightDiscipline:
        return l10n.focusNightDisciplineTitle;
      case FocusModeType.salah:
        return l10n.focusSalahFocusModeTitle;
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
            : 'Lock selected apps during prayer until you unlock from the home screen.';
    }
  }

  String homeCardTitle(AppLocalizations l10n) {
    if (_lockState.isLocked) return l10n.homeAppsLocked;
    if (isAnyModeEnabled) return l10n.focusModeActivated;
    return l10n.focusSetUpHomeCardTitle;
  }

  String homeCardSubtitle(AppLocalizations l10n) {
    if (_lockState.isLocked) {
      if (_isStaleChildLockReason) {
        if (_settings.nightDisciplineEnabled && _settings.salahModeEnabled) {
          return l10n.focusHomeBlockingNightAndSalah;
        }
        if (_settings.nightDisciplineEnabled) {
          return l10n.focusHomeBlockingNight;
        }
        if (_settings.salahModeEnabled) {
          return l10n.focusHomeBlockingSalah;
        }
      }
      return _lockState.reason ?? l10n.focusHomeAppsBlockedNow;
    }
    if (isAnyModeEnabled) {
      if (_settings.childModeEnabled) {
        return l10n.focusHomeModeEnabled(modeTitle(FocusModeType.child, l10n));
      }
      final parts = <String>[];
      if (_settings.nightDisciplineEnabled) {
        parts.add(modeTitle(FocusModeType.nightDiscipline, l10n));
      }
      if (_settings.salahModeEnabled) {
        parts.add(modeTitle(FocusModeType.salah, l10n));
      }
      if (parts.isEmpty) {
        return l10n.focusHomeChooseMode;
      }
      if (parts.length == 1) {
        return l10n.focusHomeModeEnabled(parts.first);
      }
      return l10n.focusHomeModesEnabled(parts.join(' · '));
    }
    return l10n.focusChooseAppsEnableMode;
  }

  String statusCaption(AppLocalizations l10n) {
    if (!_settings.hasSelectedApps) return l10n.focusStatusSelectApps;
    if (_lockState.isLocked) {
      if (_isStaleChildLockReason) {
        if (_settings.nightDisciplineEnabled && _settings.salahModeEnabled) {
          return l10n.focusStatusBlockingNightAndSalah;
        }
        if (_settings.nightDisciplineEnabled) {
          return l10n.focusStatusBlockingNight;
        }
        if (_settings.salahModeEnabled) {
          return l10n.focusStatusBlockingSalah;
        }
      }
      return _lockState.reason ?? l10n.focusStatusAppsLocked;
    }
    if (isTemporarilyUnlocked && _settings.temporarilyUnlockedUntil != null) {
      return l10n.focusStatusUnlockedUntil(
        DateFormat.jm().format(_settings.temporarilyUnlockedUntil!),
      );
    }
    if (!isAnyModeEnabled) return l10n.focusStatusNoMode;
    return l10n.focusStatusReadyToLock(selectedTargetPhrase);
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
      // Avoid expensive PackageManager + icon decode work during launch.
      unawaited(_warmInstalledAppsCacheDeferred());
    }
    notifyListeners();
    await _recomputeAndPersist();
  }

  bool get _isStaleChildLockReason {
    final reason = _lockState.reason ?? '';
    return !_settings.childModeEnabled && reason.startsWith('Child mode');
  }

  Future<void> _warmInstalledAppsCacheDeferred() async {
    await Future<void>.delayed(const Duration(seconds: 3));
    final apps = await DeviceAppsService.getInstalledApps(includeIcons: false);
    if (apps.isEmpty) return;
    _installedApps = apps;
    notifyListeners();
  }

  Future<void> _reloadLocation() async {
    // Invalidate salah window cache whenever location is refreshed — new
    // coordinates produce different prayer times.
    _cachedSalahWindows = null;
    _cachedSalahWindowsDate = null;
    _cachedSalahWindowsLat = null;
    _cachedSalahWindowsLng = null;
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
    final prevLocked = _lockState.isLocked;
    final prevMode = _lockState.activeMode;
    final prevReason = _lockState.reason;
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

    var work = await _importNativeIosSalahLatch(
      updatedSettings,
      recomputeNow,
      salahWindowsOnce,
    );
    work = _normalizeNightEndPauseState(
      work,
      recomputeNow,
      await salahWindowsOnce(),
    );
    work = _normalizeTemporaryUnlockBoundary(
      work,
      recomputeNow,
      await salahWindowsOnce(),
    );
    FocusLockState updatedLockState;
    var latchIter = 0;
    while (true) {
      updatedLockState = await _computeLockState(
        work,
        recomputeNow,
        salahWindowsOnce,
      );
      final windowsList = await salahWindowsOnce();
      final merged = _mergeIosSalahShieldLatch(
        settings: work,
        lockState: updatedLockState,
        now: recomputeNow,
        windows: windowsList,
      );
      if (merged.iosSalahShieldLatchEpochMillis ==
          work.iosSalahShieldLatchEpochMillis) {
        work = merged;
        break;
      }
      work = merged;
      if (++latchIter > 8) {
        updatedLockState = await _computeLockState(
          work,
          recomputeNow,
          salahWindowsOnce,
        );
        break;
      }
    }

    final scheduledTransitions = await _buildScheduledTransitions(
      work,
      recomputeNow,
      salahWindowsOnce,
    );
    _settings = work;
    _lockState = updatedLockState;
    if (prevLocked != _lockState.isLocked ||
        prevMode != _lockState.activeMode ||
        prevReason != _lockState.reason) {
      unawaited(
        FocusEnforcementService.appendDebugLog(
          'focus.lockTransition',
          'locked=$prevLocked->${_lockState.isLocked} mode=$prevMode->${_lockState.activeMode} reason=$prevReason->${_lockState.reason} nextChangeAt=${_lockState.nextChangeAt?.toIso8601String()}',
        ),
      );
    }
    await Future.wait<void>([
      _persist(),
      StorageService.setFocusScheduleJson(jsonEncode(scheduledTransitions)),
    ]);
    notifyListeners();
    // Native sync always runs so lock state / temp-unlock stay aligned with the OS.
    // Focus notifications skip cancel+reschedule internally when the signature is unchanged.
    await _syncNativeFocusEnforcement(
      scheduledTransitions,
      await salahWindowsOnce(),
    );
    final scheduleSignature = await AppNotificationService.instance
        .buildFocusScheduleSignature(
          settings: work,
          scheduledTransitions: scheduledTransitions,
        );
    if (scheduleSignature != _lastEnforcedScheduleSignature) {
      _lastEnforcedScheduleSignature = scheduleSignature;
      await _syncFocusNotifications(scheduledTransitions);
    } else {
      unawaited(
        FocusEnforcementService.appendDebugLog(
          'focus.schedule.sync',
          'skipped focus notification reschedule (signature unchanged)',
        ),
      );
    }
    unawaited(
      FocusEnforcementService.appendDebugLog(
        'focus.recompute',
        'done mode=${_lockState.activeMode?.name} locked=${_lockState.isLocked} nextChangeAt=${_lockState.nextChangeAt?.toIso8601String()} transitions=${scheduledTransitions.length} reason=${_lockState.reason}',
      ),
    );
    _scheduleNextRefresh();
  }

  Future<void> _syncNativeFocusEnforcement(
    List<Map<String, dynamic>> scheduledTransitions,
    List<SalahWindow> salahWindows,
  ) async {
    try {
      final now = DateTime.now();
      final salahPausedUntil =
          _salahLockPausedAfterNightEnd(_settings, now, salahWindows)
          ? _lockState.nextChangeAt
          : null;
      await FocusEnforcementService.sync(
        settings: _settings,
        lockState: _lockState,
        scheduledTransitions: scheduledTransitions,
        salahPausedUntil: salahPausedUntil,
      );
    } catch (e, st) {
      assert(() {
        debugPrint('focus: native sync failed: $e\n$st');
        return true;
      }());
    }
  }

  Future<void> _syncFocusNotifications(
    List<Map<String, dynamic>> scheduledTransitions,
  ) async {
    try {
      await AppNotificationService.instance.syncFocusNotifications(
        settings: _settings,
        scheduledTransitions: scheduledTransitions,
      );
    } catch (e, st) {
      assert(() {
        debugPrint('focus: syncFocusNotifications failed: $e\n$st');
        return true;
      }());
    }
  }

  FocusSettings _applyChildModeExit(FocusSettings s) {
    final night = s.nightDisciplineBeforeChild ?? false;
    final salah = s.salahModeBeforeChild ?? false;
    final now = DateTime.now();
    return s.copyWith(
      childModeEnabled: false,
      clearChildLockedUntil: true,
      clearTemporaryUnlock: true,
      nightDisciplineEnabled: night,
      salahModeEnabled: salah,
      salahTestAnchorAt: _salahTestModeEnabled && salah
          ? (s.salahTestAnchorAt ?? now)
          : null,
      clearSalahTestAnchorAt: !salah || !_salahTestModeEnabled,
      clearNightDisciplineBeforeChild: true,
      clearSalahModeBeforeChild: true,
    );
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
      return _stripIosSalahLatchIfSalahDisabled(_applyChildModeExit(s));
    }

    if (s.temporarilyUnlockedUntil != null &&
        !s.temporarilyUnlockedUntil!.isAfter(now)) {
      s = s.copyWith(clearTemporaryUnlock: true);
    }

    return _stripIosSalahLatchIfSalahDisabled(s);
  }

  FocusSettings _normalizeTemporaryUnlockBoundary(
    FocusSettings settings,
    DateTime now,
    List<SalahWindow> windows,
  ) {
    final current = settings.temporarilyUnlockedUntil;
    if (settings.childModeEnabled || current == null || !current.isAfter(now)) {
      return settings;
    }
    final boundary = _homeTemporaryUnlockBoundary(settings, now, windows);
    if (boundary == null) return settings;
    if (!boundary.isAfter(now)) {
      return settings.copyWith(clearTemporaryUnlock: true);
    }
    if (boundary.isAtSameMomentAs(current)) return settings;

    unawaited(
      FocusEnforcementService.appendDebugLog(
        'focus.tempUnlock.adjust',
        'from=${current.toIso8601String()} to=${boundary.toIso8601String()}',
      ),
    );
    return settings.copyWith(temporarilyUnlockedUntil: boundary);
  }

  FocusSettings _stripIosSalahLatchIfSalahDisabled(FocusSettings s) {
    if (!s.salahModeEnabled && s.iosSalahShieldLatchEpochMillis != null) {
      return s.copyWith(clearIosSalahShieldLatch: true);
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
    SalahWindow? activeSalahReminder;
    if (settings.salahModeEnabled) {
      activeSalahReminder = windows.where((window) {
        return !at.isBefore(window.start) && at.isBefore(window.end);
      }).firstOrNull;
    }
    final salahPausedAfterNightEnd = _salahLockPausedAfterNightEnd(
      settings,
      at,
      windows,
    );
    final latchMs = settings.iosSalahShieldLatchEpochMillis;
    final salahLatchLocks =
        !salahPausedAfterNightEnd &&
        latchMs != null &&
        _iosSalahLatchStillCoversMoment(at, latchMs, windows);

    final salahLocked =
        salahLatchLocks ||
        (activeSalahReminder != null && !salahPausedAfterNightEnd);

    SalahWindow? activeSalahForLabel;
    if (activeSalahReminder != null) {
      activeSalahForLabel = activeSalahReminder;
    } else if (salahLatchLocks) {
      activeSalahForLabel = _salahWindowMatchingStartMillis(latchMs, windows);
    }

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
      displayMode = _overlapDisplayMode(
        at: at,
        settings: settings,
        activeSalahReminder: activeSalahReminder,
      );
      reason = displayMode == FocusModeType.nightDiscipline
          ? 'Night Discipline is blocking selected apps.'
          : 'Night Discipline and Salah mode are blocking selected apps.';
    } else if (salahLocked) {
      displayMode = FocusModeType.salah;
      final prayerId = activeSalahForLabel?.prayer.id;
      reason = prayerId == null
          ? 'Salah mode is blocking selected apps.'
          : 'Salah mode is active for ${_prayerLabel(prayerId)}.';
    } else {
      displayMode = FocusModeType.nightDiscipline;
      reason = 'Night Discipline is blocking selected apps.';
    }

    DateTime? nextChangeAt = tempUnlocked
        ? settings.temporarilyUnlockedUntil
        : null;
    if (salahLocked) {
      DateTime? salahBoundary;
      if (activeSalahReminder != null) {
        salahBoundary = activeSalahReminder.end;
      } else if (salahLatchLocks && activeSalahForLabel != null) {
        salahBoundary = _firstSalahStartStrictlyAfter(
          activeSalahForLabel.start,
          windows,
        );
      }
      nextChangeAt = _earlierOf(nextChangeAt, salahBoundary);
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

  /// When Salah and Night overlap, Night UI wins if night began during the active
  /// prayer window; Salah UI wins if prayer started during an active night window.
  FocusModeType _overlapDisplayMode({
    required DateTime at,
    required FocusSettings settings,
    required SalahWindow? activeSalahReminder,
  }) {
    final nightWin = _nightWindowContainingOrNext(settings.nightRange, at);
    if (nightWin == null) return FocusModeType.salah;
    if (activeSalahReminder == null) {
      return FocusModeType.nightDiscipline;
    }
    if (nightWin.start.isAfter(activeSalahReminder.start)) {
      return FocusModeType.nightDiscipline;
    }
    return FocusModeType.salah;
  }

  bool _wouldNightLockAt(FocusSettings settings, DateTime at) {
    return settings.nightDisciplineEnabled && settings.nightRange.contains(at);
  }

  /// Most recent night end used for post-night Salah pause (survives schedule edits).
  DateTime? _nightEndAtForPauseLogic(FocusSettings settings, DateTime at) {
    final persisted = settings.nightDisciplineLastEndedAt;
    if (persisted != null && at.isAfter(persisted)) {
      return persisted;
    }
    return _endedNightWindowForPauseLogic(settings.nightRange, at)?.end;
  }

  /// After night ends inside an active Salah window, stay unlocked until the
  /// next prayer starts (night takes precedence for unlock; Salah re-locks then).
  bool _salahLockPausedAfterNightEnd(
    FocusSettings settings,
    DateTime at,
    List<SalahWindow> windows,
  ) {
    if (!settings.nightDisciplineEnabled || !settings.salahModeEnabled) {
      return false;
    }
    if (settings.nightRange.contains(at)) return false;

    final nightEndAt = _nightEndAtForPauseLogic(settings, at);
    if (nightEndAt == null || !at.isAfter(nightEndAt)) return false;

    final nightEndedDuringSalah = windows.any(
      (w) => !nightEndAt.isBefore(w.start) && nightEndAt.isBefore(w.end),
    );
    if (!nightEndedDuringSalah) return false;

    final nextPrayer = _nextSalahStart(windows, nightEndAt);
    return nextPrayer != null && at.isBefore(nextPrayer);
  }

  /// Records when night last ended, clears stale pause markers, and drops Salah
  /// latch while the post-night pause is active.
  FocusSettings _normalizeNightEndPauseState(
    FocusSettings settings,
    DateTime now,
    List<SalahWindow> windows,
  ) {
    if (!settings.nightDisciplineEnabled || !settings.salahModeEnabled) {
      if (settings.nightDisciplineLastEndedAt != null) {
        return settings.copyWith(clearNightDisciplineLastEndedAt: true);
      }
      return settings;
    }

    var work = settings;
    final lastEnd = work.nightDisciplineLastEndedAt;
    if (lastEnd != null) {
      if (work.nightRange.contains(now)) {
        return work.copyWith(clearNightDisciplineLastEndedAt: true);
      }
      final nextPrayer = _nextSalahStart(windows, lastEnd);
      if (nextPrayer != null && !now.isBefore(nextPrayer)) {
        return work.copyWith(clearNightDisciplineLastEndedAt: true);
      }
    }

    final derivedWin = _endedNightWindowForPauseLogic(work.nightRange, now);
    if (derivedWin != null) {
      if (work.nightDisciplineLastEndedAt == null ||
          derivedWin.end.isAfter(work.nightDisciplineLastEndedAt!)) {
        work = work.copyWith(nightDisciplineLastEndedAt: derivedWin.end);
      }
    }

    if (_salahLockPausedAfterNightEnd(work, now, windows) &&
        work.iosSalahShieldLatchEpochMillis != null) {
      unawaited(
        FocusEnforcementService.appendDebugLog(
          'focus.latch.clearAfterNight',
          'nightEnd=${_nightEndAtForPauseLogic(work, now)?.toIso8601String()} '
              'now=${now.toIso8601String()}',
        ),
      );
      work = work.copyWith(clearIosSalahShieldLatch: true);
    }

    return work;
  }

  bool _iosSalahLatchStillCoversMoment(
    DateTime at,
    int latchEpochMs,
    List<SalahWindow> windows,
  ) {
    SalahWindow? matched;
    for (final window in windows) {
      if (window.start.millisecondsSinceEpoch == latchEpochMs) {
        matched = window;
        break;
      }
    }
    if (matched == null) return false;
    if (at.isBefore(matched.start)) return false;
    final nextStart = _firstSalahStartStrictlyAfter(matched.start, windows);
    if (nextStart != null && !at.isBefore(nextStart)) return false;
    return true;
  }

  DateTime? _firstSalahStartStrictlyAfter(
    DateTime start,
    List<SalahWindow> windows,
  ) {
    DateTime? best;
    for (final window in windows) {
      if (!window.start.isAfter(start)) continue;
      if (best == null || window.start.isBefore(best)) {
        best = window.start;
      }
    }
    return best;
  }

  SalahWindow? _salahWindowMatchingStartMillis(
    int latchEpochMs,
    List<SalahWindow> windows,
  ) {
    for (final window in windows) {
      if (window.start.millisecondsSinceEpoch == latchEpochMs) {
        return window;
      }
    }
    return null;
  }

  SalahWindow? _activeSalahReminderAt(DateTime at, List<SalahWindow> windows) {
    for (final window in windows) {
      if (!at.isBefore(window.start) && at.isBefore(window.end)) {
        return window;
      }
    }
    return null;
  }

  /// Adopts native DeviceActivity state written while the app was suspended, so
  /// recompute does not clear a native night lock or Salah latch on foreground.
  Future<FocusSettings> _importNativeIosSalahLatch(
    FocusSettings settings,
    DateTime now,
    Future<List<SalahWindow>> Function() getSalahWindows,
  ) async {
    if (!Platform.isIOS && !Platform.isAndroid) {
      return settings;
    }

    final bridge = await FocusEnforcementService.readIosFocusBridgeState();
    if (bridge == null) return settings;

    var work = settings;
    if (bridge.nativeShieldLocked &&
        bridge.shieldActiveMode == FocusModeType.nightDiscipline.name &&
        work.nightDisciplineEnabled &&
        work.nightRange.contains(now) &&
        work.temporarilyUnlockedUntil != null &&
        work.temporarilyUnlockedUntil!.isAfter(now)) {
      final allowedUntil = _allowNativeNightTempUnlockUntilOnce;
      if (allowedUntil == work.temporarilyUnlockedUntil) {
        _allowNativeNightTempUnlockUntilOnce = null;
        unawaited(
          FocusEnforcementService.appendDebugLog(
            'focus.tempUnlock.allowForNight',
            'nativeLocked=true mode=${bridge.shieldActiveMode} '
                'tempUnlock=${work.temporarilyUnlockedUntil!.toIso8601String()}',
          ),
        );
      } else {
        unawaited(
          FocusEnforcementService.appendDebugLog(
            'focus.tempUnlock.clearForNight',
            'nativeLocked=true mode=${bridge.shieldActiveMode} '
                'tempUnlock=${work.temporarilyUnlockedUntil!.toIso8601String()}',
          ),
        );
        work = work.copyWith(clearTemporaryUnlock: true);
      }
    }

    if (!work.salahModeEnabled) {
      return work;
    }

    final nightEndMs = bridge.nightDisciplineLastEndedEpochMs;
    if (nightEndMs != null && nightEndMs > 0) {
      final nativeEnd = DateTime.fromMillisecondsSinceEpoch(nightEndMs);
      if (work.nightDisciplineLastEndedAt == null ||
          nativeEnd.isAfter(work.nightDisciplineLastEndedAt!)) {
        work = work.copyWith(nightDisciplineLastEndedAt: nativeEnd);
      }
    }

    final windows = await getSalahWindows();
    work = _normalizeNightEndPauseState(work, now, windows);
    if (_salahLockPausedAfterNightEnd(work, now, windows)) {
      return work;
    }

    var latch = work.iosSalahShieldLatchEpochMillis;
    final nativeLatch = bridge.salahLatchEpochMs;
    if (nativeLatch != null && nativeLatch > 0) {
      latch = nativeLatch;
      if (work.iosSalahShieldLatchEpochMillis != latch) {
        unawaited(
          FocusEnforcementService.appendDebugLog(
            'focus.latch.import',
            'native=$nativeLatch persisted=${work.iosSalahShieldLatchEpochMillis} '
                'nativeLocked=${bridge.nativeShieldLocked} mode=${bridge.shieldActiveMode}',
          ),
        );
      }
    }

    if (latch == null) return work;

    if (!_iosSalahLatchStillCoversMoment(now, latch, windows)) {
      unawaited(
        FocusEnforcementService.appendDebugLog(
          'focus.latch.expired',
          'clearing stale latch=$latch',
        ),
      );
      return work.copyWith(clearIosSalahShieldLatch: true);
    }

    if (work.iosSalahShieldLatchEpochMillis == latch) {
      return work;
    }
    return work.copyWith(iosSalahShieldLatchEpochMillis: latch);
  }

  FocusSettings _mergeIosSalahShieldLatch({
    required FocusSettings settings,
    required FocusLockState lockState,
    required DateTime now,
    required List<SalahWindow> windows,
  }) {
    if (!settings.salahModeEnabled) {
      if (settings.iosSalahShieldLatchEpochMillis != null) {
        return settings.copyWith(clearIosSalahShieldLatch: true);
      }
      return settings;
    }

    var nextLatch = settings.iosSalahShieldLatchEpochMillis;
    final latchStill =
        nextLatch != null &&
        _iosSalahLatchStillCoversMoment(now, nextLatch, windows);

    if (!latchStill) {
      nextLatch = null;
    }

    final reminder = _activeSalahReminderAt(now, windows);
    final tempActive = _isTemporaryUnlockActiveAt(settings, now);
    final pausedAfterNight = _salahLockPausedAfterNightEnd(
      settings,
      now,
      windows,
    );
    if (reminder != null &&
        lockState.isLocked &&
        lockState.activeMode == FocusModeType.salah &&
        !tempActive &&
        !pausedAfterNight) {
      nextLatch = reminder.start.millisecondsSinceEpoch;
    }

    if (settings.iosSalahShieldLatchEpochMillis == nextLatch) {
      return settings;
    }
    if (nextLatch == null) {
      return settings.iosSalahShieldLatchEpochMillis == null
          ? settings
          : settings.copyWith(clearIosSalahShieldLatch: true);
    }
    return settings.copyWith(iosSalahShieldLatchEpochMillis: nextLatch);
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
      // Same as [_nightWindowContainingOrNext]: after midnight, before wake, the
      // next boundary is wake (previousEnd), not tonight's sleep start.
      final previousStart = todayStart.subtract(const Duration(days: 1));
      final previousEnd = todayEnd.subtract(const Duration(days: 1));
      if (!now.isBefore(previousStart) && now.isBefore(previousEnd)) {
        return previousEnd;
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

    // Return cached result when the date and location match — prayer times are
    // stable for the full day and the same coordinates.
    final today = DateTime(now.year, now.month, now.day);
    if (_cachedSalahWindows != null &&
        _cachedSalahWindowsDate == today &&
        _cachedSalahWindowsLat == _cachedLatitude &&
        _cachedSalahWindowsLng == _cachedLongitude) {
      return _cachedSalahWindows!;
    }

    final prayers = <HomePrayerSlot>[];
    final startDate = today;
    final sect = await StorageService.sect;
    for (var offset = 0; offset < _scheduleHorizonDays; offset++) {
      final data = await HomePrayerTimesHelper.generatePrayerTimesForDate(
        latitude: _cachedLatitude!,
        longitude: _cachedLongitude!,
        date: startDate.add(Duration(days: offset)),
        sectRaw: sect,
      );
      prayers.addAll(
        data.slots.where((slot) => slot.id != HomePrayerId.sunrise),
      );
    }

    prayers.sort((a, b) => a.time.compareTo(b.time));
    final windows = List<SalahWindow>.generate(prayers.length, (index) {
      final slot = prayers[index];
      final nextStart = index + 1 < prayers.length
          ? prayers[index + 1].time
          : slot.time.add(const Duration(hours: 24));
      return SalahWindow(prayer: slot, start: slot.time, end: nextStart);
    }, growable: false);

    _cachedSalahWindows = windows;
    _cachedSalahWindowsDate = today;
    _cachedSalahWindowsLat = _cachedLatitude;
    _cachedSalahWindowsLng = _cachedLongitude;
    return windows;
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
      events.addAll(_buildNightScheduledTransitions(settings, now, windows));
    }

    if (settings.salahModeEnabled) {
      events.addAll(_buildSalahScheduledTransitions(settings, now, windows));
    }

    if (settings.childModeEnabled &&
        settings.childLockType == ChildLockType.timed &&
        settings.childLockedUntil != null &&
        settings.childLockedUntil!.isAfter(now)) {
      events.add(
        _scheduledTransition(
          at: settings.childLockedUntil!,
          isLocked: false,
          activeMode: FocusModeType.child,
          reason: 'Child mode duration ended.',
          nextChangeAt: null,
        ),
      );
    }

    events.sort(
      (a, b) => DateTime.parse(
        a['at'] as String,
      ).compareTo(DateTime.parse(b['at'] as String)),
    );
    return _dedupeTransitionsByTimestamp(events);
  }

  /// When night and salah overlap, transitions can share the same instant.
  /// Wake-time [nightMorning] events stay visible when Night and Salah share a
  /// transition instant.
  List<Map<String, dynamic>> _dedupeTransitionsByTimestamp(
    List<Map<String, dynamic>> events,
  ) {
    if (events.length <= 1) return events;
    final out = <Map<String, dynamic>>[];
    var i = 0;
    while (i < events.length) {
      final ms = events[i]['atMillis'] as int;
      var j = i + 1;
      while (j < events.length && events[j]['atMillis'] == ms) {
        j++;
      }
      final group = events.sublist(i, j);
      final nightMorning = group
          .where((e) => e['notificationHint'] == 'nightMorning')
          .toList();
      if (nightMorning.isNotEmpty) {
        out.add(Map<String, dynamic>.from(nightMorning.first));
        i = j;
        continue;
      }
      group.sort((a, b) {
        final aHint = a['notificationHint'] as String?;
        final bHint = b['notificationHint'] as String?;
        if (aHint == 'nightLock' && bHint != 'nightLock') return -1;
        if (bHint == 'nightLock' && aHint != 'nightLock') return 1;
        final aLocked = a['isLocked'] == true ? 0 : 1;
        final bLocked = b['isLocked'] == true ? 0 : 1;
        if (aLocked != bLocked) return aLocked.compareTo(bLocked);
        final aSetsSalahLatch = a['setsSalahShieldLatch'] == true ? 0 : 1;
        final bSetsSalahLatch = b['setsSalahShieldLatch'] == true ? 0 : 1;
        if (aSetsSalahLatch != bSetsSalahLatch) {
          return aSetsSalahLatch.compareTo(bSetsSalahLatch);
        }
        final aMode = a['activeMode'] as String?;
        final bMode = b['activeMode'] as String?;
        final aPriority = aMode == FocusModeType.nightDiscipline.name ? 0 : 1;
        final bPriority = bMode == FocusModeType.nightDiscipline.name ? 0 : 1;
        return aPriority.compareTo(bPriority);
      });
      final chosen = Map<String, dynamic>.from(group.first);
      out.add(chosen);
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
    var probe = now;
    for (var count = 0; count < _scheduleHorizonDays; count++) {
      final window = _nightWindowContainingOrNext(range, probe);
      if (window == null) break;

      if (window.start.isAfter(now) &&
          _wouldNightLockAt(settings, window.start)) {
        final snap = _lockStateAtInstant(settings, window.start, windows);
        final nightStartsDuringSalah =
            settings.salahModeEnabled &&
            windows.any(
              (w) =>
                  !window.start.isBefore(w.start) &&
                  window.start.isBefore(w.end),
            );
        // Daytime windows (e.g. 15:47–15:51) never use the repeating overnight
        // DeviceActivity monitor; always register a native one-shot night lock.
        final isDaytimeNightWindow =
            range.startTotalMinutes < range.endTotalMinutes;
        events.add(
          _scheduledTransition(
            at: window.start,
            isLocked: true,
            activeMode: FocusModeType.nightDiscipline,
            reason: 'Night Discipline is blocking selected apps.',
            nextChangeAt: snap.nextChangeAt ?? window.end,
            notificationHint: 'nightLock',
            forceNativeNightLock:
                isDaytimeNightWindow || nightStartsDuringSalah,
          ),
        );
      }

      if (window.end.isAfter(now)) {
        final nextWindow = _nightWindowContainingOrNext(
          range,
          window.end.add(const Duration(seconds: 1)),
        );
        final nextSalah = settings.salahModeEnabled
            ? _nextSalahStart(windows, window.end)
            : null;
        // Night always ends with unlock (including when Salah is active); the
        // next prayer start transition re-locks.
        events.add(
          _scheduledTransition(
            at: window.end,
            isLocked: false,
            activeMode: FocusModeType.nightDiscipline,
            reason:
                'Night Discipline has ended. Apps are available until the next scheduled focus time.',
            nextChangeAt: nextSalah ?? nextWindow?.start,
            notificationHint: 'nightMorning',
            clearIosSalahShieldLatch: true,
          ),
        );
      }

      probe = window.end.add(const Duration(seconds: 1));
    }

    final currentWindow = _nightWindowContainingOrNext(range, now);
    if (currentWindow != null &&
        range.contains(now) &&
        settings.temporarilyUnlockedUntil != null &&
        settings.temporarilyUnlockedUntil!.isAfter(now) &&
        settings.temporarilyUnlockedUntil!.isBefore(currentWindow.end)) {
      final relockAt = settings.temporarilyUnlockedUntil!;
      final snap = _lockStateAtInstant(settings, relockAt, windows);
      if (_wouldNightLockAt(settings, relockAt) &&
          snap.isLocked &&
          snap.activeMode == FocusModeType.nightDiscipline) {
        events.add(
          _scheduledTransition(
            at: relockAt,
            isLocked: true,
            activeMode: FocusModeType.nightDiscipline,
            reason: 'Night Discipline is blocking selected apps.',
            nextChangeAt: snap.nextChangeAt ?? currentWindow.end,
            notificationHint: 'nightResumeSilent',
            forceNativeNightLock: true,
          ),
        );
        unawaited(
          FocusEnforcementService.appendDebugLog(
            'focus.schedule.nightTempRelock',
            'at=${relockAt.toIso8601String()} '
                'activeMode=${FocusModeType.nightDiscipline.name} '
                'notificationHint=nightResumeSilent forceNativeNightLock=true '
                'nightWinEnd=${currentWindow.end.toIso8601String()}',
          ),
        );
      } else {
        unawaited(
          FocusEnforcementService.appendDebugLog(
            'focus.schedule.nightTempRelock.skip',
            'at=${relockAt.toIso8601String()} '
                'snapLocked=${snap.isLocked} snapMode=${snap.activeMode?.name} '
                'nightWinEnd=${currentWindow.end.toIso8601String()}',
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
              reason:
                  snap.reason ??
                  'Salah mode is active for ${_prayerLabel(window.prayer.id)}.',
              nextChangeAt: snap.nextChangeAt ?? window.end,
              prayerId: window.prayer.id.name,
              setsSalahShieldLatch: true,
            ),
          );
        }
      }

      // Past window ends are omitted so native replay matches Flutter; Salah
      // shield latch (iOS + Android) keeps lock state correct without scheduling
      // prayer-window auto-unlock edges.
      final shouldEmitSalahEnd = window.end.isAfter(now);
      if (shouldEmitSalahEnd) {
        final snap = _lockStateAtInstant(settings, window.end, windows);
        String? nightHint;
        var forceNativeNightLock = false;
        if (snap.isLocked &&
            snap.activeMode == FocusModeType.nightDiscipline &&
            settings.nightDisciplineEnabled &&
            settings.nightRange.contains(window.end)) {
          final nw = _nightWindowContainingOrNext(
            settings.nightRange,
            window.end,
          );
          if (nw != null &&
              !window.end.isBefore(nw.start) &&
              window.end.isBefore(nw.end)) {
            // Case 1 (night already on): resume night lock quietly — no second
            // night notification. Case 2 (night began during this Salah window):
            // treat as the real Night Focus entry — nightLock copy + notification.
            nightHint = nw.start.isBefore(window.start)
                ? 'nightResumeSilent'
                : 'nightLock';
            forceNativeNightLock = true;
            unawaited(
              FocusEnforcementService.appendDebugLog(
                'focus.schedule.salahEndNight',
                'prayer=${window.prayer.id.name} '
                    'salahStart=${window.start.toIso8601String()} '
                    'salahEnd=${window.end.toIso8601String()} '
                    'nightWinStart=${nw.start.toIso8601String()} '
                    'nightWinEnd=${nw.end.toIso8601String()} '
                    'notificationHint=$nightHint '
                    'forceNativeNightLock=true '
                    'nightStartedBeforeSalah=${nw.start.isBefore(window.start)}',
              ),
            );
          }
        }
        final omitSalahWindowEndAutoUnlock =
            !snap.isLocked && nightHint == null && !forceNativeNightLock;
        if (!omitSalahWindowEndAutoUnlock) {
          events.add(
            _scheduledTransition(
              at: window.end,
              isLocked: snap.isLocked,
              activeMode: snap.activeMode ?? FocusModeType.salah,
              reason:
                  snap.reason ??
                  'Salah mode will lock apps around the next prayer.',
              nextChangeAt: snap.nextChangeAt ?? nextWindow?.start,
              prayerId: window.prayer.id.name,
              notificationHint: nightHint,
              forceNativeNightLock: forceNativeNightLock,
            ),
          );
        }
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
        final mode = snap.activeMode ?? FocusModeType.salah;
        final forceNative = mode == FocusModeType.nightDiscipline;
        events.add(
          _scheduledTransition(
            at: settings.temporarilyUnlockedUntil!,
            isLocked: true,
            activeMode: mode,
            reason:
                snap.reason ??
                'Salah mode is active for ${_prayerLabel(activeWindow.prayer.id)}.',
            nextChangeAt: snap.nextChangeAt ?? activeWindow.end,
            prayerId: activeWindow.prayer.id.name,
            forceNativeNightLock: forceNative,
          ),
        );
        unawaited(
          FocusEnforcementService.appendDebugLog(
            'focus.schedule.salahTempRelock',
            'at=${settings.temporarilyUnlockedUntil!.toIso8601String()} '
                'prayer=${activeWindow.prayer.id.name} '
                'activeMode=${mode.name} forceNativeNightLock=$forceNative '
                'salahWinEnd=${activeWindow.end.toIso8601String()}',
          ),
        );
      }
    }

    return events;
  }

  /// Night window that most recently ended before [at] (today or yesterday).
  /// Used so post-night Salah pause works right after short daytime windows.
  ({DateTime start, DateTime end})? _endedNightWindowForPauseLogic(
    FocusTimeRange range,
    DateTime at,
  ) {
    for (var dayOffset = 0; dayOffset <= 1; dayOffset++) {
      final day = DateTime(
        at.year,
        at.month,
        at.day,
      ).subtract(Duration(days: dayOffset));
      final win = _nightWindowOnCalendarDay(range, day);
      if (win != null && at.isAfter(win.end)) {
        return win;
      }
    }
    return null;
  }

  ({DateTime start, DateTime end})? _nightWindowOnCalendarDay(
    FocusTimeRange range,
    DateTime day,
  ) {
    final todayStart = DateTime(
      day.year,
      day.month,
      day.day,
      range.startHour,
      range.startMinute,
    );
    var todayEnd = DateTime(
      day.year,
      day.month,
      day.day,
      range.endHour,
      range.endMinute,
    );
    if (range.startTotalMinutes >= range.endTotalMinutes) {
      if (!todayEnd.isAfter(todayStart)) {
        todayEnd = todayEnd.add(const Duration(days: 1));
      }
      return (start: todayStart, end: todayEnd);
    }
    if (todayEnd.isAfter(todayStart)) {
      return (start: todayStart, end: todayEnd);
    }
    return null;
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
    String? notificationHint,
    String? prayerId,

    /// iOS: when the repeating overnight night monitor is active, one-shot
    /// `nightDiscipline` lock transitions are skipped unless this is true
    /// (Salah end → night, temp-unlock expiry, etc.).
    bool forceNativeNightLock = false,

    /// Do not register a native alarm / DeviceActivity edge (state-only).
    bool skipNativeSchedule = false,

    /// iOS monitor: only prayer-window starts should set the Salah shield latch.
    bool setsSalahShieldLatch = false,

    /// Clears the native Salah latch when this edge fires (night wake unlock).
    bool clearIosSalahShieldLatch = false,
  }) {
    return <String, dynamic>{
      'at': at.toIso8601String(),
      'atMillis': at.millisecondsSinceEpoch,
      'isLocked': isLocked,
      'activeMode': activeMode.name,
      'lockReason': reason,
      'nextChangeAt': nextChangeAt?.toIso8601String(),
      // ignore: use_null_aware_elements
      if (nextChangeAt case final nextAt?)
        'nextChangeAtMillis': nextAt.millisecondsSinceEpoch,
      // ignore: use_null_aware_elements
      if (notificationHint case final hint?) 'notificationHint': hint,
      // ignore: use_null_aware_elements
      if (prayerId case final pid?) 'prayerId': pid,
      if (forceNativeNightLock) 'forceNativeNightLock': true,
      if (skipNativeSchedule) 'skipNativeSchedule': true,
      if (setsSalahShieldLatch) 'setsSalahShieldLatch': true,
      if (clearIosSalahShieldLatch) 'clearIosSalahShieldLatch': true,
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
