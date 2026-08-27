import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/share/content_share_service.dart';
import '../../../../core/services/quran_bookmark_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../quran/reading_engine/quran_repeat_mode.dart';
import '../../../quran/reading_engine/quran_transliteration.dart';
import '../../../quran/view/quran_reading_settings_launcher.dart';
import '../../../quran/view/widgets/quran_audio_bar.dart';
import '../../model/tajweed_practice_args.dart';

/// Quick-access reading tools for the Tajweed practice screen.
Future<bool?> showTajweedReadingToolsSheet(
  BuildContext context, {
  required TajweedPracticeArgs args,
  required double speed,
  required double volume,
  required QuranRepeatMode repeatMode,
  required ValueChanged<double> onSpeedChanged,
  required ValueChanged<double> onVolumeChanged,
  required ValueChanged<QuranRepeatMode> onRepeatModeChanged,
}) {
  return showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    backgroundColor: Theme.of(context).colorScheme.surface,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (ctx) => _TajweedReadingToolsSheet(
      args: args,
      speed: speed,
      volume: volume,
      repeatMode: repeatMode,
      onSpeedChanged: onSpeedChanged,
      onVolumeChanged: onVolumeChanged,
      onRepeatModeChanged: onRepeatModeChanged,
    ),
  );
}

class _TajweedReadingToolsSheet extends StatefulWidget {
  const _TajweedReadingToolsSheet({
    required this.args,
    required this.speed,
    required this.volume,
    required this.repeatMode,
    required this.onSpeedChanged,
    required this.onVolumeChanged,
    required this.onRepeatModeChanged,
  });

  final TajweedPracticeArgs args;
  final double speed;
  final double volume;
  final QuranRepeatMode repeatMode;
  final ValueChanged<double> onSpeedChanged;
  final ValueChanged<double> onVolumeChanged;
  final ValueChanged<QuranRepeatMode> onRepeatModeChanged;

  @override
  State<_TajweedReadingToolsSheet> createState() =>
      _TajweedReadingToolsSheetState();
}

