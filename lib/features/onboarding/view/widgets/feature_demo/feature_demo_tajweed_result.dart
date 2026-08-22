part of 'feature_demo_tajweed_screens.dart';

class FeatureDemoTajweedResult extends StatefulWidget {
  const FeatureDemoTajweedResult({
    super.key,
    required this.controller,
    required this.callout,
  });

  final FeatureDemoController controller;
  final String callout;

  @override
  State<FeatureDemoTajweedResult> createState() =>
      _FeatureDemoTajweedResultState();
}

class _FeatureDemoTajweedResultState extends State<FeatureDemoTajweedResult>
    with TickerProviderStateMixin, _TajweedGuideStateMixin {
  static const _tokens = <({String text, TajweedTokenStatus status})>[
    (text: 'بِسْمِ', status: TajweedTokenStatus.ok),
    (text: 'ٱللَّهِ', status: TajweedTokenStatus.ok),
    (text: 'ٱلرَّحْمَٰنِ', status: TajweedTokenStatus.minor),
    (text: 'ٱلرَّحِيمِ', status: TajweedTokenStatus.miss),
  ];

  Color _statusColor(ColorScheme colorScheme, TajweedTokenStatus status) {
    return switch (status) {
      TajweedTokenStatus.ok => const Color(0xFF2E7D32),
      TajweedTokenStatus.minor ||
      TajweedTokenStatus.major => const Color(0xFFF9A825),
      TajweedTokenStatus.sub => colorScheme.error,
      TajweedTokenStatus.miss => colorScheme.onSurfaceVariant,
      TajweedTokenStatus.extra => const Color(0xFF6A1B9A),
    };
  }

  Color _statusTileBg(ColorScheme colorScheme, TajweedTokenStatus status) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return switch (status) {
      TajweedTokenStatus.ok =>
        isDark ? const Color(0xFF1B3D2E) : const Color(0xFFE8F5E9),
      TajweedTokenStatus.minor || TajweedTokenStatus.major =>
        isDark ? const Color(0xFF3D3420) : const Color(0xFFFFF8E1),
      TajweedTokenStatus.sub =>
        isDark ? const Color(0xFF3D1F24) : const Color(0xFFFFEBEE),
      TajweedTokenStatus.miss => colorScheme.surfaceContainerHighest,
      TajweedTokenStatus.extra =>
        isDark ? const Color(0xFF2E1B3D) : const Color(0xFFF3E5F5),
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    const accuracy = 0.5;

    WidgetsBinding.instance.addPostFrameCallback((_) => measureTarget());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _tajweedOverlayStyle(context),
      child: Scaffold(
        appBar: CustomAppBar(
          title: l10n.featureDemoTajweedPracticeTitle,
          onBack: widget.controller.goBack,
          actions: _tajweedSkipGutter(),
        ),
        body: SafeArea(
          top: false,
          child: Stack(
            key: stackKey,
            fit: StackFit.expand,
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Center(
                            child: SizedBox(
                              width: 148.r,
                              height: 148.r,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 148.r,
                                    height: 148.r,
                                    child: CircularProgressIndicator(
                                      value: accuracy,
                                      strokeWidth: 10.r,
                                      backgroundColor: colorScheme
                                          .surfaceContainerHighest
                                          .withValues(alpha: 0.8),
                                      color: colorScheme.primary,
                                    ),
                                  ),
                                  Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _formatDemoPercent(l10n, accuracy),
                                        style: theme.textTheme.headlineMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w800,
                                              color: colorScheme.onSurface,
                                            ),
                                      ),
                                      SizedBox(height: 2.h),
                                      Text(
                                        l10n.tajweedWordAccuracyLabel,
                                        style: theme.textTheme.labelSmall
                                            ?.copyWith(
                                              letterSpacing: 0.8,
                                              fontWeight: FontWeight.w700,
                                              color:
                                                  colorScheme.onSurfaceVariant,
                                            ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Text(
                            l10n.featureDemoTajweedResultEncouragement,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.45,
                            ),
                          ),
                          SizedBox(height: 20.h),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.fromLTRB(
                              16.w,
                              14.h,
                              16.w,
                              16.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.45),
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(
                                color: colorScheme.outlineVariant.withValues(
                                  alpha: 0.3,
                                ),
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  l10n.tajweedWordReviewLabel,
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    letterSpacing: 0.8,
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Directionality(
                                  textDirection: TextDirection.rtl,
                                  child: Wrap(
                                    spacing: 8.w,
                                    runSpacing: 8.h,
                                    alignment: WrapAlignment.center,
                                    children: [
                                      for (final token in _tokens)
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: 12.w,
                                            vertical: 10.h,
                                          ),
                                          decoration: BoxDecoration(
                                            color: _statusTileBg(
                                              colorScheme,
                                              token.status,
                                            ),
                                            borderRadius: BorderRadius.circular(
                                              12.r,
                                            ),
                                          ),
                                          child: Text(
                                            token.text,
                                            textDirection: TextDirection.rtl,
                                            style: TextStyle(
                                              fontFamily:
                                                  FeatureDemoTajweedSample
                                                      .arabicFontFamily,
                                              fontSize: 18.sp,
                                              fontWeight: FontWeight.w600,
                                              color: _statusColor(
                                                colorScheme,
                                                token.status,
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.h),
                          Container(
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(
                                color: colorScheme.outlineVariant.withValues(
                                  alpha: 0.35,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                _DemoStatRow(
                                  color: _statusColor(
                                    colorScheme,
                                    TajweedTokenStatus.ok,
                                  ),
                                  label: l10n.featureDemoTajweedStatCorrect,
                                  count: 2,
                                ),
                                Divider(
                                  height: 1,
                                  color: colorScheme.outlineVariant.withValues(
                                    alpha: 0.25,
                                  ),
                                ),
                                _DemoStatRow(
                                  color: _statusColor(
                                    colorScheme,
                                    TajweedTokenStatus.minor,
                                  ),
                                  label:
                                      l10n.featureDemoTajweedStatPronunciation,
                                  count: 1,
                                ),
                                Divider(
                                  height: 1,
                                  color: colorScheme.outlineVariant.withValues(
                                    alpha: 0.25,
                                  ),
                                ),
                                _DemoStatRow(
                                  color: _statusColor(
                                    colorScheme,
                                    TajweedTokenStatus.sub,
                                  ),
                                  label: l10n.featureDemoTajweedStatWrong,
                                  count: 0,
                                ),
                                Divider(
                                  height: 1,
                                  color: colorScheme.outlineVariant.withValues(
                                    alpha: 0.25,
                                  ),
                                ),
                                _DemoStatRow(
                                  color: _statusColor(
                                    colorScheme,
                                    TajweedTokenStatus.miss,
                                  ),
                                  label: l10n.featureDemoTajweedStatMissed,
                                  count: 1,
                                ),
                                Divider(
                                  height: 1,
                                  color: colorScheme.outlineVariant.withValues(
                                    alpha: 0.25,
                                  ),
                                ),
                                _DemoStatRow(
                                  color: _statusColor(
                                    colorScheme,
                                    TajweedTokenStatus.extra,
                                  ),
                                  label: l10n.featureDemoTajweedStatExtra,
                                  count: 0,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 16.h),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: widget.controller.retryTajweedPractice,
                            icon: const Icon(Icons.replay_rounded),
                            label: Text(l10n.appDemoTryAgain),
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(vertical: 14.h),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(14.r),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 12.w),
                        Expanded(
                          child: KeyedSubtree(
                            key: targetKey,
                            child: FilledButton.icon(
                              onPressed: widget.controller.finishTajweedDemo,
                              icon: const Icon(Icons.check_rounded),
                              label: Text(l10n.appLockDemoDone),
                              style: FilledButton.styleFrom(
                                padding: EdgeInsets.symmetric(vertical: 14.h),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14.r),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 16.h),
                    _TajweedCallout(text: widget.callout),
                  ],
                ),
              ),
              guideArrow(color: colorScheme.primary, clearance: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoStatRow extends StatelessWidget {
  const _DemoStatRow({
    required this.color,
    required this.label,
    required this.count,
  });

  final Color color;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
      child: Row(
        children: [
          Container(
            width: 8.r,
            height: 8.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 10.w),
          Expanded(
            child: Text(label, style: Theme.of(context).textTheme.bodyMedium),
          ),
          Text(
            '$count',
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}
