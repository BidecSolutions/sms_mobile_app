/// APP_BADGE
/// Reusable badge widget with 3 variants:
///   → AppBadge.count() — shows a number count
///   → AppBadge.label() — shows a text label
///   → AppBadge.dot()   — shows a small indicator dot
///
/// All variants support:
///   → Custom background color
///   → Custom text color
///
/// Usage:
///   AppBadge.count(count: 5)
///   AppBadge.label(label: 'Pending')
///   AppBadge.dot()
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_border_radius.dart';
import '../theme/app_spacing.dart';

class AppBadge extends StatelessWidget {
  /// Badge background color
  final Color backgroundColor;

  /// Badge text color
  final Color textColor;

  /// Internal — determines variant
  final _BadgeVariant _variant;

  /// Count value — used by count variant
  final int? count;

  /// Label text — used by label variant
  final String? label;

  // ─── Private Constructor ─────────────────────────────────────────────────

  const AppBadge._({
    required _BadgeVariant variant,
    required this.backgroundColor,
    required this.textColor,
    this.count,
    this.label,
  }) : _variant = variant;

  // ─── Named Constructors ──────────────────────────────────────────────────

  /// Count badge — shows a number
  /// Use for: notification count, unread messages, pending items
  /// Shows '99+' when count exceeds 99
  const factory AppBadge.count({
    required int count,
    Color? backgroundColor,
    Color? textColor,
  }) = _CountBadge;

  /// Label badge — shows a text label
  /// Use for: homework status, submission status, role labels
  const factory AppBadge.label({
    required String label,
    Color? backgroundColor,
    Color? textColor,
  }) = _LabelBadge;

  /// Dot badge — small indicator dot
  /// Use for: online status, unread indicator, active state
  const factory AppBadge.dot({
    Color? backgroundColor,
  }) = _DotBadge;

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    switch (_variant) {
      case _BadgeVariant.count:
        return _buildCount();
      case _BadgeVariant.label:
        return _buildLabel();
      case _BadgeVariant.dot:
        return _buildDot();
    }
  }

  // ─── Count Layout ────────────────────────────────────────────────────────

  Widget _buildCount() {
    final displayText = (count ?? 0) > 99 ? '99+' : '${count ?? 0}';
    return Container(
      constraints: BoxConstraints(
        minWidth: 20.r,
        minHeight: 20.r,
      ),
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.xs,
        vertical: 2.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.full),
      ),
      child: Center(
        child: Text(
          displayText,
          style: AppTextStyles.labelSmall.copyWith(
            color: textColor,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ─── Label Layout ────────────────────────────────────────────────────────

  Widget _buildLabel() {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 4.h,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppBorderRadius.full),
      ),
      child: Text(
        label ?? '',
        style: AppTextStyles.labelSmall.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  // ─── Dot Layout ──────────────────────────────────────────────────────────

  Widget _buildDot() {
    return Container(
      width: 10.r,
      height: 10.r,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(
          color: AppColors.surface,
          width: 1.5,
        ),
      ),
    );
  }
}

// ─── Variant Enum ────────────────────────────────────────────────────────────

enum _BadgeVariant { count, label, dot }

// ─── Variant Implementations ─────────────────────────────────────────────────

class _CountBadge extends AppBadge {
  const _CountBadge({
    required int count,
    Color? backgroundColor,
    Color? textColor,
  }) : super._(
    variant: _BadgeVariant.count,
    count: count,
    backgroundColor: backgroundColor ?? AppColors.error,
    textColor: textColor ?? AppColors.white,
  );
}

class _LabelBadge extends AppBadge {
  const _LabelBadge({
    required String label,
    Color? backgroundColor,
    Color? textColor,
  }) : super._(
    variant: _BadgeVariant.label,
    label: label,
    backgroundColor: backgroundColor ?? AppColors.primaryLight,
    textColor: textColor ?? AppColors.primary,
  );
}

class _DotBadge extends AppBadge {
  const _DotBadge({
    Color? backgroundColor,
  }) : super._(
    variant: _BadgeVariant.dot,
    backgroundColor: backgroundColor ?? AppColors.success,
    textColor: AppColors.white,
  );
}