import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';

import '../model/focus_models.dart';
import '../viewmodel/focus_controller.dart';

class FocusTabScreen extends StatefulWidget {
  const FocusTabScreen({super.key});

  @override
  State<FocusTabScreen> createState() => _FocusTabScreenState();
}

class _FocusTabScreenState extends State<FocusTabScreen> {
  bool _showGlobalSelector = false;

  @override
  Widget build(BuildContext context) {
    return Consumer<FocusController>(
      builder: (context, vm, _) {
        final colorScheme = Theme.of(context).colorScheme;
        final globalApps = vm.settings.selectedApps.entries
            .map(
              (entry) => _SelectedAppChipData(
                packageName: entry.key,
                label: entry.value,
              ),
            )
            .toList(growable: false);
        final isIosSelection =
            defaultTargetPlatform == TargetPlatform.iOS &&
            vm.settings.iosSelectionCount > 0;
        final enabledMode = vm.settings.enabledMode;
        final childActive =
            enabledMode == FocusModeType.child && globalApps.isNotEmpty;
        final salahMode = enabledMode == FocusModeType.salah;
        final nightMode = enabledMode == FocusModeType.nightDiscipline;
        final childMode = enabledMode == FocusModeType.child;

        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Focus',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Protect your spiritual moments',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 24),
                  if (childActive)
                    _ChildModeBanner(
                      appCount: globalApps.length,
                      colorScheme: colorScheme,
                    ),
                  _GlassCard(
                    marginBottom: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Apps to Block',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Applies to all focus modes',
                                    style: Theme.of(context).textTheme.bodySmall
                                        ?.copyWith(
                                          fontSize: 12,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.1,
                                ),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '${globalApps.length} app${globalApps.length == 1 ? '' : 's'}',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: colorScheme.primary,
                                      fontWeight: FontWeight.w700,
                                    ),
                              ),
                            ),
                          ],
                        ),
                        if (isIosSelection) ...[
                          const SizedBox(height: 12),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.1,
                                  ),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Text(
                                      '📱',
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      '${vm.settings.iosSelectionCount} iOS app${vm.settings.iosSelectionCount == 1 ? '' : 's'} selected',
                                      style: Theme.of(context)
                                          .textTheme
                                          .labelMedium
                                          ?.copyWith(
                                            fontWeight: FontWeight.w500,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ] else if (globalApps.isNotEmpty) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            height: 44,
                            child: ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: globalApps.length,
                              separatorBuilder: (_, _) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, index) {
                                final app = globalApps[index];
                                return Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 8,
                                  ),
                                  decoration: BoxDecoration(
                                    color: colorScheme.primary.withValues(
                                      alpha: 0.1,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _emojiForApp(app.label),
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        app.label,
                                        style: Theme.of(context)
                                            .textTheme
                                            .labelMedium
                                            ?.copyWith(
                                              fontWeight: FontWeight.w500,
                                            ),
                                      ),
                                      const SizedBox(width: 8),
                                      InkWell(
                                        onTap: () =>
                                            _removeSelectedApp(vm, app),
                                        child: Icon(
                                          Icons.close,
                                          size: 14,
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                        const SizedBox(height: 12),
                        InkWell(
                          onTap: () async {
                            if (defaultTargetPlatform == TargetPlatform.iOS) {
                              await vm.requestInstalledApps();
                              return;
                            }
                            if (!_showGlobalSelector) {
                              await vm.requestInstalledApps();
                            }
                            if (!mounted) return;
                            setState(() {
                              _showGlobalSelector = !_showGlobalSelector;
                            });
                          },
                          borderRadius: BorderRadius.circular(14),
                          child: Ink(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: colorScheme.surfaceContainerHighest
                                  .withValues(alpha: 0.5),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Text(
                                    'Select Apps to Block',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                                if (vm.isLoadingApps)
                                  const SizedBox(
                                    width: 14,
                                    height: 14,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                    ),
                                  )
                                else
                                  Text(
                                    defaultTargetPlatform == TargetPlatform.iOS
                                        ? 'Open'
                                        : _showGlobalSelector
                                        ? 'Hide'
                                        : 'Show',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          color: colorScheme.onSurfaceVariant,
                                        ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        if (defaultTargetPlatform == TargetPlatform.iOS) ...[
                          const SizedBox(height: 12),
                          Text(
                            'On iOS, Apple shows a native Screen Time picker. The app receives the selected opaque tokens and selected app count, not a normal installed-app name list.',
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ] else if (_showGlobalSelector) ...[
                          const SizedBox(height: 12),
                          _AppsGrid(vm: vm),
                        ],
                      ],
                    ),
                  ),
                  _ModeCard(
                    marginBottom: 16,
                    icon: Icons.shield_outlined,
                    iconBackground: colorScheme.primary.withValues(alpha: 0.1),
                    iconColor: colorScheme.primary,
                    title: 'Salah Focus Mode',
                    subtitle: 'Block apps during prayer',
                    value: salahMode,
                    onChanged: (value) =>
                        _toggleMode(vm, FocusModeType.salah, value),
                    child: salahMode
                        ? _ModeFooterText(
                            text:
                                '✓ ${globalApps.length} app${globalApps.length == 1 ? '' : 's'} will be blocked during prayer times',
                            color: colorScheme.primary,
                          )
                        : null,
                  ),
                  _ModeCard(
                    marginBottom: 16,
                    icon: Icons.dark_mode_outlined,
                    iconBackground: colorScheme.secondaryContainer.withValues(
                      alpha: 0.45,
                    ),
                    iconColor: colorScheme.onSecondaryContainer,
                    title: 'Night Discipline',
                    subtitle: 'Protect sleep & Fajr',
                    value: nightMode,
                    onChanged: (value) =>
                        _toggleMode(vm, FocusModeType.nightDiscipline, value),
                    child: nightMode
                        ? Column(
                            children: [
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _TimeInfoCard(
                                      label: 'Sleep',
                                      time: _formatTime(
                                        context,
                                        vm.settings.nightRange.startHour,
                                        vm.settings.nightRange.startMinute,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _TimeInfoCard(
                                      label: 'Wake',
                                      time: _formatTime(
                                        context,
                                        vm.settings.nightRange.endHour,
                                        vm.settings.nightRange.endMinute,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              _ModeFooterText(
                                text:
                                    '✓ ${globalApps.length} app${globalApps.length == 1 ? '' : 's'} will be blocked at night',
                                color: colorScheme.primary,
                              ),
                            ],
                          )
                        : null,
                  ),
                  _ModeCard(
                    icon: Icons.child_care_outlined,
                    iconBackground: colorScheme.error.withValues(alpha: 0.1),
                    iconColor: colorScheme.error,
                    title: 'Child Mode',
                    subtitle: 'Block apps immediately',
                    value: childMode,
                    onChanged: (value) =>
                        _toggleMode(vm, FocusModeType.child, value),
                    child: childMode
                        ? _ModeFooterText(
                            text:
                                '⚠ ${globalApps.length} app${globalApps.length == 1 ? '' : 's'} blocked immediately',
                            color: colorScheme.error,
                          )
                        : null,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _toggleMode(
    FocusController vm,
    FocusModeType mode,
    bool enabled,
  ) async {
    if (enabled) {
      await vm.enableMode(mode);
      return;
    }
    await vm.disableMode(mode);
  }

  Future<void> _removeSelectedApp(
    FocusController vm,
    _SelectedAppChipData app,
  ) async {
    final remaining = vm.settings.selectedApps.entries
        .where((entry) => entry.key != app.packageName)
        .map(
          (entry) => FocusInstalledApp(
            packageName: entry.key,
            appName: entry.value,
            isSystemApp: false,
          ),
        )
        .toList(growable: false);
    await vm.setSelectedApps(remaining);
  }

  String _formatTime(BuildContext context, int hour, int minute) {
    return MaterialLocalizations.of(
      context,
    ).formatTimeOfDay(TimeOfDay(hour: hour, minute: minute));
  }

  String _emojiForApp(String name) {
    final value = name.toLowerCase();
    if (value.contains('instagram')) return '📷';
    if (value.contains('tiktok')) return '🎵';
    if (value.contains('youtube')) return '▶️';
    if (value.contains('twitter') || value.contains('x')) return '🐦';
    if (value.contains('snapchat')) return '👻';
    if (value.contains('facebook')) return '📘';
    if (value.contains('reddit')) return '🔴';
    if (value.contains('game')) return '🎮';
    if (value.contains('whatsapp')) return '💬';
    if (value.contains('chrome')) return '🌐';
    return '📱';
  }
}

class _ChildModeBanner extends StatelessWidget {
  const _ChildModeBanner({required this.appCount, required this.colorScheme});

  final int appCount;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: colorScheme.error.withValues(alpha: 0.1),
        border: Border.all(color: colorScheme.error.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Icon(Icons.warning_amber_rounded, size: 18, color: colorScheme.error),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Child Mode Active',
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 2),
                Text(
                  '$appCount app${appCount == 1 ? '' : 's'} blocked immediately',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 11,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GlassCard extends StatelessWidget {
  const _GlassCard({required this.child, this.marginBottom = 0});

  final Widget child;
  final double marginBottom;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      margin: EdgeInsets.only(bottom: marginBottom),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: colorScheme.surface.withValues(alpha: 0.75),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: child,
    );
  }
}

class _ModeCard extends StatelessWidget {
  const _ModeCard({
    required this.icon,
    required this.iconBackground,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
    this.child,
    this.marginBottom = 0,
  });

  final IconData icon;
  final Color iconBackground;
  final Color iconColor;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;
  final Widget? child;
  final double marginBottom;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return _GlassCard(
      marginBottom: marginBottom,
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 20, color: iconColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 12,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Switch(value: value, onChanged: onChanged),
            ],
          ),
          if (child != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
              ),
              child: child!,
            ),
          ],
        ],
      ),
    );
  }
}

class _ModeFooterText extends StatelessWidget {
  const _ModeFooterText({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.bodySmall?.copyWith(
        fontSize: 11,
        color: color,
        fontWeight: FontWeight.w500,
      ),
    );
  }
}

class _TimeInfoCard extends StatelessWidget {
  const _TimeInfoCard({required this.label, required this.time});

  final String label;
  final String time;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerHighest.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              fontSize: 11,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            time,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ),
    );
  }
}

