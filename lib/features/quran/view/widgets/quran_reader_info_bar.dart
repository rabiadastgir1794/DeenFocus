import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import 'quran_reader_theme.dart';

/// Juz, page, and reading-progress strip below the reader app bar.
class QuranReaderInfoBar extends StatelessWidget {
  const QuranReaderInfoBar({
    super.key,
    required this.juzNumber,
    required this.pageNumber,
    required this.progress,
    this.surahLabel,
  });

  final int juzNumber;
  final int pageNumber;
  final double progress;
  final String? surahLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.quranReader;
    final pct = (progress.clamp(0.0, 1.0) * 100).round();

    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 10.h, 16.w, 8.h),
      child: AnimatedContainer(
        duration: QuranReaderPalette.animDuration,
        curve: QuranReaderPalette.animCurve,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        decoration: palette.glassDecoration(radius: 18),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (surahLabel != null) ...[
                    Text(
                      surahLabel!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13.sp,
                        fontWeight: FontWeight.w700,
                        color: palette.textPrimary,
                      ),
                    ),
                    SizedBox(height: 6.h),
                  ],
                  Row(
                    children: [
                      _InfoChip(
                        label: l10n.quranJuzLabel,
                        value: '$juzNumber',
                      ),
                      SizedBox(width: 8.w),
                      _InfoChip(
                        label: l10n.quranPageLabel,
                        value: '$pageNumber',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(width: 12.w),
            SizedBox(
              width: 56.r,
              height: 56.r,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    width: 56.r,
                    height: 56.r,
                    child: CircularProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      strokeWidth: 4.r,
                      backgroundColor: palette.accent.withValues(alpha: 0.22),
                      color: palette.primary,
                    ),
                  ),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        '$pct%',
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w800,
                          color: palette.primary,
                        ),
                      ),
                      Text(
                        'GOAL',
                        style: TextStyle(
                          fontSize: 8.sp,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: palette.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  const _InfoChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final palette = context.quranReader;
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: palette.background.withValues(alpha: 0.65),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: palette.accent.withValues(alpha: 0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: palette.textSecondary,
            ),
          ),
          SizedBox(width: 6.w),
          Text(
            value,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w800,
              color: palette.textPrimary,
            ),
          ),
        ],
      ),
    );
  }
}
