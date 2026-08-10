import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/services/permission_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../quran/reading_engine/quran_transliteration.dart';
import '../../model/tajweed_practice_args.dart';
import '../../viewmodel/tajweed_practice_view_model.dart';
import 'tajweed_mic_button.dart';
import 'tajweed_reading_tools_sheet.dart';
import 'tajweed_waveform.dart';

/// Record-then-score screen with mic + waveform UI.
class TajweedRecordingView extends StatefulWidget {
  const TajweedRecordingView({
    super.key,
    required this.viewModel,
    required this.args,
  });

  final TajweedPracticeViewModel viewModel;
  final TajweedPracticeArgs args;

  @override
  State<TajweedRecordingView> createState() => _TajweedRecordingViewState();
}

class _TajweedRecordingViewState extends State<TajweedRecordingView> {
  bool _showTranslation = true;
  bool _showTransliteration = true;
  bool _prefsLoaded = false;

  TajweedPracticeViewModel get viewModel => widget.viewModel;
  TajweedPracticeArgs get args => widget.args;

  @override
  void initState() {
    super.initState();
    unawaited(_loadDisplayPrefs());
  }

  Future<void> _loadDisplayPrefs() async {
    final results = await Future.wait<bool>([
      StorageService.quranShowEnglish,
      StorageService.quranShowTransliteration,
    ]);
    if (!mounted) return;
    setState(() {
      _showTranslation = results[0];
      _showTransliteration = results[1];
      _prefsLoaded = true;
    });
  }

  Future<void> _openReadingTools() async {
    final changed = await showTajweedReadingToolsSheet(
      context,
      args: args,
      speed: viewModel.referenceSpeed,
      volume: viewModel.referenceVolume,
      repeatMode: viewModel.referenceRepeatMode,
      onSpeedChanged: viewModel.setReferenceSpeed,
      onVolumeChanged: viewModel.setReferenceVolume,
      onRepeatModeChanged: viewModel.setReferenceRepeatMode,
    );
    if (changed == true && mounted) {
      await _loadDisplayPrefs();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final isRecording = viewModel.stage == TajweedFlowStage.recording;
    final isScoring = viewModel.stage == TajweedFlowStage.scoring;
    final isBusy = isScoring || viewModel.actionInFlight;
    final canInteract = !isBusy;
    final transliteration = QuranTransliteration.of(args.arabicText);

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (kDebugMode && !kIsWeb && Platform.isIOS) ...[
                    _CoreMlDebugToggle(viewModel: viewModel),
                    SizedBox(height: 12.h),
                  ],
                  _AyahReferenceCard(
                    args: args,
                    showTranslation: _showTranslation && _prefsLoaded,
                    showTransliteration: _showTransliteration && _prefsLoaded,
                    transliteration: transliteration,
                    canInteract: canInteract,
                    isRecording: isRecording,
                    referencePlaying: viewModel.referencePlaying,
                    onOpenReadingTools: () => unawaited(_openReadingTools()),
                    onToggleAudio: viewModel.toggleReferenceAudio,
                  ),
                  if (viewModel.recordingBanner != null) ...[
                    SizedBox(height: 12.h),
                    _RecordingBanner(
                      message: viewModel.recordingBanner!,
                      micPermissionDenied: viewModel.micPermissionDenied,
                    ),
                  ],
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Center(
                  child: isBusy
                      ? SizedBox(
                          width: 96.r,
                          height: 96.r,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: colorScheme.primary,
                          ),
                        )
                      : TajweedMicButton(
                          isRecording: isRecording,
                          enabled: canInteract,
                          size: 96.r,
                          onTap: () => viewModel.toggleRecording(),
                        ),
                ),
                SizedBox(height: 16.h),
                TajweedWaveform(
                  active: isRecording,
                  color: colorScheme.primary,
                ),
                SizedBox(height: 10.h),
                Text(
                  isRecording
                      ? (l10n?.tajweedListeningHint ??
                          'Listening... recite clearly')
                      : isScoring
                      ? 'Scoring your recitation…'
                      : (l10n?.tajweedStartReciting ??
                          'Start reciting the ayah'),
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 20.h),
                if (isRecording)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => viewModel.cancelRecording(),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => viewModel.toggleRecording(),
                          icon: const Icon(Icons.stop_rounded, size: 18),
                          label: Text(
                            l10n?.tajweedStopAnalyse ?? 'Stop & analyse',
                          ),
                          style: FilledButton.styleFrom(
                            padding: EdgeInsets.symmetric(vertical: 14.h),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.r),
                            ),
                          ),
                        ),
                      ),
                    ],
                  )
                else
                  SizedBox(height: 48.h),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AyahReferenceCard extends StatelessWidget {
  const _AyahReferenceCard({
    required this.args,
    required this.showTranslation,
    required this.showTransliteration,
    required this.transliteration,
    required this.canInteract,
    required this.isRecording,
    required this.referencePlaying,
    required this.onOpenReadingTools,
    required this.onToggleAudio,
  });

  final TajweedPracticeArgs args;
  final bool showTranslation;
  final bool showTransliteration;
  final String transliteration;
  final bool canInteract;
  final bool isRecording;
  final bool referencePlaying;
  final VoidCallback onOpenReadingTools;
  final VoidCallback onToggleAudio;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(18.w, 16.h, 14.w, 20.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.42),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.28),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              const Spacer(),
              _CircleIconButton(
                tooltip: l10n?.quranReadingToolsTitle ?? 'Reading tools',
                icon: Icons.tune_rounded,
                onTap: canInteract && !isRecording ? onOpenReadingTools : null,
              ),
              SizedBox(width: 6.w),
              _CircleIconButton(
                tooltip: l10n?.tajweedListenToAyah ?? 'Listen to ayah',
                icon: referencePlaying
                    ? Icons.pause_circle_filled_rounded
                    : Icons.volume_up_rounded,
                iconColor: colorScheme.primary,
                onTap: canInteract && !isRecording ? onToggleAudio : null,
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            args.arabicText,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: args.arabicFontFamily,
              fontSize: 28.sp,
              height: 1.85,
              color: colorScheme.onSurface,
            ),
          ),
          if (showTransliteration && transliteration.isNotEmpty) ...[
            SizedBox(height: 10.h),
            Text(
              transliteration,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontStyle: FontStyle.italic,
                color: colorScheme.onSurfaceVariant,
                height: 1.45,
              ),
            ),
          ],
          if (showTranslation && args.translation != null) ...[
            SizedBox(height: 12.h),
            Text(
              args.translation!,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.82),
                height: 1.45,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({
    required this.tooltip,
    required this.icon,
    required this.onTap,
    this.iconColor,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback? onTap;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final enabled = onTap != null;

    return Tooltip(
      message: tooltip,
      child: Material(
        color: colorScheme.surface.withValues(alpha: 0.85),
        shape: const CircleBorder(),
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: enabled ? onTap : null,
          child: Padding(
            padding: EdgeInsets.all(8.r),
            child: Icon(
              icon,
              size: 20.sp,
              color: enabled
                  ? (iconColor ?? colorScheme.onSurfaceVariant)
                  : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
            ),
          ),
        ),
      ),
    );
  }
}

