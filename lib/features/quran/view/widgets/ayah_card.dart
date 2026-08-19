import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/quran_local_repository.dart';
import '../../reading_engine/quran_layout_theme.dart';
import '../../reading_engine/quran_transliteration.dart';
import 'quran_arabic_text.dart';

enum AyahCardStyle { classic, surahDetail }

/// Renders a single ayah for Surah / Juz / Page reading screens.
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
    this.style = AyahCardStyle.classic,
    this.arabicFontFamily,
    this.arabicFontFamilyFallback,
    this.surahLabel,
    this.onPracticeTap,
    this.onBookmarkTap,
    this.isBookmarked = false,
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
  final AyahCardStyle style;
  final String? arabicFontFamily;
  final List<String>? arabicFontFamilyFallback;
  final String? surahLabel;
  final VoidCallback? onPracticeTap;
  final VoidCallback? onBookmarkTap;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    if (style == AyahCardStyle.surahDetail) {
      return _SurahDetailAyahCard(
        ayah: ayah,
        isCurrent: isCurrent,
        isPlaying: isPlaying,
        showEnglish: showEnglish,
        showTransliteration: showTransliteration,
        layoutTheme: layoutTheme,
        arabicFontSp: arabicFontSp,
        englishFontSp: englishFontSp,
        lineSpacing: lineSpacing,
        onPlayTap: onTap,
        arabicFontFamily: arabicFontFamily,
        arabicFontFamilyFallback: arabicFontFamilyFallback,
        surahLabel: surahLabel,
        onPracticeTap: onPracticeTap,
        onBookmarkTap: onBookmarkTap,
        isBookmarked: isBookmarked,
      );
    }

    return _ClassicAyahCard(
      ayah: ayah,
      isCurrent: isCurrent,
      isPlaying: isPlaying,
      showEnglish: showEnglish,
      showTransliteration: showTransliteration,
      layoutTheme: layoutTheme,
      arabicFontSp: arabicFontSp,
      englishFontSp: englishFontSp,
      lineSpacing: lineSpacing,
      onTap: onTap,
      arabicFontFamily: arabicFontFamily,
      arabicFontFamilyFallback: arabicFontFamilyFallback,
      surahLabel: surahLabel,
      onPracticeTap: onPracticeTap,
    );
  }
}

