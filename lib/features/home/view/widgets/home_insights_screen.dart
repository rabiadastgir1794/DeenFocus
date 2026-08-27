import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/app_review_service.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_centered_nav_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../helpers/achievement_icon.dart';
import '../../helpers/prayer_label_helper.dart';
import '../../model/home_models.dart';
import '../../services/achievements_service.dart';
import '../../services/level_service.dart';
import '../../viewmodel/digital_balance_view_model.dart';
import '../../viewmodel/home_tab_view_model.dart';
import 'home_achievements_screen.dart';
import 'home_calendar_screen.dart';
import 'home_digital_balance_card.dart';
import 'home_digital_balance_screen.dart';

/// Redesigned My Insights — weekly/monthly share the same components.
class HomeInsightsScreen extends StatefulWidget {
  const HomeInsightsScreen({super.key});

  @override
  State<HomeInsightsScreen> createState() => _HomeInsightsScreenState();
}

class _HomeInsightsScreenState extends State<HomeInsightsScreen> {
  bool _weekly = true;
  bool _showingCelebration = false;
  DigitalBalanceViewModel? _digitalBalance;

  static bool get _showDigitalBalance =>
      DigitalBalanceInsightsCard.visibleOnThisPlatform;

  @override
  void initState() {
    super.initState();
    if (_showDigitalBalance) {
      _digitalBalance = DigitalBalanceViewModel()..attach();
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_playPendingCelebrations());
    });
  }

  @override
  void dispose() {
    _digitalBalance?.dispose();
    super.dispose();
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
          icon: achievementIcon(id),
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
          subtitle:
              '${l10n.insightsLevelNumber(levelUp)}\n${LevelService.localizedName(l10n, level.currentLevel)}',
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

    final insights = Consumer<HomeTabViewModel>(
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
                    tooltip: l10n.quickActionsCalendar,
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
                      _StreakSummaryCard(
                        prayerStreak: vm.prayerStreak,
                        bestStreak: vm.bestPrayerStreak,
                        dayStreak: vm.streakDays,
                        cycleDays: vm.cycleProtectedDaysAvailable,
                        prayerDeltaToday: vm.insightsPrayerStreakDeltaToday,
                        dayStreakGrewToday: vm.insightsDayStreakGrewToday,
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
                        completionRate: rate,
                        prayerRate: vm.prayerRatePercent,
                      ),
                      const SizedBox(height: 16),
                      _FocusAndPrayersRow(
                        vm: vm,
                        l10n: l10n,
                        colorScheme: colorScheme,
                        isDark: isDark,
                      ),
                      if (_showDigitalBalance) ...[
                        const SizedBox(height: 16),
                        DigitalBalanceInsightsCard(
                          onOpen: () {
                            final balance = _digitalBalance;
                            if (balance == null) return;
                            unawaited(balance.refresh());
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) =>
                                    ChangeNotifierProvider<
                                      DigitalBalanceViewModel
                                    >.value(
                                      value: balance,
                                      child: const HomeDigitalBalanceScreen(),
                                    ),
                              ),
                            );
                          },
                        ),
                      ],
                      const SizedBox(height: 16),
                      _ProgressionCard(
                        level: vm.levelProgress,
                        unlockedCount: vm.unlockedAchievementCount,
                        totalCount: AchievementsService.totalCount,
                        l10n: l10n,
                        colorScheme: colorScheme,
                        isDark: isDark,
                        onOpenAchievements: () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  ChangeNotifierProvider<
                                    HomeTabViewModel
                                  >.value(
                                    value: vm,
                                    child: const HomeAchievementsScreen(),
                                  ),
                            ),
                          );
                        },
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

    final balance = _digitalBalance;
    if (balance == null) return insights;
    return ChangeNotifierProvider<DigitalBalanceViewModel>.value(
      value: balance,
      child: insights,
    );
  }
}

