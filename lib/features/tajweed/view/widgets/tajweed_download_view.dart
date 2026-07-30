import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../viewmodel/tajweed_practice_view_model.dart';

/// One-time "preparing the offline AI model" screen shown by
/// `TajweedPracticeScreen` while `ensureModel()` downloads/verifies the
/// on-device pack. Automatically replaced by the recording screen on success.
class TajweedDownloadView extends StatelessWidget {
  const TajweedDownloadView({super.key, required this.viewModel});

  final TajweedPracticeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final failed = viewModel.stage == TajweedFlowStage.downloadFailed;
    final percent = (viewModel.downloadProgress * 100)
        .clamp(0, 100)
        .toStringAsFixed(0);

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: (failed ? colorScheme.error : colorScheme.primary)
                    .withValues(alpha: 0.12),
              ),
              child: Icon(
                failed ? Icons.error_outline_rounded : Icons.mic_rounded,
                size: 40,
                color: failed ? colorScheme.error : colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              failed ? 'Could not prepare AI model' : 'Preparing AI model',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              failed
                  ? (viewModel.errorMessage ?? 'Please try again.')
                  : 'One-time download so Tajweed practice works fully '
                        'offline afterwards. This only happens once.',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 28),
            if (!failed) ...[
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: viewModel.downloadProgress <= 0
                      ? null
                      : viewModel.downloadProgress.clamp(0.0, 1.0),
                  minHeight: 8,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                '$percent%',
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  onPressed: () => viewModel.retryDownload(),
                  icon: const Icon(Icons.refresh_rounded),
                  label: const Text('Try again'),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () {
                    if (context.canPop()) context.pop();
                  },
                  child: const Text('Not now'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
