import 'package:flutter/material.dart';

/// Cherry-blossom mark for Cycle Mode (inside the pink rounded square).
class CycleModeFlowerIcon extends StatelessWidget {
  const CycleModeFlowerIcon({
    super.key,
    required this.color,
    this.size = 18,
  });

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Icon(Icons.local_florist_rounded, size: size, color: color);
  }
}
