import 'package:flutter_test/flutter_test.dart';

import 'package:deenly/features/tajweed/viewmodel/tajweed_practice_view_model.dart';

void main() {
  tearDown(TajweedModelSession.resetForTest);

  test('invalidateBecauseDeleted clears ready and identity', () {
    TajweedModelSession.ready = true;
    TajweedModelSession.boundVersion = '1.0.0';
    TajweedModelSession.boundEncoderSha = 'abc';
    TajweedModelSession.invalidateBecauseDeleted();
    expect(TajweedModelSession.ready, isFalse);
    expect(TajweedModelSession.boundVersion, isNull);
    expect(TajweedModelSession.boundEncoderSha, isNull);
  });

  test('invalidateBecauseDevSourceSwitch clears ready', () {
    TajweedModelSession.ready = true;
    TajweedModelSession.invalidateBecauseDevSourceSwitch();
    expect(TajweedModelSession.ready, isFalse);
  });

  test('invalidateBecausePackIdentityChanged clears ready', () {
    TajweedModelSession.ready = true;
    TajweedModelSession.boundVersion = '1.0.0';
    TajweedModelSession.invalidateBecausePackIdentityChanged();
    expect(TajweedModelSession.ready, isFalse);
    expect(TajweedModelSession.boundVersion, isNull);
  });
}
