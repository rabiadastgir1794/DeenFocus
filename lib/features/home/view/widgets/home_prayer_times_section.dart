import 'dart:async';

import 'package:flutter/material.dart';
import '../../../../core/theme/light_theme.dart' show kAppFontFamily;
import 'package:intl/intl.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../model/home_models.dart';

class HomePrayerTimesSection extends StatelessWidget {
  const HomePrayerTimesSection({
    super.key,
    required this.prayerTimes,
    required this.backgroundColor,
    this.isActive = true,
  });

  final HomePrayerTimesData? prayerTimes;
  final Color backgroundColor;

  /// When false (e.g. another bottom tab visible), skip the 1 Hz countdown ticker.
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prayerTimes = this.prayerTimes;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? colorScheme.outlineVariant.withValues(alpha: 0.35)
              : AppColors.outlineVariantLight.withValues(alpha: 0.35),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.035),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.homeTodaysPrayers,
                style: TextStyle(
                  fontFamily: kAppFontFamily,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                  color: colorScheme.onSurface,
                ),
              ),
              const Spacer(),
              Text(
                DateFormat.yMMMEd(l10n.localeName).format(DateTime.now()),
                style: TextStyle(
                  fontFamily: kAppFontFamily,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  height: 1.2,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (prayerTimes == null)
            Text(
              l10n.homePrayerTimesUnavailable,
              style: TextStyle(
                fontFamily: kAppFontFamily,
                fontSize: 14,
                color: colorScheme.onSurfaceVariant,
              ),
            )
          else
            LayoutBuilder(
              builder: (context, constraints) {
                const minTileWidth = 104.0;
                const spacing = 8.0;
                final maxW = constraints.maxWidth;
                final width = maxW.isFinite
                    ? maxW
                    : minTileWidth * 3 + 2 * spacing;
                var cols = ((width + spacing) / (minTileWidth + spacing))
                    .floor();
                cols = cols.clamp(1, 3);
                final tileWidth = (width - (cols - 1) * spacing) / cols;

                return Wrap(
                  spacing: spacing,
                  runSpacing: spacing,
                  alignment: WrapAlignment.start,
                  children: prayerTimes.slots
                      .map(
                        (slot) => HomePrayerTile(
                          slot: slot,
                          prayerTimes: prayerTimes,
                          width: tileWidth,
                        ),
                      )
                      .toList(growable: false),
                );
              },
            ),
          const SizedBox(height: 10),
          if (prayerTimes != null)
            _NextPrayerCountdown(
              prayerTimes: prayerTimes,
              isActive: isActive,
            ),
        ],
      ),
    );
  }
}

/// Isolates the 1 Hz rebuild to the countdown row only.
class _NextPrayerCountdown extends StatefulWidget {
  const _NextPrayerCountdown({
    required this.prayerTimes,
    required this.isActive,
  });

  final HomePrayerTimesData prayerTimes;
  final bool isActive;

  @override
  State<_NextPrayerCountdown> createState() => _NextPrayerCountdownState();
}

class _NextPrayerCountdownState extends State<_NextPrayerCountdown> {
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _syncTicker();
  }

  @override
  void didUpdateWidget(covariant _NextPrayerCountdown oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isActive != widget.isActive) {
      _syncTicker();
    }
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _syncTicker() {
    _ticker?.cancel();
    _ticker = null;
    if (!widget.isActive) return;
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    final remaining = _dynamicRemaining(widget.prayerTimes);
    if (remaining == null) return const SizedBox.shrink();

    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          l10n.homeNextPrayerIn,
          style: TextStyle(
            fontFamily: kAppFontFamily,
            fontSize: 14,
            height: 1.2,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatRemaining(remaining),
          style: TextStyle(
            fontFamily: kAppFontFamily,
            fontSize: 14,
            fontWeight: FontWeight.w700,
            height: 1.2,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  String _formatRemaining(Duration value) {
    final hours = value.inHours;
    final minutes = value.inMinutes.remainder(60);
    final seconds = value.inSeconds.remainder(60);
    return '${hours}h ${minutes}m ${seconds}s';
  }

  Duration? _dynamicRemaining(HomePrayerTimesData prayerTimes) {
    if (prayerTimes.nextPrayer == null) return null;
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
    this.width = 104,
  });

  final HomePrayerSlot slot;
  final HomePrayerTimesData prayerTimes;
  final double width;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final now = DateTime.now();
    final isPassed = !slot.time.isAfter(now);
    final isCurrent = prayerTimes.nextPrayer == slot.id;
    final isPast = isPassed && !isCurrent;

    // Mirrors web: next → primary + shadow-primary/20; passed → muted/50;
    // upcoming → warm fill + border-border/50.
    final Color background;
    final Color titleColor;
    final Color timeColor;
    final BoxBorder? border;
    final List<BoxShadow>? boxShadow;

    if (isCurrent) {
      background = colorScheme.primary;
      titleColor = colorScheme.onPrimary;
      timeColor = colorScheme.onPrimary;
      border = null;
      boxShadow = [
        BoxShadow(
          color: colorScheme.primary.withValues(alpha: 0.2),
          blurRadius: 16,
          offset: const Offset(0, 6),
        ),
      ];
    } else if (isPast) {
      background = colorScheme.surfaceContainerHighest.withValues(
        alpha: isDark ? 0.42 : 0.5,
      );
      titleColor = colorScheme.onSurfaceVariant;
      timeColor = colorScheme.onSurfaceVariant.withValues(alpha: 0.8);
      border = null;
      boxShadow = null;
    } else {
      background = isDark
          ? (Theme.of(context).cardTheme.color ?? colorScheme.surface)
          : const Color(0xFFf6f4ee);
      titleColor = colorScheme.onSurface;
      timeColor = colorScheme.onSurface;
      border = Border.all(
        color: colorScheme.outlineVariant.withValues(alpha: 0.5),
      );
      boxShadow = null;
    }

    final tile = Container(
      width: width,
      height: 76,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: border,
        boxShadow: boxShadow,
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
              style: TextStyle(
                fontFamily: kAppFontFamily,
                fontSize: 10,
                fontWeight: FontWeight.w500,
                height: 1.2,
                color: titleColor.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat.jm(l10n.localeName).format(slot.time),
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: kAppFontFamily,
                fontSize: 14,
                fontWeight: FontWeight.w700,
                height: 1.2,
                color: timeColor,
              ),
            ),
          ],
        ),
      ),
    );

    if (!isCurrent) return tile;
    return tile;
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
