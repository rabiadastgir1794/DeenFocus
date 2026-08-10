import 'dart:math' as math;
import 'dart:ui' as ui;

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

class TasbihBeadsArc extends StatefulWidget {
  const TasbihBeadsArc({
    super.key,
    required this.beadColor,
    required this.onBeadsCrossed,
  });

  final Color beadColor;
  final ValueChanged<int> onBeadsCrossed;

  @override
  State<TasbihBeadsArc> createState() => _TasbihBeadsArcState();
}

class _TasbihBeadsArcState extends State<TasbihBeadsArc>
    with SingleTickerProviderStateMixin {
  static const double _beadSpacing = 48;
  static const double _centerGap = 30;
  static const double _beadRadius = 15;
  static const double _activeRadius = 17.5;
  static const double _dragScale = 0.32;
  static const double _flingVelocity = 650;
  static const double _tapSlop = 10;
  static const double _settleEpsilon = 0.35;
  static const double _settleVelocityEpsilon = 12;
  static const double _springStiffness = 260;
  static const double _springDamping = 26;

  late final Ticker _ticker;
  final ValueNotifier<double> _offset = ValueNotifier<double>(0);

  VelocityTracker? _velocityTracker;
  int? _activePointer;
  Offset? _downPosition;
  Duration? _lastTick;
  bool _moved = false;
  bool _settling = false;
  double _velocity = 0;
  double _settleTarget = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
  }

  @override
  void dispose() {
    _ticker.dispose();
    _offset.dispose();
    super.dispose();
  }

  int _crossIndexFor(double offset) => (offset / _beadSpacing).floor();

  void _reportCrossings(double previousOffset, double nextOffset) {
    final delta = _crossIndexFor(nextOffset) - _crossIndexFor(previousOffset);
    if (delta == 0) return;
    HapticFeedback.selectionClick();
    widget.onBeadsCrossed(delta);
  }

  void _setOffset(double next) {
    final previous = _offset.value;
    if ((next - previous).abs() < 0.0005) return;
    _offset.value = next;
    _reportCrossings(previous, next);
  }

  void _stopSettling() {
    _settling = false;
    _velocity = 0;
    _lastTick = null;
    if (_ticker.isActive) _ticker.stop();
  }

  void _startSettling({required double target, required double initialVelocity}) {
    _settleTarget = target;
    _velocity = initialVelocity.clamp(-2200.0, 2200.0);
    _settling = true;
    _lastTick = null;
    if (!_ticker.isActive) _ticker.start();
  }

  /// Fling settles to at most one bead ahead/back; otherwise nearest bead.
  double _settleTargetFor(double current, double velocity) {
    final index = current / _beadSpacing;
    if (velocity > _flingVelocity * _dragScale) {
      return index.floor() * _beadSpacing + _beadSpacing;
    }
    if (velocity < -_flingVelocity * _dragScale) {
      return index.ceil() * _beadSpacing - _beadSpacing;
    }
    return index.roundToDouble() * _beadSpacing;
  }

  void _onTick(Duration elapsed) {
    final last = _lastTick;
    _lastTick = elapsed;
    if (last == null || !_settling) return;

    var dt = (elapsed - last).inMicroseconds / 1e6;
    if (dt <= 0) return;
    dt = math.min(dt, 0.032);
    var remaining = dt;
    while (remaining > 0) {
      final step = math.min(remaining, 1 / 120);
      remaining -= step;

      final x = _offset.value;
      final accel =
          _springStiffness * (_settleTarget - x) - _springDamping * _velocity;
      _velocity += accel * step;
      _setOffset(x + _velocity * step);

      if ((_offset.value - _settleTarget).abs() < _settleEpsilon &&
          _velocity.abs() < _settleVelocityEpsilon) {
        _setOffset(_settleTarget);
        _stopSettling();
        return;
      }
    }
  }

  /// Left/down advances; right/up undoes.
  double _dragDelta(Offset delta) => (-delta.dx + delta.dy) * _dragScale;

  void _onPointerDown(PointerDownEvent event) {
    if (_activePointer != null) return;
    _activePointer = event.pointer;
    _downPosition = event.localPosition;
    _moved = false;
    _stopSettling();
    _velocityTracker = VelocityTracker.withKind(event.kind)
      ..addPosition(event.timeStamp, event.localPosition);
  }

  void _onPointerMove(PointerMoveEvent event) {
    if (event.pointer != _activePointer) return;
    _velocityTracker?.addPosition(event.timeStamp, event.localPosition);
    final delta = _dragDelta(event.localDelta);
    if (!_moved) {
      final traveled =
          (event.localPosition - (_downPosition ?? event.localPosition))
              .distance;
      if (traveled < _tapSlop && delta.abs() < 0.4) return;
      _moved = true;
    }
    _setOffset(_offset.value + delta);
  }

  void _onPointerUp(PointerUpEvent event) {
    if (event.pointer != _activePointer) return;
    final tracker = _velocityTracker;
    final wasTap = !_moved;
    _activePointer = null;
    _downPosition = null;
    _velocityTracker = null;

    if (wasTap) {
      final current = _offset.value;
      final base = (current / _beadSpacing).roundToDouble() * _beadSpacing;
      _startSettling(
        target: base + _beadSpacing,
        initialVelocity: 900,
      );
      return;
    }

    final estimate = tracker?.getVelocityEstimate();
    final pixelsPerSecond = estimate?.pixelsPerSecond ?? Offset.zero;
    final velocity = _dragDelta(pixelsPerSecond);
    _startSettling(
      target: _settleTargetFor(_offset.value, velocity),
      initialVelocity: velocity * 0.55,
    );
  }

  void _onPointerCancel(PointerCancelEvent event) {
    if (event.pointer != _activePointer) return;
    _activePointer = null;
    _downPosition = null;
    _velocityTracker = null;
    _startSettling(
      target: _settleTargetFor(_offset.value, 0),
      initialVelocity: 0,
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(24),
      clipBehavior: Clip.antiAlias,
      child: Listener(
        behavior: HitTestBehavior.opaque,
        onPointerDown: _onPointerDown,
        onPointerMove: _onPointerMove,
        onPointerUp: _onPointerUp,
        onPointerCancel: _onPointerCancel,
        child: ValueListenableBuilder<double>(
          valueListenable: _offset,
          builder: (context, offset, _) {
            return CustomPaint(
              painter: _TasbihBeadStringPainter(
                offset: offset,
                beadColor: widget.beadColor,
                spacing: _beadSpacing,
                centerGap: _centerGap,
                beadRadius: _beadRadius,
                activeRadius: _activeRadius,
                cordColor:
                    colorScheme.outlineVariant.withValues(alpha: 0.55),
              ),
              child: const SizedBox.expand(),
            );
          },
        ),
      ),
    );
  }
}