class _StreakSummaryCard extends StatelessWidget {
  const _StreakSummaryCard({
    required this.prayerStreak,
    required this.bestStreak,
    required this.dayStreak,
    required this.cycleDays,
    required this.prayerDeltaToday,
    required this.dayStreakGrewToday,
    required this.l10n,
    required this.colorScheme,
    required this.isDark,
  });

  final int prayerStreak;
  final int bestStreak;
  final int dayStreak;
  final int cycleDays;
  final int? prayerDeltaToday;
  final bool dayStreakGrewToday;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final stats = [
      _StreakStat(
        icon: Icons.local_fire_department_outlined,
        value: '$prayerStreak',
        label: l10n.insightsPrayerStreak,
        chip: prayerDeltaToday == null
            ? null
            : l10n.insightsChipUpToday(prayerDeltaToday!),
        colorScheme: colorScheme,
        isDark: isDark,
      ),
      _StreakStat(
        icon: Icons.emoji_events_outlined,
        value: '$bestStreak',
        label: l10n.insightsBestStreak,
        caption: l10n.insightsPrayersInARow,
        colorScheme: colorScheme,
        isDark: isDark,
      ),
      _StreakStat(
        icon: Icons.calendar_today_outlined,
        value: '$dayStreak',
        label: l10n.insightsDayStreak,
        chip: dayStreakGrewToday ? l10n.insightsChipDayUp : null,
        colorScheme: colorScheme,
        isDark: isDark,
      ),
      _StreakStat(
        icon: Icons.gpp_good_outlined,
        value: '$cycleDays',
        label: l10n.insightsCycleProtectedDays,
        colorScheme: colorScheme,
        isDark: isDark,
      ),
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(6, 16, 6, 16),
      decoration: _cardDecoration(colorScheme, isDark).copyWith(
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < stats.length; i++) ...[
              if (i > 0)
                Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  color: colorScheme.outlineVariant,
                ),
              Expanded(child: stats[i]),
            ],
          ],
        ),
      ),
    );
  }
}

class _StreakStat extends StatelessWidget {
  const _StreakStat({
    required this.icon,
    required this.value,
    required this.label,
    required this.colorScheme,
    required this.isDark,
    this.caption,
    this.chip,
  });

