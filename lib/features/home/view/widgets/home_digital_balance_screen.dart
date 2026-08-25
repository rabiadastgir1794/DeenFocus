import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_centered_nav_header.dart';
import '../../../../core/widgets/app_text_button.dart';
import '../../../../core/widgets/focus_app_icon.dart';
import '../../../../l10n/app_localizations.dart';
import '../../helpers/digital_balance_math.dart';
import '../../model/digital_balance_models.dart';
import '../../viewmodel/digital_balance_view_model.dart';
import 'digital_balance_chrome.dart';
import 'home_digital_balance_apps_screen.dart';
import 'home_digital_balance_card.dart';

class HomeDigitalBalanceScreen extends StatefulWidget {
  const HomeDigitalBalanceScreen({super.key});

  @override
  State<HomeDigitalBalanceScreen> createState() =>
      _HomeDigitalBalanceScreenState();
}

class _HomeDigitalBalanceScreenState extends State<HomeDigitalBalanceScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (!DigitalBalanceInsightsCard.visibleOnThisPlatform) return;
      unawaited(context.read<DigitalBalanceViewModel>().refresh());
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!DigitalBalanceInsightsCard.visibleOnThisPlatform) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted && Navigator.of(context).canPop()) {
          Navigator.of(context).pop();
        }
      });
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cream = isDark ? colorScheme.surface : AppColors.backgroundLight;
    final vm = context.watch<DigitalBalanceViewModel>();

    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: Column(
          children: [
            AppCenteredNavHeader(
              title: l10n.digitalBalanceTitle,
              backLabel: l10n.insightsBack,
              onBack: () => Navigator.of(context).pop(),
              trailing: IconButton(
                onPressed: () => _showInfo(context, l10n),
                icon: Icon(
                  Icons.info_outline_rounded,
                  color: colorScheme.primary,
                ),
              ),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
                children: [
                  Text(
                    l10n.digitalBalanceSubtitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (vm.loading && vm.snapshot == null)
                    const Padding(
                      padding: EdgeInsets.only(top: 48),
                      child: Center(child: CircularProgressIndicator()),
                    )
                  else if (vm.availability != AppUsageAvailability.granted ||
                      vm.snapshot == null)
                    _AvailabilityCard(
                      availability: vm.availability,
                      onEnable: vm.requestAccess,
                      onLater: () => Navigator.of(context).pop(),
                    )
                  else ...[
                    _TodayPhoneTimeCard(snapshot: vm.snapshot!),
                    const SizedBox(height: 16),
                    _WhereTimeGoesCard(snapshot: vm.snapshot!),
                    const SizedBox(height: 16),
                    _DeenVsDigitalCard(snapshot: vm.snapshot!),
                    const SizedBox(height: 16),
                    _YourWeekCard(snapshot: vm.snapshot!),
                    const SizedBox(height: 16),
                    _DailyInsightCard(snapshot: vm.snapshot!),
                    const SizedBox(height: 16),
                    _DeenGoalCard(
                      snapshot: vm.snapshot!,
                      onAdjust: () => _showGoalSheet(context, vm),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showInfo(BuildContext context, AppLocalizations l10n) {
    return showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.digitalBalanceInfoTitle),
        content: Text(l10n.digitalBalanceInfoBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(l10n.ok),
          ),
        ],
      ),
    );
  }

  Future<void> _showGoalSheet(
    BuildContext context,
    DigitalBalanceViewModel vm,
  ) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (ctx) => _AdjustGoalSheet(viewModel: vm),
    );
  }
}

class _AvailabilityCard extends StatelessWidget {
  const _AvailabilityCard({
    required this.availability,
    required this.onEnable,
    required this.onLater,
  });

  final AppUsageAvailability availability;
  final VoidCallback onEnable;
  final VoidCallback onLater;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final unsupported = availability == AppUsageAvailability.unsupported;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: digitalBalanceCardDecoration(colorScheme, isDark),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: digitalBalanceMintFill(colorScheme, isDark),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.phone_iphone_rounded,
              color: colorScheme.primary,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            unsupported
                ? l10n.digitalBalanceUnavailableTitle
                : l10n.digitalBalancePermissionTitle,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            unsupported
                ? l10n.digitalBalanceUnavailableBody
                : l10n.digitalBalancePermissionBody,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          if (!unsupported) ...[
            const SizedBox(height: 20),
            AppButton(
              label: l10n.digitalBalanceEnableUsage,
              onPressed: onEnable,
              showTrailingIcon: false,
            ),
            AppTextButton(
              label: l10n.digitalBalanceMaybeLater,
              onPressed: onLater,
            ),
          ],
        ],
      ),
    );
  }
}

