/// APP_SNACKBAR
/// Reusable snackbar utility with 4 variants:
///   → AppSnackbar.success() — green success message
///   → AppSnackbar.error()   — red error message
///   → AppSnackbar.warning() — amber warning message
///   → AppSnackbar.info()    — blue info message
///
/// Usage:
///   AppSnackbar.success(context, message: 'Homework submitted!');
///   AppSnackbar.error(context, message: 'Failed to load data');
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_border_radius.dart';
import '../theme/app_spacing.dart';

class AppSnackbar {
  AppSnackbar._(); // Private constructor — static use only

  // ─── Variants ────────────────────────────────────────────────────────────

  /// Shows a green success snackbar
  /// Use after: login, submit, save, upload
  static void success(
      BuildContext context, {
        required String message,
        Duration duration = const Duration(seconds: 3),
      }) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.success,
      icon: Icons.check_circle_outline_rounded,
      duration: duration,
    );
  }

  /// Shows a red error snackbar
  /// Use after: failed API call, validation error, network error
  static void error(
      BuildContext context, {
        required String message,
        Duration duration = const Duration(seconds: 4),
      }) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.error,
      icon: Icons.error_outline_rounded,
      duration: duration,
    );
  }

  /// Shows an amber warning snackbar
  /// Use for: attention needed, incomplete action, soft warnings
  static void warning(
      BuildContext context, {
        required String message,
        Duration duration = const Duration(seconds: 3),
      }) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.warning,
      icon: Icons.warning_amber_rounded,
      duration: duration,
    );
  }

  /// Shows a blue info snackbar
  /// Use for: general information, tips, neutral messages
  static void info(
      BuildContext context, {
        required String message,
        Duration duration = const Duration(seconds: 3),
      }) {
    _show(
      context,
      message: message,
      backgroundColor: AppColors.info,
      icon: Icons.info_outline_rounded,
      duration: duration,
    );
  }

  // ─── Core Show ───────────────────────────────────────────────────────────

  /// Core method — builds and shows the snackbar
  static void _show(
      BuildContext context, {
        required String message,
        required Color backgroundColor,
        required IconData icon,
        required Duration duration,
      }) {
    /// Remove any existing snackbar before showing new one
    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        /// Transparent background — we use our own container
        backgroundColor: Colors.transparent,

        /// Remove default padding
        padding: EdgeInsets.zero,

        /// No elevation — our container has its own shadow
        elevation: 0,

        duration: duration,

        /// Snackbar sits above bottom navigation
        behavior: SnackBarBehavior.floating,

        margin: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          bottom: AppSpacing.lg,
        ),

        content: Container(
          padding: EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(AppBorderRadius.md),
            boxShadow: [
              BoxShadow(
                color: backgroundColor.withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              /// Icon
              Icon(
                icon,
                color: AppColors.white,
                size: 22.sp,
              ),

              SizedBox(width: AppSpacing.sm),

              /// Message
              Expanded(
                child: Text(
                  message,
                  style: AppTextStyles.bodySmall.copyWith(
                    color: AppColors.white,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}