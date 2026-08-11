import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../core/widgets/app_centered_nav_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../../onboarding/view/widgets/app_lock_demo/app_lock_demo_flow.dart';
import '../../../onboarding/view/widgets/app_lock_demo/app_lock_demo_mode.dart';

/// Settings entry for the interactive App Lock Demo with mode selection.
class SettingsAppDemoScreen extends StatefulWidget {
  const SettingsAppDemoScreen({super.key});

  @override
  State<SettingsAppDemoScreen> createState() => _SettingsAppDemoScreenState();
}

class _SettingsAppDemoScreenState extends State<SettingsAppDemoScreen> {
  AppLockDemoMode? _mode;
  bool _immersive = false;

  void _openMode(AppLockDemoMode mode) {
    setState(() {
      _mode = mode;
      _immersive = false;
    });
  }

  void _backToPicker() {
    setState(() {
      _mode = null;
      _immersive = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    if (_mode != null) {
      return Scaffold(
        backgroundColor: _immersive ? Colors.black : colorScheme.surface,
        body: SafeArea(
          top: !_immersive,
          bottom: false,
          child: Stack(
            fit: StackFit.expand,
            children: [
              AppLockDemoFlow(
                key: ValueKey(_mode),
                mode: _mode!,
                fromSettings: true,
                isActive: true,
                onComplete: _backToPicker,
                onExit: _backToPicker,
                onImmersiveChanged: (value) {
                  if (!mounted || _immersive == value) return;
                  setState(() => _immersive = value);
                },
              ),
              if (_immersive)
                Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: _backToPicker,
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white.withValues(alpha: 0.92),
                      padding: EdgeInsets.symmetric(
                        horizontal: Spacing.md.w,
                        vertical: 8.h,
                      ),
                    ),
                    child: Text(
                      l10n.skip,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        shadows: const [
                          Shadow(blurRadius: 8, color: Colors.black54),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    final bottomPad =
        Spacing.xl.h + MediaQuery.paddingOf(context).bottom;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppCenteredNavHeader(
              title: l10n.settingsAppDemoLabel,
              backLabel: l10n.calendarBack,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: ListView(
                padding: EdgeInsets.fromLTRB(
                  Spacing.lg.w,
                  Spacing.sm.h,
                  Spacing.lg.w,
                  bottomPad,
                ),
                children: [
                  Text(
                    l10n.settingsAppDemoChooseModeTitle,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.3,
                          color: colorScheme.onSurface,
                        ),
                  ),
                  SizedBox(height: Spacing.sm.h),
                  Text(
                    l10n.settingsAppDemoChooseModeSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                          height: 1.45,
                        ),
                  ),
                  SizedBox(height: Spacing.lg.h),
                  _ModeOptionCard(
                    icon: Icons.mosque_rounded,
                    title: l10n.focusPrayerModeTitle,
                    subtitle: l10n.settingsAppDemoPrayerCardSubtitle,
                    onTap: () => _openMode(AppLockDemoMode.prayer),
                  ),
                  SizedBox(height: Spacing.md.h),
                  _ModeOptionCard(
                    icon: Icons.bedtime_rounded,
                    title: l10n.focusSleepModeTitle,
                    subtitle: l10n.settingsAppDemoSleepCardSubtitle,
                    onTap: () => _openMode(AppLockDemoMode.sleep),
                  ),
                  SizedBox(height: Spacing.md.h),
                  _ModeOptionCard(
                    icon: Icons.child_care_rounded,
                    title: l10n.focusChildModeTitle,
                    subtitle: l10n.settingsAppDemoChildCardSubtitle,
                    onTap: () => _openMode(AppLockDemoMode.child),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ModeOptionCard extends StatelessWidget {
  const _ModeOptionCard({
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
    final textTheme = Theme.of(context).textTheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          padding: EdgeInsets.all(18.w),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 48.w,
                height: 48.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, color: colorScheme.primary, size: 24.sp),
              ),
              SizedBox(width: 14.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: 4.h),
                    Text(
                      subtitle,
                      style: textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 8.w),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
