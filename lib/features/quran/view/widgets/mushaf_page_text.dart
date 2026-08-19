import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/quran_local_repository.dart';
import '../../reading_engine/quran_layout_theme.dart';
import 'quran_arabic_text.dart';
import 'quran_reader_theme.dart';

const String _bismillah = 'بِسْمِ اللَّهِ الرَّحْمَٰنِ الرَّحِيمِ';
const List<String> _arabicDigitGlyphs = <String>[
  '٠',
  '١',
  '٢',
  '٣',
  '٤',
  '٥',
  '٦',
  '٧',
  '٨',
  '٩',
];

String _toArabicDigits(int number) {
  return number
      .toString()
      .split('')
      .map((d) => _arabicDigitGlyphs[int.parse(d)])
      .join();
}

/// Renders one Mushaf page as continuous, justified Arabic text.
///
/// Respects [layoutTheme]:
/// - Mushaf / Color: ornate continuous page
/// - Simple: plain continuous text, no decorative chrome
/// - Color: per-word color bands (same palette as Surah Color Quran)
class MushafPageText extends StatefulWidget {
  const MushafPageText({
    super.key,
    required this.ayahs,
    required this.playingIndex,
    required this.arabicFontSp,
    required this.lineSpacing,
    required this.surahByNumber,
    required this.onAyahTap,
    this.layoutTheme = QuranLayoutTheme.classic,
    this.arabicFontFamily,
    this.arabicFontFamilyFallback,
  });

  final List<AyahRecord> ayahs;
  final int playingIndex;
  final double arabicFontSp;
  final double lineSpacing;
  final Map<int, SurahSummary> surahByNumber;
  final ValueChanged<int> onAyahTap;
  final QuranLayoutTheme layoutTheme;
  final String? arabicFontFamily;
  final List<String>? arabicFontFamilyFallback;

  @override
  State<MushafPageText> createState() => _MushafPageTextState();
}

class _MushafPageTextState extends State<MushafPageText> {
  List<TapGestureRecognizer> _recognizers = const <TapGestureRecognizer>[];

  @override
  void initState() {
    super.initState();
    _rebuildRecognizers();
  }

  @override
  void didUpdateWidget(covariant MushafPageText oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_sameAyahs(oldWidget.ayahs, widget.ayahs)) {
      _disposeRecognizers();
      _rebuildRecognizers();
    }
  }

  @override
  void dispose() {
    _disposeRecognizers();
    super.dispose();
  }

  bool _sameAyahs(List<AyahRecord> a, List<AyahRecord> b) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (a[i].surahNumber != b[i].surahNumber ||
          a[i].ayahNumber != b[i].ayahNumber) {
        return false;
      }
    }
    return true;
  }

  void _rebuildRecognizers() {
    _recognizers = List<TapGestureRecognizer>.generate(
      widget.ayahs.length,
      (index) => TapGestureRecognizer()..onTap = () => widget.onAyahTap(index),
    );
  }

  void _disposeRecognizers() {
    for (final recognizer in _recognizers) {
      recognizer.dispose();
    }
  }

  List<InlineSpan> _ayahTextSpans({
    required String arabicText,
    required TapGestureRecognizer recognizer,
    required bool isCurrent,
    required Color? highlightColor,
    required Color? highlightBg,
  }) {
    final baseStyle = TextStyle(
      backgroundColor: highlightBg,
      color: isCurrent ? highlightColor : null,
    );

    if (widget.layoutTheme != QuranLayoutTheme.color) {
      return [
        TextSpan(
          text: '$arabicText ',
          recognizer: recognizer,
          style: baseStyle,
        ),
      ];
    }

    final words = arabicText.split(RegExp(r'\s+'));
    final spans = <InlineSpan>[];
    for (var i = 0; i < words.length; i++) {
      if (i > 0) {
        spans.add(TextSpan(text: ' ', recognizer: recognizer, style: baseStyle));
      }
      final wordColor = isCurrent
          ? highlightColor
          : QuranArabicText.colorBands[i % QuranArabicText.colorBands.length];
      spans.add(
        TextSpan(
          text: words[i],
          recognizer: recognizer,
          style: TextStyle(
            backgroundColor: highlightBg,
            color: wordColor,
            fontWeight: FontWeight.w600,
          ),
        ),
      );
    }
    spans.add(TextSpan(text: ' ', recognizer: recognizer, style: baseStyle));
    return spans;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = context.quranReader;
    final colorScheme = Theme.of(context).colorScheme;
    final ayahs = widget.ayahs;
    final simple = widget.layoutTheme == QuranLayoutTheme.simple;
    final defaultTextColor = simple
        ? colorScheme.onSurface
        : palette.textPrimary;

    final blocks = <Widget>[];
    var groupSpans = <InlineSpan>[];

    void flushGroup() {
      if (groupSpans.isEmpty) return;
      blocks.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: simple ? 4.h : 6.h),
          child: Text.rich(
            TextSpan(children: List<InlineSpan>.of(groupSpans)),
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: widget.arabicFontFamily,
              fontFamilyFallback: widget.arabicFontFamilyFallback,
              fontSize: widget.arabicFontSp.sp,
              height: widget.lineSpacing,
              color: defaultTextColor,
            ),
          ),
        ),
      );
      groupSpans = <InlineSpan>[];
    }

    for (var i = 0; i < ayahs.length; i++) {
      final ayah = ayahs[i];

      if (ayah.ayahNumber == 1) {
        flushGroup();
        final surah = widget.surahByNumber[ayah.surahNumber];
        blocks.add(
          _SurahHeaderBanner(
            surahLabel: l10n.quranSurahLabel,
            surahNumber: ayah.surahNumber,
            arabicName: surah?.arabicName ?? '',
            verseCount: surah?.verses ?? 0,
            versesLabel: l10n.quranVersesLabel,
            arabicFontFamily: widget.arabicFontFamily,
            arabicFontFamilyFallback: widget.arabicFontFamilyFallback,
            simple: simple,
          ),
        );
        if (ayah.surahNumber != 9) {
          blocks.add(
            _BismillahLine(
              arabicFontFamily: widget.arabicFontFamily,
              arabicFontFamilyFallback: widget.arabicFontFamilyFallback,
              simple: simple,
            ),
          );
        }
      }

      final isCurrent = i == widget.playingIndex;
      groupSpans.addAll(
        _ayahTextSpans(
          arabicText: ayah.arabicText,
          recognizer: _recognizers[i],
          isCurrent: isCurrent,
          highlightColor: palette.primary,
          highlightBg: isCurrent
              ? palette.primary.withValues(alpha: 0.14)
              : null,
        ),
      );
      groupSpans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => widget.onAyahTap(i),
            child: _AyahMarker(
              number: ayah.ayahNumber,
              isCurrent: isCurrent,
              simple: simple,
            ),
          ),
        ),
      );
      groupSpans.add(const TextSpan(text: '  '));
    }
    flushGroup();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: blocks,
    );
  }
}

