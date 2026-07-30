import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../reading_engine/quran_repeat_mode.dart';

const List<double> quranPlaybackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

/// Bottom audio bar for the Juz and Page reading screens. Same footprint as
/// the original Surah screen's inline bottom bar, plus the Phase 1 audio
/// improvements (speed / volume / repeat) via a settings popup.
class QuranAudioBar extends StatelessWidget {
  const QuranAudioBar({
    super.key,
    required this.label,
    required this.position,
    required this.duration,
    required this.isPlaying,
    required this.isLoading,
    required this.speed,
    required this.volume,
    required this.repeatMode,
    required this.onTogglePlayPause,
    required this.onClose,
    required this.onSeekStart,
    required this.onSeekChanged,
    required this.onSeekEnd,
    required this.onSpeedChanged,
    required this.onVolumeChanged,
    required this.onRepeatModeChanged,
  });

  final String label;
  final Duration position;
  final Duration duration;
  final bool isPlaying;
  final bool isLoading;
  final double speed;
  final double volume;
  final QuranRepeatMode repeatMode;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onClose;
  final VoidCallback onSeekStart;
  final ValueChanged<double> onSeekChanged;
  final ValueChanged<double> onSeekEnd;
  final ValueChanged<double> onSpeedChanged;
  final ValueChanged<double> onVolumeChanged;
  final ValueChanged<QuranRepeatMode> onRepeatModeChanged;

  int get _sliderDurationMs => duration.inMilliseconds <= 0
      ? 0
      : duration.inMilliseconds;

  double get _sliderProgress {
    if (_sliderDurationMs <= 0) return 0;
    return (position.inMilliseconds / _sliderDurationMs).clamp(0, 1);
  }

