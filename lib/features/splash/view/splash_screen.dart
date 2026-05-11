import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/route_names.dart';
import '../../../core/constants/spacing.dart';
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
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      unawaited(
        TraceHelpers.traceImageLoad(
          'splash_png_decode_warmup',
          context,
          MemoryImage(_kSplashWarmupPngBytes),
        ),
      );
    });
    _navigateNext();
  }

  Future<void> _navigateNext() async {
    await TraceHelpers.traceScreen('SplashScreen', () async {
      await Future<void>.delayed(const Duration(milliseconds: 1900));
      final completed = await StorageService.onboardingCompleted;
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
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                AppIconCircle(icon: const Icon(CupertinoIcons.moon)),
                SizedBox(height: Spacing.md.h),
                Text(
                  AppLocalizations.of(context)!.appTitle,
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 36.sp,
                  ),

                ),
                SizedBox(height: Spacing.sm.h),
                Text(
                  AppLocalizations.of(context)!.appTagline,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    fontSize: 14.sp,
                    color: Theme.of(context).colorScheme.primary,
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
