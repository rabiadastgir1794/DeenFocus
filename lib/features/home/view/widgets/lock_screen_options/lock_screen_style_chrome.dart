import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../../../core/theme/app_colors.dart';
import '../../../../../l10n/app_localizations.dart';

/// Shared visual pieces for lock-screen style previews.
class LockScreenPalette {
  const LockScreenPalette._({
    required this.background,
    required this.card,
    required this.border,
    required this.primary,
    required this.onPrimary,
    required this.accent,
    required this.title,
    required this.body,
    required this.muted,
  });

  factory LockScreenPalette.of(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return LockScreenPalette._(
      background: colorScheme.surface,
      card: isDark
          ? colorScheme.surfaceContainerHigh
          : colorScheme.surfaceContainerLowest,
      border: colorScheme.outlineVariant.withValues(
        alpha: isDark ? 0.45 : 0.35,
      ),
      primary: colorScheme.primary,
      onPrimary: colorScheme.onPrimary,
      accent: isDark ? AppColors.secondaryDark : AppColors.secondaryLight,
      title: colorScheme.onSurface,
      body: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
      muted: colorScheme.onSurfaceVariant,
    );
  }

  final Color background;
  final Color card;
  final Color border;
  final Color primary;
  final Color onPrimary;
  final Color accent;
  final Color title;
  final Color body;
  final Color muted;
}

class LockScreenStage extends StatelessWidget {
  const LockScreenStage({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final top = isDark ? AppColors.backgroundDark : AppColors.warmBg;
    final bottom = Color.lerp(
      top,
      isDark ? AppColors.primaryDark : AppColors.primary,
      isDark ? 0.22 : 0.16,
    )!;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [top, bottom],
        ),
      ),
      child: SizedBox.expand(
        child: Stack(
          fit: StackFit.expand,
          children: [
            IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: Alignment.center,
                    radius: 0.9,
                    colors: [
                      (isDark ? AppColors.primaryDark : AppColors.primary)
                          .withValues(alpha: isDark ? 0.18 : 0.12),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            child,
          ],
        ),
      ),
    );
  }
}

class LockScreenPrayerHeader extends StatelessWidget {
  const LockScreenPrayerHeader({
    super.key,
    required this.prayerName,
    required this.prayerArabic,
    this.remaining,
    this.compact = false,
  });

  final String prayerName;
  final String prayerArabic;
  final String? remaining;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Column(
      children: [
        Text(
          l10n.lockScreenItsTimeToPray,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.bodySmall?.copyWith(
            color: palette.muted,
            fontWeight: FontWeight.w500,
          ),
        ),
        SizedBox(height: compact ? 4 : 6),
        Text(
          prayerName,
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: (compact ? textTheme.headlineSmall : textTheme.headlineMedium)
              ?.copyWith(
                color: palette.title,
                fontWeight: FontWeight.w800,
                height: 1.1,
              ),
        ),
        SizedBox(height: compact ? 2 : 4),
        Text(
          prayerArabic,
          textAlign: TextAlign.center,
          textDirection: TextDirection.rtl,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: textTheme.titleMedium?.copyWith(
            fontFamily: 'UthmanicHafs',
            color: palette.accent,
            fontWeight: FontWeight.w500,
            height: 1.3,
          ),
        ),
        if (remaining != null) ...[
          SizedBox(height: compact ? 4 : 8),
          Text(
            l10n.lockScreenRemainingTime(remaining!),
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: textTheme.bodySmall?.copyWith(color: palette.muted),
          ),
        ],
      ],
    );
  }
}

class LockScreenActionButtons extends StatelessWidget {
  const LockScreenActionButtons({
    super.key,
    this.primaryLabel,
    required this.secondaryLabel,
    this.compact = false,
    this.onPrimary,
    this.onSecondary,
  });

  final String? primaryLabel;
  final String secondaryLabel;
  final bool compact;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final palette = LockScreenPalette.of(context);
    final radius = BorderRadius.circular(compact ? 14 : 16);

    return Column(
      children: [
        if (primaryLabel != null) ...[
          _ActionButton(
            label: primaryLabel!,
            filled: true,
            palette: palette,
            radius: radius,
            compact: compact,
            onTap: onPrimary,
          ),
          SizedBox(height: compact ? 8 : 10),
        ],
        _ActionButton(
          label: secondaryLabel,
          filled: false,
          palette: palette,
          radius: radius,
          compact: compact,
          onTap: onSecondary,
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.filled,
    required this.palette,
    required this.radius,
    required this.compact,
    this.onTap,
  });

  final String label;
  final bool filled;
  final LockScreenPalette palette;
  final BorderRadius radius;
  final bool compact;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: filled ? palette.primary : Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: onTap,
        borderRadius: radius,
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(vertical: compact ? 10 : 14),
          decoration: BoxDecoration(
            borderRadius: radius,
            border: filled
                ? null
                : Border.all(color: palette.primary, width: 1.4),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: filled ? palette.onPrimary : palette.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class LockScreenContentCard extends StatelessWidget {
  const LockScreenContentCard({
    super.key,
    required this.child,
    this.accentBorder = false,
    this.padding,
  });

  final Widget child;
  final bool accentBorder;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    final palette = LockScreenPalette.of(context);
    return Container(
      width: double.infinity,
      padding: padding ?? const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: palette.card,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: accentBorder
              ? palette.accent.withValues(alpha: 0.7)
              : palette.border,
          width: accentBorder ? 1.2 : 1,
        ),
      ),
      child: child,
    );
  }
}

