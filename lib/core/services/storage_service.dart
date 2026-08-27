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
  static const String _keyQuranTranslationLanguage = 'quran_translation_language';
  static const String _keyQuranShowTransliteration = 'quran_show_transliteration';
  static const String _keyQuranLayoutTheme = 'quran_layout_theme';
  static const String _keyQuranReadingColorTheme = 'quran_reading_color_theme';
  static const String _keyQuranArabicFontSp = 'quran_arabic_font_sp';
  static const String _keyQuranEnglishFontSp = 'quran_english_font_sp';
  static const String _keyQuranArabicFont = 'quran_arabic_font';
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
  // v2: resets dismiss after layout fix so the Home promo can show again.
  static const String _keyHomeLiveActivityPromoDismissed =
      'home_live_activity_promo_dismissed_v2';
  static const String _keyHomeWidgetsPromoDismissed =
      'home_widgets_promo_dismissed';
  static const int defaultPrayerAlarmSnoozeMinutes = 10;

  /// Snooze durations offered in settings and on the full-screen alarm UI.
  static const List<int> prayerAlarmSnoozeOptionMinutes = <int>[5, 10, 15];

  // --- Quran Reading Engine (Phase 1: Surah / Juz / Page modes) ---
  static const String _keyQuranLastMode = 'quran_last_mode';
  static const String _keyQuranLastSurah = 'quran_last_surah';
  static const String _keyQuranLastAyah = 'quran_last_ayah';
  static const String _keyQuranLastPage = 'quran_last_page';
  static const String _keyQuranLastJuz = 'quran_last_juz';
  static const String _keyQuranLastReadAtMs = 'quran_last_read_at_ms';
  static const String _keyQuranTotalAyahsRead = 'quran_total_ayahs_read';
  static const String _keyQuranTotalPagesRead = 'quran_total_pages_read';
  static const String _keyQuranTotalReadingDurationMs =
      'quran_total_reading_duration_ms';
  static const String _keyQuranLastSessionAtMs = 'quran_last_session_at_ms';
  static const String _keyQuranLineSpacing = 'quran_line_spacing';
  static const String _keyQuranDefaultReadingMode =
      'quran_default_reading_mode';
  static const String _keyQuranRememberLastPosition =
      'quran_remember_last_position';
  static const String _keyQuranScript = 'quran_script';
  static const String _keyQuranPlaybackSpeed = 'quran_playback_speed';
  static const String _keyQuranPlaybackVolume = 'quran_playback_volume';
  static const String _keyQuranRepeatMode = 'quran_repeat_mode';
  static const String _keyQuranHighestPageCompleted =
      'quran_highest_page_completed';
  static const String _keyQuranBookmarksJson = 'quran_bookmarks_json';
  static const String _keyQuranLastListenedSurah = 'quran_last_listened_surah';
  static const String _keyQuranLastListenedSurahName =
      'quran_last_listened_surah_name';
  static const String _keyQuranLastListenedAyah = 'quran_last_listened_ayah';
  static const String _keyLastTajweedSurah = 'last_tajweed_surah';
  static const String _keyLastTajweedAyah = 'last_tajweed_ayah';
  static const String _keyLastTajweedSurahName = 'last_tajweed_surah_name';

  // --- Tajweed (AI practice) ---
  static const String _keyTajweedEnabled = 'tajweed_enabled';
  static const String _keyLibraryProgressJson = 'library_progress_json';
  static const String _keyDigitalBalanceGoalMinutes =
      'digital_balance_goal_minutes';
  static const int defaultDigitalBalanceGoalMinutes = 60;

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

  static Future<String> get quranTranslationLanguage async {
    final prefs = await _prefs;
    return prefs.getString(_keyQuranTranslationLanguage) ?? 'en';
  }

  static Future<void> setQuranTranslationLanguage(String languageCode) async {
    final prefs = await _prefs;
    await prefs.setString(_keyQuranTranslationLanguage, languageCode);
  }

  static Future<bool> get quranShowTransliteration async {
    final prefs = await _prefs;
    return prefs.getBool(_keyQuranShowTransliteration) ?? true;
  }

  static Future<void> setQuranShowTransliteration(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyQuranShowTransliteration, value);
  }

  static Future<String> get quranLayoutTheme async {
    final prefs = await _prefs;
    return prefs.getString(_keyQuranLayoutTheme) ?? 'classic';
  }

  static Future<void> setQuranLayoutTheme(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyQuranLayoutTheme, value);
  }

  static Future<String> get quranReadingColorTheme async {
    final prefs = await _prefs;
    return prefs.getString(_keyQuranReadingColorTheme) ?? 'emerald';
  }

  static Future<void> setQuranReadingColorTheme(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyQuranReadingColorTheme, value);
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
  /// Returns `null` when the user has never set a preference (treated as OFF
  /// until they enable from Home promo, Settings, or App Demo).
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

  /// Home "Live Prayer Updates" promo dismissed via X (without enabling).
  static Future<bool> get homeLiveActivityPromoDismissed async {
    final prefs = await _prefs;
    return prefs.getBool(_keyHomeLiveActivityPromoDismissed) ?? false;
  }

  static Future<void> setHomeLiveActivityPromoDismissed(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyHomeLiveActivityPromoDismissed, value);
  }

  static Future<bool> get homeWidgetsPromoDismissed async {
    final prefs = await _prefs;
    return prefs.getBool(_keyHomeWidgetsPromoDismissed) ?? false;
  }

  static Future<void> setHomeWidgetsPromoDismissed(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyHomeWidgetsPromoDismissed, value);
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

  // --- Continue Reading (last surah/ayah/page/juz across all modes) ---

  static Future<String?> get quranLastMode async {
    final prefs = await _prefs;
    return prefs.getString(_keyQuranLastMode);
  }

  static Future<int?> get quranLastSurah async {
    final prefs = await _prefs;
    return prefs.getInt(_keyQuranLastSurah);
  }

  static Future<int?> get quranLastAyah async {
    final prefs = await _prefs;
    return prefs.getInt(_keyQuranLastAyah);
  }

  static Future<int?> get quranLastPage async {
    final prefs = await _prefs;
    return prefs.getInt(_keyQuranLastPage);
  }

  static Future<int?> get quranLastJuz async {
    final prefs = await _prefs;
    return prefs.getInt(_keyQuranLastJuz);
  }

  static Future<int?> get quranLastReadAtMs async {
    final prefs = await _prefs;
    return prefs.getInt(_keyQuranLastReadAtMs);
  }

  static Future<void> setQuranContinueReading({
    required String mode,
    required int surah,
    required int ayah,
    required int page,
    required int juz,
  }) async {
    final prefs = await _prefs;
    await prefs.setString(_keyQuranLastMode, mode);
    await prefs.setInt(_keyQuranLastSurah, surah);
    await prefs.setInt(_keyQuranLastAyah, ayah);
    await prefs.setInt(_keyQuranLastPage, page);
    await prefs.setInt(_keyQuranLastJuz, juz);
    await prefs.setInt(
      _keyQuranLastReadAtMs,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  // --- Reading Progress (cumulative counters, no streaks/achievements) ---

  static Future<int> get quranTotalAyahsRead async {
    final prefs = await _prefs;
    return prefs.getInt(_keyQuranTotalAyahsRead) ?? 0;
  }

  static Future<int> get quranTotalPagesRead async {
    final prefs = await _prefs;
    return prefs.getInt(_keyQuranTotalPagesRead) ?? 0;
  }

  static Future<int> get quranTotalReadingDurationMs async {
    final prefs = await _prefs;
    return prefs.getInt(_keyQuranTotalReadingDurationMs) ?? 0;
  }

  static Future<int?> get quranLastSessionAtMs async {
    final prefs = await _prefs;
    return prefs.getInt(_keyQuranLastSessionAtMs);
  }

  static Future<void> addQuranReadingProgress({
    required int ayahsRead,
    required int pagesRead,
    required Duration duration,
  }) async {
    if (ayahsRead <= 0 && pagesRead <= 0 && duration <= Duration.zero) return;
    final prefs = await _prefs;
    final totalAyahs = (prefs.getInt(_keyQuranTotalAyahsRead) ?? 0) + ayahsRead;
    final totalPages = (prefs.getInt(_keyQuranTotalPagesRead) ?? 0) + pagesRead;
    final totalDurationMs =
        (prefs.getInt(_keyQuranTotalReadingDurationMs) ?? 0) +
        duration.inMilliseconds;
    await prefs.setInt(_keyQuranTotalAyahsRead, totalAyahs);
    await prefs.setInt(_keyQuranTotalPagesRead, totalPages);
    await prefs.setInt(_keyQuranTotalReadingDurationMs, totalDurationMs);
    await prefs.setInt(
      _keyQuranLastSessionAtMs,
      DateTime.now().millisecondsSinceEpoch,
    );
  }

  /// Highest Mushaf page marked read (cumulative: pages 1..N are complete).
  static Future<int> get quranHighestPageCompleted async {
    final prefs = await _prefs;
    return prefs.getInt(_keyQuranHighestPageCompleted) ?? 0;
  }

  static Future<void> markQuranPageCompleted(int page) async {
    if (page < 1) return;
    final prefs = await _prefs;
    final current = prefs.getInt(_keyQuranHighestPageCompleted) ?? 0;
    if (page > current) {
      await prefs.setInt(_keyQuranHighestPageCompleted, page);
    }
  }

  /// Clears continue reading, page progress, stats, bookmarks, and quick-action
  /// shortcuts. Display preferences (fonts, layout, translations) are kept.
  static Future<void> clearQuranReadingHistory() async {
    final prefs = await _prefs;
    await prefs.remove(_keyQuranLastMode);
    await prefs.remove(_keyQuranLastSurah);
    await prefs.remove(_keyQuranLastAyah);
    await prefs.remove(_keyQuranLastPage);
    await prefs.remove(_keyQuranLastJuz);
    await prefs.remove(_keyQuranLastReadAtMs);
    await prefs.remove(_keyQuranTotalAyahsRead);
    await prefs.remove(_keyQuranTotalPagesRead);
    await prefs.remove(_keyQuranTotalReadingDurationMs);
    await prefs.remove(_keyQuranLastSessionAtMs);
    await prefs.remove(_keyQuranHighestPageCompleted);
    await prefs.remove(_keyQuranBookmarksJson);
    await prefs.remove(_keyQuranLastListenedSurah);
    await prefs.remove(_keyQuranLastListenedSurahName);
    await prefs.remove(_keyQuranLastListenedAyah);
    await prefs.remove(_keyLastTajweedSurah);
    await prefs.remove(_keyLastTajweedAyah);
    await prefs.remove(_keyLastTajweedSurahName);
  }

  static Future<String?> get quranBookmarksJson async {
    final prefs = await _prefs;
    return prefs.getString(_keyQuranBookmarksJson);
  }

  static Future<void> setQuranBookmarksJson(String json) async {
    final prefs = await _prefs;
    await prefs.setString(_keyQuranBookmarksJson, json);
  }

  static Future<int?> get quranLastListenedSurah async {
    final prefs = await _prefs;
    return prefs.getInt(_keyQuranLastListenedSurah);
  }

  static Future<String?> get quranLastListenedSurahName async {
    final prefs = await _prefs;
    return prefs.getString(_keyQuranLastListenedSurahName);
  }

  static Future<int?> get quranLastListenedAyah async {
    final prefs = await _prefs;
    return prefs.getInt(_keyQuranLastListenedAyah);
  }

  static Future<void> setQuranLastListened({
    required int surahNumber,
    required int ayahNumber,
    required String surahName,
  }) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyQuranLastListenedSurah, surahNumber);
    await prefs.setInt(_keyQuranLastListenedAyah, ayahNumber);
    await prefs.setString(_keyQuranLastListenedSurahName, surahName);
  }

  static Future<int?> get lastTajweedSurah async {
    final prefs = await _prefs;
    return prefs.getInt(_keyLastTajweedSurah);
  }

  static Future<int?> get lastTajweedAyah async {
    final prefs = await _prefs;
    return prefs.getInt(_keyLastTajweedAyah);
  }

  static Future<String?> get lastTajweedSurahName async {
    final prefs = await _prefs;
    return prefs.getString(_keyLastTajweedSurahName);
  }

  static Future<void> setLastTajweedPractice({
    required int surah,
    required int ayah,
    required String surahName,
  }) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyLastTajweedSurah, surah);
    await prefs.setInt(_keyLastTajweedAyah, ayah);
    await prefs.setString(_keyLastTajweedSurahName, surahName);
  }

  // --- Reading Preferences ---

  static Future<double> get quranLineSpacing async {
    final prefs = await _prefs;
    return prefs.getDouble(_keyQuranLineSpacing) ?? 1.8;
  }

  static Future<void> setQuranLineSpacing(double value) async {
    final prefs = await _prefs;
    await prefs.setDouble(_keyQuranLineSpacing, value);
  }

  /// One of 'surah' | 'juz' | 'page' — see `ReadingMode`.
  static Future<String> get quranDefaultReadingMode async {
    final prefs = await _prefs;
    return prefs.getString(_keyQuranDefaultReadingMode) ?? 'surah';
  }

  static Future<void> setQuranDefaultReadingMode(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyQuranDefaultReadingMode, value);
  }

  static Future<bool> get quranRememberLastPosition async {
    final prefs = await _prefs;
    return prefs.getBool(_keyQuranRememberLastPosition) ?? true;
  }

  static Future<void> setQuranRememberLastPosition(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyQuranRememberLastPosition, value);
  }

  /// One of 'uthmani' | 'indopak' — see `QuranScript`.
  static Future<String> get quranScript async {
    final prefs = await _prefs;
    return prefs.getString(_keyQuranScript) ?? 'uthmani';
  }

  static Future<void> setQuranScript(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyQuranScript, value);
  }

  /// One of 'uthmanicHafs' | 'nooreHuda' | 'system' — see `QuranArabicFont`.
  /// Empty/missing means follow the selected script's default font.
  static Future<String?> get quranArabicFont async {
    final prefs = await _prefs;
    return prefs.getString(_keyQuranArabicFont);
  }

  static Future<void> setQuranArabicFont(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyQuranArabicFont, value);
  }

  // --- Audio Preferences ---

  static Future<double> get quranPlaybackSpeed async {
    final prefs = await _prefs;
    return prefs.getDouble(_keyQuranPlaybackSpeed) ?? 1.0;
  }

  static Future<void> setQuranPlaybackSpeed(double value) async {
    final prefs = await _prefs;
    await prefs.setDouble(_keyQuranPlaybackSpeed, value);
  }

  static Future<double> get quranPlaybackVolume async {
    final prefs = await _prefs;
    return prefs.getDouble(_keyQuranPlaybackVolume) ?? 1.0;
  }

  static Future<void> setQuranPlaybackVolume(double value) async {
    final prefs = await _prefs;
    await prefs.setDouble(_keyQuranPlaybackVolume, value);
  }

  /// One of 'off' | 'ayah' | 'surah' — see `QuranRepeatMode`.
  static Future<String> get quranRepeatMode async {
    final prefs = await _prefs;
    return prefs.getString(_keyQuranRepeatMode) ?? 'off';
  }

  static Future<void> setQuranRepeatMode(String value) async {
    final prefs = await _prefs;
    await prefs.setString(_keyQuranRepeatMode, value);
  }

  /// Controlled rollout flag for AI Tajweed. Default false (paid feature).
  static Future<bool> get tajweedEnabled async {
    final prefs = await _prefs;
    return prefs.getBool(_keyTajweedEnabled) ?? false;
  }

  static Future<void> setTajweedEnabled(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyTajweedEnabled, value);
  }

  static Future<String?> get libraryProgressJson async {
    final prefs = await _prefs;
    return prefs.getString(_keyLibraryProgressJson);
  }

  static Future<void> setLibraryProgressJson(String json) async {
    final prefs = await _prefs;
    await prefs.setString(_keyLibraryProgressJson, json);
  }

  static Future<int> get digitalBalanceGoalMinutes async {
    final prefs = await _prefs;
    return prefs.getInt(_keyDigitalBalanceGoalMinutes) ??
        defaultDigitalBalanceGoalMinutes;
  }

  static Future<void> setDigitalBalanceGoalMinutes(int minutes) async {
    final prefs = await _prefs;
    await prefs.setInt(_keyDigitalBalanceGoalMinutes, minutes);
  }
}
