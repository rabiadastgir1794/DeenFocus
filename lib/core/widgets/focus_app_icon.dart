import 'dart:typed_data';

import 'package:flutter/material.dart';

class FocusAppIcon extends StatelessWidget {
  const FocusAppIcon({
    super.key,
    required this.label,
    this.iconBytes,
    this.size = 22,
    this.radius = 8,
  });

  final String label;
  final Uint8List? iconBytes;
  final double size;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final bytes = iconBytes;
    if (bytes != null && bytes.isNotEmpty) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
          gaplessPlayback: true,
          errorBuilder: (_, _, _) => _FallbackEmoji(label: label, size: size),
        ),
      );
    }

    return _FallbackEmoji(label: label, size: size);
  }
}

class _FallbackEmoji extends StatelessWidget {
  const _FallbackEmoji({required this.label, required this.size});

  final String label;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Text(_emojiForApp(label), style: TextStyle(fontSize: size));
  }
}

String _emojiForApp(String name) {
  final value = name.toLowerCase();
  if (value.contains('instagram')) return '📷';
  if (value.contains('tiktok')) return '🎵';
  if (value.contains('youtube')) return '▶️';
  if (value.contains('twitter') || value == 'x') return '🐦';
  if (value.contains('snapchat')) return '👻';
  if (value.contains('facebook')) return '📘';
  if (value.contains('reddit')) return '🔴';
  if (value.contains('game')) return '🎮';
  if (value.contains('whatsapp')) return '💬';
  if (value.contains('chrome')) return '🌐';
  return '📱';
}
