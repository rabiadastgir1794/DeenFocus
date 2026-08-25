import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/route_names.dart';
import '../../core/services/storage_service.dart';
import '../../core/superwall/premium_gate.dart';
import '../../l10n/app_localizations.dart';
import '../quran/data/quran_translation_texts.dart';
import '../quran/reading_engine/quran_script.dart';
import '../quran/reading_engine/quran_script_texts.dart';
import '../../core/services/quran_translation_service.dart';
import 'model/tajweed_practice_args.dart';
import 'tajweed_free_preview.dart';

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
  ///
  /// AI Tajweed is a premium feature — presents the paywall when needed.
  static void open(
    BuildContext context, {
    required int surah,
    required int ayah,
    required String arabicText,
    String? surahName,
    String? translation,
  }) {
    unawaited(
      PremiumGate.presentIfNeeded(
        context: context,
        debugContext: 'tajweed:practice',
        onAccess: () {
          unawaited(
            _navigateAfterEntitlement(
              context,
              surah: surah,
              ayah: ayah,
              arabicText: arabicText,
              surahName: surahName,
              translation: translation,
            ),
          );
        },
      ),
    );
  }

  /// Opens the free Al-Fatihah 1:1 (Bismillah) demo — no subscription required.
  static Future<void> openFreePreview(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    var translation = l10n.readingSettingsTajweedFreePreviewTranslation;
    try {
      final lang = await StorageService.quranTranslationLanguage;
      final code = lang.isEmpty
          ? QuranTranslationService.defaultLanguageCode
          : lang;
      final texts = await QuranTranslationTexts.load(code);
      translation =
          texts.textFor(TajweedFreePreview.surah, TajweedFreePreview.ayah) ??
          translation;
    } catch (_) {
      // Fall back to bundled l10n string.
    }
    if (!context.mounted) return;
    await _navigateAfterEntitlement(
      context,
      surah: TajweedFreePreview.surah,
      ayah: TajweedFreePreview.ayah,
      arabicText: TajweedFreePreview.fallbackArabic,
      surahName: l10n.featureDemoTajweedSurahName,
      translation: translation,
      freePreview: true,
    );
  }

  static Future<void> _navigateAfterEntitlement(
    BuildContext context, {
    required int surah,
    required int ayah,
    required String arabicText,
    String? surahName,
    String? translation,
    bool freePreview = false,
  }) async {
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
        freePreview: freePreview,
      ),
    );
  }
}
