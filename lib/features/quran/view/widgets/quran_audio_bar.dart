import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../reading_engine/quran_repeat_mode.dart';
import 'quran_reader_theme.dart';

const List<double> quranPlaybackSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 2.0];

/// Bottom audio bar for Surah, Juz, and Page reading screens.
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
    this.floating = true,
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
  final bool floating;

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
    final card = _AudioBarCard(
      label: label,
      position: position,
      duration: duration,
      isPlaying: isPlaying,
      isLoading: isLoading,
      speed: speed,
      volume: volume,
      repeatMode: repeatMode,
      sliderProgress: _sliderProgress,
      formatTime: _formatTime,
      onTogglePlayPause: onTogglePlayPause,
      onClose: onClose,
      onSeekStart: onSeekStart,
      onSeekChanged: onSeekChanged,
      onSeekEnd: onSeekEnd,
      onSpeedChanged: onSpeedChanged,
      onVolumeChanged: onVolumeChanged,
      onRepeatModeChanged: onRepeatModeChanged,
    );

    if (!floating) {
      return Padding(
        padding: EdgeInsets.fromLTRB(12.w, 0, 12.w, 8.h),
        child: card,
      );
    }

    return Positioned(
      left: 12.w,
      right: 12.w,
      bottom: Platform.isIOS ? 8.h : 12.h,
      child: card,
    );
  }
}

class _AudioBarCard extends StatelessWidget {
  const _AudioBarCard({
    required this.label,
    required this.position,
    required this.duration,
    required this.isPlaying,
    required this.isLoading,
    required this.speed,
    required this.volume,
    required this.repeatMode,
    required this.sliderProgress,
    required this.formatTime,
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
  final double sliderProgress;
  final String Function(Duration) formatTime;
  final VoidCallback onTogglePlayPause;
  final VoidCallback onClose;
  final VoidCallback onSeekStart;
  final ValueChanged<double> onSeekChanged;
  final ValueChanged<double> onSeekEnd;
  final ValueChanged<double> onSpeedChanged;
  final ValueChanged<double> onVolumeChanged;
  final ValueChanged<QuranRepeatMode> onRepeatModeChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.quranReader;

    return ClipRRect(
      borderRadius: BorderRadius.circular(28.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: AnimatedContainer(
          duration: QuranReaderPalette.animDuration,
          curve: QuranReaderPalette.animCurve,
          padding: EdgeInsets.fromLTRB(18.w, 16.h, 18.w, 18.h),
          decoration: BoxDecoration(
            color: palette.paper.withValues(alpha: 0.88),
            borderRadius: BorderRadius.circular(28.r),
            border: Border.all(color: palette.glassBorder),
            boxShadow: palette.floatingShadow,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          label,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.w700,
                            color: palette.textPrimary,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          '${speed}x · ${l10n.quranPlaybackSpeed}',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: palette.textSecondary,
                          ),
                        ),
                      ],
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
                  SizedBox(width: 4.w),
                  _RoundIconButton(
                    icon: Icons.close_rounded,
                    onTap: onClose,
                  ),
                ],
              ),
              SizedBox(height: 10.h),
              Row(
                children: [
                  Text(
                    formatTime(position),
                    style: TextStyle(
                      fontSize: 12.sp,
                      fontWeight: FontWeight.w600,
                      color: palette.textPrimary,
                    ),
                  ),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        trackHeight: 3.h,
                        thumbShape: RoundSliderThumbShape(enabledThumbRadius: 6.r),
                        overlayShape: RoundSliderOverlayShape(overlayRadius: 14.r),
                        activeTrackColor: palette.primary,
                        inactiveTrackColor:
                            palette.accent.withValues(alpha: 0.28),
                        thumbColor: palette.primary,
                      ),
                      child: Slider(
                        value: sliderProgress,
                        min: 0,
                        max: 1,
                        onChangeStart: (_) => onSeekStart(),
                        onChanged: onSeekChanged,
                        onChangeEnd: onSeekEnd,
                      ),
                    ),
                  ),
                  Text(
                    formatTime(duration),
                    style: TextStyle(
                      fontSize: 12.sp,
                      color: palette.textSecondary,
                    ),
                  ),
                ],
              ),
              if (repeatMode != QuranRepeatMode.off) ...[
                SizedBox(height: 4.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.repeat_rounded,
                      size: 14.sp,
                      color: palette.primary,
                    ),
                    SizedBox(width: 4.w),
                    Text(
                      repeatMode == QuranRepeatMode.ayah
                          ? l10n.quranRepeatAyah
                          : l10n.quranRepeatSurah,
                      style: TextStyle(
                        fontSize: 11.sp,
                        fontWeight: FontWeight.w600,
                        color: palette.primary,
                      ),
                    ),
                  ],
                ),
              ],
              SizedBox(height: 8.h),
              _RoundIconButton(
                icon: isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
                onTap: isLoading ? null : onTogglePlayPause,
                large: true,
                loading: isLoading,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    this.large = false,
    this.loading = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool large;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    final palette = context.quranReader;
    final size = large ? 56.r : 36.r;
    return Material(
      color: large
          ? palette.primary
          : palette.background.withValues(alpha: 0.7),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: loading
              ? Padding(
                  padding: EdgeInsets.all(large ? 14.r : 8.r),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: large ? Colors.white : palette.primary,
                  ),
                )
              : Icon(
                  icon,
                  size: large ? 28.sp : 18.sp,
                  color: large ? Colors.white : palette.textPrimary,
                ),
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
    return _RoundIconButton(
      icon: Icons.tune_rounded,
      onTap: () => showQuranAudioSettingsSheet(
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

/// Shared bottom sheet for playback speed / volume / repeat.
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
  final palette = context.quranReader;
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    backgroundColor: palette.paper,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24.r)),
    ),
    builder: (sheetContext) {
      return StatefulBuilder(
        builder: (sheetContext, setSheetState) {
          return SafeArea(
            child: Padding(
              padding: EdgeInsets.fromLTRB(20.w, 4.h, 20.w, 20.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.quranAudioSettingsTitle,
                    style: Theme.of(sheetContext).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: palette.textPrimary,
                        ),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    l10n.quranPlaybackSpeed,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: palette.textSecondary,
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
                      color: palette.textSecondary,
                    ),
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.volume_down_rounded,
                        size: 18.sp,
                        color: palette.textSecondary,
                      ),
                      Expanded(
                        child: Slider(
                          value: volume,
                          min: 0,
                          max: 1,
                          activeColor: palette.primary,
                          onChanged: (value) {
                            onVolumeChanged(value);
                            setSheetState(() => volume = value);
                          },
                        ),
                      ),
                      Icon(
                        Icons.volume_up_rounded,
                        size: 18.sp,
                        color: palette.textSecondary,
                      ),
                    ],
                  ),
                  SizedBox(height: 12.h),
                  Text(
                    l10n.quranRepeat,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: palette.textSecondary,
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
