import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart' show Locale;
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

import 'focus_enforcement_service.dart';
import 'storage_service.dart';
import '../../features/focus/model/focus_models.dart';
import '../../l10n/app_localizations.dart';
import '../../features/home/helpers/home_prayer_times_helper.dart';
import '../../features/home/model/home_models.dart';

void _onNotificationResponse(NotificationResponse response) {
  unawaited(
    FocusEnforcementService.appendDebugLog(
      'notifications.response',
      'id=${response.id} actionId=${response.actionId} payload=${response.payload} input=${response.input} type=${response.notificationResponseType.name}',
    ),
  );
}

class AppNotificationService {
  AppNotificationService._();

  static final AppNotificationService instance = AppNotificationService._();

  // Android ties channel sound to the channel id permanently — it cannot be
  // changed after first creation on a device. A distinct channel per sound
  // choice lets users switch "Full Adhan" / "Beep" / "Mute" per prayer and
  // have it take effect immediately, instead of being stuck with whatever
  // sound the old shared channel happened to be created with.
  static const _prayerChannelFullAdhan = AndroidNotificationChannel(
    'prayer_full_adhan',
    'Prayer reminders (Adhan)',
    description: 'Prayer time reminders from Deenly, with the Adhan sound.',
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('azan'),
  );

  static const _prayerChannelBeep = AndroidNotificationChannel(
    'prayer_beep',
    'Prayer reminders (Beep)',
    description: 'Prayer time reminders from Deenly, with a short beep.',
    importance: Importance.max,
    sound: RawResourceAndroidNotificationSound('beep'),
  );

  static const _prayerChannelMute = AndroidNotificationChannel(
    'prayer_mute',
    'Prayer reminders (Silent)',
    description: 'Prayer time reminders from Deenly, without sound.',
    importance: Importance.max,
    playSound: false,
  );

  static const _focusChannel = AndroidNotificationChannel(
    'focus_modes',
    'Focus modes',
    description: 'Sleep time and other focus mode updates from Deenly.',
    importance: Importance.high,
  );

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();
  static const MethodChannel _focusMethodChannel = MethodChannel(
    'com.app.deenly.deenly/focus',
  );
  bool _initialized = false;
  Future<void> _prayerSyncSerial = Future<void>.value();
  Future<void> _focusSyncSerial = Future<void>.value();
  String? _lastPrayerScheduleSignature;
  String? _lastFocusScheduleSignature;

  /// Forces the next [syncFocusNotifications] to rebuild pending alerts.
  void invalidateFocusScheduleCache() {
    _lastFocusScheduleSignature = null;
  }

  /// Forces the next [reschedulePrayerNotifications] to rebuild even if the
  /// computed signature matches the in-memory cache.
  void invalidatePrayerScheduleCache() {
    _lastPrayerScheduleSignature = null;
  }

  bool _hadIosFocusNotificationPendingCapSkip = false;
  bool _iosFocusNotificationsRetryPending = false;

