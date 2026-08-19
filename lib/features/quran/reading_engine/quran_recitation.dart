/// Shared per-ayah recitation audio source, used by every reading mode.
///
/// Extracted from the original Surah reading screen so Juz/Page screens
/// don't duplicate the CDN URL scheme. The Surah screen now imports this
/// constant/function too instead of keeping its own private copy.
class QuranRecitation {
  const QuranRecitation._();

  static const int defaultReciterId = 1;
  static const String _baseUrl =
      'https://the-quran-project.github.io/Quran-Audio/Data';

  static String audioUrl(
    int surahNumber,
    int ayahNumber, {
    int reciterId = defaultReciterId,
  }) {
    return '$_baseUrl/$reciterId/${surahNumber}_$ayahNumber.mp3';
  }
}
