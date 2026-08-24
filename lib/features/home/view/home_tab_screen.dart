import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../support/view/support_us_screen.dart';
import '../../support/viewmodel/support_view_model.dart';

import '../../../core/services/location/location_service.dart';
import '../../../core/services/permission_service.dart';
import '../../../core/services/prayer_alarm_service.dart';
import '../../../core/services/storage_service.dart';
import '../../../core/services/theme_service.dart';
import '../../../core/superwall/premium_gate.dart';
import '../../../core/services/user_profile_service.dart';
import '../../../core/widgets/app_permission_dialog.dart';
import '../../focus/viewmodel/focus_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../cycle_mode_entry_intent.dart';
import '../helpers/home_daily_verse_helper.dart';
import '../helpers/prayer_reminder_prompt_keys.dart';
import '../model/home_models.dart';
import '../services/prayer_settings_service.dart';
import '../viewmodel/home_tab_view_model.dart';
import 'widgets/home_calendar_screen.dart';
import 'widgets/home_circle_icon_button.dart';
import 'widgets/home_cycle_mode_banner.dart';
import 'widgets/home_cycle_mode_settings_sheet.dart';
import 'widgets/home_daily_checklist_section.dart';
import 'widgets/home_daily_checklist_sheet.dart';
import 'widgets/home_focus_score_section.dart';
import 'widgets/home_info_screens.dart';
import 'widgets/home_islamic_date_header.dart';
import 'widgets/home_live_activity_promo_card.dart';
import 'widgets/home_nearby_mosques_screen.dart';
import 'widgets/home_prayer_completion_popup.dart';
import 'widgets/home_prayer_reminder_popup.dart';
import 'widgets/home_insights_screen.dart';
import 'widgets/home_prayer_streak_section.dart';
import 'widgets/home_prayer_times_section.dart';
import 'widgets/home_qibla_screen.dart';
import 'widgets/home_verse_marquee.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({
    super.key,
    required this.onOpenFocusTab,
    this.isTabActive = true,
  });

  final VoidCallback onOpenFocusTab;

  /// False when another bottom-nav tab is selected (Home stays mounted in
  /// [IndexedStack]). Used to pause non-critical timers.
  final bool isTabActive;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeTabViewModel>(
      create: (context) => HomeTabViewModel(
        prayerSettings: context.read<PrayerSettingsService>(),
      )..initialize(),
      child: _HomeTabView(
        onOpenFocusTab: onOpenFocusTab,
        isTabActive: isTabActive,
      ),
    );
  }
}

class _HomeTabView extends StatefulWidget {
  const _HomeTabView({required this.onOpenFocusTab, required this.isTabActive});

  final VoidCallback onOpenFocusTab;
  final bool isTabActive;

  @override
  State<_HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<_HomeTabView>
    with WidgetsBindingObserver {
  String? _lastSyncedSect;
  late UserProfileService _profileService;
  bool _locationCheckDoneThisSession = false;

  /// Prevents overlapping reminder dialogs; cleared after each attempt.
  bool _prayerReminderCheckInFlight = false;
  HomeTabViewModel? _homeVm;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _profileService = context.read<UserProfileService>();
    _profileService.addListener(_onProfileChanged);
    _homeVm = context.read<HomeTabViewModel>();
    _homeVm!.addListener(_onHomeVmChanged);
    CycleModeEntryIntent.pendingOpenSettings.addListener(
      _onCycleModeOpenSettingsRequested,
    );
    // Check on launch — delay 2s so profile finishes loading from storage.
    // Serialize I've Prayed before the "Did you pray?" reminder so the alarm
    // confirm path never races a duplicate prompt.
    Future.delayed(const Duration(seconds: 2), () async {
      if (!mounted) return;
      await _consumePendingPrayerAlarmAction();
      if (!mounted) return;
      unawaited(_checkLocationChange());
      unawaited(_checkAndShowPrayerReminder());
      unawaited(_consumePendingCycleModeOpenSettings());
    });
    WidgetsBinding.instance.addPostFrameCallback((_) {
      unawaited(_consumePendingCycleModeOpenSettings());
      if (!mounted) return;
      context.read<HomeTabViewModel>().setTabActive(widget.isTabActive);
    });
  }