class LockScreenPhoneFrame extends StatelessWidget {
  const LockScreenPhoneFrame({
    super.key,
    required this.child,
    required this.selected,
  });

  final Widget child;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final palette = LockScreenPalette.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 220),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: selected ? palette.primary : palette.border,
          width: selected ? 2.4 : 1,
        ),
        boxShadow: [
          BoxShadow(
            color: selected
                ? palette.primary.withValues(alpha: 0.22)
                : Colors.black.withValues(alpha: 0.06),
            blurRadius: selected ? 16 : 8,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(19.5),
        child: ColoredBox(color: colorScheme.surface, child: child),
      ),
    );
  }
}

/// Scaled-down snapshot of a lock-screen layout inside a phone card.
class LockScreenMiniPreview extends StatelessWidget {
  const LockScreenMiniPreview({super.key, required this.child});

  final Widget child;

  static const double _designWidth = 390;
  static const double _designHeight = 780;

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.contain,
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: _designWidth,
        height: _designHeight,
        child: Padding(
          padding: const EdgeInsets.only(top: 52),
          child: IgnorePointer(child: child),
        ),
      ),
    );
  }
}

class LockScreenPreviewChrome extends StatelessWidget {
  const LockScreenPreviewChrome({
    super.key,
    required this.label,
    required this.onClose,
    required this.child,
  });

