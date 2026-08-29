import 'package:flutter/material.dart';

import '../../../../core/widgets/widgets.dart';
import '../../../../l10n/app_localizations.dart';

/// Settings → About Deen Focus marketing overview.
class SettingsAboutScreen extends StatelessWidget {
  const SettingsAboutScreen({super.key});

  static const Color _cyclePink = Color(0xFFE59DB7);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context)!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final cardColor = isDark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.45)
        : colorScheme.surfaceContainerHighest.withValues(alpha: 0.55);

    final offers = <_AboutOfferData>[
      _AboutOfferData(
        icon: Icons.schedule_rounded,
        title: l10n.settingsAboutOfferPrayerTimesTitle,
        subtitle: l10n.settingsAboutOfferPrayerTimesSubtitle,
      ),
      _AboutOfferData(
        icon: Icons.local_fire_department_rounded,
        title: l10n.settingsAboutOfferPrayerStreaksTitle,
        subtitle: l10n.settingsAboutOfferPrayerStreaksSubtitle,
        showNew: true,
      ),
      _AboutOfferData(
        icon: Icons.water_drop_rounded,
        iconColor: _cyclePink,
        iconBackground: _cyclePink.withValues(alpha: 0.18),
        title: l10n.settingsAboutOfferCycleModeTitle,
        subtitle: l10n.settingsAboutOfferCycleModeSubtitle,
        showNew: true,
      ),
      _AboutOfferData(
        icon: Icons.menu_book_rounded,
        title: l10n.settingsAboutOfferQuranTajweedTitle,
        subtitle: l10n.settingsAboutOfferQuranTajweedSubtitle,
        showNew: true,
      ),
      _AboutOfferData(
        icon: Icons.sensors_rounded,
        title: l10n.settingsAboutOfferLiveActivitiesTitle,
        subtitle: l10n.settingsAboutOfferLiveActivitiesSubtitle,
        showNew: true,
      ),
      _AboutOfferData(
        icon: Icons.explore_rounded,
        title: l10n.settingsAboutOfferQiblaTitle,
        subtitle: l10n.settingsAboutOfferQiblaSubtitle,
      ),
      _AboutOfferData(
        icon: Icons.shield_outlined,
        title: l10n.settingsAboutOfferFocusModesTitle,
        subtitle: l10n.settingsAboutOfferFocusModesSubtitle,
      ),
      _AboutOfferData(
        icon: Icons.brightness_7_outlined,
        title: l10n.settingsAboutOfferTasbihTitle,
        subtitle: l10n.settingsAboutOfferTasbihSubtitle,
      ),
      _AboutOfferData(
        icon: Icons.calendar_month_outlined,
        title: l10n.settingsAboutOfferCalendarTitle,
        subtitle: l10n.settingsAboutOfferCalendarSubtitle,
      ),
    ];

    final gridCards = <_AboutGridData>[
      _AboutGridData(
        icon: Icons.star_rounded,
        background: const Color(0xFFF0E8FF),
        iconColor: const Color(0xFF7E57C2),
        title: l10n.settingsAboutGridNamesTitle,
        subtitle: l10n.settingsAboutGridNamesSubtitle,
      ),
      _AboutGridData(
        icon: Icons.menu_book_outlined,
        background: const Color(0xFFE3F0FF),
        iconColor: const Color(0xFF1976D2),
        title: l10n.settingsAboutGridDuasTitle,
        subtitle: l10n.settingsAboutGridDuasSubtitle,
      ),
      _AboutGridData(
        icon: Icons.self_improvement_outlined,
        background: const Color(0xFFF5EDE0),
        iconColor: const Color(0xFF8D6E63),
        title: l10n.settingsAboutGridPrayerTitle,
        subtitle: l10n.settingsAboutGridPrayerSubtitle,
      ),
      _AboutGridData(
        icon: Icons.balance_outlined,
        background: const Color(0xFFEEEEEE),
        iconColor: const Color(0xFF616161),
        title: l10n.settingsAboutGridFiqhTitle,
        subtitle: l10n.settingsAboutGridFiqhSubtitle,
      ),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            AppCenteredNavHeader(
              title: l10n.settingsAboutTitle,
              backLabel: l10n.calendarBack,
              onBack: () => Navigator.of(context).pop(),
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                children: [
                  Container(
                    padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
                    decoration: BoxDecoration(
                      color: cardColor,
                      borderRadius: BorderRadius.circular(24),
                      border: Border.all(
                        color: colorScheme.outlineVariant.withValues(
                          alpha: 0.28,
                        ),
                      ),
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: 72,
                          height: 72,
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Icon(
                            Icons.mosque_outlined,
                            size: 36,
                            color: colorScheme.primary,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          l10n.appTitle,
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          l10n.settingsAboutTagline,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w500,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.settingsAboutDescription,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            height: 1.45,
                            color: colorScheme.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 22),
                        _OffersSectionHeader(label: l10n.settingsAboutOffersHeading),
                        const SizedBox(height: 18),
                        for (var i = 0; i < offers.length; i++) ...[
                          if (i > 0) const SizedBox(height: 16),
                          _AboutOfferRow(
                            data: offers[i],
                            newBadgeLabel: l10n.settingsAboutNewBadge,
                          ),
                        ],
                        const SizedBox(height: 20),
                        SizedBox(
                          height: 132,
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            itemCount: gridCards.length,
                            separatorBuilder: (_, _) => const SizedBox(width: 10),
                            itemBuilder: (context, index) {
                              return _AboutGridCard(data: gridCards[index]);
                            },
                          ),
                        ),
                        const SizedBox(height: 20),
                        Divider(
                          color: colorScheme.outlineVariant.withValues(
                            alpha: 0.35,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: colorScheme.primary.withValues(alpha: 0.08),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: colorScheme.primary.withValues(
                                    alpha: 0.16,
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  Icons.favorite_rounded,
                                  size: 18,
                                  color: colorScheme.primary,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  l10n.settingsAboutFooterCard,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.copyWith(height: 1.4),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.settingsAboutFooter,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                            height: 1.35,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AboutOfferData {
  const _AboutOfferData({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
    this.iconBackground,
    this.showNew = false,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;
  final Color? iconBackground;
  final bool showNew;
}

class _AboutGridData {
  const _AboutGridData({
    required this.icon,
    required this.background,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color background;
  final Color iconColor;
  final String title;
  final String subtitle;
}

class _OffersSectionHeader extends StatelessWidget {
  const _OffersSectionHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final lineColor = colorScheme.outlineVariant.withValues(alpha: 0.55);

    return Row(
      children: [
        Expanded(child: _DashedLine(color: lineColor)),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.auto_awesome_rounded,
                size: 14,
                color: colorScheme.primary,
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ),
        Expanded(child: _DashedLine(color: lineColor)),
      ],
    );
  }
}

class _DashedLine extends StatelessWidget {
  const _DashedLine({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedLinePainter(color: color),
      child: const SizedBox(height: 1, width: double.infinity),
    );
  }
}

class _DashedLinePainter extends CustomPainter {
  _DashedLinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;
    const dashWidth = 4.0;
    const gap = 4.0;
    var x = 0.0;
    while (x < size.width) {
      final end = (x + dashWidth).clamp(0.0, size.width);
      canvas.drawLine(Offset(x, 0), Offset(end, 0), paint);
      x += dashWidth + gap;
    }
  }

  @override
  bool shouldRepaint(covariant _DashedLinePainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

class _AboutOfferRow extends StatelessWidget {
  const _AboutOfferRow({
    required this.data,
    required this.newBadgeLabel,
  });

  final _AboutOfferData data;
  final String newBadgeLabel;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final iconColor = data.iconColor ?? colorScheme.primary;
    final iconBg =
        data.iconBackground ?? colorScheme.primary.withValues(alpha: 0.12);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: iconBg,
            shape: BoxShape.circle,
          ),
          child: Icon(data.icon, size: 20, color: iconColor),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      data.title,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  if (data.showNew) ...[
                    const SizedBox(width: 6),
                    _NewBadge(label: newBadgeLabel),
                  ],
                ],
              ),
              const SizedBox(height: 3),
              Text(
                data.subtitle,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  height: 1.35,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _NewBadge extends StatelessWidget {
  const _NewBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
        color: colorScheme.primary,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colorScheme.onPrimary,
          fontWeight: FontWeight.w700,
          height: 1,
        ),
      ),
    );
  }
}

class _AboutGridCard extends StatelessWidget {
  const _AboutGridCard({required this.data});

  final _AboutGridData data;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? data.background.withValues(alpha: 0.35) : data.background;

    return Container(
      width: 148,
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: isDark ? 0.12 : 0.72),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(data.icon, size: 18, color: data.iconColor),
          ),
          const SizedBox(height: 10),
          Text(
            data.title,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.2,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          Expanded(
            child: Text(
              data.subtitle,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                height: 1.3,
                fontSize: 11,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
