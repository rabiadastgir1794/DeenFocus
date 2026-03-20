import 'package:flutter/material.dart';

import '../../../core/constants/app_languages.dart';
import '../../../core/services/locale_service.dart';
import '../../../features/focus/view/focus_tab_screen.dart';
import '../../../features/home/view/home_tab_screen.dart';
import '../../../features/quran/view/quran_tab_screen.dart';
import '../../../features/tasbih/view/tasbih_tab_screen.dart';
import '../../../l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int _currentIndex = 0;

  static const List<_AppTab> _tabs = <_AppTab>[
    _AppTab(id: 'home', icon: Icons.home_outlined),
    _AppTab(id: 'focus', icon: Icons.shield_outlined),
    _AppTab(id: 'tasbih', icon: Icons.trip_origin),
    _AppTab(id: 'quran', icon: Icons.menu_book_outlined),
    _AppTab(id: 'settings', icon: Icons.settings_outlined),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final pages = <Widget>[
      HomeTabScreen(
        onOpenFocusTab: () {
          setState(() => _currentIndex = 1);
        },
      ),
      const FocusTabScreen(),
      const TasbihTabScreen(),
      const QuranTabScreen(),
      const _SettingsTab(),
    ];

    return Scaffold(
      body: IndexedStack(index: _currentIndex, children: pages),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: _tabs
            .map(
              (tab) => NavigationDestination(
                icon: Icon(tab.icon),
                label: _labelForTab(l10n, tab.id),
              ),
            )
            .toList(growable: false),
      ),
    );
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

class _SettingsTab extends StatelessWidget {
  const _SettingsTab();

  Future<void> _showLanguagePicker(BuildContext context) async {
    final localeService = context.read<LocaleService>();

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: kAppLanguages.length,
            itemBuilder: (ctx, index) {
              final language = kAppLanguages[index];
              final isSelected =
                  language.localeCode == localeService.localeCode;
              return ListTile(
                leading: Text(
                  language.flag,
                  style: const TextStyle(fontSize: 20),
                ),
                title: Text(language.label),
                trailing: isSelected
                    ? Icon(
                        Icons.check,
                        color: Theme.of(ctx).colorScheme.primary,
                      )
                    : null,
                onTap: () async {
                  Navigator.of(ctx).pop();
                  await localeService.setLocale(language.locale);
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final localeService = context.watch<LocaleService>();
    final currentLang = kAppLanguages.firstWhere(
      (l) => l.localeCode == localeService.localeCode,
      orElse: () => kAppLanguages.first,
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settings)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ListTile(
            leading: const Icon(Icons.language),
            title: Text(l10n.appLanguage),
            subtitle: Text('${currentLang.flag} ${currentLang.label}'),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => _showLanguagePicker(context),
          ),
        ],
      ),
    );
  }
}
