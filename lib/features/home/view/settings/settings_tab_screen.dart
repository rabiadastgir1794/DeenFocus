import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../../core/constants/app_languages.dart';
import '../../../../core/superwall/app_superwall.dart';
import '../../../../core/services/app_notification_service.dart';
import '../../../../core/services/locale_service.dart';
import '../../../../core/services/permission_service.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/services/theme_service.dart';
import '../../../../core/services/user_profile_service.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../../features/focus/viewmodel/focus_controller.dart';
import '../../../../features/onboarding/model/location_suggestion.dart';
import '../../../../features/onboarding/model/sect_option.dart';
import '../../../../features/onboarding/view/onboarding_location_page.dart';
import '../../../../l10n/app_localizations.dart';
import 'app_demo_video_settings_card.dart';

class SettingsTabScreen extends StatefulWidget {
  const SettingsTabScreen({super.key, this.isTabActive = false});

  /// True when this tab is the selected bottom-nav destination (avoids
  /// initializing the demo video while other tabs are visible).
  final bool isTabActive;

  @override
  State<SettingsTabScreen> createState() => _SettingsTabScreenState();
}

class _SettingsTabScreenState extends State<SettingsTabScreen> {
  bool _notificationsEnabled = true;
  bool _notificationsInitialized = false;

  @override
  void initState() {
    super.initState();
    unawaited(_loadNotificationToggle());
  }

  Future<void> _loadNotificationToggle() async {
    final enabled = await StorageService.appNotificationsEnabled;
    if (!mounted) return;
    setState(() {
      _notificationsEnabled = enabled;
      _notificationsInitialized = true;
    });
  }

  Future<void> _toggleNotifications(bool value) async {
    final focusSettings = context.read<FocusController>().settings;
    if (value) {
      final granted = await PermissionService.requestNotification();
      if (!granted) {
        if (!mounted) return;
        ScaffoldMessenger.maybeOf(context)?.showSnackBar(
          const SnackBar(
            content: Text('Enable system notifications to turn this on.'),
          ),
        );
        return;
      }
    }
    await StorageService.setAppNotificationsEnabled(value);
    await AppNotificationService.instance.syncFocusNotifications(
      settings: focusSettings,
    );
    if (!mounted) return;
    setState(() => _notificationsEnabled = value);
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

  Future<void> _onEditUsernameTapped(BuildContext context) async {
    await AppSuperwall.registerPlacement(SuperwallPlacements.changeUsername, () {
      if (!context.mounted) return;
      unawaited(_presentEditUsernameSheet(context));
    });
  }

  Future<void> _presentEditUsernameSheet(BuildContext context) async {
    final profile = context.read<UserProfileService>();
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
                'Edit Username',
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
                decoration: const InputDecoration(hintText: 'Enter your name'),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () async {
                    await profile.setUserName(controller.text);
                    if (ctx.mounted) Navigator.of(ctx).pop();
                  },
                  child: const Text('Save'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showSectPicker(BuildContext context) async {
    final profile = context.read<UserProfileService>();
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sect',
                  style: Theme.of(
                    ctx,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 12),
                for (final option in const <SectOption>[
                  SectOption.sunni,
                  SectOption.shia,
                ])
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_sectLabel(option, l10n)),
                    trailing: option == profile.sect
                        ? Icon(Icons.check_rounded, color: colorScheme.primary)
                        : null,
                    onTap: () {
                      Navigator.of(ctx).pop();
                      unawaited(profile.setSect(option));
                    },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  String _sectLabel(SectOption option, AppLocalizations l10n) {
    switch (option) {
      case SectOption.sunni:
        return l10n.sectSunni;
      case SectOption.shia:
        return l10n.sectShia;
      case SectOption.preferNotToSay:
        return l10n.sectSunni;
    }
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
    final colorScheme = Theme.of(context).colorScheme;

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
            _SettingsCardButton(
              icon: Icons.workspace_premium_rounded,
              iconBackground: const LinearGradient(
                colors: [Color(0xFF0F766E), Color(0xFF34D399)],
              ),
              title: 'Deen Focus Premium',
              subtitle: 'Unlock all features',
              onTap: () {},
            ),
            const SizedBox(height: 16),
            _SettingsGroup(
              children: [
                _SettingsRow(
                  icon: Icons.person_outline_rounded,
                  label: 'Username',
                  value: profile.userName,
                  onTap: () => unawaited(_onEditUsernameTapped(context)),
                ),
                _SettingsRow(
                  icon: Icons.language_rounded,
                  label: 'Language',
                  value: '${currentLang.flag} ${currentLang.label}',
                  onTap: () => _showLanguagePicker(context),
                ),
                _SettingsRow(
                  icon: Icons.location_on_outlined,
                  label: 'Location',
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
                  icon: Icons.access_time_rounded,
                  label: 'Sect',
                  value: _sectLabel(profile.sect, l10n),
                  onTap: () => _showSectPicker(context),
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
                  label: 'Dark Mode',
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
                  label: 'About Deen Focus',
                  onTap: () {
                    unawaited(
                      AppSuperwall.registerPlacement(
                        SuperwallPlacements.aboutDeenFocus,
                        () {
                          if (!context.mounted) return;
                          Navigator.of(context).push(
                            MaterialPageRoute<void>(
                              builder: (_) => const SettingsAboutScreen(),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
            const SizedBox(height: 16),
            AppDemoVideoSettingsCard(isTabActive: widget.isTabActive),
            const SizedBox(height: 8),
            Text(
              'Tap to watch. Playback pauses when you leave and resumes from there next time.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
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
    return Scaffold(
      appBar: const CustomAppBar(title: 'Location'),
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
                  child: Text(_saving ? 'Saving...' : 'Save Location'),
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
    return Scaffold(
      appBar: const CustomAppBar(title: 'About Deen Focus'),
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
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(22),
                  ),
                  child: Icon(
                    Icons.mosque_outlined,
                    size: 34,
                    color: colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Deen Focus',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Focus. Discipline. Consistency.',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 18),
                Text(
                  'Deen Focus helps you stay grounded with prayer times, Quran, Qibla, Tasbih, nearby mosques, and distraction-free focus modes built around your routines.',
                  style: Theme.of(context).textTheme.bodyMedium,
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
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
  });

  final IconData icon;
  final String label;
  final String? value;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
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
    );
  }
}

class _SettingsSwitchRow extends StatelessWidget {
  const _SettingsSwitchRow({
    required this.icon,
    required this.label,
    required this.value,
    required this.onChanged,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool enabled;

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
          Switch.adaptive(value: value, onChanged: enabled ? onChanged : null),
        ],
      ),
    );
  }
}