  @override
  void didUpdateWidget(covariant _HomeTabView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.isTabActive != widget.isTabActive) {
      context.read<HomeTabViewModel>().setTabActive(widget.isTabActive);
    }
  }

  void _onCycleModeOpenSettingsRequested() {
    unawaited(_consumePendingCycleModeOpenSettings());
  }

  Future<void> _consumePendingCycleModeOpenSettings() async {
    if (!mounted) return;
    if (!CycleModeEntryIntent.takePendingOpenSettings()) return;
    await showCycleModeSettingsSheet(context, enabling: false);
  }

  void _onHomeVmChanged() {
    // Minute ticker / prayer reload — pick up Maghrib etc. while app stays open.
    unawaited(_checkAndShowPrayerReminder());
  }

  void _onProfileChanged() {
    if (!mounted) return;
    final vm = context.read<HomeTabViewModel>();
    unawaited(
      vm.syncLocationIfChanged(
        _profileService.latitude,
        _profileService.longitude,
        _profileService.locationName,
        _profileService.locationSubtitle,
      ),
    );
    final sect = _profileService.sect.name;
    if (_lastSyncedSect != sect) {
      _lastSyncedSect = sect;
      unawaited(vm.syncSectIfChanged(sect));
    }
    unawaited(
      vm.syncCalculationSettingsIfChanged(
        _profileService.calculationMethod.name,
        _profileService.asrMethod.name,
      ),
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final profile = context.read<UserProfileService>();

    final sect = profile.sect.name;
    if (_lastSyncedSect != sect) {
      _lastSyncedSect = sect;
      unawaited(context.read<HomeTabViewModel>().syncSectIfChanged(sect));
    }

    unawaited(
      context.read<HomeTabViewModel>().syncLocationIfChanged(
        profile.latitude,
        profile.longitude,
        profile.locationName,
        profile.locationSubtitle,
      ),
    );
  }

  @override
  void dispose() {
    CycleModeEntryIntent.pendingOpenSettings.removeListener(
      _onCycleModeOpenSettingsRequested,
    );
    _homeVm?.removeListener(_onHomeVmChanged);
    _profileService.removeListener(_onProfileChanged);
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Focus refresh is handled once by [_AppLifecycleFocusRefresher] in main.dart.
      unawaited(_onHomeResumed());
    }
  }

  Future<void> _onHomeResumed() async {
    // Load streak/settings first so "I've Prayed" marks against fresh state.
    await context.read<HomeTabViewModel>().onAppResumed();
    if (!mounted) return;
    await _consumePendingPrayerAlarmAction();
    if (!mounted) return;
    await _consumePendingCycleModeOpenSettings();
    if (!mounted) return;
    unawaited(_checkLocationChange());
    unawaited(_checkAndShowPrayerReminder());
  }

  /// Handles "I've Prayed" from native Prayer Alarm (AlarmKit / FSI activity).
  Future<void> _consumePendingPrayerAlarmAction() async {
    final prayer = await PrayerAlarmService.instance
        .consumePendingPrayedAction();
    if (!mounted || prayer == null) return;
    await _confirmReminderPrayerOnTime(prayer);
    if (!mounted) return;
    // Suppress the soft "Did you pray?" popup for this prayer today.
    await StorageService.markPrayerReminderPrompted(
      PrayerReminderPromptKeys.forPrayer(prayer),
    );
  }

  Future<void> _checkLocationChange() async {
    if (_locationCheckDoneThisSession) return;
    _locationCheckDoneThisSession = true;

    final profile = context.read<UserProfileService>();
    final savedLat = profile.latitude;
    final savedLng = profile.longitude;
    if (savedLat == null || savedLng == null) return;

    // Uses the same high-accuracy fetch as Nearby Mosques — picks up mock GPS
    // on emulator and works reliably on real devices.
    final newLocation = await LocationService.fetchCurrentCoordinates();
    if (newLocation == null ||
        newLocation.latitude == null ||
        newLocation.longitude == null ||
        !mounted) {
      return;
    }

    final double distanceKm = LocationService.distanceBetweenKm(
      savedLat,
      savedLng,
      newLocation.latitude!,
      newLocation.longitude!,
    );
    if (distanceKm < 50) {
      return;
    }

    final cityLabel = newLocation.title.isNotEmpty
        ? newLocation.title
        : AppLocalizations.of(context)!.homeYourNewLocation;

    await showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        final dialogL10n = AppLocalizations.of(ctx)!;
        final colorScheme = Theme.of(ctx).colorScheme;
        final isDark = Theme.of(ctx).brightness == Brightness.dark;
        return AlertDialog(
          backgroundColor: isDark
              ? colorScheme.surfaceContainerHigh
              : colorScheme.surface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 12),
          contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
          actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          title: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(
                    alpha: isDark ? 0.18 : 0.12,
                  ),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(
                  Icons.location_on_rounded,
                  color: colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  dialogL10n.homeLocationChangedTitle,
                  style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
              ),
            ],
          ),
          content: Text(
            dialogL10n.homeLocationChangedMessage(cityLabel),
            style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
              height: 1.55,
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).maybePop(),
              child: Text(dialogL10n.homeLocationChangedNotNow),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).maybePop();
                unawaited(
                  context.read<UserProfileService>().setLocation(newLocation),
                );
              },
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 12,
                ),
              ),
              child: Text(dialogL10n.homeLocationChangedUpdate),
            ),
          ],
        );
      },
    );
  }

  Future<void> _showLocationRequiredDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    await AppPermissionDialog.show(
      context,
      title: l10n.locationRequired,
      message: l10n.locationRequiredMessage,
      primaryButtonText: l10n.openSettings,
      secondaryButtonText: l10n.cancel,
      onPrimaryTap: PermissionService.openLocationSettings,
      onSecondaryTap: () {},
    );
  }

  Future<void> _checkAndShowPrayerReminder() async {
    if (_prayerReminderCheckInFlight) return;
    _prayerReminderCheckInFlight = true;
    try {
      if (!mounted) return;

      final vm = context.read<HomeTabViewModel>();
      // Wait until schedule is ready — otherwise we miss Maghrib on cold start.
      if (vm.isLoading || vm.prayerTimes == null) return;

      // Latest prayer that has already started; ignore older + future.
      final target = vm.getPrayerReminderTarget();
      if (target == null) return;

      final todayKey = DateFormat('yyyy-MM-dd').format(DateTime.now());
      // v2: earlier builds claimed the key before showing, which could suppress
      // Maghrib for the rest of the day if the dialog never appeared.
      final promptKey = PrayerReminderPromptKeys.forPrayer(
        target,
        dayKey: todayKey,
      );
      final alreadyPrompted = await StorageService.prayerReminderPromptedKeys;
      if (alreadyPrompted.contains(promptKey)) return;

      await Future.delayed(const Duration(milliseconds: 500));
      if (!mounted) return;
      if (vm.isLoading || vm.prayerTimes == null) return;

      // Tip must still be the same most-recent started prayer.
      final stillTarget = vm.getPrayerReminderTarget();
      if (stillTarget != target) return;

      // Persist only when we are about to present — inFlight blocks duplicates.
      await StorageService.markPrayerReminderPrompted(promptKey);
      await StorageService.setLastPrayerReminderPromptMs(
        DateTime.now().millisecondsSinceEpoch,
      );

      if (!mounted) return;
      final confirmed = await PrayerReminderPopup.show(
        context: context,
        prayer: target,
      );
      if (!mounted || confirmed != true) return;

      // Yes, Alhamdulillah → mark on-time immediately (no second status sheet).
      await _confirmReminderPrayerOnTime(target);
    } finally {
      _prayerReminderCheckInFlight = false;
    }
  }

  /// Marks the reminder target on-time and shows the existing streak popup
  /// when [PrayerMarkResult.celebrated] is true. Does not open the status sheet.
  Future<void> _confirmReminderPrayerOnTime(TrackablePrayer prayer) async {
    if (!mounted) return;
    final vm = context.read<HomeTabViewModel>();
    final result = await vm.markPrayerStatus(
      DateTime.now(),
      prayer,
      PrayerMarkStatus.onTime,
    );
    if (!mounted || result == null || !result.celebrated) return;

    final remaining = vm.prayerTimes?.nextPrayerTime?.difference(
      DateTime.now(),
    );
    await showPrayerCompletionPopup(
      context,
      result: result,
      nextPrayerIn: remaining,
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final vm = context.watch<HomeTabViewModel>();
    final focusVm = context.watch<FocusController>();
    final profile = context.watch<UserProfileService>();
    final isDarkModeEnabled = context.select<ThemeService, bool>(
      (service) => service.isDarkModeEnabled,
    );
    final softCardColor = colorScheme.surfaceContainerHighest.withValues(
      alpha: 0.20,
    );
    if (vm.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    final showHomeFocusLockCard =
        focusVm.isAppsLocked || focusVm.isTemporarilyUnlocked;
    final weekCycleModeDays = vm.weekCycleHighlights;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 4, 16, 28),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            HomeIslamicDateHeader(
              userName: profile.userName,
              onTapCalendar: () => _openCalendarScreen(context, vm),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  HomeCircleIconButton(
                    icon: isDarkModeEnabled
                        ? Icons.light_mode_outlined
                        : Icons.dark_mode_outlined,
                    onTap: () {
                      unawaited(
                        context.read<ThemeService>().setDarkModeEnabled(
                          !isDarkModeEnabled,
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  HomeCircleIconButton(
                    imagePath: 'assets/ai_chat_icon.png',
                    onTap: () {
                      unawaited(
                        PremiumGate.presentIfNeeded(
                          context: context,
                          onAccess: () {
                            if (!context.mounted) return;
                            Navigator.of(context, rootNavigator: true).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const HomeAiChatScreen(),
                              ),
                            );
                          },
                          debugContext: 'home:islamic_chat',
                        ),
                      );
                    },
                  ),
                  const SizedBox(width: 8),
                  HomeCircleIconButton(
                    icon: Icons.show_chart_rounded,
                    onTap: () => unawaited(_openInsights(context, vm)),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            HomeVerseMarquee(
              text: _verseText(l10n, vm.dailyVerse),
              color: colorScheme.primary,
            ),
            if (showHomeFocusLockCard) ...[
              const SizedBox(height: 12),
              _FocusLockCard(focusVm: focusVm),
            ],
            // Banner = activeCycle only (same gate as highlight's activeCycle term).
            if (vm.cycleModeEnabled) ...[
              const SizedBox(height: 12),
              HomeCycleModeActiveBanner(
                daysRemaining: vm.cycleModeDaysRemaining,
                onTap: () => unawaited(_openCycleModeSettings(context, vm)),
              ),
            ],
            const SizedBox(height: 12),
            HomePrayerTimesSection(
              prayerTimes: vm.prayerTimes,
              backgroundColor: softCardColor,
              isActive: widget.isTabActive,
            ),
            const HomeLiveActivityPromoCard(),
            const SizedBox(height: 12),
            _FocusModeCard(
              onTap: widget.onOpenFocusTab,
              subtitle: focusVm.homeFocusModeCardSubtitle(l10n),
              showLock: focusVm.isAnyModeEnabled,
              isAppsLocked: focusVm.isAppsLocked,
              isTemporarilyUnlocked: focusVm.isTemporarilyUnlocked,
              onLockPressed: () {
                if (focusVm.isTemporarilyUnlocked) {
                  unawaited(focusVm.relockNowFromHome());
                } else if (focusVm.isAppsLocked) {
                  unawaited(focusVm.unlockFromHome());
                } else {
                  widget.onOpenFocusTab();
                }
              },
            ),
            const SizedBox(height: 12),
            HomePrayerStreakSection(
              prayerStreak: vm.prayerStreak,
              dayStreak: vm.streakDays,
              weekPrayerCounts: vm.weekPrayerCounts,
              weekCycleModeDays: weekCycleModeDays,
              backgroundColor: softCardColor,
              isCycleThemeActive: vm.cycleModeEnabled,
              canRestoreStreak: vm.canRestoreStreak,
              onTap: () => unawaited(_openInsights(context, vm)),
              onInsightsTap: () => unawaited(_openInsights(context, vm)),
              onRestoreStreak: () => unawaited(vm.restoreStreakLast7Days()),
            ),
            const SizedBox(height: 10),
            _CycleModeToggleCard(
              isEnabled: vm.cycleModeEnabled,
              onToggle: () => unawaited(_onCycleModeToggle(context, vm)),
              onEdit: () => unawaited(_openCycleModeSettings(context, vm)),
            ),
            const SizedBox(height: 16),
            _QuickActionsCard(
              qiblaTitle: l10n.homeQiblaDirection,
              masjidTitle: l10n.quickActionsMasjidFinder,
              calendarTitle: l10n.quickActionsCalendar,
              supportUsTitle: l10n.quickActionsSupportUs,
              onOpenQibla: () => _openQiblaScreen(context, vm),
              onOpenMasjid: () => _openMasjidScreen(context, vm),
              onOpenCalendar: () => _openCalendarScreen(context, vm),
              onOpenSupportUs: () => _openSupportUs(context),
            ),
            const SizedBox(height: 12),
            HomeDailyChecklistSection(
              backgroundColor: softCardColor,
              completedCount: vm.dailyChecklistCompletedCount,
              totalCount: vm.dailyChecklistTotalCount,
              onOpen: () => unawaited(showDailyChecklistSheet(context)),
            ),
            const SizedBox(height: 10),
            HomeFocusScoreSection(
              backgroundColor: softCardColor,
              score: vm.todayFocusScore,
              prayerPercent: vm.todayPrayerPercent,
              quranPercent: vm.todayQuranPercent,
              dhikrPercent: vm.todayDhikrPercent,
              distractionPercent: vm.todayDistractionPercent,
              onTap: () => unawaited(_openInsights(context, vm)),
            ),
            if (vm.isFriday) ...[
              const SizedBox(height: 12),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: colorScheme.primary.withValues(alpha: 0.20),
                  ),
                ),
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      l10n.homeJummahMubarak,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(l10n.homeJummahReminder, textAlign: TextAlign.center),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _verseText(AppLocalizations l10n, HomeDailyVerse? verse) {
    if (verse == null) return l10n.homeDailyVerseFallback;
    final useArabic = l10n.localeName.toLowerCase().startsWith('ar');
    final quote = HomeDailyVerseHelper.localizedText(
      verse,
      useArabic: useArabic,
    );
    final source = HomeDailyVerseHelper.localizedSource(
      verse,
      l10n: l10n,
      useArabic: useArabic,
    );
    return '"$quote" — $source';
  }

  Future<void> _openQiblaScreen(
    BuildContext context,
    HomeTabViewModel vm,
  ) async {
    final hasLocation = await vm.ensureLocationAvailableForFeature();
    if (!hasLocation) {
      if (!context.mounted) return;
      await _showLocationRequiredDialog(context);
      return;
    }
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => HomeQiblaScreen(
          locationName: vm.locationName,
          latitude: vm.latitude,
          longitude: vm.longitude,
        ),
      ),
    );
  }

  Future<void> _openMasjidScreen(
    BuildContext context,
    HomeTabViewModel vm,
  ) async {
    final hasLocation = await vm.ensureLocationAvailableForFeature();
    if (!hasLocation) {
      if (!context.mounted) return;
      await _showLocationRequiredDialog(context);
      return;
    }
    if (!context.mounted) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => const HomeNearbyMosquesScreen()),
    );
  }

  Future<void> _onCycleModeToggle(
    BuildContext context,
    HomeTabViewModel vm,
  ) async {
    if (vm.cycleModeEnabled) {
      await vm.setCycleModeEnabled(false);
      return;
    }
    // Turning the switch on opens settings; Save enables the cycle.
    await showCycleModeSettingsSheet(context, enabling: true);
  }

  /// Opens Cycle Mode settings whether the mode is on or off.
  /// Prefills the last saved values. Save enables (if off) or updates (if on).
  Future<void> _openCycleModeSettings(
    BuildContext context,
    HomeTabViewModel vm,
  ) async {
    await showCycleModeSettingsSheet(context, enabling: false);
  }

  Future<void> _openInsights(BuildContext context, HomeTabViewModel vm) async {
    await PremiumGate.presentIfNeeded(
      context: context,
      onAccess: () {
        if (!context.mounted) return;
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ChangeNotifierProvider<HomeTabViewModel>.value(
              value: vm,
              child: const HomeInsightsScreen(),
            ),
          ),
        );
      },
      debugContext: 'home:insights',
    );
  }

  void _openCalendarScreen(BuildContext context, HomeTabViewModel vm) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider<HomeTabViewModel>.value(
          value: vm,
          child: const HomeCalendarScreen(),
        ),
      ),
    );
  }

  void _openSupportUs(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider(
          create: (_) => SupportViewModel(),
          child: const SupportUsScreen(),
        ),
      ),
    );
  }
}

