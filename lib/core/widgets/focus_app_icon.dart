import 'dart:typed_data';

import 'package:flutter/material.dart';

class FocusAppIcon extends StatelessWidget {
  const FocusAppIcon({
    super.key,
    required this.label,
    this.iconBytes,
    this.size = 22,
    this.radius = 8,
    this.isLocked = false,
  });

  final String label;
  final Uint8List? iconBytes;
  final double size;
  final double radius;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    final bytes = iconBytes;
    final Widget icon;
    if (bytes != null && bytes.isNotEmpty) {
      icon = ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: Image.memory(
          bytes,
          width: size,
          height: size,
          fit: BoxFit.cover,
          filterQuality: FilterQuality.low,
          cacheWidth: (size * 2).round(),
          cacheHeight: (size * 2).round(),
          gaplessPlayback: true,
          errorBuilder: (_, _, _) => _FallbackEmoji(label: label, size: size),
        ),
      );
    } else {
      icon = _FallbackEmoji(label: label, size: size);
    }

    if (!isLocked) return icon;

    final colorScheme = Theme.of(context).colorScheme;
    final badgeSize = (size * 0.48).clamp(11.0, 15.0);
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          icon,
          PositionedDirectional(
            end: 0,
            bottom: 0,
            child: Container(
              width: badgeSize,
              height: badgeSize,
              decoration: BoxDecoration(
                color: colorScheme.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: colorScheme.shadow.withValues(alpha: 0.18),
                    blurRadius: 2,
                  ),
                ],
              ),
              child: Icon(
                Icons.lock_rounded,
                size: badgeSize * 0.72,
                color: colorScheme.error,
              ),
            ),
          ),
        ],
      ),
    );
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
