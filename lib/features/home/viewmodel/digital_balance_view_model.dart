import 'dart:async';

import 'package:flutter/widgets.dart';

import '../../../core/services/app_usage_service.dart';
import '../../../core/services/storage_service.dart';
import '../helpers/digital_balance_math.dart';
import '../model/digital_balance_models.dart';

class DigitalBalanceViewModel extends ChangeNotifier
    with WidgetsBindingObserver {
  DigitalBalanceViewModel();

  AppUsageAvailability availability = AppUsageAvailability.denied;
  DigitalBalanceSnapshot? snapshot;
  bool loading = true;
  int goalMinutes = DigitalBalanceMath.defaultGoalMinutes;
  bool _observing = false;

  void attach() {
    if (_observing) return;
    WidgetsBinding.instance.addObserver(this);
    _observing = true;
    unawaited(refresh());
  }

  @override
  void dispose() {
    if (_observing) {
      WidgetsBinding.instance.removeObserver(this);
      _observing = false;
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(refresh());
    }
  }

  Future<void> refresh() async {
    goalMinutes = DigitalBalanceMath.clampGoalMinutes(
      await StorageService.digitalBalanceGoalMinutes,
    );
    final result = await AppUsageService.queryUsage();
    availability = result.availability;
    snapshot = availability == AppUsageAvailability.granted
        ? DigitalBalanceMath.buildSnapshot(
            availability: availability,
            days: result.days,
            now: DateTime.now(),
            goalMinutes: goalMinutes,
          )
        : null;
    loading = false;
    notifyListeners();
  }

  Future<void> requestAccess() async {
    loading = true;
    notifyListeners();
    availability = await AppUsageService.requestAccess();
    await refresh();
  }

  Future<void> setGoalMinutes(int minutes) async {
    goalMinutes = DigitalBalanceMath.clampGoalMinutes(minutes);
    await StorageService.setDigitalBalanceGoalMinutes(goalMinutes);
    final current = snapshot;
    if (current != null) {
      snapshot = DigitalBalanceSnapshot(
        availability: current.availability,
        today: current.today,
        thisWeek: current.thisWeek,
        lastWeek: current.lastWeek,
        topApps: current.topApps,
        allTodayApps: current.allTodayApps,
        insight: current.insight,
        goalMinutes: goalMinutes,
      );
    }
    notifyListeners();
  }
}
