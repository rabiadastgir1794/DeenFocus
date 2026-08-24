import 'package:deenly/core/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Android Superwall define name matches dart_defines.json key', () {
    expect(
      AppConfig.superwallApiKeyAndroidDefine,
      'SUPERWALL_API_KEY_ANDROID',
    );
  });

  test(
    'Android Superwall key is non-empty when dart-defines are provided',
    () {
      // Run with: flutter test --dart-define-from-file=dart_defines.json
      final key = AppConfig.superwallApiKeyAndroid;
      expect(
        key.isNotEmpty,
        isTrue,
        reason:
            'SUPERWALL_API_KEY_ANDROID empty — pass '
            '--dart-define-from-file=dart_defines.json',
      );
      expect(key.length, 24);
      expect(key.startsWith('pk_'), isTrue);
    },
    // Only meaningful when defines are injected at compile time.
    skip: AppConfig.superwallApiKeyAndroid.isEmpty
        ? 'Requires --dart-define-from-file=dart_defines.json'
        : false,
  );
}
