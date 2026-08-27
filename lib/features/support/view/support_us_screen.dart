import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

import '../../../core/constants/spacing.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/widgets.dart';
import '../../../l10n/app_localizations.dart';
import '../model/support_contribution_result.dart';
import '../model/support_impact_item.dart';
import '../services/support_contact_service.dart';
import '../viewmodel/support_view_model.dart';

/// Full-screen Support Us flow — one-time donations, independent of subscriptions.
class SupportUsScreen extends StatefulWidget {
  const SupportUsScreen({super.key});

  @override
  State<SupportUsScreen> createState() => _SupportUsScreenState();
}

class _SupportUsScreenState extends State<SupportUsScreen>
    with SingleTickerProviderStateMixin {
  static const Duration _impactAutoAdvance = Duration(seconds: 3);
  static const Duration _impactAnimDuration = Duration(milliseconds: 380);

  late final AnimationController _fadeController;
  late final Animation<double> _fadeAnimation;
  late final PageController _impactController;
  Timer? _impactAutoTimer;
  int _impactIndex = 0;
  int _impactCount = 0;
  bool _impactAnimating = false;

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
    _impactController = PageController(viewportFraction: 0.72);
    _impactCount = supportImpactItems().length;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fadeController.forward(from: 0);
      _startImpactAutoScroll();
    });
  }

  @override
  void dispose() {
    _impactAutoTimer?.cancel();
    _fadeController.dispose();
    _impactController.dispose();
    super.dispose();
  }

  void _startImpactAutoScroll() {
    _impactAutoTimer?.cancel();
    _impactAutoTimer = Timer.periodic(_impactAutoAdvance, (_) {
      unawaited(_goToNextImpact());
    });
  }

  Future<void> _goToNextImpact() async {
    if (!mounted || _impactAnimating || !_impactController.hasClients) return;
    if (_impactCount <= 1) return;

    final next = (_impactIndex + 1) % _impactCount;
    final wrapping = _impactIndex == _impactCount - 1 && next == 0;

    _impactAnimating = true;
    try {
      if (wrapping) {
        _impactController.jumpToPage(next);
        if (mounted) setState(() => _impactIndex = next);
      } else {
        await _impactController.animateToPage(
          next,
          duration: _impactAnimDuration,
          curve: Curves.easeOutCubic,
        );
      }
    } finally {
      _impactAnimating = false;
    }
  }

  void _onImpactPageChanged(int index) {
    if (_impactIndex == index) return;
    setState(() => _impactIndex = index);
    _startImpactAutoScroll();
  }

  Future<void> _openWhatsAppChat(
    BuildContext context,
    String message,
  ) async {
    final vm = context.read<SupportViewModel>();
    final result = await vm.openWhatsApp(message);
    if (!context.mounted) return;
    await _handleLaunchResult(context, result);
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

  Future<void> _handleContributionResult(
    BuildContext context,
    SupportContributionResult result,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    if (!context.mounted) return;

    switch (result) {
      case SupportContributionResult.cancelled:
      case SupportContributionResult.launchedExternally:
        return;
      case SupportContributionResult.purchased:
        await _showThankYouDialog(context);
        return;
      case SupportContributionResult.pending:
        _showMessage(context, l10n.supportUsPurchasePending);
        return;
      case SupportContributionResult.productUnavailable:
        _showMessage(context, l10n.supportUsProductUnavailable);
        return;
      case SupportContributionResult.launchUnavailable:
        _showMessage(context, l10n.supportUsLaunchUnavailable);
        return;
      case SupportContributionResult.failed:
        _showMessage(context, l10n.supportUsPurchaseFailed);
        return;
    }
  }

  void _showMessage(BuildContext context, String message) {
    ScaffoldMessenger.maybeOf(context)?.showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _showThankYouDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    return showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r),
          ),
          title: Text(l10n.supportUsThankYouTitle),
          content: Text(l10n.supportUsThankYouBody),
          actions: [
            FilledButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              style: FilledButton.styleFrom(
                backgroundColor: colorScheme.primary,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
                ),
              ),
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }

  String _formatAmount(int amount) => '\$$amount';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = context.watch<SupportViewModel>();
    final impactItems = supportImpactItems();

    final background = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = isDark
        ? colorScheme.surfaceContainerHighest.withValues(alpha: 0.4)
        : Colors.white;
    final borderColor = isDark
        ? colorScheme.outlineVariant.withValues(alpha: 0.35)
        : AppColors.outlineVariantLight.withValues(alpha: 0.45);

    final fundItems = <({IconData icon, String title, String subtitle})>[
      (
        icon: Icons.auto_awesome_rounded,
        title: l10n.supportUsFundFeature1Title,
        subtitle: l10n.supportUsFundFeature1Subtitle,
      ),
      (
        icon: Icons.bug_report_outlined,
        title: l10n.supportUsFundFeature2Title,
        subtitle: l10n.supportUsFundFeature2Subtitle,
      ),
      (
        icon: Icons.groups_outlined,
        title: l10n.supportUsFundFeature3Title,
        subtitle: l10n.supportUsFundFeature3Subtitle,
      ),
      (
        icon: Icons.volunteer_activism_outlined,
        title: l10n.supportUsFundFeature4Title,
        subtitle: l10n.supportUsFundFeature4Subtitle,
      ),
    ];

    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: Column(
            children: [
              AppCenteredNavHeader(
                title: l10n.supportUsTitle,
                backLabel: l10n.insightsBack,
                onBack: () => Navigator.of(context).pop(),
              ),
              Expanded(
                child: Stack(
                  children: [
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: 0,
                      height: 140.h,
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _MosqueSkylinePainter(
                            color: colorScheme.primary.withValues(
                              alpha: isDark ? 0.08 : 0.06,
                            ),
                          ),
                        ),
                      ),
                    ),
                    ListView(
                      padding: EdgeInsets.fromLTRB(20.w, 8.h, 20.w, 32.h),
                      children: [
                        _SupportAmountCard(
                          l10n: l10n,
                          vm: vm,
                          cardColor: cardColor,
                          borderColor: borderColor,
                          formatAmount: _formatAmount,
                          onSubmit: () async {
                            final result = await vm.submitContribution();
                            if (!context.mounted) return;
                            await _handleContributionResult(context, result);
                          },
                        ),
                        SizedBox(height: Spacing.xl.h),
                        _SectionHeader(
                          icon: Icons.eco_outlined,
                          title: l10n.supportUsImpactSectionTitle,
                          subtitle: l10n.supportUsImpactSectionSubtitle,
                        ),
                        SizedBox(height: Spacing.md.h),
                        SizedBox(
                          height: 210.h,
                          child: PageView.builder(
                            controller: _impactController,
                            itemCount: impactItems.length,
                            onPageChanged: _onImpactPageChanged,
                            padEnds: false,
                            itemBuilder: (context, index) {
                              final item = impactItems[index];
                              return Padding(
                                padding: EdgeInsets.only(right: 12.w),
                                child: _ImpactCard(
                                  item: item,
                                  title: item.titleBuilder(l10n),
                                ),
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 12.h),
                        _ImpactDots(
                          count: impactItems.length,
                          index: _impactIndex,
                        ),
                        SizedBox(height: Spacing.xl.h),
                        _SectionHeader(
                          icon: Icons.handshake_outlined,
                          title: l10n.supportUsFundSection,
                          subtitle: l10n.supportUsFundSectionSubtitle,
                        ),
                        SizedBox(height: Spacing.md.h),
                        GridView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: fundItems.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 12.h,
                            crossAxisSpacing: 12.w,
                            childAspectRatio: 0.95,
                          ),
                          itemBuilder: (context, index) {
                            final item = fundItems[index];
                            return _FundGridCard(
                              icon: item.icon,
                              title: item.title,
                              subtitle: item.subtitle,
                              cardColor: cardColor,
                              borderColor: borderColor,
                            );
                          },
                        ),
                        SizedBox(height: Spacing.lg.h),
                        _TrustBanner(
                          text: l10n.supportUsTrustBanner,
                          borderColor: borderColor,
                        ),
                        SizedBox(height: Spacing.md.h),
                        Row(
                          children: [
                            Expanded(
                              child: _SupportContactButton(
                                icon: Icons.chat_bubble_outline_rounded,
                                label: l10n.supportUsWhatsApp,
                                onTap: vm.isBusy
                                    ? null
                                    : () => unawaited(
                                        _openWhatsAppChat(
                                          context,
                                          l10n.supportUsWhatsAppPrefill,
                                        ),
                                      ),
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
                                        await _handleLaunchResult(
                                          context,
                                          result,
                                        );
                                      },
                                cardColor: cardColor,
                                borderColor: borderColor,
                              ),
                            ),
                          ],
                        ),
                      ],
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

class _SupportAmountCard extends StatelessWidget {
  const _SupportAmountCard({
    required this.l10n,
    required this.vm,
    required this.cardColor,
    required this.borderColor,
    required this.formatAmount,
    required this.onSubmit,
  });

  final AppLocalizations l10n;
  final SupportViewModel vm;
  final Color cardColor;
  final Color borderColor;
  final String Function(int amount) formatAmount;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final presets = SupportViewModel.presetAmounts;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(18.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(22.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 36.w,
                height: 36.w,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10.r),
                ),
                child: Icon(
                  Icons.card_giftcard_rounded,
                  color: colorScheme.primary,
                  size: 18.sp,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.supportUsChooseAmountTitle,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 2.h),
                    Text(
                      l10n.supportUsChooseAmountSubtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.h),
          Row(
            children: [
              for (var i = 0; i < presets.length; i++) ...[
                if (i > 0) SizedBox(width: 8.w),
                Expanded(
                  child: _AmountChip(
                    label: formatAmount(presets[i]),
                    selected: vm.amount == presets[i],
                    onTap: vm.isBusy ? null : () => vm.selectAmount(presets[i]),
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: 16.h),
          SizedBox(
            width: double.infinity,
            height: 54.h,
            child: FilledButton.icon(
              onPressed: vm.isBusy ? null : onSubmit,
              icon: vm.isSubmitting
                  ? SizedBox(
                      width: 18.w,
                      height: 18.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: colorScheme.onPrimary,
                      ),
                    )
                  : Icon(Icons.favorite_rounded, size: 18.sp),
              label: Text(
                l10n.supportUsCta(formatAmount(vm.amount)),
                style: TextStyle(
                  fontSize: 15.sp,
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
          SizedBox(height: 12.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.lock_outline_rounded,
                size: 14.sp,
                color: colorScheme.onSurfaceVariant,
              ),
              SizedBox(width: 6.w),
              Flexible(
                child: Text(
                  l10n.supportUsSecurePaymentNote,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AmountChip extends StatelessWidget {
  const _AmountChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12.r),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Container(
              height: 48.h,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.outline.withValues(alpha: 0.28),
                  width: selected ? 1.8 : 1,
                ),
                color: selected
                    ? colorScheme.primary.withValues(alpha: 0.06)
                    : Colors.transparent,
              ),
              child: Text(
                label,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: selected
                      ? colorScheme.primary
                      : colorScheme.onSurface,
                  fontWeight: FontWeight.w700,
                  fontSize: 13.sp,
                ),
              ),
            ),
            if (selected)
              Positioned(
                top: -6.h,
                right: -4.w,
                child: Container(
                  width: 18.w,
                  height: 18.w,
                  decoration: BoxDecoration(
                    color: colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    size: 11.sp,
                    color: colorScheme.onPrimary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: colorScheme.primary, size: 20.sp),
        SizedBox(width: 8.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
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
    );
  }
}

class _ImpactCard extends StatelessWidget {
  const _ImpactCard({required this.item, required this.title});

  final SupportImpactItem item;
  final String title;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18.r),
      child: Stack(
        fit: StackFit.expand,
        children: [
          Image.asset(
            item.assetPath,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(
              color: Theme.of(context).colorScheme.primaryContainer,
            ),
          ),
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withValues(alpha: 0.72),
                ],
                stops: const [0.45, 1],
              ),
            ),
          ),
          Positioned(
            left: 12.w,
            right: 12.w,
            bottom: 14.h,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(item.icon, color: Colors.white, size: 18.sp),
                SizedBox(height: 6.h),
                Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    height: 1.25,
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

class _ImpactDots extends StatelessWidget {
  const _ImpactDots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(count, (i) {
        final active = i == index;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          margin: EdgeInsets.symmetric(horizontal: 3.w),
          width: active ? 18.w : 6.w,
          height: 6.h,
          decoration: BoxDecoration(
            color: active
                ? primary
                : Theme.of(context).colorScheme.outline.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(999),
          ),
        );
      }),
    );
  }
}

class _FundGridCard extends StatelessWidget {
  const _FundGridCard({
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
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: cardColor,
        borderRadius: BorderRadius.circular(18.r),
        border: Border.all(color: borderColor),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 36.w,
            height: 36.w,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(10.r),
            ),
            child: Icon(icon, color: colorScheme.primary, size: 18.sp),
          ),
          SizedBox(height: 12.h),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w800,
            ),
          ),
          SizedBox(height: 4.h),
          Expanded(
            child: Text(
              subtitle,
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.35,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TrustBanner extends StatelessWidget {
  const _TrustBanner({required this.text, required this.borderColor});

  final String text;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 12.h),
      decoration: BoxDecoration(
        color: colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: colorScheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.verified_user_outlined,
            size: 16.sp,
            color: colorScheme.primary,
          ),
          SizedBox(width: 8.w),
          Flexible(
            child: Text(
              text,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurface.withValues(alpha: 0.78),
                fontWeight: FontWeight.w600,
              ),
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

class _MosqueSkylinePainter extends CustomPainter {
  _MosqueSkylinePainter({required this.color});

  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path()..moveTo(0, size.height);

    final points = <Offset>[
      Offset(0, size.height * 0.72),
      Offset(size.width * 0.08, size.height * 0.72),
      Offset(size.width * 0.1, size.height * 0.38),
      Offset(size.width * 0.14, size.height * 0.38),
      Offset(size.width * 0.16, size.height * 0.72),
      Offset(size.width * 0.28, size.height * 0.72),
      Offset(size.width * 0.32, size.height * 0.28),
      Offset(size.width * 0.38, size.height * 0.28),
      Offset(size.width * 0.42, size.height * 0.72),
      Offset(size.width * 0.55, size.height * 0.72),
      Offset(size.width * 0.58, size.height * 0.45),
      Offset(size.width * 0.68, size.height * 0.45),
      Offset(size.width * 0.72, size.height * 0.72),
      Offset(size.width * 0.82, size.height * 0.72),
      Offset(size.width * 0.85, size.height * 0.35),
      Offset(size.width * 0.9, size.height * 0.35),
      Offset(size.width * 0.93, size.height * 0.72),
      Offset(size.width, size.height * 0.72),
      Offset(size.width, size.height),
    ];

    for (final p in points) {
      path.lineTo(p.dx, p.dy);
    }
    path.close();
    canvas.drawPath(path, paint);

    // Domes
    canvas.drawCircle(
      Offset(size.width * 0.63, size.height * 0.45),
      size.width * 0.05,
      paint,
    );
    canvas.drawCircle(
      Offset(size.width * 0.35, size.height * 0.3),
      size.width * 0.035,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _MosqueSkylinePainter oldDelegate) =>
      oldDelegate.color != color;
}