  String _formatTime(Duration value) {
    final totalSeconds = value.inSeconds.clamp(0, 999999);
    final minutes = totalSeconds ~/ 60;
    final seconds = totalSeconds % 60;
    return '$minutes:${seconds.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return Positioned(
      left: 0.w,
      right: 0.w,
      bottom: Platform.isIOS ? -30 : 0,
      child: Container(
        padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(60.r),
            bottomRight: Radius.circular(60.r),
          ),
          border: Border.all(
            color: colorScheme.outlineVariant.withValues(alpha: 0.55),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                _AudioSettingsButton(
                  speed: speed,
                  volume: volume,
                  repeatMode: repeatMode,
                  onSpeedChanged: onSpeedChanged,
                  onVolumeChanged: onVolumeChanged,
                  onRepeatModeChanged: onRepeatModeChanged,
                ),
                SizedBox(width: 6.w),
                GestureDetector(
                  onTap: onClose,
                  child: Container(
                    width: 22.w,
                    height: 22.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorScheme.surfaceContainerHighest,
                    ),
                    child: Icon(
                      Icons.close_rounded,
                      size: 14.sp,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 6.h),
            Row(
              children: [
                Expanded(
                  child: Text(
                    _formatTime(position),
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                if (repeatMode != QuranRepeatMode.off) ...[
                  Icon(
                    Icons.repeat_rounded,
                    size: 14.sp,
                    color: colorScheme.primary,
                  ),
                  SizedBox(width: 4.w),
                  Text(
                    repeatMode == QuranRepeatMode.ayah
                        ? l10n.quranRepeatAyah
                        : l10n.quranRepeatSurah,
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 8.w),
                ],
                Text(
                  _formatTime(duration),
                  style: TextStyle(
                    fontSize: 13.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
            Slider(
              value: _sliderProgress,
              min: 0,
              max: 1,
              onChangeStart: (_) => onSeekStart(),
              onChanged: onSeekChanged,
              onChangeEnd: onSeekEnd,
            ),
            SizedBox(height: 2.h),
            SizedBox(
              width: 56.w,
              height: 56.w,
              child: isLoading
                  ? const CircularProgressIndicator(strokeWidth: 2)
                  : FilledButton(
                      onPressed: onTogglePlayPause,
                      style: FilledButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: EdgeInsets.zero,
                      ),
                      child: Icon(
                        isPlaying ? Icons.pause : Icons.play_arrow_rounded,
                        size: 28.sp,
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AudioSettingsButton extends StatelessWidget {
  const _AudioSettingsButton({
    required this.speed,
    required this.volume,
    required this.repeatMode,
    required this.onSpeedChanged,
    required this.onVolumeChanged,
    required this.onRepeatModeChanged,
  });

  final double speed;
  final double volume;
  final QuranRepeatMode repeatMode;
  final ValueChanged<double> onSpeedChanged;
  final ValueChanged<double> onVolumeChanged;
  final ValueChanged<QuranRepeatMode> onRepeatModeChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return IconButton(
      visualDensity: VisualDensity.compact,
      icon: Icon(
        Icons.tune_rounded,
        size: 18.sp,
        color: colorScheme.onSurfaceVariant,
      ),
      onPressed: () => showQuranAudioSettingsSheet(
        context,
        speed: speed,
        volume: volume,
        repeatMode: repeatMode,
        onSpeedChanged: onSpeedChanged,
        onVolumeChanged: onVolumeChanged,
        onRepeatModeChanged: onRepeatModeChanged,
      ),
    );
  }
}

/// Shared bottom sheet for playback speed / volume / repeat — used by the
/// Surah, Juz and Page reading screens.
Future<void> showQuranAudioSettingsSheet(
  BuildContext context, {
  required double speed,
  required double volume,
  required QuranRepeatMode repeatMode,
  required ValueChanged<double> onSpeedChanged,
  required ValueChanged<double> onVolumeChanged,
  required ValueChanged<QuranRepeatMode> onRepeatModeChanged,
}) {
  final l10n = AppLocalizations.of(context)!;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          final colorScheme = Theme.of(sheetContext).colorScheme;
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.quranAudioSettingsTitle,
                    style: Theme.of(sheetContext).textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    l10n.quranPlaybackSpeed,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      for (final option in quranPlaybackSpeeds)
                        ChoiceChip(
                          label: Text('${option}x'),
                          selected: speed == option,
                          onSelected: (_) {
                            onSpeedChanged(option);
                            setSheetState(() => speed = option);
                          },
                        ),
                    ],
                  ),
                  SizedBox(height: 20.h),
                  Text(
                    l10n.quranVolume,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.volume_down_rounded,
                        size: 18.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      Expanded(
                        child: Slider(
                          value: volume,
                          min: 0,
                          max: 1,
                          onChanged: (value) {
                            onVolumeChanged(value);
                            setSheetState(() => volume = value);
                          },
                        ),
                      ),
                      Icon(
                        Icons.volume_up_rounded,
                        size: 18.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    l10n.quranRepeat,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    children: [
                      ChoiceChip(
                        label: Text(l10n.quranRepeatOff),
                        selected: repeatMode == QuranRepeatMode.off,
                        onSelected: (_) {
                          onRepeatModeChanged(QuranRepeatMode.off);
                          setSheetState(() => repeatMode = QuranRepeatMode.off);
                        },
                      ),
                      ChoiceChip(
                        label: Text(l10n.quranRepeatAyah),
                        selected: repeatMode == QuranRepeatMode.ayah,
                        onSelected: (_) {
                          onRepeatModeChanged(QuranRepeatMode.ayah);
                          setSheetState(
                            () => repeatMode = QuranRepeatMode.ayah,
                          );
                        },
                      ),
                      ChoiceChip(
                        label: Text(l10n.quranRepeatSurah),
                        selected: repeatMode == QuranRepeatMode.surah,
                        onSelected: (_) {
                          onRepeatModeChanged(QuranRepeatMode.surah);
                          setSheetState(
                            () => repeatMode = QuranRepeatMode.surah,
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
    },
  );
}
