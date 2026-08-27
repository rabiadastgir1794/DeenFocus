import 'dart:async';

import 'package:flutter/material.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/user_profile_service.dart';
import '../../../../core/share/shareable_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/light_theme.dart' show kAppFontFamily;
import '../../../../l10n/app_localizations.dart';
import '../../helpers/home_prayer_times_helper.dart';
import '../../model/home_models.dart';
import '../../viewmodel/home_tab_view_model.dart';
import '../settings/settings_tab_screen.dart';
import 'home_mark_prayer_sheet.dart';
import 'home_prayer_settings_sheet.dart';

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

  void _openLocationSettings(BuildContext context) {
    final profile = context.read<UserProfileService>();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SettingsLocationScreen(
          initialSelection: profile.locationSuggestion,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prayerTimes = this.prayerTimes;
    final profile = context.watch<UserProfileService>();
    final locationName = profile.locationName?.trim() ?? '';
    final hasLocation = locationName.isNotEmpty;

    return ShareableCard(
      child: Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isDark
              ? colorScheme.outlineVariant.withValues(alpha: 0.30)
              : AppColors.outlineVariantLight.withValues(alpha: 0.28),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(14, 16, 14, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  l10n.homeTodaysPrayers,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.2,
                    color: colorScheme.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              InkWell(
                onTap: () => _openLocationSettings(context),
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Iconsax.location,
                        size: 13,
                        color: colorScheme.primary,
                      ),
                      const SizedBox(width: 4),
                      ConstrainedBox(
                        constraints: BoxConstraints(
                          maxWidth: MediaQuery.sizeOf(context).width * 0.38,
                        ),
                        child: Text(
                          hasLocation ? locationName : l10n.homeSetLocation,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.end,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                fontWeight: FontWeight.w500,
                                height: 1.2,
                                color: colorScheme.onSurfaceVariant,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 32),
            ],
          ),
          const SizedBox(height: 12),
          if (prayerTimes == null)
            Text(
              l10n.homePrayerTimesUnavailable,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
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
          const SizedBox(height: 12),
          if (prayerTimes != null)
            _NextPrayerCountdown(prayerTimes: prayerTimes, isActive: isActive),
          if (prayerTimes != null) ...[
            const SizedBox(height: 6),
            SizedBox(
              width: double.infinity,
              child: Text(
                l10n.homeTapPrayerToMark,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  height: 1.3,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ),
          ],
        ],
      ),
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
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            height: 1.2,
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          _formatRemaining(l10n, remaining),
          style: TextStyle(
            fontFamily: kAppFontFamily,
            fontSize: 16,
            fontWeight: FontWeight.w700,
            height: 1.15,
            letterSpacing: 0.2,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }

  String _formatRemaining(AppLocalizations l10n, Duration value) {
    final hours = value.inHours;
    final minutes = value.inMinutes.remainder(60);
    final seconds = value.inSeconds.remainder(60);
    return l10n.homeCountdownHms(hours, minutes, seconds);
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
    // Match the clock time shown on the tile (hour:minute today), not a possibly
    // wrong date component on [slot.time] — that bug made only Fajr markable.
    final isPassed = HomePrayerTimesHelper.hasStartedOnDay(slot.time, now);
    final isCurrent = prayerTimes.nextPrayer == slot.id;
    final isPast = isPassed && !isCurrent;
    final trackable = slot.id.trackablePrayer;
    final status = trackable == null
        ? PrayerMarkStatus.none
        : context.watch<HomeTabViewModel>().statusForToday(trackable);
    // Mirrors web: next → primary + shadow-primary/20; passed & unmarked →
    // muted/50; upcoming → warm fill + border-border/50. Marked past prayers
    // reuse the same primary/secondary/error roles as the Mark Prayer sheet
    // (on time → success/primary, qada → warning/secondary, missed →
    // error) so the two surfaces always agree on colour.
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
    } else if (isPast && status == PrayerMarkStatus.missed) {
      background = colorScheme.errorContainer.withValues(alpha: 0.55);
      titleColor = colorScheme.error;
      timeColor = colorScheme.error;
      border = null;
      boxShadow = null;
    } else if (isPast && status == PrayerMarkStatus.qada) {
      background =
          (isDark
                  ? AppColors.prayerQadaContainerDark
                  : AppColors.prayerQadaContainerLight)
              .withValues(alpha: 0.85);
      titleColor = isDark
          ? AppColors.prayerQadaOnDark
          : AppColors.prayerQadaOnLight;
      timeColor = titleColor;
      border = null;
      boxShadow = null;
    } else if (isPast && status == PrayerMarkStatus.onTime) {
      background = colorScheme.primaryContainer.withValues(alpha: 0.55);
      titleColor = colorScheme.primary;
      timeColor = colorScheme.primary;
      border = null;
      boxShadow = null;
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

    // Always show Edit on trackable prayers. Tap uses [openPrayerAction]
    // (upcoming → settings, started/passed → mark sheet). Sunrise has no
    // trackable prayer, so it stays without an edit control.
    final showEditAffordance = trackable != null;
    final editOnPrimary = isCurrent;
    final editBg = editOnPrimary
        ? colorScheme.onPrimary.withValues(alpha: 0.22)
        : (isDark
              ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.9)
              : const Color(0xFFE8E6E0));
    final editFg = editOnPrimary
        ? colorScheme.onPrimary
        : colorScheme.onSurfaceVariant;

    return SizedBox(
      width: width,
      height: 72,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(14),
          border: border,
          boxShadow: boxShadow,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: trackable == null
                      ? null
                      : () {
                          final prayer = trackable;
                          if (isPassed) {
                            showMarkPrayerSheet(context, prayer);
                          } else {
                            showPrayerSettingsSheet(context, prayer);
                          }
                        },
                  borderRadius: BorderRadius.circular(14),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 8,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _labelForPrayer(l10n, slot.id),
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                fontWeight: isCurrent
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                height: 1.2,
                                color: titleColor.withValues(
                                  alpha: isCurrent ? 0.92 : 0.88,
                                ),
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
                            height: 1.15,
                            color: timeColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            if (showEditAffordance)
              Positioned(
                top: 5,
                left: 5,
                child: Material(
                  color: editBg,
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () => openPrayerAction(
                      context,
                      trackable,
                      prayerStart: slot.time,
                    ),
                    child: Tooltip(
                      message: l10n.homeEditPrayerSettings,
                      child: SizedBox(
                        width: 20,
                        height: 20,
                        child: Icon(Iconsax.edit_2, size: 10, color: editFg),
                      ),
                    ),
                  ),
                ),
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
