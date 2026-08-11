import 'dart:async';

import 'package:deenly/features/onboarding/view/onboarding_focus_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../../../app/routes/route_names.dart';
import '../../../core/constants/app_languages.dart';
import '../../../core/constants/spacing.dart';
import '../../../core/services/locale_service.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/superwall/app_superwall.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../../focus/services/focus_app_selection_flow.dart';
import '../../focus/viewmodel/focus_controller.dart';
import '../viewmodel/onboarding_view_model.dart';
import 'onboarding_name_page.dart';
import 'onboarding_location_page.dart';
import 'onboarding_notifications_page.dart';
import 'onboarding_screen_time_page.dart';
import 'onboarding_sect_page.dart';
import 'onboarding_app_lock_demo_page.dart';
import 'onboarding_select_apps_page.dart';
import 'onboarding_subscription_page.dart';
import 'onboarding_welcome_page.dart';
import 'widgets/onboarding_theme_toggle.dart';

class OnboardingFlowScreen extends StatefulWidget {
  const OnboardingFlowScreen({super.key});

  @override
  State<OnboardingFlowScreen> createState() => _OnboardingFlowScreenState();
}

class _OnboardingFlowScreenState extends State<OnboardingFlowScreen> {
  late PageController _pageController;
  late TextEditingController _nameController;
  late final OnboardingViewModel _onboardingViewModel = OnboardingViewModel();

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _onboardingViewModel.dispose();
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: _onboardingViewModel,
      child: _OnboardingFlowContent(
        pageController: _pageController,
        nameController: _nameController,
      ),
    );
  }
}

class _OnboardingFlowContent extends StatefulWidget {
  const _OnboardingFlowContent({
    required this.pageController,
    required this.nameController,
  });

  final PageController pageController;
  final TextEditingController nameController;

  @override
  State<_OnboardingFlowContent> createState() => _OnboardingFlowContentState();
}

