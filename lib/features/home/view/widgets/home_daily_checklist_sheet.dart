import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../helpers/prayer_label_helper.dart';
import '../../model/home_models.dart';
import '../../viewmodel/home_tab_view_model.dart';

/// Opens the Daily Checklist bottom sheet, reusing [HomeTabViewModel] state.
Future<void> showDailyChecklistSheet(BuildContext context) async {
  final vm = context.read<HomeTabViewModel>();
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => ChangeNotifierProvider<HomeTabViewModel>.value(
      value: vm,
      child: const _DailyChecklistSheetContent(),
    ),
  );
}

class _DailyChecklistSheetContent extends StatelessWidget {
  const _DailyChecklistSheetContent();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final mediaQuery = MediaQuery.of(context);
    final vm = context.watch<HomeTabViewModel>();
    final completedItems = vm.dailyChecklistCompletedItems;

    Widget habit({
      required DailyChecklistItem item,
      required String title,
    }) {
      return _ChecklistItem(
        title: title,
        isCompleted: completedItems.contains(item),
        onTap: () => unawaited(vm.toggleDailyChecklistItem(item)),
      );
    }

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: mediaQuery.size.height * 0.85,
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            bottom: mediaQuery.viewInsets.bottom + 12,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.dailyChecklistTitle,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                l10n.dailyChecklistSubtitle,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    _ChecklistSectionHeader(
                      title: l10n.dailyChecklistSectionPrayer,
                    ),
                    for (final prayer in TrackablePrayer.values)
                      _ChecklistItem(
                        title: prayer.label(l10n),
                        isCompleted: vm.isChecklistPrayerCompleted(prayer),
                        onTap: () => unawaited(
                          vm.toggleChecklistTrackedPrayer(prayer),
                        ),
                      ),
                    habit(
                      item: DailyChecklistItem.tahajjud,
                      title: l10n.dailyChecklistTahajjud,
                    ),
                    _ChecklistSectionHeader(
                      title: l10n.dailyChecklistSectionQuranDhikr,
                    ),
                    habit(
                      item: DailyChecklistItem.quran,
                      title: l10n.dailyChecklistQuran,
                    ),
                    habit(
                      item: DailyChecklistItem.morningAdhkar,
                      title: l10n.dailyChecklistMorningAdhkar,
                    ),
                    habit(
                      item: DailyChecklistItem.eveningAdhkar,
                      title: l10n.dailyChecklistEveningAdhkar,
                    ),
                    habit(
                      item: DailyChecklistItem.dhikr,
                      title: l10n.dailyChecklistDhikr,
                    ),
                    habit(
                      item: DailyChecklistItem.istighfar,
                      title: l10n.dailyChecklistIstighfar,
                    ),
                    habit(
                      item: DailyChecklistItem.salawat,
                      title: l10n.dailyChecklistSalawat,
                    ),
                    _ChecklistSectionHeader(
                      title: l10n.dailyChecklistSectionGoodDeeds,
                    ),
                    habit(
                      item: DailyChecklistItem.charity,
                      title: l10n.dailyChecklistCharity,
                    ),
                    habit(
                      item: DailyChecklistItem.smileAtSomeone,
                      title: l10n.dailyChecklistSmileAtSomeone,
                    ),
                    habit(
                      item: DailyChecklistItem.familyCall,
                      title: l10n.dailyChecklistFamilyCall,
                    ),
                    _ChecklistSectionHeader(
                      title: l10n.dailyChecklistSectionDistraction,
                    ),
                    habit(
                      item: DailyChecklistItem.controlAngerSpeakKindly,
                      title: l10n.dailyChecklistControlAngerSpeakKindly,
                    ),
                    habit(
                      item: DailyChecklistItem.noSocialMediaBeforeIsha,
                      title: l10n.dailyChecklistNoSocialMediaBeforeIsha,
                    ),
                    habit(
                      item: DailyChecklistItem.noMusicToday,
                      title: l10n.dailyChecklistNoMusicToday,
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
          ),
        ),
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
      padding: const EdgeInsets.only(top: 8, bottom: 2),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: colorScheme.primary,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.4,
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