class _RecordingBanner extends StatelessWidget {
  const _RecordingBanner({
    required this.message,
    required this.micPermissionDenied,
  });

  final String message;
  final bool micPermissionDenied;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: colorScheme.errorContainer.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colorScheme.error.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onErrorContainer,
              height: 1.4,
            ),
          ),
          if (micPermissionDenied) ...[
            SizedBox(height: 8.h),
            TextButton(
              onPressed: () => PermissionService.openAppSettingsAsync(),
              child: const Text('Open app settings'),
            ),
          ],
        ],
      ),
    );
  }
}

class _CoreMlDebugToggle extends StatelessWidget {
  const _CoreMlDebugToggle({required this.viewModel});

  final TajweedPracticeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final official = viewModel.officialCoreMlActive;
    final busy = viewModel.coreMlSwitchBusy || viewModel.actionInFlight;

    return Material(
      color: official
          ? colorScheme.tertiaryContainer
          : colorScheme.secondaryContainer,
      borderRadius: BorderRadius.circular(14.r),
      child: Padding(
        padding: EdgeInsets.fromLTRB(14.w, 10.h, 8.w, 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        official
                            ? 'Scoring with: Official HF CoreML'
                            : 'Scoring with: DIY CoreML',
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        viewModel.activeCoreMlLabel,
                        style: theme.textTheme.bodySmall,
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    Text(
                      official ? 'Official' : 'DIY',
                      style: theme.textTheme.labelSmall,
                    ),
                    Switch.adaptive(
                      value: official,
                      onChanged: busy || !viewModel.coreMlOverrideAllowed
                          ? null
                          : (v) => viewModel.setOfficialCoreMlEnabled(v),
                    ),
                  ],
                ),
              ],
            ),
            Text(
              'OFF = DIY · ON = Official Hugging Face. Switch downloads the other pack and deletes the previous one.',
              style: theme.textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (viewModel.coreMlSwitchBusy) ...[
              SizedBox(height: 8.h),
              LinearProgressIndicator(
                value: viewModel.downloadProgress <= 0
                    ? null
                    : viewModel.downloadProgress.clamp(0.0, 1.0),
              ),
            ],
            if (viewModel.coreMlSwitchStatus != null) ...[
              SizedBox(height: 6.h),
              Text(
                viewModel.coreMlSwitchStatus!,
                style: theme.textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
            if (!viewModel.coreMlOverrideAllowed)
              Text(
                'overrideAllowed=false — full Debug rebuild required.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: colorScheme.error,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
