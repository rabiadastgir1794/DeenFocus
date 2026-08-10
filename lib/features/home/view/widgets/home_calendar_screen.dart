import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_centered_nav_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../helpers/home_islamic_events_helper.dart';
import '../../helpers/islamic_event_catalog.dart';
import '../../model/home_models.dart';
import '../../services/hijri_date_service.dart';
import '../../viewmodel/home_tab_view_model.dart';

/// Full-screen Islamic Calendar — Hijri hero, month grid, upcoming / this week.
class HomeCalendarScreen extends StatefulWidget {
  const HomeCalendarScreen({super.key});

  @override
  State<HomeCalendarScreen> createState() => _HomeCalendarScreenState();
}

class _HomeCalendarScreenState extends State<HomeCalendarScreen> {
  bool _showUpcoming = true;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cream = isDark
        ? colorScheme.surface
        : AppColors.backgroundLight;
    final vm = context.watch<HomeTabViewModel>();

    final upcoming = HomeIslamicEventsHelper.majorUpcomingEvents(
      vm.allIslamicEvents,
    );
    final thisWeek = HomeIslamicEventsHelper.thisWeekObservances(
      DateTime.now(),
      vm.allIslamicEvents,
    );

    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: Column(
          children: [
            AppCenteredNavHeader(
              title: l10n.calendarTitle,
              backLabel: l10n.calendarBack,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 28),
                children: [
                  const _TodayDateCard(),
                  const SizedBox(height: 16),
                  _MonthlyCalendarCard(
                    visibleMonth: vm.visibleMonth,
                    onPreviousMonth: vm.goToPreviousMonth,
                    onNextMonth: vm.goToNextMonth,
                    isCycleDay: vm.isCycleHighlight,
                    cycleHighlightRevision: vm.cycleHighlightRevision,
                  ),
                  const SizedBox(height: 16),
                  _EventsSegment(
                    showUpcoming: _showUpcoming,
                    onChanged: (v) => setState(() => _showUpcoming = v),
                    l10n: l10n,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 14),
                  if (vm.isEventsLoading)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: LinearProgressIndicator(
                        minHeight: 2,
                        color: colorScheme.primary,
                        backgroundColor:
                            colorScheme.primary.withValues(alpha: 0.12),
                      ),
                    ),
                  if (_showUpcoming)
                    ..._buildUpcomingList(context, upcoming, l10n, colorScheme, isDark)
                  else
                    ..._buildThisWeek(
                      context,
                      thisWeek,
                      l10n,
                      colorScheme,
                      isDark,
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildUpcomingList(
    BuildContext context,
    List<HomeIslamicEvent> events,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    if (events.isEmpty) {
      return [
        _EmptyWeekCard(
          title: l10n.calendarNoUpcomingEvents,
          subtitle: l10n.calendarNoEventsBlessing,
          colorScheme: colorScheme,
          isDark: isDark,
        ),
      ];
    }
    return [
      for (var i = 0; i < events.length; i++) ...[
        _EventCard(event: events[i], colorScheme: colorScheme, isDark: isDark),
        if (i != events.length - 1) const SizedBox(height: 10),
      ],
    ];
  }

  List<Widget> _buildThisWeek(
    BuildContext context,
    List<HomeIslamicEvent> events,
    AppLocalizations l10n,
    ColorScheme colorScheme,
    bool isDark,
  ) {
    if (events.isEmpty) {
      return [
        _EmptyWeekCard(
          title: l10n.calendarNoEventsThisWeek,
          subtitle: l10n.calendarNoEventsBlessing,
          colorScheme: colorScheme,
          isDark: isDark,
        ),
      ];
    }
    return [
      for (var i = 0; i < events.length; i++) ...[
        _EventCard(event: events[i], colorScheme: colorScheme, isDark: isDark),
        if (i != events.length - 1) const SizedBox(height: 10),
      ],
    ];
  }

}

class _TodayDateCard extends StatefulWidget {
  const _TodayDateCard();

  @override
  State<_TodayDateCard> createState() => _TodayDateCardState();
}

class _TodayDateCardState extends State<_TodayDateCard> {
  late Map<String, dynamic> _hijri;
  MoonPhaseInfo? _moon;

  @override
  void initState() {
    super.initState();
    _hijri = HijriDateService.currentHijriLocal();
    _moon = HijriDateService.moonPhaseFromHijriDay(
      int.tryParse('${_hijri['day']}') ?? 1,
    );
    _load();
  }

  Future<void> _load() async {
    final hijri = await HijriDateService.getCurrentHijriDate();
    final moon = await HijriDateService.getTodayMoonPhase();
    if (!mounted) return;
    setState(() {
      _hijri = hijri;
      _moon = moon;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();
    final gregorian = DateFormat.yMMMMEEEEd(l10n.localeName).format(now);

    final monthNum = _hijri['month'] as int;
    final hijriDay = '${_hijri['day']}';
    final hijriMonth = localizedHijriMonth(l10n, monthNum);
    final hijriYear = '${_hijri['year']}';
    final moon = _moon;
    final phaseName = moon == null
        ? '…'
        : localizedMoonPhaseName(l10n, moon.phaseFraction);
    final illumination = moon?.illuminationPercent ?? 0;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            colorScheme.primary.withValues(alpha: 0.95),
            const Color(0xFF1B4332),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: colorScheme.primary.withValues(alpha: 0.28),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            right: -18,
            bottom: -22,
            child: Icon(
              Icons.mosque_rounded,
              size: 140,
              color: Colors.white.withValues(alpha: 0.08),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 18, 18, 18),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        l10n.calendarToday,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.75),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '$hijriDay $hijriMonth',
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '$hijriYear ${l10n.hijriYear}',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.92),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        gregorian,
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.white.withValues(alpha: 0.88),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  children: [
                    _MoonVisual(illuminationPercent: illumination),
                    const SizedBox(height: 8),
                    Text(
                      phaseName,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      l10n.calendarMoonIlluminated(illumination),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.white.withValues(alpha: 0.75),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MoonVisual extends StatelessWidget {
  const _MoonVisual({required this.illuminationPercent});

  final int illuminationPercent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            const Color(0xFFF5F0D8),
            const Color(0xFFE8D9A8).withValues(alpha: 0.85),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.white.withValues(alpha: 0.25),
            blurRadius: 12,
          ),
        ],
      ),
      child: CustomPaint(
        painter: _MoonShadePainter(
          illumination: illuminationPercent.clamp(0, 100) / 100.0,
        ),
      ),
    );
  }
}

class _MoonShadePainter extends CustomPainter {
  _MoonShadePainter({required this.illumination});

  final double illumination;

  @override
  void paint(Canvas canvas, Size size) {
    // Soft crater dots for a premium moon look.
    final paint = Paint()
      ..color = const Color(0xFFB8A878).withValues(alpha: 0.22);
    canvas.drawCircle(Offset(size.width * 0.35, size.height * 0.4), 5, paint);
    canvas.drawCircle(Offset(size.width * 0.6, size.height * 0.55), 3.5, paint);
    if (illumination < 0.95) {
      // Dim overlay for less-than-full illumination (visual cue only).
      final shade = Paint()
        ..color = const Color(0xFF1B4332).withValues(
          alpha: (1 - illumination) * 0.35,
        );
      canvas.drawCircle(
        Offset(size.width / 2, size.height / 2),
        size.width / 2,
        shade,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _MoonShadePainter oldDelegate) =>
      oldDelegate.illumination != illumination;
}

class _MonthlyCalendarCard extends StatefulWidget {
  const _MonthlyCalendarCard({
    required this.visibleMonth,
    required this.onPreviousMonth,
    required this.onNextMonth,
    required this.isCycleDay,
    required this.cycleHighlightRevision,
  });

  final DateTime visibleMonth;
  final VoidCallback onPreviousMonth;
  final VoidCallback onNextMonth;
  final bool Function(DateTime date) isCycleDay;
  final int cycleHighlightRevision;

  @override
  State<_MonthlyCalendarCard> createState() => _MonthlyCalendarCardState();
}

class _MonthlyCalendarCardState extends State<_MonthlyCalendarCard> {
  List<HijriCalendarDay> _days = const [];
  bool _refreshing = false;
  int _loadGeneration = 0;

  @override
  void initState() {
    super.initState();
    _days = HijriDateService.monthCalendarLocal(
      year: widget.visibleMonth.year,
      month: widget.visibleMonth.month,
    );
    _load();
  }

  @override
  void didUpdateWidget(covariant _MonthlyCalendarCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.visibleMonth.year != widget.visibleMonth.year ||
        oldWidget.visibleMonth.month != widget.visibleMonth.month) {
      setState(() {
        _days = HijriDateService.monthCalendarLocal(
          year: widget.visibleMonth.year,
          month: widget.visibleMonth.month,
        );
      });
      _load();
    }
  }

  Future<void> _load() async {
    final generation = ++_loadGeneration;
    final year = widget.visibleMonth.year;
    final month = widget.visibleMonth.month;
    setState(() => _refreshing = true);
    final days = await HijriDateService.getMonthCalendar(
      year: year,
      month: month,
    );
    if (!mounted || generation != _loadGeneration) return;
    setState(() {
      _days = days;
      _refreshing = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);
    final cardColor = isDark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
        : const Color(0xFFF7F5F0);

    final monthTitle =
        DateFormat.yMMMM(l10n.localeName).format(widget.visibleMonth);
    final hijriSubtitle = _hijriSubtitle(l10n);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 14, 12),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.2 : 0.04),
            blurRadius: 14,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              IconButton(
                onPressed: widget.onPreviousMonth,
                icon: Icon(Icons.chevron_left_rounded, color: colorScheme.primary),
                visualDensity: VisualDensity.compact,
              ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      monthTitle,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    if (hijriSubtitle.isNotEmpty)
                      Text(
                        hijriSubtitle,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colorScheme.primary.withValues(alpha: 0.75),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                  ],
                ),
              ),
              IconButton(
                onPressed: widget.onNextMonth,
                icon: Icon(Icons.chevron_right_rounded, color: colorScheme.primary),
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
          const SizedBox(height: 8),
          if (_refreshing)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: LinearProgressIndicator(
                minHeight: 2,
                color: colorScheme.primary.withValues(alpha: 0.65),
                backgroundColor: colorScheme.primary.withValues(alpha: 0.1),
              ),
            ),
          _MonthGrid(
            monthDate: widget.visibleMonth,
            days: _days,
            isCycleDay: widget.isCycleDay,
            cycleHighlightRevision: widget.cycleHighlightRevision,
          ),
          const SizedBox(height: 12),
          _CalendarLegend(l10n: l10n, colorScheme: colorScheme),
        ],
      ),
    );
  }

  String _hijriSubtitle(AppLocalizations l10n) {
    if (_days.isEmpty) return '';
    final first = _days.first;
    final last = _days.last;
    final startName = localizedHijriMonth(l10n, first.hijriMonth);
    if (first.hijriMonth == last.hijriMonth &&
        first.hijriYear == last.hijriYear) {
      return '$startName ${first.hijriYear} ${l10n.hijriYear}';
    }
    final endName = localizedHijriMonth(l10n, last.hijriMonth);
    if (first.hijriYear == last.hijriYear) {
      return '$startName – $endName ${first.hijriYear} ${l10n.hijriYear}';
    }
    return '$startName ${first.hijriYear} – $endName ${last.hijriYear} ${l10n.hijriYear}';
  }
}

