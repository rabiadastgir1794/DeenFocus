part of 'feature_demo_tajweed_screens.dart';

class FeatureDemoTajweedPractice extends StatefulWidget {
  const FeatureDemoTajweedPractice({
    super.key,
    required this.controller,
    required this.callout,
  });

  final FeatureDemoController controller;
  final String callout;

  @override
  State<FeatureDemoTajweedPractice> createState() =>
      _FeatureDemoTajweedPracticeState();
}

class _FeatureDemoTajweedPracticeState extends State<FeatureDemoTajweedPractice>
    with TickerProviderStateMixin, _TajweedGuideStateMixin {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);
    final transliteration = QuranTransliteration.of(
      FeatureDemoTajweedSample.basmalaArabic,
    );

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
                padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 16.h),
                child: Column(
                  children: [
                    Expanded(
                      child: ListView(
                        children: [
                          Container(
                            padding: EdgeInsets.fromLTRB(
                              16.w,
                              14.h,
                              16.w,
                              16.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surface,
                              borderRadius: BorderRadius.circular(18.r),
                              border: Border.all(
                                color: colorScheme.outlineVariant.withValues(
                                  alpha: 0.45,
                                ),
                              ),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    const Spacer(),
                                    Icon(
                                      Icons.tune_rounded,
                                      size: 20.sp,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    SizedBox(width: 10.w),
                                    Icon(
                                      Icons.volume_up_outlined,
                                      size: 20.sp,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ],
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  FeatureDemoTajweedSample.basmalaArabic,
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: FeatureDemoTajweedSample
                                        .arabicFontFamily,
                                    fontSize: 26.sp,
                                    height: 1.8,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  transliteration,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 13.sp,
                                    fontStyle: FontStyle.italic,
                                    color: colorScheme.onSurfaceVariant,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  l10n.featureDemoTajweedAyahTranslation,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    height: 1.45,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    KeyedSubtree(
                      key: targetKey,
                      child: TajweedMicButton(
                        isRecording: false,
                        enabled: true,
                        size: 96.r,
                        onTap: widget.controller.tapTajweedMic,
                      ),
                    ),
                    SizedBox(height: 8.h),
                    TajweedWaveform(active: false, color: colorScheme.primary),
                    SizedBox(height: 10.h),
                    Text(
                      l10n.tajweedStartReciting,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    SizedBox(height: 16.h),
                    _TajweedCallout(text: widget.callout),
                  ],
                ),
              ),
              guideArrow(
                color: colorScheme.primary,
                clearance: 96.r * 0.5 + 18,
                stem: 72,
                bend: 18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
