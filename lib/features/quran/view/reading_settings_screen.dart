import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/quran_bookmark_service.dart';
import '../../../core/services/quran_translation_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/superwall/app_superwall.dart';
import '../../../core/superwall/premium_gate.dart';
import '../../../core/theme/segment_control_style.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../tajweed/model/tajweed_models.dart';
import '../../tajweed/tajweed_download_coordinator.dart';
import '../../tajweed/tajweed_entry_point.dart';
import '../reading_engine/quran_arabic_font.dart';
import '../reading_engine/quran_layout_theme.dart';
import '../reading_engine/quran_reading_color_theme.dart';
import '../reading_engine/quran_script.dart';
import '../reading_engine/quran_script_texts.dart';
import '../reading_engine/quran_transliteration.dart';
import '../reading_engine/reading_mode.dart';
import 'reading_translation_screen.dart';
import 'widgets/quran_arabic_text.dart';
import 'widgets/quran_reader_theme.dart';

/// Dedicated Reading Settings screen (Phase 1, item 4). Mirrors the
/// `_SettingsGroup` / `_SettingsRow` pattern used by `SettingsTabScreen` so
/// it fits the app's existing settings look without touching that file.
class ReadingSettingsScreen extends StatefulWidget {
  const ReadingSettingsScreen({super.key});

  @override
  State<ReadingSettingsScreen> createState() => _ReadingSettingsScreenState();
}

class _ReadingSettingsScreenState extends State<ReadingSettingsScreen> {
  static const _fallbackPreviewArabic =
      'بِسْمِ ٱللَّهِ ٱلرَّحْمَٰنِ ٱلرَّحِيمِ';
  static const _previewTranslation =
      'In the name of Allah, the Entirely Merciful, the Especially Merciful.';

  bool _loading = true;
  double _arabicFontSp = 20;
  double _englishFontSp = 15;
  double _lineSpacing = 1.8;
  ReadingMode _defaultMode = ReadingMode.surah;
  bool _rememberLastPosition = true;
  QuranScript _script = QuranScript.uthmani;
  QuranArabicFont _arabicFont = QuranArabicFont.uthmanicHafs;
  String _previewArabic = _fallbackPreviewArabic;
  bool _showEnglish = true;
  bool _showTransliteration = true;
  QuranLayoutTheme _layoutTheme = QuranLayoutTheme.classic;
  QuranReadingColorTheme _colorTheme = QuranReadingColorTheme.emerald;

  List<QuranTranslationOption> _translationOptions =
      const <QuranTranslationOption>[];
  String _selectedTranslation = QuranTranslationService.defaultLanguageCode;

  @override
  void initState() {
    super.initState();
    TajweedDownloadCoordinator.ensureListening();
    QuranTranslationService.installationRevision.addListener(
      _onTranslationRevision,
    );
    _load();
  }

  @override
  void dispose() {
    QuranTranslationService.installationRevision.removeListener(
      _onTranslationRevision,
    );
    super.dispose();
  }

  void _onTranslationRevision() {
    unawaited(_refreshTranslationOptions());
  }

  Future<void> _load() async {
    final results = await Future.wait<Object>([
      StorageService.quranArabicFontSp,
      StorageService.quranEnglishFontSp,
      StorageService.quranLineSpacing,
      StorageService.quranDefaultReadingMode,
      StorageService.quranRememberLastPosition,
      StorageService.quranScript,
      StorageService.quranArabicFont.then((v) => v ?? ''),
      StorageService.quranShowEnglish,
      StorageService.quranShowTransliteration,
      StorageService.quranLayoutTheme,
      StorageService.quranTranslationLanguage,
      StorageService.quranReadingColorTheme,
    ]);
    if (!mounted) return;
    final script = QuranScriptX.fromName(results[5] as String);
    setState(() {
      _arabicFontSp = results[0] as double;
      _englishFontSp = results[1] as double;
      _lineSpacing = results[2] as double;
      _defaultMode = ReadingMode.fromName(results[3] as String);
      _rememberLastPosition = results[4] as bool;
      _script = script;
      _arabicFont = QuranArabicFont.resolve(
        savedName: results[6] as String,
        script: script,
      );
      _showEnglish = results[7] as bool;
      _showTransliteration = results[8] as bool;
      _layoutTheme = QuranLayoutTheme.fromName(results[9] as String);
      _selectedTranslation = results[10] as String;
      _colorTheme = QuranReadingColorTheme.fromName(results[11] as String);
      _loading = false;
    });
    unawaited(_refreshPreviewArabic(script));
    unawaited(_refreshTranslationOptions());
    unawaited(TajweedDownloadCoordinator.refresh());
    if (_showEnglish) {
      unawaited(
        QuranTranslationService.ensureDefaultTranslationInBackground(),
      );
    }
  }

