part of 'feature_demo_widgets_screens.dart';

class FeatureDemoWidgetsGallery extends StatelessWidget {
  const FeatureDemoWidgetsGallery({
    super.key,
    required this.controller,
  });

  final FeatureDemoController controller;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final selected = controller.widgetSize;
    final ios = _isCupertino(context);
    final bottomPad = Spacing.lg.h + MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _widgetsOverlayStyle(context),
      child: ColoredBox(
        color: colorScheme.surface,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              Spacing.lg.w,
              Spacing.md.h,
              Spacing.lg.w,
              bottomPad,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.featureDemoWidgetsGalleryTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 6.h),
                Text(
                  l10n.featureDemoWidgetsGallerySubtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 13.sp,
                    height: 1.4,
                  ),
                ),
                SizedBox(height: Spacing.md.h),
                Expanded(
                  child: ListView(
                    children: [
                      for (final size in FeatureDemoWidgetSize.values) ...[
                        _GalleryCard(
                          size: size,
                          selected: selected == size,
                          title: _sizeTitle(l10n, size),
                          subtitle: _sizeSubtitle(l10n, size),
                          onTap: () => controller.selectWidgetSize(size),
                        ),
                        SizedBox(height: Spacing.md.h),
                      ],
                    ],
                  ),
                ),
                SizedBox(
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: controller.confirmWidgetPlacement,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: colorScheme.primary,
                      foregroundColor: colorScheme.onPrimary,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(28.r),
                      ),
                    ),
                    child: Text(
                      ios
                          ? l10n.featureDemoWidgetsAddCta
                          : l10n.featureDemoWidgetsAddCtaAndroid,
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
        ),
      ),
    );
  }

  String _sizeTitle(AppLocalizations l10n, FeatureDemoWidgetSize size) {
    return switch (size) {
      FeatureDemoWidgetSize.small => l10n.featureDemoWidgetSizeSmall,
      FeatureDemoWidgetSize.medium => l10n.featureDemoWidgetSizeMedium,
      FeatureDemoWidgetSize.large => l10n.featureDemoWidgetSizeLarge,
    };
  }

  String _sizeSubtitle(AppLocalizations l10n, FeatureDemoWidgetSize size) {
    return switch (size) {
      FeatureDemoWidgetSize.small => l10n.featureDemoWidgetSizeSmallSubtitle,
      FeatureDemoWidgetSize.medium => l10n.featureDemoWidgetSizeMediumSubtitle,
      FeatureDemoWidgetSize.large => l10n.featureDemoWidgetSizeLargeSubtitle,
    };
  }
}

class _GalleryCard extends StatelessWidget {
  const _GalleryCard({
    required this.size,
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final FeatureDemoWidgetSize size;
  final bool selected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          padding: EdgeInsets.all(14.w),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.12)
                : colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.outlineVariant.withValues(alpha: 0.45),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: colorScheme.onSurface,
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (selected)
                    Icon(
                      Icons.check_circle_rounded,
                      color: colorScheme.primary,
                      size: 20.sp,
                    ),
                ],
              ),
              SizedBox(height: 4.h),
              Text(
                subtitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: colorScheme.onSurfaceVariant,
                  fontSize: 12.sp,
                ),
              ),
              SizedBox(height: 10.h),
              FeatureDemoWidgetMock(size: size, compact: true),
            ],
          ),
        ),
      ),
    );
  }
}