  final IconData icon;
  final String value;
  final String label;
  final ColorScheme colorScheme;
  final bool isDark;
  final String? caption;
  final String? chip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: colorScheme.primary, size: 22),
          const SizedBox(height: 8),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.visible,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              fontWeight: FontWeight.w600,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          if (chip != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _mintFill(colorScheme, isDark),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                chip!,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            )
          else if (caption != null)
            Text(
              caption!,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.visible,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w500,
                height: 1.2,
              ),
            )
          else
            const SizedBox(height: 22),
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
    required this.completionRate,
    required this.prayerRate,
  });

  final bool weekly;
  final ValueChanged<bool> onPeriodChanged;
  final HomeTabViewModel vm;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool isDark;
  final int done;
  final int possible;
  final int completionRate;
  final int prayerRate;

  @override
  Widget build(BuildContext context) {
    final dates = weekly ? vm.insightsWeekDates : const <DateTime>[];
    final weekCounts = weekly ? vm.prayerCountsForDates(dates) : const <int>[];
    final monthWeeks = weekly
        ? const <({String label, int completed, int possible})>[]
        : vm.insightsMonthWeeks;
    final maxY = weekly ? 5.0 : 40.0;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: _cardDecoration(colorScheme, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              PopupMenuButton<bool>(
                initialValue: weekly,
                onSelected: onPeriodChanged,
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: true,
                    child: Text(l10n.insightsThisWeek),
                  ),
                  PopupMenuItem(
                    value: false,
                    child: Text(l10n.insightsThisMonth),
                  ),
                ],
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      weekly ? l10n.insightsThisWeek : l10n.insightsThisMonth,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Icon(
                      Icons.expand_more_rounded,
                      size: 20,
                      color: colorScheme.onSurface,
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Text(
                l10n.insightsRatio(done, possible),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E8C).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  l10n.insightsPercent(completionRate),
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: const Color(0xFFE91E8C),
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
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
                Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  color: colorScheme.outlineVariant,
                ),
                const SizedBox(width: 8),
                _PrayerRatePanel(
                  rate: prayerRate,
                  l10n: l10n,
                  colorScheme: colorScheme,
                  isDark: isDark,
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: _mintFill(colorScheme, isDark),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.auto_awesome_rounded,
                  size: 18,
                  color: colorScheme.primary,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.insightsCompletionSummary(done, possible),
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w600,
                      height: 1.35,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _PrayerRatePanel extends StatelessWidget {
  const _PrayerRatePanel({
    required this.rate,
    required this.l10n,
    required this.colorScheme,
    required this.isDark,
  });

  final int rate;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 88,
      child: Column(
        children: [
          Text(
            l10n.insightsPrayerRate,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          SizedBox(
            width: 64,
            height: 64,
            child: Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(
                  child: CircularProgressIndicator(
                    value: (rate.clamp(0, 100)) / 100,
                    strokeWidth: 7,
                    strokeCap: StrokeCap.round,
                    backgroundColor: colorScheme.outlineVariant.withValues(
                      alpha: 0.35,
                    ),
                    color: colorScheme.primary,
                  ),
                ),
                Text(
                  l10n.insightsPercent(rate),
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.insightsOverall,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: _mintFill(colorScheme, isDark),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              l10n.insightsRateStart,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.primary,
                fontWeight: FontWeight.w700,
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
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < dates.length; i++)
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 3),
              child: _Bar(
                value: counts.length > i ? counts[i].toDouble() : 0,
                maxY: maxY,
                label: DateFormat.E(l10n.localeName).format(dates[i]),
                valueLabel: l10n.insightsCompactRatio(
                  counts.length > i ? counts[i] : 0,
                  5,
                ),
                color: _weeklyBarColor(
                  count: counts.length > i ? counts[i] : 0,
                  isCycle: isCycle(dates[i]),
                  colorScheme: colorScheme,
                ),
                colorScheme: colorScheme,
              ),
            ),
          ),
      ],
    );
  }
}

