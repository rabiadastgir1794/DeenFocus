import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Measures [targetKey] in the coordinate space of [stackKey].
Rect? measureDemoTargetRect({
  required GlobalKey targetKey,
  required GlobalKey stackKey,
}) {
  final targetCtx = targetKey.currentContext;
  final stackCtx = stackKey.currentContext;
  if (targetCtx == null || stackCtx == null) return null;
  final targetBox = targetCtx.findRenderObject() as RenderBox?;
  final stackBox = stackCtx.findRenderObject() as RenderBox?;
  if (targetBox == null ||
      stackBox == null ||
      !targetBox.hasSize ||
      !stackBox.hasSize) {
    return null;
  }
  final topLeft = targetBox.localToGlobal(Offset.zero, ancestor: stackBox);
  return topLeft & targetBox.size;
}

/// Curved guide arrow used by App Demo walkthroughs (App Lock style).
class DemoGuideArrowPainter extends CustomPainter {
  DemoGuideArrowPainter({
    required this.targetCenter,
    required this.color,
    this.clearance = 34,
    this.bend = 36,
    this.stem = 56,
    this.startXFactor = 0.5,
  });

  final Offset targetCenter;
  final Color color;
  final double clearance;
  final double bend;
  final double stem;
  final double startXFactor;

  @override
  void paint(Canvas canvas, Size size) {
    final end = Offset(targetCenter.dx, targetCenter.dy - clearance);
    final start = Offset(size.width * startXFactor, end.dy - stem);

    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.2
      ..strokeCap = StrokeCap.round;

    final control = Offset((start.dx + end.dx) / 2 + bend, start.dy + 10);

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..quadraticBezierTo(control.dx, control.dy, end.dx, end.dy);
    canvas.drawPath(path, paint);

    final angle = math.atan2(end.dy - control.dy, end.dx - control.dx);
    const head = 11.0;
    final headPath = Path()
      ..moveTo(end.dx, end.dy)
      ..lineTo(
        end.dx - head * math.cos(angle - 0.5),
        end.dy - head * math.sin(angle - 0.5),
      )
      ..moveTo(end.dx, end.dy)
      ..lineTo(
        end.dx - head * math.cos(angle + 0.5),
        end.dy - head * math.sin(angle + 0.5),
      );
    canvas.drawPath(headPath, paint);
  }

  @override
  bool shouldRepaint(covariant DemoGuideArrowPainter oldDelegate) =>
      oldDelegate.targetCenter != targetCenter ||
      oldDelegate.color != color ||
      oldDelegate.clearance != clearance ||
      oldDelegate.bend != bend ||
      oldDelegate.stem != stem ||
      oldDelegate.startXFactor != startXFactor;
}

/// Ignore-pointer overlay that paints a pulsing curved arrow at [targetCenter].
class DemoGuideArrowOverlay extends StatelessWidget {
  const DemoGuideArrowOverlay({
    super.key,
    required this.targetCenter,
    required this.color,
    this.pulse,
    this.clearance = 34,
    this.bend = 36,
    this.stem = 56,
    this.startXFactor = 0.5,
  });

  final Offset targetCenter;
  final Color color;
  final Animation<double>? pulse;
  final double clearance;
  final double bend;
  final double stem;
  final double startXFactor;

  @override
  Widget build(BuildContext context) {
    Widget paint = CustomPaint(
      painter: DemoGuideArrowPainter(
        targetCenter: targetCenter,
        color: color,
        clearance: clearance,
        bend: bend,
        stem: stem,
        startXFactor: startXFactor,
      ),
    );

    if (pulse != null) {
      paint = AnimatedBuilder(
        animation: pulse!,
        builder: (context, child) {
          return Opacity(opacity: 0.72 + (pulse!.value * 0.28), child: child);
        },
        child: paint,
      );
    }

    return Positioned.fill(child: IgnorePointer(child: paint));
  }
}
