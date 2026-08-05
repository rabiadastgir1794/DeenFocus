import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../l10n/app_localizations.dart';
import '../../helpers/prayer_label_helper.dart';
import '../../model/home_models.dart';
import '../../viewmodel/home_tab_view_model.dart';
import 'home_about_prayer_screen.dart';
import 'home_edit_prayer_time_sheet.dart';
import 'home_prayer_notification_sheet.dart';
import 'prayer_sheet_back_button.dart';

/// Second-level sheet opened from the settings icon on the Mark Prayer sheet.
/// Shows per-prayer time, notification, and info as three scannable cards.
Future<void> showPrayerSettingsSheet(
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
      child: _PrayerSettingsSheetContent(prayer: prayer),
    ),
  );
}

class _PrayerSettingsSheetContent extends StatelessWidget {
  const _PrayerSettingsSheetContent({required this.prayer});

  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<HomeTabViewModel>();
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prayerLabel = prayer.label(l10n);
    final settings = vm.settingsFor(prayer);

    final slot = vm.prayerTimes?.slots
        .where((item) => item.id == prayer.homePrayerId)
        .firstOrNull;
    final timeLabel = slot == null
        ? '—'
        : DateFormat.jm(l10n.localeName).format(slot.time);
    final soundLabel = _soundLabel(l10n, settings.sound);

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
                    l10n.homePrayerSettingsTitle(prayerLabel),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Spacing.lg.h),
            _SettingsCard(
              icon: Iconsax.clock,
              title: l10n.homePrayerSettingsPrayerTime,
              subtitle: timeLabel,
              // Push on top rather than popping first, so this sheet stays on
              // the stack and its own back button reveals it again.
              onTap: () => showEditPrayerTimeSheet(context, prayer),
            ),
            SizedBox(height: Spacing.md.h),
            _SettingsCard(
              icon: settings.notificationsEnabled
                  ? Iconsax.notification
                  : Iconsax.notification_bing,
              title: l10n.homePrayerSettingsNotification,
              subtitle: settings.notificationsEnabled
                  ? soundLabel
                  : l10n.homeNotificationSoundMute,
              onTap: () => showPrayerNotificationSheet(context, prayer),
            ),
            SizedBox(height: Spacing.md.h),
            _SettingsCard(
              icon: Iconsax.info_circle,
              title: l10n.homeAboutPrayerTitle(prayerLabel),
              subtitle: l10n.homePrayerSettingsAboutSubtitle,
              onTap: () => Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => HomeAboutPrayerScreen(prayer: prayer),
                ),
              ),
            ),
            SizedBox(height: Spacing.md.h),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(Spacing.md.w),
              decoration: BoxDecoration(
                color: colorScheme.primaryContainer.withValues(
                  alpha: isDark ? 0.28 : 0.4,
                ),
                borderRadius: BorderRadius.circular(16.r),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Iconsax.info_circle,
                    size: 18.sp,
                    color: colorScheme.onPrimaryContainer,
                  ),
                  SizedBox(width: Spacing.sm.w),
                  Expanded(
                    child: Text(
                      l10n.homePrayerSettingsInfoBanner(prayerLabel),
                      style: TextStyle(
                        fontSize: 12.sp,
                        height: 1.35,
                        color: colorScheme.onPrimaryContainer,
                      ),
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

  String _soundLabel(AppLocalizations l10n, PrayerNotificationSound sound) {
    switch (sound) {
      case PrayerNotificationSound.fullAdhan:
        return l10n.homeNotificationSoundFullAdhan;
      case PrayerNotificationSound.beep:
        return l10n.homeNotificationSoundBeep;
      case PrayerNotificationSound.mute:
        return l10n.homeNotificationSoundMute;
    }
  }
}

class _SettingsCard extends StatelessWidget {
  const _SettingsCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);

    return Material(
      color: colorScheme.surface,
      borderRadius: BorderRadius.circular(20.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: borderColor),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.035),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          padding: EdgeInsets.all(Spacing.md.w),
          child: Row(
            children: [
              Container(
                width: 44.r,
                height: 44.r,
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(14.r),
                ),
                child: Icon(icon, size: 20.sp, color: colorScheme.primary),
              ),
              SizedBox(width: Spacing.md.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: Spacing.sm.w),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
