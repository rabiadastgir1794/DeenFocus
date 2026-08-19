import 'dart:convert';
import 'dart:io';

import '../../../core/services/quran_translation_service.dart';

/// Loads and caches per-ayah translation text from a downloaded JSON pack.
/// Same surah/ayah JSON shape as the legacy bundled `english_translation.json`.
class QuranTranslationTexts {
  QuranTranslationTexts._(this.languageCode, this._byKey);

  final String languageCode;
  final Map<String, String> _byKey;

  static final Map<String, QuranTranslationTexts> _cache =
      <String, QuranTranslationTexts>{};
  static final Map<String, Future<QuranTranslationTexts>> _loading =
      <String, Future<QuranTranslationTexts>>{};

  static Future<QuranTranslationTexts> load(String languageCode) async {
    final cached = _cache[languageCode];
    if (cached != null) return cached;

    final pending = _loading[languageCode];
    if (pending != null) return pending;

    final future = _loadInternal(languageCode);
    _loading[languageCode] = future;
    try {
      return await future;
    } finally {
      _loading.remove(languageCode);
    }
  }

  static void evict(String languageCode) {
    _cache.remove(languageCode);
  }

  static Future<QuranTranslationTexts> _loadInternal(String languageCode) async {
    final path = await QuranTranslationService.localPath(languageCode);
    if (path == null) {
      return QuranTranslationTexts._(languageCode, const {});
    }

    final raw = await File(path).readAsString();
    final data = (jsonDecode(raw) as List<dynamic>).cast<Map>();
    final byKey = <String, String>{};

    for (final surah in data) {
      final surahNumber = int.tryParse('${surah['@index']}');
      if (surahNumber == null) continue;
      final ayat = surah['aya'];
      if (ayat is! List) continue;
      for (final ayah in ayat) {
        if (ayah is! Map) continue;
        final ayahNumber = int.tryParse('${ayah['@index']}');
        if (ayahNumber == null) continue;
        byKey['$surahNumber:$ayahNumber'] = '${ayah['@text'] ?? ''}';
      }
    }

    final loaded = QuranTranslationTexts._(languageCode, byKey);
    _cache[languageCode] = loaded;
    return loaded;
  }

  String? textFor(int surah, int ayah) => _byKey['$surah:$ayah'];
}
