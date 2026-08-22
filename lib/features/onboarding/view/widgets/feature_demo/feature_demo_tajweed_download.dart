part of 'feature_demo_tajweed_screens.dart';

class FeatureDemoTajweedDownload extends StatefulWidget {
  const FeatureDemoTajweedDownload({
    super.key,
    required this.controller,
    required this.callout,
  });

  final FeatureDemoController controller;
  final String callout;

  @override
  State<FeatureDemoTajweedDownload> createState() =>
      _FeatureDemoTajweedDownloadState();
}

class _FeatureDemoTajweedDownloadState extends State<FeatureDemoTajweedDownload>
    with TickerProviderStateMixin, _TajweedGuideStateMixin {
  late final AnimationController _progress = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 2200),
  );

  @override
  void initState() {
    super.initState();
    _progress.forward();
  }

  @override
  void dispose() {
    _progress.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

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
                padding: EdgeInsets.fromLTRB(24.w, 12.h, 24.w, 16.h),
                child: Column(
                  children: [
                    Expanded(
                      child: Center(
                        child: AnimatedBuilder(
                          animation: _progress,
                          builder: (context, _) {
                            final value = _progress.value.clamp(0.0, 1.0);
                            return Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 88,
                                  height: 88,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.12,
                                    ),
                                  ),
                                  child: Icon(
                                    Icons.mic_rounded,
                                    size: 40,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                SizedBox(height: 24.h),
                                Text(
                                  l10n.featureDemoTajweedPreparingTitle,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  l10n.featureDemoTajweedPreparingBody,
                                  textAlign: TextAlign.center,
                                  style: theme.textTheme.bodyMedium?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    height: 1.45,
                                  ),
                                ),
                                SizedBox(height: 28.h),
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: LinearProgressIndicator(
                                    value: value,
                                    minHeight: 8,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  _formatDemoPercent(l10n, value),
                                  style: theme.textTheme.labelLarge?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    _TajweedCallout(text: widget.callout),
                    SizedBox(height: Spacing.md.h),
                    SizedBox(
                      key: targetKey,
                      height: 52.h,
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: widget.controller.finishTajweedDownload,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colorScheme.primary,
                          foregroundColor: colorScheme.onPrimary,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(28.r),
                          ),
                        ),
                        child: Text(
                          l10n.featureDemoContinue,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
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
