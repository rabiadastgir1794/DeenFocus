import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../helpers/prayer_label_helper.dart';
import '../../model/home_models.dart';
import '../../viewmodel/home_tab_view_model.dart';
import 'prayer_sheet_back_button.dart';

/// Lets the user override the calculated time for a single prayer, e.g. to
/// match their local masjid. The override applies only to [prayer].
Future<void> showEditPrayerTimeSheet(
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
      child: _EditPrayerTimeSheetContent(prayer: prayer),
    ),
  );
}

class _EditPrayerTimeSheetContent extends StatefulWidget {
  const _EditPrayerTimeSheetContent({required this.prayer});

  final TrackablePrayer prayer;

  @override
  State<_EditPrayerTimeSheetContent> createState() =>
      _EditPrayerTimeSheetContentState();
}

class _EditPrayerTimeSheetContentState
    extends State<_EditPrayerTimeSheetContent> {
  late DateTime _selectedTime;

  @override
  void initState() {
    super.initState();
    final vm = context.read<HomeTabViewModel>();
    final slot = vm.prayerTimes?.slots
        .where((item) => item.id == widget.prayer.homePrayerId)
        .firstOrNull;
    _selectedTime = slot?.time ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final vm = context.watch<HomeTabViewModel>();
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final prayerLabel = widget.prayer.label(l10n);
    final hasCustomTime =
        vm.settingsFor(widget.prayer).customTimeMinutes != null;
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
                    l10n.homeEditPrayerTimeTitle(prayerLabel),
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: Spacing.lg.h),
            Text(
              l10n.homeEditPrayerTimeCurrent,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Spacing.sm.h),
            Container(
              padding: EdgeInsets.symmetric(
                horizontal: Spacing.md.w,
                vertical: Spacing.sm.h + 2.h,
              ),
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(14.r),
                border: Border.all(color: borderColor),
              ),
              child: Text(
                DateFormat.jm(l10n.localeName).format(_selectedTime),
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ),
            SizedBox(height: Spacing.lg.h),
            Text(
              l10n.homeEditPrayerTimeSelectNew,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            SizedBox(height: Spacing.sm.h),
            Container(
              height: 180.h,
              decoration: BoxDecoration(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(20.r),
                border: Border.all(color: borderColor),
              ),
              child: CupertinoTheme(
                data: CupertinoThemeData(
                  textTheme: CupertinoTextThemeData(
                    dateTimePickerTextStyle: TextStyle(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.w600,
                      color: colorScheme.onSurface,
                    ),
                  ),
                ),
                child: CupertinoDatePicker(
                  mode: CupertinoDatePickerMode.time,
                  use24hFormat: false,
                  initialDateTime: _selectedTime,
                  onDateTimeChanged: (value) =>
                      setState(() => _selectedTime = value),
                ),
              ),
            ),
            SizedBox(height: Spacing.md.h),
            Text(
              l10n.homeEditPrayerTimeNote(prayerLabel),
              style: TextStyle(
                fontSize: 12.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            SizedBox(height: Spacing.lg.h),
            AppButton(
              label: l10n.homeEditPrayerTimeSave,
              showTrailingIcon: false,
              onPressed: () async {
                final minutes = _selectedTime.hour * 60 + _selectedTime.minute;
                await vm.setPrayerCustomTime(widget.prayer, minutes);
                if (context.mounted) Navigator.of(context).pop();
              },
            ),
            if (hasCustomTime) ...[
              SizedBox(height: Spacing.sm.h),
              Center(
                child: TextButton(
                  onPressed: () async {
                    await vm.setPrayerCustomTime(widget.prayer, null);
                    if (context.mounted) Navigator.of(context).pop();
                  },
                  child: Text(l10n.homeEditPrayerTimeReset),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
