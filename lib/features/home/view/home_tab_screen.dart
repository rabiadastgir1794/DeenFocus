import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/services/permission_service.dart';
import '../../../core/widgets/app_permission_dialog.dart';
import '../../../l10n/app_localizations.dart';
import '../model/home_models.dart';
import '../viewmodel/home_tab_view_model.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeTabViewModel>(
      create: (_) => HomeTabViewModel()..initialize(),
      child: const _HomeTabView(),
    );
  }
}

class _HomeTabView extends StatefulWidget {
  const _HomeTabView();

  @override
  State<_HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<_HomeTabView>
    with WidgetsBindingObserver {
  bool _locationDialogOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<HomeTabViewModel>().onAppResumed();
    }
  }

  Future<void> _showBlockingLocationDialogIfNeeded(
    BuildContext context,
    HomeTabViewModel vm,
  ) async {
    if (_locationDialogOpen || !vm.consumeLocationDialogFlag()) {
      return;
    }
    _locationDialogOpen = true;
    final l10n = AppLocalizations.of(context)!;
    await AppPermissionDialog.show(
      context,
      title: l10n.locationRequired,
      message: l10n.locationRequiredMessage,
      primaryButtonText: l10n.openSettings,
      onPrimaryTap: PermissionService.openLocationSettings,
    );
    _locationDialogOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final softCardColor = isDark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.28)
        : const Color(0xFFF3F1EB);

    return Consumer<HomeTabViewModel>(
      builder: (context, vm, _) {
        unawaited(_showBlockingLocationDialogIfNeeded(context, vm));

        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentMonth = DateFormat.yMMMM(
          l10n.localeName,
        ).format(vm.visibleMonth);

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.homeSalam,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            vm.userName,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    _CircleIconButton(
                      icon: Icons.chat_bubble_outline,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const _AiChatScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    _CircleIconButton(
                      icon: Icons.dark_mode_outlined,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                _VerseMarquee(
                  text: _verseText(l10n, vm.dailyVerse),
                  color: colorScheme.primary,
                ),
                const SizedBox(height: 14),
                _PrayerTimesSection(
                  prayerTimes: vm.prayerTimes,
                  backgroundColor: softCardColor,
                ),
                const SizedBox(height: 12),
                _ActionContainer(
                  backgroundColor: softCardColor,
                  title: vm.prayerModeActive
                      ? l10n.homePrayerModeActive
                      : l10n.homeActivatePrayerMode,
                  subtitle: vm.prayerModeActive
                      ? l10n.homeAppsBlockedSubtitle
                      : l10n.homeBlockDistractingApps,
                  icon: Icons.shield_outlined,
                  iconBackground: colorScheme.primaryContainer,
                  onTap: vm.togglePrayerMode,
                ),
                const SizedBox(height: 12),
                _ActionContainer(
                  backgroundColor: softCardColor,
                  title: l10n.homeQiblaDirection,
                  subtitle: vm.qiblaInfo == null
                      ? l10n.homeLocationMissingForQibla
                      : '${vm.qiblaInfo} ${l10n.homeToMakkah}',
                  icon: Icons.explore_outlined,
                  iconBackground: colorScheme.primaryContainer,
                  onTap: () => _openInfoScreen(
                    context,
                    l10n.homeQiblaDirection,
                    vm.qiblaInfo ?? l10n.homeLocationMissingForQibla,
                  ),
                ),
                const SizedBox(height: 12),
                _ActionContainer(
                  backgroundColor: softCardColor,
                  title: l10n.homeFindMasjid,
                  subtitle: l10n.homeSearchNearbyMosques,
                  icon: Icons.location_on_outlined,
                  iconBackground: colorScheme.tertiaryContainer,
                  onTap: () => _openInfoScreen(
                    context,
                    l10n.homeFindMasjid,
                    l10n.homeSearchNearbyMosques,
                  ),
                ),
                const SizedBox(height: 12),
                _PrayerStreakSection(
                  streakDays: vm.streakDays,
                  weekFlags: vm.weekStreakFlags,
                  backgroundColor: softCardColor,
                ),
                const SizedBox(height: 12),
                _CalendarSection(
                  backgroundColor: softCardColor,
                  monthTitle: currentMonth,
                  visibleMonth: vm.visibleMonth,
                  isLoading: vm.isEventsLoading,
                  weekly: vm.weeklyCalendar,
                  monthEvents: vm.monthEvents,
                  weekEvents: vm.weekEvents,
                  selectedDate: vm.selectedDate,
                  onToggleMode: vm.setWeeklyCalendar,
                  onPreviousMonth: vm.goToPreviousMonth,
                  onNextMonth: vm.goToNextMonth,
                  onDateTap: (date) => _onCalendarTap(context, vm, date),
                ),
                if (vm.isFriday) ...[
                  const SizedBox(height: 12),
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: colorScheme.primaryContainer,
                      borderRadius: BorderRadius.circular(18),
                    ),
                    padding: const EdgeInsets.all(14),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.homeJummahMubarak,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(l10n.homeJummahReminder),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _verseText(AppLocalizations l10n, HomeDailyVerse? verse) {
    if (verse == null) return l10n.homeDailyVerseFallback;
    return '"${verse.englishText}" — ${verse.surahName} ${verse.surahNumber}:${verse.ayahNumber}';
  }

  Future<void> _onCalendarTap(
    BuildContext context,
    HomeTabViewModel vm,
    DateTime date,
  ) async {
    vm.selectDate(date);
    final l10n = AppLocalizations.of(context)!;
    final eventOnDate = vm.eventsForDate(date);

    if (eventOnDate.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.homeNoEventsFoundForDay)));
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd(l10n.localeName).format(date),
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                for (final item in eventOnDate)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.event_outlined),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: Theme.of(ctx).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openInfoScreen(BuildContext context, String title, String subtitle) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => _SimpleInfoScreen(title: title, subtitle: subtitle),
      ),
    );
  }
}

