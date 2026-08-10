import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import 'home_card_open_arrow.dart';

/// Today's Focus Score — score, stars, and category percentages stay in sync.
///
/// Pass [detailed] for Insights progress bars; Home uses the compact breakdown.
/// When [onTap] is set, the card is tappable and shows [HomeCardOpenArrow].
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
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : colorScheme.outlineVariant.withValues(alpha: 0.25);
    final filledStars = _filledStars;
    final isTappable = onTap != null;

    final content = Padding(
      padding: EdgeInsets.fromLTRB(16, 16, isTappable ? 14 : 16, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        l10n.focusScoreTitle,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: List<Widget>.generate(5, (index) {
                        final isFilled = index < filledStars;
                        return Padding(
                          padding: const EdgeInsets.only(left: 2),
                          child: Icon(
                            isFilled
                                ? Icons.star_rounded
                                : Icons.star_outline_rounded,
                            color: isFilled
                                ? colorScheme.primary
                                : colorScheme.outlineVariant,
                            size: 18,
                          ),
                        );
                      }),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  '$score',
                  style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: colorScheme.primary,
                    height: 1,
                    fontSize: 48,
                  ),
                ),
                if (detailed) ...[
                  const SizedBox(height: 14),
                  _FocusProgressRow(
                    label: l10n.focusScorePrayer,
                    percent: prayerPercent,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 10),
                  _FocusProgressRow(
                    label: l10n.focusScoreQuran,
                    percent: quranPercent,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 10),
                  _FocusProgressRow(
                    label: l10n.focusScoreDhikr,
                    percent: dhikrPercent,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 10),
                  _FocusProgressRow(
                    label: l10n.focusScoreDistraction,
                    percent: distractionPercent,
                    colorScheme: colorScheme,
                  ),
                ] else ...[
                  const SizedBox(height: 10),
                  Text(
                    l10n.focusScoreBreakdown(
                      prayerPercent,
                      quranPercent,
                      dhikrPercent,
                      distractionPercent,
                    ),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (isTappable) ...[
            const SizedBox(width: 8),
            const HomeCardOpenArrow(),
          ],
        ],
      ),
    );

    if (!isTappable) {
      return Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: borderColor, width: 1.1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.07),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: content,
      );
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: borderColor, width: 1.1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.07),
                blurRadius: 18,
                offset: const Offset(0, 8),
              ),
            ],
          ),
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
    required this.colorScheme,
  });

  final String label;
  final int percent;
  final ColorScheme colorScheme;

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
                  color: colorScheme.onSurface,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Text(
              '$percent%',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: TweenAnimationBuilder<double>(
            tween: Tween(begin: 0, end: clamped),
            duration: const Duration(milliseconds: 480),
            curve: Curves.easeOutCubic,
            builder: (context, value, _) {
              return LinearProgressIndicator(
                value: value,
                minHeight: 5,
                backgroundColor:
                    colorScheme.outlineVariant.withValues(alpha: 0.35),
                color: colorScheme.primary,
              );
            },
          ),
        ),
      ],
    );
  }
}
