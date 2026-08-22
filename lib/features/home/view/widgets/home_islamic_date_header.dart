import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/constants/spacing.dart';
import '../../../../l10n/app_localizations.dart';
import '../../helpers/islamic_event_catalog.dart';
import '../../services/hijri_date_service.dart';

/// Islamic date header showing Hijri date, Gregorian date, greeting, and user name.
/// The Islamic date section is tappable and navigates to the Calendar screen.
class HomeIslamicDateHeader extends StatefulWidget {
  const HomeIslamicDateHeader({
    super.key,
    required this.userName,
    required this.onTapCalendar,
    this.trailing,
  });

  final String userName;
  final VoidCallback onTapCalendar;
  final Widget? trailing;

  @override
  State<HomeIslamicDateHeader> createState() => _HomeIslamicDateHeaderState();
}

class _HomeIslamicDateHeaderState extends State<HomeIslamicDateHeader> {
  late Map<String, dynamic> _hijriDate;

  @override
  void initState() {
    super.initState();
    _hijriDate = HijriDateService.currentHijriLocal();
    _refreshFromService();
  }

  Future<void> _refreshFromService() async {
    final date = await HijriDateService.getCurrentHijriDate();
    if (!mounted) return;
    setState(() => _hijriDate = date);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final now = DateTime.now();

    final gregorianDate = DateFormat.yMMMMEEEEd(l10n.localeName).format(now);
    final month = _hijriDate['month'] as int?;
    final hijriDateStr =
        '${_hijriDate['day']} ${localizedHijriMonth(l10n, month ?? 0)} ${_hijriDate['year']} ${l10n.hijriYear}';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: InkWell(
            onTap: widget.onTapCalendar,
            borderRadius: BorderRadius.circular(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(
                      Icons.calendar_today_rounded,
                      size: 14,
                      color: colorScheme.primary,
                    ),
                    const SizedBox(width: 6),
                    Flexible(
                      child: Text(
                        hijriDateStr,
                        style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: colorScheme.primary,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.1,
                        ),
                      ),
                    ),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 16,
                      color: colorScheme.primary.withValues(alpha: 0.75),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  gregorianDate,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  l10n.homeSalam,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  widget.userName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    height: 1.15,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (widget.trailing != null) ...[
          SizedBox(width: Spacing.sm),
          widget.trailing!,
        ],
      ],
    );
  }
}
