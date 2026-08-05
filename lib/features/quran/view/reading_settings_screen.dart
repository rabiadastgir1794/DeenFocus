import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/quran_translation_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../reading_engine/quran_layout_theme.dart';
import '../reading_engine/quran_script.dart';
import '../reading_engine/quran_transliteration.dart';
import '../reading_engine/reading_mode.dart';
import 'widgets/quran_arabic_text.dart';

/// Dedicated Reading Settings screen (Phase 1, item 4). Mirrors the
/// `_SettingsGroup` / `_SettingsRow` pattern used by `SettingsTabScreen` so
/// it fits the app's existing settings look without touching that file.
class ReadingSettingsScreen extends StatefulWidget {
  const ReadingSettingsScreen({super.key});

  @override
  State<ReadingSettingsScreen> createState() => _ReadingSettingsScreenState();
}

class _ReadingSettingsScreenState extends State<ReadingSettingsScreen> {
  static const _previewArabic =
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
  bool _showEnglish = true;
  bool _showTransliteration = true;
  QuranLayoutTheme _layoutTheme = QuranLayoutTheme.classic;

  List<QuranTranslationOption> _translationOptions =
      const <QuranTranslationOption>[];
  String _selectedTranslation = QuranTranslationService.defaultLanguageCode;
  String? _downloadingLanguage;
  double _downloadProgress = 0;
  StreamSubscription<double>? _downloadProgressSub;

