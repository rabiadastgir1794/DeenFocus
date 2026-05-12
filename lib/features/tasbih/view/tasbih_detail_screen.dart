import 'dart:async';

import 'package:flutter/material.dart';
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
      final total = await TasbihLocalRepository.instance.recordSessionBatch(
        tasbihId: _item.id,
        sessionCount: _sessionCount,
      );
      if (!mounted) return;
      setState(() {
        _item = _item.copyWith(totalCount: total);
        _sessionCount = 0;
      });
    });
  }

  void _handleTap() {
    if (_sessionCount >= _sessionGoal) return;
    setState(() => _sessionCount += 1);
  }

  void _restartSession() {
    if (_sessionCount == 0) return;
    setState(() => _sessionCount = 0);
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
    final progress = (_sessionCount / _sessionGoal).clamp(0.0, 1.0);
    final canTapCounter = _sessionCount < _sessionGoal;
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
          canPop: true,
          onPopInvokedWithResult: (_, _) {},
          child: Scaffold(
            appBar: CustomAppBar(
              title: l10n.tasbihTabTitle,
              onBack: () => Navigator.of(context).pop(),
              actions: [
                PopupMenuButton<_TasbihDetailOption>(
                  tooltip: MaterialLocalizations.of(context).moreButtonTooltip,
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
            body: SafeArea(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
                child: Column(
                  children: [
                    Text(
                      _item.label,
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 28.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    if (_item.transliteration.isNotEmpty) ...[
                      SizedBox(height: 8.h),
                      Text(
                        _item.transliteration,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    if (_item.meaning.isNotEmpty) ...[
                      SizedBox(height: 6.h),
                      Text(
                        _item.meaning,
                        textAlign: TextAlign.center,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                    Expanded(
                      child: Align(
                        alignment: const Alignment(-0.04, -0.45),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 240.w,
                              height: 240.w,
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  SizedBox(
                                    width: 240.w,
                                    height: 240.w,
                                    child: CircularProgressIndicator(
                                      value: 1,
                                      strokeWidth: 10,
                                      color:
                                          colorScheme.surfaceContainerHighest,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 240.w,
                                    height: 240.w,
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
                                      onTap: canTapCounter ? _handleTap : null,
                                      child: SizedBox(
                                        width: 182.w,
                                        height: 182.w,
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              '$_sessionCount',
                                              style: TextStyle(
                                                fontSize: 50.sp,
                                                fontWeight: FontWeight.w700,
                                                color: colorScheme.onSurface,
                                              ),
                                            ),
                                            SizedBox(height: 6.h),
                                            Text(
                                              l10n.tasbihTapMe,
                                              style: TextStyle(
                                                fontSize: 12.sp,
                                                color: colorScheme
                                                    .onSurfaceVariant,
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
                            SizedBox(height: 16.h),
                            Text(
                              l10n.tasbihGrandTotalLabel,
                              style: TextStyle(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.w600,
                                color: colorScheme.onSurfaceVariant,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              _item.totalCount.toString(),
                              style: TextStyle(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w700,
                                color: colorScheme.primary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _restartSession,
                            icon: const Icon(Icons.replay_rounded),
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
                              l10n.tasbihRestart,
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
