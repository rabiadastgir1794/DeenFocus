import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/app_review_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_centered_nav_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../helpers/prayer_label_helper.dart';
import '../../model/home_models.dart';
import '../../services/achievements_service.dart';
import '../../services/level_service.dart';
import '../../viewmodel/home_tab_view_model.dart';
import 'home_calendar_screen.dart';

/// Redesigned My Insights — weekly/monthly share the same components.
class HomeInsightsScreen extends StatefulWidget {
  const HomeInsightsScreen({super.key});

  @override
  State<HomeInsightsScreen> createState() => _HomeInsightsScreenState();
}

class _HomeInsightsScreenState extends State<HomeInsightsScreen> {
  bool _weekly = true;
  bool _showingCelebration = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_playPendingCelebrations());
    });
  }

  Future<void> _playPendingCelebrations() async {
    if (!mounted || _showingCelebration) return;
    final vm = context.read<HomeTabViewModel>();
    final unlocks = vm.pendingUnlockAchievements;
    final levelUp = vm.pendingLevelUp;
    if (unlocks.isEmpty && levelUp == null) return;

    _showingCelebration = true;
    AppReviewService.setCelebrationsBlocking(true);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    for (final id in unlocks) {
      if (!mounted) return;
      await showDialog<void>(
        context: context,
        builder: (ctx) => _ProgressionCelebrationDialog(
          title: l10n.insightsAchievementUnlockedTitle,
          subtitle: AchievementsService.title(l10n, id),
          icon: _achievementIcon(id),
          colorScheme: colorScheme,
        ),
      );
    }

    if (levelUp != null && mounted) {
      final level = vm.levelProgress;
      await showDialog<void>(
        context: context,
        builder: (ctx) => _ProgressionCelebrationDialog(
          title: l10n.insightsLevelUpTitle,
          subtitle: '${l10n.insightsLevelNumber(levelUp)}\n${level.name}',
          icon: Icons.emoji_events_rounded,
          colorScheme: colorScheme,
        ),
      );
    }

    if (mounted) {
      await vm.acknowledgeProgressionCelebrations();
      _showingCelebration = false;
      AppReviewService.setCelebrationsBlocking(false);
      unawaited(vm.maybeRequestAppReview());
    } else {
      AppReviewService.setCelebrationsBlocking(false);
      _showingCelebration = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cream = isDark ? colorScheme.surface : AppColors.backgroundLight;

    return Consumer<HomeTabViewModel>(
      builder: (context, vm, _) {
        if (!_showingCelebration &&
            (vm.pendingUnlockAchievements.isNotEmpty ||
                vm.pendingLevelUp != null)) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            unawaited(_playPendingCelebrations());
          });
        }
        final done = _weekly
            ? vm.weeklyCompletionDone
            : vm.monthlyCompletionDone;
        final possible = _weekly
            ? vm.weeklyCompletionPossible
            : vm.monthlyCompletionPossible;
        final rate = possible == 0
            ? 0
            : ((done / possible) * 100).round().clamp(0, 100);

        return Scaffold(
          backgroundColor: cream,
          body: SafeArea(
            child: Column(
              children: [
                AppCenteredNavHeader(
                  title: l10n.insightsTitle,
                  backLabel: l10n.insightsBack,
                  onBack: () => Navigator.of(context).pop(),
                  trailing: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              ChangeNotifierProvider<HomeTabViewModel>.value(
                            value: vm,
                            child: const HomeCalendarScreen(),
                          ),
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.calendar_month_rounded,
                      color: colorScheme.primary,
                    ),
                  ),
                ),
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                    children: [
                      _SummaryGrid(
                        prayerStreak: vm.prayerStreak,
                        dayStreak: vm.streakDays,
                        completionDone: done,
                        completionPossible: possible,
                        completionRate: rate,
                        weekly: _weekly,
                        prayerRate: vm.prayerRatePercent,
                        l10n: l10n,
                        colorScheme: colorScheme,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      _ChartCard(
                        weekly: _weekly,
                        onPeriodChanged: (v) => setState(() => _weekly = v),
                        vm: vm,
                        l10n: l10n,
                        colorScheme: colorScheme,
                        isDark: isDark,
                        done: done,
                        possible: possible,
                      ),
                      const SizedBox(height: 16),
                      _FocusAndPrayersRow(
                        vm: vm,
                        l10n: l10n,
                        colorScheme: colorScheme,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      _StreakDetailsRow(
                        vm: vm,
                        l10n: l10n,
                        colorScheme: colorScheme,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      _ProgressionCard(
                        level: vm.levelProgress,
                        unlockedCount: vm.unlockedAchievementCount,
                        totalCount: AchievementsService.totalCount,
                        l10n: l10n,
                        colorScheme: colorScheme,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 16),
                      _AchievementsSection(
                        achievements: vm.achievements,
                        l10n: l10n,
                        colorScheme: colorScheme,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 12),
                      _CycleFooter(
                        days: vm.cycleProtectedDaysAvailable,
                        enabled: vm.cycleModeEnabled,
                        l10n: l10n,
                        colorScheme: colorScheme,
                      ),
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

class _SummaryGrid extends StatelessWidget {
  const _SummaryGrid({
    required this.prayerStreak,
    required this.dayStreak,
    required this.completionDone,
    required this.completionPossible,
    required this.completionRate,
    required this.weekly,
    required this.prayerRate,
    required this.l10n,
    required this.colorScheme,
    required this.isDark,
  });

  final int prayerStreak;
  final int dayStreak;
  final int completionDone;
  final int completionPossible;
  final int completionRate;
  final bool weekly;
  final int prayerRate;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 10,
      crossAxisSpacing: 10,
      childAspectRatio: 1.15,
      children: [
        _SummaryCard(
          icon: Icons.local_fire_department_rounded,
          value: '$prayerStreak',
          title: l10n.insightsPrayerStreak,
          subtitle: l10n.insightsPrayersInARow,
          chip: l10n.insightsChipUpToday,
          chipColor: colorScheme.primary,
          colorScheme: colorScheme,
          isDark: isDark,
        ),
        _SummaryCard(
          icon: Icons.calendar_today_rounded,
          value: '$dayStreak',
          title: l10n.insightsDayStreak,
          subtitle: l10n.insightsDaysInARow,
          chip: l10n.insightsChipDayUp,
          chipColor: colorScheme.primary,
          colorScheme: colorScheme,
          isDark: isDark,
        ),
        _SummaryCard(
          icon: Icons.show_chart_rounded,
          value: '$completionDone / $completionPossible',
          title: weekly
              ? l10n.insightsWeeklyCompletion
              : l10n.insightsMonthlyCompletion,
          subtitle: weekly ? l10n.insightsThisWeek : l10n.insightsThisMonth,
          chip: '$completionRate%',
          chipColor: const Color(0xFFE91E8C),
          colorScheme: colorScheme,
          isDark: isDark,
        ),
        _SummaryCard(
          icon: Icons.track_changes_rounded,
          value: '$prayerRate%',
          title: l10n.insightsPrayerRate,
          subtitle: l10n.insightsOverall,
          chip: _rateLabel(l10n, prayerRate),
          chipColor: colorScheme.primary,
          colorScheme: colorScheme,
          isDark: isDark,
        ),
      ],
    );
  }

  String _rateLabel(AppLocalizations l10n, int rate) {
    if (rate >= 85) return l10n.insightsRateExcellent;
    if (rate >= 60) return l10n.insightsRateGood;
    if (rate >= 30) return l10n.insightsRateFair;
    return l10n.insightsRateStart;
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.icon,
    required this.value,
    required this.title,
    required this.subtitle,
    required this.chip,
    required this.chipColor,
    required this.colorScheme,
    required this.isDark,
  });

  final IconData icon;
  final String value;
  final String title;
  final String subtitle;
  final String chip;
  final Color chipColor;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
            : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: colorScheme.primary, size: 20),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            title.toUpperCase(),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w800,
              letterSpacing: 0.3,
              fontSize: 9,
            ),
          ),
          Text(
            subtitle,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: chipColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              chip,
              style: TextStyle(
                color: chipColor,
                fontWeight: FontWeight.w700,
                fontSize: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ChartCard extends StatelessWidget {
  const _ChartCard({
    required this.weekly,
    required this.onPeriodChanged,
    required this.vm,
    required this.l10n,
    required this.colorScheme,
    required this.isDark,
    required this.done,
    required this.possible,
  });

  final bool weekly;
  final ValueChanged<bool> onPeriodChanged;
  final HomeTabViewModel vm;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool isDark;
  final int done;
  final int possible;

  @override
  Widget build(BuildContext context) {
    final dates = weekly ? vm.insightsWeekDates : const <DateTime>[];
    final weekCounts = weekly ? vm.prayerCountsForDates(dates) : const <int>[];
    final monthWeeks = weekly ? const <({String label, int completed, int possible})>[] : vm.insightsMonthWeeks;
    final maxY = weekly ? 5.0 : 40.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
            : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  (weekly
                          ? l10n.insightsPrayersCompletedWeekly
                          : l10n.insightsPrayersCompletedMonthly)
                      .toUpperCase(),
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              PopupMenuButton<bool>(
                initialValue: weekly,
                onSelected: onPeriodChanged,
                itemBuilder: (context) => [
                  PopupMenuItem(value: true, child: Text(l10n.insightsThisWeek)),
                  PopupMenuItem(value: false, child: Text(l10n.insightsThisMonth)),
                ],
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        weekly ? l10n.insightsThisWeek : l10n.insightsThisMonth,
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                      const Icon(Icons.expand_more_rounded, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 160,
            child: weekly
                ? _WeeklyBars(
                    dates: dates,
                    counts: weekCounts,
                    maxY: maxY,
                    l10n: l10n,
                    colorScheme: colorScheme,
                    isCycle: vm.isCycleHighlight,
                  )
                : _MonthlyBars(
                    weeks: monthWeeks,
                    maxY: maxY,
                    target: possible,
                    colorScheme: colorScheme,
                    l10n: l10n,
                  ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              l10n.insightsCompletionSummary(done, possible),
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WeeklyBars extends StatelessWidget {
  const _WeeklyBars({
    required this.dates,
    required this.counts,
    required this.maxY,
    required this.l10n,
    required this.colorScheme,
    required this.isCycle,
  });

  final List<DateTime> dates;
  final List<int> counts;
  final double maxY;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool Function(DateTime) isCycle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        for (var i = 0; i < dates.length; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: _Bar(
                value: counts.length > i ? counts[i].toDouble() : 0,
                maxY: maxY,
                label: DateFormat.E(l10n.localeName).format(dates[i]),
                valueLabel: '${counts.length > i ? counts[i] : 0}/5',
                color: isCycle(dates[i])
                    ? const Color(0xFFFF9EC5)
                    : ((counts.length > i ? counts[i] : 0) < 5 &&
                            counts.length > i &&
                            counts[i] > 0
                        ? colorScheme.error
                        : colorScheme.primary),
                colorScheme: colorScheme,
              ),
            ),
          ),
      ],
    );
  }
}

class _MonthlyBars extends StatelessWidget {
  const _MonthlyBars({
    required this.weeks,
    required this.maxY,
    required this.target,
    required this.colorScheme,
    required this.l10n,
  });

  final List<({String label, int completed, int possible})> weeks;
  final double maxY;
  final int target;
  final ColorScheme colorScheme;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
        final scale = weeks.isEmpty
        ? maxY
        : weeks
            .map((w) => w.completed)
            .fold<int>(target, (a, b) => a > b ? a : b)
            .toDouble()
            .clamp(1.0, 999.0);
    return Stack(
      children: [
        if (target > 0)
          Align(
            alignment: Alignment(0, 1 - (target / scale).clamp(0, 1) * 2 + 1),
            child: Divider(
              color: const Color(0xFFE91E8C).withValues(alpha: 0.5),
              thickness: 1,
            ),
          ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            for (final week in weeks)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _Bar(
                    value: week.completed.toDouble(),
                    maxY: scale,
                    label: week.label,
                    valueLabel: '${week.completed}/${week.possible}',
                    color: colorScheme.primary,
                    colorScheme: colorScheme,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _Bar extends StatelessWidget {
  const _Bar({
    required this.value,
    required this.maxY,
    required this.label,
    required this.valueLabel,
    required this.color,
    required this.colorScheme,
  });

  final double value;
  final double maxY;
  final String label;
  final String valueLabel;
  final Color color;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final fraction = maxY <= 0 ? 0.0 : (value / maxY).clamp(0.05, 1.0);
    return Column(
      children: [
        Text(
          valueLabel,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: 9,
          ),
        ),
        const SizedBox(height: 4),
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: TweenAnimationBuilder<double>(
              tween: Tween(begin: 0, end: fraction),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOutCubic,
              builder: (context, v, _) {
                return FractionallySizedBox(
                  heightFactor: v,
                  widthFactor: 1,
                  child: Container(
                    decoration: BoxDecoration(
                      color: color,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontSize: 10,
          ),
        ),
      ],
    );
  }
}

class _FocusAndPrayersRow extends StatelessWidget {
  const _FocusAndPrayersRow({
    required this.vm,
    required this.l10n,
    required this.colorScheme,
    required this.isDark,
  });

  final HomeTabViewModel vm;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: _FocusPanel(
              score: vm.todayFocusScore,
              prayer: vm.todayPrayerPercent,
              quran: vm.todayQuranPercent,
              dhikr: vm.todayDhikrPercent,
              distraction: vm.todayDistractionPercent,
              l10n: l10n,
              colorScheme: colorScheme,
              isDark: isDark,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _TodayPrayersPanel(
              vm: vm,
              l10n: l10n,
              colorScheme: colorScheme,
              isDark: isDark,
            ),
          ),
        ],
      ),
    );
  }
}

class _FocusPanel extends StatelessWidget {
  const _FocusPanel({
    required this.score,
    required this.prayer,
    required this.quran,
    required this.dhikr,
    required this.distraction,
    required this.l10n,
    required this.colorScheme,
    required this.isDark,
  });

  final int score;
  final int prayer;
  final int quran;
  final int dhikr;
  final int distraction;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final undistracted = 100 - distraction;
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(colorScheme, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.focusScoreTitle,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Center(
            child: SizedBox(
              width: 100,
              height: 60,
              child: CustomPaint(
                painter: _GaugePainter(
                  progress: score / 100,
                  color: colorScheme.primary,
                  track: colorScheme.outlineVariant.withValues(alpha: 0.35),
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 18),
                    child: Text(
                      '$score',
                      style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                        color: colorScheme.primary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            score >= 85
                ? l10n.insightsFocusExcellent
                : l10n.insightsFocusKeepGoing,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),
          _MiniBar(label: l10n.focusScorePrayer, percent: prayer, colorScheme: colorScheme),
          _MiniBar(label: l10n.focusScoreQuran, percent: quran, colorScheme: colorScheme),
          _MiniBar(label: l10n.focusScoreDhikr, percent: dhikr, colorScheme: colorScheme),
          _MiniBar(
            label: l10n.focusScoreDistraction,
            percent: undistracted,
            colorScheme: colorScheme,
          ),
        ],
      ),
    );
  }
}

class _MiniBar extends StatelessWidget {
  const _MiniBar({
    required this.label,
    required this.percent,
    required this.colorScheme,
  });

  final String label;
  final int percent;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(label, style: Theme.of(context).textTheme.labelSmall),
              ),
              Text(
                '$percent%',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: (percent.clamp(0, 100)) / 100,
              minHeight: 4,
              backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.3),
              color: colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _GaugePainter extends CustomPainter {
  _GaugePainter({
    required this.progress,
    required this.color,
    required this.track,
  });

  final double progress;
  final Color color;
  final Color track;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(4, 8, size.width - 8, size.height * 1.6);
    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 8
      ..strokeCap = StrokeCap.round;
    canvas.drawArc(rect, 3.14, 3.14, false, trackPaint);
    canvas.drawArc(rect, 3.14, 3.14 * progress.clamp(0, 1), false, fillPaint);
  }

  @override
  bool shouldRepaint(covariant _GaugePainter oldDelegate) =>
      oldDelegate.progress != progress;
}

class _TodayPrayersPanel extends StatelessWidget {
  const _TodayPrayersPanel({
    required this.vm,
    required this.l10n,
    required this.colorScheme,
    required this.isDark,
  });

  final HomeTabViewModel vm;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    final day = vm.dayFor(today);
    final isProtected = vm.isTodayCycleProtected;
    final done = day.selectedPrayers.length;
    final slots = vm.prayerTimes?.slots ?? const <HomePrayerSlot>[];
    const cyclePink = Color(0xFFFF9EC5);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(colorScheme, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.insightsTodaysPrayers,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          if (!isProtected)
            for (final prayer in TrackablePrayer.values)
              Padding(
                padding: const EdgeInsets.only(bottom: 6),
                child: Row(
                  children: [
                    Icon(
                      _iconFor(prayer),
                      size: 16,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        prayer.label(l10n),
                        style: Theme.of(context).textTheme.labelMedium,
                      ),
                    ),
                    Text(
                      _timeFor(prayer, slots, l10n),
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Icon(
                      day.selectedPrayers.contains(prayer)
                          ? Icons.check_circle_rounded
                          : Icons.circle_outlined,
                      size: 16,
                      color: day.selectedPrayers.contains(prayer)
                          ? colorScheme.primary
                          : colorScheme.outlineVariant,
                    ),
                  ],
                ),
              ),
          if (isProtected) const SizedBox(height: 8),
          const Spacer(),
          Center(
            child: isProtected
                ? Column(
                    children: [
                      Icon(
                        Icons.water_drop_outlined,
                        color: cyclePink,
                        size: 28,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        l10n.insightsCycleModeActiveLabel,
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: cyclePink,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        l10n.insightsProtectedByCycleMode,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  )
                : Column(
                    children: [
                      Text(
                        '$done / 5',
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        l10n.insightsPrayersCompletedLabel,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }

  IconData _iconFor(TrackablePrayer prayer) {
    switch (prayer) {
      case TrackablePrayer.fajr:
        return Icons.wb_twilight_rounded;
      case TrackablePrayer.dhuhr:
        return Icons.wb_sunny_rounded;
      case TrackablePrayer.asr:
        return Icons.sunny_snowing;
      case TrackablePrayer.maghrib:
        return Icons.nightlight_round;
      case TrackablePrayer.isha:
        return Icons.dark_mode_rounded;
    }
  }

  String _timeFor(
    TrackablePrayer prayer,
    List<HomePrayerSlot> slots,
    AppLocalizations l10n,
  ) {
    HomePrayerId id;
    switch (prayer) {
      case TrackablePrayer.fajr:
        id = HomePrayerId.fajr;
      case TrackablePrayer.dhuhr:
        id = HomePrayerId.dhuhr;
      case TrackablePrayer.asr:
        id = HomePrayerId.asr;
      case TrackablePrayer.maghrib:
        id = HomePrayerId.maghrib;
      case TrackablePrayer.isha:
        id = HomePrayerId.isha;
    }
    final slot = slots.where((s) => s.id == id).firstOrNull;
    if (slot == null) return '—';
    return DateFormat.jm(l10n.localeName).format(slot.time);
  }
}

class _StreakDetailsRow extends StatelessWidget {
  const _StreakDetailsRow({
    required this.vm,
    required this.l10n,
    required this.colorScheme,
    required this.isDark,
  });

  final HomeTabViewModel vm;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.local_fire_department_rounded, '${vm.prayerStreak}', l10n.insightsCurrentPrayerStreak),
      (Icons.emoji_events_rounded, '${vm.bestPrayerStreak}', l10n.insightsBestPrayerStreak),
      (Icons.calendar_today_rounded, '${vm.streakDays}', l10n.insightsCurrentDayStreak),
      (Icons.shield_moon_rounded, '${vm.cycleProtectedDaysAvailable}', l10n.insightsCycleProtectedDays),
    ];
    return Row(
      children: [
        for (var i = 0; i < items.length; i++) ...[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 6),
              decoration: _cardDecoration(colorScheme, isDark),
              child: Column(
                children: [
                  Icon(items[i].$1, color: colorScheme.primary, size: 18),
                  const SizedBox(height: 4),
                  Text(
                    items[i].$2,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  Text(
                    items[i].$3,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 9,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _ProgressionCard extends StatelessWidget {
  const _ProgressionCard({
    required this.level,
    required this.unlockedCount,
    required this.totalCount,
    required this.l10n,
    required this.colorScheme,
    required this.isDark,
  });

  final LevelProgress level;
  final int unlockedCount;
  final int totalCount;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final xpFormat = NumberFormat.decimalPattern(l10n.localeName);
    final next = level.nextLevelXP;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(colorScheme, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.insightsMyProgress.toUpperCase(),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.insightsLevelNumber(level.currentLevel),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            level.name,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            level.isMaxLevel || next == null
                ? l10n.insightsXpTotal(xpFormat.format(level.totalXP))
                : l10n.insightsXpProgress(
                    xpFormat.format(level.totalXP),
                    xpFormat.format(next),
                  ),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: level.progressPercentage,
              minHeight: 8,
              color: colorScheme.primary,
              backgroundColor: colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            level.isMaxLevel
                ? l10n.insightsMaxLevel
                : l10n.insightsXpToNext(
                    xpFormat.format(level.xpToNext),
                    level.currentLevel + 1,
                  ),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.insightsAchievements,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          Text(
            l10n.insightsAchievementsUnlocked(unlockedCount, totalCount),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementsSection extends StatelessWidget {
  const _AchievementsSection({
    required this.achievements,
    required this.l10n,
    required this.colorScheme,
    required this.isDark,
  });

  final List<AchievementProgress> achievements;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          l10n.insightsAchievements.toUpperCase(),
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w800,
          ),
        ),
        const SizedBox(height: 10),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: achievements.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 1.15,
          ),
          itemBuilder: (context, index) {
            final item = achievements[index];
            final unlocked = item.isUnlocked;
            return Container(
              padding: const EdgeInsets.fromLTRB(10, 10, 10, 8),
              decoration: _cardDecoration(colorScheme, isDark),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _achievementIcon(item.id),
                    color: unlocked
                        ? colorScheme.primary
                        : const Color(0xFFC4B8A5),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    AchievementsService.title(l10n, item.id),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  if (unlocked)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          size: 12,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          l10n.insightsAchieved,
                          style: TextStyle(
                            color: colorScheme.primary,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    )
                  else ...[
                    Text(
                      '${item.current} / ${item.target}',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 4),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: item.fraction,
                        minHeight: 4,
                        color: colorScheme.primary,
                        backgroundColor:
                            colorScheme.outlineVariant.withValues(alpha: 0.3),
                      ),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}

class _ProgressionCelebrationDialog extends StatelessWidget {
  const _ProgressionCelebrationDialog({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.colorScheme,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 40, color: colorScheme.primary),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: colorScheme.primary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context)!.ok),
        ),
      ],
    );
  }
}

IconData _achievementIcon(AchievementId id) {
  switch (id) {
    case AchievementId.firstPrayer:
      return Icons.star_rounded;
    case AchievementId.sevenPrayerStreak:
      return Icons.calendar_view_week_rounded;
    case AchievementId.thirtyPrayerStreak:
      return Icons.workspace_premium_rounded;
    case AchievementId.fajrWarrior:
    case AchievementId.fajrChampion:
      return Icons.wb_twilight_rounded;
    case AchievementId.fiveADay:
      return Icons.mosque_rounded;
    case AchievementId.perfectWeek:
      return Icons.calendar_month_rounded;
    case AchievementId.perfectMonth:
      return Icons.event_available_rounded;
    case AchievementId.quranReader:
    case AchievementId.quranDevotee:
      return Icons.menu_book_rounded;
    case AchievementId.dhikrStarter:
    case AchievementId.dhikrMaster:
      return Icons.spa_rounded;
    case AchievementId.nightWorshipper:
      return Icons.nights_stay_rounded;
    case AchievementId.masjidCompanion:
      return Icons.location_on_rounded;
    case AchievementId.distractionDefender:
    case AchievementId.cycleGuardian:
    case AchievementId.protectedMonth:
      return Icons.shield_rounded;
    case AchievementId.consistencyChampion:
      return Icons.emoji_events_rounded;
    case AchievementId.sixMonthJourney:
      return Icons.flag_rounded;
    case AchievementId.deenfocusMaster:
      return Icons.military_tech_rounded;
  }
}

class _CycleFooter extends StatelessWidget {
  const _CycleFooter({
    required this.days,
    required this.enabled,
    required this.l10n,
    required this.colorScheme,
  });

  final int days;
  final bool enabled;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Icon(Icons.shield_rounded, color: colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              enabled
                  ? l10n.insightsCycleModeFooter(days)
                  : l10n.insightsCycleModeFooterOff,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

BoxDecoration _cardDecoration(ColorScheme colorScheme, bool isDark) {
  return BoxDecoration(
    color: isDark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
        : Colors.white,
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: colorScheme.outlineVariant.withValues(alpha: 0.35),
    ),
  );
}
