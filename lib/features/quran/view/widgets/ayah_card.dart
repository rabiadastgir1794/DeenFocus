import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/quran_local_repository.dart';

/// Renders a single ayah the same way the original Surah reading screen
/// does (number chip, Arabic text, optional translation, playing state),
/// extracted so the new Juz and Page reading screens don't duplicate this
/// ~60-line block. The Surah screen's own inline version is left untouched.
class AyahCard extends StatelessWidget {
  const AyahCard({
    super.key,
    required this.ayah,
    required this.isCurrent,
    required this.isPlaying,
    required this.showEnglish,
    required this.arabicFontSp,
    required this.englishFontSp,
    required this.lineSpacing,
    required this.onTap,
    this.arabicFontFamily,
    this.surahLabel,
    this.onPracticeTap,
  });

  final AyahRecord ayah;
  final bool isCurrent;
  final bool isPlaying;
  final bool showEnglish;
  final double arabicFontSp;
  final double englishFontSp;
  final double lineSpacing;
  final VoidCallback onTap;
  final String? arabicFontFamily;

  /// When set, shown as a small header above the card — used by Juz/Page
  /// views when a new surah begins within the current reading unit.
  final String? surahLabel;

  /// When set, shows a mic icon that opens AI Tajweed practice for this ayah.
  /// Left null (hidden) when the feature is disabled for the current user.
  final VoidCallback? onPracticeTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (surahLabel != null) ...[
          Padding(
            padding: EdgeInsets.only(bottom: 8.h, top: 4.h),
            child: Text(
              surahLabel!,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.primary,
              ),
            ),
          ),
        ],
        InkWell(
          borderRadius: BorderRadius.circular(16.r),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.r),
              border: Border.all(
                color: isCurrent
                    ? colorScheme.primary.withValues(alpha: 0.5)
                    : colorScheme.outlineVariant.withValues(alpha: 0.4),
              ),
              color: isCurrent
                  ? colorScheme.primary.withValues(alpha: 0.08)
                  : colorScheme.surface,
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 12.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24.w,
                        height: 24.w,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: colorScheme.primary.withValues(alpha: 0.14),
                        ),
                        child: Text(
                          ayah.ayahNumber.toString(),
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w700,
                            color: colorScheme.primary,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (onPracticeTap != null)
                        InkWell(
                          borderRadius: BorderRadius.circular(14.r),
                          onTap: onPracticeTap,
                          child: Padding(
                            padding: EdgeInsets.all(4.w),
                            child: Icon(
                              Icons.mic_none_rounded,
                              color: colorScheme.onSurfaceVariant,
                              size: 18.sp,
                            ),
                          ),
                        ),
                      if (isCurrent)
                        Icon(
                          isPlaying
                              ? Icons.graphic_eq_rounded
                              : Icons.play_arrow_rounded,
                          color: colorScheme.primary,
                          size: 18.sp,
                        ),
                    ],
                  ),
                  SizedBox(height: 10.h),
                  Text(
                    ayah.arabicText,
                    textAlign: TextAlign.right,
                    textDirection: TextDirection.rtl,
                    style: TextStyle(
                      fontFamily: arabicFontFamily,
                      fontSize: arabicFontSp.sp,
                      height: lineSpacing,
                      color: isCurrent
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                  if (showEnglish) ...[
                    SizedBox(height: 10.h),
                    Text(
                      ayah.englishText,
                      style: TextStyle(
                        fontSize: englishFontSp.sp,
                        height: 1.45,
                        color: isCurrent
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
