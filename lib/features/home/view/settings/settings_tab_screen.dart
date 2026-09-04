import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kDebugMode, kIsWeb;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../core/constants/app_languages.dart';
import '../../../../core/util/store_subscription_links.dart';
import '../../../../core/superwall/app_superwall.dart';
import '../../../../core/superwall/premium_gate.dart';
import '../../../../core/services/app_review_service.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/services/prayer_live_activity_service.dart';
import '../../../../core/services/prayer_live_activity_toggle.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/services/user_profile_service.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../features/onboarding/model/asr_calculation_option.dart';
import '../../../../features/onboarding/model/location_suggestion.dart';
import '../../../../features/onboarding/model/sect_option.dart';
import '../../../../features/onboarding/view/onboarding_location_page.dart';
import '../../../../features/tajweed/view/tajweed_asset_debug_screen.dart'
    deferred as tajweed_asset_debug;
import '../../../../l10n/app_localizations.dart';
import '../../../focus/model/focus_models.dart';
import '../../helpers/lock_screen_style_preference.dart';
import '../../services/prayer_settings_service.dart';
import '../../viewmodel/home_tab_view_model.dart';
import '../widgets/lock_screen_options/lock_screen_options_popup.dart';
import '../widgets/lock_screen_options/lock_screen_style.dart';
import 'settings_about_screen.dart';
import 'settings_app_demo_screen.dart';
import 'settings_calculation_method_screen.dart';
import 'settings_list_widgets.dart';
import 'settings_prayer_alarms_screen.dart';

class SettingsTabScreen extends StatefulWidget {
  const SettingsTabScreen({super.key, this.onRequestEnableFocusMode});

  /// Handoff from Focus Mode App Demos → Focus tab enable / Superwall flow.
  final ValueChanged<FocusModeType>? onRequestEnableFocusMode;

  @override
  State<SettingsTabScreen> createState() => _SettingsTabScreenState();
}

