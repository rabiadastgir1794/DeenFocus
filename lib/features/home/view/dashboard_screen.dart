import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../core/services/storage_service.dart';
import '../../../core/superwall/app_superwall.dart';
import '../../../core/theme/app_colors.dart';
import '../../../features/focus/focus_entry_intent.dart';
import '../../../features/focus/model/focus_models.dart';
import '../../../features/focus/view/focus_tab_screen.dart';
import '../../../features/home/cycle_mode_entry_intent.dart';
import '../../../features/home/services/prayer_settings_service.dart';
import '../../../features/home/view/home_tab_screen.dart';
import '../../../features/home/view/settings/settings_tab_screen.dart';
import '../../../features/home/viewmodel/home_tab_view_model.dart';
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

  /// Prevents duplicate post-onboarding Superwall presentation in one session.
  static bool _postOnboardingPaywallHandled = false;

  static const List<_AppTab> _tabs = <_AppTab>[
    _AppTab(id: 'home', icon: Icons.home_outlined),
    _AppTab(id: 'focus', icon: Icons.shield_outlined),
    _AppTab(id: 'tasbih', icon: Icons.trip_origin),
    _AppTab(id: 'learn', icon: Icons.school_outlined),
    _AppTab(id: 'settings', icon: Icons.settings_outlined),
  ];

  @override
  void initState() {
    super.initState();
    CycleModeEntryIntent.pendingOpenSettings.addListener(
      _onCycleModeOpenRequested,
    );
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_maybePresentPostOnboardingPaywall());
      _onCycleModeOpenRequested();
    });
  }

  @override
  void dispose() {
    CycleModeEntryIntent.pendingOpenSettings.removeListener(
      _onCycleModeOpenRequested,
    );
    super.dispose();
  }

  void _onCycleModeOpenRequested() {
    if (!CycleModeEntryIntent.pendingOpenSettings.value) return;
    if (!mounted) return;
    // Ensure Home is visible so HomeTabScreen can open the settings sheet.
    if (_currentIndex != 0 || !_visitedIndexes.contains(0)) {
      setState(() {
        _currentIndex = 0;
        _visitedIndexes.add(0);
      });
    }
  }

  /// After "Start My 7-Day Free Trial": Home first, then Superwall once
  /// for non-subscribers. Subscribed users skip Superwall entirely.
  Future<void> _maybePresentPostOnboardingPaywall() async {
    if (_postOnboardingPaywallHandled) return;
    final pending = await StorageService.pendingPostOnboardingPaywall;
    if (!pending) return;

    // Clear before presenting so rebuilds / resume cannot re-trigger.
    _postOnboardingPaywallHandled = true;
    await StorageService.setPendingPostOnboardingPaywall(false);
    if (!mounted) return;

    await AppSuperwall.requireActiveSubscriptionOrPresentPaywall(
      () {},
      debugContext: 'post_onboarding_home',
      placementOverride: SuperwallPlacements.firstTimeOfferWall,
    );
  }

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

  void _openFocusAndRequestEnable(FocusModeType mode) {
    FocusEntryIntent.requestEnableMode(mode);
    if (!mounted) return;
    setState(() {
      _currentIndex = 1;
      _visitedIndexes.add(1);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    const selectedNavColor = AppColors.primary;
    // Solid nav background so scroll content never shows through.
    final backgroundColor = isDark
        ? AppColors.surfaceDark
        : AppColors.surfaceLight;
    final pages = List<Widget>.generate(_tabs.length, _buildTabPage);

    return ChangeNotifierProvider<HomeTabViewModel>(
      create: (context) => HomeTabViewModel(
        prayerSettings: context.read<PrayerSettingsService>(),
      )..initialize(),
      child: Scaffold(
        body: IndexedStack(index: _currentIndex, children: pages),
        bottomNavigationBar: Material(
          color: backgroundColor,
          elevation: 8,
          shadowColor: Colors.black.withValues(alpha: 0.08),
          child: NavigationBarTheme(
            data: NavigationBarThemeData(
              backgroundColor: backgroundColor,
              surfaceTintColor: Colors.transparent,
              shadowColor: Colors.transparent,
              elevation: 0,
              indicatorColor: selectedNavColor.withValues(alpha: 0.18),
              iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
                states,
              ) {
                final isSelected = states.contains(WidgetState.selected);
                return IconThemeData(
                  color: isSelected
                      ? selectedNavColor
                      : colorScheme.onSurfaceVariant,
                );
              }),
              labelTextStyle: WidgetStateProperty.resolveWith<TextStyle?>((
                states,
              ) {
                final isSelected = states.contains(WidgetState.selected);
                return Theme.of(context).textTheme.labelSmall?.copyWith(
                  height: 1.15,
                  color: isSelected
                      ? selectedNavColor
                      : colorScheme.onSurfaceVariant,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                );
              }),
            ),
            child: NavigationBar(
              backgroundColor: backgroundColor,
              surfaceTintColor: Colors.transparent,
              elevation: 0,
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
        return SettingsTabScreen(
          onRequestEnableFocusMode: _openFocusAndRequestEnable,
        );
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
      case 'learn':
        return l10n.tabLearn;
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
