import '../../../l10n/app_localizations.dart';

/// Languages that have Islamic Library content overlays.
/// Arabic covers both ar_SA and ar_EG. Portuguese covers pt_BR.
const Set<String> libraryContentLanguages = {
  'ar',
  'az',
  'de',
  'en',
  'es',
  'fr',
  'hi',
  'it',
  'nl',
  'pt',
  'ro',
  'ru',
  'zh',
};

/// Normalizes `en`, `ar_SA`, `pt-BR`, and similar tags to a library content code.
String libraryContentLanguageCode(String languageCode) {
  final code = languageCode.split(RegExp(r'[_-]')).first.toLowerCase();
  if (libraryContentLanguages.contains(code)) return code;
  return 'en';
}

String libraryContentLanguageOf(AppLocalizations l10n) =>
    libraryContentLanguageCode(l10n.localeName);
