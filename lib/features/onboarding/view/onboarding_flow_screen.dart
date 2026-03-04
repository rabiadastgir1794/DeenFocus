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
import '../../../core/services/permission_service.dart';
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
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
    return kAppLanguages.firstWhere(
      (l) => l.localeCode == localeService.localeCode,
      orElse: () => kAppLanguages.first,
    );
  }

  Future<void> _showLanguagePicker(BuildContext context) async {
    final localeService = context.read<LocaleService>();
    final l10n = AppLocalizations.of(context)!;

    final platform = Theme.of(context).platform;
    final isCupertino =
        platform == TargetPlatform.iOS || platform == TargetPlatform.macOS;

    if (isCupertino) {
      await showCupertinoModalPopup<void>(
        context: context,
        builder: (ctx) {
          return CupertinoActionSheet(
            title: Text(l10n.language),
            actions: [
              for (final language in kAppLanguages)
                CupertinoActionSheetAction(
                  onPressed: () async {
                    Navigator.of(ctx).pop();
                    await localeService.setLocale(language.locale);
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(language.flag),
                          const SizedBox(width: 8),
                          Text(language.label),
                        ],
                      ),
                      if (language.localeCode == localeService.localeCode)
                        const Icon(
                          CupertinoIcons.checkmark,
                          color: CupertinoColors.activeBlue,
                        ),
                    ],
                  ),
                ),
            ],
            cancelButton: CupertinoActionSheetAction(
              onPressed: () => Navigator.of(ctx).pop(),
              isDefaultAction: true,
              child: Text(l10n.cancel),
            ),
          );
        },
      );
    } else {
      await showModalBottomSheet<void>(
        context: context,
        showDragHandle: true,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        builder: (ctx) {
          return SafeArea(
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: kAppLanguages.length,
              itemBuilder: (ctx, index) {
                final language = kAppLanguages[index];
                final isSelected =
                    language.localeCode == localeService.localeCode;
                return ListTile(
                  leading: Text(
                    language.flag,
                    style: TextStyle(fontSize: 20.sp),
                  ),
                  title: Text(language.label),
                  trailing: isSelected
                      ? Icon(
                          Icons.check,
                          color: Theme.of(ctx).colorScheme.primary,
                          size: 24.r,
                        )
                      : null,
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await localeService.setLocale(language.locale);
                  },
                );
              },
            ),
          );
        },
      );
    }
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
    await vm.requestNotification();
  }

  Future<void> _onScreenTimeAllowTap(
    BuildContext context,
    OnboardingViewModel vm,
  ) async {
    final opened = await PermissionService.requestScreenTimeAccess();
    if (!context.mounted || opened) return;

    final l10n = AppLocalizations.of(context)!;
    await AppPermissionDialog.show(
      context,
      title: l10n.screenTimeTitle,
      message: l10n.screenTimeSubtitle,
      primaryButtonText: l10n.openSettings,
      onPrimaryTap: () => PermissionService.openAppSettingsAsync(),
    );
    await vm.recheckPermissions();
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
            visible: vm.showSkip,
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
              onPressed: vm.skip,
              child: Text(
                l10n.skip,
                style: TextStyle(
                  fontSize: 16.sp,
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

    if (vm.didComplete) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        context.go(RouteNames.home);
      });
    }

    return Scaffold(
      body: SafeArea(
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
                  vm.setStep(index);
                  if (index == 7) {
                    _requestNotificationOnStep(vm);
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
                  ),
                  OnboardingScreenTimePage(
                    onAllowTap: () => _onScreenTimeAllowTap(context, vm),
                    onSkipTap: () => _goToNextPage(context, vm),
                  ),
                  OnboardingSubscriptionPage(
                    selectedPlan: vm.selectedPlan,
                    onPlanSelected: vm.setSelectedPlan,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                Spacing.lg.w,
                0,
                Spacing.lg.w,
                Spacing.xl.h,
              ),
              child: AppButton(
                label: vm.currentIndex == vm.totalSteps - 1
                    ? AppLocalizations.of(context)!.getStarted
                    : AppLocalizations.of(context)!.continueButton,
                enabled: !vm.isContinueDisabled,
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
            ),
            Padding(
              padding: EdgeInsets.only(bottom: Spacing.md.h),
              child: AppProgressIndicator(
                totalSteps: vm.totalSteps,
                currentIndex: vm.currentIndex,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
