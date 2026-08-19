import 'package:flutter/material.dart';

class HomeVerseMarquee extends StatefulWidget {
  const HomeVerseMarquee({super.key, required this.text, required this.color});

  final String text;
  final Color color;

  @override
  State<HomeVerseMarquee> createState() => _HomeVerseMarqueeState();
}

class _HomeVerseMarqueeState extends State<HomeVerseMarquee>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  double _cachedTextWidth = 0;
  String? _layoutText;
  TextStyle? _layoutStyle;
  TextDirection? _layoutDirection;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _ensureTextWidth({
    required String text,
    required TextStyle? style,
    required TextDirection direction,
  }) {
    if (_layoutText == text &&
        _layoutStyle == style &&
        _layoutDirection == direction &&
        _cachedTextWidth > 0) {
      return;
    }
    final painter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: direction,
      maxLines: 1,
    )..layout();
    _cachedTextWidth = painter.width;
    _layoutText = text;
    _layoutStyle = style;
    _layoutDirection = direction;
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: widget.color,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic,
    );
    final direction = Directionality.of(context);

    return SizedBox(
      height: 20,
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            _ensureTextWidth(
              text: widget.text,
              style: textStyle,
              direction: direction,
            );
            final width = constraints.maxWidth;
            final textWidth = _cachedTextWidth;
            const gap = 40.0;
            final trackWidth = textWidth + gap;
            final travel = trackWidth + width;

            return RepaintBoundary(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  final firstLeft = width - (_controller.value * travel);
                  final secondLeft = firstLeft + trackWidth;

                  return Stack(
                    children: [
                      Positioned(left: firstLeft, child: child!),
                      Positioned(left: secondLeft, child: child),
                    ],
                  );
                },
                child: Text(
                  widget.text,
                  style: textStyle,
                  maxLines: 1,
                  softWrap: false,
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
