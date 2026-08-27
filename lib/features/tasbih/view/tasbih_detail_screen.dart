import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/share/shareable_card.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_centered_nav_header.dart';
import '../../../l10n/app_localizations.dart';
import '../data/tasbih_local_repository.dart';
import 'widgets/tasbih_beads_arc.dart';

class TasbihDetailScreen extends StatefulWidget {
  const TasbihDetailScreen({super.key, required this.item});

  final TasbihItem item;

  @override
  State<TasbihDetailScreen> createState() => _TasbihDetailScreenState();
}

class _TasbihDetailScreenState extends State<TasbihDetailScreen> {
  static const List<int> _goalPresets = <int>[33, 99, 100, 1000];
  static const List<Color> _beadColors = <Color>[
    Color(0xFF4E9A7C),
    Color(0xFF3A3A3A),
    Color(0xFFEDE6DC),
    Color(0xFFC9A227),
    Color(0xFF8B5E3C),
    Color(0xFFC4787A),
  ];

  late TasbihItem _item;
  bool _saving = false;

  int _goal = 33;
  int _countInLoop = 0;
  int _loopsCompleted = 0;
  int _sessionTotal = 0;
  int _beadColorIndex = 0;
  final GlobalKey _shareKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _item = widget.item;
  }

  Color get _beadColor =>
      _beadColors[_beadColorIndex.clamp(0, _beadColors.length - 1)];

  Future<void> _withSaving(Future<void> Function() action) async {
    setState(() => _saving = true);
    try {
      await action();
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _applyBeadCrossings(int delta) {
    if (delta == 0) return;

    setState(() {
      if (delta > 0) {
        for (var i = 0; i < delta; i++) {
          _sessionTotal += 1;
          if (_countInLoop >= _goal) {
            _countInLoop = 1;
            _loopsCompleted += 1;
            HapticFeedback.mediumImpact();
          } else {
            _countInLoop += 1;
          }
        }
        return;
      }

      for (var i = 0; i < -delta; i++) {
        if (_sessionTotal <= 0) break;
        if (_countInLoop > 1) {
          _countInLoop -= 1;
          _sessionTotal -= 1;
        } else if (_countInLoop == 1) {
          if (_loopsCompleted > 0) {
            _loopsCompleted -= 1;
            _countInLoop = _goal;
          } else {
            _countInLoop = 0;
          }
          _sessionTotal -= 1;
        } else if (_loopsCompleted > 0) {
          _loopsCompleted -= 1;
          _countInLoop = _goal;
          _sessionTotal -= 1;
        } else {
          break;
        }
      }
    });
  }

  void _setGoal(int goal) {
    if (goal < 1 || !mounted) return;
    setState(() {
      _goal = goal;
      if (_countInLoop > _goal) {
        _countInLoop = _goal;
      }
    });
  }

  void _restartSession() {
    if (_sessionTotal == 0 && _countInLoop == 0 && _loopsCompleted == 0) {
      return;
    }
    setState(() {
      _countInLoop = 0;
      _loopsCompleted = 0;
      _sessionTotal = 0;
    });
  }

  Future<void> _saveSession() async {
    if (_sessionTotal <= 0) return;
    await _withSaving(() async {
      final total = await TasbihLocalRepository.instance.recordSessionBatch(
        tasbihId: _item.id,
        sessionCount: _sessionTotal,
      );
      if (!mounted) return;
      setState(() {
        _item = _item.copyWith(totalCount: total);
        _countInLoop = 0;
        _loopsCompleted = 0;
        _sessionTotal = 0;
      });
      final l10n = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.tasbihSessionSaved)));
    });
  }

  Future<void> _resetTotal() async {
    await _withSaving(() async {
      await TasbihLocalRepository.instance.resetTotal(_item.id);
      if (!mounted) return;
      setState(() {
        _item = _item.copyWith(totalCount: 0);
        _countInLoop = 0;
        _loopsCompleted = 0;
        _sessionTotal = 0;
      });
    });
  }

  Future<void> _editCustomGoal() async {
    final result = await showDialog<int>(
      context: context,
      builder: (_) => _CustomGoalDialog(initialGoal: _goal),
    );
    if (result != null && mounted) {
      _setGoal(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final softCard = isDark
        ? colorScheme.surfaceContainerHighest
        : AppColors.surfaceLight;

    return Stack(
      children: [
        Scaffold(
          body: SafeArea(
            child: Column(
              children: [
                AppCenteredNavHeader(
                  title: l10n.tasbihTabTitle,
                  subtitle: l10n.tasbihLoopLabel(_loopsCompleted + 1),
                  backLabel: l10n.calendarBack,
                  onBack: () => Navigator.of(context).pop(),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      CardShareIconButton(
                        boundaryKey: _shareKey,
                        iconSize: 22,
                      ),
                      IconButton(
                        tooltip: l10n.tasbihRestart,
                        onPressed: _restartSession,
                        visualDensity: VisualDensity.compact,
                        icon: Icon(
                          Icons.refresh_rounded,
                          color: colorScheme.primary,
                        ),
                      ),
                      PopupMenuButton<_TasbihDetailOption>(
                        padding: EdgeInsets.zero,
                        onSelected: (option) async {
                          if (option == _TasbihDetailOption.resetTotal) {
                            await _resetTotal();
                          }
                        },
                        itemBuilder: (_) => [
                          PopupMenuItem(
                            value: _TasbihDetailOption.resetTotal,
                            child: Text(l10n.tasbihResetTotal),
                          ),
                        ],
                        icon: Icon(
                          Icons.more_horiz_rounded,
                          color: colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: RepaintBoundary(
                    key: _shareKey,
                    child: ColoredBox(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 0),
                            child: Column(
                              children: [
                                Text(
                                  '$_countInLoop',
                                  style: TextStyle(
                                    fontSize: 64.sp,
                                    fontWeight: FontWeight.w700,
                                    color: AppColors.primary,
                                    height: 1,
                                  ),
                                ),
                                SizedBox(height: 4.h),
                                InkWell(
                                  onTap: _editCustomGoal,
                                  borderRadius: BorderRadius.circular(8.r),
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 8.w,
                                      vertical: 4.h,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '/ $_goal',
                                          style: TextStyle(
                                            fontSize: 22.sp,
                                            fontWeight: FontWeight.w600,
                                            color:
                                                colorScheme.onSurfaceVariant,
                                          ),
                                        ),
                                        SizedBox(width: 6.w),
                                        Icon(
                                          Icons.edit_outlined,
                                          size: 16.sp,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(height: 14.h),
                                Wrap(
                                  spacing: 8.w,
                                  runSpacing: 8.h,
                                  alignment: WrapAlignment.center,
                                  children: [
                                    for (final preset in _goalPresets)
                                      _GoalChip(
                                        label: '$preset',
                                        selected: _goal == preset,
                                        onTap: () => _setGoal(preset),
                                      ),
                                    if (!_goalPresets.contains(_goal))
                                      _GoalChip(
                                        label: '$_goal',
                                        selected: true,
                                        onTap: _editCustomGoal,
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20.w),
                            child: SizedBox(
                              height: 148.h,
                              width: double.infinity,
                              child: TasbihBeadsArc(
                                beadColor: _beadColor,
                                onBeadsCrossed: _applyBeadCrossings,
                              ),
                            ),
                          ),
                          SizedBox(height: 8.h),
                          Text(
                            l10n.tasbihSwipeHint,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          SizedBox(height: 12.h),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              for (var i = 0; i < _beadColors.length; i++) ...[
                                if (i > 0) SizedBox(width: 10.w),
                                _ColorDot(
                                  color: _beadColors[i],
                                  selected: _beadColorIndex == i,
                                  onTap: () =>
                                      setState(() => _beadColorIndex = i),
                                ),
                              ],
                            ],
                          ),
                          SizedBox(height: 12.h),
                          Expanded(
                            child: SingleChildScrollView(
                              padding:
                                  EdgeInsets.fromLTRB(20.w, 0, 20.w, 12.h),
                              child: Column(
                                children: [
                                  _DhikrCard(
                                    item: _item,
                                    backgroundColor: softCard,
                                    onViewAll: () =>
                                        Navigator.of(context).pop(),
                                    onSaveSession: _saveSession,
                                  ),
                                  SizedBox(height: 12.h),
                                  Text(
                                    l10n.tasbihSessionSummary(
                                      _sessionTotal,
                                      _goal,
                                      _loopsCompleted,
                                    ),
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 14.sp,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                  if (_item.totalCount > 0) ...[
                                    SizedBox(height: 4.h),
                                    Text(
                                      '${l10n.tasbihGrandTotalLabel}: ${_item.totalCount}',
                                      style: TextStyle(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
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

class _GoalChip extends StatelessWidget {
  const _GoalChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: selected ? AppColors.primary : colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(14.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14.r),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 18.w, vertical: 10.h),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: selected ? Colors.white : colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}

class _ColorDot extends StatelessWidget {
  const _ColorDot({
    required this.color,
    required this.selected,
    required this.onTap,
  });

  final Color color;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final isLight = color.computeLuminance() > 0.85;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 30.w,
        height: 30.w,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: color,
          border: Border.all(
            color: selected
                ? AppColors.primary
                : (isLight
                      ? Colors.black26
                      : Colors.white.withValues(alpha: 0.35)),
            width: selected ? 2.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
      ),
    );
  }
}

class _DhikrCard extends StatelessWidget {
  const _DhikrCard({
    required this.item,
    required this.backgroundColor,
    required this.onViewAll,
    required this.onSaveSession,
  });

  final TasbihItem item;
  final Color backgroundColor;
  final VoidCallback onViewAll;
  final VoidCallback onSaveSession;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 14.h),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                l10n.tasbihCurrentDhikr,
                style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              TextButton(
                onPressed: onViewAll,
                style: TextButton.styleFrom(
                  visualDensity: VisualDensity.compact,
                  foregroundColor: AppColors.primary,
                ),
                child: Text(l10n.tasbihViewAll),
              ),
            ],
          ),
          SizedBox(height: 4.h),
          Text(
            item.label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 26.sp,
              fontWeight: FontWeight.w700,
              height: 1.35,
            ),
          ),
          if (item.transliteration.isNotEmpty) ...[
            SizedBox(height: 6.h),
            Text(
              item.transliteration,
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: AppColors.primary,
              ),
            ),
          ],
          if (item.meaning.isNotEmpty) ...[
            SizedBox(height: 4.h),
            Text(
              item.meaning,
              style: TextStyle(
                fontSize: 14.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
          SizedBox(height: 12.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onSaveSession,
              icon: const Icon(Icons.save_outlined, size: 18),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.primary.withValues(alpha: 0.14),
                foregroundColor: colorScheme.onSurface,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
              label: Text(l10n.tasbihSaveSession),
            ),
          ),
        ],
      ),
    );
  }
}

enum _TasbihDetailOption { resetTotal }

class _CustomGoalDialog extends StatefulWidget {
  const _CustomGoalDialog({required this.initialGoal});

  final int initialGoal;

  @override
  State<_CustomGoalDialog> createState() => _CustomGoalDialogState();
}

class _CustomGoalDialogState extends State<_CustomGoalDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: '${widget.initialGoal}');
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final value = int.tryParse(_controller.text.trim());
    if (value == null || value < 1 || value > 99999) return;
    Navigator.of(context).pop(value);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(l10n.tasbihEditGoalTitle),
      content: TextField(
        controller: _controller,
        keyboardType: TextInputType.number,
        autofocus: true,
        decoration: InputDecoration(hintText: l10n.tasbihCustomGoalHint),
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        onSubmitted: (_) => _save(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.cancel),
        ),
        FilledButton(onPressed: _save, child: Text(l10n.save)),
      ],
    );
  }
}
