import 'package:flutter/material.dart';

import '../../../../core/services/permission_service.dart';
import '../../model/tajweed_practice_args.dart';
import '../../viewmodel/tajweed_practice_view_model.dart';

/// Record-then-score screen: shows the reference ayah, a mic button that
/// starts/stops recording, and live state feedback. Backed by the existing
/// native engine via `TajweedService.startRecording`/`stopRecordingAndScore`
/// (unchanged) — this widget only renders state from `TajweedPracticeViewModel`.
class TajweedRecordingView extends StatelessWidget {
  const TajweedRecordingView({
    super.key,
    required this.viewModel,
    required this.args,
  });

  final TajweedPracticeViewModel viewModel;
  final TajweedPracticeArgs args;

  String get _statusLabel {
    switch (viewModel.stage) {
      case TajweedFlowStage.recording:
        return 'Listening… tap to stop';
      case TajweedFlowStage.scoring:
        return 'Scoring your recitation…';
      default:
        return 'Tap the mic and recite the ayah';
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
    final isRecording = viewModel.stage == TajweedFlowStage.recording;
    final isScoring = viewModel.stage == TajweedFlowStage.scoring;
    final isBusy = isScoring || viewModel.actionInFlight;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    args.surahName != null
                        ? '${args.surahName} · ${args.ref}'
                        : 'Ayah ${args.ref}',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
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
            const Spacer(),
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
                        onPressed: () => PermissionService.openAppSettingsAsync(),
                        child: const Text('Open app settings'),
                      ),
                    ],
                  ],
                ),
              ),
            ],
            Text(
              _statusLabel,
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
                onTap: isBusy
                    ? null
                    : () => viewModel.toggleRecording(),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 88,
                  height: 88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isRecording ? colorScheme.error : colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color:
                            (isRecording ? colorScheme.error : colorScheme.primary)
                                .withValues(alpha: 0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: isBusy
                      ? const Padding(
                          padding: EdgeInsets.all(28),
                          child: CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          ),
                        )
                      : Icon(
                          isRecording
                              ? Icons.stop_rounded
                              : Icons.mic_rounded,
                          color: Colors.white,
                          size: 36,
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
              const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}
