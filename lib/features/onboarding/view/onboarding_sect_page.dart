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
  static const Color _primaryGreen = Color(0xFF2E7D5B);
  static const Color _neutralLight = Color(0xFFF4F6F5);
  static const Color _pageBackground = Color(0xFFFAFBFA);
  static const Color _titleColor = Color(0xFF1E2E27);
  static const Color _subtitleColor = Color(0xFF6B7C74);
  static const Color _unselectedTextColor = Color(0xFF1F2D28);
  static const Color _unselectedBorderColor = Color(0xFFE0E5E3);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: _pageBackground,
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: Spacing.lg.w),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: Spacing.xl.h),
            Text(
              AppLocalizations.of(context)!.sectTitle,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 24.sp,
                color: _titleColor,
              ),
            ),
            SizedBox(height: Spacing.sm.h),
            Text(
              AppLocalizations.of(context)!.sectSubtitle,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: _subtitleColor,
                fontSize: 14.sp,
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
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: MediaQuery.of(context).size.width * 0.75,
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24.r),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: EdgeInsets.symmetric(vertical: 18.h, horizontal: 16.w),
              decoration: BoxDecoration(
                color: isSelected ? _primaryGreen : _neutralLight,
                borderRadius: BorderRadius.circular(24.r),
                border: isSelected
                    ? null
                    : Border.all(color: _unselectedBorderColor, width: 1),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
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
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                  color: isSelected ? Colors.white : _unselectedTextColor,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
