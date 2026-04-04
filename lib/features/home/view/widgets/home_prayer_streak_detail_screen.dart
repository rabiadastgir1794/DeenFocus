import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/widgets/widgets.dart';
import '../../model/home_models.dart';
import '../../viewmodel/home_tab_view_model.dart';

class HomePrayerStreakDetailScreen extends StatelessWidget {
  const HomePrayerStreakDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<HomeTabViewModel>(
      builder: (context, vm, _) {
        final colorScheme = Theme.of(context).colorScheme;
        final isDark = Theme.of(context).brightness == Brightness.dark;
        final days = vm.currentWeekDates;

        return Scaffold(
          appBar: const CustomAppBar(title: 'Prayer Streak'),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: isDark
                    ? <Color>[
                        colorScheme.surface,
                        colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.96,
                        ),
                      ]
                    : const <Color>[Color(0xFFFBF7EF), Color(0xFFF2EADB)],
              ),
            ),
            child: SafeArea(
              top: false,
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 24),
                children: [
                  Text(
                    '🔥 ${vm.streakDays} Days',
                    style: Theme.of(context).textTheme.displaySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: isDark
                          ? colorScheme.surfaceContainer.withValues(alpha: 0.9)
                          : Colors.white.withValues(alpha: 0.82),
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.45,
                        ),
                      ),
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
                          'This Week',
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
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

    return Container(
      padding: const EdgeInsets.all(4),
      decoration: editable
          ? BoxDecoration(
              color: colorScheme.primaryFixedDim.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(8),
            )
          : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  vm.weekdayLabel(date),
                  style: Theme.of(
                    context,
                  ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 3),
                Icon(
                  editable
                      ? Icons.edit_calendar_rounded
                      : Icons.lock_outline_rounded,
                  size: 16,
                  color: editable
                      ? colorScheme.primary
                      : colorScheme.onSurfaceVariant,
                ),
              ],
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
                  const SizedBox(width: 8),
              ],
            ],
          ),
        ],
      ),
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

    return InkWell(
      onTap: enabled ? () => vm.togglePrayerForDay(date, prayer) : null,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        width: 42,
        height: 44,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected
              ? colorScheme.primary.withValues(alpha: 0.16)
              : colorScheme.primary.withValues(alpha: 0.08),
          border: Border.all(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.22)
                : colorScheme.primary.withValues(alpha: 0.12),
          ),
        ),
        child: Opacity(
          opacity: enabled ? 1 : 0.55,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 32,
                height: 32,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.primary.withValues(alpha: 0.22),
                ),
                child: Text(
                  _labelForPrayer(prayer),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: selected
                        ? Colors.white
                        : colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              const SizedBox(height: 6),
            ],
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
