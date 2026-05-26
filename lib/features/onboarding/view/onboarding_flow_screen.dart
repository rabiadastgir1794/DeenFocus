import 'package:deenly/features/onboarding/view/onboarding_focus_mode.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../../../app/routes/route_names.dart';
import '../../../core/constants/app_languages.dart';
import '../../../core/constants/spacing.dart';
import '../../../core/services/locale_service.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../viewmodel/onboarding_view_model.dart';
import 'onboarding_name_page.dart';
import 'onboarding_location_page.dart';
import 'onboarding_notifications_page.dart';
import 'onboarding_quran_page.dart';
import 'onboarding_screen_time_page.dart';
import 'onboarding_sect_page.dart';
import 'onboarding_subscription_page.dart';
import 'onboarding_tasbih_page.dart';
import 'onboarding_welcome_page.dart';

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
  bool _didAutoRequestNotification = false;
  bool _scheduledPostOnboardingNavigation = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<OnboardingViewModel>().recheckPermissions();
    }
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
    await vm.requestNotification();
  }

  Future<void> _requestNotificationOnStep(OnboardingViewModel vm) async {
    if (_didAutoRequestNotification) return;
    _didAutoRequestNotification = true;
    await vm.recheckPermissions();
    if (!vm.notificationGranted) {
      await vm.requestNotification();
    }
  }

  Future<void> _onScreenTimeAllowTap(
    BuildContext context,
    OnboardingViewModel vm,
  ) async {
    await vm.requestScreenTime();
    if (!context.mounted) return;
    await _goToNextPage(context, vm);
  }

  Future<void> _goToNextPage(
    BuildContext context,
    OnboardingViewModel vm,
  ) async {
    if (vm.currentIndex >= vm.totalSteps - 1) return;
    final nextIndex = vm.currentIndex + 1;
    await widget.pageController.animateToPage(
      nextIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _skipToLocationStep(OnboardingViewModel vm) async {
    await widget.pageController.animateToPage(
      OnboardingViewModel.locationStepIndex,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildTopBar(
    BuildContext context,
    OnboardingViewModel vm,
    LocaleService localeService,
  ) {
    final current = _currentAppLanguage(localeService);
    final l10n = AppLocalizations.of(context)!;

    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: Spacing.md.w,
        vertical: Spacing.sm.h,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ),
          ),
          Visibility(
            visible: vm.showSkip,
            maintainSize: true,
            maintainAnimation: true,
            maintainState: true,
            child: TextButton(
              onPressed: () => _skipToLocationStep(vm),
              child: Text(
                l10n.skip,
                style: TextStyle(
                  fontSize: 12.sp,
                  color: Theme.of(context).colorScheme.primary,
                ),
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
    final pageController = widget.pageController;

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

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: AbsorbPointer(
        absorbing: isBusyScreenTimeStep,
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              AppStepProgressLine(
                totalSteps: vm.totalSteps,
                currentIndex: vm.currentIndex,
              ),
              _buildTopBar(context, vm, localeService),
              Expanded(
                child: PageView(
                  controller: widget.pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (index) {
                    if (vm.currentIndex == 6 && index != 6) {
                      FocusManager.instance.primaryFocus?.unfocus();
                    }
                    vm.setStep(index);
                    if (index == 7) {
                      _requestNotificationOnStep(vm);
                    } else {
                      _didAutoRequestNotification = false;
                    }
                  },
                  children: [
                    const OnboardingWelcomePage(),
                    const OnboardingFocusModePage(),
                    const OnboardingTasbihPage(),
                    const OnboardingQuranPage(),
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
                    ),
                    OnboardingNotificationsPage(
                      onEnableTap: () => _onNotificationEnableTap(context, vm),
                      isLoading: vm.notificationRequesting,
                      showEnableButton: !vm.notificationGranted,
                    ),
                    OnboardingScreenTimePage(
                      onAllowTap: () => _onScreenTimeAllowTap(context, vm),
                      isLoading: vm.screenTimeRequesting,
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
      ),
      bottomNavigationBar: isScreenTimeStep
          ? null
          : SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  Spacing.lg.w,
                  16,
                  Spacing.lg.w,
                  Spacing.md.h,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    AppButton(
                      label: vm.currentIndex == vm.totalSteps - 1
                          ? AppLocalizations.of(context)!.getStarted
                          : AppLocalizations.of(context)!.continueButton,
                      enabled: !vm.isContinueDisabled && !isBusyScreenTimeStep,
                      showTrailingIcon: vm.currentIndex != vm.totalSteps - 1,
                      onPressed: () async {
                        if (vm.currentIndex < vm.totalSteps - 1) {
                          final nextIndex = vm.currentIndex + 1;
                          await pageController.animateToPage(
                            nextIndex,
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          );
                        } else {
                          vm.goNext();
                        }
                      },
                    ),
                    SizedBox(height: Spacing.xl.h),
                    AppProgressIndicator(
                      totalSteps: vm.totalSteps,
                      currentIndex: vm.currentIndex,
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
