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
  static const String _keyDarkModeEnabled = 'dark_mode_enabled';
  static const String _keyNearbyMosquesCacheLat = 'nearby_mosques_cache_lat';
  static const String _keyNearbyMosquesCacheLng = 'nearby_mosques_cache_lng';
  static const String _keyNearbyMosquesCacheFetchedMs =
      'nearby_mosques_cache_fetched_ms';
  static const String _keyNearbyMosquesCacheJson = 'nearby_mosques_cache_json';

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

  static Future<bool?> get darkModeEnabled async {
    final prefs = await _prefs;
    return prefs.getBool(_keyDarkModeEnabled);
  }

  static Future<void> setDarkModeEnabled(bool value) async {
    final prefs = await _prefs;
    await prefs.setBool(_keyDarkModeEnabled, value);
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
}
