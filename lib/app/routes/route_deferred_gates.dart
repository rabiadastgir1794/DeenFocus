import 'package:flutter/material.dart';

import '../../features/home/view/dashboard_screen.dart' deferred as home;
import '../../features/onboarding/view/onboarding_flow_screen.dart'
    deferred as onboarding;

/// Shared deferred libraries for heavy post-splash routes.
///
/// Keeping loadLibrary entrypoints in one library means splash can preload
/// during its visible delay while [createAppRouter] stays import-light.
Future<void> preloadHomeRouteLibrary() => home.loadLibrary();

Future<void> preloadOnboardingRouteLibrary() => onboarding.loadLibrary();

Future<void> preloadPostSplashRouteLibraries() => Future.wait<void>([
      preloadHomeRouteLibrary(),
      preloadOnboardingRouteLibrary(),
    ]);

class HomeRouteGate extends StatefulWidget {
  const HomeRouteGate({super.key});

  @override
  State<HomeRouteGate> createState() => _HomeRouteGateState();
}

class _HomeRouteGateState extends State<HomeRouteGate> {
  Object? _error;
  bool _ready = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await home.loadLibrary();
      if (!mounted) return;
      setState(() => _ready = true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
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

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      await onboarding.loadLibrary();
      if (!mounted) return;
      setState(() => _ready = true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e);
    }
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
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return onboarding.OnboardingFlowScreen();
  }
}