class _TasbihBeadStringPainter extends CustomPainter {
  _TasbihBeadStringPainter({
    required this.offset,
    required this.beadColor,
    required this.spacing,
    required this.centerGap,
    required this.beadRadius,
    required this.activeRadius,
    required this.cordColor,
  });

  final double offset;
  final Color beadColor;
  final double spacing;
  final double centerGap;
  final double beadRadius;
  final double activeRadius;
  final Color cordColor;

  double _rawLocal(int index) => index * spacing - offset;

  double _visualLocal(double raw) {
    final halfGap = centerGap / 2;
    final t = (raw / 10).clamp(-20.0, 20.0);
    final e2 = math.exp(2 * t);
    final soft = (e2 - 1) / (e2 + 1);
    return raw + halfGap * soft;
  }

  Offset _beadPosition(Offset center, double halfSpan, double arcDepth, double local) {
    final x = center.dx + local;
    final t = (local / halfSpan).clamp(-1.0, 1.0);
    final y = center.dy + arcDepth * (1 - t * t);
    return Offset(x, y);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.52);
    final arcDepth = size.height * 0.1;
    final halfSpan = size.width * 0.5 + spacing + centerGap;
    final firstIndex = ((offset - halfSpan) / spacing).floor() - 1;
    final lastIndex = ((offset + halfSpan) / spacing).ceil() + 1;

    final cord = Path();
    const samples = 48;
    for (var s = 0; s <= samples; s++) {
      final raw = -halfSpan + (2 * halfSpan) * (s / samples);
      final local = _visualLocal(raw);
      final p = _beadPosition(center, halfSpan, arcDepth, local);
      if (s == 0) {
        cord.moveTo(p.dx, p.dy);
      } else {
        cord.lineTo(p.dx, p.dy);
      }
    }
    canvas.drawPath(
      cord,
      Paint()
        ..color = cordColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.4
        ..strokeCap = StrokeCap.round
        ..isAntiAlias = true,
    );

    for (var i = firstIndex; i <= lastIndex; i++) {
      final raw = _rawLocal(i);
      final local = _visualLocal(raw);
      final pos = _beadPosition(center, halfSpan, arcDepth, local);
      final proximity =
          (1 - (raw.abs() / (spacing * 0.55))).clamp(0.0, 1.0);
      final radius = ui.lerpDouble(beadRadius, activeRadius, proximity)!;
      _drawBead(canvas, pos, radius, proximity);
    }
  }

  void _drawBead(Canvas canvas, Offset c, double radius, double proximity) {
    final base = Paint()
      ..isAntiAlias = true
      ..shader = ui.Gradient.radial(
        c.translate(-radius * 0.28, -radius * 0.32),
        radius * 1.35,
        [
          Color.lerp(Colors.white, beadColor, 0.15)!,
          beadColor,
          Color.lerp(beadColor, Colors.black, 0.28)!,
        ],
        const [0.0, 0.45, 1.0],
      );
    canvas.drawCircle(c, radius, base);

    canvas.drawCircle(
      c.translate(-radius * 0.28, -radius * 0.3),
      radius * 0.28,
      Paint()
        ..isAntiAlias = true
        ..color = Colors.white.withValues(alpha: 0.35 + 0.2 * proximity),
    );

    canvas.drawCircle(
      c,
      radius,
      Paint()
        ..isAntiAlias = true
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0 + 0.6 * proximity
        ..color = Colors.black.withValues(alpha: 0.12),
    );

    if (proximity > 0.05) {
      canvas.drawCircle(
        c,
        radius + 3 + 2 * proximity,
        Paint()
          ..isAntiAlias = true
          ..style = PaintingStyle.stroke
          ..strokeWidth = 1.6 + 0.6 * proximity
          ..color = beadColor.withValues(alpha: 0.15 + 0.25 * proximity),
      );
    }
  }

  @override
  bool shouldRepaint(covariant _TasbihBeadStringPainter oldDelegate) {
    return oldDelegate.offset != offset ||
        oldDelegate.beadColor != beadColor ||
        oldDelegate.cordColor != cordColor;
  }
}
