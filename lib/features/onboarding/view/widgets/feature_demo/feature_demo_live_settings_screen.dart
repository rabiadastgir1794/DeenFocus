part of 'feature_demo_live_activity_screens.dart';

/// Cropped Settings focus on the Live Activity toggle (dark App Demo style).
class FeatureDemoLiveSettings extends StatefulWidget {
  const FeatureDemoLiveSettings({
    super.key,
    required this.controller,
    required this.callout,
  });

  final FeatureDemoController controller;
  final String callout;

  @override
  State<FeatureDemoLiveSettings> createState() =>
      _FeatureDemoLiveSettingsState();
}

class _FeatureDemoLiveSettingsState extends State<FeatureDemoLiveSettings>
    with SingleTickerProviderStateMixin {
  final GlobalKey _stackKey = GlobalKey();
  final GlobalKey _toggleKey = GlobalKey();
  Rect? _toggleRect;

  late final AnimationController _pulse = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  )..repeat(reverse: true);

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  void _measureToggle() {
    final next = measureDemoTargetRect(
      targetKey: _toggleKey,
      stackKey: _stackKey,
    );
    if (next == null || next == _toggleRect || !mounted) return;
    setState(() => _toggleRect = next);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final bottomPad = Spacing.lg.h + MediaQuery.paddingOf(context).bottom;

    WidgetsBinding.instance.addPostFrameCallback((_) => _measureToggle());

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: _demoOverlayStyle(context),
      child: ColoredBox(
        color: colorScheme.surface,
        child: Stack(
          key: _stackKey,
          fit: StackFit.expand,
          children: [
            SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  Spacing.lg.w,
                  Spacing.xl.h,
                  Spacing.lg.w,
                  bottomPad,
                ),
                child: Column(
                  children: [
                    Text(
                      l10n.settings,
                      style: textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: Spacing.xl.h),
                    Expanded(
                      child: Center(
                        child: _CroppedPrayerSettingsCard(
                          controller: widget.controller,
                          toggleKey: _toggleKey,
                        ),
                      ),
                    ),
                    SizedBox(height: Spacing.lg.h),
                    AnimatedBuilder(
                      animation: _pulse,
                      builder: (context, child) {
                        return Opacity(
                          opacity: 0.75 + (_pulse.value * 0.25),
                          child: child,
                        );
                      },
                      child: _Callout(text: widget.callout),
                    ),
                  ],
                ),
              ),
            ),
            if (_toggleRect != null)
              DemoGuideArrowOverlay(
                targetCenter: Offset(
                  _toggleRect!.right - 28,
                  _toggleRect!.center.dy,
                ),
                color: colorScheme.primary,
                pulse: _pulse,
                clearance: 22,
                bend: 28,
              ),
          ],
        ),
      ),
    );
  }
}

/// Partial Prayer Calculation block using real Settings list widgets.
class _CroppedPrayerSettingsCard extends StatelessWidget {
  const _CroppedPrayerSettingsCard({
    required this.controller,
    required this.toggleKey,
  });

  final FeatureDemoController controller;
  final GlobalKey toggleKey;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Soft “cropped” hint of content above the focused section.
        IgnorePointer(
          child: Opacity(
            opacity: 0.35,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SettingsGroup(
                  children: [
                    SettingsRow(
                      icon: Icons.people_outline_rounded,
                      label: l10n.sectTitle,
                      value: l10n.sectSunni,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
        SettingsSectionHeader(
          icon: Icons.public_rounded,
          label: l10n.settingsPrayerCalculationSection,
        ),
        const SizedBox(height: 8),
        SettingsGroup(
          children: [
            SettingsRow(
              icon: Icons.wb_sunny_outlined,
              label: l10n.settingsAsrCalculationTitle,
              value:
                  '${l10n.asrMethodStandard} (${l10n.asrMethodStandardSubtitle})',
            ),
            SettingsRow(
              icon: Icons.location_on_outlined,
              label: l10n.settingsLocationLabel,
            ),
            SettingsRow(
              icon: Icons.alarm_rounded,
              label: l10n.settingsPrayerAlarmsTitle,
            ),
            KeyedSubtree(
              key: toggleKey,
              child: SettingsSubtitleSwitchRow(
                label: l10n.liveActivityEnableLabel,
                subtitle: controller.liveActivityEnabled
                    ? l10n.liveActivityStatusActive
                    : l10n.liveActivityStatusOff,
                value: controller.liveActivityEnabled,
                enabled: true,
                onChanged: controller.liveActivityEnabled
                    ? null
                    : (_) => controller.enableLiveActivity(),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        IgnorePointer(
          child: Opacity(
            opacity: 0.35,
            child: SettingsGroup(
              children: [
                SettingsSwitchRow(
                  icon: isDark
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                  label: l10n.settingsDarkModeLabel,
                  value: isDark,
                  onChanged: (_) {},
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
