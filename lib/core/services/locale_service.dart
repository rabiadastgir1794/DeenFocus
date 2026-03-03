import 'package:flutter/material.dart';

import 'storage_service.dart';

/// Holds the app's current locale, persists it, and notifies when it changes.
/// Use with Provider so the app rebuilds when locale changes.
class LocaleService extends ChangeNotifier {
  LocaleService() {
    _loadSavedLocale();
  }

  Locale _locale = const Locale('en');

  Locale get locale => _locale;

  String get localeCode {
    if (_locale.countryCode != null && _locale.countryCode!.isNotEmpty) {
      return '${_locale.languageCode}_${_locale.countryCode}';
    }
    return _locale.languageCode;
  }

  Future<void> _loadSavedLocale() async {
    final code = await StorageService.localeCode;
    if (code != null && code.isNotEmpty) {
      _locale = _localeFromCode(code);
      notifyListeners();
    }
  }

  Future<void> setLocale(Locale value) async {
    if (_locale == value) return;
    _locale = value;
    final code = value.countryCode != null && value.countryCode!.isNotEmpty
        ? '${value.languageCode}_${value.countryCode}'
        : value.languageCode;
    await StorageService.setLocaleCode(code);
    notifyListeners();
  }

  /// Set locale from a stored code string (e.g. 'en', 'ar_SA').
  Future<void> setLocaleFromCode(String code) async {
    final newLocale = _localeFromCode(code);
    await setLocale(newLocale);
  }

  static Locale _localeFromCode(String code) {
    final parts = code.split('_');
    if (parts.length >= 2) {
      return Locale(parts[0], parts[1]);
    }
    return Locale(code);
  }
}
