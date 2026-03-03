import 'package:flutter/material.dart';

/// One app-supported language for the picker: locale, display label (in that language), flag emoji.
class AppLanguage {
  const AppLanguage({
    required this.locale,
    required this.label,
    required this.flag,
  });

  final Locale locale;
  final String label;
  final String flag;

  String get localeCode {
    if (locale.countryCode != null && locale.countryCode!.isNotEmpty) {
      return '${locale.languageCode}_${locale.countryCode}';
    }
    return locale.languageCode;
  }
}

/// All languages shown in the app language picker (label in its own language).
const List<AppLanguage> kAppLanguages = [
  AppLanguage(locale: Locale('en'), label: 'English', flag: '🇬🇧'),
  AppLanguage(locale: Locale('ar', 'SA'), label: 'العربية (السعودية)', flag: '🇸🇦'),
  AppLanguage(locale: Locale('ar', 'EG'), label: 'العربية (مصر)', flag: '🇪🇬'),
  AppLanguage(locale: Locale('zh'), label: '中文', flag: '🇨🇳'),
  AppLanguage(locale: Locale('hi'), label: 'हिन्दी', flag: '🇮🇳'),
  AppLanguage(locale: Locale('es'), label: 'Español', flag: '🇪🇸'),
  AppLanguage(locale: Locale('fr'), label: 'Français', flag: '🇫🇷'),
  AppLanguage(locale: Locale('de'), label: 'Deutsch', flag: '🇩🇪'),
  AppLanguage(locale: Locale('ru'), label: 'Русский', flag: '🇷🇺'),
  AppLanguage(locale: Locale('pt', 'BR'), label: 'Português (Brasil)', flag: '🇧🇷'),
  AppLanguage(locale: Locale('it'), label: 'Italiano', flag: '🇮🇹'),
  AppLanguage(locale: Locale('ro'), label: 'Română', flag: '🇷🇴'),
  AppLanguage(locale: Locale('az'), label: 'Azərbaycanca', flag: '🇦🇿'),
  AppLanguage(locale: Locale('nl'), label: 'Nederlands', flag: '🇳🇱'),
];

/// Supported locales for MaterialApp (all picker languages; delegate falls back to en).
List<Locale> get kSupportedLocales =>
    kAppLanguages.map((l) => l.locale).toList();
