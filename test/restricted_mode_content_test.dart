import 'package:deenly/features/focus/model/restricted_mode_content.dart';
import 'package:deenly/features/onboarding/view/widgets/app_lock_demo/app_lock_demo_mode.dart';
import 'package:deenly/l10n/app_localizations_en.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final l10n = AppLocalizationsEn();

  test('restricted mode copy matches Salah / Child / Night specs', () {
    final salah = RestrictedModeContent.resolve(l10n, RestrictedModeKind.salah);
    expect(salah.title, 'Salah Time');
    expect(
      salah.message,
      "It's time to step away from distractions and answer the call to prayer.",
    );
    expect(salah.info, 'Some apps are temporarily unavailable.');
    expect(salah.cta, 'Start Salah');
    expect(salah.quote, 'Establish prayer for My remembrance.');
    expect(salah.quoteSource, 'Quran 20:14');

    final child = RestrictedModeContent.resolve(l10n, RestrictedModeKind.child);
    expect(child.title, 'Child Focus Mode');
    expect(
      child.message,
      'A safer, more balanced space for focused screen time.',
    );
    expect(child.cta, 'Stay Protected');

    final night = RestrictedModeContent.resolve(l10n, RestrictedModeKind.night);
    expect(night.title, 'Night Focus Mode');
    expect(night.cta, 'Good Night');
    expect(night.quote, 'And We made your sleep a means for rest.');
    expect(night.quoteSource, 'Quran 78:9');
    expect(child.quote, 'Teach your children prayer when they are seven.');
  });

  test('demo modes map onto restricted kinds', () {
    expect(
      RestrictedModeKindX.fromDemo(AppLockDemoMode.prayer),
      RestrictedModeKind.salah,
    );
    expect(
      RestrictedModeKindX.fromDemo(AppLockDemoMode.child),
      RestrictedModeKind.child,
    );
    expect(
      RestrictedModeKindX.fromDemo(AppLockDemoMode.sleep),
      RestrictedModeKind.night,
    );
  });
}
