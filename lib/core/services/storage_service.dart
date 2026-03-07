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
}
