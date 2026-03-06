/// APP_ERROR_WIDGET
/// Reusable error state widget with 2 variants:
///   → AppErrorWidget.full()    — full screen error state
///   → AppErrorWidget.compact() — compact inline error state
///
/// Both variants support:
///   → Custom error message
///   → Optional retry button with callback
///   → Custom icon
///
/// Usage:
///   AppErrorWidget.full(
///     message: 'Failed to load homework',
///     onRetry: () => cubit.loadHomework(),
///   )
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import '../constants/app_strings.dart';
import 'app_button.dart';

class AppErrorWidget extends StatelessWidget {
  /// Error message to display
  final String message;

  /// Called when retry button is tapped
  /// If null — retry button is hidden
  final VoidCallback? onRetry;

  /// Custom icon — defaults to error outline icon
  final IconData icon;

  /// Internal — determines variant
  final _ErrorVariant _variant;

  // ─── Private Constructor ─────────────────────────────────────────────────

  const AppErrorWidget._({
    required _ErrorVariant variant,
    required this.message,
    this.onRetry,
    this.icon = Icons.error_outline_rounded,
  }) : _variant = variant;

  // ─── Named Constructors ──────────────────────────────────────────────────

  /// Full screen error — use when main content fails to load
  const factory AppErrorWidget.full({
    required String message,
    VoidCallback? onRetry,
    IconData icon,
  }) = _FullErrorWidget;

  /// Compact error — use inside cards or list items
  const factory AppErrorWidget.compact({
    required String message,
    VoidCallback? onRetry,
    IconData icon,
  }) = _CompactErrorWidget;

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return _variant == _ErrorVariant.full
        ? _buildFull()
        : _buildCompact();
  }

  // ─── Full Layout ─────────────────────────────────────────────────────────

  Widget _buildFull() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            /// Error icon
            Icon(
              icon,
              size: 64.sp,
              color: AppColors.error,
            ),

            SizedBox(height: AppSpacing.md),

            /// Error message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            /// Retry button
            if (onRetry != null) ...[
              SizedBox(height: AppSpacing.lg),
              AppButton.primary(
                label: AppStrings.retry,
                onPressed: onRetry,
                width: 160.w,
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ─── Compact Layout ──────────────────────────────────────────────────────

  Widget _buildCompact() {
    return Padding(
      padding: EdgeInsets.all(AppSpacing.md),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          /// Error icon
          Icon(
            icon,
            size: 20.sp,
            color: AppColors.error,
          ),

          SizedBox(width: AppSpacing.xs),

          /// Error message
          Flexible(
            child: Text(
              message,
              style: AppTextStyles.bodySmall.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),

          /// Retry button
          if (onRetry != null) ...[
            SizedBox(width: AppSpacing.xs),
            AppButton.text(
              label: AppStrings.retry,
              onPressed: onRetry,
              width: 60.w,
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Variant Enum ────────────────────────────────────────────────────────────

enum _ErrorVariant { full, compact }

// ─── Variant Implementations ─────────────────────────────────────────────────

class _FullErrorWidget extends AppErrorWidget {
  const _FullErrorWidget({
    required super.message,
    super.onRetry,
    super.icon = Icons.error_outline_rounded,
  }) : super._(variant: _ErrorVariant.full);
}

class _CompactErrorWidget extends AppErrorWidget {
  const _CompactErrorWidget({
    required super.message,
    super.onRetry,
    super.icon = Icons.error_outline_rounded,
  }) : super._(variant: _ErrorVariant.compact);
}