import 'package:deenly/core/services/storage_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    StorageService.debugResetOnboardingCache();
    SharedPreferences.setMockInitialValues({});
  });

  test('warmed completed flag is true without a timeout', () async {
    SharedPreferences.setMockInitialValues({'onboarding_completed': true});
    await StorageService.warmOnboardingCompleted();
    expect(await StorageService.onboardingCompleted, isTrue);
  });

  test('missing flag is false (onboarding)', () async {
    await StorageService.warmOnboardingCompleted();
    expect(await StorageService.onboardingCompleted, isFalse);
  });

  test('setOnboardingCompleted updates cache for later reads', () async {
    await StorageService.setOnboardingCompleted(true);
    expect(await StorageService.onboardingCompleted, isTrue);
  });
}
