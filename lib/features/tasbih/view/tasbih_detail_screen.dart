import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/custom_app_bar.dart';
import '../../../l10n/app_localizations.dart';
import '../data/tasbih_local_repository.dart';

class TasbihDetailScreen extends StatefulWidget {
  const TasbihDetailScreen({super.key, required this.item});

  final TasbihItem item;

  @override
  State<TasbihDetailScreen> createState() => _TasbihDetailScreenState();
}

class _TasbihDetailScreenState extends State<TasbihDetailScreen> {
  static const int _sessionGoal = 100;

  late TasbihItem _item;
  bool _saving = false;
  bool _autoCompletingCycle = false;
  int _sessionCount = 0;

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  Future<void> _withSaving(Future<void> Function() action) async {
    setState(() => _saving = true);
    try {
      await action();
    } finally {
      if (mounted) {
        setState(() => _saving = false);
      }
    }
  }

  Future<void> _saveSession() async {
    if (_sessionCount <= 0) return;

    await _withSaving(() async {
      await TasbihLocalRepository.instance.recordSessionBatch(
        tasbihId: _item.id,
        sessionCount: _sessionCount,
      );
      if (!mounted) return;
      setState(() => _sessionCount = 0);
    });
  }

  /// Writes session history for any unsaved taps (totals already persisted per tap).
  Future<void> _flushPendingSession() async {
    if (_sessionCount <= 0) return;
    try {
      await TasbihLocalRepository.instance.recordSessionBatch(
        tasbihId: _item.id,
        sessionCount: _sessionCount,
      );
      if (mounted) setState(() => _sessionCount = 0);
    } catch (_) {}
  }

  void _popAfterFrame() {
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.of(context).pop();
    });
  }

  Future<void> _handleBack() async {
    await _flushPendingSession();
    if (!mounted) return;
    _popAfterFrame();
  }

  Future<void> _persistTap() async {
    final total = await TasbihLocalRepository.instance.incrementTap(_item.id);
    if (mounted) setState(() => _item = _item.copyWith(totalCount: total));
  }

  Future<void> _completeCycleIfNeeded() async {
    if (_autoCompletingCycle || _sessionCount < _sessionGoal) return;
    _autoCompletingCycle = true;
    try {
      await TasbihLocalRepository.instance.recordSessionBatch(
        tasbihId: _item.id,
        sessionCount: _sessionGoal,
      );
      if (!mounted) return;
      setState(() => _sessionCount = 0);
    } finally {
      _autoCompletingCycle = false;
    }
  }

  void _handleTap() {
    if (_autoCompletingCycle) return;
    final nextCount = _sessionCount + 1;
    setState(() => _sessionCount = nextCount);
    unawaited(_persistTap());
    if (nextCount >= _sessionGoal) {
      unawaited(_completeCycleIfNeeded());
    }
  }

  Future<void> _resetTotal() async {
    await _withSaving(() async {
      await TasbihLocalRepository.instance.resetTotal(_item.id);
      if (!mounted) return;
      setState(() {
        _item = _item.copyWith(totalCount: 0);
        _sessionCount = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final sessionCycleCount = _sessionCount % _sessionGoal;
    final progress = _sessionCount == 0
        ? 0.0
        : (sessionCycleCount == 0 ? 1.0 : sessionCycleCount / _sessionGoal);
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardBorderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);
    final mutedCardColor = colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.22,
    );
    final saveBackgroundColor = colorScheme.primary.withValues(alpha: 0.14);
    final saveForegroundColor = isDark
        ? colorScheme.onSurface
        : AppColors.onPrimaryContainerLight;

    return Stack(
      children: [
        PopScope(
          canPop: _sessionCount == 0,
          onPopInvokedWithResult: (didPop, result) {
            if (didPop) return;
            unawaited(
              _flushPendingSession().then((_) {
                if (!context.mounted) return;
                SchedulerBinding.instance.addPostFrameCallback((_) {
                  if (!context.mounted) return;
                  Navigator.of(context).pop(result);
                });
              }),
            );
          },
          child: Scaffold(
            appBar: CustomAppBar(
              title: "Tasbih",
              onBack: () => Navigator.of(context).pop(),
            ),
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
                child: Column(
                  children: [
                    Row(
                      children: [
                        const Spacer(),
                        PopupMenuButton<_TasbihDetailOption>(
                          tooltip: MaterialLocalizations.of(
                            context,
                          ).moreButtonTooltip,
                          padding: EdgeInsets.zero,
                          onSelected: (option) async {
                            if (option == _TasbihDetailOption.resetTotal) {
                              await _resetTotal();
                            }
                          },
                          itemBuilder: (_) => [
                            PopupMenuItem<_TasbihDetailOption>(
                              value: _TasbihDetailOption.resetTotal,
                              child: Text(l10n.tasbihResetTotal),
                            ),
                          ],
                          icon: Icon(
                            Icons.more_horiz_rounded,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8.h),
                    Text(
                      _item.label,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(flex: 2),
                    SizedBox(
                      width: 280.w,
                      height: 280.w,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            width: 280.w,
                            height: 280.w,
                            child: CircularProgressIndicator(
                              value: 1,
                              strokeWidth: 10,
                              color: colorScheme.surfaceContainerHighest,
                            ),
                          ),
                          SizedBox(
                            width: 280.w,
                            height: 280.w,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 10,
                              color: colorScheme.primary,
                            ),
                          ),
                          Material(
                            elevation: 8,
                            shape: const CircleBorder(),
                            color: colorScheme.surface,
                            child: InkWell(
                              customBorder: const CircleBorder(),
                              onTap: _handleTap,
                              child: SizedBox(
                                width: 215.w,
                                height: 215.w,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '$_sessionCount',
                                      style: TextStyle(
                                        fontSize: 54.sp,
                                        fontWeight: FontWeight.w700,
                                        color: colorScheme.onSurface,
                                      ),
                                    ),
                                    SizedBox(height: 6.h),
                                    Text(
                                      l10n.tasbihTapMe,
                                      style: TextStyle(
                                        fontSize: 12.sp,
                                        color: colorScheme.onSurfaceVariant,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _resetTotal,
                            icon: const Icon(Icons.rotate_left_rounded),
                            style: OutlinedButton.styleFrom(
                              minimumSize: Size(double.infinity, 56.h),
                              side: BorderSide(color: cardBorderColor),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.r),
                              ),
                              backgroundColor: mutedCardColor,
                              foregroundColor: colorScheme.onSurface,
                            ),
                            label: Text(
                              l10n.tasbihReset,
                              style: TextStyle(
                                fontSize: 15.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        SizedBox(width: 10.w),
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: _saveSession,
                            icon: const Icon(Icons.save_outlined),
                            style: FilledButton.styleFrom(
                              minimumSize: Size(double.infinity, 56.h),
                              backgroundColor: saveBackgroundColor,
                              foregroundColor: saveForegroundColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.r),
                              ),
                              elevation: 0,
                            ),
                            label: Text(
                              l10n.save,
                              style: TextStyle(
                                fontSize: 15.sp,
                                color: colorScheme.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        if (_saving)
          ColoredBox(
            color: Colors.black.withValues(alpha: 0.15),
            child: const Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

enum _TasbihDetailOption { resetTotal }
