import 'dart:async';
import 'dart:io';

import 'package:flutter/foundation.dart' show ValueNotifier, kIsWeb;
import 'package:flutter/material.dart' show Locale;
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import '../../features/home/helpers/home_prayer_times_helper.dart';
import '../../features/home/model/home_models.dart';
import '../../l10n/app_localizations.dart';
import '../logger/logger_service.dart';
import 'storage_service.dart';

/// Shared Flutter API for Prayer Live Activity (iOS ActivityKit + Android ongoing).
///
/// Reuses [HomePrayerTimesHelper] — does not calculate prayer times separately.
class PrayerLiveActivityService {
  PrayerLiveActivityService._();

  static final PrayerLiveActivityService instance = PrayerLiveActivityService._();

  static const MethodChannel _channel = MethodChannel(
    'com.app.deenly.deenly/prayer_live_activity',
  );

  /// Mirrors the persisted Live Activity preference for UI listeners (e.g. Settings).
  final ValueNotifier<bool?> preferenceListenable = ValueNotifier<bool?>(null);

  Future<void> _syncSerial = Future<void>.value();
  String? _lastPayloadSignature;

  Future<bool> areActivitiesEnabled() async {
    if (kIsWeb) return false;
    try {
      final enabled = await _channel.invokeMethod<bool>('areActivitiesEnabled');
      return enabled ?? false;
    } catch (error, stack) {
      LoggerService.instance.warning(
        'LIVE_ACTIVITY',
        'areActivitiesEnabled failed: $error',
        error: error,
        stackTrace: stack,
      );
      // Android ongoing notification works when notification permission is granted.
      return Platform.isAndroid;
    }
  }

  Future<Map<String, dynamic>> getCapabilities() async {
    try {
      final raw = await _channel.invokeMethod<dynamic>('getCapabilities');
      if (raw is Map) {
        return Map<String, dynamic>.from(raw);
      }
    } catch (error, stack) {
      LoggerService.instance.warning(
        'LIVE_ACTIVITY',
        'getCapabilities failed: $error',
        error: error,
        stackTrace: stack,
      );
    }
    return <String, dynamic>{
      'platform': Platform.isIOS
          ? 'ios'
          : (Platform.isAndroid ? 'android' : 'other'),
      'supportsLiveActivity': Platform.isAndroid,
    };
  }

  /// Starts or refreshes the live status when the user preference is ON.
  Future<void> syncFromStorage({bool force = false}) async {
    final run = _syncSerial.then((_) => _syncBody(force: force));
    _syncSerial = run.catchError((Object _) {});
    return run;
  }

  Future<void> _syncBody({required bool force}) async {
    final enabled = await resolveEnabled();
    if (!enabled) {
      await stop();
      return;
    }

    // Preference may default ON, but never surface lock-screen content unless
    // the OS allows Live Activities / notifications.
    if (!await areActivitiesEnabled()) {
      await stop();
      return;
    }

    final latitude = await StorageService.locationLatitude;
    final longitude = await StorageService.locationLongitude;
    if (latitude == null || longitude == null) {
      await stop();
      return;
    }

    final l10n = _widgetLocalizations(
      _localeFromPrefsCode(await StorageService.localeCode),
    );
    final calculated = await HomePrayerTimesHelper.getOrGeneratePrayerTimes(
      latitude: latitude,
      longitude: longitude,
    );
    final rawSettings = await StorageService.prayerSettingsJson;
    final settings = rawSettings == null
        ? PrayerSettingsState.defaults()
        : PrayerSettingsState.fromJson(rawSettings);
    final times = HomePrayerTimesHelper.applyCustomOverrides(
      data: calculated,
      overridesMinutesSinceMidnight: settings.customTimeOverrides,
      referenceTime: DateTime.now(),
    );

    final payload = _buildPayload(
      times: times,
      l10n: l10n,
      locationName: await StorageService.locationName,
    );
    if (payload == null) {
      await stop();
      return;
    }

    final signature = payload.toString();
    if (!force && signature == _lastPayloadSignature) return;

    try {
      await _channel.invokeMethod<void>('startOrUpdate', payload);
      _lastPayloadSignature = signature;
    } catch (error, stack) {
      LoggerService.instance.warning(
        'LIVE_ACTIVITY',
        'startOrUpdate failed: $error',
        error: error,
        stackTrace: stack,
      );
    }
  }

  /// Effective on/off: defaults to ON the first time on supported platforms.
  Future<bool> resolveEnabled() async {
    final caps = await getCapabilities();
    final supported = caps['supportsLiveActivity'] == true;
    if (!supported) {
      preferenceListenable.value = false;
      return false;
    }

    final preference = await StorageService.prayerLiveActivityEnabledPreference;
    if (preference == null) {
      await StorageService.setPrayerLiveActivityEnabled(true);
      preferenceListenable.value = true;
      return true;
    }
    preferenceListenable.value = preference;
    return preference;
  }

  Future<void> stop() async {
    _lastPayloadSignature = null;
    try {
      await _channel.invokeMethod<void>('stop');
    } catch (error, stack) {
      LoggerService.instance.warning(
        'LIVE_ACTIVITY',
        'stop failed: $error',
        error: error,
        stackTrace: stack,
      );
    }
  }

  Future<void> setEnabled(bool enabled, {bool forceSync = true}) async {
    await StorageService.setPrayerLiveActivityEnabled(enabled);
    preferenceListenable.value = enabled;
    if (enabled) {
      await syncFromStorage(force: forceSync);
    } else {
      await stop();
    }
  }

