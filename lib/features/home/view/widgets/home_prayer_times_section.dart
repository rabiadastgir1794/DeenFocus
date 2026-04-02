import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../model/home_models.dart';

class HomePrayerTimesSection extends StatefulWidget {
  const HomePrayerTimesSection({
    super.key,
    required this.prayerTimes,
    required this.backgroundColor,
  });

  final HomePrayerTimesData? prayerTimes;
  final Color backgroundColor;

  @override
  State<HomePrayerTimesSection> createState() => _HomePrayerTimesSectionState();
}

class _HomePrayerTimesSectionState extends State<HomePrayerTimesSection> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final prayerTimes = widget.prayerTimes;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: widget.backgroundColor,
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
              children: prayerTimes.slots
                  .map(
                    (slot) => HomePrayerTile(slot: slot, prayerTimes: prayerTimes),
                  )
                  .toList(growable: false),
            ),
          const SizedBox(height: 10),
          if (_dynamicRemaining(prayerTimes) case final remaining?)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(l10n.homeNextPrayerIn),
                const SizedBox(width: 6),
                Text(
                  _formatRemaining(remaining),
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
    final seconds = value.inSeconds.remainder(60);
    return '${hours}h ${minutes}m ${seconds}s';
  }

  Duration? _dynamicRemaining(HomePrayerTimesData? prayerTimes) {
    if (prayerTimes == null || prayerTimes.nextPrayer == null) return null;
    final nextPrayerTime = prayerTimes.nextPrayerTime;
    if (nextPrayerTime != null) {
      final remaining = nextPrayerTime.difference(DateTime.now());
      return remaining.isNegative ? Duration.zero : remaining;
    }
    final nextSlot = prayerTimes.slots
        .where((slot) => slot.id == prayerTimes.nextPrayer)
        .firstOrNull;
    if (nextSlot == null) return prayerTimes.remaining;
    final remaining = nextSlot.time.difference(DateTime.now());
    if (remaining.isNegative) return Duration.zero;
    return remaining;
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
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
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
