part of 'feature_demo_live_activity_screens.dart';

/// Expanded Dynamic Island mock (iOS only).
class FeatureDemoLiveExpandedIsland extends StatelessWidget {
  const FeatureDemoLiveExpandedIsland({
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
                _LiveActivityBanner(l10n: l10n, expanded: true),
                SizedBox(height: Spacing.lg.h),
                Text(
                  l10n.featureDemoLiveExpandedTitle,
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
