/// Arabic Quran script / orthography the reader can choose.
///
/// Each value maps to:
/// - a text corpus under `assets/quran/text/<name>.json`
/// - a bundled display font under `assets/fonts/`
///
/// Page/juz layout still uses Madani Mushaf metadata (`assets/quran/uthmani.json`)
/// — IndoPak printed page numbers are not shipped yet.
enum QuranScript { uthmani, indopak }

extension QuranScriptX on QuranScript {
  String get assetPath => 'assets/quran/text/$name.json';

  String get fontFamily => switch (this) {
    QuranScript.uthmani => 'UthmanicHafs',
    QuranScript.indopak => 'NooreHuda',
  };

  static QuranScript fromName(String? name) {
    return QuranScript.values.firstWhere(
      (s) => s.name == name,
      orElse: () => QuranScript.uthmani,
    );
  }
}