class _TajweedReadingToolsSheetState extends State<_TajweedReadingToolsSheet> {
  late bool _showTranslation;
  late bool _showTransliteration;
  bool _loading = true;
  bool _displayPrefsChanged = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    final results = await Future.wait<bool>([
      StorageService.quranShowEnglish,
      StorageService.quranShowTransliteration,
    ]);
    if (!mounted) return;
    setState(() {
      _showTranslation = results[0];
      _showTransliteration = results[1];
      _loading = false;
    });
  }

  void _snack(String message) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(message), duration: const Duration(seconds: 2)),
    );
  }

  Future<void> _toggleTranslation(bool value) async {
    await StorageService.setQuranShowEnglish(value);
    if (!mounted) return;
    setState(() {
      _showTranslation = value;
      _displayPrefsChanged = true;
    });
  }

  Future<void> _toggleTransliteration(bool value) async {
    await StorageService.setQuranShowTransliteration(value);
    if (!mounted) return;
    setState(() {
      _showTransliteration = value;
      _displayPrefsChanged = true;
    });
  }

  Future<void> _bookmarkAyah() async {
    final l10n = AppLocalizations.of(context)!;
    final args = widget.args;
    final label =
        '${args.surahName ?? l10n.quranSurahLabel} ${args.surah}:${args.ayah}';
    await QuranBookmarkService.add(
      QuranBookmark(
        id: QuranBookmarkService.idFor(
          kind: QuranBookmarkKind.ayah,
          surah: args.surah,
          ayah: args.ayah,
        ),
        kind: QuranBookmarkKind.ayah,
        label: label,
        surah: args.surah,
        ayah: args.ayah,
        createdAtMs: DateTime.now().millisecondsSinceEpoch,
      ),
    );
    if (mounted) _snack(l10n.quranBookmarkSaved);
  }

  Future<void> _copyAyah() async {
    final buffer = StringBuffer(widget.args.arabicText);
    final transliteration = QuranTransliteration.of(widget.args.arabicText);
    if (_showTransliteration && transliteration.isNotEmpty) {
      buffer.writeln();
      buffer.writeln();
      buffer.write(transliteration);
    }
    final translation = widget.args.translation;
    if (_showTranslation && translation != null && translation.trim().isNotEmpty) {
      buffer.writeln();
      buffer.writeln();
      buffer.write(translation);
    }
    await Clipboard.setData(ClipboardData(text: buffer.toString()));
    if (mounted) {
      _snack(AppLocalizations.of(context)!.quranCopied);
    }
  }

  Future<void> _shareAyah() async {
    await ContentShareService.shareIntro(context: context);
  }

  void _openAudioSettings() {
    Navigator.pop(context, _displayPrefsChanged);
    showQuranAudioSettingsSheet(
      context,
      speed: widget.speed,
      volume: widget.volume,
      repeatMode: widget.repeatMode,
      onSpeedChanged: widget.onSpeedChanged,
      onVolumeChanged: widget.onVolumeChanged,
      onRepeatModeChanged: widget.onRepeatModeChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    if (_loading) {
      return SizedBox(
        height: 220.h,
        child: const Center(child: CircularProgressIndicator()),
      );
    }

    return Padding(
      padding: EdgeInsets.fromLTRB(
        20.w,
        0,
        20.w,
        24.h + MediaQuery.viewPaddingOf(context).bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.quranReadingToolsTitle,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: 16.h),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.25),
              ),
            ),
            child: Column(
              children: [
                SwitchListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  title: Text(l10n.readingSettingsShowTranslation),
                  value: _showTranslation,
                  onChanged: (v) => unawaited(_toggleTranslation(v)),
                ),
                Divider(
                  height: 1,
                  indent: 16.w,
                  endIndent: 16.w,
                  color: colorScheme.outlineVariant.withValues(alpha: 0.25),
                ),
                SwitchListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.w),
                  title: Text(l10n.readingSettingsShowTransliteration),
                  value: _showTransliteration,
                  onChanged: (v) => unawaited(_toggleTransliteration(v)),
                ),
              ],
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            l10n.quranQuickActions,
            style: theme.textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 10.h),
          _ActionGrid(
            items: [
              _ActionItem(
                icon: Icons.speed_rounded,
                label: l10n.quranPlaybackSpeed,
                onTap: _openAudioSettings,
              ),
              _ActionItem(
                icon: Icons.repeat_rounded,
                label: l10n.quranRepeat,
                onTap: _openAudioSettings,
              ),
              _ActionItem(
                icon: Icons.bookmark_add_outlined,
                label: l10n.quranBookmark,
                onTap: () => unawaited(_bookmarkAyah()),
              ),
              _ActionItem(
                icon: Icons.content_copy_rounded,
                label: l10n.quranCopy,
                onTap: () => unawaited(_copyAyah()),
              ),
              _ActionItem(
                icon: Icons.share_rounded,
                label: l10n.quranShare,
                onTap: () => unawaited(_shareAyah()),
              ),
              _ActionItem(
                icon: Icons.tune_rounded,
                label: l10n.readingSettingsTitle,
                onTap: () {
                  Navigator.pop(context, _displayPrefsChanged);
                  unawaited(QuranReadingSettingsLauncher.open(context));
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ActionItem {
  const _ActionItem({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
}

class _ActionGrid extends StatelessWidget {
  const _ActionGrid({required this.items});

  final List<_ActionItem> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const columns = 3;
        const spacing = 10.0;
        final tileWidth =
            (constraints.maxWidth - spacing * (columns - 1)) / columns;

        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final item in items)
              SizedBox(
                width: tileWidth,
                child: _ActionTile(item: item),
              ),
          ],
        );
      },
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({required this.item});

  final _ActionItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: item.onTap,
        child: Ink(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14.r),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 14.h),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(item.icon, size: 22.sp, color: colorScheme.primary),
                SizedBox(height: 8.h),
                Text(
                  item.label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: colorScheme.onSurface,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
