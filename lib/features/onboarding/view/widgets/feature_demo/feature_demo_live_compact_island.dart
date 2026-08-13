part of 'feature_demo_live_activity_screens.dart';

/// Compact Dynamic Island mock (iOS only).
class FeatureDemoLiveCompactIsland extends StatelessWidget {
  const FeatureDemoLiveCompactIsland({
    super.key,
    required this.onContinue,
    required this.callout,
  });

  final VoidCallback onContinue;
  final String callout;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final bottomPad = Spacing.lg.h + MediaQuery.paddingOf(context).bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _demoOverlayStyle(context),
      child: ColoredBox(
        color: colorScheme.surface,
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(
              Spacing.lg.w,
              Spacing.xl.h,
              Spacing.lg.w,
              bottomPad,
            ),
            child: Column(
              children: [
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
                  decoration: BoxDecoration(
                    color: colorScheme.inverseSurface,
                    borderRadius: BorderRadius.circular(40.r),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Flexible(
                        child: Text(
                          l10n.homePrayerMaghrib,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: colorScheme.onInverseSurface,
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(width: 28.w),
                      Text(
                        l10n.featureDemoLiveActivitySampleTime,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: colorScheme.onInverseSurface,
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Spacing.lg.h),
                Text(
                  l10n.featureDemoLiveCompactTitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 20.sp,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: Spacing.sm.h),
                _Callout(text: callout),
                const Spacer(),
                _ContinueButton(
                  onPressed: onContinue,
                  label: l10n.featureDemoLiveExpandCta,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
