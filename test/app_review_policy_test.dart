import 'package:deenly/core/services/app_review_policy.dart';
import 'package:deenly/core/services/app_review_service.dart';
import 'package:deenly/core/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    AppReviewService.setCelebrationsBlocking(false);
  });

  group('AppReviewPolicy sessions', () {
    test('does not treat the first or second session as eligible', () {
      final now = DateTime(2026, 8, 19);
      expect(
        AppReviewPolicy.isAutomaticEligible(
          sessionCount: 1,
          completedPrayers: 10,
          hasUnlockedAchievement: true,
          now: now,
        ),
        isFalse,
      );
      expect(
        AppReviewPolicy.isAutomaticEligible(
          sessionCount: 2,
          completedPrayers: 10,
          hasUnlockedAchievement: true,
          now: now,
        ),
        isFalse,
      );
    });

    test('third session is eligible when prayers and achievement are met', () {
      expect(
        AppReviewPolicy.isAutomaticEligible(
          sessionCount: 3,
          completedPrayers: 3,
          hasUnlockedAchievement: true,
          now: DateTime(2026, 8, 19),
        ),
        isTrue,
      );
    });

    test('session gap starts a new session after 30 minutes', () {
      final first = DateTime(2026, 8, 19, 10, 0);
      expect(
        AppReviewPolicy.shouldStartNewSession(now: first, lastSessionAt: null),
        isTrue,
      );
      expect(
        AppReviewPolicy.shouldStartNewSession(
          now: first.add(const Duration(minutes: 29)),
          lastSessionAt: first,
        ),
        isFalse,
      );
      expect(
        AppReviewPolicy.shouldStartNewSession(
          now: first.add(const Duration(minutes: 30)),
          lastSessionAt: first,
        ),
        isTrue,
      );
      expect(
        AppReviewPolicy.sessionCountAfterRecording(
          currentCount: 2,
          startedNewSession: true,
        ),
        3,
      );
    });
  });

  group('AppReviewPolicy requirements', () {
    test('requires at least 3 completed prayers', () {
      expect(
        AppReviewPolicy.isAutomaticEligible(
          sessionCount: 3,
          completedPrayers: 2,
          hasUnlockedAchievement: true,
          now: DateTime(2026, 8, 19),
        ),
        isFalse,
      );
    });

    test('requires a first achievement unlock', () {
      expect(
        AppReviewPolicy.isAutomaticEligible(
          sessionCount: 3,
          completedPrayers: 3,
          hasUnlockedAchievement: false,
          now: DateTime(2026, 8, 19),
        ),
        isFalse,
      );
    });

    test('waits while an achievement or level-up dialog is showing', () {
      expect(
        AppReviewPolicy.isAutomaticEligible(
          sessionCount: 3,
          completedPrayers: 3,
          hasUnlockedAchievement: true,
          now: DateTime(2026, 8, 19),
          celebrationsBlocking: true,
        ),
        isFalse,
      );
    });
  });

  group('AppReviewPolicy cooldown and annual limit', () {
    test('enforces a 30-day cooldown after an automatic prompt', () {
      final shown = DateTime(2026, 8, 1);
      expect(
        AppReviewPolicy.isAutomaticEligible(
          sessionCount: 5,
          completedPrayers: 10,
          hasUnlockedAchievement: true,
          now: shown.add(const Duration(days: 29)),
          lastAutomaticPromptAt: shown,
        ),
        isFalse,
      );
      expect(
        AppReviewPolicy.isAutomaticEligible(
          sessionCount: 5,
          completedPrayers: 10,
          hasUnlockedAchievement: true,
          now: shown.add(const Duration(days: 30)),
          lastAutomaticPromptAt: shown,
        ),
        isTrue,
      );
    });

    test('caps automatic prompts at 3 per year', () {
      final now = DateTime(2026, 8, 19);
      final history = <DateTime>[
        DateTime(2026, 1, 1),
        DateTime(2026, 4, 1),
        DateTime(2026, 7, 1),
      ];
      expect(
        AppReviewPolicy.isAutomaticEligible(
          sessionCount: 8,
          completedPrayers: 20,
          hasUnlockedAchievement: true,
          now: now,
          lastAutomaticPromptAt: DateTime(2026, 7, 1),
          automaticPromptAt: history,
        ),
        isFalse,
      );
      expect(
        AppReviewPolicy.isAutomaticEligible(
          sessionCount: 8,
          completedPrayers: 20,
          hasUnlockedAchievement: true,
          now: now,
          lastAutomaticPromptAt: DateTime(2025, 7, 1),
          automaticPromptAt: <DateTime>[
            DateTime(2025, 7, 1),
            DateTime(2026, 4, 1),
          ],
        ),
        isTrue,
      );
    });
  });

  group('AppReview persistence', () {
    test('session count survives a simulated restart', () async {
      final first = DateTime(2026, 8, 1, 9);
      await AppReviewService.recordMeaningfulSession(now: first);
      expect(await StorageService.appReviewSessionCount, 1);

      await AppReviewService.recordMeaningfulSession(
        now: first.add(const Duration(minutes: 5)),
      );
      expect(await StorageService.appReviewSessionCount, 1);

      await AppReviewService.recordMeaningfulSession(
        now: first.add(const Duration(hours: 1)),
      );
      expect(await StorageService.appReviewSessionCount, 2);

      expect(await StorageService.appReviewSessionCount, 2);
    });

    test('automatic prompt history is persisted', () async {
      final now = DateTime(2026, 8, 19);
      await StorageService.recordAppReviewAutomaticPrompt(now);
      expect(await StorageService.appReviewLastAutomaticAt, now);
      final history = await StorageService.appReviewAutomaticHistory;
      expect(history, <DateTime>[now]);
    });

    test('migrates the legacy one-shot prompt into a cooldown', () async {
      SharedPreferences.setMockInitialValues(<String, Object>{
        'app_review_prompt_completed': true,
      });
      final now = DateTime(2026, 8, 19);
      await StorageService.migrateLegacyAppReviewPromptIfNeeded(now: now);
      expect(await StorageService.appReviewLastAutomaticAt, now);
      expect(await StorageService.appReviewAutomaticHistory, <DateTime>[now]);
      expect(
        AppReviewPolicy.isAutomaticEligible(
          sessionCount: 5,
          completedPrayers: 10,
          hasUnlockedAchievement: true,
          now: now.add(const Duration(days: 1)),
          lastAutomaticPromptAt: await StorageService.appReviewLastAutomaticAt,
          automaticPromptAt: await StorageService.appReviewAutomaticHistory,
        ),
        isFalse,
      );
    });
  });

  test('manual Settings request is not blocked by automatic eligibility', () async {
    expect(
      AppReviewPolicy.isAutomaticEligible(
        sessionCount: 1,
        completedPrayers: 0,
        hasUnlockedAchievement: false,
        now: DateTime(2026, 8, 19),
      ),
      isFalse,
    );
    await AppReviewService.requestReviewManually();
    expect(await StorageService.appReviewLastAutomaticAt, isNull);
    expect(await StorageService.appReviewAutomaticHistory, isEmpty);
  });
}
