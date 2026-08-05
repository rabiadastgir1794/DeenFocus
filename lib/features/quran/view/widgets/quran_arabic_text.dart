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
  });

  final String text;
  final QuranLayoutTheme layoutTheme;
  final String? fontFamily;
  final double fontSize;
  final double lineHeight;
  final Color color;

  static const _colorBands = <Color>[
    Color(0xFF1565C0),
    Color(0xFF2E7D32),
    Color(0xFF6A1B9A),
    Color(0xFFEF6C00),
    Color(0xFFC62828),
    Color(0xFF00838F),
  ];

  @override
  Widget build(BuildContext context) {
    if (layoutTheme != QuranLayoutTheme.color) {
      return Text(
        text,
        textAlign: TextAlign.right,
        textDirection: TextDirection.rtl,
        style: TextStyle(
          fontFamily: fontFamily,
          fontSize: fontSize,
          height: lineHeight,
          color: color,
        ),
      );
    }

    final words = text.split(RegExp(r'\s+'));
    return RichText(
      textAlign: TextAlign.right,
      textDirection: TextDirection.rtl,
      text: TextSpan(
        children: [
          for (var i = 0; i < words.length; i++) ...[
            if (i > 0) const TextSpan(text: ' '),
            TextSpan(
              text: words[i],
              style: TextStyle(
                fontFamily: fontFamily,
                fontSize: fontSize,
                height: lineHeight,
                color: _colorBands[i % _colorBands.length],
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
