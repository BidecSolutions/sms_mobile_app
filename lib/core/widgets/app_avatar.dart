/// APP_AVATAR
/// Reusable avatar widget with 3 size variants:
///   → AppAvatar.small()  — 32px for list items
///   → AppAvatar.medium() — 48px for cards and headers
///   → AppAvatar.large()  — 80px for profile screens
///
/// Behavior:
///   → Shows network image if imageUrl is provided
///   → Falls back to initials if image fails or no URL given
///   → Initials are extracted from name automatically
///   → Background color is consistent per user (based on name)
///
/// Usage:
///   AppAvatar.medium(
///     name: 'Ahmed Ali',
///     imageUrl: 'https://example.com/avatar.jpg',
///   )
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../utils/app_utils.dart';

class AppAvatar extends StatelessWidget {
  /// User's display name — used to generate initials and background color
  final String name;

  /// Optional network image URL
  /// Falls back to initials if null or fails to load
  final String? imageUrl;

  /// Avatar diameter in logical pixels
  final double size;

  /// Internal font size for initials text
  final double _fontSize;

  // ─── Private Constructor ─────────────────────────────────────────────────

  const AppAvatar._({
    required this.name,
    required this.size,
    required double fontSize,
    this.imageUrl,
  }) : _fontSize = fontSize;

  // ─── Named Constructors ──────────────────────────────────────────────────

  /// Small avatar — 32px
  /// Use inside list items, comments, compact rows
  const factory AppAvatar.small({
    required String name,
    String? imageUrl,
  }) = _SmallAvatar;

  /// Medium avatar — 48px
  /// Use inside cards, section headers, nav bars
  const factory AppAvatar.medium({
    required String name,
    String? imageUrl,
  }) = _MediumAvatar;

  /// Large avatar — 80px
  /// Use on profile screens and account pages
  const factory AppAvatar.large({
    required String name,
    String? imageUrl,
  }) = _LargeAvatar;

  // ─── Build ───────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size.r,
      height: size.r,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(size.r / 2),
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? _buildNetworkImage()
            : _buildInitials(),
      ),
    );
  }

  // ─── Network Image ───────────────────────────────────────────────────────

  /// Shows cached network image
  /// Falls back to initials on error
  Widget _buildNetworkImage() {
    return CachedNetworkImage(
      imageUrl: imageUrl!,
      fit: BoxFit.cover,
      width: size.r,
      height: size.r,

      /// Show initials while image loads
      placeholder: (context, url) => _buildInitials(),

      /// Show initials if image fails
      errorWidget: (context, url, error) => _buildInitials(),
    );
  }

  // ─── Initials ────────────────────────────────────────────────────────────

  /// Shows initials with a colored background
  /// Color is determined by the user's name for consistency
  Widget _buildInitials() {
    return Container(
      width: size.r,
      height: size.r,
      color: _getAvatarColor(name),
      child: Center(
        child: Text(
          AppUtils.getInitials(name),
          style: AppTextStyles.labelMedium.copyWith(
            fontSize: _fontSize.sp,
            color: AppColors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  /// Returns a consistent color based on the user's name
  /// Same name always gets same color — no random colors on rebuild
  Color _getAvatarColor(String name) {
    final colors = [
      AppColors.avatarColor1,
      AppColors.avatarColor2,
      AppColors.avatarColor3,
      AppColors.avatarColor4,
      AppColors.avatarColor5,
    ];

    /// Use name hashCode to pick a consistent color
    final index = name.hashCode.abs() % colors.length;
    return colors[index];
  }
}

// ─── Variant Implementations ─────────────────────────────────────────────────

class _SmallAvatar extends AppAvatar {
  const _SmallAvatar({
    required super.name,
    super.imageUrl,
  }) : super._(size: 32, fontSize: 12);
}

class _MediumAvatar extends AppAvatar {
  const _MediumAvatar({
    required super.name,
    super.imageUrl,
  }) : super._(size: 48, fontSize: 16);
}

class _LargeAvatar extends AppAvatar {
  const _LargeAvatar({
    required super.name,
    super.imageUrl,
  }) : super._(size: 80, fontSize: 24);
}