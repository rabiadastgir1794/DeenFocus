import 'package:deenly/features/home/viewmodel/home_tab_view_model.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeTabViewModel month navigation', () {
    test('each next tap advances exactly one month', () {
      final vm = HomeTabViewModel();
      vm.visibleMonth = DateTime(2026, 8, 1);

      vm.goToNextMonth();
      expect(vm.visibleMonth, DateTime(2026, 9, 1));

      for (var i = 0; i < 4; i++) {
        vm.goToNextMonth();
      }
      expect(vm.visibleMonth, DateTime(2027, 1, 1));
    });

    test('each previous tap moves back exactly one month', () {
      final vm = HomeTabViewModel();
      vm.visibleMonth = DateTime(2026, 3, 1);

      vm.goToPreviousMonth();
      expect(vm.visibleMonth, DateTime(2026, 2, 1));

      for (var i = 0; i < 4; i++) {
        vm.goToPreviousMonth();
      }
      expect(vm.visibleMonth, DateTime(2025, 10, 1));
    });

    test('crosses year boundaries correctly', () {
      final vm = HomeTabViewModel();
      vm.visibleMonth = DateTime(2026, 12, 1);

      vm.goToNextMonth();
      expect(vm.visibleMonth, DateTime(2027, 1, 1));

      vm.goToPreviousMonth();
      expect(vm.visibleMonth, DateTime(2026, 12, 1));
    });

    test('rapid alternate taps stay consistent', () {
      final vm = HomeTabViewModel();
      vm.visibleMonth = DateTime(2026, 6, 1);

      vm.goToNextMonth();
      vm.goToNextMonth();
      vm.goToPreviousMonth();
      vm.goToNextMonth();
      vm.goToPreviousMonth();
      vm.goToPreviousMonth();

      expect(vm.visibleMonth, DateTime(2026, 6, 1));
    });

    test('month navigation ignores weeklyCalendar flag', () {
      final vm = HomeTabViewModel();
      vm.weeklyCalendar = true;
      vm.visibleMonth = DateTime(2026, 11, 1);
      vm.weeklyVisibleWeekStart = DateTime(2026, 11, 1);

      for (var i = 0; i < 5; i++) {
        vm.goToNextMonth();
      }

      expect(vm.visibleMonth, DateTime(2027, 4, 1));
    });
  });
}
