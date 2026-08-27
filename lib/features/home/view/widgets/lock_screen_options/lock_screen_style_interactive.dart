import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../helpers/home_daily_verse_helper.dart';
import '../../../helpers/lock_screen_prayer_actions.dart';
import '../../../helpers/prayer_label_helper.dart';
import '../../../model/home_models.dart';
import '../../../viewmodel/home_tab_view_model.dart';
import '../../../viewmodel/lock_screen_countdown_view_model.dart';
import '../../../viewmodel/lock_screen_quiz_view_model.dart';
import '../../../viewmodel/lock_screen_tasbih_view_model.dart';
import '../../../viewmodel/lock_screen_verse_view_model.dart';
import 'lock_screen_style.dart';
import 'lock_screen_style_chrome.dart';

class LockScreenExperienceConfig extends InheritedWidget {
  const LockScreenExperienceConfig({
    super.key,
    required this.compact,
    required this.onConfirm,
    required this.onLater,
    required super.child,
  });

  final bool compact;
  final VoidCallback onConfirm;
  final VoidCallback onLater;

  static LockScreenExperienceConfig of(BuildContext context) {
    final config = context
        .dependOnInheritedWidgetOfExactType<LockScreenExperienceConfig>();
    assert(config != null, 'LockScreenExperienceConfig is missing');
    return config!;
  }

  @override
  bool updateShouldNotify(LockScreenExperienceConfig oldWidget) {
    return compact != oldWidget.compact ||
        onConfirm != oldWidget.onConfirm ||
        onLater != oldWidget.onLater;
  }
}

class LockScreenInteractiveStyle extends StatelessWidget {
  const LockScreenInteractiveStyle({
    super.key,
    required this.style,
    required this.prayer,
    this.compact = false,
    this.onConfirm,
    this.onLater,
  });

  final LockScreenStyle style;
  final TrackablePrayer prayer;
  final bool compact;
  final VoidCallback? onConfirm;
  final VoidCallback? onLater;

  @override
  Widget build(BuildContext context) {
    return LockScreenExperienceConfig(
      compact: compact,
      onConfirm:
          onConfirm ??
          () => LockScreenPrayerActions.confirmOnTime(context, prayer: prayer),
      onLater: onLater ?? () => LockScreenPrayerActions.markLater(context),
      child: _buildStyle(context),
    );
  }

  Widget _buildStyle(BuildContext context) {
    switch (style) {
      case LockScreenStyle.classic:
        return _ClassicInteractive(prayer: prayer);
      case LockScreenStyle.tasbih:
        return ChangeNotifierProvider(
          create: (_) => LockScreenTasbihViewModel(),
          child: _TasbihInteractive(prayer: prayer),
        );
      case LockScreenStyle.verse:
        return ChangeNotifierProvider(
          create: (_) => LockScreenVerseViewModel()..load(),
          child: _VerseInteractive(prayer: prayer),
        );
      case LockScreenStyle.dua:
        return _DuaInteractive(prayer: prayer);
      case LockScreenStyle.quiz:
        return ChangeNotifierProvider(
          create: (ctx) =>
              LockScreenQuizViewModel.fromL10n(AppLocalizations.of(ctx)!),
          child: _QuizInteractive(prayer: prayer),
        );
      case LockScreenStyle.times:
        return _TimesInteractive(prayer: prayer);
      case LockScreenStyle.countdown:
        return ChangeNotifierProvider(
          create: (ctx) {
            Duration remaining = const Duration(
              hours: 2,
              minutes: 34,
              seconds: 57,
            );
            try {
              final next = ctx
                  .read<HomeTabViewModel>()
                  .prayerTimes
                  ?.nextPrayerTime;
              if (next != null) {
                final delta = next.difference(DateTime.now());
                if (!delta.isNegative) remaining = delta;
              }
            } on ProviderNotFoundException {
              // Keep fallback remaining so the timer still runs in isolation.
            }
            return LockScreenCountdownViewModel.fromRemaining(remaining);
          },
          child: _CountdownInteractive(prayer: prayer),
        );
      case LockScreenStyle.hold:
        return _HoldInteractive(prayer: prayer);
      case LockScreenStyle.typeConfirm:
        return _TypeInteractive(prayer: prayer);
      case LockScreenStyle.minimal:
        return _MinimalInteractive(prayer: prayer);
    }
  }
}

