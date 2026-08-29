import 'package:deenly/features/focus/model/restricted_mode_content.dart';
import 'package:deenly/features/focus/view/widgets/restricted_mode_screen.dart';
import 'package:deenly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  Future<void> pumpAt(WidgetTester tester, Size size, RestrictedModeKind kind) {
    return tester.pumpWidget(
      MediaQuery(
        data: MediaQueryData(size: size),
        child: MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.light,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: RestrictedModeScreen(kind: kind, onPrimary: () {}),
        ),
      ),
    );
  }

  testWidgets('restricted overlay fits short and tall phones', (tester) async {
    const sizes = [Size(375, 667), Size(393, 852)];
    for (final size in sizes) {
      for (final kind in RestrictedModeKind.values) {
        await pumpAt(tester, size, kind);
        expect(tester.takeException(), isNull);
        expect(
          find.text('Some apps are temporarily unavailable.'),
          findsOneWidget,
        );
      }
    }
  });

  testWidgets('child and salah overlays stay readable in dark theme', (
    tester,
  ) async {
    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(393, 852)),
        child: MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: RestrictedModeScreen(
            kind: RestrictedModeKind.child,
            onPrimary: () {},
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Child Focus Mode'), findsOneWidget);

    await tester.pumpWidget(
      MediaQuery(
        data: const MediaQueryData(size: Size(393, 852)),
        child: MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: RestrictedModeScreen(
            kind: RestrictedModeKind.salah,
            onPrimary: () {},
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Salah Time'), findsOneWidget);
  });
}
