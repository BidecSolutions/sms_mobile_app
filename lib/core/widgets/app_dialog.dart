/// APP_DIALOG
/// Reusable dialog utility with 3 variants:
///   → AppDialog.confirm() — two buttons for confirming actions
///   → AppDialog.alert()   — one button for important alerts
///   → AppDialog.info()    — one button for general information
///
/// All variants support:
///   → Custom title and message
///   → Custom button labels
///   → Custom icon and icon color
///
/// Usage:
///   AppDialog.confirm(
///     context,
///     title: 'Delete Homework',
///     message: 'Are you sure you want to delete this homework?',
///     confirmLabel: 'Delete',
///     onConfirm: () => cubit.deleteHomework(),
///   );
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_border_radius.dart';
import '../theme/app_spacing.dart';
import '../constants/app_strings.dart';
import 'app_button.dart';

class AppDialog {
  AppDialog._(); // Private constructor — static use only

  // ─── Variants ────────────────────────────────────────────────────────────

  /// Confirm dialog — two buttons (cancel + confirm)
  /// Use for: delete, logout, submit, any destructive or important action
  static Future<bool?> confirm(
      BuildContext context, {
        required String title,
        required String message,
        String? confirmLabel,
        String? cancelLabel,
        Color? confirmColor,
        IconData? icon,
        Color? iconColor,
      }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AppDialogWidget(
        title: title,
        message: message,
        icon: icon ?? Icons.help_outline_rounded,
        iconColor: iconColor ?? AppColors.primary,
        variant: _DialogVariant.confirm,
        confirmLabel: confirmLabel ?? AppStrings.confirm,
        cancelLabel: cancelLabel ?? AppStrings.cancel,
        confirmColor: confirmColor ?? AppColors.primary,
      ),
    );
  }

  /// Alert dialog — one button (ok)
  /// Use for: errors, warnings, important notices
  static Future<void> alert(
      BuildContext context, {
        required String title,
        required String message,
        String? okLabel,
        IconData? icon,
        Color? iconColor,
      }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => _AppDialogWidget(
        title: title,
        message: message,
        icon: icon ?? Icons.warning_amber_rounded,
        iconColor: iconColor ?? AppColors.warning,
        variant: _DialogVariant.alert,
        confirmLabel: okLabel ?? AppStrings.ok,
        confirmColor: AppColors.primary,
      ),
    );
  }

  /// Info dialog — one button (got it)
  /// Use for: tips, instructions, general information
  static Future<void> info(
      BuildContext context, {
        required String title,
        required String message,
        String? okLabel,
        IconData? icon,
      }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (_) => _AppDialogWidget(
        title: title,
        message: message,
        icon: icon ?? Icons.info_outline_rounded,
        iconColor: AppColors.info,
        variant: _DialogVariant.info,
        confirmLabel: okLabel ?? AppStrings.gotIt,
        confirmColor: AppColors.primary,
      ),
    );
  }
}

// ─── Dialog Widget ────────────────────────────────────────────────────────────

class _AppDialogWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final Color iconColor;
  final _DialogVariant variant;
  final String confirmLabel;
  final String? cancelLabel;
  final Color confirmColor;

  const _AppDialogWidget({
    required this.title,
    required this.message,
    required this.icon,
    required this.iconColor,
    required this.variant,
    required this.confirmLabel,
    required this.confirmColor,
    this.cancelLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppBorderRadius.lg),
      ),
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Icon
            Container(
              width: 64.r,
              height: 64.r,
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 32.sp,
                color: iconColor,
              ),
            ),

            SizedBox(height: AppSpacing.md),

            /// Title
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w700,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: AppSpacing.sm),

            /// Message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            SizedBox(height: AppSpacing.lg),

            /// Buttons
            _buildButtons(context),
          ],
        ),
      ),
    );
  }

  // ─── Buttons ─────────────────────────────────────────────────────────────

  Widget _buildButtons(BuildContext context) {
    switch (variant) {
    /// Confirm — cancel + confirm buttons
      case _DialogVariant.confirm:
        return Row(
          children: [
            /// Cancel button
            Expanded(
              child: AppButton.secondary(
                label: cancelLabel ?? AppStrings.cancel,
                onPressed: () => Navigator.of(context).pop(false),
              ),
            ),

            SizedBox(width: AppSpacing.sm),

            /// Confirm button
            Expanded(
              child: AppButton.primary(
                label: confirmLabel,
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ),
          ],
        );

    /// Alert / Info — single ok button
      case _DialogVariant.alert:
      case _DialogVariant.info:
        return AppButton.primary(
          label: confirmLabel,
          onPressed: () => Navigator.of(context).pop(),
        );
    }
  }
}

// ─── Variant Enum ────────────────────────────────────────────────────────────

enum _DialogVariant { confirm, alert, info }