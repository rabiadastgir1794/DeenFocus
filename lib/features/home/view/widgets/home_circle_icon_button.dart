import 'package:flutter/material.dart';

class HomeCircleIconButton extends StatelessWidget {
  const HomeCircleIconButton({
    super.key,
    this.icon,
    this.imagePath,
    required this.onTap,
  }) : assert(icon != null || imagePath != null);

  final IconData? icon;
  final String? imagePath;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(999),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: colorScheme.primaryContainer,
        ),
        child: imagePath != null
            ? Padding(
                padding: const EdgeInsets.all(8),
                child: Image.asset(
                  imagePath!,
                  fit: BoxFit.contain,
                  color: colorScheme.primary,
                ),
              )
            : Icon(icon, size: 18, color: colorScheme.primary),
      ),
    );
  }
}
