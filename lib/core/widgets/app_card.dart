/// APP_CARD
/// Reusable card container widget with 3 variants:
///   → AppCard.flat()     — no shadow, subtle border
///   → AppCard.elevated() — soft shadow, no border
///   → AppCard.outlined() — colored border for highlighted cards
///
/// All variants support:
///   → Custom padding
///   → onTap callback
///   → Custom border radius
///   → Full width by default
///
/// Usage:
///   AppCard.elevated(
///     onTap: () => context.push(AppRoutes.subjectDetail),
///     child: SubjectCardContent(),
///   )
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_border_radius.dart';
import '../theme/app_spacing.dart';

class AppCard extends StatelessWidget {
  /// Card content
  final Widget child;

  /// Called when card is tapped
  /// If null — card is not tappable
  final VoidCallback? onTap;

  /// Padding inside the card
  /// Defaults to AppSpacing.md on all sides
  final EdgeInsetsGeometry? padding;

  /// Custom border radius
  /// Defaults to AppBorderRadius.md
  final double borderRadius;

  /// Internal — determines variant
  final _CardVariant _variant;

  /// Optional border color for outlined variant
  final Color? borderColor;

  // ─── Private Constructor ─────────────────────────────────────────────────

  const AppCard._({
    required Widget child,
    required _CardVariant variant,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    Color? borderColor,
  })  : child = child,
        _variant = variant,
        onTap = onTap,
        padding = padding,
        borderRadius = borderRadius ?? AppBorderRadius.md,
        borderColor = borderColor;

  // ─── Named Constructors ──────────────────────────────────────────────────

  /// Flat card — subtle border, no shadow
  /// Use inside lists and dense layouts
  const factory AppCard.flat({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
  }) = _FlatCard;

  /// Elevated card — soft shadow, no border
  /// Use for standalone cards and feature sections
  const factory AppCard.elevated({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
  }) = _ElevatedCard;

  /// Outlined card — colored border
  /// Use for selected, highlighted or active state cards
  const factory AppCard.outlined({
    required Widget child,
    VoidCallback? onTap,
    EdgeInsetsGeometry? padding,
    double? borderRadius,
    Color? borderColor,
  }) = _OutlinedCard;

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(borderRadius),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        splashColor: AppColors.primary.withOpacity(0.05),
        highlightColor: AppColors.primary.withOpacity(0.03),
        child: Ink(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(borderRadius),
            border: _buildBorder(),
            boxShadow: _buildShadow(),
          ),
          child: Padding(
            padding: padding ?? EdgeInsets.all(AppSpacing.md),
            child: child,
          ),
        ),
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  /// Builds border based on variant
  Border? _buildBorder() {
    switch (_variant) {
      case _CardVariant.flat:
        return Border.all(color: AppColors.border, width: 1);
      case _CardVariant.elevated:
        return null;
      case _CardVariant.outlined:
        return Border.all(
          color: borderColor ?? AppColors.primary,
          width: 1.5,
        );
    }
  }

  /// Builds shadow based on variant
  List<BoxShadow>? _buildShadow() {
    switch (_variant) {
      case _CardVariant.flat:
        return null;
      case _CardVariant.elevated:
        return [
          BoxShadow(
            color: AppColors.black.withOpacity(0.06),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: AppColors.black.withOpacity(0.04),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ];
      case _CardVariant.outlined:
        return null;
    }
  }
}

// ─── Variant Enum ────────────────────────────────────────────────────────────

enum _CardVariant { flat, elevated, outlined }

// ─── Variant Implementations ─────────────────────────────────────────────────

class _FlatCard extends AppCard {
  const _FlatCard({
    required super.child,
    super.onTap,
    super.padding,
    super.borderRadius,
  }) : super._(variant: _CardVariant.flat);
}

class _ElevatedCard extends AppCard {
  const _ElevatedCard({
    required super.child,
    super.onTap,
    super.padding,
    super.borderRadius,
  }) : super._(variant: _CardVariant.elevated);
}

class _OutlinedCard extends AppCard {
  const _OutlinedCard({
    required super.child,
    super.onTap,
    super.padding,
    super.borderRadius,
    super.borderColor,
  }) : super._(variant: _CardVariant.outlined);
}