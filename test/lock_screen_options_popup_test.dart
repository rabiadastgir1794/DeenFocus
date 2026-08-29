import 'package:deenly/core/services/storage_service.dart';
import 'package:deenly/core/superwall/app_superwall.dart';
import 'package:deenly/features/home/helpers/lock_screen_style_preference.dart';
import 'package:deenly/features/home/helpers/prayer_label_helper.dart';
import 'package:deenly/features/home/model/home_models.dart';
import 'package:deenly/features/home/view/widgets/home_prayer_reminder_popup.dart';
import 'package:deenly/features/home/view/widgets/lock_screen_options/lock_screen_options_screen.dart';
import 'package:deenly/features/home/view/widgets/lock_screen_options/lock_screen_style.dart';
import 'package:deenly/features/home/view/widgets/lock_screen_options/lock_screen_style_chrome.dart';
import 'package:deenly/features/home/view/widgets/lock_screen_options/lock_screen_style_experience_screen.dart';
import 'package:deenly/features/home/view/widgets/lock_screen_options/lock_screen_style_views.dart';
import 'package:deenly/features/home/viewmodel/lock_screen_countdown_view_model.dart';
import 'package:deenly/features/home/viewmodel/lock_screen_quiz_view_model.dart';
import 'package:deenly/features/home/viewmodel/lock_screen_tasbih_view_model.dart';
import 'package:deenly/features/home/viewmodel/lock_screen_verse_view_model.dart';
import 'package:deenly/l10n/app_localizations.dart';
import 'package:deenly/l10n/app_localizations_en.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> _openPicker(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Builder(
        builder: (context) {
          return Scaffold(
            body: Center(
              child: TextButton(
                onPressed: () => LockScreenOptionsScreen.open(context),
                child: const Text('Open styles'),
              ),
            ),
          );
        },
      ),
    ),
  );

  await tester.tap(find.text('Open styles'));
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Lock Screen Style opens as a full screen', (tester) async {
    await _openPicker(tester);

    expect(find.text('Lock Screen Style'), findsOneWidget);
    expect(find.text('Back'), findsOneWidget);
    expect(find.text('Prayer reminder'), findsWidgets);
    expect(find.text('Selected'), findsOneWidget);
    expect(
      find.byKey(const ValueKey<String>('lock-screen-radio-classic')),
      findsOneWidget,
    );
    expect(
      find.text('Tap a style to open the full-screen layout.'),
      findsNothing,
    );

    await tester.drag(find.byType(GridView), const Offset(0, -2400));
    await tester.pumpAndSettle();
    expect(find.text('Minimal Focus'), findsOneWidget);
  });

  test('classic style is free and others require premium', () {
    expect(LockScreenStyle.classic.requiresPremium, isFalse);
    for (final style in LockScreenStyle.values) {
      if (style == LockScreenStyle.classic) continue;
      expect(style.requiresPremium, isTrue, reason: style.name);
    }
  });

  test('stored style parse falls back when missing or invalid', () {
    expect(LockScreenStyle.tryParse(null), isNull);
    expect(LockScreenStyle.tryParse(''), isNull);
    expect(LockScreenStyle.tryParse('not-a-style'), isNull);
    expect(LockScreenStyle.tryParse('classic'), LockScreenStyle.classic);
    expect(LockScreenStyle.tryParse('minimal'), LockScreenStyle.minimal);
  });

  test('empty preference is persisted as classic', () async {
    expect(await StorageService.lockScreenStyle, isNull);
    expect(
      await LockScreenStylePreference.ensureSelected(),
      LockScreenStyle.classic,
    );
    expect(await StorageService.lockScreenStyle, 'classic');
  });

  test('reminder uses classic when nothing is stored', () async {
    expect(
      await LockScreenStylePreference.resolveForReminder(),
      LockScreenStyle.classic,
    );
  });

  test('reminder falls back to classic for unpaid premium styles', () async {
    SharedPreferences.setMockInitialValues({'lock_screen_style': 'tasbih'});
    final previous = AppSuperwall.subscriptionActiveNotifier.value;
    AppSuperwall.subscriptionActiveNotifier.value = false;
    addTearDown(() {
      AppSuperwall.subscriptionActiveNotifier.value = previous;
    });

    expect(
      await LockScreenStylePreference.resolveForReminder(),
      LockScreenStyle.classic,
    );
  });

  test('reminder keeps a paid style when subscribed', () async {
    SharedPreferences.setMockInitialValues({'lock_screen_style': 'tasbih'});
    final previous = AppSuperwall.subscriptionActiveNotifier.value;
    AppSuperwall.subscriptionActiveNotifier.value = true;
    addTearDown(() {
      AppSuperwall.subscriptionActiveNotifier.value = previous;
    });

    expect(
      await LockScreenStylePreference.resolveForReminder(),
      LockScreenStyle.tasbih,
    );
  });

  testWidgets('preview icon opens the style without selecting it', (
    tester,
  ) async {
    await _openPicker(tester);

    expect(
      find.byKey(const ValueKey<String>('lock-screen-preview-classic')),
      findsOneWidget,
    );

    await tester.tap(
      find.byKey(const ValueKey<String>('lock-screen-preview-classic')),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Preview'), findsWidgets);
    expect(find.textContaining('Prayer reminder'), findsWidgets);

    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Selected'), findsOneWidget);
  });

  testWidgets('paid style preview opens without a paywall', (tester) async {
    await _openPicker(tester);

    await tester.tap(
      find.byKey(const ValueKey<String>('lock-screen-preview-tasbih')),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Preview'), findsWidgets);
    expect(find.textContaining('Tasbih counter'), findsWidgets);
  });

  testWidgets('classic card tap stays selected and does not open preview', (
    tester,
  ) async {
    await _openPicker(tester);

    expect(find.text('Selected'), findsOneWidget);

    await tester.tap(find.text('Prayer reminder').first);
    await tester.pumpAndSettle();

    expect(find.text('Selected'), findsOneWidget);
    expect(find.textContaining('Preview ·'), findsNothing);

    await tester.tap(find.text('Prayer reminder').first);
    await tester.pumpAndSettle();
    expect(find.text('Selected'), findsOneWidget);
  });

  testWidgets('selected style is persisted across picker opens', (
    tester,
  ) async {
    await _openPicker(tester);

    expect(find.text('Selected'), findsOneWidget);
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Open styles'));
    await tester.pumpAndSettle();
    expect(find.text('Selected'), findsOneWidget);
    expect(await StorageService.lockScreenStyle, 'classic');
  });

  testWidgets('Did you pray uses a centered dialog not a fullscreen route', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            ctx = context;
            return const Scaffold(body: SizedBox.shrink());
          },
        ),
      ),
    );

    final future = PrayerReminderPopup.show(
      context: ctx,
      prayer: TrackablePrayer.maghrib,
    );
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(LockScreenStyleExperienceScreen), findsNothing);
    expect(find.textContaining('Did you pray Maghrib?'), findsOneWidget);
    expect(find.text('Yes, Alhamdulillah'), findsOneWidget);
    expect(find.text("I'll mark later"), findsOneWidget);

    await tester.tap(find.text('Yes, Alhamdulillah'));
    await tester.pumpAndSettle();
    expect(await future, isTrue);
  });

  testWidgets('Did you pray later returns false', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            ctx = context;
            return const Scaffold(body: SizedBox.shrink());
          },
        ),
      ),
    );

    final future = PrayerReminderPopup.show(
      context: ctx,
      prayer: TrackablePrayer.isha,
    );
    await tester.pumpAndSettle();

    await tester.tap(find.text("I'll mark later"));
    await tester.pumpAndSettle();
    expect(await future, isFalse);
  });

  testWidgets('style content is shown inside the same dialog chrome', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    late BuildContext ctx;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            ctx = context;
            return const Scaffold(body: SizedBox.shrink());
          },
        ),
      ),
    );

    final future = showDialog<bool>(
      context: ctx,
      builder: (_) => const PrayerReminderStyleDialog(
        style: LockScreenStyle.minimal,
        prayer: TrackablePrayer.fajr,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(LockScreenStyleExperienceScreen), findsNothing);
    expect(find.text('Fajr'), findsWidgets);
    expect(find.text('Yes, Alhamdulillah'), findsOneWidget);

    await tester.tap(find.text('Yes, Alhamdulillah'));
    await tester.pumpAndSettle();
    expect(await future, isTrue);
  });

  testWidgets('previews use the passed prayer instead of Asr', (tester) async {
    final l10n = AppLocalizationsEn();
    for (final prayer in TrackablePrayer.values) {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: LockScreenStyleView(
              style: LockScreenStyle.classic,
              prayer: prayer,
              compact: true,
            ),
          ),
        ),
      );
      await tester.pump();
      expect(
        find.text(l10n.prayerReminderTitle(prayer.label(l10n))),
        findsOneWidget,
      );
      if (prayer != TrackablePrayer.asr) {
        expect(find.textContaining('Asr'), findsNothing);
      }
    }
  });

  test('minimal focus is a lock screen style', () {
    expect(LockScreenStyle.values, contains(LockScreenStyle.minimal));
    expect(
      LockScreenStyle.minimal.title(AppLocalizationsEn()),
      'Minimal Focus',
    );
  });

  testWidgets('type-to-confirm field shows hint and uppercases input', (
    tester,
  ) async {
    final controller = TextEditingController();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: LockScreenTypeConfirmField(
            expected: 'ALHAMDULILLAH',
            controller: controller,
          ),
        ),
      ),
    );

    expect(find.text('ALHAMDULILLAH'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'al');
    await tester.pump();

    expect(controller.text, 'AL');
    expect(find.text('AL'), findsOneWidget);
  });

  test('classic is default and tasbih is recommended', () {
    expect(LockScreenStyle.classic.isDefault, isTrue);
    expect(LockScreenStyle.classic.isRecommended, isFalse);
    expect(LockScreenStyle.tasbih.isRecommended, isTrue);
    expect(LockScreenStyle.tasbih.isDefault, isFalse);
  });

  test('tasbih sequence advances and reset returns to start', () {
    final vm = LockScreenTasbihViewModel();
    expect(vm.current.transliteration, 'Astaghfirullah');
    expect(vm.current.target, 33);
    expect(vm.hasStarted, isFalse);

    for (var i = 0; i < 33; i++) {
      vm.tap();
    }
    expect(vm.current.transliteration, 'SubhanAllah');
    expect(vm.count, 0);
    expect(vm.current.target, 33);

    for (var i = 0; i < 33; i++) {
      vm.tap();
    }
    expect(vm.current.transliteration, 'Alhamdulillah');

    for (var i = 0; i < 33; i++) {
      vm.tap();
    }
    expect(vm.current.transliteration, 'Allahu Akbar');
    expect(vm.current.target, 34);

    for (var i = 0; i < 34; i++) {
      vm.tap();
    }
    expect(vm.sequenceComplete, isTrue);
    expect(vm.count, 34);
    expect(vm.consumeSequenceCompletion(), isTrue);
    expect(vm.consumeSequenceCompletion(), isFalse);

    vm.reset();
    expect(vm.current.transliteration, 'Astaghfirullah');
    expect(vm.count, 0);
    expect(vm.stepIndex, 0);
    expect(vm.hasStarted, isFalse);
  });

  testWidgets('knowledge check completes after three answers', (tester) async {
    final vm = LockScreenQuizViewModel.fromL10n(AppLocalizationsEn());
    addTearDown(vm.dispose);
    expect(vm.total, 3);

    vm.select(2);
    expect(vm.lastWasCorrect, isTrue);
    await tester.pump(const Duration(milliseconds: 900));
    expect(vm.index, 1);

    vm.select(1);
    expect(vm.lastWasCorrect, isTrue);
    await tester.pump(const Duration(milliseconds: 900));
    expect(vm.index, 2);

    vm.select(0);
    expect(vm.lastWasCorrect, isFalse);
    await tester.pump(const Duration(milliseconds: 900));
    expect(vm.complete, isTrue);
  });

  testWidgets('countdown remaining and progress stay in sync', (tester) async {
    var now = DateTime(2026, 8, 27, 12, 0, 0);
    final vm = LockScreenCountdownViewModel(
      target: now.add(const Duration(seconds: 4)),
      total: const Duration(seconds: 4),
      clock: () => now,
    );
    expect(vm.remaining.inSeconds, 4);
    expect(vm.progress, closeTo(0, 0.01));

    now = now.add(const Duration(seconds: 2));
    await tester.pump(const Duration(seconds: 1));
    expect(vm.remaining.inSeconds, 2);
    expect(vm.progress, closeTo(0.5, 0.01));
    vm.dispose();
  });

  test('verse catalog has 10 to 12 authentic refs', () {
    expect(LockScreenVerseViewModel.catalog.length, inInclusiveRange(10, 12));
    final keys = {
      for (final ref in LockScreenVerseViewModel.catalog)
        '${ref.surahNumber}:${ref.ayahNumber}',
    };
    expect(keys.length, LockScreenVerseViewModel.catalog.length);
    expect(keys.contains('2:152'), isTrue);
    expect(keys.contains('39:53'), isTrue);
  });
}
