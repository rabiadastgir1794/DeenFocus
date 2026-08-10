import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;

import 'quran_script.dart';

/// Arabic typeface for Quran reading (independent of [QuranScript] orthography).
///
/// - [uthmanicHafs] / [nooreHuda]: bundled fonts in `assets/fonts/`
/// - [system]: device-native Arabic (iOS Geeza Pro / Android Noto Naskh, etc.)
enum QuranArabicFont {
  uthmanicHafs,
  nooreHuda,
  system;

  /// Prefer a saved preference; otherwise match the selected script's font.
  static QuranArabicFont resolve({
    required String? savedName,
    required QuranScript script,
  }) {
    if (savedName != null && savedName.isNotEmpty) {
      return fromName(savedName);
    }
    return switch (script) {
      QuranScript.uthmani => QuranArabicFont.uthmanicHafs,
      QuranScript.indopak => QuranArabicFont.nooreHuda,
    };
  }

  static QuranArabicFont fromName(String? name) {
    return switch (name) {
      'nooreHuda' => QuranArabicFont.nooreHuda,
      'system' => QuranArabicFont.system,
      'uthmanicHafs' => QuranArabicFont.uthmanicHafs,
      _ => QuranArabicFont.uthmanicHafs,
    };
  }

  /// Primary [TextStyle.fontFamily]. Null for [system] so fallbacks apply.
  String? get fontFamily => switch (this) {
        QuranArabicFont.uthmanicHafs => 'UthmanicHafs',
        QuranArabicFont.nooreHuda => 'NooreHuda',
        QuranArabicFont.system => _platformNativeFamily,
      };

  /// Extra families when the primary platform face is missing.
  List<String>? get fontFamilyFallback => switch (this) {
        QuranArabicFont.system => const [
            'GeezaPro',
            'Geeza Pro',
            'Al Nile',
            'AlNile',
            'Noto Naskh Arabic',
            'Noto Sans Arabic',
            'sans-serif',
          ],
        _ => null,
      };

  static String? get _platformNativeFamily {
    if (kIsWeb) return 'Noto Naskh Arabic';
    if (Platform.isIOS || Platform.isMacOS) return 'GeezaPro';
    if (Platform.isAndroid) return 'Noto Naskh Arabic';
    return null;
  }
}