class _QuickActionsCard extends StatelessWidget {
  const _QuickActionsCard({
    required this.qiblaTitle,
    required this.masjidTitle,
    required this.calendarTitle,
    required this.supportUsTitle,
    required this.onOpenQibla,
    required this.onOpenMasjid,
    required this.onOpenCalendar,
    required this.onOpenSupportUs,
  });

  final String qiblaTitle;
  final String masjidTitle;
  final String calendarTitle;
  final String supportUsTitle;
  final VoidCallback onOpenQibla;
  final VoidCallback onOpenMasjid;
  final VoidCallback onOpenCalendar;
  final VoidCallback onOpenSupportUs;

  static const double _gap = 10;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    final items = <({String title, IconData icon, VoidCallback onTap})>[
      (title: qiblaTitle, icon: Icons.near_me_outlined, onTap: onOpenQibla),
      (
        title: masjidTitle,
        icon: Icons.location_on_outlined,
        onTap: onOpenMasjid,
      ),
      (
        title: calendarTitle,
        icon: Icons.calendar_month_outlined,
        onTap: onOpenCalendar,
      ),
      (
        title: supportUsTitle,
        icon: Icons.volunteer_activism_outlined,
        onTap: onOpenSupportUs,
      ),
    ];

    // Flat 2×2 — no outer shell, so tiles don't feel nested.
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: _gap,
        crossAxisSpacing: _gap,
        mainAxisExtent: 76,
      ),
      itemBuilder: (context, index) {
        final item = items[index];
        return _QuickActionItem(
          title: item.title,
          icon: item.icon,
          iconColor: colorScheme.primary,
          onTap: item.onTap,
        );
      },
    );
  }
}

