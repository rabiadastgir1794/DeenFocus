import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../helpers/prayer_label_helper.dart';
import '../../model/home_models.dart';
import '../../viewmodel/home_tab_view_model.dart';
import 'prayer_sheet_back_button.dart';

/// Lets the user pick a notification sound (or mute) and enable/disable
/// notifications independently for [prayer].
Future<void> showPrayerNotificationSheet(
  BuildContext context,
  TrackablePrayer prayer,
) {
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
      child: _PrayerNotificationSheetContent(prayer: prayer),
    ),
  );
}

class _PrayerNotificationSheetContent extends StatelessWidget {
  const _PrayerNotificationSheetContent({required this.prayer});

  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<HomeTabViewModel>();
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prayerLabel = prayer.label(l10n);
    final settings = vm.settingsFor(prayer);
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);

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
                SheetBackButton(onTap: () => Navigator.of(context).pop()),
                SizedBox(width: Spacing.sm.w),
                Expanded(
                  child: Text(
                    l10n.homeNotificationForPrayer(prayerLabel),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Spacing.lg.h),
            Text(
              l10n.homeNotificationSoundLabel,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Spacing.sm.h),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: borderColor),
              ),
              child: Column(
                children: [
                  _SoundTile(
                    icon: Iconsax.volume_high,
                    title: l10n.homeNotificationSoundFullAdhan,
                    subtitle: l10n.homeNotificationSoundFullAdhanSubtitle,
                    selected:
                        settings.sound == PrayerNotificationSound.fullAdhan,
                    onTap: () => vm.setPrayerNotificationSound(
                      prayer,
                      PrayerNotificationSound.fullAdhan,
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                  _SoundTile(
                    icon: Iconsax.notification,
                    title: l10n.homeNotificationSoundBeep,
                    subtitle: l10n.homeNotificationSoundBeepSubtitle,
                    selected: settings.sound == PrayerNotificationSound.beep,
                    onTap: () => vm.setPrayerNotificationSound(
                      prayer,
                      PrayerNotificationSound.beep,
                    ),
                  ),
                  Divider(
                    height: 1,
                    thickness: 1,
                    indent: 16,
                    endIndent: 16,
                    color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                  ),
                  _SoundTile(
                    icon: Iconsax.volume_slash,
                    title: l10n.homeNotificationSoundMute,
                    subtitle: l10n.homeNotificationSoundMuteSubtitle,
                    selected: settings.sound == PrayerNotificationSound.mute,
                    onTap: () => vm.setPrayerNotificationSound(
                      prayer,
                      PrayerNotificationSound.mute,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Spacing.md.h),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: borderColor),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.md.w,
                vertical: Spacing.sm.h + 2.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.homeNotificationEnableLabel,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          l10n.homeNotificationEnableSubtitle(prayerLabel),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: settings.notificationsEnabled,
                    onChanged: (value) =>
                        vm.setPrayerNotificationEnabled(prayer, value),
                  ),
                ],
              ),
            ),
            SizedBox(height: Spacing.md.h),
            Container(
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: borderColor),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.md.w,
                vertical: Spacing.sm.h + 2.h,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.homePrayerAlarmEnableLabel,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        SizedBox(height: 2.h),
                        Text(
                          l10n.homePrayerAlarmEnableSubtitle(prayerLabel),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  Switch.adaptive(
                    value: settings.alarmEnabled,
                    onChanged: (value) =>
                        vm.setPrayerAlarmEnabled(prayer, value),
                  ),
                ],
              ),
            ),
            SizedBox(height: Spacing.lg.h),
            AppButton(
              label: l10n.save,
              showTrailingIcon: false,
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }
}

class _SoundTile extends StatelessWidget {
  const _SoundTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20.r),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: Spacing.md.w,
          vertical: Spacing.sm.h + 4.h,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20.sp,
              color: selected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            SizedBox(width: Spacing.md.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: selected ? colorScheme.primary : null,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: 2.h),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              Icon(Icons.check_rounded, color: colorScheme.primary, size: 20),
          ],
        ),
      ),
    );
  }
}
