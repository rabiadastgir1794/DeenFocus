import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../reading_engine/quran_script.dart';
import '../reading_engine/reading_mode.dart';

/// Dedicated Reading Settings screen (Phase 1, item 4). Mirrors the
/// `_SettingsGroup` / `_SettingsRow` pattern used by `SettingsTabScreen` so
/// it fits the app's existing settings look without touching that file.
class ReadingSettingsScreen extends StatefulWidget {
  const ReadingSettingsScreen({super.key});

  @override
  State<ReadingSettingsScreen> createState() => _ReadingSettingsScreenState();
}

class _ReadingSettingsScreenState extends State<ReadingSettingsScreen> {
  bool _loading = true;
  double _arabicFontSp = 20;
  double _englishFontSp = 15;
  double _lineSpacing = 1.8;
  ReadingMode _defaultMode = ReadingMode.surah;
  bool _rememberLastPosition = true;
  QuranScript _script = QuranScript.uthmani;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final results = await Future.wait<Object>([
      StorageService.quranArabicFontSp,
      StorageService.quranEnglishFontSp,
      StorageService.quranLineSpacing,
      StorageService.quranDefaultReadingMode,
      StorageService.quranRememberLastPosition,
      StorageService.quranScript,
    ]);
    if (!mounted) return;
    setState(() {
      _arabicFontSp = results[0] as double;
      _englishFontSp = results[1] as double;
      _lineSpacing = results[2] as double;
      _defaultMode = ReadingMode.fromName(results[3] as String);
      _rememberLastPosition = results[4] as bool;
      _script = QuranScriptX.fromName(results[5] as String);
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: CustomAppBar(title: l10n.readingSettingsTitle),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 24.h),
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
                        unawaited(StorageService.setQuranArabicFontSp(value));
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
                        unawaited(StorageService.setQuranEnglishFontSp(value));
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
                        unawaited(StorageService.setQuranLineSpacing(value));
                      },
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
                            label: Text(l10n.readingSettingsScriptUthmani),
                          ),
                          ButtonSegment(
                            value: QuranScript.indopak,
                            label: Text(l10n.readingSettingsScriptIndopak),
                          ),
                        ],
                        selected: {_script},
                        onSelectionChanged: (selection) {
                          final script = selection.first;
                          setState(() => _script = script);
                          unawaited(StorageService.setQuranScript(script.name));
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
                          StorageService.setQuranRememberLastPosition(value),
                        );
                      },
                    ),
                  ],
                ),
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
