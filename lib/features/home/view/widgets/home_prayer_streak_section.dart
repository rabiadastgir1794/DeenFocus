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
    this.isCycleThemeActive = false,
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

  /// When Cycle Mode is ON, accents use app Cycle pink; card shell stays normal.
  final bool isCycleThemeActive;

  /// Same Cycle Mode pink as toggle / banner / calendar (`#FF9EC5`).
  static const _cyclePink = Color(0xFFFF9EC5);
  static const _cyclePinkDark = Color(0xFFE59DB7);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cycleColor = isDark ? _cyclePinkDark : _cyclePink;
    final accent = isCycleThemeActive ? cycleColor : colorScheme.primary;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);
    final restoreChipColor = isDark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.45)
        : const Color(0xFFEEEEEA);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(
            // Keep the normal soft card — only accents turn Cycle pink.
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
          padding: const EdgeInsets.fromLTRB(14, 11, 12, 11),
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
                        fontSize: 14,
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
                                .labelMedium
                                ?.copyWith(
                                  color: isCycleThemeActive
                                      ? cycleColor
                                      : colorScheme.primary
                                          .withValues(alpha: 0.8),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                          Icon(
                            Icons.chevron_right_rounded,
                            size: 15,
                            color: isCycleThemeActive
                                ? cycleColor
                                : colorScheme.primary.withValues(alpha: 0.8),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: _StreakMetric(
                      icon: Icons.local_fire_department_rounded,
                      title: l10n.insightsPrayerStreak,
                      value: '$prayerStreak',
                      subtitle: l10n.insightsPrayersInARow,
                      accentColor: accent,
                      titleUsesAccent: isCycleThemeActive,
                      colorScheme: colorScheme,
                    ),
                  ),
                  Container(
                    width: 1,
                    height: 46,
                    margin: const EdgeInsets.symmetric(horizontal: 8),
                    color: colorScheme.outlineVariant.withValues(alpha: 0.28),
                  ),
                  Expanded(
                    child: _StreakMetric(
                      icon: Icons.calendar_today_rounded,
                      title: l10n.insightsDayStreak,
                      value: '$dayStreak',
                      subtitle: l10n.insightsDaysInARow,
                      accentColor: accent,
                      titleUsesAccent: isCycleThemeActive,
                      colorScheme: colorScheme,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
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
                            const SizedBox(height: 3),
                            Text(
                              [
                                l10n.weekdayLetterMon,
                                l10n.weekdayLetterTue,
                                l10n.weekdayLetterWed,
                                l10n.weekdayLetterThu,
                                l10n.weekdayLetterFri,
                                l10n.weekdayLetterSat,
                                l10n.weekdayLetterSun,
                              ][index],
                              style: Theme.of(context)
                                  .textTheme
                                  .labelSmall
                                  ?.copyWith(
                                    fontSize: 9.5,
                                    color: weekCycleModeDays.length > index &&
                                            weekCycleModeDays[index]
                                        ? cycleColor.withValues(alpha: 0.85)
                                        : colorScheme.onSurfaceVariant
                                            .withValues(alpha: 0.45),
                                    fontWeight:
                                        weekCycleModeDays.length > index &&
                                                weekCycleModeDays[index]
                                            ? FontWeight.w600
                                            : FontWeight.w500,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
              if (canRestoreStreak && onRestoreStreak != null) ...[
                const SizedBox(height: 10),
                Material(
                  color: restoreChipColor,
                  borderRadius: BorderRadius.circular(24),
                  child: InkWell(
                    onTap: onRestoreStreak,
                    borderRadius: BorderRadius.circular(24),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.refresh_rounded,
                            size: 16,
                            color: accent,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              l10n.insightsRestoreStreak,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelLarge
                                  ?.copyWith(
                                    color: accent,
                                    fontWeight: FontWeight.w600,
                                    fontSize: 13,
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
    required this.accentColor,
    required this.titleUsesAccent,
    required this.colorScheme,
  });

  final IconData icon;
  final String title;
  final String value;
  final String subtitle;
  final Color accentColor;
  final bool titleUsesAccent;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final titleColor = titleUsesAccent
        ? accentColor
        : colorScheme.onSurface.withValues(alpha: 0.75);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, color: accentColor, size: 14),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(
                  color: titleColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: textTheme.headlineMedium?.copyWith(
            color: accentColor,
            fontWeight: FontWeight.w800,
            height: 1.0,
            fontSize: 24,
          ),
        ),
        const SizedBox(height: 1),
        Text(
          subtitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
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
    // Cycle days: soft pink well + solid pink base bar (reference).
    final cycleTrack = cycleColor.withValues(alpha: isDark ? 0.28 : 0.22);
    final cycleBar = cycleColor;

    return SizedBox(
      height: 22,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          height: 17,
          decoration: BoxDecoration(
            color: isCycleDay ? cycleTrack : trackColor,
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.bottomCenter,
          child: fill <= 0
              ? (isCycleDay
                  ? FractionallySizedBox(
                      heightFactor: 0.22,
                      widthFactor: 1,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: cycleBar,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    )
                  : const SizedBox.shrink())
              : FractionallySizedBox(
                  heightFactor: fill.clamp(0.22, 1.0),
                  widthFactor: 1,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: isCycleDay ? cycleBar : fillColor,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
