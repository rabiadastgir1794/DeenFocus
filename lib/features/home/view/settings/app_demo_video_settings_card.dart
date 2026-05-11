import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import 'app_demo_video_manager.dart';
import 'app_demo_video_screen.dart';

const String _kAppDemoVideoThumbnailAsset = 'assets/video/video_thumbnail.png';

/// Settings "App Demo" row: static thumbnail preview, tap opens fullscreen.
class AppDemoVideoSettingsCard extends StatefulWidget {
  const AppDemoVideoSettingsCard({super.key, required this.isTabActive});

  /// Warm up the player only when the Settings tab is selected.
  final bool isTabActive;

  @override
  State<AppDemoVideoSettingsCard> createState() =>
      _AppDemoVideoSettingsCardState();
}

class _AppDemoVideoSettingsCardState extends State<AppDemoVideoSettingsCard> {
  @override
  void initState() {
    super.initState();
    if (widget.isTabActive) {
      _scheduleWarmUp();
    }
  }

  @override
  void didUpdateWidget(AppDemoVideoSettingsCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isTabActive && !oldWidget.isTabActive) {
      _scheduleWarmUp();
    }
  }

  void _scheduleWarmUp() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !widget.isTabActive) return;
      unawaited(
        context.read<AppDemoVideoManager>().ensurePreviewReady().catchError(
              (Object _) {},
            ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Consumer<AppDemoVideoManager>(
      builder: (context, demo, _) {
        final c = demo.controller;
        final err = demo.lastError;
        final channelBroken = err is PlatformException &&
            err.code == 'channel-error';

        return Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: demo.hasError && c == null
                ? null
                : () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const AppDemoVideoScreen(),
                      ),
                    );
                  },
            borderRadius: BorderRadius.circular(24),
            child: Ink(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.appDemoTitle,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 14),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(18),
                    child: SizedBox(
                      width: double.infinity,
                      height: 180,
                      child: _buildPreviewBody(
                        context,
                        demo,
                        channelBroken,
                        l10n,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildPreviewBody(
    BuildContext context,
    AppDemoVideoManager demo,
    bool channelBroken,
    AppLocalizations l10n,
  ) {
    final colorScheme = Theme.of(context).colorScheme;

    if (demo.hasError && demo.controller == null) {
      return ColoredBox(
        color: colorScheme.surfaceContainerHighest,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.error_outline_rounded,
                  color: colorScheme.error,
                  size: 36,
                ),
                const SizedBox(height: 8),
                Text(
                  channelBroken
                      ? l10n.appDemoRestartHint
                      : l10n.appDemoPreviewLoadFailed,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                ),
                const SizedBox(height: 12),
                TextButton(
                  onPressed: () => unawaited(demo.retry()),
                  child: Text(l10n.appDemoTryAgain),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.asset(
          _kAppDemoVideoThumbnailAsset,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => ColoredBox(
            color: colorScheme.surfaceContainerHighest,
            child: Icon(
              Icons.ondemand_video_rounded,
              size: 48,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          color: Colors.black.withValues(alpha: 0.22),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: colorScheme.primary.withValues(alpha: 0.9),
                ),
                child: Icon(
                  Icons.play_arrow_rounded,
                  size: 30,
                  color: colorScheme.onPrimary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                l10n.appDemoWatchLabel,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                      shadows: const [
                        Shadow(
                          blurRadius: 8,
                          color: Colors.black54,
                        ),
                      ],
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
