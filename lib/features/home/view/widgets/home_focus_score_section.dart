import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'home_card_open_arrow.dart';

/// Today's Focus Score — large score first; stars/breakdown secondary.
class HomeFocusScoreSection extends StatelessWidget {
  const HomeFocusScoreSection({
    super.key,
    required this.backgroundColor,
    required this.score,
    required this.prayerPercent,
    required this.quranPercent,
    required this.dhikrPercent,
    required this.distractionPercent,
    this.detailed = false,
    this.onTap,
  });

  final Color backgroundColor;
  final int score;
  final int prayerPercent;
  final int quranPercent;
  final int dhikrPercent;
  final int distractionPercent;
  final bool detailed;
  final VoidCallback? onTap;

  /// Each star ≈ 20 points. Reference empty state shows 1 filled star.
  int get _filledStars {
    if (score <= 0) return 1;
    return (score / 20).round().clamp(1, 5);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final filledStars = _filledStars;
    final isTappable = onTap != null;

    final borderColor = colorScheme.outlineVariant.withValues(
      alpha: isDark ? 0.28 : 0.22,
    );

    final stars = Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(5, (index) {
        final isFilled = index < filledStars;
        return Padding(
          padding: EdgeInsets.only(left: index == 0 ? 0 : 1),
          child: Icon(
            isFilled ? Icons.star_rounded : Icons.star_outline_rounded,
            color: isFilled
                ? colorScheme.primary.withValues(alpha: 0.8)
                : colorScheme.outlineVariant.withValues(alpha: 0.5),
            size: 13,
          ),
        );
      }),
    );

    final content = Padding(
      padding: EdgeInsets.fromLTRB(14, 12, isTappable ? 10 : 14, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.focusScoreTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$score',
                      style: Theme.of(context).textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.primary,
                        height: 0.95,
                        fontSize: 42,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: stars,
                    ),
                  ],
                ),
                if (detailed) ...[
                  const SizedBox(height: 12),
                  _FocusProgressRow(
                    label: l10n.focusScorePrayer,
                    percent: prayerPercent,
                    accent: colorScheme.primary,
                    labelColor: colorScheme.onSurface,
                  ),
                  const SizedBox(height: 8),
                  _FocusProgressRow(
                    label: l10n.focusScoreQuran,
                    percent: quranPercent,
                    accent: colorScheme.primary,
                    labelColor: colorScheme.onSurface,
                  ),
                  const SizedBox(height: 8),
                  _FocusProgressRow(
                    label: l10n.focusScoreDhikr,
                    percent: dhikrPercent,
                    accent: colorScheme.primary,
                    labelColor: colorScheme.onSurface,
                  ),
                  const SizedBox(height: 8),
                  _FocusProgressRow(
                    label: l10n.focusScoreDistraction,
                    percent: distractionPercent,
                    accent: colorScheme.primary,
                    labelColor: colorScheme.onSurface,
                  ),
                ] else ...[
                  const SizedBox(height: 6),
                  Text(
                    l10n.focusScoreBreakdown(
                      prayerPercent,
                      quranPercent,
                      dhikrPercent,
                      distractionPercent,
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.85,
                      ),
                      fontSize: 11.5,
                      height: 1.3,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isTappable) ...[
            const SizedBox(width: 4),
            HomeCardOpenArrow(
              color: colorScheme.primary.withValues(alpha: 0.7),
            ),
          ],
        ],
      ),
    );

    final decoration = BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(18),
      border: Border.all(color: borderColor, width: 1),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.025),
          blurRadius: 10,
          offset: const Offset(0, 3),
        ),
      ],
    );

    if (!isTappable) {
      return Container(
        width: double.infinity,
        decoration: decoration,
        child: content,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: double.infinity,
          decoration: decoration,
          child: content,
        ),
      ),
    );
  }
}

class _FocusProgressRow extends StatelessWidget {
  const _FocusProgressRow({
    required this.label,
    required this.percent,
    required this.accent,
    required this.labelColor,
  });

  final String label;
  final int percent;
  final Color accent;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    final clamped = percent.clamp(0, 100) / 100.0;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: labelColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '$percent%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: labelColor.withValues(alpha: 0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: clamped),
            duration: const Duration(milliseconds: 480),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 4,
                backgroundColor: accent.withValues(alpha: 0.12),
                color: accent,
              );
            },
          ),
        ),
      ],
    );
  }
}
