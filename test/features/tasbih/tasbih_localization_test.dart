import 'dart:io';

import 'package:deenly/features/tasbih/data/tasbih_local_repository.dart';
import 'package:deenly/features/tasbih/view/tasbih_detail_screen.dart';
import 'package:deenly/features/tasbih/view/tasbih_tab_screen.dart';
import 'package:deenly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('built-in tasbih names and screen text are translated', () {
    final meaningGetters = <String Function(AppLocalizations)>[
      (l10n) => l10n.tasbihMeaningSubhanAllah,
      (l10n) => l10n.tasbihMeaningAlhamdulillah,
      (l10n) => l10n.tasbihMeaningAllahuAkbar,
      (l10n) => l10n.tasbihMeaningLaIlahaIllallah,
      (l10n) => l10n.tasbihMeaningAstaghfirullah,
      (l10n) => l10n.tasbihMeaningLaHawla,
      (l10n) => l10n.tasbihMeaningSubhanAllahiWaBihamdihi,
      (l10n) => l10n.tasbihMeaningHasbunallahu,
    ];
    final english = lookupAppLocalizations(const Locale('en'));

    for (final locale in AppLocalizations.supportedLocales) {
      final l10n = lookupAppLocalizations(locale);
      expect(l10n.tasbihPin, isNotEmpty);
      expect(l10n.tasbihUnpin, isNotEmpty);
      expect(l10n.tasbihEdit, isNotEmpty);
      expect(l10n.tasbihLoopLabel(1), contains('1'));
      expect(l10n.tasbihSessionSummary(0, 33, 0), contains('33'));
      if (locale.languageCode == 'en') continue;

      expect(l10n.tasbihCurrentDhikr, isNot(english.tasbihCurrentDhikr));
      expect(l10n.tasbihViewAll, isNot(english.tasbihViewAll));
      expect(l10n.tasbihSaveSession, isNot(english.tasbihSaveSession));
      expect(l10n.tasbihSwipeHint, isNot(english.tasbihSwipeHint));
      expect(l10n.tasbihPin, isNot(english.tasbihPin));
      expect(l10n.tasbihUnpin, isNot(english.tasbihUnpin));
      expect(l10n.tasbihEdit, isNot(english.tasbihEdit));
      expect(l10n.tasbihLoopLabel(1), isNot(english.tasbihLoopLabel(1)));
      expect(
        l10n.tasbihSessionSummary(0, 33, 0),
        isNot(english.tasbihSessionSummary(0, 33, 0)),
      );
      for (final meaning in meaningGetters) {
        expect(meaning(l10n), isNot(meaning(english)));
        expect(meaning(l10n).trim(), isNotEmpty);
      }
    }

    final zh = lookupAppLocalizations(const Locale('zh'));
    expect(zh.tasbihNameAllahuAkbar, '安拉胡艾克拜尔');
    expect(zh.tasbihMeaningAllahuAkbar, '真主至大');
    expect(zh.tasbihChooseOrAddSubtitle, isNot(contains('dhikr')));
    expect(zh.tasbihLoopLabel(1), '第 1 轮');

    final ar = lookupAppLocalizations(const Locale('ar'));
    expect(ar.tasbihPin, 'تثبيت');
    expect(ar.tasbihMeaningAllahuAkbar, 'الله أعظم من كل شيء');
    expect(ar.tasbihDelete, 'حذف');

    final hi = lookupAppLocalizations(const Locale('hi'));
    expect(hi.tasbihTabTitle, 'तस्बीह');
    expect(hi.tasbihChooseOrAddSubtitle, isNot(contains('धिक्कार')));
    expect(hi.tasbihNameAllahuAkbar, 'अल्लाहु अकबर');

    final fr = lookupAppLocalizations(const Locale('fr'));
    expect(fr.tasbihNameAllahuAkbar, 'Allahu Akbar');
    expect(fr.tasbihMeaningAllahuAkbar, 'Allah est le Plus Grand');
    expect(fr.tasbihPin, 'Épingler');

    final ru = lookupAppLocalizations(const Locale('ru'));
    expect(ru.tasbihNameSubhanAllah, 'Субханаллах');
    expect(ru.tasbihMeaningSubhanAllah, 'Пречист Аллах');
  });

  testWidgets('tasbih counter stays on screen in Chinese at a narrow width', (
    tester,
  ) async {
    await _pumpDetail(
      tester,
      locale: const Locale('zh'),
      size: const Size(320, 640),
      textScale: 1.3,
    );

    expect(tester.takeException(), isNull);
    expect(find.text('当前迪克尔'), findsOneWidget);
    expect(find.text('查看全部'), findsOneWidget);
    expect(find.text('保存本次'), findsOneWidget);
    expect(find.text('安拉胡艾克拜尔'), findsOneWidget);
    expect(find.text('真主至大'), findsOneWidget);
    expect(find.text('Allah is the Greatest'), findsNothing);
    expect(find.text('Loop 1'), findsNothing);
    expect(find.textContaining('将珠子滑过中心'), findsOneWidget);
    expect(find.textContaining('本次共计 0'), findsOneWidget);
  });

  testWidgets('tasbih counter stays on screen with large German text', (
    tester,
  ) async {
    await _pumpDetail(
      tester,
      locale: const Locale('de'),
      size: const Size(360, 800),
      textScale: 2,
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Aktueller Dhikr'), findsOneWidget);
    expect(find.text('Allah ist der Größte'), findsOneWidget);
    expect(find.textContaining('Ziehe die Perlen'), findsOneWidget);
    expect(find.text('Allah is the Greatest'), findsNothing);
  });

  testWidgets('tasbih list shows Arabic names and a translated pin action', (
    tester,
  ) async {
    await tester.runAsync(() async {
      SharedPreferences.setMockInitialValues({});
      final dir = Directory.systemTemp.createTempSync('tasbih_l10n');
      Hive.init(dir.path);
      await TasbihLocalRepository.instance.getItems();
    });

    _usePhoneSurface(tester, const Size(320, 700));
    await tester.pumpWidget(
      ScreenUtilInit(
        designSize: const Size(390, 844),
        builder: (_, _) => MaterialApp(
          locale: const Locale('ar'),
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(
                context,
              ).copyWith(textScaler: const TextScaler.linear(2)),
              child: child!,
            );
          },
          home: const TasbihTabScreen(),
        ),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(tester.takeException(), isNull);
    expect(find.text('الله أعظم من كل شيء'), findsOneWidget);
    expect(find.text('Allahu Akbar'), findsNothing);
    expect(find.text('Pin'), findsNothing);
    expect(find.textContaining('धिक्कार'), findsNothing);

    await tester.tap(find.byIcon(Icons.more_vert_rounded).first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(tester.takeException(), isNull);
    expect(find.text('تثبيت'), findsOneWidget);
    expect(find.text('Pin'), findsNothing);
  });
}

Future<void> _pumpDetail(
  WidgetTester tester, {
  required Locale locale,
  required Size size,
  required double textScale,
}) async {
  _usePhoneSurface(tester, size);
  await tester.pumpWidget(
    ScreenUtilInit(
      designSize: const Size(390, 844),
      builder: (_, _) => MaterialApp(
        locale: locale,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(
              context,
            ).copyWith(textScaler: TextScaler.linear(textScale)),
            child: child!,
          );
        },
        home: const TasbihDetailScreen(
          item: TasbihItem(
            id: 'allahu_akbar',
            label: 'الله أكبر',
            transliteration: 'Allahu Akbar',
            meaning: 'Allah is the Greatest',
            isCustom: false,
            isPinned: false,
            order: 2,
            totalCount: 0,
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void _usePhoneSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
