import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../l10n/app_localizations.dart';

/// Platform-specific Screen Time carousel pages (same shell, different content).
List<Widget> screenTimeStepPages() {
  if (Platform.isAndroid) {
    return const [
      ScreenTimeAndroidStepUsageAccess(),
      ScreenTimeAndroidStepAccessibility(),
      ScreenTimeAndroidStepChooseApps(),
      ScreenTimeAndroidStepProtected(),
    ];
  }

  return const [
    ScreenTimeIosStepOpenPrompt(),
    ScreenTimeIosStepTapContinue(),
    ScreenTimeIosStepChooseApps(),
    ScreenTimeIosStepProtected(),
  ];
}

/// Shared shell matching the reference center-card content stack.
class ScreenTimeStepShell extends StatelessWidget {
  const ScreenTimeStepShell({
    super.key,
    required this.hero,
    required this.icon,
    required this.title,
    required this.body,
  });

  final Widget hero;
  final Widget icon;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Padding(
      padding: EdgeInsets.fromLTRB(Spacing.md.w, 4.h, Spacing.md.w, 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxHeight < 360;
          final iconSize = compact ? 38.r : 44.r;

          return Column(
            children: [
              Expanded(
                child: Center(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: hero,
                  ),
                ),
              ),
              SizedBox(height: compact ? 10.h : 14.h),
              Container(
                width: iconSize,
                height: iconSize,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: icon,
              ),
              SizedBox(height: compact ? 8.h : 10.h),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: compact ? 15.sp : 16.sp,
                  height: 1.25,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 6.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Spacing.sm.w),
                child: Text(
                  body,
                  textAlign: TextAlign.center,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: compact ? 12.sp : 13.sp,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ─── iOS steps ───────────────────────────────────────────────────────────────

class ScreenTimeIosStepOpenPrompt extends StatelessWidget {
  const ScreenTimeIosStepOpenPrompt({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return ScreenTimeStepShell(
      hero: _IosPermissionDialogHero(
        continueBackground: colorScheme.primaryContainer,
        continueForeground: colorScheme.primary,
        dontAllowFilled: false,
      ),
      icon: Icon(
        CupertinoIcons.hourglass,
        size: 20.sp,
        color: colorScheme.primary,
      ),
      title: l10n.screenTimeStep1Title,
      body: l10n.screenTimeStep1Body,
    );
  }
}

class ScreenTimeIosStepTapContinue extends StatelessWidget {
  const ScreenTimeIosStepTapContinue({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return ScreenTimeStepShell(
      hero: _IosPermissionDialogHero(
        continueBackground: colorScheme.primary,
        continueForeground: colorScheme.onPrimary,
        dontAllowFilled: true,
      ),
      icon: _ToggleGlyph(size: 22.r),
      title: l10n.screenTimeStep2Title,
      body: l10n.screenTimeStep2Body,
    );
  }
}

class ScreenTimeIosStepChooseApps extends StatelessWidget {
  const ScreenTimeIosStepChooseApps({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ScreenTimeStepShell(
      hero: const _AppsListHero(allSelected: false, chipRows: true),
      icon: _FilterGlyph(size: 18.sp),
      title: l10n.screenTimeStep3Title,
      body: l10n.screenTimeStep3Body,
    );
  }
}

class ScreenTimeIosStepProtected extends StatelessWidget {
  const ScreenTimeIosStepProtected({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return ScreenTimeStepShell(
      hero: const _AppsListHero(allSelected: true, chipRows: false),
      icon: Icon(
        Icons.verified_user_outlined,
        size: 20.sp,
        color: colorScheme.primary,
      ),
      title: l10n.screenTimeStep4Title,
      body: l10n.screenTimeStep4Body,
    );
  }
}

// ─── Android steps ───────────────────────────────────────────────────────────

class ScreenTimeAndroidStepUsageAccess extends StatelessWidget {
  const ScreenTimeAndroidStepUsageAccess({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return ScreenTimeStepShell(
      hero: const _AndroidUsageAccessHero(),
      icon: Icon(
        Icons.data_usage_rounded,
        size: 20.sp,
        color: colorScheme.primary,
      ),
      title: l10n.screenTimeAndroidStep1Title,
      body: l10n.screenTimeAndroidStep1Body,
    );
  }
}

class ScreenTimeAndroidStepAccessibility extends StatelessWidget {
  const ScreenTimeAndroidStepAccessibility({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ScreenTimeStepShell(
      hero: const _AndroidAccessibilityHero(),
      icon: _ToggleGlyph(size: 22.r),
      title: l10n.screenTimeAndroidStep2Title,
      body: l10n.screenTimeAndroidStep2Body,
    );
  }
}

class ScreenTimeAndroidStepChooseApps extends StatelessWidget {
  const ScreenTimeAndroidStepChooseApps({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ScreenTimeStepShell(
      hero: const _AppsListHero(allSelected: false, chipRows: true),
      icon: _FilterGlyph(size: 18.sp),
      title: l10n.screenTimeAndroidStep3Title,
      body: l10n.screenTimeAndroidStep3Body,
    );
  }
}

class ScreenTimeAndroidStepProtected extends StatelessWidget {
  const ScreenTimeAndroidStepProtected({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;

    return ScreenTimeStepShell(
      hero: const _AppsListHero(allSelected: true, chipRows: false),
      icon: Icon(
        Icons.verified_user_outlined,
        size: 20.sp,
        color: colorScheme.primary,
      ),
      title: l10n.screenTimeAndroidStep4Title,
      body: l10n.screenTimeAndroidStep4Body,
    );
  }
}

// ─── Heroes ──────────────────────────────────────────────────────────────────

class _IosPermissionDialogHero extends StatelessWidget {
  const _IosPermissionDialogHero({
    required this.continueBackground,
    required this.continueForeground,
    required this.dontAllowFilled,
  });

  final Color continueBackground;
  final Color continueForeground;
  final bool dontAllowFilled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final dialog = Container(
      width: 228.w,
      padding: EdgeInsets.fromLTRB(20.w, 20.h, 20.w, 16.h),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.35 : 0.12),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.screenTimePromptTitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 16.sp,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            l10n.screenTimePromptMessage(l10n.appTitle),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13.sp,
              height: 1.35,
              fontWeight: FontWeight.w400,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: 18.h),
          Row(
            children: [
              Expanded(
                child: dontAllowFilled
                    ? Container(
                        height: 34.h,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          l10n.screenTimeDontAllow,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w600,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      )
                    : SizedBox(
                        height: 34.h,
                        child: Center(
                          child: Text(
                            l10n.screenTimeDontAllow,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 13.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Container(
                  height: 34.h,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: continueBackground,
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    l10n.screenTimePromptContinue,
                    style: TextStyle(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w700,
                      color: continueForeground,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );

    return Container(
      width: 268.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.45)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(child: dialog),
    );
  }
}

class _AndroidUsageAccessHero extends StatelessWidget {
  const _AndroidUsageAccessHero();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 268.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.45)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        width: 236.w,
        padding: EdgeInsets.fromLTRB(16.w, 16.h, 16.w, 14.h),
        decoration: BoxDecoration(
          color: isDark
              ? colorScheme.surfaceContainerHighest
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: isDark ? 0.3 : 0.1),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.screenTimeAndroidUsageTitle,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 12.h),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainerHighest.withValues(
                  alpha: 0.55,
                ),
                borderRadius: BorderRadius.circular(14.r),
              ),
              child: Row(
                children: [
                  Container(
                    width: 34.r,
                    height: 34.r,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Icon(
                      Icons.spa_rounded,
                      size: 18.sp,
                      color: colorScheme.primary,
                    ),
                  ),
                  SizedBox(width: 10.w),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.appTitle,
                          style: TextStyle(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.onSurface,
                          ),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          l10n.screenTimeAndroidUsageMessage,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 11.sp,
                            height: 1.3,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 8.w),
                  _AndroidSwitch(on: false),
                ],
              ),
            ),
            SizedBox(height: 14.h),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 34.h,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Text(
                  l10n.screenTimeAndroidPermit,
                  style: TextStyle(
                    fontSize: 13.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AndroidAccessibilityHero extends StatelessWidget {
  const _AndroidAccessibilityHero();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: 268.w,
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 18.h),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.45)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(26.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.25 : 0.06),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Container(
        width: 236.w,
        padding: EdgeInsets.fromLTRB(18.w, 18.h, 18.w, 14.h),
        decoration: BoxDecoration(
          color: isDark
              ? colorScheme.surfaceContainerHighest
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(18.r),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: isDark ? 0.3 : 0.1),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.accessibility_new_rounded,
              size: 28.sp,
              color: colorScheme.primary,
            ),
            SizedBox(height: 10.h),
            Text(
              l10n.screenTimeAndroidAccessibilityTitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 8.h),
            Text(
              l10n.screenTimeAndroidAccessibilityMessage,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 12.5.sp,
                height: 1.35,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: 16.h),
            Row(
              children: [
                Expanded(
                  child: Container(
                    height: 36.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      l10n.screenTimeAndroidNotNow,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: Container(
                    height: 36.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: colorScheme.primary,
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                    child: Text(
                      l10n.screenTimeAndroidEnable,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: colorScheme.onPrimary,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AndroidSwitch extends StatelessWidget {
  const _AndroidSwitch({required this.on});

  final bool on;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final trackColor = on
        ? colorScheme.primary
        : colorScheme.outlineVariant.withValues(alpha: 0.8);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 36.w,
      height: 22.h,
      padding: EdgeInsets.all(2.r),
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(999),
      ),
      alignment: on ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        width: 18.r,
        height: 18.r,
        decoration: BoxDecoration(
          color: colorScheme.surface,
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: 0.15),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
      ),
    );
  }
}

class _AppsListHero extends StatelessWidget {
  const _AppsListHero({
    required this.allSelected,
    required this.chipRows,
  });

  final bool allSelected;
  final bool chipRows;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final apps = <(String, bool)>[
      (l10n.screenTimeAppInstagram, true),
      (l10n.screenTimeAppTikTok, true),
      (l10n.screenTimeAppYouTube, true),
      (l10n.screenTimeAppGames, allSelected),
    ];

    return Container(
      width: 248.w,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 14.h),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest
            : colorScheme.surface,
        borderRadius: BorderRadius.circular(22.r),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.28 : 0.1),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 0; i < apps.length; i++) ...[
            if (i > 0) SizedBox(height: chipRows ? 8.h : 0),
            if (!chipRows && i > 0)
              Divider(
                height: 14.h,
                thickness: 1,
                color: colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
            _AppRow(
              name: apps[i].$1,
              selected: apps[i].$2,
              asChip: chipRows,
            ),
          ],
        ],
      ),
    );
  }
}

class _AppRow extends StatelessWidget {
  const _AppRow({
    required this.name,
    required this.selected,
    required this.asChip,
  });

  final String name;
  final bool selected;
  final bool asChip;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final row = Row(
      children: [
        Container(
          width: 26.r,
          height: 26.r,
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(7.r),
          ),
        ),
        SizedBox(width: 10.w),
        Expanded(
          child: Text(
            name,
            style: TextStyle(
              fontSize: 13.sp,
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurface,
            ),
          ),
        ),
        if (selected)
          Icon(
            CupertinoIcons.check_mark,
            size: 15.sp,
            color: colorScheme.primary,
          )
        else
          Container(
            width: 16.r,
            height: 16.r,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: colorScheme.outlineVariant,
                width: 1.4,
              ),
            ),
          ),
      ],
    );

    if (!asChip) return row;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 9.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: row,
    );
  }
}

class _ToggleGlyph extends StatelessWidget {
  const _ToggleGlyph({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return SizedBox(
      width: size,
      height: size * 0.55,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colorScheme.primary,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Align(
          alignment: Alignment.centerRight,
          child: Padding(
            padding: EdgeInsets.all(size * 0.08),
            child: Container(
              width: size * 0.42,
              height: size * 0.42,
              decoration: BoxDecoration(
                color: colorScheme.onPrimary,
                shape: BoxShape.circle,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _FilterGlyph extends StatelessWidget {
  const _FilterGlyph({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;
    final barHeight = (size * 0.14).clamp(2.0, 3.5);

    return SizedBox(
      width: size,
      height: size * 0.72,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _bar(width: size, height: barHeight, color: color),
          _bar(width: size * 0.72, height: barHeight, color: color),
          _bar(width: size * 0.45, height: barHeight, color: color),
        ],
      ),
    );
  }

  Widget _bar({
    required double width,
    required double height,
    required Color color,
  }) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
