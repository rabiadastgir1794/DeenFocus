import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../features/home/model/home_models.dart';

/// Centralized storage. Use for simple preferences (e.g. onboarding completed).
/// For structured data use Hive via this layer.
abstract class StorageService {
  static const String _keyOnboardingCompleted = 'onboarding_completed';
  static const String _keyUserName = 'user_name';
  static const String _keySect = 'sect';
  static const String _keyLocale = 'locale';
  static const String _keyLocationName = 'user_location_name';
  static const String _keyLocationSubtitle = 'user_location_subtitle';
  static const String _keyLocationLatitude = 'user_location_latitude';
  static const String _keyLocationLongitude = 'user_location_longitude';
  static const String _keyQuranSeedVersion = 'quran_seed_version';
  static const String _keyQuranShowEnglish = 'quran_show_english';
  static const String _keyQuranArabicFontSp = 'quran_arabic_font_sp';
  static const String _keyQuranEnglishFontSp = 'quran_english_font_sp';
  static const String _keyTasbihSeedVersion = 'tasbih_seed_version';
  static const String _keyHomeDailyVerseDate = 'home_daily_verse_date';
  static const String _keyHomeDailyVerseSurah = 'home_daily_verse_surah';
  static const String _keyHomeDailyVerseAyah = 'home_daily_verse_ayah';
  static const String _keyHomePrayerCacheDate = 'home_prayer_cache_date';
  static const String _keyHomePrayerCacheLat = 'home_prayer_cache_lat';
  static const String _keyHomePrayerCacheLng = 'home_prayer_cache_lng';
  static const String _keyHomePrayerCacheSect = 'home_prayer_cache_sect';
  static const String _keyHomePrayerCacheJson = 'home_prayer_cache_json';
  static const String _keyHomeNotificationPrompted =
      'home_notification_prompted';
  static const String _keyHomeIslamicEventsJson = 'home_islamic_events_json';
  static const String _keyHomeIslamicEventsLastYear =
      'home_islamic_events_last_year';
  static const String _keyHomePrayerStreakJson = 'home_prayer_streak_json';
  static const String _keyPrayerSettingsJson = 'prayer_settings_json';
  static const String _keyFocusSettingsJson = 'focus_settings_json';
  static const String _keyFocusScheduleJson = 'focus_schedule_json';
  static const String _keyDarkModeEnabled = 'dark_mode_enabled';
  static const String _keyAppNotificationsEnabled = 'app_notifications_enabled';
  static const String _keyNearbyMosquesCacheLat = 'nearby_mosques_cache_lat';
  static const String _keyNearbyMosquesCacheLng = 'nearby_mosques_cache_lng';
  static const String _keyNearbyMosquesCacheFetchedMs =
      'nearby_mosques_cache_fetched_ms';
  static const String _keyNearbyMosquesCacheJson = 'nearby_mosques_cache_json';
  static const String _keyAppFirstOpenMs = 'app_first_open_ms';
  static const String _keyAppReviewPromptCompleted =
      'app_review_prompt_completed';
  static const String _keyAppReviewSessionCount = 'app_review_session_count';
  static const String _keyAppReviewLastSessionMs = 'app_review_last_session_ms';
  static const String _keyAppReviewLastAutomaticMs =
      'app_review_last_automatic_ms';
  static const String _keyAppReviewAutomaticHistoryJson =
      'app_review_automatic_history_json';
  static const String _keyFocusAccessibilityDisclosureAccepted =
      'focus_accessibility_disclosure_accepted';
  static const String _keyHasEverSubscribed = 'has_ever_subscribed';
  static const String _legacyKeyHasUsedIntroOffer = 'has_used_intro_offer';
  static const String _keySubscriptionActive = 'subscription_active';
  static const String _keySubscriptionCachedAtMs = 'subscription_cached_at_ms';
  static const String _keyCalculationMethod = 'calculation_method';
  static const String _keyAsrMethod = 'asr_method';
  static const String _keyCycleModeEnabled = 'cycle_mode_enabled';
  static const String _keyCycleModeStartDateMs = 'cycle_mode_start_date_ms';
  static const String _keyCycleModeDataJson = 'cycle_mode_data_json';
  static const String _keyCycleModeCleanupVersion =
      'cycle_mode_cleanup_version';
  /// Bump when adding new Cycle Mode data repairs (Edit-bug history purge, etc.).
  static const int _cycleModeCleanupVersion = 1;
  static const String _keyLastPrayerReminderPromptMs = 'last_prayer_reminder_prompt_ms';
  static const String _keyPrayerReminderPromptedKeys =
      'prayer_reminder_prompted_keys';
  static const String _keyDailyChecklistJson = 'daily_checklist_json';
  static const String _keyStreakRestoreUsed = 'streak_restore_used';
  static const String _keyPendingPostOnboardingPaywall =
      'pending_post_onboarding_paywall';
  static const String _keyPrayerAlarmsEnabled = 'prayer_alarms_enabled';
  static const String _keyPrayerAlarmSnoozeMinutes =
      'prayer_alarm_snooze_minutes';
  static const String _keyNeedsPrayerNotificationReschedule =
      'needs_prayer_notification_reschedule';
  static const String _keyPrayerLiveActivityEnabled =
      'prayer_live_activity_enabled';
  static const int defaultPrayerAlarmSnoozeMinutes = 10;

