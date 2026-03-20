import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../model/home_models.dart';

class HomePrayerTimesSection extends StatelessWidget {
  const HomePrayerTimesSection({
    super.key,
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
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
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
                        HomePrayerTile(slot: slot, prayerTimes: prayerTimes!),
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

class HomePrayerTile extends StatelessWidget {
  const HomePrayerTile({
    super.key,
    required this.slot,
    required this.prayerTimes,
  });

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
