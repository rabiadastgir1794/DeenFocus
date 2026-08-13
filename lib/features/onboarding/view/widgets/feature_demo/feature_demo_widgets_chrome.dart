part of 'feature_demo_widgets_screens.dart';

bool _isCupertino(BuildContext context) {
  final p = Theme.of(context).platform;
  return p == TargetPlatform.iOS || p == TargetPlatform.macOS;
}

SystemUiOverlayStyle _widgetsOverlayStyle(BuildContext context) {
  return Theme.of(context).brightness == Brightness.dark
      ? SystemUiOverlayStyle.light
      : SystemUiOverlayStyle.dark;
}

class _EmptyWidgetSlot extends StatelessWidget {
  const _EmptyWidgetSlot({
    required this.ios,
    required this.onAdd,
    required this.label,
  });

  final bool ios;
  final VoidCallback onAdd;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onAdd,
      child: Container(
        width: double.infinity,
        height: 120.h,
        decoration: BoxDecoration(
          color: colorScheme.surfaceContainer,
          borderRadius: BorderRadius.circular(22.r),
          border: Border.all(
            color: colorScheme.outline.withValues(alpha: 0.45),
            width: 1.5,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              ios ? Icons.add_circle_outline_rounded : Icons.add_rounded,
              color: colorScheme.onSurface,
              size: 32.sp,
            ),
            SizedBox(height: 6.h),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: colorScheme.onSurface,
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppIconGrid extends StatefulWidget {
  const _AppIconGrid({required this.jiggle});

  final bool jiggle;

  @override
  State<_AppIconGrid> createState() => _AppIconGridState();
}

class _AppIconGridState extends State<_AppIconGrid>
    with SingleTickerProviderStateMixin {
  late final AnimationController _jiggle = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 180),
  );

  @override
  void initState() {
    super.initState();
    if (widget.jiggle) _jiggle.repeat(reverse: true);
  }

  @override
  void didUpdateWidget(covariant _AppIconGrid oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.jiggle && !_jiggle.isAnimating) {
      _jiggle.repeat(reverse: true);
    } else if (!widget.jiggle && _jiggle.isAnimating) {
      _jiggle.stop();
      _jiggle.value = 0;
    }
  }

  @override
  void dispose() {
    _jiggle.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = [
      const Color(0xFF34C759),
      const Color(0xFF007AFF),
      const Color(0xFFFF9500),
      const Color(0xFFFF2D55),
      const Color(0xFFAF52DE),
      const Color(0xFF5AC8FA),
      const Color(0xFFFFCC00),
      const Color(0xFF8E8E93),
    ];

    return AnimatedBuilder(
      animation: _jiggle,
      builder: (context, _) {
        return Wrap(
          spacing: 18.w,
          runSpacing: 16.h,
          alignment: WrapAlignment.center,
          children: [
            for (var i = 0; i < colors.length; i++)
              Transform.rotate(
                angle: widget.jiggle
                    ? ((_jiggle.value - 0.5) * 0.08) * (i.isEven ? 1 : -1)
                    : 0,
                child: Container(
                  width: 52.w,
                  height: 52.w,
                  decoration: BoxDecoration(
                    color: colors[i],
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

class _Dock extends StatelessWidget {
  const _Dock({required this.ios});

  final bool ios;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(
          alpha: ios ? 0.85 : 0.75,
        ),
        borderRadius: BorderRadius.circular(ios ? 28.r : 18.r),
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _DockIcon(color: Color(0xFF34C759)),
          _DockIcon(color: Color(0xFF007AFF)),
          _DockIcon(color: Color(0xFFFF9500)),
          _DockIcon(color: Color(0xFFFF2D55)),
        ],
      ),
    );
  }
}

class _DockIcon extends StatelessWidget {
  const _DockIcon({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44.w,
      height: 44.w,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.r),
      ),
    );
  }
}

class _CalloutChip extends StatelessWidget {
  const _CalloutChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.28),
        ),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        softWrap: true,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
