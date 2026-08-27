import 'package:flutter/material.dart';

import '../../../../../l10n/app_localizations.dart';
import '../../../helpers/lock_screen_prayer_actions.dart';
import '../../../helpers/prayer_label_helper.dart';
import '../../../model/home_models.dart';
import '../../../viewmodel/lock_screen_tasbih_view_model.dart';
import 'lock_screen_style.dart';
import 'lock_screen_style_chrome.dart';

/// Full visual layouts for each lock-screen style. Design-only: controls
/// do not change reminder or alarm behavior.
class LockScreenStyleView extends StatelessWidget {
  const LockScreenStyleView({
    super.key,
    required this.style,
    required this.prayer,
    this.compact = false,
  });

  final LockScreenStyle style;
  final TrackablePrayer prayer;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    switch (style) {
      case LockScreenStyle.classic:
        return _ClassicStyle(compact: compact, prayer: prayer);
      case LockScreenStyle.tasbih:
        return _TasbihStyle(compact: compact, prayer: prayer);
      case LockScreenStyle.verse:
        return _VerseStyle(compact: compact, prayer: prayer);
      case LockScreenStyle.dua:
        return _DuaStyle(compact: compact, prayer: prayer);
      case LockScreenStyle.quiz:
        return _QuizStyle(compact: compact, prayer: prayer);
      case LockScreenStyle.times:
        return _TimesStyle(compact: compact, prayer: prayer);
      case LockScreenStyle.countdown:
        return _CountdownStyle(compact: compact, prayer: prayer);
      case LockScreenStyle.hold:
        return _HoldStyle(compact: compact, prayer: prayer);
      case LockScreenStyle.typeConfirm:
        return _TypeStyle(compact: compact, prayer: prayer);
      case LockScreenStyle.minimal:
        return _MinimalStyle(compact: compact, prayer: prayer);
    }
  }
}

class _ClassicStyle extends StatelessWidget {
  const _ClassicStyle({required this.compact, required this.prayer});

  final bool compact;
  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return LockScreenStage(
      child: SafeArea(
        minimum: EdgeInsets.fromLTRB(
          compact ? 20 : 24,
          compact ? 56 : 72,
          compact ? 20 : 24,
          compact ? 20 : 24,
        ),
        child: Center(
          child: SingleChildScrollView(
            child: LockScreenReminderCard(
              prayerName: prayer.label(l10n),
              compact: compact,
            ),
          ),
        ),
      ),
    );
  }
}

class _FullscreenScaffold extends StatelessWidget {
  const _FullscreenScaffold({
    required this.compact,
    required this.prayer,
    required this.body,
    this.showActions = true,
  });

