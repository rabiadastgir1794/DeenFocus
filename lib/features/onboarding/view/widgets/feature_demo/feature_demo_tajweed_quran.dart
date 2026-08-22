part of 'feature_demo_tajweed_screens.dart';

class FeatureDemoTajweedQuran extends StatefulWidget {
  const FeatureDemoTajweedQuran({
    super.key,
    required this.controller,
    required this.callout,
  });

  final FeatureDemoController controller;
  final String callout;

  @override
  State<FeatureDemoTajweedQuran> createState() =>
      _FeatureDemoTajweedQuranState();
}

class _FeatureDemoTajweedQuranState extends State<FeatureDemoTajweedQuran>
    with TickerProviderStateMixin, _TajweedGuideStateMixin {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : colorScheme.outlineVariant.withValues(alpha: 0.45);
    final rowColor = colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.20,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) => measureTarget());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _tajweedOverlayStyle(context),
      child: Scaffold(
        appBar: CustomAppBar(
          title: l10n.libraryModuleQuran,
          subtitle: l10n.libraryModuleQuranSub,
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
                padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 16.h),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 8.h),
                    ContinueReadingCard(
                      mode: ReadingMode.surah,
                      surahName: l10n.featureDemoTajweedSurahName,
                      ayahNumber: 1,
                      pageNumber: 1,
                      juzNumber: 1,
                      juzProgressPercent: 5,
                      onTap: widget.controller.tapTajweedDrill,
                    ),
                    SizedBox(height: 12.h),
                    Row(
                      children: [
                        Expanded(
                          child: KeyedSubtree(
                            key: targetKey,
                            child: _DemoQuickTile(
                              icon: Icons.mic_rounded,
                              title: l10n.quranQuickTajweed,
                              subtitle: l10n.quranQuickTajweedSub,
                              onTap: widget.controller.tapTajweedDrill,
                            ),
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _DemoQuickTile(
                            icon: Icons.bookmark_rounded,
                            title: l10n.quranBookmarksTitle,
                            subtitle: l10n.quranBookmarkCount(0),
                            onTap: () {},
                          ),
                        ),
                        SizedBox(width: 8.w),
                        Expanded(
                          child: _DemoQuickTile(
                            icon: Icons.headphones_rounded,
                            title: l10n.quranLastListened,
                            subtitle: l10n.quranNoneYet,
                            onTap: () {},
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 14.h),
                    QuranReadingModeTabs(
                      selected: ReadingMode.surah,
                      onSelected: (_) {},
                      surahLabel: l10n.quranModeSurah,
                      juzLabel: l10n.quranModeJuz,
                      pageLabel: l10n.quranModePage,
                    ),
                    SizedBox(height: 14.h),
                    Container(
                      decoration: BoxDecoration(
                        color: colorScheme.surfaceContainerHighest,
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      child: TextField(
                        enabled: false,
                        decoration: InputDecoration(
                          hintText: l10n.quranSearchHintExtended,
                          prefixIcon: Icon(
                            Icons.search_rounded,
                            size: 18.sp,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 12.h,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 12.h),
                    Expanded(
                      child: ListView(
                        children: [
                          KeyedSubtree(
                            key: secondaryTargetKey,
                            child: Column(
                              children: [
                                _DemoSurahRow(
                                  number: '1',
                                  name: l10n.featureDemoTajweedSurahName,
                                  arabic: FeatureDemoTajweedSample.surahArabic,
                                  subtitle:
                                      l10n.featureDemoTajweedSurahListSubtitle,
                                  background: rowColor,
                                  borderColor: borderColor,
                                  onTap: widget.controller.tapTajweedDrill,
                                ),
                                SizedBox(height: 8.h),
                                _DemoSurahRow(
                                  number: '2',
                                  name: l10n.featureDemoTajweedBaqarahName,
                                  arabic: 'البقرة',
                                  subtitle:
                                      l10n.featureDemoTajweedBaqarahSubtitle,
                                  background: rowColor,
                                  borderColor: borderColor,
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    _TajweedCallout(text: widget.callout),
                  ],
                ),
              ),
              guideArrow(
                color: colorScheme.primary,
                anchor: (rect) => Offset(rect.center.dx, rect.top),
                clearance: 14,
                stem: 40,
                startXFactor: 0.22,
                bend: 14,
              ),
              guideArrow(
                color: colorScheme.primary,
                rect: secondaryTargetRect,
                anchor: (rect) => Offset(rect.center.dx, rect.top),
                clearance: 16,
                stem: 44,
                startXFactor: 0.72,
                bend: -18,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoQuickTile extends StatelessWidget {
  const _DemoQuickTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        borderRadius: BorderRadius.circular(14.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(icon, size: 18.sp, color: colorScheme.primary),
              SizedBox(height: 6.h),
              Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 11.sp,
                  fontWeight: FontWeight.w700,
                  color: colorScheme.onSurface,
                ),
              ),
              Text(
                subtitle,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10.sp,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DemoSurahRow extends StatelessWidget {
  const _DemoSurahRow({
    required this.number,
    required this.name,
    required this.arabic,
    required this.subtitle,
    required this.background,
    required this.borderColor,
    required this.onTap,
  });

  final String number;
  final String name;
  final String arabic;
  final String subtitle;
  final Color background;
  final Color borderColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
          child: Row(
            children: [
              Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                alignment: Alignment.center,
                child: Text(
                  number,
                  style: TextStyle(
                    fontSize: 11.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurface,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 11.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                arabic,
                style: TextStyle(
                  fontFamily: FeatureDemoTajweedSample.arabicFontFamily,
                  fontSize: 18.sp,
                  color: colorScheme.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
