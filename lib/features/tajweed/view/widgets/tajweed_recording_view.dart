import 'dart:io' show Platform;

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../../../core/services/permission_service.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../quran/view/widgets/quran_audio_bar.dart';
import '../../model/tajweed_practice_args.dart';
import '../../viewmodel/tajweed_practice_view_model.dart';

/// Record-then-score screen: shows the reference ayah, listen + recite controls.
class TajweedRecordingView extends StatelessWidget {
  const TajweedRecordingView({
    super.key,
    required this.viewModel,
    required this.args,
  });

  final TajweedPracticeViewModel viewModel;
  final TajweedPracticeArgs args;

  String _statusLabel(AppLocalizations? l10n) {
    switch (viewModel.stage) {
      case TajweedFlowStage.recording:
        return l10n?.tajweedTapToStop ?? 'Tap to stop';
      case TajweedFlowStage.scoring:
        return 'Scoring your recitation…';
      default:
        return l10n?.tajweedStartReciting ?? 'Start reciting the ayah';
    }
  }

  String _formatElapsed(Duration d) {
    final m = d.inMinutes.remainder(60).toString().padLeft(2, '0');
    final s = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final isRecording = viewModel.stage == TajweedFlowStage.recording;
    final isScoring = viewModel.stage == TajweedFlowStage.scoring;
    final isBusy = isScoring || viewModel.actionInFlight;
    final canListen = !isRecording && !isBusy;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (kDebugMode && !kIsWeb && Platform.isIOS) ...[
                      _CoreMlDebugToggle(viewModel: viewModel),
                      const SizedBox(height: 12),
                    ],
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainer,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: colorScheme.outlineVariant
                              .withValues(alpha: 0.35),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  args.surahName != null
                                      ? '${args.surahName} · ${args.ref}'
                                      : 'Ayah ${args.ref}',
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                              IconButton(
                                tooltip: l10n?.quranAudioSettingsTitle ??
                                    'Audio settings',
                                onPressed: canListen
                                    ? () => showQuranAudioSettingsSheet(
                                          context,
                                          speed: viewModel.referenceSpeed,
                                          volume: viewModel.referenceVolume,
                                          repeatMode:
                                              viewModel.referenceRepeatMode,
                                          onSpeedChanged:
                                              viewModel.setReferenceSpeed,
                                          onVolumeChanged:
                                              viewModel.setReferenceVolume,
                                          onRepeatModeChanged:
                                              viewModel.setReferenceRepeatMode,
                                        )
                                    : null,
                                icon: const Icon(Icons.tune_rounded),
                                visualDensity: VisualDensity.compact,
                              ),
                            ],
                          ),
                          const SizedBox(height: 10),
                          FilledButton.tonalIcon(
                            onPressed: canListen
                                ? () => viewModel.toggleReferenceAudio()
                                : null,
                            icon: Icon(
                              viewModel.referencePlaying
                                  ? Icons.pause_circle_outline_rounded
                                  : Icons.volume_up_rounded,
                              size: 20,
                            ),
                            label: Text(
                              l10n?.tajweedListenToAyah ?? 'Listen to ayah',
                              style: theme.textTheme.labelMedium?.copyWith(
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            style: FilledButton.styleFrom(
                              visualDensity: VisualDensity.compact,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 10,
                              ),
                            ),
                          ),
                          const SizedBox(height: 14),
                          Text(
                            args.arabicText,
                            textAlign: TextAlign.center,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: args.arabicFontFamily,
                              fontSize: 26,
                              height: 1.9,
                            ),
                          ),
                          if (args.translation != null) ...[
                            const SizedBox(height: 12),
                            Text(
                              args.translation!,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (viewModel.recordingBanner != null) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(14),
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: colorScheme.errorContainer.withValues(alpha: 0.6),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      viewModel.recordingBanner!,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onErrorContainer,
                      ),
                    ),
                    if (viewModel.micPermissionDenied) ...[
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () =>
                            PermissionService.openAppSettingsAsync(),
                        child: const Text('Open app settings'),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            Text(
              _statusLabel(l10n),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            if (isRecording) ...[
              const SizedBox(height: 6),
              Text(
                _formatElapsed(viewModel.recordingElapsed),
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: colorScheme.primary,
                ),
              ),
            ],
            const SizedBox(height: 20),
            Center(
              child: GestureDetector(
                onTap: isBusy ? null : () => viewModel.toggleRecording(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  constraints: const BoxConstraints(minWidth: 200),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 28,
                    vertical: 20,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(999),
                    color: isRecording ? colorScheme.error : colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: (isRecording
                                ? colorScheme.error
                                : colorScheme.primary)
                            .withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: isBusy
                      ? const SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : Row(
                          mainAxisSize: MainAxisSize.min,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              isRecording
                                  ? Icons.stop_rounded
                                  : Icons.record_voice_over_rounded,
                              color: Colors.white,
                              size: 28,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              isRecording
                                  ? (l10n?.tajweedTapToStop ?? 'Tap to stop')
                                  : (l10n?.tajweedStartReciting ??
                                      'Start reciting'),
                              style: theme.textTheme.titleMedium?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isRecording)
              TextButton(
                onPressed: () => viewModel.cancelRecording(),
                child: const Text('Cancel'),
              )
            else
              const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

/// DEBUG iOS only: shows which CoreML pack will score, and toggles Official↔DIY.
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
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 10, 8, 10),
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
                      const SizedBox(height: 2),
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
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: viewModel.downloadProgress <= 0
                    ? null
                    : viewModel.downloadProgress.clamp(0.0, 1.0),
              ),
            ],
            if (viewModel.coreMlSwitchStatus != null) ...[
              const SizedBox(height: 6),
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