  Map<String, dynamic>? _buildPayload({
    required HomePrayerTimesData times,
    required AppLocalizations l10n,
    required String? locationName,
  }) {
    final now = DateTime.now();
    final prayers = times.slots
        .where((slot) => slot.id != HomePrayerId.sunrise)
        .toList(growable: false);
    if (prayers.isEmpty) return null;

    final timeFormat = _safeTimeFormat(l10n.localeName);
    final current = _currentPrayer(prayers, now);
    final fajrSlot = prayers.firstWhere(
      (slot) => slot.id == HomePrayerId.fajr,
      orElse: () => prayers.first,
    );
    final tomorrowFajrTime = fajrSlot.time.add(const Duration(days: 1));
    final tomorrowFajr = HomePrayerSlot(
      id: HomePrayerId.fajr,
      time: tomorrowFajrTime,
    );

    // Before Fajr, feature the upcoming prayer with an "up next" label.
    // Native background refresh flips to [nowLabel] once the first slot starts.
    final featured = current ??
        prayers.firstWhere(
          (slot) => slot.time.isAfter(now),
          orElse: () => prayers.first,
        );
    final next = current == null
        ? (prayers.length > 1 ? prayers[1] : tomorrowFajr)
        : (_nextPrayerAfter(prayers, current, now) ?? tomorrowFajr);
    final beforeFirstPrayer = current == null;

    return <String, dynamic>{
      'currentPrayerId': featured.id.name,
      'currentPrayerLabel': _label(featured.id, l10n),
      'currentPrayerTimeLabel': timeFormat.format(featured.time),
      'currentPrayerIso': featured.time.toIso8601String(),
      // Prefer empty strings over null — iOS UserDefaults rejects NSNull.
      'nextPrayerId': next.id.name,
      'nextPrayerLabel': _label(next.id, l10n),
      'nextPrayerTimeLabel': timeFormat.format(next.time),
      // Before Fajr, schedule refresh at Fajr so the label can flip to "Now".
      'nextPrayerIso': beforeFirstPrayer
          ? featured.time.toIso8601String()
          : next.time.toIso8601String(),
      'nextPrayerLine': beforeFirstPrayer
          ? ''
          : l10n.liveActivityNextAt(
              _label(next.id, l10n),
              timeFormat.format(next.time),
            ),
      // Localized template so native background refresh keeps language.
      'nextPrayerLineTemplate': l10n.liveActivityNextAt('{prayer}', '{time}'),
      'locationName': locationName ?? '',
      'updatedAtLabel': l10n.liveActivityUpdatedAt(timeFormat.format(now)),
      'nowLabel': l10n.liveActivityNowLabel,
      'upNextLabel': l10n.homeNextPrayerIn,
      'beforeFirstPrayer': beforeFirstPrayer,
      'brandName': l10n.appTitle,
      'tomorrowFajrIso': tomorrowFajrTime.toIso8601String(),
      'tomorrowFajrLabel': _label(HomePrayerId.fajr, l10n),
      'tomorrowFajrTimeLabel': timeFormat.format(tomorrowFajrTime),
      'prayers': [
        for (final slot in prayers)
          <String, dynamic>{
            'id': slot.id.name,
            'label': _label(slot.id, l10n),
            'timeLabel': timeFormat.format(slot.time),
            'isoTime': slot.time.toIso8601String(),
          },
      ],
    };
  }

  HomePrayerSlot? _currentPrayer(List<HomePrayerSlot> prayers, DateTime now) {
    HomePrayerSlot? current;
    for (final slot in prayers) {
      if (!slot.time.isAfter(now)) {
        current = slot;
      }
    }
    return current;
  }

  HomePrayerSlot? _nextPrayerAfter(
    List<HomePrayerSlot> prayers,
    HomePrayerSlot current,
    DateTime now,
  ) {
    final index = prayers.indexWhere((slot) => slot.id == current.id);
    if (index >= 0 && index + 1 < prayers.length) {
      return prayers[index + 1];
    }
    for (final slot in prayers) {
      if (slot.time.isAfter(now) && slot.id != current.id) return slot;
    }
    return null;
  }

  String _label(HomePrayerId id, AppLocalizations l10n) {
    switch (id) {
      case HomePrayerId.fajr:
        return l10n.homePrayerFajr;
      case HomePrayerId.sunrise:
        return l10n.homePrayerSunrise;
      case HomePrayerId.dhuhr:
        return l10n.homePrayerDhuhr;
      case HomePrayerId.asr:
        return l10n.homePrayerAsr;
      case HomePrayerId.maghrib:
        return l10n.homePrayerMaghrib;
      case HomePrayerId.isha:
        return l10n.homePrayerIsha;
    }
  }

  static Locale _localeFromPrefsCode(String? code) {
    if (code == null || code.isEmpty) return const Locale('en');
    final primary = code.replaceAll('_', '-').split('-').first.toLowerCase();
    return Locale(primary);
  }

  static AppLocalizations _widgetLocalizations(Locale locale) {
    try {
      return lookupAppLocalizations(locale);
    } catch (_) {
      return lookupAppLocalizations(const Locale('en'));
    }
  }

  static DateFormat _safeTimeFormat(String localeName) {
    try {
      return DateFormat('h:mm a', localeName);
    } catch (_) {
      return DateFormat('h:mm a');
    }
  }
}
