import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../app/routes/route_names.dart';
import '../../../core/constants/spacing.dart';
import '../../../core/logger/startup_diagnostics.dart';
import '../../../core/logger/startup_probe.dart';
import '../../../core/logger/trace_helpers.dart';
import '../../../core/services/storage_service.dart';
import '../../../l10n/app_localizations.dart';

const String _kAppIconAsset = 'assets/app_icon.png';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _iconScale;
  late final Animation<double> _iconOpacity;
  late final Animation<double> _glowOpacity;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleOpacity;
  late final Animation<Offset> _taglineSlide;
  late final Animation<double> _taglineOpacity;

  @override
  void initState() {
    super.initState();
    StartupProbe.mark('SplashScreen.initState begin');
    _controller = AnimationController(
      vsync: this,
      duration: StartupDiagnostics.simpleSplash
          ? Duration.zero
          : const Duration(milliseconds: 400),
    );
    _iconScale = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween(
          begin: 0.72,
          end: 1.06,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 55,
      ),
      TweenSequenceItem(
        tween: Tween(
          begin: 1.06,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 45,
      ),
    ]).animate(_controller);
    _iconOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.32, curve: Curves.easeOut),
    );
    _glowOpacity = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.04, 0.48, curve: Curves.easeOut),
    );
    final titleCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.28, 0.62, curve: Curves.easeOutCubic),
    );
    _titleOpacity = titleCurve;
    _titleSlide = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(titleCurve);
    final taglineCurve = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.44, 0.82, curve: Curves.easeOutCubic),
    );
    _taglineOpacity = taglineCurve;
    _taglineSlide = Tween<Offset>(
      begin: const Offset(0, 0.4),
      end: Offset.zero,
    ).animate(taglineCurve);
    _controller.forward();
    StartupProbe.mark('SplashScreen animation start');
    // Destination is warmed in main() before runApp — no timeout.
    // Do not preload Home+Onboarding here — deferred JIT starves this isolate.
    final destinationFuture = _resolveDestination();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      StartupProbe.detail('SplashScreen post-frame: navigate begin');
      if (!mounted) return;
      unawaited(precacheImage(const AssetImage(_kAppIconAsset), context));
      unawaited(_navigateNext(destinationFuture));
    });
    StartupProbe.mark('SplashScreen.initState end');
  }

  Future<void> _navigateNext(Future<String> destinationFuture) async {
    await TraceHelpers.traceScreen('SplashScreen', () async {
      // Wait for the branded animation that is already running — never an
      // arbitrary wall-clock delay that outlasts the animation.
      if (!StartupDiagnostics.simpleSplash &&
          _controller.status != AnimationStatus.completed) {
        StartupProbe.detail('SplashScreen awaiting brand animation');
        await _controller.forward();
      }
      StartupProbe.mark('SplashScreen animation complete');

      final path = await StartupProbe.timeAsync(
        'SplashScreen destination resolved',
        () => destinationFuture,
      );
      if (!mounted) return;
      StartupProbe.mark('SplashScreen context.go($path)');
      context.go(path);
    });
  }

  Future<String> _resolveDestination() async {
    StartupProbe.detail('SplashScreen resolveDestination begin');
    final completed = await StorageService.onboardingCompleted;
    StartupProbe.detail(
      'SplashScreen resolveDestination done onboardingCompleted=$completed',
    );
    return completed ? RouteNames.home : RouteNames.onboarding;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    StartupProbe.mark('SplashScreen.build begin');
    if (StartupDiagnostics.simpleSplash) {
      StartupProbe.mark('SplashScreen.build end (simple ColoredBox)');
      return const ColoredBox(color: Color(0xFF0F1F1A));
    }
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final scaffold = Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 112.w,
                height: 112.w,
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    OverflowBox(
                      maxWidth: 188.w,
                      maxHeight: 188.w,
                      child: FadeTransition(
                        opacity: _glowOpacity,
                        child: Container(
                          width: 188.w,
                          height: 188.w,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: RadialGradient(
                              colors: [
                                colorScheme.primary.withValues(alpha: 0.22),
                                colorScheme.primary.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                    ScaleTransition(
                      scale: _iconScale,
                      child: FadeTransition(
                        opacity: _iconOpacity,
                        child: const _SplashAppIcon(),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 12.h),
              SlideTransition(
                position: _titleSlide,
                child: FadeTransition(
                  opacity: _titleOpacity,
                  child: Text(
                    l10n?.appTitle ?? 'Deen Focus',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.headlineLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 36.sp,
                      height: 1.08,
                      letterSpacing: -0.6,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Spacing.sm.h),
              SlideTransition(
                position: _taglineSlide,
                child: FadeTransition(
                  opacity: _taglineOpacity,
                  child: Text(
                    l10n?.appTagline ?? '',
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                      fontSize: 15.sp,
                      letterSpacing: 0.4,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
    StartupProbe.mark('SplashScreen.build end');
    return scaffold;
  }
}

class _SplashAppIcon extends StatelessWidget {
  const _SplashAppIcon();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = 112.w;
    final radius = 28.r;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: isDark ? 0.28 : 0.18),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          _kAppIconAsset,
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}
