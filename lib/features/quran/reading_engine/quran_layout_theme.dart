/// Visual layout for Quran reading:
/// - [classic]: soft bordered ayah cards / paper page frame
/// - [simple]: flat list with dividers, no page chrome
/// - [color]: classic chrome + per-word color bands
enum QuranLayoutTheme {
  classic,
  simple,
  color;

  /// True for layouts that use the paper page frame (not Simple).
  bool get isMushafStyle => this == classic || this == color;

  static QuranLayoutTheme fromName(String? name) {
    return switch (name) {
      'simple' => QuranLayoutTheme.simple,
      'color' => QuranLayoutTheme.color,
      _ => QuranLayoutTheme.classic,
    };
  }
}
