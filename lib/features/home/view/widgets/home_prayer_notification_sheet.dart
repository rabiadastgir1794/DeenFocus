import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:iconsax_flutter/iconsax_flutter.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/services/prayer_alarm_enablement.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_centered_nav_header.dart';
import '../../../../core/widgets/app_permission_dialog.dart';
import '../../../../l10n/app_localizations.dart';
import '../../helpers/prayer_label_helper.dart';
import '../../model/home_models.dart';
import '../../viewmodel/home_tab_view_model.dart';

/// Lets the user pick a notification sound (or mute) and enable/disable
/// soft notifications and native prayer alarms independently for [prayer].
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

class _PrayerNotificationSheetContent extends StatefulWidget {
  const _PrayerNotificationSheetContent({required this.prayer});

  final TrackablePrayer prayer;

  @override
  State<_PrayerNotificationSheetContent> createState() =>
      _PrayerNotificationSheetContentState();
}

class _PrayerNotificationSheetContentState
    extends State<_PrayerNotificationSheetContent> {
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    // Pick up OS permission + master/auth changes made elsewhere.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final vm = context.read<HomeTabViewModel>();
      unawaited(vm.refreshPrayerAlarmGate());
      unawaited(vm.refreshNotificationPermissionGate());
    });
  }

  Future<void> _onNotificationChanged(bool value) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final vm = context.read<HomeTabViewModel>();
      final ok = await vm.setPrayerNotificationEnabled(widget.prayer, value);
      if (!ok && mounted) {
        await _showNotificationDeniedDialog();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _onAlarmChanged(bool value) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final vm = context.read<HomeTabViewModel>();
      final status = await vm.setPrayerAlarmEnabled(widget.prayer, value);
      if (!mounted) return;
      if (status == PrayerAlarmEnablementStatus.denied ||
          status == PrayerAlarmEnablementStatus.notificationDenied) {
        await _showAlarmDeniedDialog();
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _showAlarmDeniedDialog() async {
    final l10n = AppLocalizations.of(context)!;
    await AppPermissionDialog.show(
      context,
      title: l10n.prayerAlarmsDeniedTitle,
      message: l10n.prayerAlarmsDeniedMessage,
      primaryButtonText: l10n.prayerAlarmsOpenSettings,
      secondaryButtonText: l10n.prayerAlarmsCancel,
      onPrimaryTap: () {
        unawaited(PermissionService.openAppSettingsAsync());
      },
      onSecondaryTap: () {},
    );
  }

  Future<void> _showNotificationDeniedDialog() async {
    final l10n = AppLocalizations.of(context)!;
    await AppPermissionDialog.show(
      context,
      title: l10n.prayerAlarmsDeniedTitle,
      message: l10n.prayerAlarmsDeniedMessage,
      primaryButtonText: l10n.prayerAlarmsOpenSettings,
      secondaryButtonText: l10n.prayerAlarmsCancel,
      onPrimaryTap: () {
        unawaited(PermissionService.openAppSettingsAsync());
      },
      onSecondaryTap: () {},
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<HomeTabViewModel>();
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prayerLabel = widget.prayer.label(l10n);
    final settings = vm.settingsFor(widget.prayer);
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);

    return SafeArea(
      top: false,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppCenteredNavHeader(
            title: l10n.homeNotificationForPrayer(prayerLabel),
            backLabel: l10n.calendarBack,
            onBack: () => Navigator.of(context).pop(),
          ),
          Flexible(
            child: SingleChildScrollView(
              padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 32.h),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: Spacing.md.h),
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
                              settings.sound ==
                              PrayerNotificationSound.fullAdhan,
                          onTap: () => vm.setPrayerNotificationSound(
                            widget.prayer,
                            PrayerNotificationSound.fullAdhan,
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        _SoundTile(
                          icon: Iconsax.notification,
                          title: l10n.homeNotificationSoundBeep,
                          subtitle: l10n.homeNotificationSoundBeepSubtitle,
                          selected:
                              settings.sound == PrayerNotificationSound.beep,
                          onTap: () => vm.setPrayerNotificationSound(
                            widget.prayer,
                            PrayerNotificationSound.beep,
                          ),
                        ),
                        Divider(
                          height: 1,
                          thickness: 1,
                          indent: 16,
                          endIndent: 16,
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.3,
                          ),
                        ),
                        _SoundTile(
                          icon: Iconsax.volume_slash,
                          title: l10n.homeNotificationSoundMute,
                          subtitle: l10n.homeNotificationSoundMuteSubtitle,
                          selected:
                              settings.sound == PrayerNotificationSound.mute,
                          onTap: () => vm.setPrayerNotificationSound(
                            widget.prayer,
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
                                l10n.homeNotificationEnableSubtitle(
                                  prayerLabel,
                                ),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: vm.effectiveNotificationEnabledFor(
                            widget.prayer,
                          ),
                          onChanged: _busy
                              ? null
                              : (value) => unawaited(
                                  _onNotificationChanged(value),
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
                                l10n.homePrayerAlarmEnableLabel,
                                style: Theme.of(context).textTheme.titleSmall
                                    ?.copyWith(fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 2.h),
                              Text(
                                l10n.homePrayerAlarmEnableSubtitle(prayerLabel),
                                style: Theme.of(context).textTheme.bodySmall
                                    ?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: vm.effectiveAlarmEnabledFor(widget.prayer),
                          onChanged: _busy
                              ? null
                              : (value) => unawaited(_onAlarmChanged(value)),
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
          ),
        ],
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
