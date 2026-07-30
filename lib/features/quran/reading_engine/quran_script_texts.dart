import 'dart:convert';

import 'package:flutter/services.dart';

import 'quran_script.dart';

/// Loads and caches the per-ayah Arabic text for a [QuranScript].
/// English translation and surah metadata stay in Hive; only the Arabic
/// orthography switches with the script preference.
class QuranScriptTexts {
  QuranScriptTexts._(this.script, this._byKey);

  final QuranScript script;
  final Map<String, String> _byKey;

  static final Map<QuranScript, QuranScriptTexts> _cache =
      <QuranScript, QuranScriptTexts>{};
  static final Map<QuranScript, Future<QuranScriptTexts>> _loading =
      <QuranScript, Future<QuranScriptTexts>>{};

  static Future<QuranScriptTexts> load(QuranScript script) async {
    final cached = _cache[script];
    if (cached != null) return cached;

    final pending = _loading[script];
    if (pending != null) return pending;

    final future = _loadInternal(script);
    _loading[script] = future;
    try {
      return await future;
    } finally {
      _loading.remove(script);
    }
  }

  static Future<QuranScriptTexts> _loadInternal(QuranScript script) async {
    final raw = await rootBundle.loadString(script.assetPath);
    final decoded = jsonDecode(raw) as Map<String, dynamic>;
    final ayahs = (decoded['ayahs'] as List<dynamic>).cast<Map<String, dynamic>>();
    final byKey = <String, String>{
      for (final a in ayahs)
        '${(a['surah'] as num).toInt()}:${(a['ayah'] as num).toInt()}':
            a['text'] as String,
    };
    final loaded = QuranScriptTexts._(script, byKey);
    _cache[script] = loaded;
    return loaded;
  }

  String? textFor(int surah, int ayah) => _byKey['$surah:$ayah'];
}