class _SettingsTabScreenState extends State<SettingsTabScreen>
    with WidgetsBindingObserver {
  late final Future<PackageInfo> _packageInfoFuture;
  bool _liveActivityEnabled = false;
  bool _liveActivitySupported = false;
  bool _liveActivityBusy = false;
  LockScreenStyle _lockScreenStyle = LockScreenStyle.classic;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (PrayerLiveActivityService.visibleOnThisPlatform) {
      PrayerLiveActivityService.instance.preferenceListenable.addListener(
        _onLiveActivityPreferenceChanged,
      );
      unawaited(_loadLiveActivityState());
    }
    _packageInfoFuture = PackageInfo.fromPlatform();
    unawaited(_loadLockScreenStyle());
  }

  @override
  void dispose() {
    if (PrayerLiveActivityService.visibleOnThisPlatform) {
      PrayerLiveActivityService.instance.preferenceListenable.removeListener(
        _onLiveActivityPreferenceChanged,
      );
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  void _onLiveActivityPreferenceChanged() {
    if (!mounted) return;
    unawaited(_loadLiveActivityState());
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed &&
        PrayerLiveActivityService.visibleOnThisPlatform) {
      unawaited(_loadLiveActivityState());
    }
  }

  Future<void> _loadLiveActivityState() async {
    final caps = await PrayerLiveActivityService.instance.getCapabilities();
    final supported = caps['supportsLiveActivity'] == true;
    final enabled = supported
        ? await PrayerLiveActivityService.instance.resolveEnabled()
        : false;
    if (!mounted) return;
    setState(() {
      _liveActivityEnabled = enabled;
      _liveActivitySupported = supported;
    });
    if (enabled) {
      unawaited(PrayerLiveActivityService.instance.syncFromStorage());
    } else {
      unawaited(PrayerLiveActivityService.instance.stop());
    }
  }

  Future<void> _loadLockScreenStyle() async {
    final style = await LockScreenStylePreference.ensureSelected();
    if (!mounted) return;
    setState(() => _lockScreenStyle = style);
  }

  Future<void> _openLockScreenOptions() async {
    await LockScreenOptionsPopup.show(context);
    if (!mounted) return;
    await _loadLockScreenStyle();
  }

  Future<void> _setLiveActivityEnabled(bool value) async {
    if (!_liveActivitySupported || _liveActivityBusy) return;
    setState(() => _liveActivityBusy = true);
    try {
      final ok = await PrayerLiveActivityToggle.applyWithDialogs(
        context,
        enabled: value,
      );
      if (!mounted) return;
      if (ok) setState(() => _liveActivityEnabled = value);
    } finally {
      if (mounted) setState(() => _liveActivityBusy = false);
    }
  }

  Future<void> _showSectPicker(BuildContext context) async {
    final profile = context.read<UserProfileService>();
    final l10n = AppLocalizations.of(context)!;
    final currentSect = profile.sect;

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        final colorScheme = Theme.of(ctx).colorScheme;
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 32),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.sectTitle,
                style: Theme.of(
                  ctx,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 8),
              for (final option in SectOption.values)
                InkWell(
                  onTap: () async {
                    Navigator.of(ctx).pop();
                    await profile.setSect(option);
                  },
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            option.label,
                            style: Theme.of(ctx).textTheme.bodyLarge,
                          ),
                        ),
                        if (option == currentSect)
                          Icon(
                            Icons.check_rounded,
                            color: colorScheme.primary,
                            size: 22,
                          ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openTajweedAssetDebug(BuildContext context) async {
    await tajweed_asset_debug.loadLibrary();
    if (!context.mounted) return;
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => tajweed_asset_debug.TajweedAssetDebugScreen(),
      ),
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

  Future<void> _onPremiumCardTap() async {
    final manageMode =
        AppSuperwall.isEnabled &&
        AppSuperwall.purchasedSubscriptionActiveNotifier.value;
    if (manageMode) {
      if (kIsWeb) return;
      final Uri uri;
      if (Platform.isIOS) {
        uri = StoreSubscriptionLinks.appleManageSubscriptions;
      } else if (Platform.isAndroid) {
        uri = StoreSubscriptionLinks.playStoreManageSubscription();
      } else {
        return;
      }
      try {
        final launched = await launchUrl(
          uri,
          mode: LaunchMode.externalApplication,
        );
        if (!launched && mounted) {
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            const SnackBar(content: Text('Could not open the store.')),
          );
        }
      } catch (_) {
        if (mounted) {
          ScaffoldMessenger.maybeOf(context)?.showSnackBar(
            const SnackBar(content: Text('Could not open the store.')),
          );
        }
      }
      return;
    }

    if (!mounted) return;
    await PremiumGate.presentIfNeeded(
      context: context,
      onAccess: () {},
      debugContext: 'settings:premium_card',
    );
  }

  Future<void> _onEditUsernameTapped(BuildContext context) async {
    if (!context.mounted) return;
    await _presentEditUsernameSheet(context);
  }

  void _onAboutTapped(BuildContext context) {
    if (!context.mounted) return;
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(builder: (_) => const SettingsAboutScreen()),
    );
  }

  Future<void> _onContactUsTapped(BuildContext context) async {
    final uri = Uri(scheme: 'mailto', path: 'rnr1710678@gmail.com');
    try {
      final launched = await launchUrl(
        uri,
        mode: LaunchMode.externalApplication,
      );
      if (!launched && context.mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text(
              'Could not open email client.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
          ),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          SnackBar(
            content: Text(
              'Could not open email client.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onInverseSurface,
              ),
            ),
          ),
        );
      }
    }
  }

  Future<void> _presentEditUsernameSheet(BuildContext context) async {
    final profile = context.read<UserProfileService>();
    final l10n = AppLocalizations.of(context)!;
    final controller = TextEditingController(text: profile.userName);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            20,
            12,
            20,
            MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.settingsEditUsername,
                style: Theme.of(
                  ctx,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 14),
              TextField(
                controller: controller,
                autofocus: true,
                textInputAction: TextInputAction.done,
                onSubmitted: (_) async {
                  await profile.setUserName(controller.text);
                  if (ctx.mounted) Navigator.of(ctx).pop();
                },
                decoration: InputDecoration(
                  hintText: l10n.settingsEnterYourName,
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    await profile.setUserName(controller.text);
                    if (ctx.mounted) Navigator.of(ctx).pop();
                  },
                  child: Text(l10n.save),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final profile = context.watch<UserProfileService>();
    final themeService = context.watch<ThemeService>();
    final localeService = context.watch<LocaleService>();
    final currentLang = kAppLanguages.firstWhere(
      (l) => l.localeCode == localeService.localeCode,
      orElse: () => kAppLanguages.firstWhere(
        (l) => l.locale.languageCode == 'en',
        orElse: () => kAppLanguages.first,
      ),
    );

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 24),
          children: [
            Text(
              l10n.settings,
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 24),
            ValueListenableBuilder<bool>(
              valueListenable: AppSuperwall.purchasedSubscriptionActiveNotifier,
              builder: (context, isSubscribed, _) {
                final manageMode = AppSuperwall.isEnabled && isSubscribed;
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SettingsCardButton(
                      icon: Icons.workspace_premium_rounded,
                      iconBackground: const LinearGradient(
                        colors: [Color(0xFF0F766E), Color(0xFF34D399)],
                      ),
                      title: manageMode
                          ? l10n.settingsManageSubscriptionTitle
                          : l10n.settingsPremiumTitle,
                      subtitle: manageMode
                          ? l10n.settingsManageSubscriptionSubtitle
                          : l10n.settingsPremiumSubtitle,
                      onTap: () => unawaited(_onPremiumCardTap()),
                    ),
                    const SizedBox(height: 16),
                  ],
                );
              },
            ),
            SettingsGroup(
              children: [
                SettingsRow(
                  icon: Icons.person_outline_rounded,
                  label: l10n.settingsUsernameLabel,
                  value: profile.userName,
                  onTap: () => unawaited(_onEditUsernameTapped(context)),
                ),
                SettingsRow(
                  icon: Icons.language_rounded,
                  label: l10n.language,
                  value: '${currentLang.flag} ${currentLang.label}',
                  onTap: () => _showLanguagePicker(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SettingsSectionHeader(
              icon: Icons.public_rounded,
              label: l10n.settingsPrayerCalculationSection,
            ),
            const SizedBox(height: 8),
            SettingsGroup(
              children: [
                SettingsRow(
                  icon: Icons.people_outline_rounded,
                  label: l10n.sectTitle,
                  value: profile.sect.label,
                  onTap: () => unawaited(_showSectPicker(context)),
                ),
                SettingsRow(
                  icon: Icons.calculate_outlined,
                  label: l10n.settingsCalculationMethodTitle,
                  value: profile.calculationMethod.label,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SettingsCalculationMethodScreen(),
                      ),
                    );
                  },
                ),
                SettingsRow(
                  icon: Icons.wb_sunny_outlined,
                  label: l10n.settingsAsrCalculationTitle,
                  value: profile.asrMethod == AsrCalculationOption.standard
                      ? '${l10n.asrMethodStandard} (${l10n.asrMethodStandardSubtitle})'
                      : l10n.asrMethodHanafi,
                  disabled: profile.calculationMethod.isShia,
                  onTap: profile.calculationMethod.isShia
                      ? null
                      : () {
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) =>
                                  const SettingsAsrCalculationScreen(),
                            ),
                          );
                        },
                ),
                SettingsRow(
                  icon: Icons.location_on_outlined,
                  label: l10n.settingsLocationLabel,
                  value: profile.locationLabel,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SettingsLocationScreen(
                          initialSelection: profile.locationSuggestion,
                        ),
                      ),
                    );
                  },
                ),
                SettingsRow(
                  icon: Icons.alarm_rounded,
                  label: l10n.settingsPrayerAlarmsTitle,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SettingsPrayerAlarmsScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            if (PrayerLiveActivityService.visibleOnThisPlatform) ...[
              const SizedBox(height: 16),
              SettingsGroup(
                children: [
                  SettingsSubtitleSwitchRow(
                    icon: Icons.notifications_active_outlined,
                    label: l10n.liveActivityEnableLabel,
                    subtitle: _liveActivitySupported
                        ? (_liveActivityEnabled
                              ? l10n.liveActivityStatusActive
                              : l10n.liveActivityStatusOff)
                        : l10n.liveActivityUnsupported,
                    value: _liveActivityEnabled,
                    enabled: _liveActivitySupported && !_liveActivityBusy,
                    onChanged: _liveActivitySupported && !_liveActivityBusy
                        ? (value) => unawaited(_setLiveActivityEnabled(value))
                        : null,
                  ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            SettingsGroup(
              children: [
                SettingsRow(
                  icon: Icons.stay_current_portrait_outlined,
                  label: l10n.lockScreenOptionsTitle,
                  value: _lockScreenStyle.title(l10n),
                  onTap: () => unawaited(_openLockScreenOptions()),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SettingsGroup(
              children: [
                SettingsSwitchRow(
                  icon: themeService.isDarkModeEnabled
                      ? Icons.dark_mode_outlined
                      : Icons.light_mode_outlined,
                  label: l10n.settingsDarkModeLabel,
                  value: themeService.isDarkModeEnabled,
                  onChanged: themeService.setDarkModeEnabled,
                ),
              ],
            ),
            const SizedBox(height: 16),
            SettingsGroup(
              children: [
                SettingsRow(
                  icon: Icons.info_outline_rounded,
                  label: l10n.settingsAboutTitle,
                  onTap: () => _onAboutTapped(context),
                ),
                SettingsRow(
                  icon: Icons.star_rounded,
                  label: l10n.settingsRateDeenFocus,
                  onTap: () =>
                      unawaited(AppReviewService.requestReviewManually()),
                ),
                SettingsRow(
                  icon: Icons.email_outlined,
                  label: l10n.settingsContactUsTitle,
                  onTap: () => unawaited(_onContactUsTapped(context)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SettingsGroup(
              children: [
                SettingsRow(
                  icon: Icons.play_circle_outline_rounded,
                  label: l10n.settingsAppDemoLabel,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => SettingsAppDemoScreen(
                          onRequestEnableFocusMode:
                              widget.onRequestEnableFocusMode,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
            // Debug harness only — production Tajweed toggle lives in
            // Reading Settings (on by default).
            if (kDebugMode && !kIsWeb && Platform.isAndroid) ...[
              const SizedBox(height: 16),
              SettingsGroup(
                children: [
                  SettingsRow(
                    icon: Icons.bug_report_outlined,
                    label: 'Tajweed Asset Debug',
                    onTap: () => unawaited(_openTajweedAssetDebug(context)),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 12),
            _AppVersionText(packageInfoFuture: _packageInfoFuture),
          ],
        ),
      ),
    );
  }
}

class _AppVersionText extends StatelessWidget {
  const _AppVersionText({required this.packageInfoFuture});

  final Future<PackageInfo> packageInfoFuture;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return FutureBuilder<PackageInfo>(
      future: packageInfoFuture,
      builder: (context, snapshot) {
        final info = snapshot.data;
        if (info == null || info.version.trim().isEmpty) {
          return const SizedBox.shrink();
        }
        final buildNumber = info.buildNumber.trim();
        final version = buildNumber.isEmpty
            ? info.version.trim()
            : '${info.version.trim()}+$buildNumber';
        return Text(
          'Version $version',
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        );
      },
    );
  }
}

class SettingsLocationScreen extends StatefulWidget {
  const SettingsLocationScreen({super.key, this.initialSelection});

  final LocationSuggestion? initialSelection;

  @override
  State<SettingsLocationScreen> createState() => _SettingsLocationScreenState();
}

class _SettingsLocationScreenState extends State<SettingsLocationScreen> {
  LocationSuggestion? _selectedLocation;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    // Do not pre-select the saved row for Save — a stale name/coords pair
    // (e.g. "Lahore" label with Singapore lat/lng) must not be re-persisted.
    // User must pick GPS or a city search result with fresh coordinates.
    _selectedLocation = null;
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppCenteredNavHeader(
              title: l10n.settingsLocationLabel,
              backLabel: l10n.calendarBack,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: OnboardingLocationPage(
                initialSelection: widget.initialSelection,
                onLocationSelected: (value) {
                  setState(() {
                    _selectedLocation = value;
                  });
                },
                onPermissionLocationResolved: (value) {
                  setState(() {
                    _selectedLocation = value;
                  });
                },
                onManualLocationResolved: (value) {
                  setState(() {
                    _selectedLocation = value;
                  });
                },
              ),
            ),
            if (!keyboardOpen)
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: _selectedLocation == null ||
                            _selectedLocation!.latitude == null ||
                            _selectedLocation!.longitude == null ||
                            _saving
                        ? null
                        : () async {
                            setState(() => _saving = true);
                            final selected = _selectedLocation!;
                            final profile =
                                context.read<UserProfileService>();
                            final prayerSettings =
                                context.read<PrayerSettingsService>();
                            await prayerSettings.clearAllCustomTimes();
                            await profile.setLocation(selected);
                            if (!context.mounted) return;
                            // Home may not be under this route — try to refresh.
                            try {
                              await context
                                  .read<HomeTabViewModel>()
                                  .syncLocationIfChanged(
                                    selected.latitude,
                                    selected.longitude,
                                    selected.title,
                                    selected.subtitle,
                                  );
                            } on ProviderNotFoundException {
                              // Opened from a context without Home VM.
                            }
                            if (context.mounted) Navigator.of(context).pop();
                          },
                    child: Text(
                      _saving
                          ? l10n.settingsSavingLocation
                          : l10n.settingsSaveLocation,
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
