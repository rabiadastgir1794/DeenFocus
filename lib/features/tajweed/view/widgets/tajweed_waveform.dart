import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Animated mic-level bars shown while recording.
class TajweedWaveform extends StatefulWidget {
  const TajweedWaveform({
    super.key,
    required this.active,
    this.barCount = 28,
    this.color,
  });

  final bool active;
  final int barCount;
  final Color? color;

  @override
  State<TajweedWaveform> createState() => _TajweedWaveformState();
}

class _TajweedWaveformState extends State<TajweedWaveform>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    if (widget.active) _controller.repeat();
  }

  @override
  void didUpdateWidget(covariant TajweedWaveform oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.active && !_controller.isAnimating) {
      _controller.repeat();
    } else if (!widget.active && _controller.isAnimating) {
      _controller.stop();
      _controller.value = 0;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final color = widget.color ?? Theme.of(context).colorScheme.primary;
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return SizedBox(
          height: 36,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(widget.barCount, (index) {
              final phase = _controller.value * math.pi * 2 + index * 0.45;
              final wave = widget.active
                  ? (0.35 + (math.sin(phase).abs() * 0.65))
                  : 0.18;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 1.2),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 120),
                  width: 3,
                  height: 8 + wave * 24,
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: widget.active ? 0.85 : 0.25),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              );
            }),
          ),
        );
      },
    );
  }
}
