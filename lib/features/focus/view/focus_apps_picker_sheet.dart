import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/widgets/focus_app_icon.dart';
import '../../../l10n/app_localizations.dart';
import '../model/focus_models.dart';
import '../viewmodel/focus_controller.dart';

/// Android app-selection UI shared by Focus Mode and onboarding.
///
/// Selections are read/written through [FocusController] so Focus and
/// onboarding stay synchronized via `focus_settings_json`.
class FocusAppsPickerSheet extends StatelessWidget {
  const FocusAppsPickerSheet({super.key});

  /// Presents the picker as a modal bottom sheet (Android Focus-equivalent UI).
  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (sheetContext) {
        return const FocusAppsPickerSheet();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final maxHeight = MediaQuery.sizeOf(context).height * 0.78;

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: ConstrainedBox(
        constraints: BoxConstraints(maxHeight: maxHeight),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: colorScheme.outlineVariant.withValues(alpha: 0.8),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.focusSelectAppsToBlock,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: Text(l10n.focusDone),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: FocusAppsGrid(
                  onAppToggle: (app) =>
                      context.read<FocusController>().toggleSelectedApp(app),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Horizontal installed-apps grid used by Focus Mode and the picker sheet.
class FocusAppsGrid extends StatelessWidget {
  const FocusAppsGrid({super.key, required this.onAppToggle});

  final Future<void> Function(FocusInstalledApp app) onAppToggle;
  static const int _maxRows = 5;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return Selector<
      FocusController,
      ({bool loading, List<FocusInstalledApp> apps})
    >(
      selector: (_, vm) => (loading: vm.isLoadingApps, apps: vm.installedApps),
      builder: (context, data, _) {
        if (data.loading) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Center(child: CircularProgressIndicator()),
                const SizedBox(height: 12),
                Text(
                  l10n.focusLoadingInstalledApps,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          );
        }

        if (data.apps.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              l10n.focusNoInstalledAppsToShow,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
            ),
          );
        }

        final maxHeight = MediaQuery.sizeOf(context).height * 0.58;
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: SizedBox(
            width: double.infinity,
            height: maxHeight.clamp(280.0, 460.0),
            child: GridView.builder(
              scrollDirection: Axis.horizontal,
              clipBehavior: Clip.hardEdge,
              itemCount: data.apps.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: _maxRows,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                mainAxisExtent: 88,
              ),
              itemBuilder: (context, index) {
                final app = data.apps[index];
                return RepaintBoundary(
                  key: ValueKey<String>('focus-app-${app.packageName}'),
                  child: _FocusGridAppTile(
                    app: app,
                    colorScheme: colorScheme,
                    onTap: onAppToggle,
                  ),
                );
              },
            ),
          ),
        );
      },
    );
  }
}

class _FocusGridAppTile extends StatelessWidget {
  const _FocusGridAppTile({
    required this.app,
    required this.colorScheme,
    required this.onTap,
  });

  final FocusInstalledApp app;
  final ColorScheme colorScheme;
  final Future<void> Function(FocusInstalledApp app) onTap;

  @override
  Widget build(BuildContext context) {
    final tileState = context
        .select<FocusController, ({bool selected, bool locked})>((vm) {
          final selected = vm.settings.selectedApps.containsKey(
            app.packageName,
          );
          return (selected: selected, locked: selected && vm.isAppsLocked);
        });
    final selected = tileState.selected;
    final locked = tileState.locked;
    final textStyle = Theme.of(
      context,
    ).textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w500);
    final selectedColor = locked
        ? colorScheme.errorContainer.withValues(alpha: 0.32)
        : colorScheme.primary.withValues(alpha: 0.15);
    final unselectedColor = colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.5,
    );
    final selectedBorderColor = locked
        ? colorScheme.error.withValues(alpha: 0.3)
        : colorScheme.primary.withValues(alpha: 0.3);
    return InkWell(
      onTap: () => unawaited(onTap(app)),
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          color: selected ? selectedColor : unselectedColor,
          border: Border.all(
            color: selected ? selectedBorderColor : Colors.transparent,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FocusAppIcon(
              label: app.appName,
              iconBytes: app.iconBytes,
              size: 28,
              radius: 10,
              isLocked: locked,
            ),
            const SizedBox(height: 6),
            Text(
              app.appName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
              style: textStyle,
            ),
          ],
        ),
      ),
    );
  }
}
