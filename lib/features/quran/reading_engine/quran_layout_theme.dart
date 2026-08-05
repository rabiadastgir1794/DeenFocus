/// Visual layout for Quran ayah cards:
/// - [classic]: bordered soft cards with circle ayah badges
/// - [simple]: flat list with dividers, no card chrome
/// - [color]: classic card chrome + per-word color bands
enum QuranLayoutTheme {
  classic,
  simple,
  color;

  static QuranLayoutTheme fromName(String? name) {
    return switch (name) {
      'simple' => QuranLayoutTheme.simple,
      'color' => QuranLayoutTheme.color,
      _ => QuranLayoutTheme.classic,
    };
  }
}
