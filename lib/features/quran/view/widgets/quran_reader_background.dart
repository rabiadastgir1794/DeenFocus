import 'package:flutter/material.dart';

import 'quran_reader_theme.dart';

/// Warm parchment background for premium Mushaf reading.
class QuranReaderBackground extends StatelessWidget {
  const QuranReaderBackground({super.key});

  @override
  Widget build(BuildContext context) {
    final palette = context.quranReader;
    return DecoratedBox(
      decoration: BoxDecoration(gradient: palette.backgroundGradient()),
      child: CustomPaint(
        painter: _PaperTexturePainter(accent: palette.accent),
        child: const SizedBox.expand(),
      ),
    );
  }
}

class _PaperTexturePainter extends CustomPainter {
  _PaperTexturePainter({required this.accent});

  final Color accent;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = accent.withValues(alpha: 0.04)
      ..strokeWidth = 0.6;
    const step = 28.0;
    for (var x = 0.0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (var y = 0.0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _PaperTexturePainter oldDelegate) {
    return oldDelegate.accent != accent;
  }
}
