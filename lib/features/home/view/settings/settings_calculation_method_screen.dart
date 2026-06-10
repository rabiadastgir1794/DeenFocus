import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/user_profile_service.dart';
import '../../../../core/widgets/widgets.dart';
import '../../../onboarding/model/asr_calculation_option.dart';
import '../../../onboarding/model/calculation_method_option.dart';

class SettingsCalculationMethodScreen extends StatelessWidget {
  const SettingsCalculationMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfileService>();
    final colorScheme = Theme.of(context).colorScheme;
    final current = profile.calculationMethod;

    Widget section(String title, List<CalculationMethodOption> methods) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(4, 16, 4, 6),
            child: Text(
              title,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: Column(
              children: [
                for (int i = 0; i < methods.length; i++) ...[
                  if (i > 0)
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  _MethodTile(
                    method: methods[i],
                    selected: methods[i] == current,
                    onTap: () => unawaited(
                      profile.setCalculationMethod(methods[i]),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      );
    }

    return Scaffold(
      appBar: const CustomAppBar(title: 'Calculation Method'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
        children: [
          section('Major Islamic Organizations', const [
            CalculationMethodOption.muslimWorldLeague,
            CalculationMethodOption.northAmerica,
            CalculationMethodOption.egyptian,
            CalculationMethodOption.ummAlQura,
            CalculationMethodOption.karachi,
            CalculationMethodOption.tehran,
          ]),
          section('Middle East', const [
            CalculationMethodOption.kuwait,
            CalculationMethodOption.qatar,
            CalculationMethodOption.dubai,
            CalculationMethodOption.turkey,
          ]),
          section('Asia Pacific', const [
            CalculationMethodOption.singapore,
          ]),
          section('Special Methods', const [
            CalculationMethodOption.moonsightingCommittee,
          ]),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  Icon(
                    Icons.nightlight_round,
                    size: 20,
                    color: colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Shia Prayer Times',
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Use prayer times calculated according to Shia method',
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: colorScheme.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Switch.adaptive(
                    value: current.isShia,
                    onChanged: (on) {
                      unawaited(
                        profile.setCalculationMethod(
                          on
                              ? CalculationMethodOption.tehran
                              : CalculationMethodOption.karachi,
                        ),
                      );
                    },
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

class _MethodTile extends StatelessWidget {
  const _MethodTile({
    required this.method,
    required this.selected,
    required this.onTap,
  });

  final CalculationMethodOption method;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Expanded(
              child: Text(
                method.label,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: selected ? colorScheme.primary : null,
                  fontWeight:
                      selected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ),
            if (selected)
              Icon(
                Icons.check_rounded,
                color: colorScheme.primary,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }
}

class SettingsAsrCalculationScreen extends StatelessWidget {
  const SettingsAsrCalculationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final profile = context.watch<UserProfileService>();
    final colorScheme = Theme.of(context).colorScheme;
    final current = profile.asrMethod;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Asr Calculation'),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
        children: [
          Container(
            decoration: BoxDecoration(
              color: colorScheme.surfaceContainer,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outlineVariant.withValues(alpha: 0.35),
              ),
            ),
            child: Column(
              children: [
                for (final option in AsrCalculationOption.values) ...[
                  if (option != AsrCalculationOption.values.first)
                    Divider(
                      height: 1,
                      thickness: 1,
                      indent: 16,
                      endIndent: 16,
                      color: colorScheme.outlineVariant.withValues(alpha: 0.3),
                    ),
                  InkWell(
                    onTap: () => unawaited(profile.setAsrMethod(option)),
                    borderRadius: BorderRadius.circular(20),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  option.label,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.bodyMedium?.copyWith(
                                    color: option == current
                                        ? colorScheme.primary
                                        : null,
                                    fontWeight: option == current
                                        ? FontWeight.w600
                                        : FontWeight.w400,
                                  ),
                                ),
                                if (option.subtitle.isNotEmpty)
                                  Text(
                                    option.subtitle,
                                    style: Theme.of(
                                      context,
                                    ).textTheme.bodySmall?.copyWith(
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (option == current)
                            Icon(
                              Icons.check_rounded,
                              color: colorScheme.primary,
                              size: 20,
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
