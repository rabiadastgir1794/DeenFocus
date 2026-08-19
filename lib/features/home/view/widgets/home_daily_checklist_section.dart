import 'package:flutter/material.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../model/home_models.dart';
import 'home_card_open_arrow.dart';

/// Compact Daily Checklist entry card for Home — actionable, cream-family.
class HomeDailyChecklistSection extends StatelessWidget {
  const HomeDailyChecklistSection({
    super.key,
    required this.backgroundColor,
    required this.completedItems,
    required this.onOpen,
  });

  final Color backgroundColor;
  final Set<DailyChecklistItem> completedItems;
  final VoidCallback onOpen;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final borderColor = colorScheme.primary.withValues(
      alpha: isDark ? 0.28 : 0.16,
    );
    final accent = colorScheme.primary;

    final total = DailyChecklistItem.values.length;
    final completed = completedItems.length.clamp(0, total);
    final progress = total == 0 ? 0.0 : completed / total;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(18),
        child: Ink(
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: borderColor, width: 1),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.03),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
          child: Row(
            children: [
              _ChecklistProgressRing(
                completed: completed,
                total: total,
                progress: progress,
                accent: accent,
                trackColor: accent.withValues(alpha: isDark ? 0.22 : 0.14),
                labelColor: colorScheme.onSurface,
              ),
              SizedBox(width: Spacing.sm + 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.dailyChecklistTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      l10n.dailyChecklistProgress(completed, total),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontSize: 12.5,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Spacing.sm),
              HomeCardOpenArrow(color: accent),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChecklistProgressRing extends StatelessWidget {
  const _ChecklistProgressRing({
    required this.completed,
    required this.total,
    required this.progress,
    required this.accent,
    required this.trackColor,
    required this.labelColor,
  });

  final int completed;
  final int total;
  final double progress;
  final Color accent;
  final Color trackColor;
  final Color labelColor;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 48,
      height: 48,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 48,
            height: 48,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 4.5,
              strokeCap: StrokeCap.round,
              backgroundColor: trackColor,
              color: accent,
            ),
          ),
          Text(
            '$completed/$total',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: labelColor,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
