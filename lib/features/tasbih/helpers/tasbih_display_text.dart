import '../../../l10n/app_localizations.dart';
import '../data/tasbih_local_repository.dart';

String tasbihDisplayName(AppLocalizations l10n, TasbihItem item) {
  if (item.isCustom) return item.transliteration;
  return switch (item.id) {
    'subhanallah' => l10n.tasbihNameSubhanAllah,
    'alhamdulillah' => l10n.tasbihNameAlhamdulillah,
    'allahu_akbar' => l10n.tasbihNameAllahuAkbar,
    'la_ilaha_illallah' => l10n.tasbihNameLaIlahaIllallah,
    'astaghfirullah' => l10n.tasbihNameAstaghfirullah,
    'la_hawla' => l10n.tasbihNameLaHawla,
    'subhanallahi_wa_bihamdihi' => l10n.tasbihNameSubhanAllahiWaBihamdihi,
    'hasbunallahu' => l10n.tasbihNameHasbunallahu,
    _ => item.transliteration,
  };
}

String tasbihDisplayMeaning(AppLocalizations l10n, TasbihItem item) {
  if (item.isCustom) return item.meaning;
  return switch (item.id) {
    'subhanallah' => l10n.tasbihMeaningSubhanAllah,
    'alhamdulillah' => l10n.tasbihMeaningAlhamdulillah,
    'allahu_akbar' => l10n.tasbihMeaningAllahuAkbar,
    'la_ilaha_illallah' => l10n.tasbihMeaningLaIlahaIllallah,
    'astaghfirullah' => l10n.tasbihMeaningAstaghfirullah,
    'la_hawla' => l10n.tasbihMeaningLaHawla,
    'subhanallahi_wa_bihamdihi' => l10n.tasbihMeaningSubhanAllahiWaBihamdihi,
    'hasbunallahu' => l10n.tasbihMeaningHasbunallahu,
    _ => item.meaning,
  };
}

bool tasbihShowsName(TasbihItem item, String name) {
  final trimmed = name.trim();
  return trimmed.isNotEmpty && trimmed != item.label.trim();
}
