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

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: widget.color,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic,
    );

    return SizedBox(
      height: 20,
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final width = constraints.maxWidth;
                final painter = TextPainter(
                  text: TextSpan(text: widget.text, style: textStyle),
                  textDirection: Directionality.of(context),
                  maxLines: 1,
                )..layout();
                final textWidth = painter.width;
                final gap = 40.0;
                final trackWidth = textWidth + gap;
                final travel = trackWidth + width;
                final firstLeft = width - (_controller.value * travel);
                final secondLeft = firstLeft + trackWidth;

                return Stack(
                  children: [
                    Positioned(
                      left: firstLeft,
                      child: Text(
                        widget.text,
                        style: textStyle,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                    Positioned(
                      left: secondLeft,
                      child: Text(
                        widget.text,
                        style: textStyle,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}