class _CircleIconButton extends StatelessWidget {
  const _CircleIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primaryContainer,
        ),
        child: Icon(icon, size: 18, color: colorScheme.primary),
      ),
    );
  }
}

class _VerseMarquee extends StatefulWidget {
  const _VerseMarquee({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  State<_VerseMarquee> createState() => _VerseMarqueeState();
}

class _VerseMarqueeState extends State<_VerseMarquee>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      color: widget.color,
      fontWeight: FontWeight.w600,
      fontStyle: FontStyle.italic,
    );

    return SizedBox(
      height: 20,
      child: ClipRect(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final width = constraints.maxWidth;
                final painter = TextPainter(
                  text: TextSpan(text: widget.text, style: textStyle),
                  textDirection: Directionality.of(context),
                  maxLines: 1,
                )..layout();
                final textWidth = painter.width;
                final gap = 40.0;
                final trackWidth = textWidth + gap;
                final travel = trackWidth + width;
                final firstLeft = width - (_controller.value * travel);
                final secondLeft = firstLeft + trackWidth;

                return Stack(
                  children: [
                    Positioned(
                      left: firstLeft,
                      child: Text(
                        widget.text,
                        style: textStyle,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                    Positioned(
                      left: secondLeft,
                      child: Text(
                        widget.text,
                        style: textStyle,
                        maxLines: 1,
                        softWrap: false,
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }
}

class _PrayerTimesSection extends StatelessWidget {
  const _PrayerTimesSection({
    required this.prayerTimes,
    required this.backgroundColor,
  });

  final HomePrayerTimesData? prayerTimes;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.homeTodaysPrayers,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const Spacer(),
              Text(
                DateFormat.yMMMEd(l10n.localeName).format(DateTime.now()),
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(color: colorScheme.primary),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (prayerTimes == null)
            Text(l10n.homePrayerTimesUnavailable)
          else
            Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: prayerTimes!.slots
                  .map(
                    (slot) =>
                        _PrayerTile(slot: slot, prayerTimes: prayerTimes!),
                  )
                  .toList(growable: false),
            ),
          const SizedBox(height: 10),
          if (prayerTimes?.remaining != null)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.homeNextPrayerIn),
                const SizedBox(width: 6),
                Text(
                  _formatRemaining(prayerTimes!.remaining!),
                  style: TextStyle(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  String _formatRemaining(Duration value) {
    final hours = value.inHours;
    final minutes = value.inMinutes.remainder(60);
    return '${hours}h ${minutes}m';
  }
}

class _PrayerTile extends StatelessWidget {
  const _PrayerTile({required this.slot, required this.prayerTimes});

  final HomePrayerSlot slot;
  final HomePrayerTimesData prayerTimes;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final isPassed = !slot.time.isAfter(now);
    final isCurrent = prayerTimes.nextPrayer == slot.id;

    final background = isCurrent
        ? colorScheme.primary
        : isPassed
        ? colorScheme.primary.withValues(alpha: isDark ? 0.30 : 0.14)
        : isDark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.55)
        : const Color(0xFFF3F1EB);
    final textColor = isCurrent ? colorScheme.onPrimary : colorScheme.onSurface;

    return Container(
      width: 104,
      height: 76,
      clipBehavior: Clip.none,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          if (isCurrent)
            Positioned(
              top: -14,
              right: -14,
              child: Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          SizedBox.expand(
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _labelForPrayer(l10n, slot.id),
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: textColor),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat.jm(l10n.localeName).format(slot.time),
                    textAlign: TextAlign.center,
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: textColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _labelForPrayer(AppLocalizations l10n, HomePrayerId id) {
    switch (id) {
      case HomePrayerId.fajr:
        return l10n.homePrayerFajr;
      case HomePrayerId.sunrise:
        return l10n.homePrayerSunrise;
      case HomePrayerId.dhuhr:
        return l10n.homePrayerDhuhr;
      case HomePrayerId.asr:
        return l10n.homePrayerAsr;
      case HomePrayerId.maghrib:
        return l10n.homePrayerMaghrib;
      case HomePrayerId.isha:
        return l10n.homePrayerIsha;
    }
  }
}

class _ActionContainer extends StatelessWidget {
  const _ActionContainer({
    required this.backgroundColor,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.iconBackground,
    required this.onTap,
  });

  final Color backgroundColor;
  final String title;
  final String subtitle;
  final IconData icon;
  final Color iconBackground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: iconBackground,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: colorScheme.primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.titleSmall),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: colorScheme.onSurfaceVariant),
          ],
        ),
      ),
    );
  }
}

class _PrayerStreakSection extends StatelessWidget {
  const _PrayerStreakSection({
    required this.streakDays,
    required this.weekFlags,
    required this.backgroundColor,
  });

  final int streakDays;
  final List<bool> weekFlags;
  final Color backgroundColor;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.homePrayerStreak,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(width: 8),
              if (streakDays > 3)
                Text(
                  '🔥 $streakDays ${l10n.homeDays}',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 6),
          Text(
            '$streakDays ${l10n.homeDays}',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(7, (index) {
              final done = weekFlags[index];
              final baseHeight = 18.0 + (index * 4);
              final height = done ? baseHeight : 12.0;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 2),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        height: height,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: done
                              ? colorScheme.primary
                              : colorScheme.outlineVariant.withValues(
                                  alpha: isDark ? 0.6 : 0.35,
                                ),
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        const ['M', 'T', 'W', 'T', 'F', 'S', 'S'][index],
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }
}

class _CalendarSection extends StatelessWidget {
  const _CalendarSection({
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

    return Column(
      children: [
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(20),
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
                  ? _WeeklyCalendar(
                      selectedDate: selectedDate,
                      eventDates: weekEvents
                          .map((e) => e.date)
                          .toList(growable: false),
                      onTap: onDateTap,
                    )
                  : _MonthlyCalendar(
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

class _WeeklyCalendar extends StatelessWidget {
  const _WeeklyCalendar({
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
                      color: isToday || isSelected
                          ? colorScheme.primary
                          : colorScheme.primary,
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

class _MonthlyCalendar extends StatelessWidget {
  const _MonthlyCalendar({
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
                        color: isToday || isSelected
                            ? colorScheme.primary
                            : colorScheme.primary,
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

class _AiChatScreen extends StatelessWidget {
  const _AiChatScreen();

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return _SimpleInfoScreen(
      title: l10n.featureAiAssistant,
      subtitle: l10n.homeAiChatDescription,
    );
  }
}

class _SimpleInfoScreen extends StatelessWidget {
  const _SimpleInfoScreen({required this.title, required this.subtitle});

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Text(subtitle, textAlign: TextAlign.center),
        ),
      ),
    );
  }
}
