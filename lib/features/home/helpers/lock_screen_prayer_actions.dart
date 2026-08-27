import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../l10n/app_localizations.dart';
import '../model/home_models.dart';
import '../view/widgets/home_prayer_completion_popup.dart';
import '../viewmodel/home_tab_view_model.dart';
import 'prayer_label_helper.dart';

/// Shared confirm / defer actions for lock-screen prayer styles.
///
/// Delegates marking to [HomeTabViewModel.markPrayerStatus] — the same path
/// as the in-app reminder popup.
abstract final class LockScreenPrayerActions {
  static TrackablePrayer? targetOf(BuildContext context) {
    try {
      return context.read<HomeTabViewModel>().getPrayerReminderTarget();
    } on ProviderNotFoundException {
      return null;
    }
  }

  /// Current / last prayer to show on lock-screen previews and experiences.
  ///
  /// Prefers [preferred], then the unmarked reminder target, then the most
  /// recent started prayer, then the next upcoming prayer. Never defaults
  /// to a hardcoded Asr/Dhuhr.
  static TrackablePrayer resolveDisplayPrayer(
    BuildContext context, {
    TrackablePrayer? preferred,
  }) {
    if (preferred != null) return preferred;
    try {
      final vm = context.read<HomeTabViewModel>();
      return vm.getPrayerReminderTarget() ??
          vm.getMostRecentStartedPrayer() ??
          vm.prayerTimes?.nextPrayer?.trackablePrayer ??
          TrackablePrayer.fajr;
    } on ProviderNotFoundException {
      return TrackablePrayer.fajr;
    }
  }

  static String prayerLabel(BuildContext context, {TrackablePrayer? prayer}) {
    final l10n = AppLocalizations.of(context)!;
    return resolveDisplayPrayer(context, preferred: prayer).label(l10n);
  }

  static String prayerArabic(TrackablePrayer prayer) {
    switch (prayer) {
      case TrackablePrayer.fajr:
        return 'الفجر';
      case TrackablePrayer.dhuhr:
        return 'الظهر';
      case TrackablePrayer.asr:
        return 'العصر';
      case TrackablePrayer.maghrib:
        return 'المغرب';
      case TrackablePrayer.isha:
        return 'العشاء';
    }
  }

  static String? remainingLabel(BuildContext context) {
    try {
      final remaining = context
          .watch<HomeTabViewModel>()
          .prayerTimes
          ?.remaining;
      if (remaining == null || remaining.isNegative) return null;
      final l10n = AppLocalizations.of(context)!;
      return l10n.homeCountdownHms(
        remaining.inHours,
        remaining.inMinutes.remainder(60),
        remaining.inSeconds.remainder(60),
      );
    } on ProviderNotFoundException {
      return null;
    }
  }

  /// Pops a reminder dialog with `true` without marking the prayer.
  static void completeReminder(BuildContext context) {
    if (context.mounted) Navigator.of(context).pop(true);
  }

  /// Pops a reminder dialog with `false` (I'll mark later).
  static void deferReminder(BuildContext context) {
    if (context.mounted) Navigator.of(context).pop(false);
  }

  static Future<void> confirmOnTime(
    BuildContext context, {
    TrackablePrayer? prayer,
  }) async {
    HomeTabViewModel vm;
    try {
      vm = context.read<HomeTabViewModel>();
    } on ProviderNotFoundException {
      if (context.mounted) Navigator.of(context).maybePop(true);
      return;
    }

    final target =
        prayer ??
        vm.getPrayerReminderTarget() ??
        vm.getMostRecentStartedPrayer();
    if (target == null) {
      if (context.mounted) Navigator.of(context).maybePop(true);
      return;
    }
    if (vm.statusForToday(target) != PrayerMarkStatus.none) {
      if (context.mounted) Navigator.of(context).maybePop(true);
      return;
    }

    final result = await vm.markPrayerStatus(
      DateTime.now(),
      target,
      PrayerMarkStatus.onTime,
    );
    if (!context.mounted) return;

    if (result != null && result.celebrated) {
      final remaining = vm.prayerTimes?.nextPrayerTime?.difference(
        DateTime.now(),
      );
      await showPrayerCompletionPopup(
        context,
        result: result,
        nextPrayerIn: remaining,
      );
    }
    if (context.mounted) Navigator.of(context).maybePop(true);
  }

  static void markLater(BuildContext context) {
    Navigator.of(context).maybePop(false);
  }
}