class _AppsGrid extends StatelessWidget {
  const _AppsGrid({required this.vm});

  final FocusController vm;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final apps = vm.installedApps;

    if (vm.isLoadingApps) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 20),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (apps.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(top: 4),
        child: Text(
          'No installed apps available to show.',
          style: Theme.of(
            context,
          ).textTheme.bodySmall?.copyWith(color: colorScheme.onSurfaceVariant),
        ),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: apps.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        childAspectRatio: 0.82,
      ),
      itemBuilder: (context, index) {
        final app = apps[index];
        final selected = vm.settings.selectedApps.containsKey(app.packageName);
        return InkWell(
          onTap: () async {
            final updated = <FocusInstalledApp>[
              for (final item in apps)
                if (vm.settings.selectedApps.containsKey(item.packageName) &&
                    item.packageName != app.packageName)
                  item,
            ];
            if (!selected) updated.add(app);
            await vm.setSelectedApps(updated);
          },
          borderRadius: BorderRadius.circular(14),
          child: Ink(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: selected
                  ? colorScheme.primary.withValues(alpha: 0.15)
                  : colorScheme.surfaceContainerHighest.withValues(alpha: 0.5),
              border: Border.all(
                color: selected
                    ? colorScheme.primary.withValues(alpha: 0.3)
                    : Colors.transparent,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _emojiForApp(app.appName),
                  style: const TextStyle(fontSize: 22),
                ),
                const SizedBox(height: 6),
                Text(
                  app.appName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
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
}

class _SelectedAppChipData {
  const _SelectedAppChipData({required this.packageName, required this.label});

  final String packageName;
  final String label;
}