  final String label;
  final VoidCallback onClose;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);

    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Material(
      color: isDark ? AppColors.backgroundDark : AppColors.warmBg,
      child: Stack(
        fit: StackFit.expand,
        children: [
          child,
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Flexible(
                    child: Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: palette.card.withValues(alpha: 0.92),
                          borderRadius: BorderRadius.circular(999),
                          border: Border.all(color: palette.border),
                        ),
                        child: Text(
                          '${l10n.lockScreenPreviewLabel} · $label',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.labelSmall
                              ?.copyWith(
                                color: palette.title,
                                fontWeight: FontWeight.w700,
                              ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Material(
                    color: palette.card.withValues(alpha: 0.92),
                    shape: const CircleBorder(),
                    child: InkWell(
                      customBorder: const CircleBorder(),
                      onTap: onClose,
                      child: SizedBox(
                        width: 40,
                        height: 40,
                        child: Icon(
                          Icons.close_rounded,
                          color: palette.title,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LockScreenTasbihDots extends StatelessWidget {
  const LockScreenTasbihDots({
    super.key,
    required this.labels,
    required this.activeIndex,
  });

  final List<String> labels;
  final int activeIndex;

  @override
  Widget build(BuildContext context) {
    final palette = LockScreenPalette.of(context);
    return Row(
      children: [
        for (var i = 0; i < labels.length; i++)
          Expanded(
            child: Column(
              children: [
                _TasbihDot(
                  completed: i < activeIndex,
                  active: i == activeIndex,
                  accent: palette.accent,
                  muted: palette.muted,
                ),
                const SizedBox(height: 6),
                Text(
                  labels[i],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: i == activeIndex
                        ? palette.title
                        : i < activeIndex
                        ? palette.accent
                        : palette.muted,
                    fontWeight: i == activeIndex
                        ? FontWeight.w700
                        : FontWeight.w500,
                    fontSize: 9,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _TasbihDot extends StatelessWidget {
  const _TasbihDot({
    required this.completed,
    required this.active,
    required this.accent,
    required this.muted,
  });

  final bool completed;
  final bool active;
  final Color accent;
  final Color muted;

  @override
  Widget build(BuildContext context) {
    final filled = completed || active;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 240),
      curve: Curves.easeOutCubic,
      width: active ? 11 : 8,
      height: active ? 11 : 8,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: filled ? accent : Colors.transparent,
        border: Border.all(
          color: filled ? accent : muted,
          width: active ? 1.6 : 1,
        ),
      ),
    );
  }
}

/// Standard uppercase confirm field with a dim hint of the expected word.
class LockScreenTypeConfirmField extends StatelessWidget {
  const LockScreenTypeConfirmField({
    super.key,
    required this.expected,
    this.controller,
    this.onChanged,
    this.readOnly = false,
  });

  final String expected;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final bool readOnly;

  @override
  Widget build(BuildContext context) {
    final palette = LockScreenPalette.of(context);
    final fieldStyle = Theme.of(context).textTheme.headlineSmall?.copyWith(
      color: palette.title,
      fontWeight: FontWeight.w300,
      letterSpacing: 3.2,
      height: 1.2,
    );
    final hintStyle = fieldStyle?.copyWith(
      color: palette.muted.withValues(alpha: 0.35),
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        TextField(
          controller: controller,
          readOnly: readOnly,
          enabled: !readOnly,
          autofocus: !readOnly,
          textAlign: TextAlign.center,
          textCapitalization: TextCapitalization.characters,
          inputFormatters: const [_UpperCaseTextFormatter()],
          autocorrect: false,
          enableSuggestions: false,
          style: fieldStyle,
          cursorColor: palette.primary,
          decoration: InputDecoration(
            isCollapsed: true,
            hintText: expected,
            hintStyle: hintStyle,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            disabledBorder: InputBorder.none,
          ),
          onChanged: onChanged,
        ),
        const SizedBox(height: 8),
        Container(
          height: 1.5,
          width: 220,
          color: palette.title.withValues(alpha: 0.55),
        ),
      ],
    );
  }
}

class _UpperCaseTextFormatter extends TextInputFormatter {
  const _UpperCaseTextFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return newValue.copyWith(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}

class LockScreenReminderCard extends StatelessWidget {
  const LockScreenReminderCard({
    super.key,
    required this.prayerName,
    this.compact = false,
    this.chrome = true,
    this.onPrimary,
    this.onSecondary,
  });

  final String prayerName;
  final bool compact;
  final bool chrome;
  final VoidCallback? onPrimary;
  final VoidCallback? onSecondary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final palette = LockScreenPalette.of(context);
    final colorScheme = Theme.of(context).colorScheme;

    final body = Padding(
      padding: chrome ? EdgeInsets.all(compact ? 20 : 24) : EdgeInsets.zero,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: compact ? 64 : 80,
            height: compact ? 64 : 80,
            decoration: BoxDecoration(
              color: colorScheme.primaryContainer,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.mosque_rounded,
              size: compact ? 32 : 40,
              color: colorScheme.primary,
            ),
          ),
          SizedBox(height: compact ? 16 : 20),
          Text(
            l10n.prayerReminderTitle(prayerName),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              color: palette.title,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.prayerReminderSubtitle,
            textAlign: TextAlign.center,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: palette.body, height: 1.45),
          ),
          SizedBox(height: compact ? 18 : 22),
          LockScreenActionButtons(
            primaryLabel: l10n.prayerReminderYesButton,
            secondaryLabel: l10n.prayerReminderLaterButton,
            compact: compact,
            onPrimary: onPrimary,
            onSecondary: onSecondary,
          ),
        ],
      ),
    );

    if (!chrome) return body;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 360),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: palette.card,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: body,
      ),
    );
  }
}

class LockScreenSampleData {
  static const remainingClock = '2:34:57';

  static const verseArabic = 'فَاذْكُرُونِي أَذْكُرْكُمْ';
  static const duaArabic = 'رَبَّنَا آتِنَا فِي الدُّنْيَا حَسَنَةً';
  static const dhikrArabic = 'سُبْحَانَ اللّٰهِ';

  static String remaining(AppLocalizations l10n) =>
      l10n.lockScreenSampleRemaining;

  static String verseTranslation(AppLocalizations l10n) =>
      l10n.lockScreenVerseTranslation;

  static String verseRef(AppLocalizations l10n) => l10n.lockScreenVerseRef;

  static String duaTransliteration(AppLocalizations l10n) =>
      l10n.lockScreenDuaTransliteration;

  static String duaTranslation(AppLocalizations l10n) =>
      l10n.lockScreenDuaTranslation;

  static String duaSource(AppLocalizations l10n) => l10n.lockScreenDuaSource;

  static String dhikrLatin(AppLocalizations l10n) =>
      l10n.lockScreenDhikrSubhanAllah;

  static List<(String, TimeOfDay)> prayerTimes(AppLocalizations l10n) => [
    (l10n.homePrayerFajr, const TimeOfDay(hour: 5, minute: 2)),
    (l10n.homePrayerDhuhr, const TimeOfDay(hour: 12, minute: 10)),
    (l10n.homePrayerAsr, const TimeOfDay(hour: 15, minute: 30)),
    (l10n.homePrayerMaghrib, const TimeOfDay(hour: 18, minute: 31)),
    (l10n.homePrayerIsha, const TimeOfDay(hour: 19, minute: 50)),
  ];
}
