import 'dart:async';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../../../core/services/permission_service.dart';
import '../../../core/services/user_profile_service.dart';
import '../../../core/widgets/app_permission_dialog.dart';
import '../../focus/viewmodel/focus_controller.dart';
import '../../../l10n/app_localizations.dart';
import '../model/home_models.dart';
import '../viewmodel/home_tab_view_model.dart';
import 'widgets/home_action_container.dart';
import 'widgets/home_calendar_section.dart';
import 'widgets/home_circle_icon_button.dart';
import 'widgets/home_info_screens.dart';
import 'widgets/home_nearby_mosques_screen.dart';
import 'widgets/home_prayer_streak_detail_screen.dart';
import 'widgets/home_prayer_streak_section.dart';
import 'widgets/home_prayer_times_section.dart';
import 'widgets/home_qibla_screen.dart';
import 'widgets/home_verse_marquee.dart';

class HomeTabScreen extends StatelessWidget {
  const HomeTabScreen({super.key, required this.onOpenFocusTab});

  final VoidCallback onOpenFocusTab;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<HomeTabViewModel>(
      create: (_) => HomeTabViewModel()..initialize(),
      child: _HomeTabView(onOpenFocusTab: onOpenFocusTab),
    );
  }
}

class _HomeTabView extends StatefulWidget {
  const _HomeTabView({required this.onOpenFocusTab});

  final VoidCallback onOpenFocusTab;

  @override
  State<_HomeTabView> createState() => _HomeTabViewState();
}

