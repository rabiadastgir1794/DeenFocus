import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

/// Decorative Qibla compass for the location onboarding step.
/// The outer dial rotates continuously; the center readout stays upright.
class OnboardingLocationQiblaHero extends StatefulWidget {
  const OnboardingLocationQiblaHero({
    super.key,
    this.size,
    this.compact = false,
    this.animate = true,
  });

  final double? size;
  final bool compact;

  /// When false, the dial holds its current angle (avoids jank while typing).
  final bool animate;

  @override
  State<OnboardingLocationQiblaHero> createState() =>
      _OnboardingLocationQiblaHeroState();
}

class _OnboardingLocationQiblaHeroState
    extends State<OnboardingLocationQiblaHero>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    );
    if (widget.animate) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant OnboardingLocationQiblaHero oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.animate == oldWidget.animate) return;
    if (widget.animate) {
      _controller.repeat();
    } else {
      _controller.stop();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final size = widget.size ?? (widget.compact ? 156.r : 176.r);
    final centerSize = size * 0.42;
    final arrowSize = centerSize * 0.34;

    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        clipBehavior: Clip.none,
        children: [
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Transform.rotate(
                angle: _controller.value * 2 * math.pi,
                child: child,
              );
            },
            child: Stack(
              alignment: Alignment.center,
              clipBehavior: Clip.none,
              children: [
                CustomPaint(
                  size: Size(size, size),
                  painter: _OnboardingCompassTicksPainter(
                    foreground: colorScheme.onSurfaceVariant,
                    ringColor: colorScheme.outlineVariant,
                  ),
                ),
                Transform.rotate(
                  // Kaaba on the outer ring (matches design right-side placement).
                  angle: 90 * math.pi / 180,
                  child: SizedBox(
                    width: size,
                    height: size,
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: EdgeInsets.only(top: 2.r),
                        child: Text('🕋', style: TextStyle(fontSize: 18.sp)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: centerSize,
            height: centerSize,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: colorScheme.shadow.withValues(alpha: 0.12),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.navigation_rounded,
                  size: arrowSize,
                  color: colorScheme.primary,
                ),
                SizedBox(height: 2.h),
                Text(
                  '245°',
                  style: textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: widget.compact ? 14.sp : 16.sp,
                    color: colorScheme.onSurface,
                    height: 1.1,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _OnboardingCompassTicksPainter extends CustomPainter {
  const _OnboardingCompassTicksPainter({
    required this.foreground,
    required this.ringColor,
  });

  final Color foreground;
  final Color ringColor;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 1;

    final ringPaint = Paint()
      ..color = ringColor.withValues(alpha: 0.7)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;
    canvas.drawCircle(center, radius, ringPaint);

    for (var i = 0; i < 72; i++) {
      final angleDeg = i * 5.0;
      final angleRad = angleDeg * math.pi / 180;
      final h = i % 18 == 0
          ? 11.0
          : i % 6 == 0
          ? 7.0
          : 3.5;
      final innerR = radius - h;
      final outerR = radius;

      final inner = Offset(
        center.dx + math.sin(angleRad) * innerR,
        center.dy - math.cos(angleRad) * innerR,
      );
      final outer = Offset(
        center.dx + math.sin(angleRad) * outerR,
        center.dy - math.cos(angleRad) * outerR,
      );

      final opacity = i % 18 == 0
          ? 0.45
          : i % 6 == 0
          ? 0.22
          : 0.12;
      final paint = Paint()
        ..color = foreground.withValues(alpha: opacity)
        ..strokeWidth = 1
        ..strokeCap = StrokeCap.round;
      canvas.drawLine(inner, outer, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OnboardingCompassTicksPainter oldDelegate) {
    return oldDelegate.foreground != foreground ||
        oldDelegate.ringColor != ringColor;
  }
}
