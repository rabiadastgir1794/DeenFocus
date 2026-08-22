part of 'feature_demo_tajweed_screens.dart';

String _formatDemoPercent(AppLocalizations l10n, double fraction) {
  return intl.NumberFormat.percentPattern(l10n.localeName).format(fraction);
}

SystemUiOverlayStyle _tajweedOverlayStyle(BuildContext context) {
  final brightness = Theme.of(context).brightness;
  return SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: brightness == Brightness.dark
        ? Brightness.light
        : Brightness.dark,
    statusBarBrightness: brightness,
  );
}

List<Widget> _tajweedSkipGutter() => [SizedBox(width: 80.w)];

class _TajweedCallout extends StatelessWidget {
  const _TajweedCallout({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.25)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        softWrap: true,
        style: TextStyle(
          color: colorScheme.onSurface,
          fontSize: 13.sp,
          fontWeight: FontWeight.w600,
          height: 1.35,
        ),
      ),
    );
  }
}

mixin _TajweedGuideStateMixin<T extends StatefulWidget>
    on State<T>, TickerProviderStateMixin<T> {
  final GlobalKey stackKey = GlobalKey();
  final GlobalKey targetKey = GlobalKey();
  final GlobalKey secondaryTargetKey = GlobalKey();
  Rect? targetRect;
  Rect? secondaryTargetRect;
  late final AnimationController pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    pulse.dispose();
    super.dispose();
  }

  void measureTarget() {
    final next = measureDemoTargetRect(
      targetKey: targetKey,
      stackKey: stackKey,
    );
    final nextSecondary = measureDemoTargetRect(
      targetKey: secondaryTargetKey,
      stackKey: stackKey,
    );
    if (!mounted) return;
    if (next == targetRect && nextSecondary == secondaryTargetRect) return;
    setState(() {
      if (next != null) targetRect = next;
      secondaryTargetRect = nextSecondary;
    });
  }

  Widget guideArrow({
    required Color color,
    Rect? rect,
    Offset Function(Rect rect)? anchor,
    double clearance = 28,
    double bend = 28,
    double stem = 56,
    double startXFactor = 0.5,
  }) {
    final target = rect ?? targetRect;
    if (target == null) return const SizedBox.shrink();
    final center = anchor?.call(target) ?? target.center;
    return DemoGuideArrowOverlay(
      targetCenter: center,
      color: color,
      pulse: pulse,
      clearance: clearance,
      bend: bend,
      stem: stem,
      startXFactor: startXFactor,
    );
  }
}