class _OnboardingFlowContentState extends State<_OnboardingFlowContent>
    with WidgetsBindingObserver {
  bool _scheduledPostOnboardingNavigation = false;
  bool _scheduledLocationAutoAdvance = false;
  bool _isAdvancingPage = false;
  bool _selectAppsAutoAdvancing = false;
  bool _appLockDemoImmersive = false;
  Timer? _selectAppsAutoAdvanceTimer;
  OnboardingViewModel? _listeningVm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final vm = context.read<OnboardingViewModel>();
    if (_listeningVm == vm) return;
    _listeningVm?.removeListener(_onOnboardingViewModelChanged);
    _listeningVm = vm;
    _listeningVm!.addListener(_onOnboardingViewModelChanged);
  }

  @override
  void dispose() {
    _selectAppsAutoAdvanceTimer?.cancel();
    _listeningVm?.removeListener(_onOnboardingViewModelChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _cancelSelectAppsAutoAdvance() {
    _selectAppsAutoAdvanceTimer?.cancel();
    _selectAppsAutoAdvanceTimer = null;
    if (_selectAppsAutoAdvancing && mounted) {
      setState(() => _selectAppsAutoAdvancing = false);
    } else {
      _selectAppsAutoAdvancing = false;
    }
  }

  void _scheduleSelectAppsAutoAdvance(OnboardingViewModel vm) {
    _selectAppsAutoAdvanceTimer?.cancel();
    setState(() => _selectAppsAutoAdvancing = true);
    _selectAppsAutoAdvanceTimer = Timer(const Duration(seconds: 2), () {
      if (!mounted) return;
      setState(() => _selectAppsAutoAdvancing = false);
      final current = context.read<OnboardingViewModel>();
      if (current.isSelectAppsStep) {
        unawaited(_goToNextPage(current));
      }
    });
  }

  void _onOnboardingViewModelChanged() {
    final vm = _listeningVm;
    if (vm == null || !vm.shouldAutoAdvanceFromLocation) return;
    if (_scheduledLocationAutoAdvance) return;

    _scheduledLocationAutoAdvance = true;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scheduledLocationAutoAdvance = false;
      if (!mounted) return;
      final currentVm = context.read<OnboardingViewModel>();
      if (!currentVm.shouldAutoAdvanceFromLocation) return;
      currentVm.acknowledgeLocationAutoAdvance();
      _goToNextPage(currentVm);
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) return;

    final vm = context.read<OnboardingViewModel>();
    final wasOnNotificationStep = vm.isNotificationStep;
    final notificationGrantedBefore = vm.notificationGranted;

    vm.recheckPermissions().then((_) {
      if (!mounted) return;
      final current = context.read<OnboardingViewModel>();
      if (wasOnNotificationStep &&
          !notificationGrantedBefore &&
          current.notificationGranted) {
        _goToNextPage(current);
      }
    });
  }

  AppLanguage _currentAppLanguage(LocaleService localeService) {
    final englishDefault = kAppLanguages.firstWhere(
      (l) => l.locale.languageCode == 'en',
      orElse: () => kAppLanguages.first,
    );

    return kAppLanguages.firstWhere(
      (l) => l.localeCode == localeService.localeCode,
      orElse: () => englishDefault,
    );
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final localeService = context.read<LocaleService>();
    final l10n = AppLocalizations.of(context)!;
    final englishDefault = kAppLanguages.firstWhere(
      (l) => l.locale.languageCode == 'en',
      orElse: () => kAppLanguages.first,
    );

    final isCurrentLocaleSupported = kAppLanguages.any(
      (l) => l.localeCode == localeService.localeCode,
    );
    if (!isCurrentLocaleSupported) {
      await localeService.setLocale(englishDefault.locale);
    }
    if (!context.mounted) return;

    await showCupertinoModalPopup<void>(
      context: context,
      builder: (ctx) {
        final colorScheme = Theme.of(ctx).colorScheme;
        final maxSheetHeight = MediaQuery.of(ctx).size.height * 0.78;
        return SafeArea(
          child: Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              margin: EdgeInsets.fromLTRB(12.w, 0, 12.w, 12.h),
              decoration: BoxDecoration(
                color: Theme.of(ctx).scaffoldBackgroundColor,
                borderRadius: BorderRadius.circular(18.r),
                border: Border.all(
                  color: colorScheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
              child: ConstrainedBox(
                constraints: BoxConstraints(maxHeight: maxSheetHeight),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Padding(
                      padding: EdgeInsets.fromLTRB(16.w, 12.h, 16.w, 8.h),
                      child: Text(
                        l10n.language,
                        style: TextStyle(
                          fontSize: 13.sp,
                          fontWeight: FontWeight.w600,
                          color: colorScheme.onSurfaceVariant,
                          decoration: TextDecoration.none,
                        ),
                      ),
                    ),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            for (final language in kAppLanguages)
                              CupertinoButton(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 16.w,
                                  vertical: 10.h,
                                ),
                                onPressed: () async {
                                  Navigator.of(ctx).pop();
                                  await localeService.setLocale(
                                    language.locale,
                                  );
                                },
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(language.flag),
                                        SizedBox(width: 8.w),
                                        Text(
                                          language.label,
                                          style: TextStyle(
                                            fontSize: 15.sp,
                                            color: colorScheme.onSurface,
                                            decoration: TextDecoration.none,
                                          ),
                                        ),
                                      ],
                                    ),
                                    if (language.localeCode ==
                                        localeService.localeCode)
                                      Icon(
                                        CupertinoIcons.checkmark,
                                        color: colorScheme.primary,
                                        size: 18.sp,
                                      ),
                                  ],
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.fromLTRB(12.w, 4.h, 12.w, 12.h),
                      child: SizedBox(
                        width: double.infinity,
                        child: CupertinoButton(
                          color: colorScheme.surfaceContainerHighest,
                          borderRadius: BorderRadius.circular(12.r),
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: Text(
                            l10n.cancel,
                            style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              color: colorScheme.onSurface,
                              decoration: TextDecoration.none,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _onNotificationEnableTap(
    BuildContext context,
    OnboardingViewModel vm,
  ) async {
    final status = await vm.requestNotification();
    if (!context.mounted) return;

    if (status.isGranted || status.isLimited) {
      await _goToNextPage(vm);
      return;
    }

    if (status.isPermanentlyDenied) {
      final l10n = AppLocalizations.of(context)!;
      await AppPermissionDialog.show(
        context,
        title: l10n.notificationsRequired,
        message: l10n.notificationsRequiredMessage,
        primaryButtonText: l10n.openSettings,
        secondaryButtonText: l10n.cancel,
        onPrimaryTap: () => PermissionService.openAppSettingsAsync(),
        onSecondaryTap: () {},
      );
      if (!context.mounted) return;
      await vm.recheckPermissions();
      if (vm.notificationGranted) {
        await _goToNextPage(vm);
      }
    }
  }

  Future<void> _onScreenTimeAllowTap(
    BuildContext context,
    OnboardingViewModel vm,
  ) async {
    final result = await vm.requestScreenTime();
    if (!context.mounted) return;
    if (result.granted) {
      await _goToNextPage(vm);
    }
  }

  Future<void> _goToNextPage(OnboardingViewModel vm) async {
    if (_isAdvancingPage) return;
    if (vm.currentIndex >= vm.totalSteps - 1) return;
    if (!widget.pageController.hasClients) return;

    _cancelSelectAppsAutoAdvance();
    _isAdvancingPage = true;
    FocusManager.instance.primaryFocus?.unfocus();
    final nextIndex = vm.currentIndex + 1;
    try {
      await widget.pageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } finally {
      _isAdvancingPage = false;
    }
  }

  Future<void> _goToPreviousPage(OnboardingViewModel vm) async {
    if (_isAdvancingPage) return;
    if (vm.currentIndex <= 0) return;
    if (!widget.pageController.hasClients) return;

    _cancelSelectAppsAutoAdvance();
    _isAdvancingPage = true;
    FocusManager.instance.primaryFocus?.unfocus();
    final prevIndex = vm.currentIndex - 1;
    try {
      await widget.pageController.animateToPage(
        prevIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } finally {
      _isAdvancingPage = false;
    }
  }

  Future<void> _skipToLocationStep(OnboardingViewModel vm) async {
    await widget.pageController.animateToPage(
      OnboardingViewModel.locationStepIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _onSkipPressed(OnboardingViewModel vm) async {
    if (vm.isLocationStep ||
        vm.isNotificationStep ||
        vm.isScreenTimeStep ||
        vm.isSelectAppsStep ||
        vm.isAppLockDemoStep) {
      await _goToNextPage(vm);
      return;
    }
    await _skipToLocationStep(vm);
  }

  Future<void> _onSelectAppsTap(
    BuildContext context,
    OnboardingViewModel vm,
  ) async {
    if (vm.selectAppsLoading || _selectAppsAutoAdvancing) return;
    vm.setSelectAppsLoading(true);
    try {
      // Skip premium during onboarding — App Lock Demo + subscription follow.
      await FocusAppSelectionFlow.open(
        context: context,
        requirePremium: false,
        requireAccessibilityDisclosure: true,
      );
    } finally {
      if (context.mounted) {
        vm.setSelectAppsLoading(false);
      }
    }
    if (!context.mounted) return;
    final focus = context.read<FocusController>();
    // After a real selection, show the Focus-style count chip then continue.
    if (focus.selectedAppCount > 0) {
      _scheduleSelectAppsAutoAdvance(vm);
    }
  }

  Widget _buildTopBar(
    BuildContext context,
    OnboardingViewModel vm,
    LocaleService localeService,
  ) {
    final current = _currentAppLanguage(localeService);
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isWelcomeStep = vm.currentIndex == 0;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.md.w,
        vertical: Spacing.sm.h,
      ),
      child: Row(
        children: [
          Visibility(
            visible: vm.showLanguageChangeOption,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: AppLanguageSelectorChip(
              label: current.label,
              flagEmoji: current.flag,
              onTap: () => _showLanguagePicker(context),
              backgroundColor: isWelcomeStep
                  ? colorScheme.surface.withValues(alpha: 0.72)
                  : null,
              borderColor: isWelcomeStep
                  ? colorScheme.outlineVariant.withValues(alpha: 0.45)
                  : null,
            ),
          ),
          const Spacer(),
          if (isWelcomeStep) ...[
            const OnboardingThemeToggle(),
            SizedBox(width: Spacing.sm.w),
          ],
          Visibility(
            visible: vm.showSkip,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: TextButton(
              onPressed: () => _onSkipPressed(vm),
              style: TextButton.styleFrom(
                foregroundColor:
                    isWelcomeStep ||
                        vm.isLocationStep ||
                        vm.isNotificationStep ||
                        vm.isScreenTimeStep ||
                        vm.isSelectAppsStep ||
                        vm.isAppLockDemoStep
                    ? colorScheme.onSurfaceVariant
                    : colorScheme.primary,
                padding: EdgeInsets.symmetric(horizontal: Spacing.sm.w),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                l10n.skip,
                style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.w500),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<OnboardingViewModel>();
    final localeService = context.watch<LocaleService>();
    vm.setSelectedLanguageCode(localeService.localeCode);

    if (vm.didComplete && !_scheduledPostOnboardingNavigation) {
      _scheduledPostOnboardingNavigation = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        context.go(RouteNames.home);
      });
    }

    final isScreenTimeStep =
        vm.currentIndex == OnboardingViewModel.screenTimeStepIndex;
    final isBusyScreenTimeStep = isScreenTimeStep && vm.screenTimeRequesting;
    final isBusySelectAppsStep = vm.isSelectAppsStep &&
        (vm.selectAppsLoading || _selectAppsAutoAdvancing);
    final isWelcomeStep = vm.currentIndex == 0;
    final demoImmersive = vm.isAppLockDemoStep && _appLockDemoImmersive;
    final l10n = AppLocalizations.of(context)!;

    // Keep PageView in one stable slot. Remounting it when immersive toggles
    // resets the controller to page 0 (welcome) — that was the Start Demo bug.
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: demoImmersive ? Colors.black : null,
      body: AbsorbPointer(
        absorbing: isBusyScreenTimeStep || isBusySelectAppsStep,
        child: Stack(
          fit: StackFit.expand,
          children: [
            SafeArea(
              top: !demoImmersive,
              bottom: false,
              child: Column(
                children: [
                  if (!demoImmersive && !isWelcomeStep)
                    AppStepProgressLine(
                      totalSteps: vm.totalSteps,
                      currentIndex: vm.currentIndex,
                    ),
                  if (!demoImmersive)
                    _buildTopBar(context, vm, localeService),
                  Expanded(
                    child: PageView(
                      key: const ValueKey('onboarding_page_view'),
                      controller: widget.pageController,
                      physics: const NeverScrollableScrollPhysics(),
                      onPageChanged: (index) {
                        if (vm.currentIndex ==
                                OnboardingViewModel.locationStepIndex &&
                            index != OnboardingViewModel.locationStepIndex) {
                          FocusManager.instance.primaryFocus?.unfocus();
                        }
                        if (index !=
                                OnboardingViewModel.appLockDemoStepIndex &&
                            _appLockDemoImmersive) {
                          setState(() => _appLockDemoImmersive = false);
                        }
                        vm.setStep(index);
                      },
                      children: [
                        const OnboardingWelcomePage(),
                        const OnboardingFocusModePage(),
                        OnboardingSectPage(
                          selectedSect: vm.selectedSect,
                          onSectSelected: vm.setSelectedSect,
                        ),
                        OnboardingNamePage(
                          controller: widget.nameController,
                          onChanged: vm.setUserName,
                        ),
                        OnboardingLocationPage(
                          initialSelection: vm.selectedLocation,
                          onLocationSelected: vm.setSelectedLocation,
                          onPermissionChanged: vm.setLocationGranted,
                          onPermissionLocationResolved:
                              vm.applyPermissionLocation,
                        ),
                        OnboardingNotificationsPage(
                          onEnableTap: () =>
                              _onNotificationEnableTap(context, vm),
                          isLoading: vm.notificationRequesting,
                          showEnableButton: !vm.notificationGranted,
                        ),
                        OnboardingScreenTimePage(
                          onAllowTap: () =>
                              _onScreenTimeAllowTap(context, vm),
                          isLoading: vm.screenTimeRequesting,
                        ),
                        OnboardingSelectAppsPage(
                          onSelectAppsTap: () =>
                              _onSelectAppsTap(context, vm),
                          onSkipForNowTap: () => _goToNextPage(vm),
                          isLoading: vm.selectAppsLoading,
                          isAutoAdvancing: _selectAppsAutoAdvancing,
                        ),
                        OnboardingAppLockDemoPage(
                          isActive: vm.isAppLockDemoStep,
                          onComplete: () => _goToNextPage(vm),
                          onExitToPrevious: () => _goToPreviousPage(vm),
                          onImmersiveChanged: (immersive) {
                            if (!mounted) return;
                            if (_appLockDemoImmersive == immersive) return;
                            // Defer so we never setState during PageView build.
                            WidgetsBinding.instance.addPostFrameCallback((_) {
                              if (!mounted) return;
                              if (_appLockDemoImmersive == immersive) return;
                              setState(
                                () => _appLockDemoImmersive = immersive,
                              );
                            });
                          },
                        ),
                        OnboardingSubscriptionPage(
                          selectedPlan: vm.selectedPlan,
                          onPlanSelected: vm.setSelectedPlan,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (demoImmersive)
              SafeArea(
                child: Align(
                  alignment: Alignment.topRight,
                  child: TextButton(
                    onPressed: () => _onSkipPressed(vm),
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white.withValues(alpha: 0.92),
                      padding: EdgeInsets.symmetric(
                        horizontal: Spacing.md.w,
                        vertical: 8.h,
                      ),
                    ),
                    child: Text(
                      l10n.skip,
                      style: TextStyle(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w600,
                        shadows: const [
                          Shadow(blurRadius: 8, color: Colors.black54),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
      bottomNavigationBar: demoImmersive
          ? null
          : SafeArea(
        top: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            Spacing.lg.w,
            vm.isAppLockDemoStep ? 10 : 16,
            Spacing.lg.w,
            Spacing.md.h,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (vm.isAppLockDemoStep) ...[
                // Intro / completion: shared onboarding stepper only.
                AppProgressIndicator(
                  totalSteps: vm.totalSteps,
                  currentIndex: vm.currentIndex,
                ),
              ] else if (vm.currentIndex == vm.totalSteps - 1) ...[
                SizedBox(
                  width: double.infinity,
                  height: 56.h,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Complete onboarding → Home first. Superwall is presented
                      // once from Dashboard for non-subscribers only.
                      if (!AppSuperwall.subscriptionActiveNotifier.value) {
                        await StorageService.setPendingPostOnboardingPaywall(
                          true,
                        );
                      }
                      vm.goNext();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      elevation: 0,
                      shadowColor: Colors.transparent,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16.r),
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 16.w),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Flexible(
                          child: Text(
                            AppLocalizations.of(context)!.getStarted,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.w700,
                              color: Theme.of(context).colorScheme.onPrimary,
                            ),
                          ),
                        ),
                        SizedBox(width: 6.w),
                        Icon(
                          Icons.chevron_right_rounded,
                          size: 22.sp,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 12.h),
                TextButton(
                  onPressed: vm.goNext,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.symmetric(
                      horizontal: 12.w,
                      vertical: 8.h,
                    ),
                    foregroundColor: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withValues(alpha: 0.72),
                  ),
                  child: Text(
                    AppLocalizations.of(context)!.continueForFree,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13.5.sp,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: Spacing.md.h),
                AppProgressIndicator(
                  totalSteps: vm.totalSteps,
                  currentIndex: vm.currentIndex,
                ),
              ] else ...[
                AppButton(
                  label: AppLocalizations.of(context)!.continueButton,
                  enabled: !vm.isContinueDisabled &&
                      !isBusyScreenTimeStep &&
                      !isBusySelectAppsStep,
                  showTrailingIcon: true,
                  onPressed: () => _goToNextPage(vm),
                ),
                SizedBox(height: Spacing.md.h),
                AppProgressIndicator(
                  totalSteps: vm.totalSteps,
                  currentIndex: vm.currentIndex,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