class _SurahDetailAyahCard extends StatelessWidget {
  const _SurahDetailAyahCard({
    required this.ayah,
    required this.isCurrent,
    required this.isPlaying,
    required this.showEnglish,
    required this.showTransliteration,
    required this.layoutTheme,
    required this.arabicFontSp,
    required this.englishFontSp,
    required this.lineSpacing,
    required this.onPlayTap,
    this.arabicFontFamily,
    this.arabicFontFamilyFallback,
    this.surahLabel,
    this.onPracticeTap,
    this.onBookmarkTap,
    this.isBookmarked = false,
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
  final VoidCallback onPlayTap;
  final String? arabicFontFamily;
  final List<String>? arabicFontFamilyFallback;
  final String? surahLabel;
  final VoidCallback? onPracticeTap;
  final VoidCallback? onBookmarkTap;
  final bool isBookmarked;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final simple = layoutTheme == QuranLayoutTheme.simple;
    final textColor =
        isCurrent ? colorScheme.primary : colorScheme.onSurface;
    final mutedColor = colorScheme.onSurfaceVariant;
    final chipBg = colorScheme.secondaryContainer.withValues(alpha: 0.55);

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            if (simple)
              Text(
                '${ayah.ayahNumber}',
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w700,
                  color: mutedColor,
                ),
              )
            else
              Container(
                width: 30.w,
                height: 30.w,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: chipBg,
                  shape: BoxShape.circle,
                ),
                child: Text(
                  '${ayah.ayahNumber}',
                  style: TextStyle(
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w700,
                    color: colorScheme.secondary,
                  ),
                ),
              ),
            const Spacer(),
            _ActionIcon(
              icon: isPlaying && isCurrent
                  ? Icons.pause_circle_filled_rounded
                  : Icons.volume_up_rounded,
              onTap: onPlayTap,
              color: isCurrent
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
            ),
            if (onPracticeTap != null) ...[
              SizedBox(width: 4.w),
              _ActionIcon(
                icon: Icons.mic_rounded,
                onTap: onPracticeTap!,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
            if (onBookmarkTap != null) ...[
              SizedBox(width: 4.w),
              _ActionIcon(
                icon: isBookmarked
                    ? Icons.bookmark_rounded
                    : Icons.bookmark_border_rounded,
                onTap: onBookmarkTap!,
                color: isBookmarked
                    ? colorScheme.primary
                    : colorScheme.onSurfaceVariant,
              ),
            ],
          ],
        ),
        SizedBox(height: 12.h),
        QuranArabicText(
          text: ayah.arabicText,
          layoutTheme: layoutTheme,
          fontFamily: arabicFontFamily,
          fontFamilyFallback: arabicFontFamilyFallback,
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
          SizedBox(height: 10.h),
          Text(
            ayah.englishText,
            style: TextStyle(
              fontSize: englishFontSp.sp,
              height: 1.45,
              color: textColor,
            ),
          ),
        ],
        if (onPracticeTap != null) ...[
          SizedBox(height: 14.h),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: onPracticeTap,
              icon: Icon(Icons.mic_rounded, size: 18.sp),
              label: Text(l10n.quranReciteCheckTajweed),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                foregroundColor: colorScheme.onPrimary,
                padding: EdgeInsets.symmetric(vertical: 12.h),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14.r),
                ),
              ),
            ),
          ),
        ],
      ],
    );

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
        if (simple) ...[
          Padding(
            padding: EdgeInsets.fromLTRB(2.w, 8.h, 2.w, 8.h),
            child: body,
          ),
          Divider(
            height: 1,
            thickness: 1,
            color: colorScheme.outlineVariant.withValues(alpha: 0.4),
          ),
        ] else
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surface,
              borderRadius: BorderRadius.circular(18.r),
              border: Border.all(
                color: isCurrent
                    ? colorScheme.primary.withValues(alpha: 0.45)
                    : colorScheme.outlineVariant.withValues(alpha: 0.45),
              ),
            ),
            padding: EdgeInsets.fromLTRB(14.w, 12.h, 14.w, 14.h),
            child: body,
          ),
      ],
    );
  }
}

class _ActionIcon extends StatelessWidget {
  const _ActionIcon({
    required this.icon,
    required this.onTap,
    required this.color,
  });

  final IconData icon;
  final VoidCallback onTap;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.35),
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: Padding(
          padding: EdgeInsets.all(7.r),
          child: Icon(icon, size: 18.sp, color: color),
        ),
      ),
    );
  }
}

class _ClassicAyahCard extends StatelessWidget {
  const _ClassicAyahCard({
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
    this.arabicFontFamilyFallback,
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
  final List<String>? arabicFontFamilyFallback;
  final String? surahLabel;
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
          _PracticeButton(onPressed: onPracticeTap!),
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
                    fontFamilyFallback: arabicFontFamilyFallback,
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
          _PracticeButton(onPressed: onPracticeTap!),
        ],
      ],
    );
  }
}

class _PracticeButton extends StatelessWidget {
  const _PracticeButton({required this.onPressed});

  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      child: FilledButton.tonalIcon(
        onPressed: onPressed,
        icon: Icon(Icons.record_voice_over_rounded, size: 20.sp),
        label: Text(
          'Practice Tajweed',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            fontSize: 14.sp,
            color: colorScheme.onPrimaryContainer,
          ),
        ),
        style: FilledButton.styleFrom(
          backgroundColor: colorScheme.primaryContainer,
          foregroundColor: colorScheme.onPrimaryContainer,
          padding: EdgeInsets.symmetric(vertical: 12.h),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.r),
          ),
        ),
      ),
    );
  }
}
