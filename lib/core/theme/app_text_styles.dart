/// APP_TEXT_STYLES
/// Contains all text style constants used throughout the app.
/// Currently using placeholder styles — will be updated when Figma is shared.
/// NEVER hardcode a TextStyle directly in any widget.
/// Always use these constants to ensure typographic consistency.
///
/// TODO: Update the following when Figma is shared:
///   → Add fontFamily to all styles (e.g. 'Inter', 'Poppins' etc.)
///   → Update font sizes to match Figma specifications
///   → Update font weights to match Figma specifications
///   → Update line heights (height) to match Figma specifications
///   → Update letter spacing where needed
///   → Add fontFamily to pubspec.yaml assets section
import 'package:flutter/material.dart';
import 'app_colors.dart';

class AppTextStyles {
  AppTextStyles._(); // Private constructor — prevents instantiation

  // ─── TODO ─────────────────────────────────────────────────────────────────
  /// Font family placeholder — update when Figma is shared
  /// Example: static const String _fontFamily = 'Inter';
  /// Then add to each TextStyle: fontFamily: _fontFamily
  // static const String _fontFamily = 'YourFontHere';

  // ─── Headings ─────────────────────────────────────────────────────────────

  /// Large heading — used for main screen titles
  /// TODO: Update fontSize, fontWeight, height from Figma
  static const TextStyle heading1 = TextStyle(
    // fontFamily: _fontFamily,
    fontSize: 28,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Medium heading — used for section titles
  /// TODO: Update fontSize, fontWeight, height from Figma
  static const TextStyle heading2 = TextStyle(
    // fontFamily: _fontFamily,
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  /// Small heading — used for card titles, dialog titles
  /// TODO: Update fontSize, fontWeight, height from Figma
  static const TextStyle heading3 = TextStyle(
    // fontFamily: _fontFamily,
    fontSize: 20,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.3,
  );

  // ─── Subtitles ────────────────────────────────────────────────────────────

  /// Large subtitle — used below headings
  /// TODO: Update fontSize, fontWeight, height from Figma
  static const TextStyle subtitle1 = TextStyle(
    // fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.textPrimary,
    height: 1.4,
  );

  /// Small subtitle — used for secondary information
  /// TODO: Update fontSize, fontWeight, height from Figma
  static const TextStyle subtitle2 = TextStyle(
    // fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ─── Body ────────────────────────────────────────────────────────────────

  /// Large body text — used for main content
  /// TODO: Update fontSize, fontWeight, height from Figma
  static const TextStyle body1 = TextStyle(
    // fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Small body text — used for descriptions, secondary content
  /// TODO: Update fontSize, fontWeight, height from Figma
  static const TextStyle body2 = TextStyle(
    // fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.5,
  );

  // ─── Button ──────────────────────────────────────────────────────────────

  /// Button text style
  /// TODO: Update fontSize, fontWeight, letterSpacing from Figma
  static const TextStyle button = TextStyle(
    // fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.surface,
    height: 1.2,
    letterSpacing: 0.5,
  );

  // ─── Caption ─────────────────────────────────────────────────────────────

  /// Small caption — used for timestamps, labels, tags
  /// TODO: Update fontSize, fontWeight, height from Figma
  static const TextStyle caption = TextStyle(
    // fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  /// Small caption bold — used for badges, status labels
  /// TODO: Update fontSize, fontWeight, height from Figma
  static const TextStyle captionBold = TextStyle(
    // fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ─── Input Fields ────────────────────────────────────────────────────────

  /// Input field text style
  /// TODO: Update fontSize, fontWeight, height from Figma
  static const TextStyle input = TextStyle(
    // fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textPrimary,
    height: 1.5,
  );

  /// Input field hint text style
  /// TODO: Update fontSize, fontWeight, height from Figma
  static const TextStyle inputHint = TextStyle(
    // fontFamily: _fontFamily,
    fontSize: 16,
    fontWeight: FontWeight.normal,
    color: AppColors.textHint,
    height: 1.5,
  );

  /// Input field label text style
  /// TODO: Update fontSize, fontWeight, height from Figma
  static const TextStyle inputLabel = TextStyle(
    // fontFamily: _fontFamily,
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.textSecondary,
    height: 1.4,
  );

  // ─── Error ───────────────────────────────────────────────────────────────

  /// Error message text style — used below input fields
  /// TODO: Update fontSize, fontWeight, height from Figma
  static const TextStyle error = TextStyle(
    // fontFamily: _fontFamily,
    fontSize: 12,
    fontWeight: FontWeight.normal,
    color: AppColors.error,
    height: 1.4,
  );
}