class _AyahMarker extends StatelessWidget {
  const _AyahMarker({
    required this.number,
    required this.isCurrent,
    required this.simple,
  });

  final int number;
  final bool isCurrent;
  final bool simple;

  @override
  Widget build(BuildContext context) {
    final palette = context.quranReader;
    final colorScheme = Theme.of(context).colorScheme;
    final color = isCurrent
        ? palette.primary
        : (simple
            ? colorScheme.onSurfaceVariant
            : palette.primary.withValues(alpha: 0.55));

    if (simple) {
      return Padding(
        padding: EdgeInsets.symmetric(horizontal: 2.w),
        child: Text(
          '﴿${_toArabicDigits(number)}﴾',
          textDirection: TextDirection.rtl,
          style: TextStyle(
            fontSize: 12.sp,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
      );
    }

    return Container(
      width: 23.sp,
      height: 23.sp,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: 1.3),
        color: isCurrent ? color.withValues(alpha: 0.14) : Colors.transparent,
      ),
      child: Text(
        _toArabicDigits(number),
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontSize: 10.sp,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }
}

class _SurahHeaderBanner extends StatelessWidget {
  const _SurahHeaderBanner({
    required this.surahLabel,
    required this.surahNumber,
    required this.arabicName,
    required this.verseCount,
    required this.versesLabel,
    required this.simple,
    this.arabicFontFamily,
    this.arabicFontFamilyFallback,
  });

  final String surahLabel;
  final int surahNumber;
  final String arabicName;
  final int verseCount;
  final String versesLabel;
  final bool simple;
  final String? arabicFontFamily;
  final List<String>? arabicFontFamilyFallback;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final palette = context.quranReader;

    if (simple) {
      return Padding(
        padding: EdgeInsets.symmetric(vertical: 10.h),
        child: Column(
          children: [
            Text(
              arabicName,
              textDirection: TextDirection.rtl,
              style: TextStyle(
                fontFamily: arabicFontFamily,
                fontFamilyFallback: arabicFontFamilyFallback,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                color: colorScheme.onSurface,
              ),
            ),
            SizedBox(height: 2.h),
            Text(
              '$surahLabel $surahNumber • $verseCount $versesLabel',
              style: TextStyle(
                fontSize: 11.sp,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 12.h),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: palette.accent.withValues(alpha: 0.45),
          width: 1.2,
        ),
        color: palette.primary.withValues(alpha: 0.06),
      ),
      child: Column(
        children: [
          Text(
            arabicName,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: arabicFontFamily,
              fontFamilyFallback: arabicFontFamilyFallback,
              fontSize: 21.sp,
              fontWeight: FontWeight.w700,
              color: palette.primary,
            ),
          ),
          SizedBox(height: 3.h),
          Text(
            '$surahLabel $surahNumber • $verseCount $versesLabel',
            style: TextStyle(
              fontSize: 11.sp,
              color: palette.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _BismillahLine extends StatelessWidget {
  const _BismillahLine({
    required this.simple,
    this.arabicFontFamily,
    this.arabicFontFamilyFallback,
  });

  final bool simple;
  final String? arabicFontFamily;
  final List<String>? arabicFontFamilyFallback;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final palette = context.quranReader;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: simple ? 8.h : 10.h),
      child: Text(
        _bismillah,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: arabicFontFamily,
          fontFamilyFallback: arabicFontFamilyFallback,
          fontSize: 19.sp,
          fontWeight: FontWeight.w600,
          color: simple ? colorScheme.onSurface : palette.textPrimary,
        ),
      ),
    );
  }
}
