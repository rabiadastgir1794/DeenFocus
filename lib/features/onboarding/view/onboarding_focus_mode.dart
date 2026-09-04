import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../l10n/app_localizations.dart';

enum _FocusModeKind { prayer, sleep, child }

class OnboardingFocusModePage extends StatefulWidget {
  const OnboardingFocusModePage({super.key});

  @override
  State<OnboardingFocusModePage> createState() =>
      _OnboardingFocusModePageState();
}

class _OnboardingFocusModePageState extends State<OnboardingFocusModePage> {
  _FocusModeKind? _selectedMode;

  Future<void> _openModeDetails(_FocusModeKind kind) async {
    setState(() => _selectedMode = kind);
    await _showFocusModeDetailsDialog(context, kind: kind);
    if (!mounted) return;
    setState(() => _selectedMode = null);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 700;

        return SafeArea(
          bottom: false,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            padding: EdgeInsets.fromLTRB(
              Spacing.lg.w,
              compact ? Spacing.md.h : Spacing.lg.h,
              Spacing.lg.w,
              Spacing.md.h,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.focusModesTitle,
                  textAlign: TextAlign.center,
                  style: textTheme.headlineLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: compact ? 24.sp : 28.sp,
                    height: 1.15,
                    letterSpacing: -0.4,
                    color: colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: compact ? Spacing.sm.h : Spacing.md.h),
                Text(
                  l10n.focusModesSubtitle,
                  textAlign: TextAlign.center,
                  style: textTheme.bodyLarge?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.45,
                    fontSize: compact ? 13.sp : 14.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(height: compact ? Spacing.lg.h : Spacing.xl.h),
                _SectionLabel(label: l10n.focusModesSectionLabel),
                SizedBox(height: Spacing.sm.h),
                _FocusModesRow(
                  compact: compact,
                  selectedMode: _selectedMode,
                  onModeTap: _openModeDetails,
                ),
                SizedBox(height: compact ? Spacing.lg.h : Spacing.xl.h),
                _SectionLabel(label: l10n.focusPrayerTrackingSectionLabel),
                SizedBox(height: Spacing.sm.h),
                _FeatureGrid(
                  compact: compact,
                  items: [
                    _FeatureItem(
                      icon: Icons.schedule_rounded,
                      title: l10n.focusFeaturePrayerTimesTitle,
                      subtitle: l10n.focusFeaturePrayerTimesSubtitle,
                    ),
                    _FeatureItem(
                      icon: Icons.local_fire_department_outlined,
                      title: l10n.focusFeatureStreaksTitle,
                      subtitle: l10n.focusFeatureStreaksSubtitle,
                    ),
                    _FeatureItem(
                      icon: Icons.checklist_rounded,
                      title: l10n.focusFeatureChecklistTitle,
                      subtitle: l10n.focusFeatureChecklistSubtitle,
                    ),
                    _FeatureItem(
                      icon: Icons.explore_outlined,
                      title: l10n.focusFeatureQiblaTitle,
                      subtitle: l10n.focusFeatureQiblaSubtitle,
                    ),
                  ],
                ),
                SizedBox(height: compact ? Spacing.lg.h : Spacing.xl.h),
                _SectionLabel(label: l10n.focusLearningHubSectionLabel),
                SizedBox(height: Spacing.sm.h),
                _FeatureGrid(
                  compact: compact,
                  items: [
                    _FeatureItem(
                      icon: Icons.menu_book_outlined,
                      title: l10n.focusFeatureQuranTitle,
                      subtitle: l10n.focusFeatureQuranSubtitle,
                    ),
                    _FeatureItem(
                      icon: Icons.school_outlined,
                      title: l10n.focusFeatureHadithTitle,
                      subtitle: l10n.focusFeatureHadithSubtitle,
                    ),
                    _FeatureItem(
                      icon: Icons.favorite_border_rounded,
                      title: l10n.focusFeatureDuasTitle,
                      subtitle: l10n.focusFeatureDuasSubtitle,
                    ),
                    _FeatureItem(
                      icon: Icons.circle_outlined,
                      title: l10n.focusFeatureTasbihTitle,
                      subtitle: l10n.focusFeatureTasbihSubtitle,
                    ),
                  ],
                ),
                SizedBox(height: compact ? Spacing.lg.h : Spacing.xl.h),
                _SectionLabel(label: l10n.focusMoreSectionLabel),
                SizedBox(height: Spacing.sm.h),
                _FeatureGrid(
                  compact: compact,
                  items: [
                    _FeatureItem(
                      icon: Icons.auto_awesome_outlined,
                      title: l10n.focusFeatureAiTitle,
                      subtitle: l10n.focusFeatureAiSubtitle,
                    ),
                    _FeatureItem(
                      icon: Icons.notifications_none_rounded,
                      title: l10n.focusFeatureInsightsTitle,
                      subtitle: l10n.focusFeatureInsightsSubtitle,
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<void> _showFocusModeDetailsDialog(
  BuildContext context, {
  required _FocusModeKind kind,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.transparent,
    transitionDuration: Duration.zero,
    pageBuilder: (ctx, animation, secondaryAnimation) {
      return _FocusModeDetailsDialog(kind: kind);
    },
  );
}

class _FocusModeDetailsDialog extends StatelessWidget {
  const _FocusModeDetailsDialog({required this.kind});

  final _FocusModeKind kind;

  _FocusModeDialogContent _content(AppLocalizations l10n, ColorScheme scheme) {
    switch (kind) {
      case _FocusModeKind.prayer:
        return _FocusModeDialogContent(
          title: l10n.focusPrayerModeTitle,
          description: l10n.focusPrayerModeDescription,
          bullets: [
            l10n.focusPrayerModeBullet1,
            l10n.focusPrayerModeBullet2,
            l10n.focusPrayerModeBullet3,
          ],
          icon: Icons.shield_outlined,
          iconColor: scheme.primary,
          iconBackground: scheme.primaryContainer,
        );
      case _FocusModeKind.sleep:
        return _FocusModeDialogContent(
          title: l10n.focusSleepModeTitle,
          description: l10n.focusSleepModeDescription,
          bullets: [
            l10n.focusSleepModeBullet1,
            l10n.focusSleepModeBullet2,
            l10n.focusSleepModeBullet3,
          ],
          icon: Icons.dark_mode_outlined,
          iconColor: scheme.tertiary,
          iconBackground: scheme.tertiaryContainer,
        );
      case _FocusModeKind.child:
        return _FocusModeDialogContent(
          title: l10n.focusChildModeTitle,
          description: l10n.focusChildModeDescription,
          bullets: [
            l10n.focusChildModeBullet1,
            l10n.focusChildModeBullet2,
            l10n.focusChildModeBullet3,
          ],
          icon: Icons.child_care_outlined,
          iconColor: scheme.error,
          iconBackground: scheme.errorContainer,
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final content = _content(l10n, colorScheme);
    final maxWidth = MediaQuery.sizeOf(context).width;

    return Material(
      type: MaterialType.transparency,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).maybePop(),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
              child: ColoredBox(
                color: colorScheme.scrim.withValues(alpha: 0.28),
              ),
            ),
          ),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(horizontal: 28.w, vertical: 24.h),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: maxWidth < 420 ? maxWidth - 56.w : 340.w,
                  ),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(28.r),
                      boxShadow: [
                        BoxShadow(
                          color: colorScheme.shadow.withValues(alpha: 0.16),
                          blurRadius: 28,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(20.w, 16.h, 20.w, 20.h),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Align(
                            alignment: Alignment.topRight,
                            child: IconButton(
                              onPressed: () => Navigator.of(context).maybePop(),
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: BoxConstraints.tightFor(
                                width: 32.w,
                                height: 32.w,
                              ),
                              icon: Icon(
                                Icons.close_rounded,
                                size: 20.sp,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                          ),
                          _FocusModeIconBadge(
                            icon: content.icon,
                            iconColor: content.iconColor,
                            backgroundColor: content.iconBackground,
                            size: 56.w,
                            iconSize: 28.sp,
                            radius: 16.r,
                          ),
                          SizedBox(height: Spacing.md.h),
                          Text(
                            content.title,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.titleLarge
                                ?.copyWith(
                              fontWeight: FontWeight.w700,
                              fontSize: 20.sp,
                              color: colorScheme.onSurface,
                            ),
                          ),
                          SizedBox(height: Spacing.sm.h),
                          Text(
                            content.description,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyMedium
                                ?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              height: 1.5,
                              fontSize: 14.sp,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          SizedBox(height: Spacing.lg.h),
                          DecoratedBox(
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHigh
                                  .withValues(alpha: 0.7),
                              borderRadius: BorderRadius.circular(16.r),
                            ),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                horizontal: 14.w,
                                vertical: 14.h,
                              ),
                              child: Column(
                                children: [
                                  for (var i = 0;
                                      i < content.bullets.length;
                                      i++) ...[
                                    if (i > 0) SizedBox(height: 10.h),
                                    _BulletRow(text: content.bullets[i]),
                                  ],
                                ],
                              ),
                            ),
                          ),
                          SizedBox(height: Spacing.lg.h),
                          SizedBox(
                            width: double.infinity,
                            height: 52.h,
                            child: ElevatedButton(
                              onPressed: () =>
                                  Navigator.of(context).maybePop(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: colorScheme.primary,
                                foregroundColor: colorScheme.onPrimary,
                                elevation: 0,
                                shape: const StadiumBorder(),
                              ),
                              child: Text(
                                l10n.focusModeGotIt,
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusModeDialogContent {
  const _FocusModeDialogContent({
    required this.title,
    required this.description,
    required this.bullets,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
  });

  final String title;
  final String description;
  final List<String> bullets;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
}

class _FocusModeIconBadge extends StatelessWidget {
  const _FocusModeIconBadge({
    required this.icon,
    required this.iconColor,
    required this.backgroundColor,
    required this.size,
    required this.iconSize,
    required this.radius,
  });

  final IconData icon;
  final Color iconColor;
  final Color backgroundColor;
  final double size;
  final double iconSize;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(radius),
      ),
      alignment: Alignment.center,
      child: Icon(icon, size: iconSize, color: iconColor),
    );
  }
}

class _BulletRow extends StatelessWidget {
  const _BulletRow({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(Icons.check_rounded, size: 18.sp, color: colorScheme.primary),
        SizedBox(width: 8.w),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurface,
              fontSize: 13.sp,
              height: 1.35,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Text(
      label,
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: colorScheme.primary,
        fontWeight: FontWeight.w700,
        fontSize: 11.sp,
        letterSpacing: 0.6,
      ),
    );
  }
}

class _FocusModesRow extends StatelessWidget {
  const _FocusModesRow({
    required this.compact,
    required this.selectedMode,
    required this.onModeTap,
  });

  final bool compact;
  final _FocusModeKind? selectedMode;
  final ValueChanged<_FocusModeKind> onModeTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    final modes = [
      (
        kind: _FocusModeKind.prayer,
        title: l10n.focusPrayerModeTitle,
        icon: Icons.shield_outlined,
        iconColor: colorScheme.primary,
        iconBackground: colorScheme.primaryContainer,
      ),
      (
        kind: _FocusModeKind.sleep,
        title: l10n.focusSleepModeTitle,
        icon: Icons.dark_mode_outlined,
        iconColor: colorScheme.tertiary,
        iconBackground: colorScheme.tertiaryContainer,
      ),
      (
        kind: _FocusModeKind.child,
        title: l10n.focusChildModeTitle,
        icon: Icons.child_care_outlined,
        iconColor: colorScheme.error,
        iconBackground: colorScheme.errorContainer,
      ),
    ];

    return Row(
      children: [
        for (var i = 0; i < modes.length; i++) ...[
          if (i > 0) SizedBox(width: compact ? 8.w : 10.w),
          Expanded(
            child: _FocusModeTile(
              title: modes[i].title,
              icon: modes[i].icon,
              iconColor: modes[i].iconColor,
              iconBackground: modes[i].iconBackground,
              compact: compact,
              selected: selectedMode == modes[i].kind,
              onTap: () => onModeTap(modes[i].kind),
            ),
          ),
        ],
      ],
    );
  }
}

class _FocusModeTile extends StatelessWidget {
  const _FocusModeTile({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.iconBackground,
    required this.compact,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final Color iconBackground;
  final bool compact;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final badgeSize = compact ? 40.h : 44.h;

    return Material(
      color: colorScheme.surfaceContainerLowest,
      borderRadius: BorderRadius.circular(18.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18.r),
        child: Container(
          constraints: BoxConstraints(minHeight: compact ? 104.h : 116.h),
          padding: EdgeInsets.symmetric(
            horizontal: 8.w,
            vertical: compact ? 12.h : 14.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18.r),
            border: Border.all(
              color: selected
                  ? colorScheme.tertiary
                  : colorScheme.outlineVariant.withValues(alpha: 0.45),
              width: selected ? 2 : 1,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _FocusModeIconBadge(
                icon: icon,
                iconColor: iconColor,
                backgroundColor: iconBackground,
                size: badgeSize,
                iconSize: compact ? 20.sp : 22.sp,
                radius: compact ? 12.r : 14.r,
              ),
              SizedBox(height: compact ? 8.h : 10.h),
              Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: compact ? 11.sp : 12.sp,
                  color: colorScheme.onSurface,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureItem {
  const _FeatureItem({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid({
    required this.items,
    required this.compact,
  });

  final List<_FeatureItem> items;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final gap = compact ? 8.w : 10.w;

    return LayoutBuilder(
      builder: (context, constraints) {
        final itemWidth = (constraints.maxWidth - gap) / 2;

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final item in items)
              SizedBox(
                width: itemWidth,
                child: _FeatureCard(item: item, compact: compact),
              ),
          ],
        );
      },
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.item,
    required this.compact,
  });

  final _FeatureItem item;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(
        compact ? 12.w : 14.w,
        compact ? 12.h : 14.h,
        compact ? 12.w : 14.w,
        compact ? 12.h : 14.h,
      ),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.45),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            item.icon,
            size: compact ? 20.sp : 22.sp,
            color: colorScheme.primary,
          ),
          SizedBox(height: compact ? 8.h : 10.h),
          Text(
            item.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              fontSize: compact ? 12.sp : 13.sp,
              color: colorScheme.onSurface,
              height: 1.2,
            ),
          ),
          SizedBox(height: 4.h),
          Text(
            item.subtitle,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontWeight: FontWeight.w400,
              fontSize: compact ? 11.sp : 12.sp,
              color: colorScheme.onSurfaceVariant,
              height: 1.3,
            ),
          ),
        ],
      ),
    );
  }
}
