/// Lightweight Latin transliteration for Quran ayah display.
///
/// Not a scholarly tajweed transliteration — strips diacritics and maps
/// Arabic letters to a readable Latin form for learners.
abstract final class QuranTransliteration {
  static String of(String arabic) {
    final stripped = arabic.replaceAll(
      RegExp(r'[\u064B-\u065F\u0670\u0640\u06D6-\u06ED]'),
      '',
    );
    final buffer = StringBuffer();
    for (final rune in stripped.runes) {
      buffer.write(_map[rune] ?? String.fromCharCode(rune));
    }
    return buffer.toString().trim();
  }

  static const Map<int, String> _map = {
    0x0621: "'",
    0x0622: 'aa',
    0x0623: 'a',
    0x0624: 'u',
    0x0625: 'i',
    0x0626: 'a',
    0x0627: 'a',
    0x0628: 'b',
    0x0629: 'h',
    0x062A: 't',
    0x062B: 'th',
    0x062C: 'j',
    0x062D: 'h',
    0x062E: 'kh',
    0x062F: 'd',
    0x0630: 'dh',
    0x0631: 'r',
    0x0632: 'z',
    0x0633: 's',
    0x0634: 'sh',
    0x0635: 's',
    0x0636: 'd',
    0x0637: 't',
    0x0638: 'z',
    0x0639: 'a',
    0x063A: 'gh',
    0x0641: 'f',
    0x0642: 'q',
    0x0643: 'k',
    0x0644: 'l',
    0x0645: 'm',
    0x0646: 'n',
    0x0647: 'h',
    0x0648: 'w',
    0x0649: 'a',
    0x064A: 'y',
    0x0671: 'a',
    0x06CC: 'y',
    0x06A9: 'k',
    0x06AF: 'g',
    0x06BE: 'h',
    0x06C1: 'h',
    0x06D2: 'ay',
    0x06D3: 'ay',
    0xFEFC: 'la',
    0x20: ' ',
  };
}
