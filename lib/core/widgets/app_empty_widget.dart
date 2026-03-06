/// APP_EMPTY_WIDGET
/// Reusable empty state widget with 2 variants:
///   → AppEmptyWidget.full()    — full screen empty state
///   → AppEmptyWidget.compact() — compact inline empty state
///
/// Both variants support:
///   → Custom message
///   → Optional action button with callback and label
///   → Custom icon
///
/// Usage:
///   AppEmptyWidget.full(
///     message: 'No homework assigned yet',
///     actionLabel: 'Refresh',
///     onAction: () => cubit.loadHomework(),
///   )
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_spacing.dart';
import 'app_button.dart';

class AppEmptyWidget extends StatelessWidget {
  /// Message to display
  final String message;

  /// Optional action button label
  /// If null — action button is hidden
  final String? actionLabel;

  /// Called when action button is tapped
  final VoidCallback? onAction;

  /// Custom icon — defaults to inbox icon
  final IconData icon;

  /// Internal — determines variant
  final _EmptyVariant _variant;

  // ─── Private Constructor ─────────────────────────────────────────────────

  const AppEmptyWidget._({
    required _EmptyVariant variant,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.icon = Icons.inbox_rounded,
  }) : _variant = variant;

  // ─── Named Constructors ──────────────────────────────────────────────────

  /// Full screen empty state
  /// Use when main content list is empty
  const factory AppEmptyWidget.full({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    IconData icon,
  }) = _FullEmptyWidget;

  /// Compact empty state
  /// Use inside cards or smaller sections
  const factory AppEmptyWidget.compact({
    required String message,
    String? actionLabel,
    VoidCallback? onAction,
    IconData icon,
  }) = _CompactEmptyWidget;

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return _variant == _EmptyVariant.full
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
            /// Empty icon
            Icon(
              icon,
              size: 64.sp,
              color: AppColors.textHint,
            ),

            SizedBox(height: AppSpacing.md),

            /// Message
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),

            /// Action button
            if (actionLabel != null && onAction != null) ...[
              SizedBox(height: AppSpacing.lg),
              AppButton.primary(
                label: actionLabel!,
                onPressed: onAction,
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          /// Empty icon
          Icon(
            icon,
            size: 32.sp,
            color: AppColors.textHint,
          ),

          SizedBox(height: AppSpacing.xs),

          /// Message
          Text(
            message,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
            ),
            textAlign: TextAlign.center,
          ),

          /// Action button
          if (actionLabel != null && onAction != null) ...[
            SizedBox(height: AppSpacing.sm),
            AppButton.text(
              label: actionLabel!,
              onPressed: onAction,
            ),
          ],
        ],
      ),
    );
  }
}

// ─── Variant Enum ────────────────────────────────────────────────────────────

enum _EmptyVariant { full, compact }

// ─── Variant Implementations ─────────────────────────────────────────────────

class _FullEmptyWidget extends AppEmptyWidget {
  const _FullEmptyWidget({
    required super.message,
    super.actionLabel,
    super.onAction,
    super.icon = Icons.inbox_rounded,
  }) : super._(variant: _EmptyVariant.full);
}

class _CompactEmptyWidget extends AppEmptyWidget {
  const _CompactEmptyWidget({
    required super.message,
    super.actionLabel,
    super.onAction,
    super.icon = Icons.inbox_rounded,
  }) : super._(variant: _EmptyVariant.compact);
}