Color _weeklyBarColor({
  required int count,
  required bool isCycle,
  required ColorScheme colorScheme,
}) {
  if (isCycle) return const Color(0xFFFF9EC5);
  if (count <= 0) {
    return colorScheme.outlineVariant.withValues(alpha: 0.7);
  }
  return colorScheme.primary;
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
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            for (var i = 0; i < weeks.length; i++)
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: _Bar(
                    value: weeks[i].completed.toDouble(),
                    maxY: scale,
                    label: l10n.insightsWeekNumber(i + 1),
                    valueLabel: l10n.insightsCompactRatio(
                      weeks[i].completed,
                      weeks[i].possible,
                    ),
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
        SizedBox(
          height: 14,
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              valueLabel,
              maxLines: 1,
              softWrap: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 9,
              ),
            ),
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
        const SizedBox(height: 8),
        SizedBox(
          height: 16,
          width: double.infinity,
          child: FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(
              label,
              maxLines: 1,
              softWrap: false,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
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
    required this.l10n,
    required this.colorScheme,
    required this.isDark,
  });

  final int score;
  final int prayer;
  final int quran;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDecoration(colorScheme, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.focusScoreTitle,
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
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
                      l10n.insightsFocusScoreValue(score),
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
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
            style: Theme.of(
              context,
            ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 8),
          _MiniBar(
            label: l10n.focusScorePrayer,
            percent: prayer,
            colorScheme: colorScheme,
            l10n: l10n,
          ),
          _MiniBar(
            label: l10n.focusScoreQuran,
            percent: quran,
            colorScheme: colorScheme,
            l10n: l10n,
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
    required this.l10n,
  });

  final String label;
  final int percent;
  final ColorScheme colorScheme;
  final AppLocalizations l10n;

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
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              Text(
                l10n.insightsPercent(percent),
                style: Theme.of(
                  context,
                ).textTheme.labelSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 3),
          ClipRRect(
            borderRadius: BorderRadius.circular(3),
            child: LinearProgressIndicator(
              value: (percent.clamp(0, 100)) / 100,
              minHeight: 4,
              backgroundColor: colorScheme.outlineVariant.withValues(
                alpha: 0.3,
              ),
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
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w800),
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
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
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
                        l10n.insightsRatio(done, 5),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(
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

class _ProgressionCard extends StatelessWidget {
  const _ProgressionCard({
    required this.level,
    required this.unlockedCount,
    required this.totalCount,
    required this.l10n,
    required this.colorScheme,
    required this.isDark,
    required this.onOpenAchievements,
  });

  final LevelProgress level;
  final int unlockedCount;
  final int totalCount;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool isDark;
  final VoidCallback onOpenAchievements;

  @override
  Widget build(BuildContext context) {
    final xpFormat = NumberFormat.decimalPattern(l10n.localeName);
    final next = level.nextLevelXP;
    final xpLabel = level.isMaxLevel || next == null
        ? l10n.insightsXpTotal(xpFormat.format(level.totalXP))
        : l10n.insightsXpProgress(
            xpFormat.format(level.progressXP),
            xpFormat.format(level.xpSpan),
          );
    final xpHint = level.isMaxLevel
        ? l10n.insightsMaxLevel
        : l10n.insightsXpToNext(
            xpFormat.format(level.xpToNext),
            level.currentLevel + 1,
          );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
      decoration: _cardDecoration(colorScheme, isDark).copyWith(
        boxShadow: isDark
            ? null
            : [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.insightsMyProgress,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 14),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _ProgressBadge(
                        icon: Icons.auto_graph_rounded,
                        colorScheme: colorScheme,
                        isDark: isDark,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              l10n.insightsLevelNumber(level.currentLevel),
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(fontWeight: FontWeight.w800),
                            ),
                            Text(
                              LevelService.localizedName(
                                l10n,
                                level.currentLevel,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              xpLabel,
                              style: Theme.of(context).textTheme.labelMedium
                                  ?.copyWith(fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 6),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: level.progressPercentage,
                                minHeight: 7,
                                color: colorScheme.primary,
                                backgroundColor: colorScheme.outlineVariant
                                    .withValues(alpha: 0.3),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              xpHint,
                              style: Theme.of(context).textTheme.labelSmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant,
                                    fontWeight: FontWeight.w600,
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 1,
                  margin: const EdgeInsets.symmetric(
                    vertical: 4,
                    horizontal: 12,
                  ),
                  color: colorScheme.outlineVariant.withValues(alpha: 0.7),
                ),
                Expanded(
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: onOpenAchievements,
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8, 4, 0, 4),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _ProgressBadge(
                                    icon: Icons.emoji_events_rounded,
                                    colorScheme: colorScheme,
                                    isDark: isDark,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    l10n.insightsAchievements,
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(fontWeight: FontWeight.w800),
                                  ),
                                  Text(
                                    l10n.insightsAchievementsUnlocked(
                                      unlockedCount,
                                      totalCount,
                                    ),
                                    textAlign: TextAlign.center,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                          fontWeight: FontWeight.w600,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              Icons.chevron_right_rounded,
                              color: colorScheme.primary,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProgressBadge extends StatelessWidget {
  const _ProgressBadge({
    required this.icon,
    required this.colorScheme,
    required this.isDark,
  });

  final IconData icon;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: _mintFill(colorScheme, isDark),
        shape: BoxShape.circle,
      ),
      child: Icon(icon, size: 20, color: colorScheme.primary),
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
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
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

Color _mintFill(ColorScheme colorScheme, bool isDark) {
  return colorScheme.primary.withValues(alpha: isDark ? 0.18 : 0.12);
}
