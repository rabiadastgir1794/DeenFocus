import 'package:flutter/material.dart';

/// Large mic control with optional pulsing rings while recording.
class TajweedMicButton extends StatefulWidget {
  const TajweedMicButton({
    super.key,
    required this.isRecording,
    required this.enabled,
    required this.onTap,
    this.size = 96,
  });

  final bool isRecording;
  final bool enabled;
  final VoidCallback? onTap;
  final double size;

  @override
  State<TajweedMicButton> createState() => _TajweedMicButtonState();
}

class _TajweedMicButtonState extends State<TajweedMicButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    );
    if (widget.isRecording) _pulse.repeat();
  }

  @override
  void didUpdateWidget(covariant TajweedMicButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isRecording && !_pulse.isAnimating) {
      _pulse.repeat();
    } else if (!widget.isRecording && _pulse.isAnimating) {
      _pulse.stop();
      _pulse.value = 0;
    }
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final core = widget.size;

    return GestureDetector(
      onTap: widget.enabled ? widget.onTap : null,
      child: SizedBox(
        width: core * 1.55,
        height: core * 1.55,
        child: Stack(
          alignment: Alignment.center,
          children: [
            if (widget.isRecording)
              ...List.generate(3, (i) {
                final scale = 1.0 + (i + 1) * 0.18;
                final opacity = 0.28 - i * 0.07;
                return AnimatedBuilder(
                  animation: _pulse,
                  builder: (context, child) {
                    final t = (_pulse.value + i * 0.15) % 1.0;
                    return Transform.scale(
                      scale: scale + t * 0.08,
                      child: Container(
                        width: core,
                        height: core,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary.withValues(
                            alpha: opacity * (1 - t * 0.35),
                          ),
                        ),
                      ),
                    );
                  },
                );
              }),
            Container(
              width: core,
              height: core,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: widget.enabled
                    ? colorScheme.primary
                    : colorScheme.primary.withValues(alpha: 0.45),
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.28),
                    blurRadius: 18,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Icon(
                Icons.mic_rounded,
                color: colorScheme.onPrimary,
                size: core * 0.38,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
