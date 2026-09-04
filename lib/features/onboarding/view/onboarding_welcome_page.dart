import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../core/utils/responsive_layout.dart';
import '../../../l10n/app_localizations.dart';
import 'widgets/onboarding_welcome_theme.dart';

class OnboardingWelcomePage extends StatelessWidget {
  const OnboardingWelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    final chips = [
      _WelcomeFeatureChipData(emoji: '🕌', label: l10n.focusPrayerModeTitle),
      _WelcomeFeatureChipData(emoji: '🌙', label: l10n.focusSleepModeTitle),
      _WelcomeFeatureChipData(emoji: '👶', label: l10n.focusChildModeTitle),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 640;
        final scrollable =
            ResponsiveLayout.isTablet(context) || compact;

        final content = Padding(
          padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              _WelcomeLogo(compact: compact),
              SizedBox(height: compact ? 20.h : 28.h),
              Text(
                l10n.homeSalam,
                textAlign: TextAlign.center,
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 10.sp : 11.sp,
                  letterSpacing: 2.2,
                ),
              ),
              SizedBox(height: compact ? 10.h : 14.h),
              Text(
                l10n.appTitle,
                textAlign: TextAlign.center,
                style: textTheme.headlineLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 32.sp : 38.sp,
                  height: 1.08,
                  letterSpacing: -0.8,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: compact ? 12.h : 16.h),
              ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 318.w),
                child: Text(
                  l10n.welcomeDescription,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.55,
                    fontSize: compact ? 13.sp : 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
              SizedBox(height: compact ? 24.h : 32.h),
              _WelcomeFeatureChips(chips: chips, compact: compact),
            ],
          ),
        );

        if (scrollable) {
          return SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: Center(child: content),
            ),
          );
        }

        return content;
      },
    );
  }
}

class _WelcomeLogo extends StatelessWidget {
  const _WelcomeLogo({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;
    final size = compact ? 92.w : 108.w;
    final radius = compact ? 24.r : 28.r;

    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        boxShadow: [
          BoxShadow(
            color: OnboardingWelcomeTheme.logoShadow(colorScheme, brightness),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.asset(
          'assets/app_icon.png',
          width: size,
          height: size,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class _WelcomeFeatureChips extends StatelessWidget {
  const _WelcomeFeatureChips({
    required this.chips,
    required this.compact,
  });

  final List<_WelcomeFeatureChipData> chips;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      alignment: WrapAlignment.center,
      runAlignment: WrapAlignment.center,
      spacing: compact ? 6.w : 8.w,
      runSpacing: 8.h,
      children: [
        for (final chip in chips)
          _WelcomeFeatureChip(data: chip, compact: compact),
      ],
    );
  }
}

class _WelcomeFeatureChipData {
  const _WelcomeFeatureChipData({
    required this.emoji,
    required this.label,
  });

  final String emoji;
  final String label;
}

class _WelcomeFeatureChip extends StatelessWidget {
  const _WelcomeFeatureChip({
    required this.data,
    required this.compact,
  });

  final _WelcomeFeatureChipData data;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final brightness = Theme.of(context).brightness;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10.w : 12.w,
        vertical: compact ? 7.h : 8.h,
      ),
      decoration: BoxDecoration(
        color: OnboardingWelcomeTheme.chipBackground(colorScheme, brightness),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: OnboardingWelcomeTheme.chipBorder(colorScheme),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(data.emoji, style: TextStyle(fontSize: compact ? 12.sp : 13.sp)),
          SizedBox(width: 4.w),
          Text(
            data.label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: OnboardingWelcomeTheme.chipLabel(colorScheme),
              fontWeight: FontWeight.w600,
              fontSize: compact ? 11.sp : 12.sp,
            ),
          ),
        ],
      ),
    );
  }
}
