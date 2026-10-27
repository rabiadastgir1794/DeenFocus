import 'package:deenly/core/widgets/app_centered_nav_header.dart';
import 'package:deenly/features/home/view/settings/settings_list_widgets.dart';
import 'package:deenly/features/home/view/widgets/app_bottom_navigation_bar.dart';
import 'package:deenly/features/islamic_library/widgets/learning_card_actions.dart';
import 'package:deenly/features/onboarding/model/calculation_method_option.dart';
import 'package:deenly/features/onboarding/model/sect_option.dart';
import 'package:deenly/l10n/app_localizations.dart';
import 'package:deenly/l10n/app_localizations_de.dart';
import 'package:deenly/l10n/app_localizations_fr.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('settings values use localized sect and calculation method names', () {
    final fr = AppLocalizationsFr();
    final de = AppLocalizationsDe();

    expect(SectOption.sunni.localizedLabel(fr), 'Sunnite');
    expect(SectOption.shia.localizedLabel(fr), isNot('Shia'));
    expect(
      CalculationMethodOption.muslimWorldLeague.localizedLabel(fr),
      'Ligue islamique mondiale',
    );
    expect(
      CalculationMethodOption.northAmerica.localizedLabel(de),
      isNot(contains('Islamic Society')),
    );
  });

  testWidgets('bottom nav labels stay on one line at a narrow width', (
    tester,
  ) async {
    final de = AppLocalizationsDe();
    final labels = [
      de.tabHome,
      de.tabFocus,
      de.tabTasbih,
      de.tabLearn,
      de.settings,
    ];
    _usePhoneSurface(tester, const Size(320, 640));

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.3),
            ),
            child: child!,
          );
        },
        home: Scaffold(
          bottomNavigationBar: AppBottomNavigationBar(
            labels: labels,
            icons: const [
              Icons.home_outlined,
              Icons.shield_outlined,
              Icons.trip_origin,
              Icons.school_outlined,
              Icons.settings_outlined,
            ],
            selectedIndex: 1,
            onSelected: (_) {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    for (var i = 0; i < labels.length; i++) {
      final rect = tester.getRect(find.text(labels[i]));
      expect(rect.height, lessThan(22));
      expect(rect.width, lessThanOrEqualTo(320 / labels.length + 0.5));
      if (i > 0) {
        final previous = tester.getRect(find.text(labels[i - 1]));
        expect(rect.overlaps(previous), isFalse);
      }
    }
  });

  testWidgets('bottom nav does not overflow when text is scaled up', (
    tester,
  ) async {
    _usePhoneSurface(tester, const Size(320, 640));
    const labels = [
      'Start',
      'Fokus',
      'Tasbih',
      'Lernen',
      'Einstellungen',
    ];

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(3),
            ),
            child: child!,
          );
        },
        home: Scaffold(
          bottomNavigationBar: AppBottomNavigationBar(
            labels: labels,
            icons: const [
              Icons.home_outlined,
              Icons.shield_outlined,
              Icons.trip_origin,
              Icons.school_outlined,
              Icons.settings_outlined,
            ],
            selectedIndex: 4,
            onSelected: (_) {},
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    for (var i = 0; i < labels.length; i++) {
      final rect = tester.getRect(find.text(labels[i]));
      expect(rect.width, lessThanOrEqualTo(320 / labels.length + 0.5));
      if (i > 0) {
        expect(rect.overlaps(tester.getRect(find.text(labels[i - 1]))), isFalse);
      }
    }
  });

  testWidgets('learn actions and long settings values fit on a narrow screen', (
    tester,
  ) async {
    final de = AppLocalizationsDe();
    _usePhoneSurface(tester, const Size(320, 800));

    await tester.pumpWidget(
      MaterialApp(
        locale: const Locale('de'),
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(3),
            ),
            child: child!,
          );
        },
        home: Scaffold(
          body: ListView(
            children: [
              LearningCardActions(
                isBookmarked: false,
                onBookmark: () {},
                onCopy: () {},
                onShare: () {},
              ),
              SettingsRow(
                icon: Icons.grid_view_outlined,
                label: de.settingsCalculationMethodTitle,
                value: CalculationMethodOption.karachi.localizedLabel(de),
              ),
              SettingsRow(
                icon: Icons.wb_sunny_outlined,
                label: de.settingsAsrCalculationTitle,
                value:
                    '${de.asrMethodStandard} (${de.asrMethodStandardSubtitle})',
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.text(de.libraryBookmark), findsOneWidget);
    expect(
      find.text(CalculationMethodOption.karachi.localizedLabel(de)),
      findsOneWidget,
    );
  });

  testWidgets('settings rows wrap long values instead of clipping mid-word', (
    tester,
  ) async {
    _usePhoneSurface(tester, const Size(320, 700));

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.3),
            ),
            child: child!,
          );
        },
        home: Scaffold(
          body: ListView(
            children: [
              SettingsRow(
                icon: Icons.groups_outlined,
                label: 'Choisissez votre secte',
                value: 'Sunnite',
              ),
              SettingsRow(
                icon: Icons.grid_view_outlined,
                label: 'Méthode de Calcul',
                value: 'Ligue islamique mondiale',
              ),
              SettingsRow(
                icon: Icons.wb_sunny_outlined,
                label: "Calcul de l'Asr",
                value: 'Standard (Shafi, Maliki, Hanbali)',
              ),
            ],
          ),
        ),
      ),
    );

    expect(tester.takeException(), isNull);
    expect(find.text('Sunnite'), findsOneWidget);
    expect(find.text('Ligue islamique mondiale'), findsOneWidget);
    expect(find.text('Standard (Shafi, Maliki, Hanbali)'), findsOneWidget);

    for (final value in [
      'Choisissez votre secte',
      'Méthode de Calcul',
      "Calcul de l'Asr",
      'Sunnite',
      'Ligue islamique mondiale',
      'Standard (Shafi, Maliki, Hanbali)',
    ]) {
      final paragraph = tester.renderObject<RenderParagraph>(find.text(value));
      expect(paragraph.didExceedMaxLines, isFalse, reason: value);
    }
  });

  testWidgets('surah header icons do not overflow the right edge', (
    tester,
  ) async {
    for (final width in [360.0, 393.0]) {
      _usePhoneSurface(tester, Size(width, 852));
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: AppCenteredNavHeader(
              title: 'Al-Fatihah',
              subtitle: 'Al-Fatihah • 7 Verse',
              backLabel: 'Zurück',
              onBack: () {},
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.auto_stories_rounded),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.tune_rounded),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(tester.takeException(), isNull, reason: 'width $width');
      final headerRight = tester.getTopRight(find.byType(AppCenteredNavHeader)).dx;
      final iconRight = tester.getTopRight(find.byIcon(Icons.tune_rounded)).dx;
      expect(iconRight, lessThanOrEqualTo(headerRight));
    }
  });
}

void _usePhoneSurface(WidgetTester tester, Size size) {
  tester.view.physicalSize = size;
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);
}