  Future<void> _refreshPreviewArabic(QuranScript script) async {
    try {
      final corpus = await QuranScriptTexts.load(script);
      final text = corpus.textFor(1, 1);
      if (!mounted || text == null || text.isEmpty) return;
      setState(() => _previewArabic = text);
    } catch (_) {
      // Keep current preview if corpus fails to load.
    }
  }

  Future<void> _onScriptChanged(QuranScript script) async {
    final font = QuranArabicFont.defaultFor(script);
    setState(() {
      _script = script;
      // Script chooses the matching typeface; users can override via Font.
      _arabicFont = font;
    });
    await Future.wait<void>([
      StorageService.setQuranScript(script.name),
      StorageService.setQuranArabicFont(font.name),
    ]);
    await _refreshPreviewArabic(script);
  }

  Future<void> _refreshTranslationOptions() async {
    try {
      final options = await QuranTranslationService.listAvailable(
        forceRefresh: true,
      );
      final selected = await StorageService.quranTranslationLanguage;
      if (!mounted) return;
      setState(() {
        _translationOptions = options;
        _selectedTranslation = selected;
      });
    } catch (_) {
      // Catalog offline — keep whatever we already have.
    }
  }

  String _labelFor(QuranTranslationOption option) {
    final name = option.displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    return option.languageCode.toUpperCase();
  }

  QuranTranslationOption? get _selectedOption {
    for (final o in _translationOptions) {
      if (o.languageCode == _selectedTranslation) return o;
    }
    return null;
  }

