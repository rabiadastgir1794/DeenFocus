import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'quran_reader_theme.dart';

/// Premium Read / Next page action row for Mushaf reader.
class QuranReaderBottomActions extends StatelessWidget {
  const QuranReaderBottomActions({
    super.key,
    required this.readLabel,
    required this.nextLabel,
    required this.onRead,
    required this.onNext,
    this.readCompleted = false,
    this.nextEnabled = true,
  });

  final String readLabel;
  final String nextLabel;
  final VoidCallback? onRead;
  final VoidCallback? onNext;
  final bool readCompleted;
  final bool nextEnabled;

  @override
  Widget build(BuildContext context) {
    final palette = context.quranReader;
    return Padding(
      padding: EdgeInsets.fromLTRB(16.w, 4.h, 16.w, 12.h),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: onRead,
              icon: Icon(
                readCompleted
                    ? Icons.check_circle_rounded
                    : Icons.check_rounded,
                size: 20.sp,
                color: palette.primary,
              ),
              label: Text(readLabel),
              style: OutlinedButton.styleFrom(
                foregroundColor: palette.primary,
                backgroundColor: palette.paper.withValues(alpha: 0.9),
                side: BorderSide(
                  color: palette.primary.withValues(alpha: 0.45),
                ),
                padding: EdgeInsets.symmetric(vertical: 15.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
          SizedBox(width: 12.w),
          Expanded(
            child: FilledButton.icon(
              onPressed: nextEnabled ? onNext : null,
              icon: Icon(Icons.arrow_forward_rounded, size: 20.sp),
              label: Text(nextLabel),
              style: FilledButton.styleFrom(
                backgroundColor: palette.primary,
                foregroundColor: Colors.white,
                disabledBackgroundColor:
                    palette.textSecondary.withValues(alpha: 0.25),
                padding: EdgeInsets.symmetric(vertical: 15.h),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