  final bool compact;
  final TrackablePrayer prayer;
  final Widget body;
  final bool showActions;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LockScreenStage(
      child: SafeArea(
        minimum: EdgeInsets.fromLTRB(
          compact ? 20 : 24,
          compact ? 56 : 72,
          compact ? 20 : 24,
          compact ? 20 : 24,
        ),
        child: Column(
          children: [
            LockScreenPrayerHeader(
              prayerName: prayer.label(l10n),
              prayerArabic: LockScreenPrayerActions.prayerArabic(prayer),
              remaining: LockScreenSampleData.remaining(l10n),
              compact: compact,
            ),
            SizedBox(height: compact ? 16 : 22),
            Expanded(child: body),
            if (showActions) ...[
              SizedBox(height: compact ? 14 : 18),
              LockScreenActionButtons(
                primaryLabel: l10n.prayerReminderYesButton,
                secondaryLabel: l10n.prayerReminderLaterButton,
                compact: compact,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TasbihStyle extends StatelessWidget {
  const _TasbihStyle({required this.compact, required this.prayer});

  final bool compact;
  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);
    final phrases = LockScreenTasbihViewModel.localizedLabels(l10n);

    return _FullscreenScaffold(
      compact: compact,
      prayer: prayer,
      body: Column(
        children: [
          const Spacer(),
          Text(
            LockScreenSampleData.dhikrArabic,
            textAlign: TextAlign.center,
            textDirection: TextDirection.rtl,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontFamily: 'UthmanicHafs',
              color: palette.title,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            LockScreenSampleData.dhikrLatin(l10n),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: palette.accent,
              fontWeight: FontWeight.w700,
            ),
          ),
          SizedBox(height: compact ? 8 : 12),
          Text(
            '19',
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
              color: palette.title,
              fontWeight: FontWeight.w800,
              height: 1,
              fontSize: compact ? 56 : 72,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            l10n.lockScreenCountProgress(19, 33),
            style: Theme.of(
              context,
            ).textTheme.bodySmall?.copyWith(color: palette.muted),
          ),
          SizedBox(height: compact ? 14 : 20),
          LockScreenTasbihDots(labels: phrases, activeIndex: 1),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.touch_app_outlined, size: 14, color: palette.muted),
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
          const Spacer(),
        ],
      ),
    );
  }
}

class _VerseStyle extends StatelessWidget {
  const _VerseStyle({required this.compact, required this.prayer});

  final bool compact;
  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);

    return _FullscreenScaffold(
      compact: compact,
      prayer: prayer,
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: LockScreenContentCard(
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
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: palette.accent,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.1,
                      ),
                    ),
                    SizedBox(height: compact ? 12 : 16),
                    Text(
                      LockScreenSampleData.verseArabic,
                      textAlign: TextAlign.center,
                      textDirection: TextDirection.rtl,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.headlineSmall
                          ?.copyWith(
                            fontFamily: 'UthmanicHafs',
                            color: palette.accent,
                            height: 1.55,
                          ),
                    ),
                    SizedBox(height: compact ? 10 : 14),
                    Text(
                      LockScreenSampleData.verseTranslation(l10n),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
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
                        LockScreenSampleData.verseRef(l10n),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(
                          context,
                        ).textTheme.labelSmall?.copyWith(color: palette.muted),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10, bottom: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.arrow_forward_rounded,
                  size: 16,
                  color: palette.accent,
                ),
                const SizedBox(width: 6),
                Text(
                  l10n.lockScreenNextVerse,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: palette.accent,
                    fontWeight: FontWeight.w700,
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

class _DuaStyle extends StatelessWidget {
  const _DuaStyle({required this.compact, required this.prayer});

  final bool compact;
  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);

    return _FullscreenScaffold(
      compact: compact,
      prayer: prayer,
      body: Center(
        child: LockScreenContentCard(
          accentBorder: true,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                l10n.lockScreenDuaForToday.toUpperCase(),
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
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
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: palette.accent,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                '"${LockScreenSampleData.duaTranslation(l10n)}"',
                textAlign: TextAlign.center,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: palette.body,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: palette.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Text(
                  LockScreenSampleData.duaSource(l10n),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: palette.accent,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuizStyle extends StatelessWidget {
  const _QuizStyle({required this.compact, required this.prayer});

  final bool compact;
  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);
    final options = [
      (l10n.lockScreenQuizA, false),
      (l10n.lockScreenQuizB, false),
      (l10n.lockScreenQuizC, true),
    ];

    return _FullscreenScaffold(
      compact: compact,
      prayer: prayer,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.lockScreenQuizCategory.toUpperCase(),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: palette.accent,
                fontWeight: FontWeight.w800,
                letterSpacing: 1,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              l10n.lockScreenQuizQuestion,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: palette.title,
                fontWeight: FontWeight.w800,
                height: 1.25,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                for (var i = 0; i < 3; i++) ...[
                  if (i > 0) const SizedBox(width: 6),
                  Expanded(
                    child: Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: i < 2
                            ? palette.accent
                            : palette.muted.withValues(alpha: 0.25),
                        borderRadius: BorderRadius.circular(99),
                      ),
                    ),
                  ),
                ],
              ],
            ),
            SizedBox(height: compact ? 12 : 16),
            for (var i = 0; i < options.length; i++) ...[
              _QuizOption(
                letter: String.fromCharCode(65 + i),
                label: options[i].$1,
                selected: options[i].$2,
                palette: palette,
              ),
              if (i != options.length - 1) const SizedBox(height: 8),
            ],
            const SizedBox(height: 10),
            Text(
              l10n.lockScreenQuizCorrect,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelLarge?.copyWith(
                color: palette.primary,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizOption extends StatelessWidget {
  const _QuizOption({
    required this.letter,
    required this.label,
    required this.selected,
    required this.palette,
  });

  final String letter;
  final String label;
  final bool selected;
  final LockScreenPalette palette;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: selected ? palette.primary : palette.border,
          width: selected ? 1.6 : 1,
        ),
      ),
      child: Row(
        children: [
          Text(
            letter,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              color: selected ? palette.primary : palette.accent,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: palette.title,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          if (selected)
            Icon(Icons.check_circle_rounded, color: palette.primary, size: 20),
        ],
      ),
    );
  }
}

class _TimesStyle extends StatelessWidget {
  const _TimesStyle({required this.compact, required this.prayer});

  final bool compact;
  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);
    final current = prayer.label(l10n);

    return _FullscreenScaffold(
      compact: compact,
      prayer: prayer,
      body: Center(
        child: LockScreenContentCard(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (final row in LockScreenSampleData.prayerTimes(l10n))
                _PrayerTimeRow(
                  name: row.$1,
                  time: row.$2.format(context),
                  active: row.$1 == current,
                  palette: palette,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PrayerTimeRow extends StatelessWidget {
  const _PrayerTimeRow({
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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
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

class _CountdownStyle extends StatelessWidget {
  const _CountdownStyle({required this.compact, required this.prayer});

  final bool compact;
  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final palette = LockScreenPalette.of(context);

    return _FullscreenScaffold(
      compact: compact,
      prayer: prayer,
      body: Column(
        children: [
          const Spacer(),
          Text(
            LockScreenSampleData.remainingClock,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: palette.title,
              fontWeight: FontWeight.w800,
              letterSpacing: -1.2,
              height: 1,
              fontSize: compact ? 48 : 58,
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
              child: Row(
                children: [
                  Expanded(flex: 18, child: ColoredBox(color: palette.accent)),
                  Expanded(
                    flex: 82,
                    child: ColoredBox(
                      color: palette.muted.withValues(alpha: 0.25),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}

class _HoldStyle extends StatelessWidget {
  const _HoldStyle({required this.compact, required this.prayer});

  final bool compact;
  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);
    final size = compact ? 168.0 : 196.0;

    return _FullscreenScaffold(
      compact: compact,
      prayer: prayer,
      showActions: false,
      body: Column(
        children: [
          const Spacer(),
          Text(
            l10n.lockScreenConfirmBeforeAllah,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: palette.body, height: 1.4),
          ),
          SizedBox(height: compact ? 18 : 24),
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: palette.primary.withValues(alpha: 0.10),
              border: Border.all(
                color: palette.primary.withValues(alpha: 0.55),
                width: 3,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  LockScreenPrayerActions.prayerArabic(prayer),
                  textDirection: TextDirection.rtl,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontFamily: 'UthmanicHafs',
                    color: palette.title,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    l10n.lockScreenHoldHint,
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: palette.muted),
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          LockScreenActionButtons(
            secondaryLabel: l10n.prayerReminderLaterButton,
            compact: compact,
          ),
        ],
      ),
    );
  }
}

class _TypeStyle extends StatelessWidget {
  const _TypeStyle({required this.compact, required this.prayer});

  final bool compact;
  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);

    return _FullscreenScaffold(
      compact: compact,
      prayer: prayer,
      showActions: false,
      body: Column(
        children: [
          const Spacer(),
          Text(
            l10n.lockScreenConfirmBeforeAllah,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: palette.body, height: 1.4),
          ),
          SizedBox(height: compact ? 22 : 28),
          Text(
            l10n.lockScreenTypeHint(l10n.lockScreenTypeWord),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: palette.muted.withValues(alpha: 0.75),
            ),
          ),
          const SizedBox(height: 12),
          LockScreenTypeConfirmField(
            expected: l10n.lockScreenTypeWord,
            readOnly: true,
          ),
          const Spacer(),
          LockScreenActionButtons(
            secondaryLabel: l10n.prayerReminderLaterButton,
            compact: compact,
          ),
        ],
      ),
    );
  }
}

class _MinimalStyle extends StatelessWidget {
  const _MinimalStyle({required this.compact, required this.prayer});

  final bool compact;
  final TrackablePrayer prayer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);
    final textTheme = Theme.of(context).textTheme;

    return LockScreenStage(
      child: SafeArea(
        minimum: EdgeInsets.fromLTRB(
          compact ? 20 : 28,
          compact ? 48 : 64,
          compact ? 20 : 28,
          compact ? 20 : 24,
        ),
        child: Column(
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
            const Spacer(flex: 2),
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
                fontSize: compact ? 40 : 52,
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
            SizedBox(height: compact ? 14 : 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: palette.card.withValues(alpha: 0.7),
                borderRadius: BorderRadius.circular(999),
                border: Border.all(color: palette.border),
              ),
              child: Text(
                l10n.lockScreenRemainingTime(
                  LockScreenSampleData.remaining(l10n),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: textTheme.labelMedium?.copyWith(color: palette.muted),
              ),
            ),
            const Spacer(flex: 3),
            LockScreenActionButtons(
              primaryLabel: l10n.prayerReminderYesButton,
              secondaryLabel: l10n.prayerReminderLaterButton,
              compact: compact,
            ),
          ],
        ),
      ),
    );
  }
}
