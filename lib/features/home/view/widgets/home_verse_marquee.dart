import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../../../../core/logger/startup_handoff.dart';

/// Daily verse strip: cross-fade on text change; optional horizontal scroll
/// only after [StartupHandoff.allowHomeChromeAnimations] (post-Superwall).
class HomeVerseMarquee extends StatefulWidget {
  const HomeVerseMarquee({
    super.key,
    required this.text,
    required this.color,
  });

  final String text;
  final Color color;

  @override
  State<HomeVerseMarquee> createState() => _HomeVerseMarqueeState();
}

class _HomeVerseMarqueeState extends State<HomeVerseMarquee>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scrollController;

  double _cachedTextWidth = 0;
  String? _layoutText;
  TextStyle? _layoutStyle;
  TextDirection? _layoutDirection;
  bool _scrollStarted = false;
  double _lastViewportWidth = 0;

  @override
  void initState() {
    super.initState();
    _scrollController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 30),
    );
    StartupHandoff.allowHomeChromeAnimations.addListener(_onChromeGateChanged);
  }

  @override
  void didUpdateWidget(HomeVerseMarquee oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) {
      _cachedTextWidth = 0;
      _layoutText = null;
      _scrollStarted = false;
      _scrollController.stop();
      _scrollController.value = 0;
    }
  }

  @override
  void dispose() {
    StartupHandoff.allowHomeChromeAnimations.removeListener(
      _onChromeGateChanged,
    );
    _scrollController.dispose();
    super.dispose();
  }

  void _onChromeGateChanged() {
    if (!mounted) return;
    if (StartupHandoff.allowHomeChromeAnimations.value) {
      setState(() {});
      _maybeStartScroll(
        viewportWidth: _lastViewportWidth,
        textWidth: _cachedTextWidth,
      );
    } else {
      _scrollController.stop();
      _scrollStarted = false;
    }
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

  void _maybeStartScroll({
    required double viewportWidth,
    required double textWidth,
  }) {
    if (_scrollStarted) return;
    if (!StartupHandoff.allowHomeChromeAnimations.value) return;
    if (widget.text.trim().isEmpty) return;
    if (textWidth <= 0 || viewportWidth <= 0) return;
    if (textWidth <= viewportWidth) return;
    _scrollStarted = true;
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_scrollStarted) return;
      if (!StartupHandoff.allowHomeChromeAnimations.value) return;
      if (!_scrollController.isAnimating) {
        _scrollController.repeat();
      }
    });
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
      width: double.infinity,
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            _ensureTextWidth(
              text: widget.text,
              style: textStyle,
              direction: direction,
            );
            final width = constraints.maxWidth;
            _lastViewportWidth = width;
            final textWidth = _cachedTextWidth;
            const gap = 40.0;
            final trackWidth = textWidth + gap;
            final travel = trackWidth + width;
            _maybeStartScroll(viewportWidth: width, textWidth: textWidth);

            // Bound the text to the viewport so softWrap:false cannot report
            // a RenderFlex / box overflow (yellow/black stripes on Android).
            if (!_scrollController.isAnimating && !_scrollStarted) {
              return SizedBox(
                width: width,
                child: Text(
                  widget.text,
                  style: textStyle,
                  maxLines: 1,
                  softWrap: false,
                  overflow: TextOverflow.fade,
                ),
              );
            }

            // Marquee track is wider than the viewport — lift max-width so the
            // Row does not overflow, then clip via the parent [ClipRect].
            return RepaintBoundary(
              child: AnimatedBuilder(
                animation: _scrollController,
                builder: (context, child) {
                  final dx = width - (_scrollController.value * travel);
                  return OverflowBox(
                    minWidth: 0,
                    maxWidth: double.infinity,
                    alignment: Alignment.centerLeft,
                    child: Transform.translate(
                      offset: Offset(dx, 0),
                      transformHitTests: false,
                      child: child,
                    ),
                  );
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      widget.text,
                      style: textStyle,
                      maxLines: 1,
                      softWrap: false,
                    ),
                    const SizedBox(width: gap),
                    Text(
                      widget.text,
                      style: textStyle,
                      maxLines: 1,
                      softWrap: false,
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
