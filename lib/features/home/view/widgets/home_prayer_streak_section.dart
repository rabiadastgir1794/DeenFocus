import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class HomePrayerStreakSection extends StatelessWidget {
  const HomePrayerStreakSection({
    super.key,
    required this.streakDays,
    required this.weekFlags,
    required this.backgroundColor,
    required this.onTap,
  });

  final int streakDays;
  final List<bool> weekFlags;
  final Color backgroundColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  l10n.homePrayerStreak,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(width: 8),
                if (streakDays > 3)
                  Text(
                    '🔥 $streakDays ${l10n.homeDays}',
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                const Spacer(),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              '$streakDays ${l10n.homeDays}',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                for (var index = 0; index < 7; index++)
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 2),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            height: weekFlags[index]
                                ? 18.0 + (index * 4)
                                : 12.0,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8),
                              color: weekFlags[index]
                                  ? colorScheme.primary
                                  : colorScheme.outlineVariant.withValues(
                                      alpha: isDark ? 0.6 : 0.35,
                                    ),
                            ),
                          ),
                          const SizedBox(height: 5),
                          Text(
                            const ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                            style: Theme.of(context).textTheme.labelSmall,
                          ),
                        ],
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
