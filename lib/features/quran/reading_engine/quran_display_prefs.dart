import '../../../core/services/storage_service.dart';
import 'quran_arabic_font.dart';
import 'quran_script.dart';

/// Current Reading Settings script + Arabic typeface from storage.
class QuranDisplayPrefs {
  const QuranDisplayPrefs({
    required this.script,
    required this.font,
  });

  final QuranScript script;
  final QuranArabicFont font;

  String? get fontFamily => font.fontFamily;
  List<String>? get fontFamilyFallback => font.fontFamilyFallback;

  static Future<QuranDisplayPrefs> load() async {
    final scriptName = await StorageService.quranScript;
    final fontName = await StorageService.quranArabicFont;
    final script = QuranScriptX.fromName(scriptName);
    return QuranDisplayPrefs(
      script: script,
      font: QuranArabicFont.resolve(savedName: fontName, script: script),
    );
  }
}
