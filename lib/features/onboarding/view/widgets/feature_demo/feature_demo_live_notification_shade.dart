part of 'feature_demo_live_activity_screens.dart';

/// Android notification shade with updated prayer status.
class FeatureDemoLiveNotificationShade extends StatelessWidget {
  const FeatureDemoLiveNotificationShade({
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
              Spacing.md.w,
              Spacing.md.h,
              Spacing.md.w,
              bottomPad,
            ),
            child: Column(
              children: [
                Container(
                  width: 40.w,
                  height: 4.h,
                  decoration: BoxDecoration(
                    color: colorScheme.onSurfaceVariant.withValues(alpha: 0.35),
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
                SizedBox(height: Spacing.md.h),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    l10n.featureDemoAndroidShadeTitle,
                    style: TextStyle(
                      color: colorScheme.onSurface,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(height: Spacing.sm.h),
                _AndroidShadeCard(l10n: l10n),
                SizedBox(height: Spacing.lg.h),
                _Callout(text: callout),
                const Spacer(),
                _ContinueButton(
                  onPressed: onContinue,
                  label: l10n.featureDemoContinue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
