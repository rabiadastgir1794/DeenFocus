import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../core/constants/app_languages.dart';
import '../../core/services/locale_service.dart';
import '../../features/splash/view/splash_screen.dart';
import '../../features/onboarding/view/onboarding_flow_screen.dart';
import '../../l10n/app_localizations.dart';
import 'route_names.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

GoRouter createAppRouter() {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: RouteNames.splash,
    routes: [
      GoRoute(
        path: RouteNames.splash,
        name: 'splash',
        builder: (context, state) => const SplashScreen(),
      ),
      GoRoute(
        path: RouteNames.onboarding,
        name: 'onboarding',
        builder: (context, state) => const OnboardingFlowScreen(),
      ),
      GoRoute(
        path: RouteNames.home,
        name: 'home',
        builder: (context, state) => const _PlaceholderHome(),
      ),
    ],
  );
}

class _PlaceholderHome extends StatelessWidget {
  const _PlaceholderHome();

  Future<void> _showLanguagePicker(BuildContext context) async {
    final localeService = context.read<LocaleService>();
    final l10n = AppLocalizations.of(context)!;
    final isCupertino = Theme.of(context).platform == TargetPlatform.iOS ||
        Theme.of(context).platform == TargetPlatform.macOS;

    if (isCupertino) {
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (ctx) {
          return CupertinoActionSheet(
            title: Text(l10n.language),
            actions: [
              for (final language in kAppLanguages)
                CupertinoActionSheetAction(
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    await localeService.setLocale(language.locale);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(language.flag),
                          const SizedBox(width: 8),
                          Text(language.label),
                        ],
                      ),
                      if (language.localeCode == localeService.localeCode)
                        const Icon(CupertinoIcons.checkmark, color: CupertinoColors.activeBlue),
                    ],
                  ),
                ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.of(ctx).pop(),
              isDefaultAction: true,
              child: Text(l10n.cancel),
            ),
          );
        },
      );
    } else {
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
                final isSelected = language.localeCode == localeService.localeCode;
                return ListTile(
                  leading: Text(language.flag, style: const TextStyle(fontSize: 20)),
                  title: Text(language.label),
                  trailing: isSelected
                      ? Icon(Icons.check, color: Theme.of(ctx).colorScheme.primary)
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
      appBar: AppBar(
        title: Text(l10n.homeTitle),
      ),
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
          const SizedBox(height: 24),
          Center(
            child: TextButton(
              onPressed: () => context.go(RouteNames.onboarding),
              child: Text(l10n.backToOnboarding),
            ),
          ),
        ],
      ),
    );
  }
}
