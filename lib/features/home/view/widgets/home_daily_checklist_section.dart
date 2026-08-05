import 'package:flutter/material.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../model/home_models.dart';

/// Daily Checklist section showing trackable daily habits inside a card.
class HomeDailyChecklistSection extends StatelessWidget {
  const HomeDailyChecklistSection({
    super.key,
    required this.backgroundColor,
    required this.completedItems,
    required this.onToggleItem,
  });

  final Color backgroundColor;
  final Set<DailyChecklistItem> completedItems;
  final ValueChanged<DailyChecklistItem> onToggleItem;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : colorScheme.outlineVariant.withValues(alpha: 0.25);

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
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.checklist_rounded,
                size: 20,
                color: colorScheme.primary,
              ),
              SizedBox(width: Spacing.sm),
              Text(
                l10n.dailyChecklistTitle,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _ChecklistSectionHeader(title: l10n.dailyChecklistSectionPrayer),
          _ChecklistItem(
            title: l10n.dailyChecklistFajr,
            isCompleted: completedItems.contains(DailyChecklistItem.fajr),
            onTap: () => onToggleItem(DailyChecklistItem.fajr),
          ),
          _ChecklistItem(
            title: l10n.dailyChecklistTahajjud,
            isCompleted: completedItems.contains(DailyChecklistItem.tahajjud),
            onTap: () => onToggleItem(DailyChecklistItem.tahajjud),
          ),
          _ChecklistSectionHeader(title: l10n.dailyChecklistSectionQuranDhikr),
          _ChecklistItem(
            title: l10n.dailyChecklistQuran,
            isCompleted: completedItems.contains(DailyChecklistItem.quran),
            onTap: () => onToggleItem(DailyChecklistItem.quran),
          ),
          _ChecklistItem(
            title: l10n.dailyChecklistMorningAdhkar,
            isCompleted:
                completedItems.contains(DailyChecklistItem.morningAdhkar),
            onTap: () => onToggleItem(DailyChecklistItem.morningAdhkar),
          ),
          _ChecklistItem(
            title: l10n.dailyChecklistEveningAdhkar,
            isCompleted:
                completedItems.contains(DailyChecklistItem.eveningAdhkar),
            onTap: () => onToggleItem(DailyChecklistItem.eveningAdhkar),
          ),
          _ChecklistItem(
            title: l10n.dailyChecklistDhikr,
            isCompleted: completedItems.contains(DailyChecklistItem.dhikr),
            onTap: () => onToggleItem(DailyChecklistItem.dhikr),
          ),
          _ChecklistSectionHeader(title: l10n.dailyChecklistSectionGoodDeeds),
          _ChecklistItem(
            title: l10n.dailyChecklistCharity,
            isCompleted: completedItems.contains(DailyChecklistItem.charity),
            onTap: () => onToggleItem(DailyChecklistItem.charity),
          ),
          _ChecklistItem(
            title: l10n.dailyChecklistSmileAtSomeone,
            isCompleted:
                completedItems.contains(DailyChecklistItem.smileAtSomeone),
            onTap: () => onToggleItem(DailyChecklistItem.smileAtSomeone),
          ),
          _ChecklistItem(
            title: l10n.dailyChecklistFamilyCall,
            isCompleted: completedItems.contains(DailyChecklistItem.familyCall),
            onTap: () => onToggleItem(DailyChecklistItem.familyCall),
          ),
          _ChecklistSectionHeader(
            title: l10n.dailyChecklistSectionDistraction,
          ),
          _ChecklistItem(
            title: l10n.dailyChecklistNoMusicToday,
            isCompleted:
                completedItems.contains(DailyChecklistItem.noMusicToday),
            onTap: () => onToggleItem(DailyChecklistItem.noMusicToday),
          ),
          _ChecklistItem(
            title: l10n.dailyChecklistNoSocialMediaBeforeIsha,
            isCompleted: completedItems
                .contains(DailyChecklistItem.noSocialMediaBeforeIsha),
            onTap: () =>
                onToggleItem(DailyChecklistItem.noSocialMediaBeforeIsha),
          ),
        ],
      ),
    );
  }
}

class _ChecklistSectionHeader extends StatelessWidget {
  const _ChecklistSectionHeader({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 2),
      child: Text(
        title,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _ChecklistItem extends StatelessWidget {
  const _ChecklistItem({
    required this.title,
    required this.isCompleted,
    required this.onTap,
  });

  final String title;
  final bool isCompleted;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isCompleted
                      ? colorScheme.primary
                      : colorScheme.outlineVariant,
                  width: 1.8,
                ),
                color: isCompleted ? colorScheme.primary : Colors.transparent,
              ),
              child: isCompleted
                  ? Icon(
                      Icons.check,
                      size: 14,
                      color: colorScheme.onPrimary,
                    )
                  : null,
            ),
            SizedBox(width: Spacing.md),
            Expanded(
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  decoration: isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: isCompleted
                      ? colorScheme.onSurfaceVariant
                      : colorScheme.onSurface,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
