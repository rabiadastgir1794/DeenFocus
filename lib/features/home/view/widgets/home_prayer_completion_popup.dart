import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../helpers/prayer_label_helper.dart';
import '../../model/home_models.dart';

/// Celebratory popup shown after marking a prayer as completed.
Future<void> showPrayerCompletionPopup(
  BuildContext context, {
  required PrayerMarkResult result,
  Duration? nextPrayerIn,
}) {
  return showGeneralDialog<void>(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    transitionDuration: const Duration(milliseconds: 320),
    pageBuilder: (ctx, anim, secondary) {
      return SafeArea(
        child: Center(
          child: _PrayerCompletionCard(
            result: result,
            nextPrayerIn: nextPrayerIn,
          ),
        ),
      );
    },
    transitionBuilder: (ctx, anim, secondary, child) {
      final curved = CurvedAnimation(parent: anim, curve: Curves.easeOutBack);
      return FadeTransition(
        opacity: anim,
        child: ScaleTransition(scale: curved, child: child),
      );
    },
  );
}

class _PrayerCompletionCard extends StatelessWidget {
  const _PrayerCompletionCard({
    required this.result,
    this.nextPrayerIn,
  });

  final PrayerMarkResult result;
  final Duration? nextPrayerIn;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final prayerLabel = result.prayer.label(l10n);
    final nextLabel = _formatNext(l10n, nextPrayerIn);

    return Material(
      color: Colors.transparent,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 24),
        constraints: const BoxConstraints(maxWidth: 400),
        decoration: BoxDecoration(
          color: colorScheme.surface,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.18),
              blurRadius: 28,
              offset: const Offset(0, 12),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    colorScheme.primary.withValues(alpha: 0.18),
                    colorScheme.surface,
                  ],
                ),
              ),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 84,
                        height: 84,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary.withValues(alpha: 0.16),
                        ),
                        child: Icon(
                          Icons.local_fire_department_rounded,
                          size: 40,
                          color: colorScheme.primary,
                        ),
                      ),
                      Positioned(
                        right: 0,
                        top: 0,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: colorScheme.surface,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.08),
                                blurRadius: 6,
                              ),
                            ],
                          ),
                          child: Text(
                            '+1',
                            style: TextStyle(
                              color: colorScheme.primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.prayerCompletionAlhamdulillah,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          l10n.prayerCompletionCompleted(prayerLabel),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Icon(
                        Icons.check_circle_rounded,
                        size: 18,
                        color: colorScheme.primary,
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.prayerCompletionStreakIncreased,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    decoration: BoxDecoration(
                      color: colorScheme.surfaceContainerHighest.withValues(
                        alpha: 0.35,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _StatColumn(
                            icon: Icons.local_fire_department_rounded,
                            value: '${result.prayerStreak}',
                            fromValue: result.previousPrayerStreak,
                            label: l10n.insightsPrayerStreak,
                            colorScheme: colorScheme,
                          ),
                        ),
                        Container(
                          width: 1,
                          height: 44,
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.5,
                          ),
                        ),
                        Expanded(
                          child: _StatColumn(
                            icon: Icons.calendar_today_rounded,
                            value: '${result.dayStreak}',
                            label: l10n.insightsDayStreak,
                            colorScheme: colorScheme,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (nextLabel != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      l10n.prayerCompletionNextPrayer(nextLabel),
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                  const SizedBox(height: 10),
                  Text(
                    l10n.prayerCompletionKeepGoing,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 18),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: Text(l10n.prayerCompletionContinue),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _formatNext(AppLocalizations l10n, Duration? next) {
    if (next == null || next.isNegative) return null;
    final minutes = next.inMinutes;
    if (minutes < 60) return l10n.prayerCompletionMinutes(minutes);
    final hours = minutes ~/ 60;
    final rem = minutes % 60;
    return l10n.prayerCompletionHoursMinutes(hours, rem);
  }
}

class _StatColumn extends StatelessWidget {
  const _StatColumn({
    required this.icon,
    required this.value,
    required this.label,
    required this.colorScheme,
    this.fromValue = 0,
  });

  final IconData icon;
  final String value;
  final String label;
  final ColorScheme colorScheme;
  final int fromValue;

  @override
  Widget build(BuildContext context) {
    final end = double.tryParse(value) ?? 0;
    return Column(
      children: [
        Icon(icon, color: colorScheme.primary, size: 18),
        const SizedBox(height: 4),
        TweenAnimationBuilder<double>(
          tween: Tween(begin: fromValue.toDouble(), end: end),
          duration: const Duration(milliseconds: 700),
          curve: Curves.easeOutCubic,
          builder: (context, animated, _) {
            return Text(
              '${animated.round()}',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.w800,
                color: colorScheme.primary,
              ),
            );
          },
        ),
        Text(
          label.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
            fontSize: 9,
          ),
        ),
      ],
    );
  }
}
