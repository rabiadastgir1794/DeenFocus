import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../data/quran_local_repository.dart';
import '../../reading_engine/quran_layout_theme.dart';
import '../../reading_engine/quran_transliteration.dart';
import 'ayah_practice_button.dart';
import 'quran_arabic_text.dart';

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
    required this.showTransliteration,
    required this.layoutTheme,
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
  final bool showTransliteration;
  final QuranLayoutTheme layoutTheme;
  final double arabicFontSp;
  final double englishFontSp;
  final double lineSpacing;
  final VoidCallback onTap;
  final String? arabicFontFamily;

  /// When set, shown as a small header above the card — used by Juz/Page
  /// views when a new surah begins within the current reading unit.
  final String? surahLabel;

  /// Opens AI Tajweed practice — rendered outside the play [onTap] zone.
  final VoidCallback? onPracticeTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSimple = layoutTheme == QuranLayoutTheme.simple;
    final textColor =
        isCurrent ? colorScheme.primary : colorScheme.onSurface;
    final mutedColor = colorScheme.onSurfaceVariant;

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
        if (onPracticeTap != null && isSimple) ...[
          AyahPracticeButton(onPressed: onPracticeTap!),
          SizedBox(height: 8.h),
        ],
        InkWell(
          borderRadius: BorderRadius.circular(isSimple ? 0 : 16.r),
          onTap: onTap,
          child: Ink(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(isSimple ? 0 : 16.r),
              border: isSimple
                  ? null
                  : Border.all(
                      color: isCurrent
                          ? colorScheme.primary.withValues(alpha: 0.55)
                          : colorScheme.outlineVariant.withValues(alpha: 0.65),
                      width: isCurrent ? 1.5 : 1,
                    ),
              color: isSimple
                  ? Colors.transparent
                  : (isCurrent
                      ? colorScheme.primary.withValues(alpha: 0.10)
                      : colorScheme.surfaceContainerHighest
                          .withValues(alpha: 0.45)),
              boxShadow: isSimple
                  ? null
                  : [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 10,
                        offset: const Offset(0, 3),
                      ),
                    ],
            ),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                isSimple ? 2.w : 16.w,
                isSimple ? 10.h : 14.h,
                isSimple ? 2.w : 16.w,
                isSimple ? 10.h : 14.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      if (isSimple)
                        Text(
                          '${ayah.ayahNumber}',
                          style: TextStyle(
                            fontSize: 12.sp,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.2,
                            color: mutedColor,
                          ),
                        )
                      else
                        Container(
                          width: 28.w,
                          height: 28.w,
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: colorScheme.primary.withValues(alpha: 0.14),
                            border: Border.all(
                              color: colorScheme.primary.withValues(alpha: 0.25),
                            ),
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
                  SizedBox(height: isSimple ? 8.h : 12.h),
                  QuranArabicText(
                    text: ayah.arabicText,
                    layoutTheme: layoutTheme,
                    fontFamily: arabicFontFamily,
                    fontSize: arabicFontSp.sp,
                    lineHeight: lineSpacing,
                    color: textColor,
                  ),
                  if (showTransliteration) ...[
                    SizedBox(height: 8.h),
                    Text(
                      QuranTransliteration.of(ayah.arabicText),
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: (englishFontSp - 1).sp,
                        height: 1.4,
                        fontStyle: FontStyle.italic,
                        color: mutedColor,
                      ),
                    ),
                  ],
                  if (showEnglish && ayah.englishText.trim().isNotEmpty) ...[
                    SizedBox(height: isSimple ? 8.h : 10.h),
                    Text(
                      ayah.englishText,
                      style: TextStyle(
                        fontSize: englishFontSp.sp,
                        height: 1.45,
                        color: textColor,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (isSimple)
          Divider(
            height: 20.h,
            thickness: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.45),
          ),
        if (onPracticeTap != null && !isSimple) ...[
          SizedBox(height: 10.h),
          AyahPracticeButton(onPressed: onPracticeTap!),
        ],
      ],
    );
  }
}
