import 'package:deenly/features/support/view/support_us_screen.dart';
import 'package:deenly/features/support/viewmodel/support_view_model.dart';
import 'package:deenly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

Widget _wrap(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (_, __) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ChangeNotifierProvider(
        create: (_) => SupportViewModel(),
        child: child,
      ),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('SupportUsScreen renders redesigned support UI', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 2800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_wrap(const SupportUsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Support DeenFocus'), findsOneWidget);
    expect(
      find.text(
        'Your support helps us keep improving DeenFocus and contribute to meaningful causes.',
      ),
      findsNothing,
    );
    expect(find.text('Choose a support amount'), findsOneWidget);
    expect(find.text('\$50'), findsWidgets);
    expect(find.text('New Features'), findsOneWidget);
    expect(find.text('People in Need'), findsOneWidget);
    expect(find.text('Where your support makes a difference'), findsOneWidget);
  });

  testWidgets('selecting amount chip updates view model', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 2800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_wrap(const SupportUsScreen()));
    await tester.pumpAndSettle();

    await tester.tap(find.text('\$100').first);
    await tester.pumpAndSettle();

    final vm = tester
        .element(find.byType(SupportUsScreen))
        .read<SupportViewModel>();
    expect(vm.amount, 100);
  });
}
