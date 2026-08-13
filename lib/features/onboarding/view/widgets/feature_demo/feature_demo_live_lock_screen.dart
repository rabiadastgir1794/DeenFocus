part of 'feature_demo_live_activity_screens.dart';

/// iOS Lock Screen with Live Activity banner.
class FeatureDemoLiveLockScreen extends StatelessWidget {
  const FeatureDemoLiveLockScreen({
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
              48.h,
              Spacing.lg.w,
              bottomPad,
            ),
            child: Column(
              children: [
                Text(
                  l10n.featureDemoSampleStatusTime,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: colorScheme.onSurface,
                    fontSize: 64.sp,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                Text(
                  l10n.featureDemoLiveActivityLockHint,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 15.sp,
                  ),
                ),
                const Spacer(),
                _LiveActivityBanner(l10n: l10n, expanded: false),
                SizedBox(height: Spacing.md.h),
                _Callout(text: callout),
                SizedBox(height: Spacing.md.h),
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
