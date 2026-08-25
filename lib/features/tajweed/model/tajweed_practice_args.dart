/// Navigation payload for `TajweedPracticeScreen` (passed via go_router `extra`).
class TajweedPracticeArgs {
  const TajweedPracticeArgs({
    required this.surah,
    required this.ayah,
    required this.arabicText,
    required this.arabicFontFamily,
    this.arabicFontFamilyFallback,
    this.lexicalReferenceArabic,
    this.surahName,
    this.translation,
    this.freePreview = false,
  });

  final int surah;
  final int ayah;

  /// Arabic orthography for the script selected in Reading Settings
  /// (`uthmani` / `indopak`) — same corpus as the surah listing.
  final String arabicText;

  /// Bundled / system display font for [arabicText].
  final String arabicFontFamily;

  /// Extra families when [arabicFontFamily] is a system face.
  final List<String>? arabicFontFamilyFallback;

  /// Canonical word-boundary text for lexical alignment (Uthmani for the same
  /// ayah). When null, native falls back to [arabicText].
  final String? lexicalReferenceArabic;

  /// Display-only, e.g. "Al-Fatiha".
  final String? surahName;

  /// Display-only English translation shown alongside the Arabic reference.
  final String? translation;

  /// When true, practice works without enabling AI Tajweed in Settings or
  /// an active subscription (single demo ayah only).
  final bool freePreview;

  String get ref => '$surah:$ayah';
}