class _ExperienceScaffold extends StatelessWidget {
  const _ExperienceScaffold({
    required this.prayer,
    required this.body,
    this.showActions = true,
    this.showPrimary = true,
  });

  final TrackablePrayer prayer;
  final Widget body;
  final bool showActions;
  final bool showPrimary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final remainingLabel = LockScreenPrayerActions.remainingLabel(context);
    final config = LockScreenExperienceConfig.of(context);
    final compact = config.compact;

    final column = Column(
      mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
      children: [
        LockScreenPrayerHeader(
          prayerName: prayer.label(l10n),
          prayerArabic: LockScreenPrayerActions.prayerArabic(prayer),
          remaining: remainingLabel,
          compact: compact,
        ),
        SizedBox(height: compact ? 12 : 22),
        if (compact) body else Expanded(child: body),
        if (showActions) ...[
          SizedBox(height: compact ? 12 : 18),
          LockScreenActionButtons(
            primaryLabel: showPrimary ? l10n.prayerReminderYesButton : null,
            secondaryLabel: l10n.prayerReminderLaterButton,
            compact: compact,
            onPrimary: showPrimary ? config.onConfirm : null,
            onSecondary: config.onLater,
          ),
        ],
      ],
    );

    if (compact) return column;

    return LockScreenStage(
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 72, 24, 24),
        child: column,
      ),
    );
  }
}

class _ClassicInteractive extends StatelessWidget {
  const _ClassicInteractive({required this.prayer});

  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final prayerName = prayer.label(AppLocalizations.of(context)!);
    final config = LockScreenExperienceConfig.of(context);
    final card = LockScreenReminderCard(
      prayerName: prayerName,
      chrome: !config.compact,
      onPrimary: config.onConfirm,
      onSecondary: config.onLater,
    );

    if (config.compact) return card;

    return LockScreenStage(
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(24, 72, 24, 24),
        child: Center(child: SingleChildScrollView(child: card)),
      ),
    );
  }
}

class _DuaInteractive extends StatelessWidget {
  const _DuaInteractive({required this.prayer});

  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);
    final compact = LockScreenExperienceConfig.of(context).compact;
    final card = LockScreenContentCard(
      accentBorder: true,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            l10n.lockScreenDuaForToday.toUpperCase(),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: palette.accent,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.1,
            ),
          ),
          SizedBox(height: compact ? 12 : 16),
          Text(
            LockScreenSampleData.duaArabic,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontFamily: 'UthmanicHafs',
              color: palette.title,
              height: 1.55,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            LockScreenSampleData.duaTransliteration(l10n),
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: palette.accent,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '"${LockScreenSampleData.duaTranslation(l10n)}"',
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: palette.body, height: 1.4),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: palette.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              LockScreenSampleData.duaSource(l10n),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: palette.accent,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );

    return _ExperienceScaffold(
      prayer: prayer,
      body: compact ? card : Center(child: SingleChildScrollView(child: card)),
    );
  }
}

