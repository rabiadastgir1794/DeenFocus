import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../features/focus/view/focus_tab_screen.dart';
import '../../../features/home/view/home_tab_screen.dart';
import '../../../features/home/view/settings/settings_tab_screen.dart';
import '../../../features/quran/view/quran_tab_screen.dart';
import '../../../features/tasbih/view/tasbih_tab_screen.dart';
import '../../../l10n/app_localizations.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;
  final Set<int> _visitedIndexes = <int>{0};

  static const List<_AppTab> _tabs = <_AppTab>[
    _AppTab(id: 'home', icon: Icons.home_outlined),
    _AppTab(id: 'focus', icon: Icons.shield_outlined),
    _AppTab(id: 'tasbih', icon: Icons.trip_origin),
    _AppTab(id: 'quran', icon: Icons.menu_book_outlined),
    _AppTab(id: 'settings', icon: Icons.settings_outlined),
  ];

  void _onDestinationSelected(int index) {
    // Tabs are not gated by Superwall — paywalls are surfaced by the
    // individual premium features themselves (AI chat, prayer streak,
    // focus mode app/enable flows).
    if (!mounted) return;
    setState(() {
      _currentIndex = index;
      _visitedIndexes.add(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    const selectedNavColor = AppColors.primary;
    final backgroundColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.25)
        : AppColors.outlineVariantLight.withValues(alpha: 0.25);
    final pages = List<Widget>.generate(_tabs.length, _buildTabPage);

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBarTheme(
        data: NavigationBarThemeData(
          backgroundColor: backgroundColor,
          indicatorColor: selectedNavColor.withValues(alpha: 0.18),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((states) {
            final isSelected = states.contains(WidgetState.selected);
            return IconThemeData(
              color: isSelected
                  ? selectedNavColor
                  : colorScheme.onSurfaceVariant,
            );
          }),
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((states) {
            final isSelected = states.contains(WidgetState.selected);
            return TextStyle(
              fontSize: 10,
              height: 1,
              color: isSelected
                  ? selectedNavColor
                  : colorScheme.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            );
          }),
        ),
        child: NavigationBar(
          selectedIndex: _currentIndex,
          onDestinationSelected: (index) => _onDestinationSelected(index),
          destinations: _tabs
              .map(
                (tab) => NavigationDestination(
                  icon: Icon(tab.icon),
                  label: _labelForTab(l10n, tab.id),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }

  Widget _buildTabPage(int index) {
    if (!_visitedIndexes.contains(index)) {
      // Keep startup fast: avoid building non-visible tabs until first visit.
      return const SizedBox.shrink();
    }
    switch (index) {
      case 0:
        return HomeTabScreen(
          isTabActive: _currentIndex == 0,
          onOpenFocusTab: () {
            setState(() {
              _currentIndex = 1;
              _visitedIndexes.add(1);
            });
          },
        );
      case 1:
        return const FocusTabScreen();
      case 2:
        return const TasbihTabScreen();
      case 3:
        return const QuranTabScreen();
      case 4:
        return SettingsTabScreen(isTabActive: _currentIndex == 4);
      default:
        return const SizedBox.shrink();
    }
  }

  String _labelForTab(AppLocalizations l10n, String id) {
    switch (id) {
      case 'home':
        return l10n.tabHome;
      case 'focus':
        return l10n.tabFocus;
      case 'tasbih':
        return l10n.tabTasbih;
      case 'quran':
        return l10n.tabQuran;
      case 'settings':
        return l10n.settings;
      default:
        return id;
    }
  }
}

class _AppTab {
  const _AppTab({required this.id, required this.icon});

  final String id;
  final IconData icon;
}