  /// Snooze durations offered in settings and on the full-screen alarm UI.
  static const List<int> prayerAlarmSnoozeOptionMinutes = <int>[5, 10, 15];

  static Future<SharedPreferences> get _prefs async =>
      await SharedPreferences.getInstance();

  static Future<bool> get onboardingCompleted async {
    final prefs = await _prefs;
    return prefs.getBool(_keyOnboardingCompleted) ?? false;
  }

  static Future<void> setOnboardingCompleted(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyOnboardingCompleted, value);
  }

  /// One-shot: show first-time Superwall after onboarding lands on Home.
  static Future<bool> get pendingPostOnboardingPaywall async {
    final prefs = await _prefs;
    return prefs.getBool(_keyPendingPostOnboardingPaywall) ?? false;
  }

  static Future<void> setPendingPostOnboardingPaywall(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyPendingPostOnboardingPaywall, value);
  }

  static Future<String?> get userName async {
    final prefs = await _prefs;
    return prefs.getString(_keyUserName);
  }

  static Future<void> setUserName(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyUserName, value);
  }

  static Future<String?> get sect async {
    final prefs = await _prefs;
    return prefs.getString(_keySect);
  }

  static Future<void> setSect(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keySect, value);
  }

  static Future<String?> get localeCode async {
    final prefs = await _prefs;
    return prefs.getString(_keyLocale);
  }

  static Future<void> setLocaleCode(String? value) async {
    final prefs = await _prefs;
    if (value == null) {
      await prefs.remove(_keyLocale);
    } else {
      await prefs.setString(_keyLocale, value);
    }
  }

  static Future<String?> get locationName async {
    final prefs = await _prefs;
    return prefs.getString(_keyLocationName);
  }

  static Future<String?> get locationSubtitle async {
    final prefs = await _prefs;
    return prefs.getString(_keyLocationSubtitle);
  }

  static Future<double?> get locationLatitude async {
    final prefs = await _prefs;
    return prefs.getDouble(_keyLocationLatitude);
  }

  static Future<double?> get locationLongitude async {
    final prefs = await _prefs;
    return prefs.getDouble(_keyLocationLongitude);
  }

  static Future<void> setUserLocation({
    required String name,
    String? subtitle,
    double? latitude,
    double? longitude,
  }) async {
    final prefs = await _prefs;
    await prefs.setString(_keyLocationName, name);
    if (subtitle == null || subtitle.trim().isEmpty) {
      await prefs.remove(_keyLocationSubtitle);
    } else {
      await prefs.setString(_keyLocationSubtitle, subtitle.trim());
    }

    if (latitude == null) {
      await prefs.remove(_keyLocationLatitude);
    } else {
      await prefs.setDouble(_keyLocationLatitude, latitude);
    }

    if (longitude == null) {
      await prefs.remove(_keyLocationLongitude);
    } else {
      await prefs.setDouble(_keyLocationLongitude, longitude);
    }
  }

  static Future<int> get quranSeedVersion async {
    final prefs = await _prefs;
    return prefs.getInt(_keyQuranSeedVersion) ?? 0;
  }

  static Future<void> setQuranSeedVersion(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyQuranSeedVersion, value);
  }

  static Future<bool> get quranShowEnglish async {
    final prefs = await _prefs;
    return prefs.getBool(_keyQuranShowEnglish) ?? true;
  }

  static Future<void> setQuranShowEnglish(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyQuranShowEnglish, value);
  }

  static Future<double> get quranArabicFontSp async {
    final prefs = await _prefs;
    return prefs.getDouble(_keyQuranArabicFontSp) ?? 20;
  }

  static Future<double> get quranEnglishFontSp async {
    final prefs = await _prefs;
    return prefs.getDouble(_keyQuranEnglishFontSp) ?? 15;
  }

  static Future<void> setQuranArabicFontSp(double value) async {
    final prefs = await _prefs;
    await prefs.setDouble(_keyQuranArabicFontSp, value);
  }

  static Future<void> setQuranEnglishFontSp(double value) async {
    final prefs = await _prefs;
    await prefs.setDouble(_keyQuranEnglishFontSp, value);
  }

  static Future<int> get tasbihSeedVersion async {
    final prefs = await _prefs;
    return prefs.getInt(_keyTasbihSeedVersion) ?? 0;
  }

  static Future<void> setTasbihSeedVersion(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyTasbihSeedVersion, value);
  }

  static Future<String?> get homeDailyVerseDate async {
    final prefs = await _prefs;
    return prefs.getString(_keyHomeDailyVerseDate);
  }

  static Future<int?> get homeDailyVerseSurah async {
    final prefs = await _prefs;
    return prefs.getInt(_keyHomeDailyVerseSurah);
  }

  static Future<int?> get homeDailyVerseAyah async {
    final prefs = await _prefs;
    return prefs.getInt(_keyHomeDailyVerseAyah);
  }

  static Future<void> setHomeDailyVerse({
    required String dateKey,
    required int surah,
    required int ayah,
  }) async {
    final prefs = await _prefs;
    await prefs.setString(_keyHomeDailyVerseDate, dateKey);
    await prefs.setInt(_keyHomeDailyVerseSurah, surah);
    await prefs.setInt(_keyHomeDailyVerseAyah, ayah);
  }

  static Future<String?> get homePrayerCacheDate async {
    final prefs = await _prefs;
    return prefs.getString(_keyHomePrayerCacheDate);
  }

  static Future<double?> get homePrayerCacheLatitude async {
    final prefs = await _prefs;
    return prefs.getDouble(_keyHomePrayerCacheLat);
  }

  static Future<double?> get homePrayerCacheLongitude async {
    final prefs = await _prefs;
    return prefs.getDouble(_keyHomePrayerCacheLng);
  }

  static Future<String?> get homePrayerCacheSect async {
    final prefs = await _prefs;
    return prefs.getString(_keyHomePrayerCacheSect);
  }

  static Future<String?> get homePrayerCacheJson async {
    final prefs = await _prefs;
    return prefs.getString(_keyHomePrayerCacheJson);
  }

  static Future<void> setHomePrayerCache({
    required String dateKey,
    required double latitude,
    required double longitude,
    required String sect,
    required String serializedTimes,
  }) async {
    final prefs = await _prefs;
    await prefs.setString(_keyHomePrayerCacheDate, dateKey);
    await prefs.setDouble(_keyHomePrayerCacheLat, latitude);
    await prefs.setDouble(_keyHomePrayerCacheLng, longitude);
    await prefs.setString(_keyHomePrayerCacheSect, sect);
    await prefs.setString(_keyHomePrayerCacheJson, serializedTimes);
  }

  static Future<bool> get homeNotificationPrompted async {
    final prefs = await _prefs;
    return prefs.getBool(_keyHomeNotificationPrompted) ?? false;
  }

  static Future<void> setHomeNotificationPrompted(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyHomeNotificationPrompted, value);
  }

  static Future<String?> get homeIslamicEventsJson async {
    final prefs = await _prefs;
    return prefs.getString(_keyHomeIslamicEventsJson);
  }

  static Future<void> setHomeIslamicEventsJson(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyHomeIslamicEventsJson, value);
  }

  static Future<int> get homeIslamicEventsLastYear async {
    final prefs = await _prefs;
    return prefs.getInt(_keyHomeIslamicEventsLastYear) ?? 0;
  }

  static Future<void> setHomeIslamicEventsLastYear(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyHomeIslamicEventsLastYear, value);
  }

  static Future<String?> get homePrayerStreakJson async {
    final prefs = await _prefs;
    return prefs.getString(_keyHomePrayerStreakJson);
  }

  static Future<void> setHomePrayerStreakJson(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyHomePrayerStreakJson, value);
  }

  static Future<String?> get prayerSettingsJson async {
    final prefs = await _prefs;
    return prefs.getString(_keyPrayerSettingsJson);
  }

  static Future<void> setPrayerSettingsJson(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyPrayerSettingsJson, value);
  }

  /// Master switch for native Prayer Alarms (AlarmKit / full-screen intent).
  /// Defaults to off so existing users keep soft notifications only.
  static Future<bool> get prayerAlarmsEnabled async {
    final prefs = await _prefs;
    return prefs.getBool(_keyPrayerAlarmsEnabled) ?? false;
  }

  static Future<void> setPrayerAlarmsEnabled(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyPrayerAlarmsEnabled, value);
  }

  /// Master switch for Prayer Live Activity (iOS ActivityKit / Android ongoing).
  /// Returns `null` when the user has never set a preference (caller may default
  /// to ON on supported platforms).
  static Future<bool?> get prayerLiveActivityEnabledPreference async {
    final prefs = await _prefs;
    if (!prefs.containsKey(_keyPrayerLiveActivityEnabled)) return null;
    return prefs.getBool(_keyPrayerLiveActivityEnabled);
  }

  static Future<bool> get prayerLiveActivityEnabled async {
    return (await prayerLiveActivityEnabledPreference) ?? false;
  }

  static Future<void> setPrayerLiveActivityEnabled(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyPrayerLiveActivityEnabled, value);
  }

  static Future<int> get prayerAlarmSnoozeMinutes async {
    final prefs = await _prefs;
    return prefs.getInt(_keyPrayerAlarmSnoozeMinutes) ??
        defaultPrayerAlarmSnoozeMinutes;
  }

  static Future<void> setPrayerAlarmSnoozeMinutes(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(
      _keyPrayerAlarmSnoozeMinutes,
      value.clamp(1, 60),
    );
  }

  static Future<String?> get focusSettingsJson async {
    final prefs = await _prefs;
    return prefs.getString(_keyFocusSettingsJson);
  }

  static Future<void> setFocusSettingsJson(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyFocusSettingsJson, value);
  }

  static Future<String?> get focusScheduleJson async {
    final prefs = await _prefs;
    return prefs.getString(_keyFocusScheduleJson);
  }

  static Future<void> setFocusScheduleJson(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyFocusScheduleJson, value);
  }

  static Future<bool?> get darkModeEnabled async {
    final prefs = await _prefs;
    return prefs.getBool(_keyDarkModeEnabled);
  }

  static Future<void> setDarkModeEnabled(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyDarkModeEnabled, value);
  }

  static Future<bool> get appNotificationsEnabled async {
    final prefs = await _prefs;
    return prefs.getBool(_keyAppNotificationsEnabled) ?? true;
  }

  static Future<void> setAppNotificationsEnabled(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyAppNotificationsEnabled, value);
  }

  /// Set by native code after timezone/clock changes so Flutter force-reschedules
  /// soft prayer reminders with recalculated wall times.
  static Future<bool> get needsPrayerNotificationReschedule async {
    final prefs = await _prefs;
    return prefs.getBool(_keyNeedsPrayerNotificationReschedule) ?? false;
  }

  static Future<void> setNeedsPrayerNotificationReschedule(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyNeedsPrayerNotificationReschedule, value);
  }

  static Future<double?> get nearbyMosquesCacheLatitude async {
    final prefs = await _prefs;
    return prefs.getDouble(_keyNearbyMosquesCacheLat);
  }

  static Future<double?> get nearbyMosquesCacheLongitude async {
    final prefs = await _prefs;
    return prefs.getDouble(_keyNearbyMosquesCacheLng);
  }

  static Future<int?> get nearbyMosquesCacheFetchedMs async {
    final prefs = await _prefs;
    return prefs.getInt(_keyNearbyMosquesCacheFetchedMs);
  }

  static Future<String?> get nearbyMosquesCacheJson async {
    final prefs = await _prefs;
    return prefs.getString(_keyNearbyMosquesCacheJson);
  }

  static Future<void> setNearbyMosquesCache({
    required double latitude,
    required double longitude,
    required int fetchedMs,
    required String json,
  }) async {
    final prefs = await _prefs;
    await prefs.setDouble(_keyNearbyMosquesCacheLat, latitude);
    await prefs.setDouble(_keyNearbyMosquesCacheLng, longitude);
    await prefs.setInt(_keyNearbyMosquesCacheFetchedMs, fetchedMs);
    await prefs.setString(_keyNearbyMosquesCacheJson, json);
  }

  static Future<void> ensureAppFirstOpenRecorded() async {
    final prefs = await _prefs;
    if (!prefs.containsKey(_keyAppFirstOpenMs)) {
      await prefs.setInt(
        _keyAppFirstOpenMs,
        DateTime.now().millisecondsSinceEpoch,
      );
    }
  }

  static Future<int> get appReviewSessionCount async {
    final prefs = await _prefs;
    return prefs.getInt(_keyAppReviewSessionCount) ?? 0;
  }

  static Future<DateTime?> get appReviewLastSessionAt async {
    final prefs = await _prefs;
    final ms = prefs.getInt(_keyAppReviewLastSessionMs);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  static Future<void> setAppReviewSession({
    required int count,
    required DateTime at,
  }) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyAppReviewSessionCount, count);
    await prefs.setInt(_keyAppReviewLastSessionMs, at.millisecondsSinceEpoch);
  }

  static Future<DateTime?> get appReviewLastAutomaticAt async {
    final prefs = await _prefs;
    final ms = prefs.getInt(_keyAppReviewLastAutomaticMs);
    if (ms == null) return null;
    return DateTime.fromMillisecondsSinceEpoch(ms);
  }

  static Future<List<DateTime>> get appReviewAutomaticHistory async {
    final prefs = await _prefs;
    final raw = prefs.getString(_keyAppReviewAutomaticHistoryJson);
    if (raw == null || raw.isEmpty) return const <DateTime>[];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return [
        for (final item in list)
          DateTime.fromMillisecondsSinceEpoch((item as num).toInt()),
      ];
    } catch (_) {
      return const <DateTime>[];
    }
  }

  static Future<void> recordAppReviewAutomaticPrompt(DateTime at) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyAppReviewLastAutomaticMs, at.millisecondsSinceEpoch);
    final previous = await appReviewAutomaticHistory;
    final next = <int>[
      for (final stamp in previous) stamp.millisecondsSinceEpoch,
      at.millisecondsSinceEpoch,
    ];
    await prefs.setString(_keyAppReviewAutomaticHistoryJson, jsonEncode(next));
    await prefs.setBool(_keyAppReviewPromptCompleted, true);
  }

  /// One-time: users who already saw the old one-shot prompt start a cooldown.
  static Future<void> migrateLegacyAppReviewPromptIfNeeded({
    DateTime? now,
  }) async {
    final prefs = await _prefs;
    if (prefs.containsKey(_keyAppReviewLastAutomaticMs)) return;
    if (!(prefs.getBool(_keyAppReviewPromptCompleted) ?? false)) return;
    final stamp = now ?? DateTime.now();
    await prefs.setInt(
      _keyAppReviewLastAutomaticMs,
      stamp.millisecondsSinceEpoch,
    );
    await prefs.setString(
      _keyAppReviewAutomaticHistoryJson,
      jsonEncode(<int>[stamp.millisecondsSinceEpoch]),
    );
  }

  static Future<bool> get focusAccessibilityDisclosureAccepted async {
    final prefs = await _prefs;
    return prefs.getBool(_keyFocusAccessibilityDisclosureAccepted) ?? false;
  }

  static Future<void> setFocusAccessibilityDisclosureAccepted(
    bool value,
  ) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyFocusAccessibilityDisclosureAccepted, value);
  }

  static Future<bool> get hasEverSubscribed async {
    final prefs = await _prefs;
    return (prefs.getBool(_keyHasEverSubscribed) ?? false) ||
        (prefs.getBool(_legacyKeyHasUsedIntroOffer) ?? false);
  }

  static Future<void> setHasEverSubscribed(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyHasEverSubscribed, value);
    await prefs.setBool(_legacyKeyHasUsedIntroOffer, value);
  }

  // Cached subscription active state — read on cold start to skip the loader.
  static Future<bool> get cachedSubscriptionActive async {
    final prefs = await _prefs;
    return prefs.getBool(_keySubscriptionActive) ?? false;
  }

  static Future<void> setCachedSubscriptionActive(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keySubscriptionActive, value);
    await prefs.setInt(
      _keySubscriptionCachedAtMs,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  static Future<bool> get hasUsedIntroOffer => hasEverSubscribed;

  static Future<void> setHasUsedIntroOffer(bool value) {
    return setHasEverSubscribed(value);
  }

  static Future<String?> get calculationMethod async {
    final prefs = await _prefs;
    return prefs.getString(_keyCalculationMethod);
  }

  static Future<void> setCalculationMethod(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyCalculationMethod, value);
  }

  static Future<String?> get asrMethod async {
    final prefs = await _prefs;
    return prefs.getString(_keyAsrMethod);
  }

  static Future<void> setAsrMethod(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyAsrMethod, value);
  }

  // Cycle Mode
  /// Full Cycle Mode settings (migrates legacy enabled/start keys once).
  /// Also applies [CycleModeData.purgeLegacyEditBugHistory] so incorrect
  /// history from the earlier Edit-auto-enable bug is cleared.
  static Future<CycleModeData> get cycleModeData async {
    final prefs = await _prefs;
    CycleModeData data;
    final raw = prefs.getString(_keyCycleModeDataJson);
    if (raw != null && raw.isNotEmpty) {
      try {
        final map = jsonDecode(raw) as Map<String, dynamic>;
        data = CycleModeData.fromJson(map);
      } catch (_) {
        data = await _migrateLegacyCycleModeKeys(prefs);
      }
    } else {
      data = await _migrateLegacyCycleModeKeys(prefs);
    }
    return _applyCycleModeCleanups(data);
  }

  static Future<CycleModeData> _migrateLegacyCycleModeKeys(
    SharedPreferences prefs,
  ) async {
    final enabled = prefs.getBool(_keyCycleModeEnabled) ?? false;
    final startMs = prefs.getInt(_keyCycleModeStartDateMs);
    final startDate = startMs != null
        ? DateTime.fromMillisecondsSinceEpoch(startMs)
        : DateTime.now();
    final migrated = CycleModeData(
      isEnabled: enabled,
      startDate: startDate,
    );
    await setCycleModeData(migrated);
    return migrated;
  }

  static Future<CycleModeData> _applyCycleModeCleanups(
    CycleModeData data,
  ) async {
    final prefs = await _prefs;
    final applied = prefs.getInt(_keyCycleModeCleanupVersion) ?? 0;
    final purged = data.purgeLegacyEditBugHistory();
    final changed = purged.toJson() != data.toJson();
    if (changed || applied < _cycleModeCleanupVersion) {
      await setCycleModeData(purged);
      await prefs.setInt(
        _keyCycleModeCleanupVersion,
        _cycleModeCleanupVersion,
      );
    }
    return purged;
  }

  static Future<void> setCycleModeData(CycleModeData data) async {
    final prefs = await _prefs;
    await prefs.setString(_keyCycleModeDataJson, data.toJson());
    // Keep legacy keys in sync for older readers / debugging.
    await prefs.setBool(_keyCycleModeEnabled, data.isEnabled);
    if (data.isEnabled) {
      await prefs.setInt(
        _keyCycleModeStartDateMs,
        DateTime(data.startDate.year, data.startDate.month, data.startDate.day)
            .millisecondsSinceEpoch,
      );
    } else {
      await prefs.remove(_keyCycleModeStartDateMs);
    }
  }

  // Prayer Reminder
  static Future<int?> get lastPrayerReminderPromptMs async {
    final prefs = await _prefs;
    return prefs.getInt(_keyLastPrayerReminderPromptMs);
  }

  static Future<void> setLastPrayerReminderPromptMs(int value) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyLastPrayerReminderPromptMs, value);
  }

  /// Keys like `yyyy-MM-dd:maghrib` — one reminder prompt per prayer per day.
  static Future<Set<String>> get prayerReminderPromptedKeys async {
    final prefs = await _prefs;
    final raw = prefs.getStringList(_keyPrayerReminderPromptedKeys) ?? const [];
    return raw.toSet();
  }

  static Future<void> markPrayerReminderPrompted(String key) async {
    final prefs = await _prefs;
    final keys = (prefs.getStringList(_keyPrayerReminderPromptedKeys) ??
            <String>[])
        .toSet()
      ..add(key);
    // Keep only recent keys to avoid unbounded growth.
    final trimmed = keys.toList()..sort();
    final keep = trimmed.length <= 40
        ? trimmed
        : trimmed.sublist(trimmed.length - 40);
    await prefs.setStringList(_keyPrayerReminderPromptedKeys, keep);
  }

  static Future<bool> get streakRestoreUsed async {
    final prefs = await _prefs;
    return prefs.getBool(_keyStreakRestoreUsed) ?? false;
  }

  static Future<void> setStreakRestoreUsed(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyStreakRestoreUsed, value);
  }
  
  // Daily Checklist
  static Future<String?> get dailyChecklistJson async {
    final prefs = await _prefs;
    return prefs.getString(_keyDailyChecklistJson);
  }

  static Future<void> setDailyChecklistJson(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyDailyChecklistJson, value);
  }

  // Generic string getter/setter for services
  static Future<String?> getString(String key) async {
    final prefs = await _prefs;
    return prefs.getString(key);
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await _prefs;
    await prefs.setString(key, value);
  }

  static Future<int?> getInt(String key) async {
    final prefs = await _prefs;
    return prefs.getInt(key);
  }

  static Future<void> setInt(String key, int value) async {
    final prefs = await _prefs;
    await prefs.setInt(key, value);
  }

  static Future<void> remove(String key) async {
    final prefs = await _prefs;
    await prefs.remove(key);
  }
}
