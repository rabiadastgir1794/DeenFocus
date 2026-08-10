import 'package:flutter/material.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../model/home_models.dart';
import 'home_card_open_arrow.dart';

/// Compact Daily Checklist entry card for Home.
///
/// Progress is derived from [completedItems] vs [DailyChecklistItem.values].
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
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : colorScheme.outlineVariant.withValues(alpha: 0.25);

    final total = DailyChecklistItem.values.length;
    final completed = completedItems.length.clamp(0, total);
    final progress = total == 0 ? 0.0 : completed / total;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onOpen,
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
          padding: const EdgeInsets.fromLTRB(16, 14, 14, 14),
          child: Row(
            children: [
              _ChecklistProgressRing(
                completed: completed,
                total: total,
                progress: progress,
                colorScheme: colorScheme,
              ),
              SizedBox(width: Spacing.md),
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
                    const SizedBox(height: 4),
                    Text(
                      l10n.dailyChecklistProgress(completed, total),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Spacing.sm),
              const HomeCardOpenArrow(),
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
    required this.colorScheme,
  });

  final int completed;
  final int total;
  final double progress;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 52,
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 52,
            height: 52,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 5,
              strokeCap: StrokeCap.round,
              backgroundColor:
                  colorScheme.outlineVariant.withValues(alpha: 0.35),
              color: colorScheme.primary,
            ),
          ),
          Text(
            '$completed/$total',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }
}