class _TodayPhoneTimeCard extends StatelessWidget {
  const _TodayPhoneTimeCard({required this.snapshot});

  final DigitalBalanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percent = digitalBalanceTodayPercent(snapshot);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: digitalBalanceCardDecoration(colorScheme, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.digitalBalanceTodayPhoneTime,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          Text(
            formatDigitalBalanceDuration(l10n, snapshot.todayPhone),
            style: Theme.of(
              context,
            ).textTheme.displaySmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _MetricColumn(
                  label: l10n.digitalBalanceDeenFocus,
                  value: formatDigitalBalanceDuration(l10n, snapshot.todayDeen),
                  color: colorScheme.primary,
                ),
              ),
              Expanded(
                child: _MetricColumn(
                  label: l10n.digitalBalanceOtherApps,
                  value: formatDigitalBalanceDuration(
                    l10n,
                    snapshot.todayOther,
                  ),
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _SplitUsageBar(
            deen: snapshot.todayDeen,
            other: snapshot.todayOther,
            colorScheme: colorScheme,
          ),
          const SizedBox(height: 12),
          Center(
            child: Text(
              l10n.digitalBalancePercentOfPhoneTime(percent),
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: digitalBalanceMintFill(colorScheme, isDark),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Icon(Icons.eco_rounded, size: 18, color: colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    l10n.digitalBalanceInsightKeepGoing,
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

class _MetricColumn extends StatelessWidget {
  const _MetricColumn({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: color,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          value,
          style: Theme.of(
            context,
          ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _SplitUsageBar extends StatelessWidget {
  const _SplitUsageBar({
    required this.deen,
    required this.other,
    required this.colorScheme,
  });

  final Duration deen;
  final Duration other;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final total = deen + other;
    final deenFlex = total.inMilliseconds <= 0
        ? 0
        : (deen.inMilliseconds / total.inMilliseconds * 100).round().clamp(
            0,
            100,
          );
    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: SizedBox(
        height: 10,
        child: Row(
          children: [
            if (deenFlex > 0)
              Expanded(
                flex: deenFlex,
                child: ColoredBox(color: colorScheme.primary),
              ),
            Expanded(
              flex: (100 - deenFlex).clamp(1, 100),
              child: ColoredBox(
                color: colorScheme.outlineVariant.withValues(alpha: 0.45),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _WhereTimeGoesCard extends StatelessWidget {
  const _WhereTimeGoesCard({required this.snapshot});

  final DigitalBalanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final maxUsage = snapshot.topApps.fold<Duration>(
      Duration.zero,
      (longest, app) => app.usage > longest ? app.usage : longest,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 12, 12),
      decoration: digitalBalanceCardDecoration(colorScheme, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.digitalBalanceWhereTimeGoes,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              if (snapshot.allTodayApps.length > snapshot.topApps.length)
                TextButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => HomeDigitalBalanceAppsScreen(
                          apps: snapshot.allTodayApps,
                        ),
                      ),
                    );
                  },
                  child: Text(l10n.digitalBalanceViewAllApps),
                ),
            ],
          ),
          if (snapshot.topApps.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Text(
                l10n.digitalBalanceNoApps,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            )
          else
            for (var i = 0; i < snapshot.topApps.length; i++)
              _AppUsageRow(
                index: i + 1,
                entry: snapshot.topApps[i],
                maxUsage: maxUsage,
              ),
        ],
      ),
    );
  }
}

class _AppUsageRow extends StatelessWidget {
  const _AppUsageRow({
    required this.index,
    required this.entry,
    required this.maxUsage,
  });

  final int index;
  final AppUsageEntry entry;
  final Duration maxUsage;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fraction = maxUsage.inMilliseconds <= 0
        ? 0.0
        : (entry.usage.inMilliseconds / maxUsage.inMilliseconds).clamp(
            0.0,
            1.0,
          );

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.fromLTRB(8, 10, 8, 10),
      decoration: BoxDecoration(
        color: entry.isDeenFocus
            ? digitalBalanceMintFill(colorScheme, isDark)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 22,
            child: Text(
              '$index',
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          FocusAppIcon(
            label: entry.appName,
            iconBytes: entry.iconBytes,
            size: 28,
            radius: 8,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  entry.appName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: entry.isDeenFocus
                        ? colorScheme.primary
                        : colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: fraction,
                    minHeight: 6,
                    color: entry.isDeenFocus
                        ? colorScheme.primary
                        : colorScheme.onSurfaceVariant.withValues(alpha: 0.45),
                    backgroundColor: colorScheme.outlineVariant.withValues(
                      alpha: 0.28,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Text(
            formatDigitalBalanceDuration(l10n, entry.usage),
            style: Theme.of(
              context,
            ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _DeenVsDigitalCard extends StatelessWidget {
  const _DeenVsDigitalCard({required this.snapshot});

  final DigitalBalanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final percent = digitalBalanceTodayPercent(snapshot);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: digitalBalanceCardDecoration(colorScheme, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.digitalBalanceDeenVsDigital,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              SizedBox(
                width: 108,
                height: 108,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: CircularProgressIndicator(
                        value: percent / 100,
                        strokeWidth: 10,
                        strokeCap: StrokeCap.round,
                        backgroundColor: colorScheme.outlineVariant.withValues(
                          alpha: 0.35,
                        ),
                        color: colorScheme.primary,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        l10n.digitalBalanceRingLabel(percent),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(fontWeight: FontWeight.w800),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Column(
                  children: [
                    _LegendRow(
                      icon: Icons.mosque_rounded,
                      label: l10n.digitalBalanceDeenFocus,
                      value: formatDigitalBalanceDuration(
                        l10n,
                        snapshot.todayDeen,
                      ),
                      color: colorScheme.primary,
                    ),
                    const SizedBox(height: 12),
                    _LegendRow(
                      icon: Icons.phone_iphone_rounded,
                      label: l10n.digitalBalanceOtherApps,
                      value: formatDigitalBalanceDuration(
                        l10n,
                        snapshot.todayOther,
                      ),
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: digitalBalanceMintFill(colorScheme, isDark),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              l10n.digitalBalancePercentToday(percent),
              textAlign: TextAlign.center,
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

class _LegendRow extends StatelessWidget {
  const _LegendRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 20, color: color),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: color,
                  fontWeight: FontWeight.w700,
                ),
              ),
              Text(
                value,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _YourWeekCard extends StatelessWidget {
  const _YourWeekCard({required this.snapshot});

  final DigitalBalanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final increase = DigitalBalanceMath.weekDeenIncreasePercent(
      snapshot.weekDeen,
      snapshot.lastWeekDeen,
    );
    final maxY = DigitalBalanceMath.niceHourCeiling(
      snapshot.thisWeek.fold<Duration>(
        Duration.zero,
        (max, day) => day.totalPhoneUsage > max ? day.totalPhoneUsage : max,
      ),
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: digitalBalanceCardDecoration(colorScheme, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.digitalBalanceYourWeek,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.digitalBalanceThisWeek,
                      style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      formatDigitalBalanceDuration(l10n, snapshot.weekPhone),
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(fontWeight: FontWeight.w800),
                    ),
                    if (increase != null)
                      Text(
                        l10n.digitalBalanceWeekMoreDeen(increase),
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w700,
                            ),
                      ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.digitalBalanceDeenFocus,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    formatDigitalBalanceDuration(l10n, snapshot.weekDeen),
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _LegendDot(
                color: colorScheme.outlineVariant,
                label: l10n.digitalBalancePhoneUsageLegend,
              ),
              const SizedBox(width: 16),
              _LegendDot(
                color: colorScheme.primary,
                label: l10n.digitalBalanceDeenFocus,
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 180,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _WeekAxis(maxHours: maxY, colorScheme: colorScheme),
                const SizedBox(width: 8),
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      for (final day in snapshot.thisWeek)
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 3),
                            child: _WeekBar(
                              day: day,
                              maxHours: maxY,
                              l10n: l10n,
                              colorScheme: colorScheme,
                            ),
                          ),
                        ),
                    ],
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

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _WeekAxis extends StatelessWidget {
  const _WeekAxis({required this.maxHours, required this.colorScheme});

  final double maxHours;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final ticks = <double>[maxHours, maxHours * 2 / 3, maxHours / 3, 0];
    return SizedBox(
      width: 28,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          for (final tick in ticks)
            Text(
              tick == 0 ? '0' : '${tick.round()}h',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
        ],
      ),
    );
  }
}

class _WeekBar extends StatelessWidget {
  const _WeekBar({
    required this.day,
    required this.maxHours,
    required this.l10n,
    required this.colorScheme,
  });

  final AppUsageDay day;
  final double maxHours;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    final maxMs = maxHours * 3600 * 1000;
    final phone = (day.totalPhoneUsage.inMilliseconds / maxMs).clamp(0.0, 1.0);
    final deen = (day.deenFocusUsage.inMilliseconds / maxMs).clamp(0.0, 1.0);
    final other = (phone - deen).clamp(0.0, 1.0);

    return Column(
      children: [
        Expanded(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: FractionallySizedBox(
              heightFactor: phone <= 0 ? 0.04 : phone,
              widthFactor: 1,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Column(
                  children: [
                    if (other > 0)
                      Expanded(
                        flex: (other * 1000).round().clamp(1, 1000),
                        child: ColoredBox(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.55,
                          ),
                        ),
                      ),
                    Expanded(
                      flex: deen <= 0
                          ? 1
                          : (deen * 1000).round().clamp(1, 1000),
                      child: ColoredBox(
                        color: deen <= 0
                            ? colorScheme.outlineVariant.withValues(alpha: 0.35)
                            : colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          DateFormat.E(l10n.localeName).format(day.date),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _DailyInsightCard extends StatelessWidget {
  const _DailyInsightCard({required this.snapshot});

  final DigitalBalanceSnapshot snapshot;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: digitalBalanceCardDecoration(colorScheme, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.digitalBalanceDailyInsight,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: digitalBalanceMintFill(colorScheme, isDark),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.auto_awesome_rounded,
                    color: colorScheme.onPrimary,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    digitalBalanceInsightText(l10n, snapshot.insight),
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.4,
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

class _DeenGoalCard extends StatelessWidget {
  const _DeenGoalCard({required this.snapshot, required this.onAdjust});

  final DigitalBalanceSnapshot snapshot;
  final VoidCallback onAdjust;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final goal = Duration(minutes: snapshot.goalMinutes);
    final progress =
        DigitalBalanceMath.percentOf(snapshot.todayDeen, goal) / 100;
    final remaining = DigitalBalanceMath.remainingToGoal(
      snapshot.todayDeen,
      snapshot.goalMinutes,
    );
    final reached = DigitalBalanceMath.goalReached(
      snapshot.todayDeen,
      snapshot.goalMinutes,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: digitalBalanceCardDecoration(colorScheme, isDark),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.digitalBalanceGoalTitle,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              TextButton(
                onPressed: onAdjust,
                child: Text(l10n.digitalBalanceAdjustGoal),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.digitalBalanceGoalPerDay(
                    formatDigitalBalanceDuration(l10n, goal),
                  ),
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
                ),
              ),
              Text(
                l10n.digitalBalanceGoalProgress(
                  formatDigitalBalanceDuration(l10n, snapshot.todayDeen),
                  formatDigitalBalanceDuration(l10n, goal),
                ),
                style: Theme.of(
                  context,
                ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress.clamp(0, 1),
              minHeight: 10,
              color: colorScheme.primary,
              backgroundColor: colorScheme.outlineVariant.withValues(
                alpha: 0.35,
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Icon(
                Icons.schedule_rounded,
                size: 16,
                color: colorScheme.onSurfaceVariant,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  reached
                      ? l10n.digitalBalanceGoalReached
                      : l10n.digitalBalanceMinutesToGoal(remaining.inMinutes),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdjustGoalSheet extends StatefulWidget {
  const _AdjustGoalSheet({required this.viewModel});

  final DigitalBalanceViewModel viewModel;

  @override
  State<_AdjustGoalSheet> createState() => _AdjustGoalSheetState();
}

class _AdjustGoalSheetState extends State<_AdjustGoalSheet> {
  late int _selected;
  late final TextEditingController _custom;

  @override
  void initState() {
    super.initState();
    _selected = widget.viewModel.goalMinutes;
    _custom = TextEditingController(
      text: DigitalBalanceMath.goalPresets.contains(_selected)
          ? ''
          : '$_selected',
    );
  }

  @override
  void dispose() {
    _custom.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final bottom = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(20, 8, 20, 20 + bottom),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.digitalBalanceGoalSheetTitle,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final minutes in DigitalBalanceMath.goalPresets)
                ChoiceChip(
                  label: Text(_presetLabel(l10n, minutes)),
                  selected: _selected == minutes,
                  onSelected: (_) {
                    setState(() {
                      _selected = minutes;
                      _custom.clear();
                    });
                  },
                ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _custom,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: l10n.digitalBalanceGoalCustomHint,
            ),
            onChanged: (value) {
              final parsed = int.tryParse(value.trim());
              if (parsed == null) return;
              setState(() {
                _selected = DigitalBalanceMath.clampGoalMinutes(parsed);
              });
            },
          ),
          const SizedBox(height: 16),
          AppButton(
            label: l10n.digitalBalanceGoalSave,
            onPressed: () async {
              await widget.viewModel.setGoalMinutes(_selected);
              if (context.mounted) Navigator.of(context).pop();
            },
            showTrailingIcon: false,
          ),
        ],
      ),
    );
  }

  String _presetLabel(AppLocalizations l10n, int minutes) {
    switch (minutes) {
      case 15:
        return l10n.digitalBalanceGoal15;
      case 30:
        return l10n.digitalBalanceGoal30;
      case 45:
        return l10n.digitalBalanceGoal45;
      case 60:
        return l10n.digitalBalanceGoal60;
      default:
        return formatDigitalBalanceDuration(l10n, Duration(minutes: minutes));
    }
  }
}
