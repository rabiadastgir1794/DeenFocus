import 'package:deenly/features/home/view/settings/settings_app_demo_screen.dart';
import 'package:deenly/features/onboarding/view/onboarding_app_lock_demo_page.dart';
import 'package:deenly/features/onboarding/view/widgets/app_lock_demo/app_lock_demo_controller.dart';
import 'package:deenly/features/onboarding/view/widgets/app_lock_demo/app_lock_demo_flow.dart';
import 'package:deenly/features/onboarding/view/widgets/app_lock_demo/app_lock_demo_mode.dart';
import 'package:deenly/features/onboarding/view/widgets/app_lock_demo/app_lock_demo_phase.dart';
import 'package:deenly/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_test/flutter_test.dart';

Widget _wrap(Widget child) {
  return ScreenUtilInit(
    designSize: const Size(390, 844),
    builder: (_, _) => MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AppLockDemoController', () {
    testWidgets('opening timer lands on prayer lock then reward', (tester) async {
      final c = AppLockDemoController();
      addTearDown(c.dispose);

      expect(c.phase, AppLockDemoPhase.intro);
      c.startDemo();
      expect(c.phase, AppLockDemoPhase.homeScreen);

      c.tapInstagram();
      expect(c.instagramTapped, isTrue);
      expect(c.phase, AppLockDemoPhase.openingApp);

      await tester.pump(AppLockDemoController.openingDuration);
      await tester.pump();
      expect(c.phase, AppLockDemoPhase.prayerLock);

      c.markPrayed();
      expect(c.phase, AppLockDemoPhase.streakReward);

      c.continueFromStreak();
      expect(c.phase, AppLockDemoPhase.completion);

      c.openEnableOffer();
      expect(c.phase, AppLockDemoPhase.enableOffer);

      c.reset();
      expect(c.phase, AppLockDemoPhase.intro);
    });
  });

  group('OnboardingAppLockDemoPage', () {
    testWidgets('interactive taps advance Screen 1 → 5', (tester) async {
      var completed = 0;
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        _wrap(
          OnboardingAppLockDemoPage(
            onComplete: () => completed++,
            onExitToPrevious: () {},
          ),
        ),
      );
      await tester.pump();

      expect(find.text('See how App Lock works'), findsOneWidget);

      await tester.tap(find.text('Start the demo'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 50));

      expect(find.text('Try opening Instagram'), findsOneWidget);
      expect(find.text('Instagram'), findsOneWidget);

      await tester.tap(find.text('Instagram'));
      await tester.pump();
      await tester.pump(AppLockDemoController.openingDuration);
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('It’s time to pray'), findsOneWidget);
      await tester.tap(find.textContaining('I’ve prayed'));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Your prayer streak increased'), findsOneWidget);
      await tester.tap(find.text('Continue'));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Continue setup'), findsOneWidget);
      await tester.tap(find.text('Continue setup'));
      await tester.pump();
      await tester.tap(find.text('Continue setup'));
      await tester.pump();
      expect(completed, 1);
    });
  });

  group('AppLockDemoFlow modes', () {
    testWidgets('sleep mode uses sleep lock copy', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        _wrap(
          AppLockDemoFlow(
            mode: AppLockDemoMode.sleep,
            fromSettings: true,
            onComplete: () {},
            onExit: () {},
          ),
        ),
      );
      await tester.pump();
      expect(find.text('See how Sleep Mode works'), findsOneWidget);

      await tester.tap(find.text('Start the demo'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.text('Instagram'));
      await tester.pump();
      await tester.pump(AppLockDemoController.openingDuration);
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('SLEEP MODE'), findsOneWidget);
      expect(find.text('Time to wind down'), findsOneWidget);

      await tester.tap(find.text('I’m ready to rest'));
      await tester.pump(const Duration(milliseconds: 500));

      // Sleep skips streak reward and Alhamdulillah.
      expect(find.text('Alhamdulillah'), findsNothing);
      expect(find.text('NIGHT STREAK'), findsNothing);
      expect(find.text('Rest well tonight'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);

      await tester.tap(find.text('Done'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Ready to try Sleep Mode?'), findsOneWidget);
      expect(find.text('Enable Sleep Mode'), findsOneWidget);
      expect(find.text('Not now'), findsOneWidget);
    });

    testWidgets('child mode skips streak and uses positive completion',
        (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        _wrap(
          AppLockDemoFlow(
            mode: AppLockDemoMode.child,
            fromSettings: true,
            onComplete: () {},
            onExit: () {},
          ),
        ),
      );
      await tester.pump();
      expect(find.text('See how Child Mode works'), findsOneWidget);

      await tester.tap(find.text('Start the demo'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.text('Instagram'));
      await tester.pump();
      await tester.pump(AppLockDemoController.openingDuration);
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('CHILD MODE'), findsOneWidget);
      expect(find.text('Apps are protected'), findsOneWidget);

      await tester.tap(find.text('Got it'));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Alhamdulillah'), findsNothing);
      expect(find.text('SAFE STREAK'), findsNothing);
      expect(find.text('Peace of mind'), findsOneWidget);
      expect(find.text('Done'), findsOneWidget);

      await tester.tap(find.text('Done'));
      await tester.pump(const Duration(milliseconds: 500));
      expect(find.text('Ready to try Child Mode?'), findsOneWidget);
      expect(find.text('Enable Child Mode'), findsOneWidget);
    });

    testWidgets('settings enable offer calls onEnableFocusMode', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      var enableTaps = 0;
      await tester.pumpWidget(
        _wrap(
          AppLockDemoFlow(
            mode: AppLockDemoMode.prayer,
            fromSettings: true,
            onComplete: () {},
            onExit: () {},
            onEnableFocusMode: () => enableTaps++,
          ),
        ),
      );
      await tester.pump();

      await tester.tap(find.text('Start the demo'));
      await tester.pump(const Duration(milliseconds: 400));
      await tester.pump(const Duration(milliseconds: 50));
      await tester.tap(find.text('Instagram'));
      await tester.pump();
      await tester.pump(AppLockDemoController.openingDuration);
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.textContaining('I’ve prayed'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.text('Continue'));
      await tester.pump(const Duration(milliseconds: 500));
      await tester.tap(find.text('Done'));
      await tester.pump(const Duration(milliseconds: 500));

      expect(find.text('Ready to try Prayer Mode?'), findsOneWidget);
      await tester.tap(find.text('Enable Prayer Mode'));
      await tester.pump();
      expect(enableTaps, 1);
    });
  });

  group('SettingsAppDemoScreen', () {
    testWidgets('mode picker opens walkthrough and back returns', (tester) async {
      tester.view.physicalSize = const Size(390, 844);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      await tester.pumpWidget(
        ScreenUtilInit(
          designSize: const Size(390, 844),
          builder: (_, _) => MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const SettingsAppDemoScreen(),
          ),
        ),
      );
      await tester.pump();

      expect(find.text('Experience App Lock'), findsOneWidget);
      expect(find.text('Prayer Mode'), findsOneWidget);
      expect(find.text('Sleep Mode'), findsOneWidget);
      expect(find.text('Child Mode'), findsOneWidget);
      expect(
        find.text('Pause distractions at Salah so you can pray with presence.'),
        findsOneWidget,
      );

      await tester.tap(find.text('Prayer Mode'));
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('See how App Lock works'), findsOneWidget);
      // Intro uses calendar-style header with mode title.
      expect(find.text('Prayer Mode'), findsWidgets);

      await tester.tap(find.text('Back').first);
      await tester.pump(const Duration(milliseconds: 300));
      expect(find.text('Experience App Lock'), findsOneWidget);
    });
  });
}