  Future<void> _openTranslationSettings() async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const ReadingTranslationScreen(),
      ),
    );
    await _refreshTranslationOptions();
  }

  Future<void> _onTajweedDownloadTapped({required bool isSubscribed}) async {
    if (!isSubscribed) {
      await PremiumGate.presentIfNeeded(
        context: context,
        debugContext: 'reading_settings:tajweed',
        onAccess: () {
          unawaited(_startTajweedDownloadWithFeedback());
        },
      );
      return;
    }
    await _startTajweedDownloadWithFeedback();
  }

  Future<void> _startTajweedDownloadWithFeedback() async {
    final phase = TajweedDownloadCoordinator.phase.value;
    if (phase == TajweedDownloadPhase.downloaded ||
        phase == TajweedDownloadPhase.downloading) {
      return;
    }
    try {
      await TajweedDownloadCoordinator.startDownload();
    } catch (e) {
      if (!mounted) return;
      final l10n = AppLocalizations.of(context)!;
      final message = e is TajweedException
          ? (e.message?.trim().isNotEmpty == true
                ? e.message!
                : l10n.tajweedErrorModelDownloadFailed)
          : l10n.tajweedErrorModelDownloadFailed;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message)),
      );
    }
  }

  Future<void> _onTajweedDeleteTapped() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.readingSettingsTajweedDeleteConfirmTitle),
          content: Text(l10n.readingSettingsTajweedDeleteConfirmBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: Text(l10n.readingSettingsTajweedDeleteConfirmAction),
            ),
          ],
        );
      },
    );
    if (confirmed != true || !mounted) return;
    try {
      await TajweedDownloadCoordinator.deleteDownloadedModel();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.readingSettingsTajweedDeleted)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.readingSettingsTajweedDeleteFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedLabel = _selectedOption != null
        ? _labelFor(_selectedOption!)
        : _selectedTranslation.toUpperCase();
    final palette = QuranReaderPalette.resolve(
      _colorTheme,
      Theme.of(context).brightness,
    );

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: CustomAppBar(title: l10n.readingSettingsTitle),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 0),
                  child: _ReadingPreviewCard(
                    title: l10n.readingSettingsPreview,
                    arabicText: _previewArabic,
                    translation: _previewTranslation,
                    arabicFontSp: _arabicFontSp,
                    englishFontSp: _englishFontSp,
                    lineSpacing: _lineSpacing,
                    arabicFont: _arabicFont,
                    showEnglish: _showEnglish,
                    showTransliteration: _showTransliteration,
                    layoutTheme: _layoutTheme,
                    palette: palette,
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                    children: [
                      _SettingsGroup(
                        children: [
                          _SettingsNavRow(
                            icon: Icons.translate_rounded,
                            label: l10n.readingSettingsTranslationLabel,
                            value: selectedLabel,
                            onTap: () => unawaited(_openTranslationSettings()),
                          ),
                          const _SettingsDivider(),
                          _SettingsSegmentSection<QuranLayoutTheme>(
                            icon: Icons.palette_outlined,
                            label: l10n.readingSettingsLayoutTheme,
                            segments: [
                              ButtonSegment(
                                value: QuranLayoutTheme.classic,
                                label: Text(l10n.readingSettingsLayoutClassic),
                              ),
                              ButtonSegment(
                                value: QuranLayoutTheme.simple,
                                label: Text(l10n.readingSettingsLayoutSimple),
                              ),
                              ButtonSegment(
                                value: QuranLayoutTheme.color,
                                label: Text(l10n.readingSettingsLayoutColor),
                              ),
                            ],
                            selected: _layoutTheme,
                            onChanged: (theme) {
                              setState(() => _layoutTheme = theme);
                              unawaited(
                                StorageService.setQuranLayoutTheme(theme.name),
                              );
                            },
                          ),
                          const _SettingsDivider(),
                          _SettingsSegmentSection<QuranScript>(
                            icon: Icons.font_download_rounded,
                            label: l10n.readingSettingsScript,
                            segments: [
                              ButtonSegment(
                                value: QuranScript.uthmani,
                                label: Text(l10n.readingSettingsScriptUthmani),
                              ),
                              ButtonSegment(
                                value: QuranScript.indopak,
                                label: Text(l10n.readingSettingsScriptIndopak),
                              ),
                            ],
                            selected: _script,
                            onChanged: (script) {
                              unawaited(_onScriptChanged(script));
                            },
                          ),
                          const _SettingsDivider(),
                          _SettingsSegmentSection<QuranArabicFont>(
                            icon: Icons.text_format_rounded,
                            label: l10n.readingSettingsArabicFont,
                            segments: [
                              ButtonSegment(
                                value: QuranArabicFont.uthmanicHafs,
                                label: Text(l10n.readingSettingsFontUthmanic),
                              ),
                              ButtonSegment(
                                value: QuranArabicFont.nooreHuda,
                                label: Text(l10n.readingSettingsFontNooreHuda),
                              ),
                              ButtonSegment(
                                value: QuranArabicFont.system,
                                label: Text(l10n.readingSettingsFontSystem),
                              ),
                            ],
                            selected: _arabicFont,
                            onChanged: (font) {
                              setState(() => _arabicFont = font);
                              unawaited(
                                StorageService.setQuranArabicFont(font.name),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _SettingsGroup(
                        children: [
                          _SettingsSliderRow(
                            icon: Icons.text_fields_rounded,
                            label: l10n.readingSettingsArabicFontSize,
                            value: _arabicFontSp,
                            min: 16,
                            max: 32,
                            valueLabel: _arabicFontSp.round().toString(),
                            onChanged: (value) {
                              setState(() => _arabicFontSp = value);
                              unawaited(
                                StorageService.setQuranArabicFontSp(value),
                              );
                            },
                          ),
                          const _SettingsDivider(),
                          _SettingsSliderRow(
                            icon: Icons.format_size_rounded,
                            label: l10n.readingSettingsTranslationFontSize,
                            value: _englishFontSp,
                            min: 12,
                            max: 24,
                            valueLabel: _englishFontSp.round().toString(),
                            onChanged: (value) {
                              setState(() => _englishFontSp = value);
                              unawaited(
                                StorageService.setQuranEnglishFontSp(value),
                              );
                            },
                          ),
                          const _SettingsDivider(),
                          _SettingsSliderRow(
                            icon: Icons.format_line_spacing_rounded,
                            label: l10n.readingSettingsLineSpacing,
                            value: _lineSpacing,
                            min: 1.2,
                            max: 2.4,
                            valueLabel: _lineSpacing.toStringAsFixed(1),
                            onChanged: (value) {
                              setState(() => _lineSpacing = value);
                              unawaited(
                                StorageService.setQuranLineSpacing(value),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _SettingsGroup(
                        children: [
                          _SettingsSwitchRow(
                            icon: Icons.menu_book_outlined,
                            label: l10n.readingSettingsShowTranslation,
                            value: _showEnglish,
                            onChanged: (value) {
                              setState(() => _showEnglish = value);
                              unawaited(
                                StorageService.setQuranShowEnglish(value),
                              );
                              if (value) {
                                unawaited(
                                  QuranTranslationService
                                      .ensureDefaultTranslationInBackground(),
                                );
                                unawaited(_refreshTranslationOptions());
                              }
                            },
                          ),
                          const _SettingsDivider(),
                          _SettingsSwitchRow(
                            icon: Icons.spellcheck_rounded,
                            label: l10n.readingSettingsShowTransliteration,
                            value: _showTransliteration,
                            onChanged: (value) {
                              setState(() => _showTransliteration = value);
                              unawaited(
                                StorageService.setQuranShowTransliteration(
                                  value,
                                ),
                              );
                            },
                          ),
                          const _SettingsDivider(),
                          ValueListenableBuilder<bool>(
                            valueListenable:
                                AppSuperwall.subscriptionActiveNotifier,
                            builder: (context, isSubscribed, _) {
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  _TajweedDownloadSettingsRow(
                                    label: l10n.readingSettingsTajweedPractice,
                                    showLock: !isSubscribed,
                                    onDownloadTap: () => unawaited(
                                      _onTajweedDownloadTapped(
                                        isSubscribed: isSubscribed,
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      48.w,
                                      0,
                                      16.w,
                                      12.h,
                                    ),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: InkWell(
                                        onTap: () => unawaited(
                                          TajweedEntryPoint.openFreePreview(
                                            context,
                                          ),
                                        ),
                                        borderRadius:
                                            BorderRadius.circular(4),
                                        child: Text(
                                          l10n.readingSettingsTajweedSeeHowItWorks,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .colorScheme
                                                    .primary,
                                                fontWeight: FontWeight.w600,
                                                decoration: TextDecoration
                                                    .underline,
                                                decorationColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primary,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  ValueListenableBuilder<TajweedDownloadPhase>(
                                    valueListenable:
                                        TajweedDownloadCoordinator.phase,
                                    builder: (context, phase, _) {
                                      if (phase !=
                                          TajweedDownloadPhase.downloaded) {
                                        return const SizedBox.shrink();
                                      }
                                      return Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          48.w,
                                          0,
                                          16.w,
                                          12.h,
                                        ),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: TextButton(
                                            onPressed: () => unawaited(
                                              _onTajweedDeleteTapped(),
                                            ),
                                            style: TextButton.styleFrom(
                                              foregroundColor: Colors.red,
                                              padding: EdgeInsets.zero,
                                              minimumSize: Size.zero,
                                              tapTargetSize:
                                                  MaterialTapTargetSize
                                                      .shrinkWrap,
                                            ),
                                            child: Text(
                                              l10n.readingSettingsTajweedDeleteModel,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    color: Colors.red,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                          const _SettingsDivider(),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 6.h),
                            child: _SettingsSectionHeader(
                              icon: Icons.color_lens_outlined,
                              label: l10n.readingSettingsColorTheme,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _ColorThemeOption(
                                    label: l10n.readingSettingsColorThemeParchment,
                                    theme: QuranReadingColorTheme.parchment,
                                    selected:
                                        _colorTheme ==
                                        QuranReadingColorTheme.parchment,
                                    onTap: () => _setColorTheme(
                                      QuranReadingColorTheme.parchment,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: _ColorThemeOption(
                                    label: l10n.readingSettingsColorThemeEmerald,
                                    theme: QuranReadingColorTheme.emerald,
                                    selected:
                                        _colorTheme ==
                                        QuranReadingColorTheme.emerald,
                                    onTap: () => _setColorTheme(
                                      QuranReadingColorTheme.emerald,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 8.w),
                                Expanded(
                                  child: _ColorThemeOption(
                                    label: l10n.readingSettingsColorThemeMidnight,
                                    theme: QuranReadingColorTheme.midnight,
                                    selected:
                                        _colorTheme ==
                                        QuranReadingColorTheme.midnight,
                                    onTap: () => _setColorTheme(
                                      QuranReadingColorTheme.midnight,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _SettingsGroup(
                        children: [
                          _SettingsSegmentSection<ReadingMode>(
                            icon: Icons.menu_book_rounded,
                            label: l10n.readingSettingsDefaultMode,
                            segments: [
                              ButtonSegment(
                                value: ReadingMode.surah,
                                label: Text(l10n.quranModeSurah),
                              ),
                              ButtonSegment(
                                value: ReadingMode.juz,
                                label: Text(l10n.quranModeJuz),
                              ),
                              ButtonSegment(
                                value: ReadingMode.page,
                                label: Text(l10n.quranModePage),
                              ),
                            ],
                            selected: _defaultMode,
                            onChanged: (mode) {
                              setState(() => _defaultMode = mode);
                              unawaited(
                                StorageService.setQuranDefaultReadingMode(
                                  mode.name,
                                ),
                              );
                            },
                          ),
                          const _SettingsDivider(),
                          _SettingsSwitchRow(
                            icon: Icons.bookmark_outlined,
                            label: l10n.readingSettingsRememberPosition,
                            value: _rememberLastPosition,
                            onChanged: (value) {
                              setState(() => _rememberLastPosition = value);
                              unawaited(
                                StorageService.setQuranRememberLastPosition(
                                  value,
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _SettingsGroup(
                        children: [
                          ListTile(
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 4.h,
                            ),
                            leading: Icon(
                              Icons.restart_alt_rounded,
                              size: 22.sp,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            title: Text(
                              l10n.readingSettingsResetHistoryTitle,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Theme.of(context).colorScheme.error,
                              ),
                            ),
                            subtitle: Text(
                              l10n.readingSettingsResetHistorySubtitle,
                            ),
                            trailing: OutlinedButton(
                              style: OutlinedButton.styleFrom(
                                foregroundColor:
                                    Theme.of(context).colorScheme.error,
                                side: BorderSide(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              onPressed: () =>
                                  unawaited(_confirmResetReadingHistory()),
                              child: Text(l10n.readingSettingsResetHistoryButton),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 24.h),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  void _setColorTheme(QuranReadingColorTheme theme) {
    setState(() => _colorTheme = theme);
    unawaited(StorageService.setQuranReadingColorTheme(theme.name));
  }

  Future<void> _confirmResetReadingHistory() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.readingSettingsResetHistoryConfirmTitle),
        content: Text(l10n.readingSettingsResetHistoryConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(ctx).colorScheme.error,
            ),
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.readingSettingsResetHistoryButton),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;

    await StorageService.clearQuranReadingHistory();
    QuranBookmarkService.revision.value++;
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n.readingSettingsResetHistoryDone),
        duration: const Duration(seconds: 2),
      ),
    );
  }
}

class _SettingsNavRow extends StatelessWidget {
  const _SettingsNavRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          child: Row(
            children: [
              Icon(icon, size: 20.sp, color: colorScheme.onSurfaceVariant),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(width: 8.w),
              Flexible(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.end,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20.sp,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.7),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsSectionHeader extends StatelessWidget {
  const _SettingsSectionHeader({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 20.sp, color: colorScheme.onSurfaceVariant),
        SizedBox(width: 12.w),
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _SettingsSegmentSection<T> extends StatelessWidget {
  const _SettingsSegmentSection({
    required this.icon,
    required this.label,
    required this.segments,
    required this.selected,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final List<ButtonSegment<T>> segments;
  final T selected;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _SettingsSectionHeader(icon: icon, label: label),
          SizedBox(height: 12.h),
          SegmentedButton<T>(
            segments: segments,
            selected: {selected},
            showSelectedIcon: false,
            style: deenSegmentStyle(context),
            onSelectionChanged: (selection) {
              if (selection.isEmpty) return;
              onChanged(selection.first);
            },
          ),
        ],
      ),
    );
  }
}

class _ReadingPreviewCard extends StatelessWidget {
  const _ReadingPreviewCard({
    required this.title,
    required this.arabicText,
    required this.translation,
    required this.arabicFontSp,
    required this.englishFontSp,
    required this.lineSpacing,
    required this.arabicFont,
    required this.showEnglish,
    required this.showTransliteration,
    required this.layoutTheme,
    required this.palette,
  });

  final String title;
  final String arabicText;
  final String translation;
  final double arabicFontSp;
  final double englishFontSp;
  final double lineSpacing;
  final QuranArabicFont arabicFont;
  final bool showEnglish;
  final bool showTransliteration;
  final QuranLayoutTheme layoutTheme;
  final QuranReaderPalette palette;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
          SizedBox(height: 12.h),
          _previewBody(context),
        ],
      ),
    );
  }

  Widget _previewBody(BuildContext context) {
    final content = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuranArabicText(
          text: arabicText,
          layoutTheme: layoutTheme,
          fontFamily: arabicFont.fontFamily,
          fontFamilyFallback: arabicFont.fontFamilyFallback,
          fontSize: arabicFontSp.sp,
          lineHeight: lineSpacing,
          color: palette.textPrimary,
        ),
        if (showTransliteration) ...[
          SizedBox(height: 8.h),
          Text(
            QuranTransliteration.of(arabicText),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: (englishFontSp - 1).sp,
              height: 1.4,
              fontStyle: FontStyle.italic,
              color: palette.textSecondary,
            ),
          ),
        ],
        if (showEnglish) ...[
          SizedBox(height: 10.h),
          Text(
            translation,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: englishFontSp.sp,
              height: 1.45,
              color: palette.textPrimary,
            ),
          ),
        ],
      ],
    );

    if (layoutTheme.isMushafStyle) {
      return Container(
        width: double.infinity,
        padding: EdgeInsets.fromLTRB(14.w, 14.h, 14.w, 16.h),
        decoration: BoxDecoration(
          color: palette.paper,
          borderRadius: BorderRadius.circular(16.r),
          border: Border.all(color: palette.accent.withValues(alpha: 0.18)),
        ),
        child: content,
      );
    }

    return content;
  }
}

class _ColorThemeOption extends StatelessWidget {
  const _ColorThemeOption({
    required this.label,
    required this.theme,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final QuranReadingColorTheme theme;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final palette = QuranReaderPalette.resolve(theme, brightness);
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(12.r),
        onTap: onTap,
        child: Ink(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 8.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.r),
            color: selected ? colorScheme.primaryContainer : Colors.transparent,
            border: Border.all(
              color: selected
                  ? colorScheme.primary.withValues(alpha: 0.55)
                  : colorScheme.outlineVariant.withValues(alpha: 0.35),
              width: selected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: 44.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.r),
                  color: palette.background,
                ),
                child: Stack(
                  children: [
                    Positioned.fill(
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.r),
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              palette.background,
                              Color.lerp(
                                palette.background,
                                palette.accent,
                                0.22,
                              )!,
                            ],
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Container(
                        width: double.infinity,
                        height: 22.h,
                        margin: EdgeInsets.symmetric(horizontal: 8.w),
                        decoration: BoxDecoration(
                          color: palette.paper,
                          borderRadius: BorderRadius.circular(4.r),
                          border: Border.all(
                            color: palette.accent.withValues(alpha: 0.45),
                          ),
                        ),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 3.h,
                            margin: EdgeInsets.fromLTRB(6.w, 0, 6.w, 4.h),
                            decoration: BoxDecoration(
                              color: palette.primary,
                              borderRadius: BorderRadius.circular(2.r),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.22),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(children: children),
    );
  }
}

class _SettingsDivider extends StatelessWidget {
  const _SettingsDivider();

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 1,
      indent: 16.w,
      endIndent: 16.w,
      color: Theme.of(context).colorScheme.outlineVariant.withValues(
        alpha: 0.25,
      ),
    );
  }
}

class _TajweedDownloadSettingsRow extends StatelessWidget {
  const _TajweedDownloadSettingsRow({
    required this.label,
    required this.showLock,
    required this.onDownloadTap,
  });

  final String label;
  final bool showLock;
  final VoidCallback onDownloadTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        children: [
          Icon(Icons.mic_outlined, size: 20.sp, color: colorScheme.onSurfaceVariant),
          SizedBox(width: 12.w),
          Expanded(
            child: Row(
              children: [
                Flexible(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (showLock) ...[
                  SizedBox(width: 6.w),
                  Icon(
                    Icons.lock_outline_rounded,
                    size: 16.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ],
              ],
            ),
          ),
          SizedBox(width: 12.w),
          ValueListenableBuilder<TajweedDownloadPhase>(
            valueListenable: TajweedDownloadCoordinator.phase,
            builder: (context, phase, _) {
              return ValueListenableBuilder<double>(
                valueListenable: TajweedDownloadCoordinator.progress,
                builder: (context, progress, _) {
                  return _TajweedDownloadTrailing(
                    phase: phase,
                    progress: progress,
                    onDownloadTap: onDownloadTap,
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

class _TajweedDownloadTrailing extends StatelessWidget {
  const _TajweedDownloadTrailing({
    required this.phase,
    required this.progress,
    required this.onDownloadTap,
  });

  final TajweedDownloadPhase phase;
  final double progress;
  final VoidCallback onDownloadTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    switch (phase) {
      case TajweedDownloadPhase.downloaded:
        return Container(
          width: 28.w,
          height: 28.w,
          decoration: BoxDecoration(
            color: const Color(0xFF2E7D32),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: Icon(Icons.check_rounded, size: 18.sp, color: Colors.white),
        );
      case TajweedDownloadPhase.downloading:
        final pct = (progress * 100).clamp(0, 100).round();
        final size = 40.w;
        return SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                width: size,
                height: size,
                child: CircularProgressIndicator(
                  strokeWidth: 3,
                  value: progress <= 0 ? null : progress.clamp(0.0, 1.0),
                  color: colorScheme.primary,
                  backgroundColor:
                      colorScheme.primary.withValues(alpha: 0.15),
                ),
              ),
              Text(
                progress <= 0 ? '…' : '$pct%',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: 10.sp,
                  color: colorScheme.primary,
                  height: 1,
                ),
              ),
            ],
          ),
        );
      case TajweedDownloadPhase.failed:
      case TajweedDownloadPhase.notDownloaded:
        return IconButton(
          padding: EdgeInsets.zero,
          constraints: BoxConstraints.tightFor(width: 36.w, height: 36.w),
          tooltip: labelDownload(context),
          onPressed: onDownloadTap,
          icon: Icon(
            Icons.download_rounded,
            size: 22.sp,
            color: colorScheme.onSurfaceVariant,
          ),
        );
    }
  }

  String labelDownload(BuildContext context) {
    return AppLocalizations.of(context)!.readingSettingsTajweedPractice;
  }
}

class _SettingsSwitchRow extends StatelessWidget {
  const _SettingsSwitchRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(icon, size: 20.sp, color: colorScheme.onSurfaceVariant),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: 12.w),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}

class _SettingsSliderRow extends StatelessWidget {
  const _SettingsSliderRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    required this.valueLabel,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final double value;
  final double min;
  final double max;
  final String valueLabel;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 4.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20.sp, color: colorScheme.onSurfaceVariant),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w600),
                ),
              ),
              Text(
                valueLabel,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: colorScheme.primary.withValues(alpha: 0.75),
              inactiveTrackColor: colorScheme.surfaceContainerHighest,
              thumbColor: colorScheme.primary,
              overlayColor: colorScheme.primary.withValues(alpha: 0.08),
            ),
            child: Slider(value: value, min: min, max: max, onChanged: onChanged),
          ),
        ],
      ),
    );
  }
}
