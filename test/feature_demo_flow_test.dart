import 'package:deenly/features/home/view/settings/settings_app_demo_screen.dart';
import 'package:deenly/features/onboarding/view/widgets/feature_demo/feature_demo_controller.dart';
import 'package:deenly/features/onboarding/view/widgets/feature_demo/feature_demo_kind.dart';
import 'package:deenly/features/onboarding/view/widgets/feature_demo/feature_demo_phase.dart';
import 'package:deenly/l10n/app_localizations.dart';
import 'package:flutter/foundation.dart';
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

  group('FeatureDemoController widgets', () {
    test('long-press → gallery → place → completion', () {
      final c = FeatureDemoController(
        kind: FeatureDemoKind.widgets,
        isCupertinoPlatform: true,
      );
      addTearDown(c.dispose);

      c.startDemo();
      expect(c.phase, FeatureDemoPhase.widgetsHome);

      c.longPressHome();
      expect(c.phase, FeatureDemoPhase.widgetsEditMode);

      c.openWidgetGallery();
      expect(c.phase, FeatureDemoPhase.widgetsGallery);

      c.selectWidgetSize(FeatureDemoWidgetSize.large);
      expect(c.widgetSize, FeatureDemoWidgetSize.large);

      c.confirmWidgetPlacement();
      expect(c.phase, FeatureDemoPhase.widgetsPlaced);

      c.finishWidgetsDemo();
      expect(c.phase, FeatureDemoPhase.completion);

      // Widgets cannot be auto-placed — no Yes/No enable offer.
      c.openEnableOffer();
      expect(c.phase, FeatureDemoPhase.completion);
    });
  });

  group('FeatureDemoController live activity', () {
    test('iOS path uses Dynamic Island phases', () {
      final c = FeatureDemoController(
        kind: FeatureDemoKind.liveActivity,
        isCupertinoPlatform: true,
      );
      addTearDown(c.dispose);

      c.startDemo();
      expect(c.phase, FeatureDemoPhase.liveSettings);

      c.enableLiveActivity();
      expect(c.liveActivityEnabled, isTrue);
      expect(c.phase, FeatureDemoPhase.liveLockScreen);

      c.advanceLiveActivity();
      expect(c.phase, FeatureDemoPhase.liveCompactIsland);
      c.advanceLiveActivity();
      expect(c.phase, FeatureDemoPhase.liveExpandedIsland);
      c.advanceLiveActivity();
      expect(c.phase, FeatureDemoPhase.completion);

      c.openEnableOffer();
      expect(c.phase, FeatureDemoPhase.enableOffer);
    });

    test('Android path uses notification shade phases', () {
      final c = FeatureDemoController(
        kind: FeatureDemoKind.liveActivity,
        isCupertinoPlatform: false,
      );
      addTearDown(c.dispose);

      c.startDemo();
      c.enableLiveActivity();
      expect(c.phase, FeatureDemoPhase.liveOngoingNotification);

      c.advanceLiveActivity();
      expect(c.phase, FeatureDemoPhase.liveNotificationShade);
      c.advanceLiveActivity();
      expect(c.phase, FeatureDemoPhase.completion);

      c.openEnableOffer();
      expect(c.phase, FeatureDemoPhase.enableOffer);
    });
  });

  group('SettingsAppDemoScreen', () {
    testWidgets('opens widgets walkthrough with long-press callout', (
      tester,
    ) async {
      tester.view.physicalSize = const Size(390, 1400);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() {
        tester.view.resetPhysicalSize();
        tester.view.resetDevicePixelRatio();
      });

      debugDefaultTargetPlatformOverride = TargetPlatform.iOS;
      try {
        await tester.pumpWidget(_wrap(const SettingsAppDemoScreen()));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Widgets'));
        await tester.pumpAndSettle();
        expect(find.text('See your Home Screen widgets'), findsOneWidget);

        await tester.tap(find.text('Start the demo'));
        await tester.pump(const Duration(milliseconds: 400));
        expect(
          find.text('Long-press the Home Screen to edit widgets'),
          findsOneWidget,
        );
      } finally {
        debugDefaultTargetPlatformOverride = null;
      }
    });
  });
}
