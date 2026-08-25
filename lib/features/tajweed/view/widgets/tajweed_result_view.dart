import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../model/tajweed_models.dart';
import '../../model/tajweed_practice_args.dart';
import '../../viewmodel/tajweed_practice_view_model.dart';

/// Post-scoring results screen — layout only; scoring data unchanged.
class TajweedResultView extends StatelessWidget {
  const TajweedResultView({
    super.key,
    required this.viewModel,
    required this.args,
    required this.onDone,
  });

  final TajweedPracticeViewModel viewModel;
  final TajweedPracticeArgs args;
  final VoidCallback onDone;

  Color _statusColor(ColorScheme colorScheme, TajweedTokenStatus status) {
    switch (status) {
      case TajweedTokenStatus.ok:
        return const Color(0xFF2E7D32);
      case TajweedTokenStatus.minor:
      case TajweedTokenStatus.major:
        return const Color(0xFFF9A825);
      case TajweedTokenStatus.sub:
        return colorScheme.error;
      case TajweedTokenStatus.miss:
        return colorScheme.onSurfaceVariant;
      case TajweedTokenStatus.extra:
        return const Color(0xFF6A1B9A);
    }
  }

  Color _statusTileBg(TajweedTokenStatus status) {
    switch (status) {
      case TajweedTokenStatus.ok:
        return const Color(0xFFE8F5E9);
      case TajweedTokenStatus.minor:
      case TajweedTokenStatus.major:
        return const Color(0xFFFFF8E1);
      case TajweedTokenStatus.sub:
        return const Color(0xFFFFEBEE);
      case TajweedTokenStatus.miss:
        return const Color(0xFFF5F5F5);
      case TajweedTokenStatus.extra:
        return const Color(0xFFF3E5F5);
    }
  }

  String _feedbackText(AppLocalizations? l10n, TajweedScoreResult result) {
    if (result.exactMatch) return 'Exact match — mā shā\' Allāh!';
    final pct = result.wordAccuracy * 100;
    if (pct >= 85) {
      return l10n?.tajweedResultEncouragement ??
          'Beautiful effort — keep practicing your tajweed.';
    }
    if (pct >= 65) {
      return 'Good progress — focus on clear pronunciation on highlighted words.';
    }
    return 'Keep practicing — listen to the reference and try again.';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final l10n = AppLocalizations.of(context);
    final result = viewModel.result;
    if (result == null) return const SizedBox.shrink();

    final accuracy = result.wordAccuracy.clamp(0.0, 1.0);
    final accuracyPercent = (accuracy * 100).round();
    final summary = result.tokenSummary;
    final ayahTokens = result.tokens
        .where((t) => t.status != TajweedTokenStatus.extra)
        .toList(growable: false);

    return SafeArea(
      child: ListView(
        padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 20.h),
        children: [
          Center(
            child: SizedBox(
              width: 148.r,
              height: 148.r,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 148.r,
                    height: 148.r,
                    child: CircularProgressIndicator(
                      value: accuracy,
                      strokeWidth: 10.r,
                      backgroundColor:
                          colorScheme.surfaceContainerHighest.withValues(alpha: 0.8),
                      color: result.exactMatch
                          ? const Color(0xFF2E7D32)
                          : colorScheme.primary,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$accuracyPercent%',
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onSurface,
                        ),
                      ),
                      SizedBox(height: 2.h),
                      Text(
                        l10n?.tajweedWordAccuracyLabel ?? 'WORD ACCURACY',
                        style: theme.textTheme.labelSmall?.copyWith(
                          letterSpacing: 0.8,
                          fontWeight: FontWeight.w700,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 16.h),
          Text(
            _feedbackText(l10n, result),
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              height: 1.45,
            ),
          ),
          SizedBox(height: 20.h),
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(16.w, 14.h, 16.w, 16.h),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.3),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n?.tajweedWordReviewLabel ?? 'WORD REVIEW',
                  style: theme.textTheme.labelSmall?.copyWith(
                    letterSpacing: 0.8,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
                SizedBox(height: 12.h),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Wrap(
                    spacing: 8.w,
                    runSpacing: 8.h,
                    alignment: WrapAlignment.center,
                    children: [
                      for (final token in ayahTokens)
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 12.w,
                            vertical: 10.h,
                          ),
                          decoration: BoxDecoration(
                            color: _statusTileBg(token.status),
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          child: Text(
                            token.text,
                            textDirection: TextDirection.rtl,
                            style: TextStyle(
                              fontFamily: args.arabicFontFamily,
                              fontFamilyFallback: args.arabicFontFamilyFallback,
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w600,
                              color: _statusColor(colorScheme, token.status),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 14.h),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: Column(
              children: [
                _StatRow(
                  color: _statusColor(colorScheme, TajweedTokenStatus.ok),
                  label: 'Correct',
                  count: summary.ok,
                ),
                Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.25)),
                _StatRow(
                  color: _statusColor(colorScheme, TajweedTokenStatus.minor),
                  label: 'Pronunciation',
                  count: summary.minor + summary.major,
                ),
                Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.25)),
                _StatRow(
                  color: _statusColor(colorScheme, TajweedTokenStatus.sub),
                  label: 'Wrong word',
                  count: summary.sub,
                ),
                Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.25)),
                _StatRow(
                  color: _statusColor(colorScheme, TajweedTokenStatus.miss),
                  label: 'Missed',
                  count: summary.miss,
                ),
                Divider(height: 1, color: colorScheme.outlineVariant.withValues(alpha: 0.25)),
                _StatRow(
                  color: _statusColor(colorScheme, TajweedTokenStatus.extra),
                  label: 'Extra',
                  count: summary.extra,
                ),
              ],
            ),
          ),
          SizedBox(height: 24.h),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => viewModel.tryAgain(),
                  icon: const Icon(Icons.replay_rounded),
                  label: const Text('Try again'),
                  style: OutlinedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: FilledButton.icon(
                  onPressed: onDone,
                  icon: const Icon(Icons.check_rounded),
                  label: const Text('Done'),
                  style: FilledButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14.h),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14.r),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.color,
    required this.label,
    required this.count,
  });

  final Color color;
  final String label;
  final int count;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
      child: Row(
        children: [
          Container(
            width: 10.r,
            height: 10.r,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: colorScheme.onSurface,
              ),
            ),
          ),
          Text(
            '$count',
            style: TextStyle(
              fontSize: 15.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
