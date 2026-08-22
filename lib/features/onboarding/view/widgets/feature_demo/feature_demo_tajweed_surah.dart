part of 'feature_demo_tajweed_screens.dart';

class FeatureDemoTajweedSurah extends StatefulWidget {
  const FeatureDemoTajweedSurah({
    super.key,
    required this.controller,
    required this.callout,
  });

  final FeatureDemoController controller;
  final String callout;

  @override
  State<FeatureDemoTajweedSurah> createState() =>
      _FeatureDemoTajweedSurahState();
}

class _FeatureDemoTajweedSurahState extends State<FeatureDemoTajweedSurah>
    with TickerProviderStateMixin, _TajweedGuideStateMixin {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final transliteration = QuranTransliteration.of(
      FeatureDemoTajweedSample.basmalaArabic,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => measureTarget());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _tajweedOverlayStyle(context),
      child: Scaffold(
        appBar: CustomAppBar(
          title: l10n.featureDemoTajweedSurahName,
          subtitle: l10n.featureDemoTajweedSurahHeaderSubtitle,
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
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(
                              horizontal: 16.w,
                              vertical: 22.h,
                            ),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.35),
                              borderRadius: BorderRadius.circular(22.r),
                            ),
                            child: Column(
                              children: [
                                Text(
                                  FeatureDemoTajweedSample.basmalaArabic,
                                  textAlign: TextAlign.center,
                                  textDirection: TextDirection.rtl,
                                  style: TextStyle(
                                    fontFamily: FeatureDemoTajweedSample
                                        .arabicFontFamily,
                                    fontSize: 26.sp,
                                    height: 1.6,
                                    color: colorScheme.primary,
                                  ),
                                ),
                                SizedBox(height: 10.h),
                                Text(
                                  l10n.featureDemoTajweedSurahMeta,
                                  style: TextStyle(
                                    fontSize: 11.sp,
                                    letterSpacing: 1.2,
                                    fontWeight: FontWeight.w700,
                                    color: colorScheme.onSurface,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 12.h),
                          const TajweedLegendRow(),
                          SizedBox(height: 12.h),
                          _DemoAyahCard(
                            targetKey: targetKey,
                            l10n: l10n,
                            transliteration: transliteration,
                            onRecite: widget.controller.tapTajweedRecite,
                          ),
                        ],
                      ),
                    ),
                    _TajweedCallout(text: widget.callout),
                  ],
                ),
              ),
              guideArrow(color: colorScheme.primary, clearance: 24),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoAyahCard extends StatelessWidget {
  const _DemoAyahCard({
    required this.targetKey,
    required this.l10n,
    required this.transliteration,
    required this.onRecite,
  });

  final GlobalKey? targetKey;
  final AppLocalizations l10n;
  final String transliteration;
  final VoidCallback onRecite;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
      decoration: BoxDecoration(
        color: colorScheme.surface,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            children: [
              Container(
                width: 28.w,
                height: 28.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainerHighest,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '1',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const Spacer(),
              Icon(
                Icons.volume_up_outlined,
                size: 20.sp,
                color: colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 10.w),
              Icon(
                Icons.mic_none_rounded,
                size: 20.sp,
                color: colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 10.w),
              Icon(
                Icons.bookmark_border_rounded,
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
              fontFamily: FeatureDemoTajweedSample.arabicFontFamily,
              fontSize: 24.sp,
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
            style: TextStyle(
              fontSize: 14.sp,
              height: 1.45,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 14.h),
          KeyedSubtree(
            key: targetKey,
            child: SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: onRecite,
                icon: Icon(Icons.mic_rounded, size: 18.sp),
                label: Text(l10n.quranReciteCheckTajweed),
                style: FilledButton.styleFrom(
                  backgroundColor: colorScheme.primary,
                  foregroundColor: colorScheme.onPrimary,
                  padding: EdgeInsets.symmetric(vertical: 12.h),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14.r),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
