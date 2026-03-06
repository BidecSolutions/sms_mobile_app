/// APP_NETWORK_IMAGE
/// Reusable cached network image widget with 3 variants:
///   → AppNetworkImage.rectangular() — sharp corners for banners
///   → AppNetworkImage.rounded()     — rounded corners for cards
///   → AppNetworkImage.circular()    — circular shape for thumbnails
///
/// All variants support:
///   → Shimmer-style loading placeholder
///   → Error fallback icon
///   → Custom width and height
///   → BoxFit control
///
/// Usage:
///   AppNetworkImage.rounded(
///     imageUrl: 'https://example.com/image.jpg',
///     width: double.infinity,
///     height: 180,
///   )
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_border_radius.dart';

class AppNetworkImage extends StatelessWidget {
  /// Network image URL
  final String? imageUrl;

  /// Image width
  final double? width;

  /// Image height
  final double? height;

  /// How the image fits within its bounds
  final BoxFit fit;

  /// Border radius — set per variant
  final BorderRadius borderRadius;

  // ─── Private Constructor ─────────────────────────────────────────────────

  const AppNetworkImage._({
    required this.borderRadius,
    this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
  });

  // ─── Named Constructors ──────────────────────────────────────────────────

  /// Rectangular image — sharp corners
  /// Use for: banners, full-width headers
  const factory AppNetworkImage.rectangular({
    String? imageUrl,
    double? width,
    double? height,
    BoxFit fit,
  }) = _RectangularImage;

  /// Rounded image — rounded corners
  /// Use for: course covers, subject thumbnails, cards
  const factory AppNetworkImage.rounded({
    String? imageUrl,
    double? width,
    double? height,
    BoxFit fit,
  }) = _RoundedImage;

  /// Circular image — fully circular
  /// Use for: thumbnails, small previews
  const factory AppNetworkImage.circular({
    String? imageUrl,
    double? width,
    double? height,
    BoxFit fit,
  }) = _CircularImage;

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: borderRadius,
      child: imageUrl != null && imageUrl!.isNotEmpty
          ? _buildCachedImage()
          : _buildErrorFallback(),
    );
  }

  // ─── Cached Image ────────────────────────────────────────────────────────

  Widget _buildCachedImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      width: width,
      height: height,
      fit: fit,

      /// Loading placeholder — shimmer style
      placeholder: (context, url) => _buildPlaceholder(),

      /// Error fallback
      errorWidget: (context, url, error) => _buildErrorFallback(),
    );
  }

  // ─── Placeholder ─────────────────────────────────────────────────────────

  /// Shimmer-style loading placeholder
  /// Shown while image is loading from network
  Widget _buildPlaceholder() {
    return SizedBox(
      width: width,
      height: height,
      child: const _ShimmerPlaceholder(),
    );
  }

  // ─── Error Fallback ──────────────────────────────────────────────────────

  /// Shown when image URL is null, empty, or fails to load
  Widget _buildErrorFallback() {
    return Container(
      width: width,
      height: height,
      color: AppColors.border,
      child: Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          size: 32.sp,
          color: AppColors.textHint,
        ),
      ),
    );
  }
}

// ─── Shimmer Placeholder ──────────────────────────────────────────────────────

/// Animated shimmer loading placeholder
/// Uses AnimationController for smooth shimmer effect
class _ShimmerPlaceholder extends StatefulWidget {
  const _ShimmerPlaceholder();

  @override
  State<_ShimmerPlaceholder> createState() => _ShimmerPlaceholderState();
}

class _ShimmerPlaceholderState extends State<_ShimmerPlaceholder>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: [
                AppColors.border.withOpacity(_animation.value * 0.5),
                AppColors.border.withOpacity(_animation.value),
                AppColors.border.withOpacity(_animation.value * 0.5),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Variant Enum ────────────────────────────────────────────────────────────

enum _ImageVariant { rectangular, rounded, circular }

// ─── Variant Implementations ─────────────────────────────────────────────────

class _RectangularImage extends AppNetworkImage {
  const _RectangularImage({
    super.imageUrl,
    super.width,
    super.height,
    super.fit = BoxFit.cover,
  }) : super._(borderRadius: BorderRadius.zero);
}

class _RoundedImage extends AppNetworkImage {
  const _RoundedImage({
    super.imageUrl,
    super.width,
    super.height,
    super.fit = BoxFit.cover,
  }) : super._(
    borderRadius: const BorderRadius.all(
      Radius.circular(AppBorderRadius.md),
    ),
  );
}

class _CircularImage extends AppNetworkImage {
  const _CircularImage({
    super.imageUrl,
    super.width,
    super.height,
    super.fit = BoxFit.cover,
  }) : super._(
    borderRadius: const BorderRadius.all(
      Radius.circular(AppBorderRadius.full),
    ),
  );
}