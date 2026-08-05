import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/route_deferred_gates.dart';
import '../../../app/routes/route_names.dart';
import '../../../core/constants/spacing.dart';
import '../../../core/logger/startup_probe.dart';
import '../../../core/logger/trace_helpers.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/widgets/app_icon_circle.dart';
import '../../../l10n/app_localizations.dart';

/// 1×1 PNG — decodes a real image pipeline on low-end GPUs without adding assets.
final Uint8List _kSplashWarmupPngBytes = base64Decode(
  'iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVR42mP8z8BQDwAEhQGAhKmMIQAAAABJRU5ErkJggg==',
);

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    StartupProbe.mark('SplashScreen.initState begin');
    StartupProbe.timeSync('SplashScreen.initState: AnimationController', () {
      _controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 1600),
      );
    });
    StartupProbe.timeSync('SplashScreen.initState: CurvedAnimation', () {
      _fadeAnimation = CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      );
    });
    StartupProbe.timeSync('SplashScreen.initState: controller.forward', () {
      _controller.forward();
    });
    // First frame paints immediately; async navigation + preload after paint.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StartupProbe.detail('SplashScreen post-frame: navigate+preload begin');
      if (!mounted) return;
      unawaited(preloadPostSplashRouteLibraries());
      unawaited(
        TraceHelpers.traceImageLoad(
          'splash_png_decode_warmup',
          context,
          MemoryImage(_kSplashWarmupPngBytes),
        ),
      );
      unawaited(_navigateNext());
    });
    StartupProbe.mark('SplashScreen.initState end');
  }

  Future<void> _navigateNext() async {
    await TraceHelpers.traceScreen('SplashScreen', () async {
      await Future<void>.delayed(const Duration(milliseconds: 1900));
      var completed = false;
      try {
        completed = await StorageService.onboardingCompleted.timeout(
          const Duration(seconds: 2),
        );
      } catch (e) {
        debugPrint('[Splash] onboardingCompleted timed out/failed: $e');
      }
      if (!mounted) return;
      if (completed) {
        context.go(RouteNames.home);
      } else {
        context.go(RouteNames.onboarding);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StartupProbe.mark('SplashScreen.build begin');
    final l10n = StartupProbe.timeSync(
      'SplashScreen.build: AppLocalizations.of',
      () => AppLocalizations.of(context),
    );
    final theme = StartupProbe.timeSync(
      'SplashScreen.build: Theme.of',
      () => Theme.of(context),
    );
    final scaffold = StartupProbe.timeSync(
      'SplashScreen.build: Scaffold tree',
      () => Scaffold(
        body: SafeArea(
          child: Center(
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  StartupProbe.timeSync(
                    'SplashScreen.build: AppIconCircle',
                    () => AppIconCircle(icon: const Icon(CupertinoIcons.moon)),
                  ),
                  SizedBox(height: Spacing.md.h),
                  Text(
                    l10n?.appTitle ?? 'Deenly',
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                      fontSize: 36.sp,
                    ),
                  ),
                  SizedBox(height: Spacing.sm.h),
                  Text(
                    l10n?.appTagline ?? '',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
    StartupProbe.mark('SplashScreen.build end');
    return scaffold;
  }
}
