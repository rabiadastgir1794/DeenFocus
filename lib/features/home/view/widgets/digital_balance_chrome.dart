import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../helpers/digital_balance_math.dart';
import '../../model/digital_balance_models.dart';

BoxDecoration digitalBalanceCardDecoration(
  ColorScheme colorScheme,
  bool isDark,
) {
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

Color digitalBalanceMintFill(ColorScheme colorScheme, bool isDark) {
  return colorScheme.primary.withValues(alpha: isDark ? 0.18 : 0.12);
}

String formatDigitalBalanceDuration(AppLocalizations l10n, Duration duration) {
  final totalMinutes = duration.inMinutes;
  if (totalMinutes <= 0) return l10n.digitalBalanceDurationMinutes(0);
  final hours = totalMinutes ~/ 60;
  final minutes = totalMinutes % 60;
  if (hours <= 0) return l10n.digitalBalanceDurationMinutes(minutes);
  if (minutes <= 0) return l10n.digitalBalanceDurationHours(hours);
  return l10n.digitalBalanceDurationHoursMinutes(hours, minutes);
}

String digitalBalanceInsightText(
  AppLocalizations l10n,
  DigitalBalanceInsight insight,
) {
  switch (insight.kind) {
    case DigitalBalanceInsightKind.minutesToday:
      return l10n.digitalBalanceInsightTimeToday(
        formatDigitalBalanceDuration(l10n, insight.duration),
      );
    case DigitalBalanceInsightKind.increasedVsYesterday:
      return l10n.digitalBalanceInsightIncreasedYesterday(insight.percent ?? 0);
    case DigitalBalanceInsightKind.weekHigher:
      return l10n.digitalBalanceInsightWeekHigher;
    case DigitalBalanceInsightKind.quietDay:
      return l10n.digitalBalanceInsightQuietDay;
    case DigitalBalanceInsightKind.keepGoing:
      return l10n.digitalBalanceInsightKeepGoing;
  }
}

int digitalBalanceTodayPercent(DigitalBalanceSnapshot snapshot) {
  return DigitalBalanceMath.percentOf(snapshot.todayDeen, snapshot.todayPhone);
}