  /// Android can keep a longer rolling batch; iOS stays short for the 64-pending cap.
  static int get defaultPrayerScheduleDaysAhead => Platform.isIOS ? 3 : 7;

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
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );

    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    await androidPlugin?.createNotificationChannel(_prayerChannelFullAdhan);
    await androidPlugin?.createNotificationChannel(_prayerChannelBeep);
    await androidPlugin?.createNotificationChannel(_prayerChannelMute);
    await androidPlugin?.createNotificationChannel(_focusChannel);

    _initialized = true;
  }

  Future<bool> _hasNotificationPermission() async {
    final enabledByUser = await StorageService.appNotificationsEnabled;
    if (!enabledByUser) return false;
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

  /// Enough IDs for multiple days × 6 prayer indices (sunrise skipped when scheduling).
  static const int _prayerNotificationIdStart = 1000;
  static const int _prayerNotificationIdEnd = 1199;

  /// Hard iOS limit for pending local notifications per app.
  static const int _iosPendingNotificationLimit = 64;

  /// Reserve capacity so the nearest 3 calendar days × 5 prayers stay schedulable
  /// even when focus/other alerts compete for the iOS pending pool.
  static const int _iosPrayerReserveSlots = 15;

  Future<void> reschedulePrayerNotifications({
    required double latitude,
    required double longitude,
    bool forceReschedule = false,
    int? daysAheadOverride,
  }) async {
    final run = _prayerSyncSerial.then((_) async {
      final isSpanish = await _isSpanishLocale();
      final l10n = await _focusNotificationsLocalizations();
      await initialize();

      final needsTzReschedule =
          await StorageService.needsPrayerNotificationReschedule;
      final effectiveForce = forceReschedule || needsTzReschedule;

      if (!await _hasNotificationPermission()) {
        // Permission / master toggle off must clear leftovers so revoked access
        // cannot leave orphaned prayer reminders firing.
        _lastPrayerScheduleSignature = null;
        await _cancelRange(
          _prayerNotificationIdStart,
          _prayerNotificationIdEnd,
        );
        if (needsTzReschedule) {
          await StorageService.setNeedsPrayerNotificationReschedule(false);
        }
        return;
      }
      await _ensureAndroidExactAlarmOrFallback();
      // Match device timezone after travel / DST changes.
      await _setLocalTimezone();

      final prayerSettingsRaw = await StorageService.prayerSettingsJson;
      final prayerSettings = prayerSettingsRaw == null
          ? PrayerSettingsState.defaults()
          : PrayerSettingsState.fromJson(prayerSettingsRaw);
      final customTimeOverrides = prayerSettings.customTimeOverrides;
      final calculationMethod = await StorageService.calculationMethod ?? '';
      final asrMethod = await StorageService.asrMethod ?? '';
      final localeCode = await StorageService.localeCode ?? 'en';

      final now = DateTime.now();
      final daysAhead =
          (daysAheadOverride ?? defaultPrayerScheduleDaysAhead).clamp(1, 7);
      // Calendar-day iteration (not Duration) so DST transitions cannot skip a day.
      final today = DateTime(now.year, now.month, now.day);
      final datasets = <({int dayOffset, HomePrayerTimesData data})>[
        for (var d = 0; d < daysAhead; d++)
          (
            dayOffset: d,
            // Fresh calculation — never the home cache — so reminders align with
            // the current method/location and focus lock windows.
            data: HomePrayerTimesHelper.applyCustomOverrides(
              data: await HomePrayerTimesHelper.generatePrayerTimesForDate(
                latitude: latitude,
                longitude: longitude,
                date: DateTime(today.year, today.month, today.day + d),
              ),
              overridesMinutesSinceMidnight: customTimeOverrides,
              referenceTime: DateTime(today.year, today.month, today.day + d, 12),
            ),
          ),
      ];

      final signature = _buildPrayerScheduleSignature(
        latitude: latitude,
        longitude: longitude,
        datasets: datasets,
        prayerSettings: prayerSettings,
        calculationMethod: calculationMethod,
        asrMethod: asrMethod,
        localeCode: localeCode,
        timeZoneName: now.timeZoneName,
        daysAhead: daysAhead,
      );
      // Identical schedule → keep existing pending Fajr→Isha alarms. Never cancel
      // just because resume/daily-refresh set a dirty flag after NTP TIME_CHANGED.
      if (_lastPrayerScheduleSignature == signature) {
        if (needsTzReschedule) {
          await StorageService.setNeedsPrayerNotificationReschedule(false);
        }
        await FocusEnforcementService.appendDebugLog(
          'notifications.prayer.sync',
          'skipped reschedule because signature is unchanged '
          '(force=$effectiveForce)',
        );
        return;
      }

      // Cancel stale prayer IDs first so they are not counted toward the iOS cap.
      // Do not use [cancelAll] — it would clear unrelated tray notifications.
      await _cancelRange(_prayerNotificationIdStart, _prayerNotificationIdEnd);

      final candidates = <PrayerScheduleCandidate>[];
      for (final dataset in datasets) {
        for (final slot in dataset.data.slots.where(
          (slot) => slot.id != HomePrayerId.sunrise,
        )) {
          final trackable = slot.id.trackablePrayer;
          final entry = trackable == null
              ? const PrayerSettingEntry()
              : prayerSettings.forPrayer(trackable);
          if (!entry.notificationsEnabled) continue;
          candidates.add(
            PrayerScheduleCandidate(
              id:
                  _prayerNotificationIdStart +
                  dataset.dayOffset * 20 +
                  _slotIndex(slot.id),
              when: slot.time,
              title: _prayerTimeTitle(slot.id, isSpanish: isSpanish),
              body: _prayerTimeBody(slot.id, l10n),
              details: _prayerNotificationDetailsFor(entry.sound),
              payload: 'prayer:${slot.id.name}',
            ),
          );
        }
      }

      var toSchedule = candidates;
      if (Platform.isIOS) {
        // Only free focus/other alerts for prayers that will actually be scheduled
        // (nearest upcoming within the 3-day horizon), not a blanket 15 always.
        final futureCount = prioritizeNearestPrayerSlots(
          candidates: candidates,
          room: _iosPendingNotificationLimit,
          now: now,
        ).length;
        final needed = iosPrayerSlotsToProtect(futureCandidateCount: futureCount);
        await _ensureIosRoomForPrayers(needed: needed);
        final pending = await _plugin.pendingNotificationRequests();
        final room = (_iosPendingNotificationLimit - pending.length).clamp(
          0,
          _iosPendingNotificationLimit,
        );
        toSchedule = prioritizeNearestPrayerSlots(
          candidates: candidates,
          room: room,
          now: now,
        );
        await FocusEnforcementService.appendDebugLog(
          'notifications.prayer.sync',
          'ios cap needed=$needed room=$room candidates=${candidates.length} '
          'selected=${toSchedule.length}',
        );
      }

      for (final candidate in toSchedule) {
        await _schedulePrayerCandidate(candidate);
      }

      _lastPrayerScheduleSignature = signature;
      if (needsTzReschedule) {
        await StorageService.setNeedsPrayerNotificationReschedule(false);
      }
      await FocusEnforcementService.appendDebugLog(
        'notifications.prayer.sync',
        'scheduled soft prayer reminders daysAhead=$daysAhead '
        'scheduledCount=${toSchedule.length} '
        'force=$effectiveForce tz=${now.timeZoneName}',
      );
    });
    _prayerSyncSerial = run.catchError((Object _) {});
    await run;
  }

  /// Night discipline: one ID per upcoming lock / unlock (same horizon as prayer batch).
  static const int _nightLockNotificationIdStart = 4000;
  static const int _nightUnlockNotificationIdEnd = 4016;
  static const int _salahLockNotificationIdStart = 3000;
  static const int _salahUnlockNotificationIdStart = 3100;
  static const int _salahUnlockNotificationIdEnd = 3139;

  Future<void> syncFocusNotifications({
    required FocusSettings settings,
    required List<Map<String, dynamic>> scheduledTransitions,
  }) async {
    final run = _focusSyncSerial.then((_) async {
      await initialize();
      if (!await _hasNotificationPermission()) {
        _lastFocusScheduleSignature = null;
        _iosFocusNotificationsRetryPending = false;
        await _cancelRange(2000, 2059);
        await _cancelRange(
          _salahLockNotificationIdStart,
          _salahUnlockNotificationIdEnd,
        );
        await _cancelRange(
          _nightLockNotificationIdStart,
          _nightUnlockNotificationIdEnd,
        );
        return;
      }
      await _ensureAndroidExactAlarmOrFallback();
      await _setLocalTimezone();

      const includeUnlockNotifications = true;
      final signature = await _buildFocusScheduleSignature(
        settings: settings,
        includeUnlockNotifications: includeUnlockNotifications,
        scheduledTransitions: scheduledTransitions,
      );
      if (_lastFocusScheduleSignature == signature &&
          !_iosFocusNotificationsRetryPending) {
        await FocusEnforcementService.appendDebugLog(
          'notifications.focus.sync',
          'skipped reschedule because signature is unchanged',
        );
        return;
      }

      await _cancelRange(2000, 2059);
      // Clear legacy Salah/night ID ranges as part of the rebuild so old
      // pending requests cannot pile up after upgrading to the deduped flow.
      await _cancelRange(
        _salahLockNotificationIdStart,
        _salahUnlockNotificationIdEnd,
      );
      await _cancelRange(
        _nightLockNotificationIdStart,
        _nightUnlockNotificationIdEnd,
      );

      await _scheduleFocusTransitionNotifications(
        scheduledTransitions: scheduledTransitions,
        includeUnlockNotifications: includeUnlockNotifications,
      );

      if (_hadIosFocusNotificationPendingCapSkip) {
        _iosFocusNotificationsRetryPending = true;
        await FocusEnforcementService.appendDebugLog(
          'notifications.focus.sync',
          'iOS pending-notification cap hit; will retry on next focus sync',
        );
      } else {
        _iosFocusNotificationsRetryPending = false;
      }
      _lastFocusScheduleSignature = signature;
    });
    _focusSyncSerial = run.catchError((Object _) {});
    await run;
  }

  Future<void> _scheduleFocusTransitionNotifications({
    required List<Map<String, dynamic>> scheduledTransitions,
    required bool includeUnlockNotifications,
  }) async {
    _hadIosFocusNotificationPendingCapSkip = false;
    final l10n = await _focusNotificationsLocalizations();
    final transitions =
        scheduledTransitions
            .where((transition) {
              final atMillis = (transition['atMillis'] as num?)?.toInt() ?? 0;
              if (atMillis <= DateTime.now().millisecondsSinceEpoch) {
                return false;
              }
              final isLocked = transition['isLocked'] as bool? ?? false;
              final mode = transition['activeMode'] as String?;
              if (!isLocked && !includeUnlockNotifications) return false;
              final hint = transition['notificationHint'] as String?;
              // Night already notified; Salah ended — re-lock without a duplicate night alert.
              if (hint == 'nightResumeSilent') {
                unawaited(
                  FocusEnforcementService.appendDebugLog(
                    'notifications.focus.skip',
                    'nightResumeSilent atMillis=$atMillis '
                        '(duplicate night notification suppressed)',
                  ),
                );
                return false;
              }
              // Prayer reminders already cover Salah start; avoid a second alert.
              // Exception: nightLock during an active Salah window (night starts inside prayer).
              if (isLocked &&
                  mode == FocusModeType.salah.name &&
                  hint != 'nightLock') {
                return false;
              }
              final prayerId = transition['prayerId'] as String?;
              // Salah windows do not auto-open apps (shield / latch until Home unlock).
              // Do not schedule Salah-boundary unlock notifications on mobile.
              if (!kIsWeb &&
                  (Platform.isIOS || Platform.isAndroid) &&
                  !isLocked &&
                  prayerId != null) {
                return false;
              }
              return isLocked || includeUnlockNotifications;
            })
            .toList(growable: false)
          ..sort((a, b) {
            final am = (a['atMillis'] as num?)?.toInt() ?? 0;
            final bm = (b['atMillis'] as num?)?.toInt() ?? 0;
            return am.compareTo(bm);
          });

    var lockId = _salahLockNotificationIdStart;
    var unlockId = _salahUnlockNotificationIdStart;
    for (final transition in transitions) {
      final atMillis = (transition['atMillis'] as num?)?.toInt() ?? 0;
      if (atMillis <= 0) continue;
      final isLocked = transition['isLocked'] as bool? ?? false;
      final mode = transition['activeMode'] as String?;
      final notificationHint = transition['notificationHint'] as String?;
      final prayerId = transition['prayerId'] as String?;
      final at = DateTime.fromMillisecondsSinceEpoch(atMillis);
      final id = isLocked ? lockId++ : unlockId++;
      final title = _focusTransitionTitle(
        isLocked: isLocked,
        mode: mode,
        notificationHint: notificationHint,
        prayerId: prayerId,
        l10n: l10n,
      );
      final body = _focusTransitionBody(
        isLocked: isLocked,
        mode: mode,
        notificationHint: notificationHint,
        prayerId: prayerId,
        l10n: l10n,
      );
      await FocusEnforcementService.appendDebugLog(
        'notifications.focusTransition.schedule',
        'id=$id at=${at.toIso8601String()} locked=$isLocked mode=$mode hint=$notificationHint prayerId=$prayerId',
      );
      final scheduled = await _scheduleIfFuture(
        id: id,
        when: at,
        title: title,
        body: body,
        details: _nightTransitionNotificationDetails,
        preferAlarmClock: false,
        iosScheduleRole: _IosScheduleRole.focus,
      );
      if (Platform.isIOS && !scheduled && at.isAfter(DateTime.now())) {
        _hadIosFocusNotificationPendingCapSkip = true;
      }
    }
  }

  Future<AppLocalizations> _focusNotificationsLocalizations() async {
    final code = await StorageService.localeCode;
    try {
      return lookupAppLocalizations(_localeFromPrefsCode(code));
    } catch (_) {
      return lookupAppLocalizations(const Locale('en'));
    }
  }

  Locale _localeFromPrefsCode(String? code) {
    if (code == null || code.isEmpty) return const Locale('en');
    final primary = code.replaceAll('_', '-').split('-').first.toLowerCase();
    return Locale(primary);
  }

  String _focusTransitionTitle({
    required bool isLocked,
    required String? mode,
    required String? notificationHint,
    required String? prayerId,
    required AppLocalizations l10n,
  }) {
    if (notificationHint == 'nightLock') {
      return l10n.focusNotifNightModeTitle;
    }
    if (notificationHint == 'nightMorning') {
      return 'Good Morning';
    }
    if (!isLocked && mode == FocusModeType.salah.name) {
      return l10n.focusNotifSalahCompleteTitle;
    }
    if (isLocked) return l10n.focusNotifAppsLockedTitle;
    return l10n.focusNotifAppsUnlockedTitle;
  }

  String _focusTransitionBody({
    required bool isLocked,
    required String? mode,
    required String? notificationHint,
    required String? prayerId,
    required AppLocalizations l10n,
  }) {
    if (notificationHint == 'nightLock') {
      return l10n.focusNotifNightLockedBody;
    }
    if (notificationHint == 'nightMorning') {
      if (isLocked) {
        return 'Night Focus Mode is complete. Open Deenly to unlock apps when you are ready.';
      }
      return 'Good morning! Apps are now available.';
    }
    if (!isLocked && mode == FocusModeType.salah.name) {
      return l10n.focusNotifSalahCompleteBody;
    }
    if (!isLocked) return l10n.focusNotifAppsNowAvailableBody;
    if (isLocked && mode == FocusModeType.salah.name) {
      return l10n.focusNotifSalahLockedBody;
    }
    if (mode == FocusModeType.nightDiscipline.name) {
      return l10n.focusNotifNightLockedBody;
    }
    return l10n.focusNotifGenericLockedBody;
  }

  NotificationDetails get _nightTransitionNotificationDetails =>
      NotificationDetails(
        android: AndroidNotificationDetails(
          _focusChannel.id,
          _focusChannel.name,
          channelDescription: _focusChannel.description,
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          threadIdentifier: 'deenly.focus_transition',
        ),
        macOS: const DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          threadIdentifier: 'deenly.focus_transition',
        ),
      );

  /// Per-prayer sound preference.
  ///
  /// Android: routed to a dedicated channel per sound (channel sound is
  /// immutable after first creation, so each choice needs its own channel).
  /// `azan.mp3` / `beep.mp3` live in `android/app/src/main/res/raw/`.
  ///
  /// iOS: `sound` names a file bundled at the root of the app bundle
  /// (`ios/Runner/azan.caf` / `beep.caf`, added to the Runner target's Copy
  /// Bundle Resources phase). Apple silently falls back to the default tone
  /// for any custom sound longer than 30 seconds, so `azan.caf` is a 28s
  /// CAF/IMA4 clip trimmed from the source Adhan (Android plays the full
  /// `azan.mp3` — no such limit there).
  NotificationDetails _prayerNotificationDetailsFor(
    PrayerNotificationSound sound,
  ) {
    final playSound = sound != PrayerNotificationSound.mute;
    final AndroidNotificationChannel channel;
    String? iosSoundName;
    switch (sound) {
      case PrayerNotificationSound.fullAdhan:
        channel = _prayerChannelFullAdhan;
        iosSoundName = 'azan.caf';
      case PrayerNotificationSound.beep:
        channel = _prayerChannelBeep;
        iosSoundName = 'beep.caf';
      case PrayerNotificationSound.mute:
        channel = _prayerChannelMute;
        iosSoundName = null;
    }
    return NotificationDetails(
      android: AndroidNotificationDetails(
        channel.id,
        channel.name,
        channelDescription: channel.description,
        importance: Importance.max,
        priority: Priority.high,
        playSound: playSound,
        sound: channel.sound,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: playSound,
        sound: iosSoundName,
        threadIdentifier: 'deenly.prayer_reminder',
      ),
      macOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: playSound,
        sound: iosSoundName,
        threadIdentifier: 'deenly.prayer_reminder',
      ),
    );
  }

  Future<void> _schedulePrayerCandidate(PrayerScheduleCandidate candidate) async {
    await _scheduleIfFuture(
      id: candidate.id,
      when: candidate.when,
      title: candidate.title,
      body: candidate.body,
      details: candidate.details,
      payload: candidate.payload,
      // Prayer times must beat Doze. alarmClock is the reliable Android path;
      // focus/other alerts keep preferAlarmClock=false.
      preferAlarmClock: true,
      iosScheduleRole: _IosScheduleRole.prayer,
    );
  }

  Future<bool> _scheduleIfFuture({
    required int id,
    required DateTime when,
    required String title,
    required String body,
    required NotificationDetails details,
    String? payload,
    bool preferAlarmClock = false,
    _IosScheduleRole iosScheduleRole = _IosScheduleRole.focus,
  }) async {
    final safeTitle = title.trim().isEmpty ? 'Deenly' : title.trim();
    final safeBody = body.trim().isEmpty
        ? 'Open Deenly for details.'
        : body.trim();
    // Prayer slots are already local wall times truncated to the minute.
    final scheduledAt = when.isUtc ? when.toLocal() : when;
    final scheduledMinute = DateTime(
      scheduledAt.year,
      scheduledAt.month,
      scheduledAt.day,
      scheduledAt.hour,
      scheduledAt.minute,
    );
    // Exact prayer time only — never schedule or show a late catch-up.
    if (!scheduledMinute.isAfter(DateTime.now())) {
      await FocusEnforcementService.appendDebugLog(
        'notifications.skip',
        'id=$id title=$safeTitle scheduledAt=${scheduledMinute.toIso8601String()} '
        'reason=past',
      );
      return false;
    }

    if (Platform.isIOS) {
      final pending = await _plugin.pendingNotificationRequests();
      final prayerPending = pending.where(_isPrayerNotificationId).length;
      final nonPrayerPending = pending.length - prayerPending;
      final blocked = switch (iosScheduleRole) {
        // Prayers may use the full OS pool; caller already ranked nearest-first.
        _IosScheduleRole.prayer =>
          pending.length >= _iosPendingNotificationLimit,
        // Focus/other must leave reserved capacity for prayer reminders.
        _IosScheduleRole.focus => () {
          final reserved = prayerPending > _iosPrayerReserveSlots
              ? prayerPending
              : _iosPrayerReserveSlots;
          final focusBudget = _iosPendingNotificationLimit - reserved;
          return nonPrayerPending >= focusBudget;
        }(),
      };
      if (blocked) {
        await FocusEnforcementService.appendDebugLog(
          'notifications.skip',
          'id=$id title=$safeTitle reason=ios_pending_cap '
          'role=${iosScheduleRole.name} pending=${pending.length} '
          'prayerPending=$prayerPending nonPrayerPending=$nonPrayerPending',
        );
        return false;
      }
    }

    await FocusEnforcementService.appendDebugLog(
      'notifications.schedule',
      'id=$id title=$safeTitle scheduledAt=${scheduledMinute.toIso8601String()} '
      'payload=$payload',
    );

    // Build TZDateTime from wall-clock components in tz.local so the OS trigger
    // matches the calculated prayer minute (not a UTC reinterpretation).
    final whenTz = tz.TZDateTime(
      tz.local,
      scheduledMinute.year,
      scheduledMinute.month,
      scheduledMinute.day,
      scheduledMinute.hour,
      scheduledMinute.minute,
    );

    if (Platform.isAndroid) {
      Future<void> scheduleWith(AndroidScheduleMode mode) {
        return _plugin.zonedSchedule(
          id,
          safeTitle,
          safeBody,
          whenTz,
          details,
          androidScheduleMode: mode,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          payload: payload,
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
        safeTitle,
        safeBody,
        whenTz,
        details,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        payload: payload,
      );
    }
    return true;
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

  Future<void> _cancelRange(int startInclusive, int endInclusive) async {
    // On iOS, `cancel(id)` can remove delivered entries with the same ID from
    // Notification Center. Route through native pending-only cancellation.
    if (Platform.isIOS) {
      try {
        await _focusMethodChannel.invokeMethod<int>(
          'cancelPendingNotificationRange',
          <String, dynamic>{
            'startInclusive': startInclusive,
            'endInclusive': endInclusive,
          },
        );
        return;
      } on PlatformException {
        // Fall back to plugin behavior below.
      }
    }

    // On macOS, limit to pending IDs so delivered notifications are not cleared.
    if (Platform.isMacOS) {
      final pending = await _plugin.pendingNotificationRequests();
      for (final request in pending) {
        final id = request.id;
        if (id < startInclusive || id > endInclusive) continue;
        await _plugin.cancel(id);
      }
      return;
    }

    // Android: `cancel(id)` clears the status bar entry for that id. Cancelling
    // only [pendingNotificationRequests] is unsafe — the plugin cache can
    // disagree with AlarmManager, leaving stale alarms and breaking new
    // schedules. Cancel every id in range, but skip ids currently shown so tray
    // alerts (e.g. night mode) stay until the user dismisses them.
    if (Platform.isAndroid) {
      final activeIds = <int>{};
      try {
        final active = await _plugin.getActiveNotifications();
        for (final n in active) {
          final nid = n.id;
          if (nid != null) activeIds.add(nid);
        }
      } catch (_) {
        // Older API / unsupported: fall through with empty set → full cancel.
      }
      for (var id = startInclusive; id <= endInclusive; id++) {
        if (activeIds.contains(id)) continue;
        await _plugin.cancel(id);
      }
      return;
    }

    for (var id = startInclusive; id <= endInclusive; id++) {
      await _plugin.cancel(id);
    }
  }

  /// Cancels prayer notification ID range (e.g. before focus sync if IDs ever overlap).

  Future<void> _setLocalTimezone() async {
    try {
      final timezoneName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(timezoneName));
      return;
    } catch (_) {
      // Fall through to offset-based location — never force UTC for wall times.
    }
    try {
      final offsetHours = DateTime.now().timeZoneOffset.inHours;
      // Etc/GMT signs are inverted from conventional UTC offsets.
      final locationName = offsetHours == 0
          ? 'Etc/UTC'
          : 'Etc/GMT${offsetHours > 0 ? '-' : '+'}${offsetHours.abs()}';
      tz.setLocalLocation(tz.getLocation(locationName));
    } catch (_) {
      // Leave tz.local unchanged if both lookups fail.
    }
  }

  int _slotIndex(HomePrayerId id) => _slotIndexStatic(id);

  String _prayerLabel(HomePrayerId id, {bool isSpanish = false}) {
    if (isSpanish) {
      switch (id) {
        case HomePrayerId.fajr:
          return 'Fajr';
        case HomePrayerId.sunrise:
          return 'Amanecer';
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

  String _prayerTimeTitle(HomePrayerId id, {required bool isSpanish}) {
    return "It's time for ${_prayerLabel(id, isSpanish: isSpanish)}";
  }

  String _prayerTimeBody(HomePrayerId id, AppLocalizations l10n) {
    switch (id) {
      case HomePrayerId.fajr:
        return l10n.prayerNotificationSubtitleFajr;
      case HomePrayerId.dhuhr:
        return l10n.prayerNotificationSubtitleDhuhr;
      case HomePrayerId.asr:
        return l10n.prayerNotificationSubtitleAsr;
      case HomePrayerId.maghrib:
        return l10n.prayerNotificationSubtitleMaghrib;
      case HomePrayerId.isha:
        return l10n.prayerNotificationSubtitleIsha;
      case HomePrayerId.sunrise:
        return '';
    }
  }

  Future<bool> _isSpanishLocale() async {
    final code = (await StorageService.localeCode)?.toLowerCase();
    return code != null && code.startsWith('es');
  }

  String _buildPrayerScheduleSignature({
    required double latitude,
    required double longitude,
    required List<({int dayOffset, HomePrayerTimesData data})> datasets,
    required PrayerSettingsState prayerSettings,
    required String calculationMethod,
    required String asrMethod,
    required String localeCode,
    required String timeZoneName,
    required int daysAhead,
  }) {
    final prayerParts = <String>[
      latitude.toStringAsFixed(4),
      longitude.toStringAsFixed(4),
      calculationMethod,
      asrMethod,
      localeCode,
      timeZoneName,
      'days=$daysAhead',
    ];
    for (final prayer in TrackablePrayer.values) {
      final entry = prayerSettings.forPrayer(prayer);
      prayerParts.add(
        '${prayer.name}:en=${entry.notificationsEnabled}:snd=${entry.sound.name}',
      );
    }
    for (final dataset in datasets) {
      for (final slot in dataset.data.slots.where(
        (slot) => slot.id != HomePrayerId.sunrise,
      )) {
        final local = slot.time.isUtc ? slot.time.toLocal() : slot.time;
        prayerParts.add(
          '${dataset.dayOffset}:${slot.id.name}:'
          '${local.year}-${local.month}-${local.day}'
          'T${local.hour}:${local.minute}',
        );
      }
    }
    return prayerParts.join('|');
  }

  /// Stable notification id for a prayer on a day offset (0 = today).
  @visibleForTesting
  static int prayerNotificationIdFor(HomePrayerId id, int dayOffset) {
    return _prayerNotificationIdStart + dayOffset * 20 + _slotIndexStatic(id);
  }

  static int _slotIndexStatic(HomePrayerId id) {
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

  static bool _isPrayerNotificationId(PendingNotificationRequest request) {
    return request.id >= _prayerNotificationIdStart &&
        request.id <= _prayerNotificationIdEnd;
  }

  /// How many pending slots to protect/free for the current upcoming prayer set.
  /// Never more than [_iosPrayerReserveSlots]; never more than real candidates.
  @visibleForTesting
  static int iosPrayerSlotsToProtect({
    required int futureCandidateCount,
    int reserveSlots = _iosPrayerReserveSlots,
  }) {
    if (futureCandidateCount <= 0) return 0;
    return futureCandidateCount > reserveSlots
        ? reserveSlots
        : futureCandidateCount;
  }

  /// Keeps the soonest future prayer slots when iOS pending capacity is tight.
  @visibleForTesting
  static List<PrayerScheduleCandidate> prioritizeNearestPrayerSlots({
    required List<PrayerScheduleCandidate> candidates,
    required int room,
    required DateTime now,
  }) {
    if (room <= 0) return const <PrayerScheduleCandidate>[];
    final future = candidates.where((candidate) {
      final local = candidate.when.isUtc
          ? candidate.when.toLocal()
          : candidate.when;
      final minute = DateTime(
        local.year,
        local.month,
        local.day,
        local.hour,
        local.minute,
      );
      return minute.isAfter(now);
    }).toList(growable: false)..sort((a, b) => a.when.compareTo(b.when));
    if (future.length <= room) return future;
    return future.sublist(0, room);
  }

  /// Frees lower-priority focus/other pending alerts so prayer reminders fit.
  /// No-op when [needed] is already available — does not strip focus preemptively.
  Future<void> _ensureIosRoomForPrayers({required int needed}) async {
    if (!Platform.isIOS || needed <= 0) return;
    final pending = await _plugin.pendingNotificationRequests();
    final room = _iosPendingNotificationLimit - pending.length;
    if (room >= needed) return;

    // Drop unlock / night chatter first, then lock alerts, then legacy IDs.
    const ranges = <(int, int)>[
      (_salahUnlockNotificationIdStart, _salahUnlockNotificationIdEnd),
      (_nightLockNotificationIdStart, _nightUnlockNotificationIdEnd),
      (_salahLockNotificationIdStart, _salahLockNotificationIdStart + 99),
      (2000, 2059),
    ];
    for (final range in ranges) {
      await _cancelRange(range.$1, range.$2);
      final after = await _plugin.pendingNotificationRequests();
      if (_iosPendingNotificationLimit - after.length >= needed) {
        invalidateFocusScheduleCache();
        return;
      }
    }
    invalidateFocusScheduleCache();
  }

  /// Stable signature for focus transition + native schedule sync deduplication.
  Future<String> buildFocusScheduleSignature({
    required FocusSettings settings,
    required List<Map<String, dynamic>> scheduledTransitions,
    bool includeUnlockNotifications = true,
  }) {
    return _buildFocusScheduleSignature(
      settings: settings,
      includeUnlockNotifications: includeUnlockNotifications,
      scheduledTransitions: scheduledTransitions,
    );
  }

  Future<String> _buildFocusScheduleSignature({
    required FocusSettings settings,
    required bool includeUnlockNotifications,
    required List<Map<String, dynamic>> scheduledTransitions,
  }) async {
    final localeCode = await StorageService.localeCode ?? 'en';
    final parts = <String>[
      'locale=$localeCode',
      'night=${settings.nightDisciplineEnabled}',
      'salah=${settings.salahModeEnabled}',
      'start=${settings.nightRange.startHour}:${settings.nightRange.startMinute}',
      'end=${settings.nightRange.endHour}:${settings.nightRange.endMinute}',
      'unlock=$includeUnlockNotifications',
      'tempUnlockUntil=${settings.temporarilyUnlockedUntil?.millisecondsSinceEpoch ?? 0}',
      'child=${settings.childModeEnabled}',
      'childUntil=${settings.childLockedUntil?.millisecondsSinceEpoch ?? 0}',
      'salahLatch=${settings.iosSalahShieldLatchEpochMillis ?? 0}',
    ];
    for (final transition in scheduledTransitions) {
      final atMillis = (transition['atMillis'] as num?)?.toInt() ?? 0;
      final isLocked = transition['isLocked'] as bool? ?? false;
      final mode = transition['activeMode'] as String? ?? '';
      final hint = transition['notificationHint'] as String? ?? '';
      final prayerId = transition['prayerId'] as String? ?? '';
      final forceNative = transition['forceNativeNightLock'] == true ? 1 : 0;
      final skipNative = transition['skipNativeSchedule'] == true ? 1 : 0;
      final setsSalahLatch = transition['setsSalahShieldLatch'] == true ? 1 : 0;
      final clearsSalahLatch = transition['clearIosSalahShieldLatch'] == true
          ? 1
          : 0;
      parts.add(
        'transition=$atMillis:${isLocked ? 1 : 0}:$mode:$hint:$prayerId:$forceNative:$skipNative:$setsSalahLatch:$clearsSalahLatch',
      );
    }

    return parts.join('|');
  }
}

enum _IosScheduleRole { prayer, focus }

@visibleForTesting
class PrayerScheduleCandidate {
  const PrayerScheduleCandidate({
    required this.id,
    required this.when,
    required this.title,
    required this.body,
    required this.details,
    required this.payload,
  });

  final int id;
  final DateTime when;
  final String title;
  final String body;
  final NotificationDetails details;
  final String payload;
}
