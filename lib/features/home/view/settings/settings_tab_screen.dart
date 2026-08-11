import 'dart:async';
import 'dart:io' show Platform;

import 'package:flutter/foundation.dart' show kIsWeb;
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
import '../../../../core/services/locale_service.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/services/user_profile_service.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../features/onboarding/model/asr_calculation_option.dart';
import '../../../../features/onboarding/model/location_suggestion.dart';
import '../../../../features/onboarding/model/sect_option.dart';
import '../../../../features/onboarding/view/onboarding_location_page.dart';
import '../../../../l10n/app_localizations.dart';
import 'app_demo_video_settings_card.dart';
import 'settings_app_demo_screen.dart';
import 'settings_calculation_method_screen.dart';
import 'settings_prayer_alarms_screen.dart';

class SettingsTabScreen extends StatefulWidget {
  const SettingsTabScreen({super.key, this.isTabActive = false});

  /// True when this tab is the selected bottom-nav destination (avoids
  /// initializing the demo video while other tabs are visible).
  final bool isTabActive;

  @override
  State<SettingsTabScreen> createState() => _SettingsTabScreenState();
}

class _SettingsTabScreenState extends State<SettingsTabScreen> {
  late final Future<PackageInfo> _packageInfoFuture;

  @override
  void initState() {
    super.initState();
    _packageInfoFuture = PackageInfo.fromPlatform();
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
    // final l10n = AppLocalizations.of(context)!;
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
                    _SettingsCardButton(
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
            _SettingsGroup(
              children: [
                _SettingsRow(
                  icon: Icons.person_outline_rounded,
                  label: l10n.settingsUsernameLabel,
                  value: profile.userName,
                  onTap: () => unawaited(_onEditUsernameTapped(context)),
                ),
                _SettingsRow(
                  icon: Icons.language_rounded,
                  label: l10n.language,
                  value: '${currentLang.flag} ${currentLang.label}',
                  onTap: () => _showLanguagePicker(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SettingsSectionHeader(
              icon: Icons.public_rounded,
              label: l10n.settingsPrayerCalculationSection,
            ),
            const SizedBox(height: 8),
            _SettingsGroup(
              children: [
                _SettingsRow(
                  icon: Icons.people_outline_rounded,
                  label: l10n.sectTitle,
                  value: profile.sect.label,
                  onTap: () => unawaited(_showSectPicker(context)),
                ),
                _SettingsRow(
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
                _SettingsRow(
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
                _SettingsRow(
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
                _SettingsRow(
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
            const SizedBox(height: 16),
            _SettingsGroup(
              children: [
                _SettingsSwitchRow(
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
            _SettingsGroup(
              children: [
                _SettingsRow(
                  icon: Icons.info_outline_rounded,
                  label: l10n.settingsAboutTitle,
                  onTap: () => _onAboutTapped(context),
                ),
                _SettingsRow(
                  icon: Icons.email_outlined,
                  label: l10n.settingsContactUsTitle,
                  onTap: () => unawaited(_onContactUsTapped(context)),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _SettingsGroup(
              children: [
                _SettingsRow(
                  icon: Icons.play_circle_outline_rounded,
                  label: l10n.settingsAppDemoLabel,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SettingsAppDemoScreen(),
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppDemoVideoSettingsCard(isTabActive: widget.isTabActive),
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
    _selectedLocation = widget.initialSelection;
  }

  @override
  Widget build(BuildContext context) {
    final keyboardOpen = MediaQuery.of(context).viewInsets.bottom > 0;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(title: l10n.settingsLocationLabel),
      body: Column(
        children: [
          Expanded(
            child: OnboardingLocationPage(
              initialSelection: widget.initialSelection,
              onLocationSelected: (value) {
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
                  onPressed: _selectedLocation == null || _saving
                      ? null
                      : () async {
                          setState(() => _saving = true);
                          await context.read<UserProfileService>().setLocation(
                            _selectedLocation!,
                          );
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
    );
  }
}

class SettingsAboutScreen extends StatelessWidget {
  const SettingsAboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: CustomAppBar(title: l10n.settingsAboutTitle),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: Column(
              children: [
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: Icon(
                    Icons.mosque_outlined,
                    size: 40,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n.appTitle,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n.settingsAboutTagline,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Text(
                  l10n.settingsAboutDescription,
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                _AboutFeatureItem(
                  text: l10n.settingsAboutFeature1,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 10),
                _AboutFeatureItem(
                  text: l10n.settingsAboutFeature2,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 10),
                _AboutFeatureItem(
                  text: l10n.settingsAboutFeature3,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 10),
                _AboutFeatureItem(
                  text: l10n.settingsAboutFeature4,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 10),
                _AboutFeatureItem(
                  text: l10n.settingsAboutFeature5,
                  colorScheme: colorScheme,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    l10n.settingsAboutFocusDescription,
                    style: Theme.of(context).textTheme.bodyMedium,
                    textAlign: TextAlign.start,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    l10n.settingsAboutFooter,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.start,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AboutFeatureItem extends StatelessWidget {
  const _AboutFeatureItem({required this.text, required this.colorScheme});

  final String text;
  final ColorScheme colorScheme;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.only(top: 2),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.check_rounded,
            size: 14,
            color: colorScheme.primary,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyMedium),
        ),
      ],
    );
  }
}

class _SettingsCardButton extends StatelessWidget {
  const _SettingsCardButton({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Gradient iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Ink(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainer,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: colorScheme.outlineVariant.withValues(alpha: 0.35),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  gradient: iconBackground,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.workspace_premium_rounded,
                  color: Colors.white,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SettingsGroup extends StatelessWidget {
  const _SettingsGroup({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainer,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: colorScheme.outlineVariant.withValues(alpha: 0.35),
        ),
      ),
      child: Column(children: children),
    );
  }
}

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.label,
    this.value,
    this.onTap,
    this.disabled = false,
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;
  final bool disabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final disabledColor = colorScheme.onSurface.withValues(alpha: 0.38);
    return Opacity(
      opacity: disabled ? 0.45 : 1.0,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: disabled ? null : onTap,
          borderRadius: BorderRadius.circular(24),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Icon(
                        icon,
                        size: 20,
                        color: disabled
                            ? disabledColor
                            : colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          label,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w600,
                                color: disabled ? disabledColor : null,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 170),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      if (value != null)
                        Flexible(
                          child: Text(
                            value!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.end,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: colorScheme.onSurfaceVariant),
                          ),
                        ),
                      if (value != null) const SizedBox(width: 6),
                      Icon(
                        Icons.chevron_right_rounded,
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _SettingsSectionHeader extends StatelessWidget {
  const _SettingsSectionHeader({required this.icon, required this.label});

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      children: [
        Icon(icon, size: 18, color: colorScheme.primary),
        const SizedBox(width: 8),
        Text(
          label,
          style: Theme.of(context).textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
            color: colorScheme.primary,
          ),
        ),
      ],
    );
  }
}

class _SettingsSwitchRow extends StatelessWidget {
  const _SettingsSwitchRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              children: [
                Icon(icon, size: 20, color: colorScheme.onSurfaceVariant),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    label,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Switch.adaptive(value: value, onChanged: onChanged),
        ],
      ),
    );
  }
}