class _TasbihInteractive extends StatelessWidget {
  const _TasbihInteractive({required this.prayer});

  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);
    final vm = context.watch<LockScreenTasbihViewModel>();
    final step = vm.current;
    final config = LockScreenExperienceConfig.of(context);
    final compact = config.compact;

    return _ExperienceScaffold(
      prayer: prayer,
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          vm.tap();
          if (!vm.consumeSequenceCompletion()) return;
          Future<void>.delayed(const Duration(milliseconds: 350), () {
            if (context.mounted) config.onConfirm();
          });
        },
        child: Column(
          mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
          children: [
            if (!compact) const Spacer(),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 280),
              switchInCurve: Curves.easeOutCubic,
              switchOutCurve: Curves.easeInCubic,
              child: Column(
                key: ValueKey<int>(vm.stepIndex),
                children: [
                  Text(
                    step.arabic,
                    textAlign: TextAlign.center,
                    textDirection: TextDirection.rtl,
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontFamily: 'UthmanicHafs',
                      color: palette.title,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    vm.localizedTransliteration(l10n),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      color: palette.accent,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  SizedBox(height: compact ? 8 : 12),
                  Text(
                    '${vm.count}',
                    style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: palette.title,
                      fontWeight: FontWeight.w800,
                      height: 1,
                      fontSize: compact ? 48 : 72,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.lockScreenCountProgress(vm.count, step.target),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: palette.muted),
                  ),
                ],
              ),
            ),
            SizedBox(height: compact ? 12 : 20),
            LockScreenTasbihDots(
              labels: LockScreenTasbihViewModel.localizedLabels(l10n),
              activeIndex: vm.stepIndex,
            ),
            const SizedBox(height: 16),
            if (vm.hasStarted)
              TextButton.icon(
                onPressed: vm.reset,
                icon: const Icon(Icons.refresh_rounded, size: 18),
                label: Text(l10n.tasbihReset),
              )
            else
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.touch_app_outlined,
                    size: 14,
                    color: palette.muted,
                  ),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      l10n.lockScreenTapToCount,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: palette.muted),
                    ),
                  ),
                ],
              ),
            if (!compact) const Spacer(),
          ],
        ),
      ),
    );
  }
}

class _VerseInteractive extends StatelessWidget {
  const _VerseInteractive({required this.prayer});

  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);
    final vm = context.watch<LockScreenVerseViewModel>();
    final verse = vm.current;
    final useArabic = Localizations.localeOf(context).languageCode == 'ar';
    final compact = LockScreenExperienceConfig.of(context).compact;

    final card = vm.loading
        ? const Padding(
            padding: EdgeInsets.symmetric(vertical: 24),
            child: Center(child: CircularProgressIndicator()),
          )
        : verse == null
        ? const SizedBox.shrink()
        : LockScreenContentCard(
            accentBorder: true,
            padding: EdgeInsets.fromLTRB(
              compact ? 14 : 18,
              compact ? 16 : 20,
              compact ? 14 : 18,
              compact ? 14 : 16,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  l10n.lockScreenVerseForToday.toUpperCase(),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: palette.accent,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.1,
                  ),
                ),
                SizedBox(height: compact ? 12 : 16),
                Text(
                  verse.arabicText,
                  textAlign: TextAlign.center,
                  textDirection: TextDirection.rtl,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'UthmanicHafs',
                    color: palette.accent,
                    height: 1.55,
                  ),
                ),
                SizedBox(height: compact ? 10 : 14),
                Text(
                  verse.englishText,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: palette.title,
                    fontStyle: FontStyle.italic,
                    height: 1.4,
                  ),
                ),
                const SizedBox(height: 10),
                Align(
                  alignment: AlignmentDirectional.centerEnd,
                  child: Text(
                    HomeDailyVerseHelper.localizedSource(
                      verse,
                      l10n: l10n,
                      useArabic: useArabic,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.labelSmall?.copyWith(color: palette.muted),
                  ),
                ),
              ],
            ),
          );

    return _ExperienceScaffold(
      prayer: prayer,
      body: Column(
        mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
        children: [
          if (compact)
            card
          else
            Expanded(
              child: Center(child: SingleChildScrollView(child: card)),
            ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: TextButton.icon(
              onPressed: vm.loading ? null : vm.next,
              icon: Icon(Icons.arrow_forward_rounded, color: palette.accent),
              label: Text(
                l10n.lockScreenNextVerse,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: palette.accent,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizInteractive extends StatelessWidget {
  const _QuizInteractive({required this.prayer});

  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);
    final vm = context.watch<LockScreenQuizViewModel>();
    final compact = LockScreenExperienceConfig.of(context).compact;

    if (vm.complete) {
      final done = LockScreenContentCard(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.check_circle_rounded, color: palette.primary, size: 40),
            const SizedBox(height: 12),
            Text(
              l10n.lockScreenQuizComplete,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w800,
                color: palette.title,
              ),
            ),
          ],
        ),
      );
      return _ExperienceScaffold(
        prayer: prayer,
        body: compact ? done : Center(child: done),
      );
    }

    final question = vm.current;
    final quizBody = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          question.category.toUpperCase(),
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: palette.accent,
            fontWeight: FontWeight.w800,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          question.question,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: palette.title,
            fontWeight: FontWeight.w800,
            height: 1.25,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            for (var i = 0; i < vm.total; i++) ...[
              if (i > 0) const SizedBox(width: 6),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: i <= vm.index
                        ? palette.accent
                        : palette.muted.withValues(alpha: 0.25),
                    borderRadius: BorderRadius.circular(99),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 16),
        for (var i = 0; i < question.options.length; i++) ...[
          _QuizChoice(
            letter: String.fromCharCode(65 + i),
            label: question.options[i],
            selected: vm.selectedIndex == i,
            correct: vm.answered && i == question.correctIndex,
            wrong:
                vm.answered &&
                vm.selectedIndex == i &&
                i != question.correctIndex,
            onTap: () => vm.select(i),
            palette: palette,
          ),
          if (i != question.options.length - 1) const SizedBox(height: 8),
        ],
        if (vm.answered) ...[
          const SizedBox(height: 10),
          Text(
            vm.lastWasCorrect
                ? l10n.lockScreenQuizCorrect
                : l10n.lockScreenQuizIncorrect,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: vm.lastWasCorrect
                  ? palette.primary
                  : Theme.of(context).colorScheme.error,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ],
    );

    return _ExperienceScaffold(
      prayer: prayer,
      body: compact ? quizBody : SingleChildScrollView(child: quizBody),
    );
  }
}

