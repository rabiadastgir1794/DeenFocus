import 'package:deenly/features/home/helpers/islamic_event_catalog.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/services/hijri_date_service.dart';
import 'package:deenly/features/home/view/widgets/home_calendar_screen.dart';
import 'package:deenly/features/home/view/widgets/home_islamic_date_header.dart';
import 'package:deenly/features/home/viewmodel/home_tab_view_model.dart';
import 'package:deenly/l10n/app_localizations.dart';
import 'package:deenly/l10n/app_localizations_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

class _TestHomeTabViewModel extends HomeTabViewModel {
  _TestHomeTabViewModel({
    required List<HomeIslamicEvent> events,
    bool loading = false,
  }) {
    allIslamicEvents = events;
    isEventsLoading = loading;
    visibleMonth = DateTime(2026, 8, 1);
  }
}

Widget _wrap(Widget child, {HomeTabViewModel? vm}) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (_, __) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ChangeNotifierProvider<HomeTabViewModel>(
        create: (_) => vm ?? _TestHomeTabViewModel(events: const []),
        child: child,
      ),
    ),
  );
}

Widget _headerApp(Widget header) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (_, __) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: header),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('HomeIslamicDateHeader', () {
    testWidgets('shows Hijri date immediately without ellipsis', (
      WidgetTester tester,
    ) async {
      final local = HijriDateService.currentHijriLocal(DateTime(2026, 8, 3));

      await tester.pumpWidget(
        _headerApp(
          HomeIslamicDateHeader(
            userName: 'User',
            onTapCalendar: () {},
          ),
        ),
      );

      await tester.pump();

      expect(find.textContaining('AH'), findsOneWidget);
      expect(find.textContaining('…'), findsNothing);
      expect(find.textContaining('...'), findsNothing);
      expect(
        find.textContaining('${local['day']} ${localizedHijriMonth(
          AppLocalizationsEn(),
          local['month'] as int,
        )}'),
        findsOneWidget,
      );
    });

    testWidgets('renders in dark theme', (WidgetTester tester) async {
      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (_, __) => MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.dark,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: Scaffold(
              body: HomeIslamicDateHeader(
                userName: 'User',
                onTapCalendar: () {},
              ),
            ),
          ),
        ),
      );

      await tester.pump();
      expect(find.text('User'), findsOneWidget);
      expect(find.textContaining('AH'), findsOneWidget);
    });
  });

  group('HomeCalendarScreen', () {
    final sampleEvents = <HomeIslamicEvent>[
      HomeIslamicEvent(date: DateTime(2026, 8, 25), title: 'Mawlid an-Nabi'),
      HomeIslamicEvent(date: DateTime(2027, 2, 10), title: '1 Ramadan'),
      HomeIslamicEvent(date: DateTime(2027, 3, 12), title: 'Eid al-Fitr'),
      HomeIslamicEvent(date: DateTime(2027, 6, 26), title: 'Day of Arafah'),
      HomeIslamicEvent(date: DateTime(2027, 6, 27), title: 'Eid al-Adha'),
      HomeIslamicEvent(date: DateTime(2027, 7, 7), title: 'Islamic New Year'),
    ];

    testWidgets('renders month grid immediately without blocking spinner', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 2200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        _wrap(
          const HomeCalendarScreen(),
          vm: _TestHomeTabViewModel(events: sampleEvents),
        ),
      );

      await tester.pump();

      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(find.text('Islamic Calendar'), findsOneWidget);
      expect(find.textContaining('AH'), findsWidgets);
    });

    testWidgets('lists multiple upcoming major events', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 2200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        _wrap(
          const HomeCalendarScreen(),
          vm: _TestHomeTabViewModel(events: sampleEvents),
        ),
      );

      await tester.pump();

      expect(find.text('Mawlid an-Nabi'), findsOneWidget);
      expect(find.text('Ramadan Begins'), findsOneWidget);
      expect(find.text('Eid al-Fitr'), findsOneWidget);
      expect(find.text('Eid al-Adha'), findsOneWidget);
    });

    testWidgets('shows thin progress while events load', (
      WidgetTester tester,
    ) async {
      tester.view.physicalSize = const Size(800, 2200);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        _wrap(
          const HomeCalendarScreen(),
          vm: _TestHomeTabViewModel(events: const [], loading: true),
        ),
      );

      await tester.pump();

      expect(find.byType(LinearProgressIndicator), findsWidgets);
      expect(find.byType(CircularProgressIndicator), findsNothing);
    });
  });
}
