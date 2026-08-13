part of 'feature_demo_live_activity_screens.dart';

/// Android ongoing / live prayer notification.
class FeatureDemoLiveOngoingNotification extends StatelessWidget {
  const FeatureDemoLiveOngoingNotification({
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
              Spacing.lg.h,
              Spacing.lg.w,
              bottomPad,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.featureDemoAndroidStatusBarHint,
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12.sp,
                  ),
                ),
                SizedBox(height: Spacing.md.h),
                _AndroidOngoingCard(l10n: l10n),
                SizedBox(height: Spacing.lg.h),
                Text(
                  l10n.featureDemoAndroidOngoingTitle,
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
                  label: l10n.featureDemoAndroidOpenShadeCta,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
