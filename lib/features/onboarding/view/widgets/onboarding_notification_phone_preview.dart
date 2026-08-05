import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

/// Lock-screen phone illustration for the notifications onboarding step.
///
/// Built on a fixed design canvas and scaled with [FittedBox] so proportions
/// stay pixel-consistent and never overflow on small screens.
class OnboardingNotificationPhonePreview extends StatelessWidget {
  const OnboardingNotificationPhonePreview({super.key});

  static const Size designSize = Size(236, 412);

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      child: SizedBox(
        width: designSize.width,
        height: designSize.height,
        child: const _PhoneCanvas(),
      ),
    );
  }
}

class _PhoneCanvas extends StatelessWidget {
  const _PhoneCanvas();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context)!;

    final frameColor = isDark
        ? colorScheme.surfaceContainerHigh
        : colorScheme.surfaceContainerHighest;
    final screenColor = isDark
        ? colorScheme.surfaceContainerLowest
        : colorScheme.surface;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: frameColor,
        borderRadius: BorderRadius.circular(42),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.55),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.4 : 0.14),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: ColoredBox(
            color: screenColor,
            child: Stack(
              children: [
                const Positioned(
                  top: 12,
                  left: 0,
                  right: 0,
                  child: Center(child: _DynamicIsland()),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(14, 42, 14, 14),
                  child: Column(
                    children: [
                      Text(
                        l10n.notificationsPreviewDate,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurfaceVariant,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.notificationsPreviewTime,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1.5,
                          height: 1,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      const SizedBox(height: 16),
                      _NotificationCard(
                        icon: Icons.nightlight_round,
                        iconBackground: colorScheme.primary,
                        iconColor: colorScheme.onPrimary,
                        appName: l10n.appTitle.toUpperCase(),
                        timeLabel: l10n.notificationsPreviewNow,
                        title: l10n.notificationsPreviewAdhanTitle,
                        body: l10n.notificationsPreviewAdhanBody,
                        opacity: 1,
                      ),
                      const SizedBox(height: 8),
                      _NotificationCard(
                        icon: CupertinoIcons.heart_fill,
                        iconBackground: colorScheme.tertiary.withValues(
                          alpha: isDark ? 0.35 : 0.22,
                        ),
                        iconColor: isDark
                            ? colorScheme.tertiary
                            : colorScheme.onTertiaryContainer,
                        appName: l10n.appTitle.toUpperCase(),
                        timeLabel: l10n.notificationsPreviewMinutesAgo,
                        title: l10n.notificationsPreviewDhikrTitle,
                        body: l10n.notificationsPreviewDhikrBody,
                        opacity: 0.78,
                      ),
                      const SizedBox(height: 8),
                      _NotificationCard(
                        icon: Icons.local_fire_department_rounded,
                        iconBackground: colorScheme.primaryContainer,
                        iconColor: colorScheme.primary,
                        appName: l10n.appTitle.toUpperCase(),
                        timeLabel: l10n.notificationsPreviewHourAgo,
                        title: l10n.notificationsPreviewStreakTitle,
                        body: l10n.notificationsPreviewStreakBody,
                        opacity: 0.55,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DynamicIsland extends StatelessWidget {
  const _DynamicIsland();

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: 78,
      height: 22,
      decoration: BoxDecoration(
        color: colorScheme.onSurface.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(20),
      ),
    );
  }
}

class _NotificationCard extends StatelessWidget {
  const _NotificationCard({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.appName,
    required this.timeLabel,
    required this.title,
    required this.body,
    required this.opacity,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String appName;
  final String timeLabel;
  final String title;
  final String body;
  final double opacity;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Opacity(
      opacity: opacity,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 10),
        decoration: BoxDecoration(
          color: isDark
              ? colorScheme.surfaceContainerHigh
              : colorScheme.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: colorScheme.shadow.withValues(alpha: isDark ? 0.25 : 0.08),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 16, color: iconColor),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          appName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.3,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ),
                      Text(
                        timeLabel,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 1),
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      height: 1.2,
                      color: colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    body,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      height: 1.25,
                      color: colorScheme.onSurfaceVariant,
                    ),
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
