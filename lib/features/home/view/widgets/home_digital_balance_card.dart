import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../model/digital_balance_models.dart';
import '../../viewmodel/digital_balance_view_model.dart';
import 'digital_balance_chrome.dart';

class DigitalBalanceInsightsCard extends StatelessWidget {
  const DigitalBalanceInsightsCard({super.key, required this.onOpen});

  final VoidCallback onOpen;

  /// Android UsageStats is live. iOS host-app export is not, so Insights
  /// omits this card instead of showing the unused permission state.
  static bool get visibleOnThisPlatform => !kIsWeb && Platform.isAndroid;

  @override
  Widget build(BuildContext context) {
    if (!visibleOnThisPlatform) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = context.watch<DigitalBalanceViewModel>();
    final snapshot = vm.snapshot;
    final hasData =
        vm.availability == AppUsageAvailability.granted && snapshot != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(16),
        child: Ink(
          decoration: digitalBalanceCardDecoration(colorScheme, isDark),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(14, 14, 10, 14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: digitalBalanceMintFill(colorScheme, isDark),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.bar_chart_rounded,
                        color: colorScheme.primary,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.digitalBalanceTitle,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w800),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            l10n.digitalBalanceSubtitle,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w500,
                                ),
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
                if (hasData) ...[
                  const SizedBox(height: 12),
                  Text(
                    '${l10n.digitalBalanceTodayLabel} · ${formatDigitalBalanceDuration(l10n, snapshot.todayPhone)}',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _CompactSplitBar(
                    deen: snapshot.todayDeen,
                    other: snapshot.todayOther,
                    colorScheme: colorScheme,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          '${l10n.digitalBalanceDeenFocus}  ${formatDigitalBalanceDuration(l10n, snapshot.todayDeen)}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelMedium
                              ?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                      Text(
                        '${l10n.digitalBalanceOtherApps}  ${formatDigitalBalanceDuration(l10n, snapshot.todayOther)}',
                        style: Theme.of(context).textTheme.labelMedium
                            ?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.digitalBalancePercentShort(
                      digitalBalanceTodayPercent(snapshot),
                    ),
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.digitalBalanceViewCta,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colorScheme.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CompactSplitBar extends StatelessWidget {
  const _CompactSplitBar({
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
      borderRadius: BorderRadius.circular(6),
      child: SizedBox(
        height: 8,
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
