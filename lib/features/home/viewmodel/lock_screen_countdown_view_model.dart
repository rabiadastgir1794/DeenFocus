import 'dart:async';

import 'package:flutter/widgets.dart';

/// Wall-clock countdown with a synchronized progress fraction.
class LockScreenCountdownViewModel extends ChangeNotifier
    with WidgetsBindingObserver {
  LockScreenCountdownViewModel({
    required DateTime target,
    required Duration total,
    DateTime Function()? clock,
  }) : _target = target,
       _total = total <= Duration.zero ? const Duration(seconds: 1) : total,
       _clock = clock ?? DateTime.now {
    _tick();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => _tick());
    WidgetsBinding.instance.addObserver(this);
  }

  factory LockScreenCountdownViewModel.fromRemaining(
    Duration remaining, {
    DateTime Function()? clock,
  }) {
    final nowFn = clock ?? DateTime.now;
    final safe = remaining.isNegative ? Duration.zero : remaining;
    final now = nowFn();
    return LockScreenCountdownViewModel(
      target: now.add(safe),
      total: safe <= Duration.zero ? const Duration(seconds: 1) : safe,
      clock: nowFn,
    );
  }

  final DateTime _target;
  final Duration _total;
  final DateTime Function() _clock;
  Timer? _timer;
  Duration _remaining = Duration.zero;
  bool _complete = false;

  Duration get remaining => _remaining;
  bool get complete => _complete;

  double get progress {
    final totalMs = _total.inMilliseconds;
    if (totalMs <= 0) return 1;
    final elapsed = totalMs - _remaining.inMilliseconds;
    return (elapsed / totalMs).clamp(0.0, 1.0);
  }

  String get clockLabel {
    final hours = _remaining.inHours;
    final minutes = _remaining.inMinutes
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    final seconds = _remaining.inSeconds
        .remainder(60)
        .toString()
        .padLeft(2, '0');
    return '$hours:$minutes:$seconds';
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      _tick();
    }
  }

  void _tick() {
    final next = _target.difference(_clock());
    if (next.isNegative || next == Duration.zero) {
      _remaining = Duration.zero;
      _complete = true;
      _timer?.cancel();
    } else {
      _remaining = next;
    }
    notifyListeners();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    super.dispose();
  }
}
