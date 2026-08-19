import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/route_names.dart';
import '../../core/services/storage_service.dart';
import '../quran/reading_engine/quran_script.dart';
import '../quran/reading_engine/quran_script_texts.dart';
import 'model/tajweed_practice_args.dart';

/// Shared helpers for the per-ayah "Practice Tajweed" entry point, used by
/// Surah/Juz reading screens so each one doesn't duplicate the rollout-flag
/// check and navigation call.
abstract final class TajweedEntryPoint {
  /// Whether the per-ayah practice button should be shown at all
  /// (controlled rollout flag, Settings → AI Tajweed Practice).
  static Future<bool> isEnabled() => StorageService.tajweedEnabled;

  /// Opens practice using the **Reading Settings** script (text + font),
  /// matching the surah listing 100%. [arabicText] is only a fallback if the
  /// script corpus lacks that ayah.
  static void open(
    BuildContext context, {
    required int surah,
    required int ayah,
    required String arabicText,
    String? surahName,
    String? translation,
  }) {
    unawaited(() async {
      final script = QuranScriptX.fromName(await StorageService.quranScript);
      final corpus = await QuranScriptTexts.load(script);
      final resolvedText = corpus.textFor(surah, ayah) ?? arabicText;
      // Uthmani is the canonical word-boundary reference for lexical alignment
      // across mushaf presentation orthographies (IndoPak presentation spaces).
      final uthmaniCorpus = script == QuranScript.uthmani
          ? corpus
          : await QuranScriptTexts.load(QuranScript.uthmani);
      final lexicalReference =
          uthmaniCorpus.textFor(surah, ayah) ?? resolvedText;
      if (!context.mounted) return;
      if (surahName != null) {
        unawaited(
          StorageService.setLastTajweedPractice(
            surah: surah,
            ayah: ayah,
            surahName: surahName,
          ),
        );
      }
      context.push(
        RouteNames.tajweedPractice,
        extra: TajweedPracticeArgs(
          surah: surah,
          ayah: ayah,
          arabicText: resolvedText,
          arabicFontFamily: script.fontFamily,
          lexicalReferenceArabic: lexicalReference,
          surahName: surahName,
          translation: translation,
        ),
      );
    }());
  }
}
