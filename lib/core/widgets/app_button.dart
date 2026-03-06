/// APP_BUTTON
/// Reusable button widget with 3 variants:
///   → AppButton.primary()   — filled background for main actions
///   → AppButton.secondary() — outlined for secondary actions
///   → AppButton.text()      — no background for tertiary actions
///
/// All variants support:
///   → Loading state (shows spinner, disables tap)
///   → Disabled state
///   → Custom width (defaults to full width)
///   → Leading icon
///
/// Usage:
///   AppButton.primary(
///     label: 'Login',
///     onPressed: () => cubit.login(),
///     isLoading: state.isLoading,
///   )
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_border_radius.dart';
import '../theme/app_spacing.dart';
import 'app_loader.dart';

class AppButton extends StatelessWidget {
  /// Button label text
  final String label;

  /// Called when button is tapped
  /// Set to null to disable the button
  final VoidCallback? onPressed;

  /// Shows loading spinner and disables tap when true
  final bool isLoading;

  /// Optional leading icon shown before label
  final IconData? icon;

  /// Custom button width
  /// Defaults to full available width
  final double? width;

  /// Button height
  final double? height;

  /// Internal — determines visual variant
  final _ButtonVariant _variant;

  // ─── Private Constructor ─────────────────────────────────────────────────

  const AppButton._({
    required this.label,
    required _ButtonVariant variant,
    this.onPressed,
    this.isLoading = false,
    this.icon,
    this.width,
    this.height,
  }) : _variant = variant;

  // ─── Named Constructors ──────────────────────────────────────────────────

  /// Primary button — filled background
  /// Use for: Login, Submit, Confirm, Save
  const factory AppButton.primary({
    required String label,
    VoidCallback? onPressed,
    bool isLoading,
    IconData? icon,
    double? width,
    double? height,
  }) = _PrimaryButton;

  /// Secondary button — outlined border
  /// Use for: Cancel, Back, Secondary actions
  const factory AppButton.secondary({
    required String label,
    VoidCallback? onPressed,
    bool isLoading,
    IconData? icon,
    double? width,
    double? height,
  }) = _SecondaryButton;

  /// Text button — no background
  /// Use for: Forgot password, Skip, Tertiary actions
  const factory AppButton.text({
    required String label,
    VoidCallback? onPressed,
    bool isLoading,
    IconData? icon,
    double? width,
    double? height,
  }) = _TextButton;

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: height ?? 52.h,
      child: _buildButton(),
    );
  }

  Widget _buildButton() {
    final isDisabled = onPressed == null || isLoading;

    switch (_variant) {
      case _ButtonVariant.primary:
        return ElevatedButton(
          onPressed: isDisabled ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            disabledBackgroundColor: AppColors.primary.withOpacity(0.5),
            foregroundColor: AppColors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
            elevation: 0,
          ),
          child: _buildChild(
            labelStyle: AppTextStyles.button.copyWith(color: AppColors.white),
            loaderColor: AppColors.white,
          ),
        );

      case _ButtonVariant.secondary:
        return OutlinedButton(
          onPressed: isDisabled ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.primary,
            side: BorderSide(
              color: isDisabled
                  ? AppColors.primary.withOpacity(0.5)
                  : AppColors.primary,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
          ),
          child: _buildChild(
            labelStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
            loaderColor: AppColors.primary,
          ),
        );

      case _ButtonVariant.text:
        return TextButton(
          onPressed: isDisabled ? null : onPressed,
          style: TextButton.styleFrom(
            foregroundColor: AppColors.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(AppBorderRadius.md),
            ),
          ),
          child: _buildChild(
            labelStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
            loaderColor: AppColors.primary,
          ),
        );
    }
  }

  /// Builds button child — either loader or icon+label
  Widget _buildChild({
    required TextStyle labelStyle,
    required Color loaderColor,
  }) {
    if (isLoading) {
      return AppLoader.small(color: loaderColor);
    }

    if (icon != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 20.sp),
          SizedBox(width: AppSpacing.xs),
          Text(label, style: labelStyle),
        ],
      );
    }

    return Text(label, style: labelStyle);
  }
}

// ─── Variant Enum ────────────────────────────────────────────────────────────

enum _ButtonVariant { primary, secondary, text }

// ─── Variant Implementations ─────────────────────────────────────────────────

class _PrimaryButton extends AppButton {
  const _PrimaryButton({
    required super.label,
    super.onPressed,
    super.isLoading = false,
    super.icon,
    super.width,
    super.height,
  }) : super._(variant: _ButtonVariant.primary);
}

class _SecondaryButton extends AppButton {
  const _SecondaryButton({
    required super.label,
    super.onPressed,
    super.isLoading = false,
    super.icon,
    super.width,
    super.height,
  }) : super._(variant: _ButtonVariant.secondary);
}

class _TextButton extends AppButton {
  const _TextButton({
    required super.label,
    super.onPressed,
    super.isLoading = false,
    super.icon,
    super.width,
    super.height,
  }) : super._(variant: _ButtonVariant.text);
}