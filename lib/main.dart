import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'app/routes/app_router.dart';
import 'core/constants/app_languages.dart';
import 'core/services/app_notification_service.dart';
import 'core/services/daily_refresh_service.dart';
import 'core/services/locale_service.dart';
import 'core/services/theme_service.dart';
import 'core/services/user_profile_service.dart';
import 'core/theme/app_theme.dart';
import 'features/focus/viewmodel/focus_controller.dart';
import 'features/tasbih/data/tasbih_local_repository.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await AppNotificationService.instance.initialize();
  unawaited(TasbihLocalRepository.instance.ensureInitialized());
  unawaited(DailyRefreshService.instance.initialize());
  runApp(const DeenlyApp());
}

class DeenlyApp extends StatefulWidget {
  const DeenlyApp({super.key});

  @override
  State<DeenlyApp> createState() => _DeenlyAppState();
}

class _DeenlyAppState extends State<DeenlyApp> {
  late final _router = createAppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleService()),
        ChangeNotifierProvider(create: (_) => ThemeService()),
        ChangeNotifierProvider(create: (_) => UserProfileService()),
        ChangeNotifierProvider(create: (_) => FocusController()..initialize()),
      ],
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Consumer2<LocaleService, ThemeService>(
            builder: (context, localeService, themeService, _) {
              return MaterialApp.router(
                title: 'Deenly',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: themeService.themeMode,
                locale: localeService.locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: kSupportedLocales,
                routerConfig: _router,
              );
            },
          );
        },
      ),
    );
  }
}