  @override
  void initState() {
    super.initState();
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
    _downloadProgressSub?.cancel();
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
      StorageService.quranShowEnglish,
      StorageService.quranShowTransliteration,
      StorageService.quranLayoutTheme,
      StorageService.quranTranslationLanguage,
    ]);
    if (!mounted) return;
    setState(() {
      _arabicFontSp = results[0] as double;
      _englishFontSp = results[1] as double;
      _lineSpacing = results[2] as double;
      _defaultMode = ReadingMode.fromName(results[3] as String);
      _rememberLastPosition = results[4] as bool;
      _script = QuranScriptX.fromName(results[5] as String);
      _showEnglish = results[6] as bool;
      _showTransliteration = results[7] as bool;
      _layoutTheme = QuranLayoutTheme.fromName(results[8] as String);
      _selectedTranslation = results[9] as String;
      _loading = false;
    });
    unawaited(_refreshTranslationOptions());
    if (_showEnglish) {
      unawaited(
        QuranTranslationService.ensureDefaultTranslationInBackground(),
      );
    }
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

  String? _sizeLabel(QuranTranslationOption option) {
    final bytes = option.approxSizeBytes;
    if (bytes == null || bytes <= 0) return null;
    final mb = bytes / (1024 * 1024);
    if (mb >= 10) return '${mb.round()} MB';
    return '${mb.toStringAsFixed(1)} MB';
  }

  QuranTranslationOption? get _selectedOption {
    for (final o in _translationOptions) {
      if (o.languageCode == _selectedTranslation) return o;
    }
    return null;
  }

  List<QuranTranslationOption> get _installedOptions {
    final installed = _translationOptions
        .where((o) => o.installed)
        .toList(growable: false);
    return [
      ...installed.where((o) => o.languageCode == _selectedTranslation),
      ...installed.where((o) => o.languageCode != _selectedTranslation),
    ];
  }

  List<QuranTranslationOption> get _availableOptions => _translationOptions
      .where((o) => !o.installed)
      .toList(growable: false);

  _TranslationRowStatus _statusFor(QuranTranslationOption option) {
    if (_downloadingLanguage == option.languageCode) {
      return _TranslationRowStatus.downloading;
    }
    if (option.installed) {
      return option.languageCode == _selectedTranslation
          ? _TranslationRowStatus.selected
          : _TranslationRowStatus.installed;
    }
    if (QuranTranslationService.isDefaultLanguage(option.languageCode)) {
      return _TranslationRowStatus.installing;
    }
    return _TranslationRowStatus.download;
  }

  List<Widget> _translationRows({
    required List<QuranTranslationOption> options,
    required AppLocalizations l10n,
  }) {
    final rows = <Widget>[];
    for (var i = 0; i < options.length; i++) {
      if (i > 0) rows.add(const _SettingsDivider());
      final option = options[i];
      rows.add(
        _TranslationOptionRow(
          key: ValueKey<String>(option.packId),
          label: _labelFor(option),
          sizeLabel: _sizeLabel(option),
          status: _statusFor(option),
          progress: _downloadProgress,
          selectedLabel: l10n.readingSettingsTranslationSelected,
          installedLabel: l10n.readingSettingsTranslationInstalled,
          downloadLabel: l10n.readingSettingsTranslationDownload,
          installingLabel: l10n.readingSettingsTranslationInstalling,
          downloadingLabel: l10n.readingSettingsTranslationDownloading,
          onSelect: () => unawaited(_selectInstalled(option)),
          onDownload: () => unawaited(_downloadAndSelect(option)),
        ),
      );
    }
    return rows;
  }

  Future<void> _selectInstalled(QuranTranslationOption option) async {
    await QuranTranslationService.selectLanguage(option.languageCode);
    if (!mounted) return;
    setState(() => _selectedTranslation = option.languageCode);
  }

  Future<void> _downloadAndSelect(QuranTranslationOption option) async {
    if (_downloadingLanguage != null) return;
    setState(() {
      _downloadingLanguage = option.languageCode;
      _downloadProgress = 0;
    });
    await _downloadProgressSub?.cancel();
    _downloadProgressSub = QuranTranslationService.downloadProgress().listen((
      p,
    ) {
      if (!mounted) return;
      setState(() => _downloadProgress = p);
    });
    try {
      await QuranTranslationService.ensureTranslation(option.languageCode);
      await QuranTranslationService.selectLanguage(option.languageCode);
      if (!mounted) return;
      setState(() {
        _selectedTranslation = option.languageCode;
        _downloadingLanguage = null;
      });
      await _refreshTranslationOptions();
    } on QuranTranslationException {
      if (!mounted) return;
      setState(() => _downloadingLanguage = null);
      ScaffoldMessenger.maybeOf(context)?.showSnackBar(
        SnackBar(
          content: Text(
            'Could not download ${_labelFor(option)}. Try again when online.',
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _downloadingLanguage = null);
    } finally {
      await _downloadProgressSub?.cancel();
      _downloadProgressSub = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final selectedLabel = _selectedOption != null
        ? _labelFor(_selectedOption!)
        : _selectedTranslation.toUpperCase();

    return Scaffold(
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
                    script: _script,
                    showEnglish: _showEnglish,
                    showTransliteration: _showTransliteration,
                    layoutTheme: _layoutTheme,
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 24.h),
                    children: [
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
                            icon: Icons.translate_rounded,
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
                            icon: Icons.translate_rounded,
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
                          if (_showEnglish) ...[
                            const _SettingsDivider(),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                16.w,
                                14.h,
                                16.w,
                                6.h,
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.menu_book_outlined,
                                    size: 20.sp,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                  ),
                                  SizedBox(width: 12.w),
                                  Text(
                                    l10n.readingSettingsTranslationSection,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                16.w,
                                0,
                                16.w,
                                12.h,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.readingSettingsTranslationCurrent,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                  SizedBox(height: 4.h),
                                  Text(
                                    selectedLabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ),
                            if (_installedOptions.isNotEmpty) ...[
                              _TranslationSectionHeader(
                                label: l10n.readingSettingsInstalledTranslations,
                              ),
                              ..._translationRows(
                                options: _installedOptions,
                                l10n: l10n,
                              ),
                            ],
                            if (_availableOptions.isNotEmpty) ...[
                              _TranslationSectionHeader(
                                label: l10n.readingSettingsAvailableTranslations,
                              ),
                              ..._translationRows(
                                options: _availableOptions,
                                l10n: l10n,
                              ),
                            ],
                            SizedBox(height: 8.h),
                          ],
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
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 6.h),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.palette_outlined,
                                  size: 20.sp,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  l10n.readingSettingsLayoutTheme,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
                            child: SegmentedButton<QuranLayoutTheme>(
                              segments: [
                                ButtonSegment(
                                  value: QuranLayoutTheme.classic,
                                  label: Text(
                                    l10n.readingSettingsLayoutClassic,
                                  ),
                                ),
                                ButtonSegment(
                                  value: QuranLayoutTheme.simple,
                                  label: Text(
                                    l10n.readingSettingsLayoutSimple,
                                  ),
                                ),
                                ButtonSegment(
                                  value: QuranLayoutTheme.color,
                                  label: Text(l10n.readingSettingsLayoutColor),
                                ),
                              ],
                              selected: {_layoutTheme},
                              onSelectionChanged: (selection) {
                                final theme = selection.first;
                                setState(() => _layoutTheme = theme);
                                unawaited(
                                  StorageService.setQuranLayoutTheme(
                                    theme.name,
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _SettingsGroup(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 6.h),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.font_download_rounded,
                                  size: 20.sp,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  l10n.readingSettingsScript,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
                            child: SegmentedButton<QuranScript>(
                              segments: [
                                ButtonSegment(
                                  value: QuranScript.uthmani,
                                  label: Text(
                                    l10n.readingSettingsScriptUthmani,
                                  ),
                                ),
                                ButtonSegment(
                                  value: QuranScript.indopak,
                                  label: Text(
                                    l10n.readingSettingsScriptIndopak,
                                  ),
                                ),
                              ],
                              selected: {_script},
                              onSelectionChanged: (selection) {
                                final script = selection.first;
                                setState(() => _script = script);
                                unawaited(
                                  StorageService.setQuranScript(script.name),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 16.h),
                      _SettingsGroup(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 6.h),
                            child: Row(
                              children: [
                                Icon(
                                  Icons.menu_book_rounded,
                                  size: 20.sp,
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.onSurfaceVariant,
                                ),
                                SizedBox(width: 12.w),
                                Text(
                                  l10n.readingSettingsDefaultMode,
                                  style: Theme.of(context).textTheme.titleSmall
                                      ?.copyWith(fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(16.w, 0, 16.w, 14.h),
                            child: SegmentedButton<ReadingMode>(
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
                              selected: {_defaultMode},
                              onSelectionChanged: (selection) {
                                final mode = selection.first;
                                setState(() => _defaultMode = mode);
                                unawaited(
                                  StorageService.setQuranDefaultReadingMode(
                                    mode.name,
                                  ),
                                );
                              },
                            ),
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
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

enum _TranslationRowStatus {
  selected,
  installed,
  downloading,
  installing,
  download,
}

class _TranslationSectionHeader extends StatelessWidget {
  const _TranslationSectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 8.h, 16.w, 4.h),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
          color: Theme.of(context).colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}

/// One catalog pack row. Parent keys rows by [QuranTranslationOption.packId]
/// so later delete / update / multi-translator English can land without redesign.
class _TranslationOptionRow extends StatelessWidget {
  const _TranslationOptionRow({
    super.key,
    required this.label,
    required this.sizeLabel,
    required this.status,
    required this.progress,
    required this.selectedLabel,
    required this.installedLabel,
    required this.downloadLabel,
    required this.installingLabel,
    required this.downloadingLabel,
    required this.onSelect,
    required this.onDownload,
  });

  final String label;
  final String? sizeLabel;
  final _TranslationRowStatus status;
  final double progress;
  final String selectedLabel;
  final String installedLabel;
  final String downloadLabel;
  final String installingLabel;
  final String downloadingLabel;
  final VoidCallback onSelect;
  final VoidCallback onDownload;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final selected = status == _TranslationRowStatus.selected;
    final installed =
        status == _TranslationRowStatus.selected ||
        status == _TranslationRowStatus.installed;

    final VoidCallback? onTap = switch (status) {
      _TranslationRowStatus.installed => onSelect,
      _TranslationRowStatus.download => onDownload,
      _ => null,
    };

    final Widget leading = switch (status) {
      _TranslationRowStatus.selected ||
      _TranslationRowStatus.installed => Icon(
        Icons.check_circle,
        size: 20.sp,
        color: colorScheme.primary,
      ),
      _TranslationRowStatus.download => Icon(
        Icons.download_rounded,
        size: 20.sp,
        color: colorScheme.onSurfaceVariant,
      ),
      _TranslationRowStatus.downloading ||
      _TranslationRowStatus.installing => SizedBox(
        width: 20.sp,
        height: 20.sp,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          value: status == _TranslationRowStatus.downloading && progress > 0
              ? progress
              : null,
        ),
      ),
    };

    final Widget trailing = switch (status) {
      _TranslationRowStatus.selected => Text(
        selectedLabel,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
      _TranslationRowStatus.installed => Text(
        installedLabel,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
        ),
      ),
      _TranslationRowStatus.installing => Text(
        installingLabel,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.onSurfaceVariant,
        ),
      ),
      _TranslationRowStatus.download => Text(
        downloadLabel,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
      _TranslationRowStatus.downloading => SizedBox(
        width: 96.w,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              downloadingLabel,
              style: Theme.of(context).textTheme.labelSmall,
            ),
            SizedBox(height: 4.h),
            LinearProgressIndicator(value: progress > 0 ? progress : null),
            SizedBox(height: 2.h),
            Text(
              '${(progress * 100).clamp(0, 99).round()}%',
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    };

    // Subtitle reserved for size now; later "Update available" / version notes.
    final subtitle = !installed ? sizeLabel : null;

    return Material(
      color: selected
          ? colorScheme.primaryContainer.withValues(alpha: 0.35)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          child: Row(
            children: [
              leading,
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                      ),
                    ),
                    if (subtitle != null) ...[
                      SizedBox(height: 2.h),
                      Text(
                        subtitle,
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              trailing,
            ],
          ),
        ),
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
    required this.script,
    required this.showEnglish,
    required this.showTransliteration,
    required this.layoutTheme,
  });

  final String title;
  final String arabicText;
  final String translation;
  final double arabicFontSp;
  final double englishFontSp;
  final double lineSpacing;
  final QuranScript script;
  final bool showEnglish;
  final bool showTransliteration;
  final QuranLayoutTheme layoutTheme;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isSimple = layoutTheme == QuranLayoutTheme.simple;
    final muted = colorScheme.onSurfaceVariant;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: isSimple
            ? colorScheme.surfaceContainer
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: isSimple
              ? colorScheme.outlineVariant.withValues(alpha: 0.35)
              : colorScheme.outlineVariant.withValues(alpha: 0.65),
        ),
        boxShadow: isSimple
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            title,
            style: theme.textTheme.labelLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 12.h),
          QuranArabicText(
            text: arabicText,
            layoutTheme: layoutTheme,
            fontFamily: script.fontFamily,
            fontSize: arabicFontSp.sp,
            lineHeight: lineSpacing,
            color: colorScheme.onSurface,
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
                color: muted,
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
                color: colorScheme.onSurface,
              ),
            ),
          ],
        ],
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
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
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
                style: TextStyle(
                  fontSize: 13.sp,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          Slider(value: value, min: min, max: max, onChanged: onChanged),
        ],
      ),
    );
  }
}
