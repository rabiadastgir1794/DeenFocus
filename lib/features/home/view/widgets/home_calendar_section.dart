import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../model/home_models.dart';

class HomeCalendarSection extends StatelessWidget {
  const HomeCalendarSection({
    super.key,
    required this.backgroundColor,
    required this.monthTitle,
    required this.visibleMonth,
    required this.isLoading,
    required this.weekly,
    required this.monthEvents,
    required this.weekEvents,
    required this.selectedDate,
    required this.onToggleMode,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.onDateTap,
  });

  final Color backgroundColor;
  final String monthTitle;
  final DateTime visibleMonth;
  final bool isLoading;
  final bool weekly;
  final List<HomeIslamicEvent> monthEvents;
  final List<HomeIslamicEvent> weekEvents;
  final DateTime? selectedDate;
  final ValueChanged<bool> onToggleMode;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final ValueChanged<DateTime> onDateTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);

    return Column(
      children: [
        Container(
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
            children: [
              Row(
                children: [
                  Icon(Icons.calendar_month, color: colorScheme.primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      monthTitle,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (isLoading)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: colorScheme.primary,
                        ),
                      ),
                    ),
                  IconButton(
                    onPressed: onPreviousMonth,
                    icon: Icon(Icons.chevron_left, color: colorScheme.primary),
                  ),
                  IconButton(
                    onPressed: onNextMonth,
                    icon: Icon(Icons.chevron_right, color: colorScheme.primary),
                  ),
                  SegmentedButton<bool>(
                    showSelectedIcon: false,
                    segments: [
                      ButtonSegment<bool>(
                        value: true,
                        label: Text(l10n.homeWeek),
                      ),
                      ButtonSegment<bool>(
                        value: false,
                        label: Text(l10n.homeMonth),
                      ),
                    ],
                    selected: {weekly},
                    onSelectionChanged: (selection) =>
                        onToggleMode(selection.first),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              weekly
                  ? _HomeWeeklyCalendar(
                      selectedDate: selectedDate,
                      eventDates: weekEvents
                          .map((e) => e.date)
                          .toList(growable: false),
                      onTap: onDateTap,
                    )
                  : _HomeMonthlyCalendar(
                      monthDate: visibleMonth,
                      selectedDate: selectedDate,
                      eventDates: monthEvents
                          .map((e) => e.date)
                          .toList(growable: false),
                      onTap: onDateTap,
                    ),
            ],
          ),
        ),
        if (weekEvents.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
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
                Text(
                  l10n.homeThisWeek,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                for (final event in weekEvents)
                  ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    leading: Icon(Icons.event, color: colorScheme.primary),
                    title: Text(event.title),
                    subtitle: Text(
                      DateFormat.yMMMMd(l10n.localeName).format(event.date),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

class _HomeWeeklyCalendar extends StatelessWidget {
  const _HomeWeeklyCalendar({
    required this.selectedDate,
    required this.eventDates,
    required this.onTap,
  });

  final DateTime? selectedDate;
  final List<DateTime> eventDates;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final today = DateTime.now();
    final weekStart = today.subtract(Duration(days: today.weekday % 7));

    return Row(
      children: List.generate(7, (index) {
        final date = DateTime(
          weekStart.year,
          weekStart.month,
          weekStart.day + index,
        );
        final isSelected =
            selectedDate?.year == date.year &&
            selectedDate?.month == date.month &&
            selectedDate?.day == date.day;
        final isToday =
            today.year == date.year &&
            today.month == date.month &&
            today.day == date.day;
        final hasEvent = eventDates.any(
          (d) =>
              d.year == date.year && d.month == date.month && d.day == date.day,
        );

        return Expanded(
          child: InkWell(
            onTap: () => onTap(date),
            child: Column(
              children: [
                Text(DateFormat.E().format(date).substring(0, 1)),
                const SizedBox(height: 4),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isToday || isSelected
                        ? colorScheme.primaryContainer
                        : Colors.transparent,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    '${date.day}',
                    style: TextStyle(
                      color: colorScheme.primary,
                      fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 2),
                Container(
                  width: 4,
                  height: 4,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: hasEvent ? colorScheme.primary : Colors.transparent,
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}

class _HomeMonthlyCalendar extends StatelessWidget {
  const _HomeMonthlyCalendar({
    required this.monthDate,
    required this.selectedDate,
    required this.eventDates,
    required this.onTap,
  });

  final DateTime monthDate;
  final DateTime? selectedDate;
  final List<DateTime> eventDates;
  final ValueChanged<DateTime> onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final first = DateTime(monthDate.year, monthDate.month, 1);
    final daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    final leading = first.weekday % 7;
    final today = DateTime.now();

    return Column(
      children: [
        Row(
          children: const ['S', 'M', 'T', 'W', 'T', 'F', 'S']
              .map((label) => Expanded(child: Center(child: Text(label))))
              .toList(),
        ),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: leading + daysInMonth,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            childAspectRatio: 0.9,
          ),
          itemBuilder: (context, index) {
            final day = index - leading + 1;
            if (day < 1 || day > daysInMonth) return const SizedBox.shrink();

            final date = DateTime(monthDate.year, monthDate.month, day);
            final isSelected =
                selectedDate?.year == date.year &&
                selectedDate?.month == date.month &&
                selectedDate?.day == date.day;
            final isToday =
                today.year == date.year &&
                today.month == date.month &&
                today.day == date.day;
            final hasEvent = eventDates.any(
              (d) =>
                  d.year == date.year &&
                  d.month == date.month &&
                  d.day == date.day,
            );

            return InkWell(
              onTap: () => onTap(date),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 30,
                    height: 30,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: isToday || isSelected
                          ? colorScheme.primaryContainer
                          : Colors.transparent,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '$day',
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: isToday ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Container(
                    width: 4,
                    height: 4,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: hasEvent
                          ? colorScheme.primary
                          : Colors.transparent,
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
