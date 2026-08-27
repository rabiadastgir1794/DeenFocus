import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/share/shareable_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_centered_nav_header.dart';
import '../../../../l10n/app_localizations.dart';
import '../../helpers/achievement_icon.dart';
import '../../services/achievements_service.dart';
import '../../services/level_service.dart';
import '../../viewmodel/home_tab_view_model.dart';

/// Full-screen Achievements list, opened from My Insights.
class HomeAchievementsScreen extends StatelessWidget {
  const HomeAchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cream = isDark ? colorScheme.surface : AppColors.backgroundLight;
    final vm = context.watch<HomeTabViewModel>();
    final completed = vm.achievements.where((item) => item.isUnlocked).toList();
    final inProgress = vm.achievements
        .where((item) => !item.isUnlocked)
        .toList();

    return Scaffold(
      backgroundColor: cream,
      body: SafeArea(
        child: Column(
          children: [
            AppCenteredNavHeader(
              title: l10n.insightsAchievements,
              backLabel: l10n.insightsBack,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 28),
                children: [
                  _LevelHeroCard(
                    level: vm.levelProgress,
                    l10n: l10n,
                    colorScheme: colorScheme,
                    isDark: isDark,
                  ),
                  const SizedBox(height: 12),
                  _UnlockedCountCard(
                    unlockedCount: vm.unlockedAchievementCount,
                    totalCount: AchievementsService.totalCount,
                    l10n: l10n,
                    colorScheme: colorScheme,
                    isDark: isDark,
                  ),
                  if (completed.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    _SectionTitle(l10n.insightsCompleted),
                    const SizedBox(height: 8),
                    for (final item in completed) ...[
                      _AchievementRow(
                        item: item,
                        l10n: l10n,
                        colorScheme: colorScheme,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                  if (inProgress.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    _SectionTitle(l10n.insightsInProgress),
                    const SizedBox(height: 8),
                    for (final item in inProgress) ...[
                      _AchievementRow(
                        item: item,
                        l10n: l10n,
                        colorScheme: colorScheme,
                        isDark: isDark,
                      ),
                      const SizedBox(height: 8),
                    ],
                  ],
                  const SizedBox(height: 8),
                  _KeepGoingCard(l10n: l10n, colorScheme: colorScheme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelHeroCard extends StatelessWidget {
  const _LevelHeroCard({
    required this.level,
    required this.l10n,
    required this.colorScheme,
    required this.isDark,
  });

  final LevelProgress level;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final xpFormat = NumberFormat.decimalPattern(l10n.localeName);
    final next = level.nextLevelXP;
    final heroBg = isDark
        ? colorScheme.primaryContainer
        : AppColors.primaryContainerDark;
    final heroFg = isDark
        ? colorScheme.onPrimaryContainer
        : AppColors.onPrimaryLight;
    final barColor = heroFg;
    final barTrack = heroFg.withValues(alpha: 0.28);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: heroBg,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: isDark
                      ? heroFg.withValues(alpha: 0.12)
                      : AppColors.onPrimaryLight,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.emoji_events_rounded,
                  color: isDark ? heroFg : AppColors.primaryContainerDark,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.insightsLevelNumber(level.currentLevel),
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: heroFg,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text(
                      LevelService.localizedName(l10n, level.currentLevel),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: heroFg.withValues(alpha: 0.9),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(
            level.isMaxLevel || next == null
                ? l10n.insightsXpTotal(xpFormat.format(level.totalXP))
                : l10n.insightsXpProgress(
                    xpFormat.format(level.progressXP),
                    xpFormat.format(level.xpSpan),
                  ),
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: heroFg,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: level.progressPercentage,
              minHeight: 8,
              color: barColor,
              backgroundColor: barTrack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            level.isMaxLevel
                ? l10n.insightsMaxLevel
                : l10n.insightsXpToNext(
                    xpFormat.format(level.xpToNext),
                    level.currentLevel + 1,
                  ),
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: heroFg.withValues(alpha: 0.85),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _UnlockedCountCard extends StatelessWidget {
  const _UnlockedCountCard({
    required this.unlockedCount,
    required this.totalCount,
    required this.l10n,
    required this.colorScheme,
    required this.isDark,
  });

  final int unlockedCount;
  final int totalCount;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: _cardDecoration(colorScheme, isDark),
      child: Row(
        children: [
          Expanded(
            child: Text(
              l10n.insightsAchievementsUnlockedLabel,
              style: Theme.of(
                context,
              ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Text(
            l10n.insightsAchievementsCount(unlockedCount, totalCount),
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(
        context,
      ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
    );
  }
}

class _AchievementRow extends StatefulWidget {
  const _AchievementRow({
    required this.item,
    required this.l10n,
    required this.colorScheme,
    required this.isDark,
  });

  final AchievementProgress item;
  final AppLocalizations l10n;
  final ColorScheme colorScheme;
  final bool isDark;

  @override
  State<_AchievementRow> createState() => _AchievementRowState();
}

class _AchievementRowState extends State<_AchievementRow> {
  final GlobalKey _boundaryKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    final item = widget.item;
    final l10n = widget.l10n;
    final colorScheme = widget.colorScheme;
    final isDark = widget.isDark;
    final unlocked = item.isUnlocked;
    return Row(
      children: [
        Expanded(
          child: RepaintBoundary(
            key: _boundaryKey,
            child: Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: _cardDecoration(colorScheme, isDark),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: unlocked
                  ? colorScheme.primary
                  : colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              achievementIcon(item.id),
              size: 22,
              color: unlocked ? colorScheme.onPrimary : colorScheme.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AchievementsService.title(l10n, item.id),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(
                    context,
                  ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  AchievementsService.description(l10n, item.id),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          if (unlocked)
            Icon(
              Icons.check_circle_rounded,
              color: colorScheme.primary,
              size: 22,
            )
          else
            SizedBox(
              width: 52,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    l10n.insightsCompactRatio(item.current, item.target),
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(3),
                    child: LinearProgressIndicator(
                      value: item.fraction,
                      minHeight: 4,
                      color: colorScheme.primary,
                      backgroundColor: colorScheme.outlineVariant.withValues(
                        alpha: 0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
            ),
          ),
        ),
        if (unlocked) ...[
          CardShareIconButton(boundaryKey: _boundaryKey),
        ],
      ],
    );
  }
}

class _KeepGoingCard extends StatelessWidget {
  const _KeepGoingCard({required this.l10n, required this.colorScheme});

  final AppLocalizations l10n;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Icon(
            Icons.card_giftcard_rounded,
            color: colorScheme.primary,
            size: 28,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.insightsKeepGoingTitle,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  l10n.insightsKeepGoingBody,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimaryContainer,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Icon(Icons.eco_rounded, color: colorScheme.primary, size: 36),
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
