import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import 'app/routes/app_router.dart';
import 'core/constants/app_languages.dart';
import 'core/services/locale_service.dart';
import 'core/theme/app_theme.dart';
import 'l10n/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const DeenlyApp());
}

class DeenlyApp extends StatelessWidget {
  const DeenlyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => LocaleService(),
      child: ScreenUtilInit(
        designSize: const Size(390, 844),
        minTextAdapt: true,
        splitScreenMode: true,
        builder: (context, child) {
          return Consumer<LocaleService>(
            builder: (context, localeService, _) {
              return MaterialApp.router(
                title: 'Deenly',
                debugShowCheckedModeBanner: false,
                theme: AppTheme.light,
                darkTheme: AppTheme.dark,
                themeMode: ThemeMode.system,
                locale: localeService.locale,
                localizationsDelegates: AppLocalizations.localizationsDelegates,
                supportedLocales: kSupportedLocales,
                routerConfig: createAppRouter(),
              );
            },
          );
        },
      ),
    );
  }
}