class _QuizChoice extends StatelessWidget {
  const _QuizChoice({
    required this.letter,
    required this.label,
    required this.selected,
    required this.correct,
    required this.wrong,
    required this.onTap,
    required this.palette,
  });

  final String letter;
  final String label;
  final bool selected;
  final bool correct;
  final bool wrong;
  final VoidCallback onTap;
  final LockScreenPalette palette;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final border = correct
        ? palette.primary
        : wrong
        ? colorScheme.error
        : selected
        ? palette.primary
        : palette.border;
    return Material(
      color: palette.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: border,
              width: correct || wrong ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              Text(
                letter,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: correct ? palette.primary : palette.accent,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: palette.title,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              if (correct)
                Icon(
                  Icons.check_circle_rounded,
                  color: palette.primary,
                  size: 20,
                ),
              if (wrong)
                Icon(Icons.cancel_rounded, color: colorScheme.error, size: 20),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimesInteractive extends StatelessWidget {
  const _TimesInteractive({required this.prayer});

  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);
    HomeTabViewModel? home;
    try {
      home = context.watch<HomeTabViewModel>();
    } on ProviderNotFoundException {
      home = null;
    }
    final slots = home?.prayerTimes?.slots ?? const [];
    final currentId = prayer.homePrayerId;

    final compact = LockScreenExperienceConfig.of(context).compact;
    final timesCard = LockScreenContentCard(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (slots.isEmpty)
            for (final row in LockScreenSampleData.prayerTimes(l10n))
              _TimeRow(
                name: row.$1,
                time: row.$2.format(context),
                active: row.$1 == prayer.label(l10n),
                palette: palette,
              )
          else
            for (final slot in slots.where((s) => s.id != HomePrayerId.sunrise))
              _TimeRow(
                name: slot.id.trackablePrayer?.label(l10n) ?? slot.id.name,
                time: TimeOfDay.fromDateTime(slot.time).format(context),
                active: slot.id == currentId,
                palette: palette,
              ),
        ],
      ),
    );

