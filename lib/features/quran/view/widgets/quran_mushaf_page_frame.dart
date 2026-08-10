import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'quran_reader_theme.dart';

/// Soft paper card wrapping Mushaf page content.
class QuranMushafPageFrame extends StatelessWidget {
  const QuranMushafPageFrame({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final palette = context.quranReader;
    return AnimatedContainer(
      duration: QuranReaderPalette.animDuration,
      curve: QuranReaderPalette.animCurve,
      margin: EdgeInsets.symmetric(horizontal: 14.w, vertical: 6.h),
      decoration: BoxDecoration(
        color: palette.paper,
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: palette.accent.withValues(alpha: 0.18)),
        boxShadow: palette.pageShadow,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20.r),
        child: Padding(
          padding: EdgeInsets.fromLTRB(18.w, 20.h, 18.w, 24.h),
          child: child,
        ),
      ),
    );
  }
}
