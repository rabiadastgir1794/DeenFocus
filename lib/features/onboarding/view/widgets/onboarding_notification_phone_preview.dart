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

    final bezelColor = isDark
        ? colorScheme.surfaceContainerHighest
        : colorScheme.inverseSurface;
    final lockOnColor = isDark
        ? colorScheme.onSurface
        : colorScheme.onPrimaryContainer;
    final wallpaperColors = isDark
        ? [
            colorScheme.surfaceContainerHigh,
            colorScheme.surface,
            colorScheme.surfaceContainerLowest,
          ]
        : [
            colorScheme.primaryContainer,
            Color.lerp(
              colorScheme.primaryContainer,
              colorScheme.secondaryContainer,
              0.55,
            )!,
            colorScheme.secondaryContainer,
          ];

    return DecoratedBox(
      decoration: BoxDecoration(
        color: bezelColor,
        borderRadius: BorderRadius.circular(44),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.45 : 0.22),
            blurRadius: 28,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(34),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: wallpaperColors,
              ),
            ),
            child: Stack(
              children: [
                const Positioned(
                  top: 10,
                  left: 0,
                  right: 0,
                  child: Center(child: _DynamicIsland()),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 40, 12, 12),
                  child: Column(
                    children: [
                      Text(
                        l10n.notificationsPreviewDate,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: lockOnColor.withValues(alpha: 0.78),
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        l10n.notificationsPreviewTime,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 56,
                          fontWeight: FontWeight.w700,
                          letterSpacing: -1.5,
                          height: 1,
                          color: lockOnColor,
                        ),
                      ),
                      const SizedBox(height: 18),
                      _NotificationCard(
                        icon: CupertinoIcons.moon_fill,
                        iconBackground: colorScheme.primary,
                        iconColor: colorScheme.onPrimary,
                        appName: l10n.appTitle.toUpperCase(),
                        timeLabel: l10n.notificationsPreviewNow,
                        title: l10n.notificationsPreviewAdhanTitle,
                        body: l10n.notificationsPreviewAdhanBody,
                      ),
                      const SizedBox(height: 6),
                      _NotificationCard(
                        icon: CupertinoIcons.heart_fill,
                        iconBackground: colorScheme.tertiaryContainer,
                        iconColor: colorScheme.onTertiaryContainer,
                        appName: l10n.appTitle.toUpperCase(),
                        timeLabel: l10n.notificationsPreviewMinutesAgo,
                        title: l10n.notificationsPreviewDhikrTitle,
                        body: l10n.notificationsPreviewDhikrBody,
                      ),
                      const SizedBox(height: 6),
                      _NotificationCard(
                        icon: Icons.local_fire_department_rounded,
                        iconBackground: colorScheme.primaryContainer,
                        iconColor: colorScheme.primary,
                        appName: l10n.appTitle.toUpperCase(),
                        timeLabel: l10n.notificationsPreviewHourAgo,
                        title: l10n.notificationsPreviewStreakTitle,
                        body: l10n.notificationsPreviewStreakBody,
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
        color: colorScheme.scrim,
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
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String appName;
  final String timeLabel;
  final String title;
  final String body;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bannerColor = isDark
        ? colorScheme.surfaceContainerHigh
        : colorScheme.surfaceContainerLowest;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(10, 9, 10, 9),
      decoration: BoxDecoration(
        color: bannerColor,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: colorScheme.shadow.withValues(alpha: isDark ? 0.28 : 0.1),
            blurRadius: 10,
            offset: const Offset(0, 3),
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
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.2,
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
    );
  }
}
