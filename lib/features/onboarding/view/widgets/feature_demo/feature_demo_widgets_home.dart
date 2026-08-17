part of 'feature_demo_widgets_screens.dart';

class FeatureDemoWidgetsHome extends StatefulWidget {
  const FeatureDemoWidgetsHome({
    super.key,
    required this.controller,
    required this.callout,
  });

  final FeatureDemoController controller;
  final String callout;

  @override
  State<FeatureDemoWidgetsHome> createState() => _FeatureDemoWidgetsHomeState();
}

class _FeatureDemoWidgetsHomeState extends State<FeatureDemoWidgetsHome>
    with SingleTickerProviderStateMixin {
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _targetKey = GlobalKey();
  Rect? _targetRect;

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _measureTarget() {
    final next = measureDemoTargetRect(
      targetKey: _targetKey,
      stackKey: _stackKey,
    );
    if (next == null || next == _targetRect || !mounted) return;
    setState(() => _targetRect = next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final phase = widget.controller.phase;
    final editing = phase == FeatureDemoPhase.widgetsEditMode ||
        phase == FeatureDemoPhase.widgetsPlaced;
    final placed = phase == FeatureDemoPhase.widgetsPlaced;
    final showGuide = phase == FeatureDemoPhase.widgetsHome ||
        phase == FeatureDemoPhase.widgetsEditMode;
    final ios = _isCupertino(context);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showGuide) {
        _measureTarget();
      } else if (_targetRect != null && mounted) {
        setState(() => _targetRect = null);
      }
    });

    final colorScheme = Theme.of(context).colorScheme;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _widgetsOverlayStyle(context),
      child: Stack(
        key: _stackKey,
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onLongPress: phase == FeatureDemoPhase.widgetsHome
                ? () {
                    HapticFeedback.mediumImpact();
                    widget.controller.longPressHome();
                  }
                : null,
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primaryContainer.withValues(alpha: 0.55),
                    colorScheme.surface,
                    colorScheme.surfaceContainerLowest,
                  ],
                ),
              ),
              child: SafeArea(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
                  child: Column(
                    children: [
                      SizedBox(height: Spacing.md.h),
                      Text(
                        l10n.featureDemoSampleStatusTime,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorScheme.onSurface.withValues(alpha: 0.92),
                          fontSize: ios ? 52.sp : 44.sp,
                          fontWeight: ios ? FontWeight.w200 : FontWeight.w400,
                        ),
                      ),
                      Text(
                        l10n.featureDemoWidgetsHomeHint,
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorScheme.onSurfaceVariant,
                          fontSize: 13.sp,
                        ),
                      ),
                      SizedBox(height: Spacing.lg.h),
                      if (placed)
                        FeatureDemoWidgetMock(
                          size: widget.controller.widgetSize,
                        )
                      else if (editing)
                        KeyedSubtree(
                          key: _targetKey,
                          child: _EmptyWidgetSlot(
                            ios: ios,
                            onAdd: widget.controller.openWidgetGallery,
                            label: l10n.featureDemoWidgetsAddSlotLabel,
                          ),
                        )
                      else
                        KeyedSubtree(
                          key: _targetKey,
                          child: const _AppIconGrid(jiggle: false),
                        ),
                      if (editing && !placed) ...[
                        SizedBox(height: Spacing.md.h),
                        const _AppIconGrid(jiggle: true),
                      ],
                      if (placed) ...[
                        SizedBox(height: Spacing.md.h),
                        _AppIconGrid(jiggle: editing),
                      ],
                      const Spacer(),
                      if (placed) ...[
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: widget.controller.openWidgetGallery,
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: colorScheme.onSurface,
                                  side: BorderSide(
                                    color: colorScheme.outline
                                        .withValues(alpha: 0.55),
                                  ),
                                  minimumSize: Size.fromHeight(48.h),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.r),
                                  ),
                                ),
                                child: Text(
                                  l10n.featureDemoWidgetsChangeCta,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                            SizedBox(width: 10.w),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: widget.controller.finishWidgetsDemo,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: colorScheme.primary,
                                  foregroundColor: colorScheme.onPrimary,
                                  minimumSize: Size.fromHeight(48.h),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(24.r),
                                  ),
                                ),
                                child: Text(
                                  l10n.featureDemoContinue,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: Spacing.md.h),
                      ],
                      _Dock(ios: ios),
                      SizedBox(height: Spacing.md.h),
                    ],
                  ),
                ),
              ),
            ),
          ),
          if (showGuide && _targetRect != null)
            DemoGuideArrowOverlay(
              targetCenter: _targetRect!.center,
              color: colorScheme.primary,
              pulse: _pulse,
              clearance: phase == FeatureDemoPhase.widgetsEditMode ? 18 : 28,
              bend: phase == FeatureDemoPhase.widgetsEditMode ? 22 : 36,
            ),
          if (showGuide)
            Positioned(
              left: Spacing.lg.w,
              right: Spacing.lg.w,
              bottom: 110.h,
              child: AnimatedBuilder(
                animation: _pulse,
                builder: (context, child) {
                  return Opacity(
                    opacity: 0.75 + (_pulse.value * 0.25),
                    child: child,
                  );
                },
                child: _CalloutChip(text: widget.callout),
              ),
            ),
        ],
      ),
    );
  }
}
