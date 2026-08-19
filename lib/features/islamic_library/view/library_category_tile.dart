import 'package:flutter/material.dart';

import '../../../features/home/view/widgets/home_action_container.dart';

class LibraryCategoryTile extends StatelessWidget {
  const LibraryCategoryTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.onTap,
    this.icon = Icons.format_quote_outlined,
  });

  final String title;
  final String subtitle;
  final Color backgroundColor;
  final VoidCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return HomeActionContainer(
      backgroundColor: backgroundColor,
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconBackground: colorScheme.primary.withValues(alpha: 0.14),
      onTap: onTap,
    );
  }
}