class _HomeTabViewState extends State<_HomeTabView>
    with WidgetsBindingObserver {
  bool _locationDialogOpen = false;

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
      context.read<HomeTabViewModel>().onAppResumed();
      context.read<FocusController>().refresh();
    }
  }

  Future<void> _showBlockingLocationDialogIfNeeded(
    BuildContext context,
    HomeTabViewModel vm,
  ) async {
    if (_locationDialogOpen || !vm.consumeLocationDialogFlag()) return;
    _locationDialogOpen = true;
    final l10n = AppLocalizations.of(context)!;
    await AppPermissionDialog.show(
      context,
      title: l10n.locationRequired,
      message: l10n.locationRequiredMessage,
      primaryButtonText: l10n.openSettings,
      onPrimaryTap: PermissionService.openLocationSettings,
    );
    _locationDialogOpen = false;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final softCardColor = isDark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.28)
        : const Color(0xFFF3F1EB);

    return Consumer3<HomeTabViewModel, FocusController, UserProfileService>(
      builder: (context, vm, focusVm, profile, _) {
        unawaited(_showBlockingLocationDialogIfNeeded(context, vm));

        if (vm.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        final currentMonth = DateFormat.yMMMM(
          l10n.localeName,
        ).format(vm.visibleMonth);

        return SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.homeSalam,
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                          Text(
                            profile.userName,
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                        ],
                      ),
                    ),
                    HomeCircleIconButton(
                      icon: Icons.chat_bubble_outline,
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const HomeAiChatScreen(),
                          ),
                        );
                      },
                    ),
                    const SizedBox(width: 10),
                    HomeCircleIconButton(
                      icon: Icons.dark_mode_outlined,
                      onTap: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                HomeVerseMarquee(
                  text: _verseText(l10n, vm.dailyVerse),
                  color: colorScheme.primary,
                ),
                if (focusVm.isAppsLocked) ...[
                  const SizedBox(height: 14),
                  _FocusLockCard(focusVm: focusVm),
                ],
                const SizedBox(height: 14),
                HomePrayerTimesSection(
                  prayerTimes: vm.prayerTimes,
                  backgroundColor: softCardColor,
                ),
                const SizedBox(height: 12),
                HomeActionContainer(
                  backgroundColor: softCardColor,
                  title: focusVm.homeCardTitle,
                  subtitle: focusVm.homeCardSubtitle,
                  icon: Icons.shield_outlined,
                  iconBackground: colorScheme.primaryContainer,
                  onTap: widget.onOpenFocusTab,
                ),
                const SizedBox(height: 12),
                HomeActionContainer(
                  backgroundColor: softCardColor,
                  title: l10n.homeQiblaDirection,
                  subtitle: vm.qiblaInfo == null
                      ? l10n.homeLocationMissingForQibla
                      : '${vm.qiblaInfo} ${l10n.homeToMakkah}',
                  icon: Icons.explore_outlined,
                  iconBackground: colorScheme.primaryContainer,
                  onTap: () => _openQiblaScreen(
                    context,
                    locationName: vm.locationName,
                    latitude: vm.latitude,
                    longitude: vm.longitude,
                  ),
                ),
                const SizedBox(height: 12),
                HomeActionContainer(
                  backgroundColor: softCardColor,
                  title: l10n.homeFindMasjid,
                  subtitle: l10n.homeSearchNearbyMosques,
                  icon: Icons.location_on_outlined,
                  iconBackground: colorScheme.tertiaryContainer,
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => HomeNearbyMosquesScreen(
                        initialLatitude: vm.latitude,
                        initialLongitude: vm.longitude,
                        initialLocationName: vm.locationName,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                HomePrayerStreakSection(
                  streakDays: vm.streakDays,
                  weekFlags: vm.weekStreakFlags,
                  backgroundColor: softCardColor,
                  onTap: () => _openPrayerStreakDetail(context, vm),
                ),
                const SizedBox(height: 12),
                HomeCalendarSection(
                  backgroundColor: softCardColor,
                  monthTitle: currentMonth,
                  visibleMonth: vm.visibleMonth,
                  isLoading: vm.isEventsLoading,
                  weekly: vm.weeklyCalendar,
                  monthEvents: vm.monthEvents,
                  weekEvents: vm.weekEvents,
                  selectedDate: vm.selectedDate,
                  onToggleMode: vm.setWeeklyCalendar,
                  onPreviousMonth: vm.goToPreviousMonth,
                  onNextMonth: vm.goToNextMonth,
                  onDateTap: (date) => _onCalendarTap(context, vm, date),
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
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: colorScheme.primary,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.homeJummahReminder,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }

  String _verseText(AppLocalizations l10n, HomeDailyVerse? verse) {
    if (verse == null) return l10n.homeDailyVerseFallback;
    return '"${verse.englishText}" — ${verse.surahName} ${verse.surahNumber}:${verse.ayahNumber}';
  }

  Future<void> _onCalendarTap(
    BuildContext context,
    HomeTabViewModel vm,
    DateTime date,
  ) async {
    vm.selectDate(date);
    final l10n = AppLocalizations.of(context)!;
    final eventOnDate = vm.eventsForDate(date);

    if (eventOnDate.isEmpty) {
      ScaffoldMessenger.of(context).hideCurrentSnackBar();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.homeNoEventsFoundForDay)));
      return;
    }

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat.yMMMMd(l10n.localeName).format(date),
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
                const SizedBox(height: 10),
                for (final item in eventOnDate)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.event_outlined),
                    title: Text(
                      item.title,
                      style: TextStyle(
                        color: Theme.of(ctx).colorScheme.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openQiblaScreen(
    BuildContext context, {
    required String? locationName,
    required double? latitude,
    required double? longitude,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => HomeQiblaScreen(
          locationName: locationName,
          latitude: latitude,
          longitude: longitude,
        ),
      ),
    );
  }

  void _openPrayerStreakDetail(BuildContext context, HomeTabViewModel vm) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ChangeNotifierProvider<HomeTabViewModel>.value(
          value: vm,
          child: const HomePrayerStreakDetailScreen(),
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
    final colorScheme = Theme.of(context).colorScheme;
    final isLocked = focusVm.isAppsLocked;

    return InkWell(
      onTap: isLocked ? () => focusVm.disableActiveMode() : null,
      borderRadius: BorderRadius.circular(22),
      child: Ink(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: isLocked
                ? colorScheme.error.withValues(alpha: 0.3)
                : colorScheme.primary.withValues(alpha: 0.2),
          ),
          color: isLocked
              ? colorScheme.errorContainer.withValues(alpha: 0.32)
              : colorScheme.primaryContainer.withValues(alpha: 0.4),
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
              child: Icon(
                isLocked ? Icons.lock_outline : Icons.lock_open_outlined,
                color: isLocked ? colorScheme.error : colorScheme.primary,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Focus Mode Active',
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    isLocked
                        ? 'Tap to turn off the current focus mode.'
                        : focusVm.statusCaption,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(999),
                color: isLocked
                    ? colorScheme.error.withValues(alpha: 0.1)
                    : colorScheme.primary.withValues(alpha: 0.12),
              ),
              child: Text(
                isLocked ? 'Turn Off' : 'Armed',
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: isLocked ? colorScheme.error : colorScheme.primary,
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