class _MonthGrid extends StatelessWidget {
  const _MonthGrid({
    required this.monthDate,
    required this.days,
    required this.isCycleDay,
    required this.cycleHighlightRevision,
  });

  final DateTime monthDate;
  final List<HijriCalendarDay> days;
  final bool Function(DateTime date) isCycleDay;
  final int cycleHighlightRevision;

  static const _cyclePink = Color(0xFFFF9EC5);
  static const _cyclePinkBg = Color(0xFFF8D7DA);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final first = DateTime(monthDate.year, monthDate.month, 1);
    final daysInMonth = DateTime(monthDate.year, monthDate.month + 1, 0).day;
    final leading = first.weekday % 7;
    final today = DateTime.now();
    final byDay = <int, HijriCalendarDay>{
      for (final d in days)
        if (d.gregorian.month == monthDate.month) d.gregorian.day: d,
    };

    final weekLabels = List<String>.generate(7, (i) {
      // Sunday-first labels localized via a fixed Sunday reference week.
      final date = DateTime(2023, 1, 1 + i); // 2023-01-01 was Sunday
      final label = DateFormat.E(l10n.localeName).format(date);
      return label.isEmpty ? '' : label[0].toUpperCase();
    });

    return Column(
      children: [
        Row(
          children: [
            for (final label in weekLabels)
              Expanded(
                child: Center(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 6),
        GridView.builder(
          key: ValueKey(
            '${monthDate.year}-${monthDate.month}-$cycleHighlightRevision',
          ),
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: leading + daysInMonth,
          gridDelegate: const SyncedGridDelegate(),
          itemBuilder: (context, index) {
            final day = index - leading + 1;
            if (day < 1 || day > daysInMonth) {
              return const SizedBox.shrink();
            }

            final date = DateTime(monthDate.year, monthDate.month, day);
            final hijri = byDay[day];
            final isToday = today.year == date.year &&
                today.month == date.month &&
                today.day == date.day;
            final cycle = isCycleDay(date);

            Color? bg;
            Color textColor = colorScheme.onSurface;
            Color hijriColor = colorScheme.onSurfaceVariant;

            // Cycle days always use pink — including today inside the window.
            if (cycle) {
              bg = _cyclePinkBg;
              textColor = const Color(0xFFC2185B);
              hijriColor = _cyclePink;
            } else if (isToday) {
              bg = colorScheme.primary;
              textColor = colorScheme.onPrimary;
              hijriColor = colorScheme.onPrimary.withValues(alpha: 0.85);
            }

            return IgnorePointer(
              child: Container(
                margin: const EdgeInsets.all(2),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$day',
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: textColor,
                        fontWeight: FontWeight.w700,
                        height: 1.1,
                      ),
                    ),
                    Text(
                      hijri == null ? '' : '${hijri.hijriDay}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: hijriColor,
                        fontSize: 10,
                        height: 1.1,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Keeps calendar cells roughly square with room for dual date labels.
class SyncedGridDelegate extends SliverGridDelegateWithFixedCrossAxisCount {
  const SyncedGridDelegate()
      : super(
          crossAxisCount: 7,
          childAspectRatio: 0.85,
          mainAxisSpacing: 2,
          crossAxisSpacing: 2,
        );
}

class _CalendarLegend extends StatelessWidget {
  const _CalendarLegend({
    required this.l10n,
    required this.colorScheme,
  });

  final AppLocalizations l10n;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _LegendDot(color: colorScheme.primary, label: l10n.calendarToday),
        const SizedBox(width: 16),
        _LegendDot(
          color: const Color(0xFFFF9EC5),
          label: l10n.calendarLegendCycleDays,
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _EventsSegment extends StatelessWidget {
  const _EventsSegment({
    required this.showUpcoming,
    required this.onChanged,
    required this.l10n,
    required this.colorScheme,
  });

  final bool showUpcoming;
  final ValueChanged<bool> onChanged;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(3),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colorScheme.primary.withValues(alpha: 0.45)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _SegmentChip(
              selected: showUpcoming,
              icon: Icons.calendar_month_rounded,
              label: l10n.calendarUpcomingThisYear,
              onTap: () => onChanged(true),
              colorScheme: colorScheme,
            ),
          ),
          Expanded(
            child: _SegmentChip(
              selected: !showUpcoming,
              icon: Icons.star_outline_rounded,
              label: l10n.calendarThisWeekObservances,
              onTap: () => onChanged(false),
              colorScheme: colorScheme,
            ),
          ),
        ],
      ),
    );
  }
}

class _SegmentChip extends StatelessWidget {
  const _SegmentChip({
    required this.selected,
    required this.icon,
    required this.label,
    required this.onTap,
    required this.colorScheme,
  });

  final bool selected;
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? colorScheme.primary : Colors.transparent,
      borderRadius: BorderRadius.circular(11),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(11),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 11, horizontal: 6),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 15,
                color: selected ? colorScheme.onPrimary : colorScheme.primary,
              ),
              const SizedBox(width: 5),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: selected ? colorScheme.onPrimary : colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EventCard extends StatelessWidget {
  const _EventCard({
    required this.event,
    required this.colorScheme,
    required this.isDark,
  });

  final HomeIslamicEvent event;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final kind = IslamicEventCatalog.kindForTitle(event.title);
    final title = IslamicEventCatalog.displayTitle(l10n, event);
    final description = IslamicEventCatalog.displayDescription(l10n, event);
    final dateLabel = DateFormat.yMMMMd(l10n.localeName).format(event.date);
    final days = _daysUntil(event.date);
    final daysLabel = days == 0
        ? l10n.calendarToday
        : days == 1
            ? l10n.calendarTomorrow
            : l10n.calendarDaysAway(days);

    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 12, 10, 12),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.18 : 0.04),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        children: [
          _EventIcon(kind: kind, colorScheme: colorScheme),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                if (description.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
                const SizedBox(height: 4),
                Text(
                  dateLabel,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: colorScheme.primary.withValues(alpha: 0.85),
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                daysLabel,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _daysUntil(DateTime date) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final target = DateTime(date.year, date.month, date.day);
    return target.difference(today).inDays;
  }
}

class _EventIcon extends StatelessWidget {
  const _EventIcon({required this.kind, required this.colorScheme});

  final IslamicEventKind kind;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(_iconFor(kind), color: colorScheme.primary, size: 22),
    );
  }

  IconData _iconFor(IslamicEventKind kind) {
    switch (kind) {
      case IslamicEventKind.ramadanBegins:
        return Icons.nightlight_round;
      case IslamicEventKind.laylatAlQadr:
        return Icons.auto_awesome_rounded;
      case IslamicEventKind.eidAlFitr:
        return Icons.celebration_rounded;
      case IslamicEventKind.dayOfArafah:
        return Icons.landscape_rounded;
      case IslamicEventKind.eidAlAdha:
        return Icons.volunteer_activism_rounded;
      case IslamicEventKind.islamicNewYear:
        return Icons.mosque_rounded;
      case IslamicEventKind.mawlidAnNabi:
        return Icons.favorite_rounded;
      case IslamicEventKind.ashura:
        return Icons.water_drop_rounded;
      case IslamicEventKind.jumuah:
        return Icons.mosque_outlined;
      case IslamicEventKind.whiteDays:
        return Icons.brightness_3_rounded;
      case IslamicEventKind.other:
        return Icons.event_rounded;
    }
  }
}

class _EmptyWeekCard extends StatelessWidget {
  const _EmptyWeekCard({
    required this.title,
    required this.subtitle,
    required this.colorScheme,
    required this.isDark,
  });

  final String title;
  final String subtitle;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 28, 20, 28),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        children: [
          Icon(
            Icons.calendar_month_outlined,
            size: 42,
            color: colorScheme.primary.withValues(alpha: 0.7),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
