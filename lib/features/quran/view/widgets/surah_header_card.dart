import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/quran_local_repository.dart';
import '../../reading_engine/quran_layout_theme.dart';

/// Decorative surah banner shown at the top of Surah detail reading.
class SurahHeaderCard extends StatelessWidget {
  const SurahHeaderCard({
    super.key,
    required this.surah,
    this.layoutTheme = QuranLayoutTheme.classic,
  });

  final SurahSummary surah;
  final QuranLayoutTheme layoutTheme;

  static const _bismillah = 'بِسْمِ ٱللَّهِ ٱلرَّحْمَـٰنِ ٱلرَّحِيمِ';

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final showBismillah = surah.number != 9;
    final simple = layoutTheme == QuranLayoutTheme.simple;

    if (simple) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 8.h),
        child: Column(
          children: [
            if (showBismillah) ...[
              Text(
                _bismillah,
                textAlign: TextAlign.center,
                textDirection: TextDirection.rtl,
                style: TextStyle(
                  fontSize: 20.sp,
                  height: 1.6,
                  fontWeight: FontWeight.w600,
                  color: colorScheme.onSurface,
                ),
              ),
              SizedBox(height: 10.h),
            ],
            Text(
              '${surah.name}  ·  ${surah.verses} ayahs',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w600,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 22.h),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        children: [
          if (showBismillah) ...[
            Text(
              _bismillah,
              textAlign: TextAlign.center,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontSize: 22.sp,
                height: 1.6,
                fontWeight: FontWeight.w600,
                color: colorScheme.primary,
              ),
            ),
            SizedBox(height: 12.h),
          ],
          Text(
            'SURAH ${surah.number} • ${surah.revelationType.toUpperCase()}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12.sp,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.1,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
