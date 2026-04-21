import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/custom_app_bar.dart';
import '../../../../l10n/app_localizations.dart';
import '../../model/home_models.dart';
import '../../viewmodel/home_tab_view_model.dart';

class HomePrayerStreakDetailScreen extends StatelessWidget {
  const HomePrayerStreakDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeTabViewModel>(
      builder: (context, vm, _) {
        final l10n = AppLocalizations.of(context)!;
        final colorScheme = Theme.of(context).colorScheme;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final days = vm.currentWeekDates;

        final borderColor = isDark
            ? colorScheme.outlineVariant.withValues(alpha: 0.35)
            : AppColors.outlineVariantLight.withValues(alpha: 0.35);
        final backgroundColor = colorScheme.surfaceContainerHighest.withValues(
          alpha: 0.20,
        );

        return Scaffold(
          appBar: CustomAppBar(
            title: l10n.homePrayerStreak,
            onBack: () => Navigator.of(context).pop(),
          ),
          body: SafeArea(
            bottom: false,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              children: [
                Text(
                  '🔥 ${vm.streakDays} ${vm.streakDays == 1 ? l10n.homeDay : l10n.homeDays}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: backgroundColor,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: borderColor),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(
                          alpha: isDark ? 0.22 : 0.05,
                        ),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.homeThisWeek,
                        style: Theme.of(context).textTheme.labelSmall
                            ?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                      const SizedBox(height: 16),
                      for (var index = 0; index < days.length; index++) ...[
                        _PrayerWeekRow(date: days[index]),
                        if (index != days.length - 1)
                          const SizedBox(height: 12),
                      ],
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _PrayerWeekRow extends StatelessWidget {
  const _PrayerWeekRow({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<HomeTabViewModel>();
    final day = vm.dayFor(date);
    final editable = vm.isPrayerDayEditable(date);
    final colorScheme = Theme.of(context).colorScheme;
    final isCompleted = day.isCompleted;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Text(
            vm.weekdayLabel(date),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
              color: isCompleted
                  ? colorScheme.onSurface
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final prayer in TrackablePrayer.values) ...[
              _PrayerToggleChip(
                date: date,
                prayer: prayer,
                selected: day.selectedPrayers.contains(prayer),
                enabled: editable,
              ),
              if (prayer != TrackablePrayer.values.last)
                const SizedBox(width: 6),
            ],
          ],
        ),
      ],
    );
  }
}

class _PrayerToggleChip extends StatelessWidget {
  const _PrayerToggleChip({
    required this.date,
    required this.prayer,
    required this.selected,
    required this.enabled,
  });

  final DateTime date;
  final TrackablePrayer prayer;
  final bool selected;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final vm = context.read<HomeTabViewModel>();
    final colorScheme = Theme.of(context).colorScheme;
    final backgroundColor = selected
        ? colorScheme.primary.withValues(alpha: 0.24)
        : colorScheme.primary.withValues(alpha: 0.10);

    return InkWell(
      onTap: enabled ? () => vm.togglePrayerForDay(date, prayer) : null,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: backgroundColor,
          border: Border.all(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.34)
                : colorScheme.primary.withValues(alpha: 0.12),
          ),
        ),
        child: Opacity(
          opacity: enabled ? 1 : 0.55,
          child: Center(
            child: Text(
              _labelForPrayer(prayer),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: selected
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _labelForPrayer(TrackablePrayer prayer) {
    switch (prayer) {
      case TrackablePrayer.fajr:
        return 'F';
      case TrackablePrayer.dhuhr:
        return 'D';
      case TrackablePrayer.asr:
        return 'A';
      case TrackablePrayer.maghrib:
        return 'M';
      case TrackablePrayer.isha:
        return 'I';
    }
  }
}
