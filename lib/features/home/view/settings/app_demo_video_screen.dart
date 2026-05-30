import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../../../l10n/app_localizations.dart';
import 'app_demo_video_manager.dart';

class AppDemoVideoScreen extends StatefulWidget {
  const AppDemoVideoScreen({super.key});

  @override
  State<AppDemoVideoScreen> createState() => _AppDemoVideoScreenState();
}

class _AppDemoVideoScreenState extends State<AppDemoVideoScreen> {
  AppDemoVideoManager? _manager;
  bool _started = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _manager ??= context.read<AppDemoVideoManager>();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _manager == null) return;
      unawaited(_startPlayback());
    });
  }

  Future<void> _startPlayback() async {
    if (_started || _manager == null) return;
    _started = true;
    try {
      await _manager!.enterFullscreen();
    } catch (_) {
      if (mounted) setState(() {});
    }
  }

  @override
  void dispose() {
    final m = _manager;
    if (m != null) {
      unawaited(m.leaveFullscreen());
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.appDemoTitle)),
      body: Consumer<AppDemoVideoManager>(
        builder: (context, demo, _) {
          final c = demo.controller;
          if (demo.hasError && c == null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.appDemoLoadFailed,
                  textAlign: TextAlign.center,
                  style: Theme.of(
                    context,
                  ).textTheme.bodyLarge?.copyWith(color: colorScheme.error),
                ),
              ),
            );
          }
          if (c == null) {
            return const Center(child: CircularProgressIndicator());
          }
          // Body [Center] is the middle of the area below the app bar, which sits
          // ~half a toolbar below the screen's visual center; nudge up to match.
          return Transform.translate(
            offset: const Offset(0, -kToolbarHeight / 2),
            child: Center(
              child: AspectRatio(
                aspectRatio: c.value.aspectRatio,
                child: VideoPlayer(c),
              ),
            ),
          );
        },
      ),
    );
  }
}
