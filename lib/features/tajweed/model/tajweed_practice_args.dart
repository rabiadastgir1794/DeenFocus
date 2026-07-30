/// Navigation payload for `TajweedPracticeScreen` (passed via go_router `extra`).
class TajweedPracticeArgs {
  const TajweedPracticeArgs({
    required this.surah,
    required this.ayah,
    required this.arabicText,
    required this.arabicFontFamily,
    this.surahName,
    this.translation,
  });

  final int surah;
  final int ayah;

  /// Arabic orthography for the script selected in Reading Settings
  /// (`uthmani` / `indopak`) — same corpus as the surah listing.
  final String arabicText;

  /// Bundled display font for [arabicText] (`UthmanicHafs` / `NooreHuda`).
  final String arabicFontFamily;

  /// Display-only, e.g. "Al-Fatiha".
  final String? surahName;

  /// Display-only English translation shown alongside the Arabic reference.
  final String? translation;

  String get ref => '$surah:$ayah';
}
