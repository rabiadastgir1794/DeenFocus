import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';

class HomePrayerStreakSection extends StatelessWidget {
  const HomePrayerStreakSection({
    super.key,
    required this.prayerStreak,
    required this.dayStreak,
    required this.weekPrayerCounts,
    required this.backgroundColor,
    required this.onTap,
    this.onInsightsTap,
    this.onRestoreStreak,
    this.canRestoreStreak = false,
    this.weekCycleModeDays = const <bool>[
      false,
      false,
      false,
      false,
      false,
      false,
      false,
    ],
  });

  final int prayerStreak;
  final int dayStreak;
  final List<int> weekPrayerCounts;
  final List<bool> weekCycleModeDays;
  final Color backgroundColor;
  final VoidCallback onTap;
  final VoidCallback? onInsightsTap;
  final VoidCallback? onRestoreStreak;
  final bool canRestoreStreak;

  static const _cyclePink = Color(0xFFFF9EC5);
  static const _cyclePinkDark = Color(0xFFE59DB7);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);
    final cycleColor = isDark ? _cyclePinkDark : _cyclePink;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.homePrayerStreak,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: onInsightsTap ?? onTap,
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 4,
                        vertical: 2,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            l10n.homeInsights,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.85,
                                  ),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 18,
                            color: colorScheme.primary.withValues(alpha: 0.85),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _StreakMetric(
                      icon: Icons.local_fire_department_rounded,
                      title: l10n.insightsPrayerStreak,
                      value: '$prayerStreak',
                      subtitle: l10n.insightsPrayersInARow,
                      colorScheme: colorScheme,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 52,
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    color: colorScheme.outlineVariant.withValues(alpha: 0.35),
                  ),
                  Expanded(
                    child: _StreakMetric(
                      icon: Icons.calendar_today_rounded,
                      title: l10n.insightsDayStreak,
                      value: '$dayStreak',
                      subtitle: l10n.insightsDaysInARow,
                      colorScheme: colorScheme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
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
                            _DayBar(
                              prayerCount: weekPrayerCounts.length > index
                                  ? weekPrayerCounts[index]
                                  : 0,
                              isCycleDay: weekCycleModeDays.length > index &&
                                  weekCycleModeDays[index],
                              cycleColor: cycleColor,
                              colorScheme: colorScheme,
                              isDark: isDark,
                            ),
                            const SizedBox(height: 5),
                            Text(
                              const ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    color: weekCycleModeDays.length > index &&
                                            weekCycleModeDays[index]
                                        ? cycleColor
                                        : colorScheme.onSurfaceVariant
                                            .withValues(alpha: 0.55),
                                    fontWeight:
                                        weekCycleModeDays.length > index &&
                                                weekCycleModeDays[index]
                                            ? FontWeight.w700
                                            : null,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              if (canRestoreStreak && onRestoreStreak != null) ...[
                const SizedBox(height: 14),
                Material(
                  color: isDark
                      ? colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.45,
                        )
                      : const Color(0xFFEEEEEA),
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    onTap: onRestoreStreak,
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 11,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.refresh_rounded,
                            size: 18,
                            color: colorScheme.primary,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.insightsRestoreStreak,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StreakMetric extends StatelessWidget {
  const _StreakMetric({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
    required this.colorScheme,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: colorScheme.primary, size: 16),
            const SizedBox(width: 5),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurface.withValues(alpha: 0.75),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Text(
          value,
          style: textTheme.headlineSmall?.copyWith(
            color: colorScheme.primary,
            fontWeight: FontWeight.w800,
            height: 1.05,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant.withValues(alpha: 0.75),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _DayBar extends StatelessWidget {
  const _DayBar({
    required this.prayerCount,
    required this.isCycleDay,
    required this.cycleColor,
    required this.colorScheme,
    required this.isDark,
  });

  final int prayerCount;
  final bool isCycleDay;
  final Color cycleColor;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    const maxPrayers = 5;
    final fill = prayerCount.clamp(0, maxPrayers) / maxPrayers;
    final trackColor = isDark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.55)
        : const Color(0xFFE8E8E4);
    final fillColor = isCycleDay ? cycleColor : colorScheme.primary;

    return SizedBox(
      height: 36,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 28,
          decoration: BoxDecoration(
            color: isCycleDay
                ? cycleColor.withValues(alpha: isDark ? 0.22 : 0.18)
                : trackColor,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.bottomCenter,
          child: fill <= 0
              ? (isCycleDay
                  ? FractionallySizedBox(
                      heightFactor: 0.15,
                      widthFactor: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: cycleColor.withValues(alpha: 0.85),
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    )
                  : const SizedBox.shrink())
              : FractionallySizedBox(
                  heightFactor: fill.clamp(0.15, 1.0),
                  widthFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: fillColor.withValues(
                        alpha: isCycleDay ? 0.85 : 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
