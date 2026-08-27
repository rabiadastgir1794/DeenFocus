import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.subtitle,
    this.actions,
    this.onBack,
    this.showBackButton = true,
  });

  static const double _toolbarHeight = 72;

  final String title;
  final String? subtitle;
  final List<Widget>? actions;
  final VoidCallback? onBack;
  final bool showBackButton;

  @override
  Size get preferredSize => const Size.fromHeight(_toolbarHeight);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AppBar(
      automaticallyImplyLeading: false,
      toolbarHeight: _toolbarHeight,
      titleSpacing: 0,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,

      // 🚀 ONE clickable area
      title: InkWell(
        onTap: onBack ?? () => Navigator.of(context).maybePop(),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (showBackButton) ...[
                Icon(
                  Icons.chevron_left_rounded,
                  size: 28,
                  color: colorScheme.onSurface,
                ),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),

      actionsPadding: const EdgeInsets.fromLTRB(4, 8, 8, 8),
      actions: actions,
    );
  }
}