    return _ExperienceScaffold(
      prayer: prayer,
      body: compact ? timesCard : Center(child: timesCard),
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.name,
    required this.time,
    required this.active,
    required this.palette,
  });

  final String name;
  final String time;
  final bool active;
  final LockScreenPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 3),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: active
            ? palette.primary.withValues(alpha: 0.16)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                color: palette.title,
                fontWeight: active ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
          Text(
            time,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: active ? palette.primary : palette.muted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _CountdownInteractive extends StatelessWidget {
  const _CountdownInteractive({required this.prayer});

  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);
    final vm = context.watch<LockScreenCountdownViewModel>();
    final compact = LockScreenExperienceConfig.of(context).compact;

    return _ExperienceScaffold(
      prayer: prayer,
      body: Column(
        mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
        children: [
          if (!compact) const Spacer(),
          Text(
            vm.complete ? l10n.lockScreenTimeUp : vm.clockLabel,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: palette.title,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
              height: 1,
              fontSize: compact ? 40 : 58,
              shadows: [
                Shadow(
                  color: palette.primary.withValues(alpha: 0.35),
                  blurRadius: 18,
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(99),
            child: SizedBox(
              height: 6,
              child: LinearProgressIndicator(
                value: vm.progress,
                minHeight: 6,
                backgroundColor: palette.muted.withValues(alpha: 0.25),
                color: palette.accent,
              ),
            ),
          ),
          if (!compact) const Spacer() else const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _HoldInteractive extends StatefulWidget {
  const _HoldInteractive({required this.prayer});

  final TrackablePrayer prayer;

  @override
  State<_HoldInteractive> createState() => _HoldInteractiveState();
}

class _HoldInteractiveState extends State<_HoldInteractive>
    with SingleTickerProviderStateMixin {
  static const _holdDuration = Duration(milliseconds: 1400);
  late final AnimationController _controller;
  bool _confirmed = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _holdDuration)
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed && !_confirmed) {
          _confirmed = true;
          LockScreenExperienceConfig.of(context).onConfirm();
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _cancel() {
    if (_confirmed) return;
    _controller.reverse();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);
    final compact = LockScreenExperienceConfig.of(context).compact;
    final size = compact ? 140.0 : 196.0;

    return _ExperienceScaffold(
      prayer: widget.prayer,
      showActions: true,
      showPrimary: false,
      body: Column(
        mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
        children: [
          if (!compact) const Spacer(),
          Text(
            l10n.lockScreenConfirmBeforeAllah,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: palette.body, height: 1.4),
          ),
          SizedBox(height: compact ? 16 : 24),
          Listener(
            onPointerDown: (_) {
              if (_confirmed) return;
              _controller.forward();
            },
            onPointerUp: (_) => _cancel(),
            onPointerCancel: (_) => _cancel(),
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return CustomPaint(
                  painter: _HoldRingPainter(
                    progress: _controller.value,
                    track: palette.primary.withValues(alpha: 0.22),
                    fill: palette.primary,
                  ),
                  child: Container(
                    width: size,
                    height: size,
                    alignment: Alignment.center,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            LockScreenPrayerActions.prayerArabic(widget.prayer),
                            textDirection: TextDirection.rtl,
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontFamily: 'UthmanicHafs',
                                  color: palette.title,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            l10n.lockScreenHoldHint,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(color: palette.muted),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (!compact) const Spacer() else const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _HoldRingPainter extends CustomPainter {
  _HoldRingPainter({
    required this.progress,
    required this.track,
    required this.fill,
  });

  final double progress;
  final Color track;
  final Color fill;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.shortestSide / 2 - 4;
    final trackPaint = Paint()
      ..color = track
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6;
    final fillPaint = Paint()
      ..color = fill
      ..style = PaintingStyle.stroke
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(center, radius, trackPaint);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -1.5708,
      progress * 6.2832,
      false,
      fillPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _HoldRingPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
}

class _TypeInteractive extends StatefulWidget {
  const _TypeInteractive({required this.prayer});

  final TrackablePrayer prayer;

  @override
  State<_TypeInteractive> createState() => _TypeInteractiveState();
}

class _TypeInteractiveState extends State<_TypeInteractive> {
  final _controller = TextEditingController();
  bool _confirmed = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value, String expected) {
    final typed = value.replaceAll(RegExp(r'\s+'), '').toUpperCase();
    final need = expected.replaceAll(RegExp(r'\s+'), '').toUpperCase();
    if (!_confirmed && typed == need && need.isNotEmpty) {
      _confirmed = true;
      FocusScope.of(context).unfocus();
      LockScreenExperienceConfig.of(context).onConfirm();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);
    final expected = l10n.lockScreenTypeWord;
    final compact = LockScreenExperienceConfig.of(context).compact;

    return _ExperienceScaffold(
      prayer: widget.prayer,
      showPrimary: false,
      body: Column(
        mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
        children: [
          if (!compact) const Spacer(),
          Text(
            l10n.lockScreenConfirmBeforeAllah,
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: palette.body, height: 1.4),
          ),
          SizedBox(height: compact ? 16 : 28),
          Text(
            l10n.lockScreenTypeHint(expected),
            textAlign: TextAlign.center,
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: palette.muted),
          ),
          const SizedBox(height: 12),
          LockScreenTypeConfirmField(
            expected: expected,
            controller: _controller,
            onChanged: (value) => _onChanged(value, expected),
          ),
          if (!compact) const Spacer() else const SizedBox(height: 8),
        ],
      ),
    );
  }
}

class _MinimalInteractive extends StatelessWidget {
  const _MinimalInteractive({required this.prayer});

  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);
    final textTheme = Theme.of(context).textTheme;
    final remaining =
        LockScreenPrayerActions.remainingLabel(context) ??
        LockScreenSampleData.remaining(l10n);
    final config = LockScreenExperienceConfig.of(context);
    final compact = config.compact;

    final column = Column(
      mainAxisSize: compact ? MainAxisSize.min : MainAxisSize.max,
      children: [
        Text(
          l10n.appTitle,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.labelMedium?.copyWith(
            color: palette.primary,
            fontWeight: FontWeight.w800,
            letterSpacing: 1.4,
          ),
        ),
        if (!compact) const Spacer(flex: 2) else const SizedBox(height: 16),
        Text(
          l10n.lockScreenItsTimeToPray,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(color: palette.muted),
        ),
        SizedBox(height: compact ? 8 : 12),
        Text(
          prayer.label(l10n),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.displaySmall?.copyWith(
            color: palette.primary,
            fontWeight: FontWeight.w800,
            height: 1,
            fontSize: compact ? 36 : 52,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          LockScreenPrayerActions.prayerArabic(prayer),
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleLarge?.copyWith(
            fontFamily: 'UthmanicHafs',
            color: palette.accent,
          ),
        ),
        SizedBox(height: compact ? 12 : 20),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: palette.card.withValues(alpha: 0.7),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: palette.border),
          ),
          child: Text(
            l10n.lockScreenRemainingTime(remaining),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.labelMedium?.copyWith(color: palette.muted),
          ),
        ),
        if (!compact) const Spacer(flex: 3) else const SizedBox(height: 20),
        LockScreenActionButtons(
          primaryLabel: l10n.prayerReminderYesButton,
          secondaryLabel: l10n.prayerReminderLaterButton,
          compact: compact,
          onPrimary: config.onConfirm,
          onSecondary: config.onLater,
        ),
      ],
    );

    if (compact) return column;

    return LockScreenStage(
      child: SafeArea(
        minimum: const EdgeInsets.fromLTRB(28, 64, 28, 24),
        child: column,
      ),
    );
  }
}
