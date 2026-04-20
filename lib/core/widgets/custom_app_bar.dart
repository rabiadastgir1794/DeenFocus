import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({
    super.key,
    required this.title,
    this.actions,
    this.onBack,
    this.showBackButton = true,
  });

  static const double _toolbarHeight = 72;

  final String title;
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
      leadingWidth: showBackButton ? 40 : 16,
      titleSpacing: 4,
      elevation: 0,
      scrolledUnderElevation: 0,
      surfaceTintColor: Colors.transparent,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      leading: showBackButton
          ? Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 0, 16),
              child: IconButton(
                onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 60,
                  height: 40,
                ),
                splashRadius: 20,
                tooltip: MaterialLocalizations.of(context).backButtonTooltip,
                icon: Icon(
                  Icons.chevron_left_rounded,
                  size: 28,
                  color: colorScheme.onSurface,
                ),
              ),
            )
          : null,
      title: Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Text(title, maxLines: 1, overflow: TextOverflow.ellipsis),
      ),
      actionsPadding: const EdgeInsets.fromLTRB(8, 16, 16, 16),
      actions: actions,
    );
  }
}
