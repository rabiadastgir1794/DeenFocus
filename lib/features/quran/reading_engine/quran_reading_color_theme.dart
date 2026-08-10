/// Color themes for Quran reading surfaces (background, paper, accents).
/// Each theme adapts to light and dark app brightness.
enum QuranReadingColorTheme {
  parchment,
  emerald,
  midnight;

  static QuranReadingColorTheme fromName(String? name) {
    return switch (name) {
      'parchment' => QuranReadingColorTheme.parchment,
      'midnight' => QuranReadingColorTheme.midnight,
      _ => QuranReadingColorTheme.emerald,
    };
  }
}
