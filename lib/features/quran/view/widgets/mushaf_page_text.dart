import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../l10n/app_localizations.dart';
import '../../data/quran_local_repository.dart';

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

/// Renders one Mushaf page as continuous, justified Arabic text — the same
/// "real printed page" look used by apps like Athan Pro / Muslim Pro —
/// instead of a list of chat-style ayah cards.
///
/// Every word of an ayah (plus its ornate number marker) is one tap target
/// that calls [onAyahTap]: the whole ayah highlights inline. Playback is
/// started separately by the parent screen so selection and audio stay
/// independent.
/// Surah boundaries insert a decorative header banner (+ Bismillah, except
/// for Al-Fatihah — where it's ayah 1 itself — and At-Tawbah, which has
/// none).
class MushafPageText extends StatefulWidget {
  const MushafPageText({
    super.key,
    required this.ayahs,
    required this.playingIndex,
    required this.arabicFontSp,
    required this.lineSpacing,
    required this.surahByNumber,
    required this.onAyahTap,
    this.arabicFontFamily,
  });

  final List<AyahRecord> ayahs;
  final int playingIndex;
  final double arabicFontSp;
  final double lineSpacing;
  final Map<int, SurahSummary> surahByNumber;
  final ValueChanged<int> onAyahTap;
  final String? arabicFontFamily;

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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final ayahs = widget.ayahs;

    final blocks = <Widget>[];
    var groupSpans = <InlineSpan>[];

    void flushGroup() {
      if (groupSpans.isEmpty) return;
      blocks.add(
        Padding(
          padding: EdgeInsets.symmetric(vertical: 6.h),
          child: Text.rich(
            TextSpan(children: List<InlineSpan>.of(groupSpans)),
            textAlign: TextAlign.justify,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: widget.arabicFontFamily,
              fontSize: widget.arabicFontSp.sp,
              height: widget.lineSpacing,
              color: colorScheme.onSurface,
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
          ),
        );
        if (ayah.surahNumber != 9) {
          blocks.add(_BismillahLine(arabicFontFamily: widget.arabicFontFamily));
        }
      }

      final isCurrent = i == widget.playingIndex;
      groupSpans.add(
        TextSpan(
          text: '${ayah.arabicText} ',
          recognizer: _recognizers[i],
          style: TextStyle(
            backgroundColor: isCurrent
                ? colorScheme.primary.withValues(alpha: 0.16)
                : null,
            color: isCurrent ? colorScheme.primary : null,
          ),
        ),
      );
      groupSpans.add(
        WidgetSpan(
          alignment: PlaceholderAlignment.middle,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => widget.onAyahTap(i),
            child: _AyahMarker(number: ayah.ayahNumber, isCurrent: isCurrent),
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
  const _AyahMarker({required this.number, required this.isCurrent});

  final int number;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final color = isCurrent
        ? colorScheme.primary
        : colorScheme.primary.withValues(alpha: 0.6);

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
    this.arabicFontFamily,
  });

  final String surahLabel;
  final int surahNumber;
  final String arabicName;
  final int verseCount;
  final String versesLabel;
  final String? arabicFontFamily;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(vertical: 12.h),
      padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14.r),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.35),
          width: 1.2,
        ),
        color: colorScheme.primary.withValues(alpha: 0.06),
      ),
      child: Column(
        children: [
          Text(
            arabicName,
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontFamily: arabicFontFamily,
              fontSize: 21.sp,
              fontWeight: FontWeight.w700,
              color: colorScheme.primary,
            ),
          ),
          SizedBox(height: 3.h),
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
}

class _BismillahLine extends StatelessWidget {
  const _BismillahLine({this.arabicFontFamily});

  final String? arabicFontFamily;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 10.h),
      child: Text(
        _bismillah,
        textAlign: TextAlign.center,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: arabicFontFamily,
          fontSize: 19.sp,
          fontWeight: FontWeight.w600,
          color: colorScheme.onSurface,
        ),
      ),
    );
  }
}
