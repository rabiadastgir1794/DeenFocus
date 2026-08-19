import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../home/view/widgets/home_action_container.dart';

/// List row for learning library items (list → detail navigation).
class LearningItemTile extends StatelessWidget {
  const LearningItemTile({
    super.key,
    required this.title,
    required this.subtitle,
    required this.backgroundColor,
    required this.onTap,
    this.leadingLabel,
    this.leadingArabic,
    this.bookmarked = false,
    this.icon = Icons.menu_book_outlined,
  });

  final String title;
  final String subtitle;
  final Color backgroundColor;
  final VoidCallback onTap;
  final String? leadingLabel;
  final String? leadingArabic;
  final bool bookmarked;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final hasArabic = leadingArabic != null && leadingArabic!.isNotEmpty;

    return HomeActionContainer(
      backgroundColor: backgroundColor,
      title: title,
      subtitle: subtitle,
      icon: icon,
      iconBackground: colorScheme.primary.withValues(alpha: 0.14),
      onTap: onTap,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (bookmarked)
            Padding(
              padding: const EdgeInsets.only(right: 6),
              child: Icon(
                Icons.bookmark,
                size: 18,
                color: AppColors.primary,
              ),
            ),
          if (hasArabic)
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 88),
              child: Text(
                leadingArabic!,
                textAlign: TextAlign.right,
                textDirection: TextDirection.rtl,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontFamily: 'UthmanicHafs',
                      color: AppColors.primary,
                      height: 1.2,
                    ),
              ),
            )
          else if (leadingLabel != null)
            Text(
              leadingLabel!,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: AppColors.primary,
                    fontWeight: FontWeight.w700,
                  ),
            ),
          Icon(
            Icons.chevron_right,
            color: colorScheme.onSurfaceVariant,
          ),
        ],
      ),
    );
  }
}
