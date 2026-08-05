import 'package:shared_preferences/shared_preferences.dart';

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
  static const String _keyFocusAccessibilityDisclosureAccepted =
      'focus_accessibility_disclosure_accepted';
  static const String _keyHasEverSubscribed = 'has_ever_subscribed';
  static const String _legacyKeyHasUsedIntroOffer = 'has_used_intro_offer';

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

  // --- Tajweed (AI practice) ---
  static const String _keyTajweedEnabled = 'tajweed_enabled';

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

  static Future<bool> get shouldShowAppReviewPrompt async {
    final prefs = await _prefs;
    if (prefs.getBool(_keyAppReviewPromptCompleted) ?? false) {
      return false;
    }
    final firstMs = prefs.getInt(_keyAppFirstOpenMs);
    if (firstMs == null) return false;
    final elapsed = DateTime.now().millisecondsSinceEpoch - firstMs;
    return elapsed >= Duration.zero.inMilliseconds;
  }

  static Future<void> setAppReviewPromptCompleted() async {
    final prefs = await _prefs;
    await prefs.setBool(_keyAppReviewPromptCompleted, true);
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

  static Future<bool> get hasUsedIntroOffer => hasEverSubscribed;

  static Future<void> setHasUsedIntroOffer(bool value) {
    return setHasEverSubscribed(value);
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

  /// Controlled rollout flag for AI Tajweed. Default false.
  static Future<bool> get tajweedEnabled async {
    final prefs = await _prefs;
    return prefs.getBool(_keyTajweedEnabled) ?? false;
  }

  static Future<void> setTajweedEnabled(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyTajweedEnabled, value);
  }
}
