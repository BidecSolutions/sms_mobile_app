/// APP_LOADER
/// Reusable loading spinner with 3 size variants:
///   → AppLoader.small()  — inside buttons and small inline areas
///   → AppLoader.medium() — inside cards and list items
///   → AppLoader.large()  — full screen loading overlay
///
/// All variants support:
///   → Custom color (defaults to AppColors.primary)
///   → Consistent sizing via flutter_screenutil
///
/// Usage:
///   AppLoader.small()                    // inside button
///   AppLoader.medium()                   // inside card
///   AppLoader.large()                    // full screen
///   AppLoader.small(color: Colors.white) // white spinner in dark button
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';

class AppLoader extends StatelessWidget {
  /// Size of the spinner
  final double size;

  /// Color of the spinner
  /// Defaults to AppColors.primary
  final Color? color;

  /// Stroke width of the spinner circle
  final double strokeWidth;

  // ─── Private Constructor ─────────────────────────────────────────────────

  const AppLoader._({
    required this.size,
    required this.strokeWidth,
    this.color,
  });

  // ─── Named Constructors ──────────────────────────────────────────────────

  /// Small spinner — use inside buttons and inline areas
  const factory AppLoader.small({Color? color}) = _SmallLoader;

  /// Medium spinner — use inside cards and list items
  const factory AppLoader.medium({Color? color}) = _MediumLoader;

  /// Large spinner — use for full screen loading
  const factory AppLoader.large({Color? color}) = _LargeLoader;

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CircularProgressIndicator(
        strokeWidth: strokeWidth,
        valueColor: AlwaysStoppedAnimation<Color>(
          color ?? AppColors.primary,
        ),
      ),
    );
  }
}

// ─── Full Screen Loader ───────────────────────────────────────────────────────

/// Full screen loading overlay
/// Blocks user interaction while loading
/// Usage:
///   if (state.isLoading) AppLoader.fullScreen()
class AppFullScreenLoader extends StatelessWidget {
  /// Background overlay color
  final Color? backgroundColor;

  const AppFullScreenLoader({super.key, this.backgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: backgroundColor ?? AppColors.black.withOpacity(0.3),
      child: const Center(
        child: AppLoader.large(),
      ),
    );
  }
}

// ─── Variant Enum ────────────────────────────────────────────────────────────

enum _LoaderSize { small, medium, large }

// ─── Variant Implementations ─────────────────────────────────────────────────

class _SmallLoader extends AppLoader {
  const _SmallLoader({super.color})
      : super._(size: 20, strokeWidth: 2.0);
}

class _MediumLoader extends AppLoader {
  const _MediumLoader({super.color})
      : super._(size: 32, strokeWidth: 2.5);
}

class _LargeLoader extends AppLoader {
  const _LargeLoader({super.color})
      : super._(size: 48, strokeWidth: 3.0);
}