/// Compact quick-action tile — soft fill, no border layering.
class _QuickActionItem extends StatelessWidget {
  const _QuickActionItem({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.onTap,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark
        ? colorScheme.primary.withValues(alpha: 0.12)
        : colorScheme.primary.withValues(alpha: 0.07);

    return Material(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(16),
      elevation: 0,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 22, color: iconColor),
              const SizedBox(height: 6),
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  height: 1.15,
                  color: colorScheme.onSurface,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FocusLockCard extends StatelessWidget {
  const _FocusLockCard({required this.focusVm});

  final FocusController focusVm;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isTemporarilyUnlocked = focusVm.isTemporarilyUnlocked;

    return InkWell(
      onTap: () => isTemporarilyUnlocked
          ? focusVm.relockNowFromHome()
          : focusVm.unlockFromHome(),
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: colorScheme.error.withValues(alpha: 0.3)),
          color: colorScheme.errorContainer.withValues(alpha: 0.32),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 14,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: Theme.of(
                  context,
                ).colorScheme.surface.withValues(alpha: 0.72),
              ),
              child: Icon(Icons.lock_outline, color: colorScheme.error),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isTemporarilyUnlocked
                        ? l10n.homeAppsUnlocked
                        : l10n.homeAppsLocked,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isTemporarilyUnlocked
                        ? l10n.homeTapToRelock
                        : l10n.homeTapToUnlock,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: colorScheme.error.withValues(alpha: 0.1),
              ),
              child: Text(
                isTemporarilyUnlocked ? l10n.homeRelock : l10n.homeUnlock,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: colorScheme.error,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Green Focus Mode CTA card — always visible below Today's Prayers.
class _FocusModeCard extends StatelessWidget {
  const _FocusModeCard({
    required this.onTap,
    required this.subtitle,
    required this.showLock,
    required this.isAppsLocked,
    required this.isTemporarilyUnlocked,
    required this.onLockPressed,
  });

  final VoidCallback onTap;
  final String subtitle;
  final bool showLock;
  final bool isAppsLocked;
  final bool isTemporarilyUnlocked;
  final VoidCallback onLockPressed;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final onPrimary = colorScheme.onPrimary;
    final lockTooltip = isTemporarilyUnlocked
        ? l10n.homeRelock
        : isAppsLocked
        ? l10n.homeUnlock
        : l10n.focusModeActivated;
    final lockIcon = isTemporarilyUnlocked
        ? Icons.lock_open_rounded
        : Icons.lock_rounded;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: colorScheme.primary,
          boxShadow: [
            BoxShadow(
              color: colorScheme.primary.withValues(alpha: 0.22),
              blurRadius: 14,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                color: onPrimary.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Icon(Icons.shield_outlined, color: onPrimary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.homeFocusModeTitle,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: onPrimary,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: onPrimary.withValues(alpha: 0.88),
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            if (showLock) ...[
              IconButton(
                tooltip: lockTooltip,
                onPressed: onLockPressed,
                visualDensity: VisualDensity.compact,
                style: IconButton.styleFrom(
                  foregroundColor: onPrimary,
                  backgroundColor: onPrimary.withValues(alpha: 0.18),
                ),
                icon: Icon(lockIcon, size: 20),
              ),
              const SizedBox(width: 4),
            ],
            Icon(
              Icons.arrow_forward_rounded,
              color: onPrimary.withValues(alpha: 0.95),
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}

/// Cycle Mode row: quieter secondary control so Focus Mode stays primary.
class _CycleModeToggleCard extends StatelessWidget {
  const _CycleModeToggleCard({
    required this.isEnabled,
    required this.onToggle,
    required this.onEdit,
  });

  final bool isEnabled;
  final VoidCallback onToggle;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cycleModeColor = isDark
        ? const Color(0xFFE59DB7)
        : const Color(0xFFFF9EC5);
    final cycleModeBackground = isDark
        ? cycleModeColor.withValues(alpha: 0.10)
        : cycleModeColor.withValues(alpha: 0.08);

    return Material(
      color: cycleModeBackground,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(10, 8, 6, 8),
        child: Row(
          children: [
            Container(
              width: 26,
              height: 26,
              decoration: BoxDecoration(
                color: cycleModeColor.withValues(alpha: 0.18),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                Icons.water_drop_outlined,
                color: cycleModeColor,
                size: 14,
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.cycleModeTitle,
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    l10n.cycleModeSubtitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      height: 1.25,
                    ),
                  ),
                ],
              ),
            ),
            TextButton(
              onPressed: onEdit,
              style: TextButton.styleFrom(
                foregroundColor: cycleModeColor,
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                visualDensity: VisualDensity.compact,
              ),
              child: Text(
                l10n.cycleModeEditButton,
                style: Theme.of(
                  context,
                ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w600),
              ),
            ),
            Transform.scale(
              scale: 0.78,
              child: Switch.adaptive(
                value: isEnabled,
                onChanged: (_) => onToggle(),
                activeTrackColor: cycleModeColor,
                materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
