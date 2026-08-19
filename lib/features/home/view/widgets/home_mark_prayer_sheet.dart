import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../helpers/home_prayer_times_helper.dart';
import '../../helpers/prayer_label_helper.dart';
import '../../model/home_models.dart';
import '../../viewmodel/home_tab_view_model.dart';
import 'home_prayer_completion_popup.dart';
import 'home_prayer_settings_sheet.dart';

/// Generic prayer tap handler for all five prayers:
/// - upcoming (clock time not reached today) → settings sheet
/// - started / passed → mark-as status sheet
///
/// Pass [prayerStart] from the visible tile when available so the decision
/// matches the time shown on that tile.
Future<void> openPrayerAction(
  BuildContext context,
  TrackablePrayer prayer, {
  DateTime? prayerStart,
}) {
  final vm = context.read<HomeTabViewModel>();
  final now = DateTime.now();
  final started = prayerStart != null
      ? HomePrayerTimesHelper.hasStartedOnDay(prayerStart, now)
      : vm.hasPrayerStarted(prayer, now: now);
  if (!started) {
    return showPrayerSettingsSheet(context, prayer);
  }
  return showMarkPrayerSheet(context, prayer);
}

/// Opens the "Mark Prayer" bottom sheet for [prayer] — the primary action
/// for logging today's prayer, with a settings shortcut in the header.
Future<void> showMarkPrayerSheet(BuildContext context, TrackablePrayer prayer) {
  // showModalBottomSheet mounts its builder under the root Navigator, so the
  // HomeTabViewModel from the Home tab's subtree must be re-supplied here.
  final vm = context.read<HomeTabViewModel>();
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => ChangeNotifierProvider<HomeTabViewModel>.value(
      value: vm,
      child: _MarkPrayerSheetContent(prayer: prayer),
    ),
  );
}

class _MarkPrayerSheetContent extends StatelessWidget {
  const _MarkPrayerSheetContent({required this.prayer});

  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<HomeTabViewModel>();
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final status = vm.statusForToday(prayer);
    final prayerLabel = prayer.label(l10n);

    return SafeArea(
      top: false,
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 32.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.homeMarkPrayerAs(prayerLabel),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                SizedBox(width: Spacing.sm.w),
                Material(
                  color: colorScheme.surfaceContainerHighest.withValues(
                    alpha: 0.6,
                  ),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    // Push on top rather than popping first, so the sheet's own
                    // back button (see home_prayer_settings_sheet.dart) returns
                    // here instead of dropping straight back to the Home screen.
                    onTap: () => showPrayerSettingsSheet(context, prayer),
                    child: Padding(
                      padding: EdgeInsets.all(Spacing.sm.w),
                      child: Icon(
                        Iconsax.setting_2,
                        size: 20.sp,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Spacing.lg.h),
            _MarkStatusButton(
              icon: Iconsax.tick_circle,
              label: l10n.homeMarkPrayerPrayedOnTime,
              backgroundColor: colorScheme.primary,
              foregroundColor: colorScheme.onPrimary,
              selected: status == PrayerMarkStatus.onTime,
              onTap: () => _mark(context, PrayerMarkStatus.onTime),
            ),
            SizedBox(height: Spacing.sm.h + 4.h),
            _MarkStatusButton(
              icon: Iconsax.timer_1,
              label: l10n.homeMarkPrayerQada,
              backgroundColor: isDark
                  ? AppColors.prayerQadaContainerDark
                  : AppColors.prayerQadaContainerLight,
              foregroundColor: isDark
                  ? AppColors.prayerQadaOnDark
                  : AppColors.prayerQadaOnLight,
              selected: status == PrayerMarkStatus.qada,
              onTap: () => _mark(context, PrayerMarkStatus.qada),
            ),
            SizedBox(height: Spacing.sm.h + 4.h),
            _MarkStatusButton(
              icon: Iconsax.close_circle,
              label: l10n.homeMarkPrayerMissed,
              backgroundColor: isDark
                  ? AppColors.prayerMissedContainerDark
                  : AppColors.prayerMissedContainerLight,
              foregroundColor: isDark
                  ? AppColors.prayerMissedOnDark
                  : AppColors.prayerMissedOnLight,
              selected: status == PrayerMarkStatus.missed,
              onTap: () => _mark(context, PrayerMarkStatus.missed),
            ),
          ],
        ),
      ),
    );
  }

  void _mark(BuildContext context, PrayerMarkStatus status) {
    final vm = context.read<HomeTabViewModel>();
    final current = vm.statusForToday(prayer);
    final next = current == status ? PrayerMarkStatus.none : status;
    unawaited(_markAndCelebrate(context, vm, next));
  }

  Future<void> _markAndCelebrate(
    BuildContext context,
    HomeTabViewModel vm,
    PrayerMarkStatus next,
  ) async {
    final result = await vm.markPrayerStatus(DateTime.now(), prayer, next);
    if (!context.mounted) return;
    if (result == null || !result.celebrated) return;

    Navigator.of(context).pop(); // close mark sheet
    if (!context.mounted) return;

    final remaining = vm.prayerTimes?.nextPrayerTime?.difference(DateTime.now());
    await showPrayerCompletionPopup(
      context,
      result: result,
      nextPrayerIn: remaining,
    );
  }
}

class _MarkStatusButton extends StatelessWidget {
  const _MarkStatusButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          height: 56.h,
          padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: selected
                ? Border.all(
                    color: foregroundColor.withValues(alpha: 0.55),
                    width: 2,
                  )
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 20.sp, color: foregroundColor),
              SizedBox(width: Spacing.sm.w),
              Text(
                label,
                style: TextStyle(
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: foregroundColor,
                ),
              ),
              if (selected) ...[
                SizedBox(width: Spacing.sm.w),
                Icon(Icons.check_rounded, size: 18.sp, color: foregroundColor),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
