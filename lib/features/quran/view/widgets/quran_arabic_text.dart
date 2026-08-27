import 'package:flutter/material.dart';

import '../../reading_engine/quran_layout_theme.dart';

/// Arabic ayah body — classic plain text or color-quran word bands.
class QuranArabicText extends StatelessWidget {
  const QuranArabicText({
    super.key,
    required this.text,
    required this.layoutTheme,
    required this.fontFamily,
    required this.fontSize,
    required this.lineHeight,
    required this.color,
    this.fontFamilyFallback,
    this.textAlign = TextAlign.right,
  });

  final String text;
  final QuranLayoutTheme layoutTheme;
  final String? fontFamily;
  final List<String>? fontFamilyFallback;
  final TextAlign textAlign;
  final double fontSize;
  final double lineHeight;
  final Color color;

  static const colorBands = <Color>[
    Color(0xFF1C1C1C), // black
    Color(0xFFC67A3A), // warm orange / brown
    Color(0xFF7A3D9B), // purple
  ];

  TextStyle get _baseStyle => TextStyle(
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        fontSize: fontSize,
        height: lineHeight,
        color: color,
      );

  @override
  Widget build(BuildContext context) {
    if (layoutTheme != QuranLayoutTheme.color) {
      return Text(
        text,
        textAlign: textAlign,
        textDirection: TextDirection.rtl,
        style: _baseStyle,
      );
    }

    final words = text.split(RegExp(r'\s+'));
    return RichText(
      textAlign: textAlign,
      textDirection: TextDirection.rtl,
      text: TextSpan(
        children: [
          for (var i = 0; i < words.length; i++) ...[
            if (i > 0) const TextSpan(text: ' '),
            TextSpan(
              text: words[i],
              style: _baseStyle.copyWith(
                color: colorBands[i % colorBands.length],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
