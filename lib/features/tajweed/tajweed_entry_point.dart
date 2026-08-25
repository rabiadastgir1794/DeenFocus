import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../../app/routes/route_names.dart';
import '../../core/services/storage_service.dart';
import '../../core/superwall/premium_gate.dart';
import '../../l10n/app_localizations.dart';
import '../quran/data/quran_translation_texts.dart';
import '../quran/reading_engine/quran_display_prefs.dart';
import '../quran/reading_engine/quran_script.dart';
import '../quran/reading_engine/quran_script_texts.dart';
import '../../core/services/quran_translation_service.dart';
import 'model/tajweed_practice_args.dart';
import 'tajweed_free_preview.dart';

/// Shared helpers for the per-ayah "Practice Tajweed" entry point.
abstract final class TajweedEntryPoint {
  /// Legacy flag — kept for native ensure/prepare gating. Mic visibility no
  /// longer depends on this; download / practice set it when needed.
  static Future<bool> isEnabled() => StorageService.tajweedEnabled;

  /// Non-subscriber → paywall. Subscriber → existing Tajweed practice screen
  /// (which shows the model download UI when the pack is not on disk).
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
            () async {
              await StorageService.setTajweedEnabled(true);
              if (!context.mounted) return;
              await _navigateAfterEntitlement(
                context,
                surah: surah,
                ayah: ayah,
                arabicText: arabicText,
                surahName: surahName,
                translation: translation,
              );
            }(),
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
    final display = await QuranDisplayPrefs.load();
    final corpus = await QuranScriptTexts.load(display.script);
    final resolvedText = corpus.textFor(surah, ayah) ?? arabicText;
    final uthmaniCorpus = display.script == QuranScript.uthmani
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
        arabicFontFamily:
            display.fontFamily ?? display.script.fontFamily,
        arabicFontFamilyFallback: display.fontFamilyFallback,
        lexicalReferenceArabic: lexicalReference,
        surahName: surahName,
        translation: translation,
        freePreview: freePreview,
      ),
    );
  }
}
