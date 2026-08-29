import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../l10n/app_localizations.dart';
import '../../model/home_models.dart';
import '../../viewmodel/home_tab_view_model.dart';

/// Bottom sheet shown when enabling Cycle Mode (or editing an active cycle).
/// Saves [CycleModeData] locally via [HomeTabViewModel.saveCycleMode].
Future<bool> showCycleModeSettingsSheet(
  BuildContext context, {
  bool enabling = true,
}) async {
  final vm = context.read<HomeTabViewModel>();
  final result = await showModalBottomSheet<bool>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (ctx) => ChangeNotifierProvider<HomeTabViewModel>.value(
      value: vm,
      child: _CycleModeSettingsSheetContent(enabling: enabling),
    ),
  );
  return result ?? false;
}

class _CycleModeSettingsSheetContent extends StatefulWidget {
  const _CycleModeSettingsSheetContent({required this.enabling});

  final bool enabling;

  @override
  State<_CycleModeSettingsSheetContent> createState() =>
      _CycleModeSettingsSheetContentState();
}

class _CycleModeSettingsSheetContentState
    extends State<_CycleModeSettingsSheetContent> {
  late DateTime _startDate;
  late DateTime _originalStartDate;
  late bool _wasAlreadyActive;
  late int _cycleLength;
  late bool _pauseStreaks;
  late bool _excludeFromStatistics;

  @override
  void initState() {
    super.initState();
    final current = context.read<HomeTabViewModel>().cycleModeData;
    final today = DateTime.now();
    _wasAlreadyActive = current.isEnabled;
    _originalStartDate = DateTime(
      current.startDate.year,
      current.startDate.month,
      current.startDate.day,
    );
    _startDate = widget.enabling && !current.isEnabled
        ? DateTime(today.year, today.month, today.day)
        : _originalStartDate;
    _cycleLength = current.cycleLength.clamp(
      CycleModeData.minCycleLength,
      CycleModeData.maxCycleLength,
    );
    _pauseStreaks = current.pauseStreaks;
    _excludeFromStatistics = current.excludeFromStatistics;
  }

  bool get _startDateChangedWhileActive =>
      _wasAlreadyActive && !_isSameDay(_startDate, _originalStartDate);

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  Future<void> _pickStartDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _startDate,
      firstDate: DateTime.now().subtract(const Duration(days: 60)),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked == null) return;
    setState(() {
      _startDate = DateTime(picked.year, picked.month, picked.day);
    });
  }

  Future<bool> _confirmStartDateChange() async {
    final l10n = AppLocalizations.of(context)!;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.cycleModeChangeStartDateTitle),
        content: Text(l10n.cycleModeChangeStartDateMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(l10n.cycleModeChangeStartDateConfirm),
          ),
        ],
      ),
    );
    return confirmed == true;
  }

  Future<void> _onSave() async {
    final vm = context.read<HomeTabViewModel>();
    final current = vm.cycleModeData;

    if (_startDateChangedWhileActive) {
      final confirmed = await _confirmStartDateChange();
      if (!confirmed || !mounted) return;
    }

    final CycleModeData next;
    if (current.isEnabled) {
      // Already on — update the active window (extend/shrink, same cycle).
      next = current.updateActiveCycle(
        startDate: _startDate,
        cycleLength: _cycleLength,
        pauseStreaks: _pauseStreaks,
        excludeFromStatistics: _excludeFromStatistics,
      );
    } else if (widget.enabling) {
      // Opened by turning the toggle on — Save activates Cycle Mode.
      next = current.enableWith(
        startDate: _startDate,
        cycleLength: _cycleLength,
        pauseStreaks: _pauseStreaks,
        excludeFromStatistics: _excludeFromStatistics,
      );
    } else {
      // Edit while off — persist preferences only; stay disabled.
      next = current.saveDraft(
        startDate: _startDate,
        cycleLength: _cycleLength,
        pauseStreaks: _pauseStreaks,
        excludeFromStatistics: _excludeFromStatistics,
      );
    }
    await vm.saveCycleMode(next);
    if (mounted) Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cycleModeColor =
        isDark ? const Color(0xFFE59DB7) : const Color(0xFFFF9EC5);
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);
    final dateLabel = DateFormat.yMMMMd(l10n.localeName).format(_startDate);
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return SafeArea(
      top: false,
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomInset),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20.w, 0, 20.w, 32.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: cycleModeColor.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.local_florist_rounded,
                      color: cycleModeColor,
                      size: 22,
                    ),
                  ),
                  SizedBox(width: Spacing.sm.w),
                  Expanded(
                    child: Text(
                      l10n.cycleModeSettingsTitle,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Spacing.lg.h),
              Text(
                l10n.cycleModeStartDateLabel,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: Spacing.sm.h),
              Material(
                color: colorScheme.surfaceContainer,
                borderRadius: BorderRadius.circular(14.r),
                child: InkWell(
                  onTap: _pickStartDate,
                  borderRadius: BorderRadius.circular(14.r),
                  child: Container(
                    width: double.infinity,
                    padding: EdgeInsets.symmetric(
                      horizontal: Spacing.md.w,
                      vertical: Spacing.md.h,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14.r),
                      border: Border.all(color: borderColor),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            dateLabel,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                        ),
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 18,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: Spacing.lg.h),
              Text(
                l10n.cycleModeLengthLabel,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              SizedBox(height: Spacing.sm.h),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Spacing.sm.w,
                  vertical: Spacing.sm.h,
                ),
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(14.r),
                  border: Border.all(color: borderColor),
                ),
                child: Row(
                  children: [
                    _StepperButton(
                      icon: Icons.remove_rounded,
                      enabled: _cycleLength > CycleModeData.minCycleLength,
                      onTap: () => setState(() => _cycleLength -= 1),
                    ),
                    Expanded(
                      child: Text(
                        l10n.cycleModeLengthValue(_cycleLength),
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                    ),
                    _StepperButton(
                      icon: Icons.add_rounded,
                      enabled: _cycleLength < CycleModeData.maxCycleLength,
                      onTap: () => setState(() => _cycleLength += 1),
                    ),
                  ],
                ),
              ),
              SizedBox(height: Spacing.lg.h),
              CheckboxListTile(
                value: _pauseStreaks,
                onChanged: (value) =>
                    setState(() => _pauseStreaks = value ?? true),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: cycleModeColor,
                title: Text(
                  l10n.cycleModePauseStreaksLabel,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  l10n.cycleModeProtectPrayerStreakSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ),
              CheckboxListTile(
                value: _excludeFromStatistics,
                onChanged: (value) =>
                    setState(() => _excludeFromStatistics = value ?? true),
                contentPadding: EdgeInsets.zero,
                controlAffinity: ListTileControlAffinity.leading,
                activeColor: cycleModeColor,
                title: Text(
                  l10n.cycleModeExcludeFromStatisticsLabel,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                subtitle: Text(
                  l10n.cycleModeExcludeFromStatisticsSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.35,
                  ),
                ),
              ),
              SizedBox(height: Spacing.lg.h),
              AppButton(
                label: l10n.cycleModeSaveButton,
                showTrailingIcon: false,
                onPressed: () => unawaited(_onSave()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: enabled
          ? colorScheme.surface
          : colorScheme.surfaceContainerHighest.withValues(alpha: 0.4),
      borderRadius: BorderRadius.circular(12.r),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(12.r),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            color: enabled
                ? colorScheme.onSurface
                : colorScheme.onSurfaceVariant.withValues(alpha: 0.4),
          ),
        ),
      ),
    );
  }
}
