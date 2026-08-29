import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../core/constants/spacing.dart';
import '../../../../../core/superwall/premium_gate.dart';
import '../../../../../core/widgets/app_centered_nav_header.dart';
import '../../../../../l10n/app_localizations.dart';
import '../../../helpers/lock_screen_prayer_actions.dart';
import '../../../model/home_models.dart';
import '../../../viewmodel/home_tab_view_model.dart';
import '../../../viewmodel/lock_screen_options_view_model.dart';
import 'lock_screen_style.dart';
import 'lock_screen_style_chrome.dart';
import 'lock_screen_style_experience_screen.dart';
import 'lock_screen_style_views.dart';

/// Full-screen Lock Screen Style picker.
class LockScreenOptionsScreen extends StatefulWidget {
  const LockScreenOptionsScreen({super.key});

  static Future<void> open(BuildContext context) {
    HomeTabViewModel? homeVm;
    try {
      homeVm = context.read<HomeTabViewModel>();
    } on ProviderNotFoundException {
      homeVm = null;
    }
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) {
          final page = ChangeNotifierProvider(
            create: (_) => LockScreenOptionsViewModel()..load(),
            child: const LockScreenOptionsScreen(),
          );
          if (homeVm == null) return page;
          return ChangeNotifierProvider<HomeTabViewModel>.value(
            value: homeVm,
            child: page,
          );
        },
      ),
    );
  }

  @override
  State<LockScreenOptionsScreen> createState() =>
      _LockScreenOptionsScreenState();
}

class _LockScreenOptionsScreenState extends State<LockScreenOptionsScreen> {
  Future<void> _onCardTap(LockScreenStyle style) async {
    final vm = context.read<LockScreenOptionsViewModel>();
    if (vm.selected == style) {
      return;
    }
    if (!style.requiresPremium) {
      await vm.select(style);
      return;
    }
    if (!mounted) return;
    await PremiumGate.presentIfNeeded(
      context: context,
      onAccess: () {
        if (!mounted) return;
        unawaited(vm.select(style));
      },
      debugContext: 'lock_screen_style:${style.name}',
    );
  }

  Future<void> _previewStyle(LockScreenStyle style, TrackablePrayer prayer) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (ctx) {
          Widget page = LockScreenStyleExperienceScreen(
            style: style,
            prayer: prayer,
          );
          try {
            final homeVm = context.read<HomeTabViewModel>();
            page = ChangeNotifierProvider<HomeTabViewModel>.value(
              value: homeVm,
              child: page,
            );
          } on ProviderNotFoundException {
            // Experience still works without a live prayer target.
          }
          return page;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final selected = context.watch<LockScreenOptionsViewModel>().selected;
    try {
      context.watch<HomeTabViewModel>();
    } on ProviderNotFoundException {
      // Picker still works without a live prayer schedule.
    }
    final prayer = LockScreenPrayerActions.resolveDisplayPrayer(context);

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppCenteredNavHeader(
              title: l10n.lockScreenOptionsTitle,
              backLabel: l10n.calendarBack,
              onBack: () => Navigator.of(context).pop(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
              child: Text(
                l10n.lockScreenOptionsSubtitle,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 14,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.62,
                ),
                itemCount: LockScreenStyle.values.length,
                itemBuilder: (context, index) {
                  final style = LockScreenStyle.values[index];
                  return _StyleOptionCard(
                    style: style,
                    selected: style == selected,
                    prayer: prayer,
                    onTap: () => _onCardTap(style),
                    onPreview: () => _previewStyle(style, prayer),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _StyleOptionCard extends StatelessWidget {
  const _StyleOptionCard({
    required this.style,
    required this.selected,
    required this.prayer,
    required this.onTap,
    required this.onPreview,
  });

  final LockScreenStyle style;
  final bool selected;
  final TrackablePrayer prayer;
  final VoidCallback onTap;
  final VoidCallback onPreview;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final title = style.title(l10n);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(22),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: LockScreenPhoneFrame(
                      selected: selected,
                      child: LockScreenMiniPreview(
                        child: LockScreenStyleView(
                          style: style,
                          prayer: prayer,
                          compact: true,
                        ),
                      ),
                    ),
                  ),
                  if (style.isRecommended)
                    PositionedDirectional(
                      top: 10,
                      start: 10,
                      child: _Badge(
                        label: l10n.lockScreenRecommendedBadge,
                        color: const Color(0xFFC62828),
                        onColor: Colors.white,
                      ),
                    ),
                  if (style.isDefault)
                    PositionedDirectional(
                      top: 10,
                      start: 10,
                      child: _Badge(
                        label: l10n.lockScreenDefaultBadge,
                        color: colorScheme.secondary,
                        onColor: colorScheme.onSecondary,
                      ),
                    ),
                  PositionedDirectional(
                    top: 10,
                    end: 10,
                    child: _SelectionRadio(
                      key: ValueKey<String>('lock-screen-radio-${style.name}'),
                      selected: selected,
                    ),
                  ),
                  PositionedDirectional(
                    bottom: 8,
                    end: 8,
                    child: _PreviewIconButton(
                      style: style,
                      tooltip: l10n.lockScreenPreviewLabel,
                      onPressed: onPreview,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: Spacing.sm),
            SizedBox(
              height: 36,
              child: Column(
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.onSurface,
                    ),
                  ),
                  Text(
                    selected
                        ? l10n.lockScreenSelectedBadge
                        : (style.isDefault ? l10n.lockScreenDefaultBadge : ' '),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: selected
                          ? colorScheme.primary
                          : colorScheme.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectionRadio extends StatelessWidget {
  const _SelectionRadio({super.key, required this.selected});

  final bool selected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOutCubic,
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: selected ? colorScheme.primary : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
          color: selected
              ? colorScheme.primary
              : colorScheme.outline.withValues(alpha: 0.85),
          width: selected ? 2 : 1.8,
        ),
        boxShadow: selected
            ? [
                BoxShadow(
                  color: colorScheme.primary.withValues(alpha: 0.35),
                  blurRadius: 8,
                ),
              ]
            : null,
      ),
      child: selected
          ? Icon(Icons.check_rounded, size: 15, color: colorScheme.onPrimary)
          : null,
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.color,
    required this.onColor,
  });

  final String label;
  final Color color;
  final Color onColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: onColor,
          fontWeight: FontWeight.w800,
          fontSize: 10,
        ),
      ),
    );
  }
}

class _PreviewIconButton extends StatelessWidget {
  const _PreviewIconButton({
    required this.style,
    required this.tooltip,
    required this.onPressed,
  });

  final LockScreenStyle style;
  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: colorScheme.surface.withValues(alpha: 0.92),
      shape: const CircleBorder(),
      elevation: 1,
      child: InkWell(
        key: ValueKey<String>('lock-screen-preview-${style.name}'),
        customBorder: const CircleBorder(),
        onTap: onPressed,
        child: SizedBox(
          width: 30,
          height: 30,
          child: Tooltip(
            message: tooltip,
            child: Icon(
              Icons.open_in_full_rounded,
              size: 15,
              color: colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}
