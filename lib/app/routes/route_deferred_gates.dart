import 'package:flutter/material.dart';

import '../../core/logger/startup_handoff.dart';
import '../../core/logger/startup_probe.dart';
import '../../features/home/view/dashboard_screen.dart' deferred as home;
import '../../features/onboarding/view/onboarding_flow_screen.dart'
    deferred as onboarding;

/// Deferred loaders for heavy post-splash routes.
///
/// [createAppRouter] stays import-light; each gate calls `loadLibrary` when
/// that route is actually opened. Do not preload during splash — Dart
/// deferred libraries compile on the UI isolate and skip splash frames.
/// Services start only after the destination's first frame.

class HomeRouteGate extends StatefulWidget {
  const HomeRouteGate({super.key});

  @override
  State<HomeRouteGate> createState() => _HomeRouteGateState();
}

class _HomeRouteGateState extends State<HomeRouteGate> {
  Object? _error;
  bool _ready = false;
  bool _handedOff = false;

  @override
  void initState() {
    super.initState();
    StartupProbe.mark('HomeRouteGate.initState');
    _load();
  }

  Future<void> _load() async {
    StartupProbe.mark('HomeRouteGate.loadLibrary begin');
    try {
      await home.loadLibrary();
      StartupProbe.mark('HomeRouteGate.loadLibrary end');
      if (!mounted) return;
      setState(() => _ready = true);
    } catch (e) {
      StartupProbe.detail('HomeRouteGate.loadLibrary failed: $e');
      if (!mounted) return;
      setState(() => _error = e);
      _notifyDestinationReady(settleHomeContent: true);
    }
  }

  void _notifyDestinationReady({bool settleHomeContent = false}) {
    StartupHandoff.notifyFirstDestinationFrame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StartupProbe.markOnce('HomeRouteGate destination idle');
      StartupHandoff.notifyFirstDestinationIdle();
      if (settleHomeContent) {
        StartupHandoff.notifyHomeContentSettled();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Could not open home:\n$_error'),
          ),
        ),
      );
    }
    if (!_ready) {
      StartupProbe.markOnce('HomeRouteGate.spinner');
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (!_handedOff) {
      StartupProbe.markOnce('HomeRouteGate.DashboardScreen');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_handedOff) return;
        _handedOff = true;
        StartupProbe.markOnce('HomeRouteGate.Dashboard first frame');
        _notifyDestinationReady();
        StartupProbe.dumpSummary();
      });
    }
    return home.DashboardScreen();
  }
}

class OnboardingRouteGate extends StatefulWidget {
  const OnboardingRouteGate({super.key});

  @override
  State<OnboardingRouteGate> createState() => _OnboardingRouteGateState();
}

class _OnboardingRouteGateState extends State<OnboardingRouteGate> {
  Object? _error;
  bool _ready = false;
  bool _handedOff = false;

  @override
  void initState() {
    super.initState();
    StartupProbe.mark('OnboardingRouteGate.initState');
    _load();
  }

  Future<void> _load() async {
    StartupProbe.mark('OnboardingRouteGate.loadLibrary begin');
    try {
      await onboarding.loadLibrary();
      StartupProbe.mark('OnboardingRouteGate.loadLibrary end');
      if (!mounted) return;
      setState(() => _ready = true);
    } catch (e) {
      StartupProbe.detail('OnboardingRouteGate.loadLibrary failed: $e');
      if (!mounted) return;
      setState(() => _error = e);
      _notifyDestinationReady();
    }
  }

  void _notifyDestinationReady() {
    StartupHandoff.notifyFirstDestinationFrame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      StartupProbe.markOnce('OnboardingRouteGate destination idle');
      StartupHandoff.notifyFirstDestinationIdle();
      // No Home secondary path — still unblock Superwall quiet gate.
      StartupHandoff.notifyHomeContentSettled();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('Could not open onboarding:\n$_error'),
          ),
        ),
      );
    }
    if (!_ready) {
      StartupProbe.markOnce('OnboardingRouteGate.spinner');
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    if (!_handedOff) {
      StartupProbe.markOnce('OnboardingRouteGate.screen');
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_handedOff) return;
        _handedOff = true;
        StartupProbe.markOnce('OnboardingRouteGate first frame');
        _notifyDestinationReady();
        StartupProbe.dumpSummary();
      });
    }
    return onboarding.OnboardingFlowScreen();
  }
}
