import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../services/support_contact_service.dart';
import '../viewmodel/support_view_model.dart';

/// Full-screen Support Us flow — contributions, fund transparency, and help.
class SupportUsScreen extends StatefulWidget {
  const SupportUsScreen({super.key});

  @override
  State<SupportUsScreen> createState() => _SupportUsScreenState();
}

class _SupportUsScreenState extends State<SupportUsScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final TextEditingController _customAmountController;
  late final TextEditingController _purposeController;
  bool _syncingAmountField = false;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 420),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOutCubic,
    );
    _customAmountController = TextEditingController(
      text: '${SupportViewModel.defaultContributionAmount}',
    );
    _purposeController = TextEditingController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward(from: 0);
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _customAmountController.dispose();
    _purposeController.dispose();
    super.dispose();
  }

  void _syncCustomAmountField(SupportViewModel vm) {
    if (_syncingAmountField) return;
    final text = '${vm.amount}';
    if (_customAmountController.text == text) return;
    _syncingAmountField = true;
    _customAmountController.value = TextEditingValue(
      text: text,
      selection: TextSelection.collapsed(offset: text.length),
    );
    _syncingAmountField = false;
  }

  Future<void> _handleLaunchResult(
    BuildContext context,
    SupportLaunchResult result,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    if (result == SupportLaunchResult.launched) return;
    if (!context.mounted) return;
    final message = switch (result) {
      SupportLaunchResult.unavailable => l10n.supportUsLaunchUnavailable,
      SupportLaunchResult.failed => l10n.supportUsLaunchFailed,
      SupportLaunchResult.launched => '',
    };
    if (message.isEmpty) return;
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  String _formatAmount(int amount) => '\$$amount';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = context.watch<SupportViewModel>();

    _syncCustomAmountField(vm);

    final background = isDark ? colorScheme.surface : AppColors.backgroundLight;
    final cardColor = isDark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
        : colorScheme.surfaceContainerLow;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.35);

    final fundItems = <({IconData icon, String title, String subtitle})>[
      (
        icon: Icons.auto_awesome_outlined,
        title: l10n.supportUsFundFeature1Title,
        subtitle: l10n.supportUsFundFeature1Subtitle,
      ),
      (
        icon: Icons.dns_outlined,
        title: l10n.supportUsFundFeature2Title,
        subtitle: l10n.supportUsFundFeature2Subtitle,
      ),
      (
        icon: Icons.bug_report_outlined,
        title: l10n.supportUsFundFeature3Title,
        subtitle: l10n.supportUsFundFeature3Subtitle,
      ),
      (
        icon: Icons.menu_book_outlined,
        title: l10n.supportUsFundFeature4Title,
        subtitle: l10n.supportUsFundFeature4Subtitle,
      ),
    ];

    return Scaffold(
      backgroundColor: background,
      appBar: CustomAppBar(
        title: l10n.supportUsTitle,
        onBack: () => Navigator.of(context).pop(),
      ),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: ListView(
            padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 28.h),
            children: [
              _SupportHeroCard(l10n: l10n, isDark: isDark),
              SizedBox(height: Spacing.lg.h),
              Text(
                l10n.supportUsFundSection,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: Spacing.sm.h),
              for (var i = 0; i < fundItems.length; i++) ...[
                _SupportFundTile(
                  icon: fundItems[i].icon,
                  title: fundItems[i].title,
                  subtitle: fundItems[i].subtitle,
                  cardColor: cardColor,
                  borderColor: borderColor,
                ),
                if (i != fundItems.length - 1) SizedBox(height: Spacing.sm.h),
              ],
              SizedBox(height: Spacing.lg.h),
              Text(
                l10n.supportUsNeedHelp,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                ),
              ),
              SizedBox(height: Spacing.sm.h),
              Row(
                children: [
                  Expanded(
                    child: _SupportContactButton(
                      icon: Icons.chat_bubble_outline_rounded,
                      label: l10n.supportUsWhatsApp,
                      onTap: vm.isBusy
                          ? null
                          : () async {
                              final result = await vm.openWhatsApp(
                                l10n.supportUsWhatsAppPrefill,
                              );
                              if (!context.mounted) return;
                              await _handleLaunchResult(context, result);
                            },
                      cardColor: cardColor,
                      borderColor: borderColor,
                    ),
                  ),
                  SizedBox(width: Spacing.sm.w),
                  Expanded(
                    child: _SupportContactButton(
                      icon: Icons.email_outlined,
                      label: l10n.supportUsEmailSupport,
                      onTap: vm.isBusy
                          ? null
                          : () async {
                              final result = await vm.openEmail(
                                subject: l10n.supportUsEmailSubject,
                              );
                              if (!context.mounted) return;
                              await _handleLaunchResult(context, result);
                            },
                      cardColor: cardColor,
                      borderColor: borderColor,
                    ),
                  ),
                ],
              ),
              SizedBox(height: Spacing.lg.h),
              _SupportAmountCard(
                l10n: l10n,
                vm: vm,
                isDark: isDark,
                cardColor: cardColor,
                borderColor: borderColor,
                customAmountController: _customAmountController,
                purposeController: _purposeController,
                syncingAmountField: () => _syncingAmountField,
                onSyncFlag: (value) => _syncingAmountField = value,
                formatAmount: _formatAmount,
              ),
              SizedBox(height: Spacing.lg.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_outline_rounded,
                    size: 14.sp,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  SizedBox(width: Spacing.xs.w),
                  Flexible(
                    child: Text(
                      l10n.supportUsOptionalFooter,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Spacing.md.h),
              SizedBox(
                width: double.infinity,
                height: 56.h,
                child: FilledButton.icon(
                  onPressed: vm.isBusy
                      ? null
                      : () async {
                          final result = await vm.submitContribution();
                          if (!context.mounted) return;
                          await _handleLaunchResult(context, result);
                        },
                  icon: vm.isSubmitting
                      ? SizedBox(
                          width: 18.w,
                          height: 18.w,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: colorScheme.onPrimary,
                          ),
                        )
                      : Icon(Icons.favorite_rounded, size: 20.sp),
                  label: Text(
                    l10n.supportUsCta(_formatAmount(vm.amount)),
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  style: FilledButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.r),
                    ),
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

class _SupportHeroCard extends StatelessWidget {
  const _SupportHeroCard({required this.l10n, required this.isDark});

  final AppLocalizations l10n;
  final bool isDark;

  @override
  Widget build(BuildContext context) {
    final gradient = LinearGradient(
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
      colors: isDark
          ? [
              AppColors.primaryContainerDark,
              AppColors.primaryDark.withValues(alpha: 0.85),
            ]
          : [
              AppColors.primary,
              AppColors.primary.withValues(alpha: 0.82),
            ],
    );

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(Spacing.lg.w),
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius: BorderRadius.circular(20.r),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: isDark ? 0.2 : 0.25),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.favorite_rounded,
              color: Colors.white,
              size: 20.sp,
            ),
          ),
          SizedBox(height: Spacing.md.h),
          Text(
            l10n.supportUsHeroTitle,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: Spacing.sm.h),
          Text(
            l10n.supportUsHeroBody,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white.withValues(alpha: 0.92),
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _SupportFundTile extends StatelessWidget {
  const _SupportFundTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.cardColor,
    required this.borderColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color cardColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(Spacing.md.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: borderColor),
      ),
      child: Row(
        children: [
          Container(
            width: 44.w,
            height: 44.w,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12.r),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 22.sp),
          ),
          SizedBox(width: Spacing.md.w),
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
                SizedBox(height: 2.h),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
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

class _SupportContactButton extends StatelessWidget {
  const _SupportContactButton({
    required this.icon,
    required this.label,
    required this.onTap,
    required this.cardColor,
    required this.borderColor,
  });

  final IconData icon;
  final String label;
  final VoidCallback? onTap;
  final Color cardColor;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: cardColor,
      borderRadius: BorderRadius.circular(16.r),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16.r),
        child: Container(
          padding: EdgeInsets.symmetric(
            horizontal: Spacing.sm.w,
            vertical: Spacing.md.h,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: borderColor),
          ),
          child: Column(
            children: [
              Icon(icon, color: colorScheme.primary, size: 22.sp),
              SizedBox(height: Spacing.xs.h),
              Text(
                label,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportAmountCard extends StatelessWidget {
  const _SupportAmountCard({
    required this.l10n,
    required this.vm,
    required this.isDark,
    required this.cardColor,
    required this.borderColor,
    required this.customAmountController,
    required this.purposeController,
    required this.syncingAmountField,
    required this.onSyncFlag,
    required this.formatAmount,
  });

  final AppLocalizations l10n;
  final SupportViewModel vm;
  final bool isDark;
  final Color cardColor;
  final Color borderColor;
  final TextEditingController customAmountController;
  final TextEditingController purposeController;
  final bool Function() syncingAmountField;
  final ValueChanged<bool> onSyncFlag;
  final String Function(int amount) formatAmount;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      padding: EdgeInsets.all(Spacing.lg.w),
      decoration: BoxDecoration(
        color: isDark
            ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.35)
            : AppColors.secondaryContainerLight.withValues(alpha: 0.45),
        borderRadius: BorderRadius.circular(20.r),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            l10n.supportUsChooseAmountTitle,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: Spacing.xs.h),
          Text(
            l10n.supportUsChooseAmountSubtitle,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: Spacing.md.h),
          Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 180),
              child: Text(
                formatAmount(vm.amount),
                key: ValueKey<int>(vm.amount),
                style: Theme.of(context).textTheme.displaySmall?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          SizedBox(height: Spacing.sm.h),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              trackHeight: 4.h,
              thumbShape: RoundSliderThumbShape(enabledThumbRadius: 10.r),
              overlayShape: RoundSliderOverlayShape(overlayRadius: 18.r),
            ),
            child: Slider(
              value: vm.amount.toDouble(),
              min: SupportViewModel.minAmount.toDouble(),
              max: SupportViewModel.maxAmount.toDouble(),
              divisions: SupportViewModel.maxAmount - SupportViewModel.minAmount,
              label: formatAmount(vm.amount),
              onChanged: vm.isBusy ? null : vm.setAmountFromSlider,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                formatAmount(SupportViewModel.minAmount),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                formatAmount(SupportViewModel.maxAmount),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
          SizedBox(height: Spacing.lg.h),
          Text(
            l10n.supportUsCustomAmountLabel,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: Spacing.sm.h),
          AppTextField(
            controller: customAmountController,
            keyboardType: TextInputType.number,
            prefixIcon: Padding(
              padding: EdgeInsets.only(left: Spacing.md.w),
              child: Text(
                '\$',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            onChanged: (value) {
              if (syncingAmountField()) return;
              vm.setAmountFromText(value);
            },
          ),
          SizedBox(height: Spacing.md.h),
          Text(
            l10n.supportUsPurposeLabel,
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
              fontWeight: FontWeight.w600,
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          SizedBox(height: Spacing.sm.h),
          AppTextField(
            controller: purposeController,
            placeholder: l10n.supportUsPurposeHint,
            maxLines: 2,
            onChanged: vm.setPurpose,
          ),
          SizedBox(height: Spacing.xs.h),
          Text(
            l10n.supportUsPurposeNote,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: colorScheme.onSurfaceVariant.withValues(alpha: 0.85),
            ),
          ),
        ],
      ),
    );
  }
}
