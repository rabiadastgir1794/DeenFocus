import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../core/constants/spacing.dart';
import '../../../l10n/app_localizations.dart';
import '../model/sect_option.dart';

class OnboardingSectPage extends StatelessWidget {
  const OnboardingSectPage({
    super.key,
    required this.selectedSect,
    required this.onSectSelected,
  });

  final SectOption? selectedSect;
  final ValueChanged<SectOption?> onSectSelected;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
      child: SingleChildScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Spacing.xl.h),
          Text(
            AppLocalizations.of(context)!.sectTitle,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18.sp,
              color: colorScheme.onSurface,
            ),
          ),
          SizedBox(height: Spacing.sm.h),
          Text(
            AppLocalizations.of(context)!.sectSubtitle,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontSize: 10.5.sp,
            ),
          ),
          SizedBox(height: Spacing.xl.h),
          _buildSectButton(
            context: context,
            label: AppLocalizations.of(context)!.sectSunni,
            isSelected: selectedSect == SectOption.sunni,
            onTap: () => onSectSelected(SectOption.sunni),
          ),
          SizedBox(height: Spacing.md.h),
          _buildSectButton(
            context: context,
            label: AppLocalizations.of(context)!.sectShia,
            isSelected: selectedSect == SectOption.shia,
            onTap: () => onSectSelected(SectOption.shia),
          ),
          SizedBox(height: Spacing.md.h),
          _buildSectButton(
            context: context,
            label: AppLocalizations.of(context)!.sectPreferNotToSay,
            isSelected: selectedSect == SectOption.preferNotToSay,
            onTap: () => onSectSelected(SectOption.preferNotToSay),
          ),
            SizedBox(height: Spacing.lg.h),
          ],
        ),
      ),
    );
  }

  Widget _buildSectButton({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final colorScheme = Theme.of(context).colorScheme;

    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(16.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: isSelected ? colorScheme.primary : colorScheme.surface,
                borderRadius: BorderRadius.circular(16.r),
                border: isSelected
                    ? null
                    : Border.all(color: colorScheme.outlineVariant, width: 1),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: colorScheme.scrim.withValues(alpha: 0.08),
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : null,
              ),
              child: Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected
                      ? colorScheme.onPrimary
                      : colorScheme.onSurface,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
