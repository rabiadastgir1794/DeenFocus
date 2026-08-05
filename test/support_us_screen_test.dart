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

  testWidgets('SupportUsScreen renders hero, fund items, and CTA', (
    WidgetTester tester,
  ) async {
    tester.view.physicalSize = const Size(390, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_wrap(const SupportUsScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Support DeenFocus'), findsOneWidget);
    expect(find.text('Help keep DeenFocus growing'), findsOneWidget);
    expect(find.text('New Islamic features'), findsOneWidget);
    expect(find.text('Chat on WhatsApp'), findsOneWidget);
    expect(find.text('Email Support'), findsOneWidget);
    expect(find.text('Choose a one-time amount'), findsOneWidget);
  });

  testWidgets('slider updates displayed amount', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(390, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(_wrap(const SupportUsScreen()));
    await tester.pumpAndSettle();

    final slider = find.byType(Slider);
    await tester.scrollUntilVisible(
      slider,
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    await tester.drag(slider, const Offset(120, 0));
    await tester.pumpAndSettle();

    final vm = tester
        .element(find.byType(SupportUsScreen))
        .read<SupportViewModel>();
    expect(vm.amount, isNot(10));
  });
}
