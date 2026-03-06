/// APP_COLORS
/// Contains all color constants used throughout the app.
/// Currently using placeholder colors — will be updated when Figma is shared.
/// NEVER hardcode a color value directly in any widget.
/// Always use these constants to ensure consistency across the app.
import 'package:flutter/material.dart';

class AppColors {
  AppColors._(); // Private constructor — prevents instantiation

  // ─── Primary ─────────────────────────────────────────────────────────────
  /// Main brand color — used for primary buttons, active states, key UI elements
  /// TODO: Update with real color from Figma
  static const Color primary = Color(0xFF1A73E8);

  /// Slightly darker shade of primary — used for pressed states
  static const Color primaryDark = Color(0xFF1557B0);

  /// Light tint of primary — used for backgrounds, chips, subtle highlights
  static const Color primaryLight = Color(0xFFE8F0FE);

  // ─── Secondary ───────────────────────────────────────────────────────────
  /// Accent color — used for secondary actions and highlights
  /// TODO: Update with real color from Figma
  static const Color secondary = Color(0xFF34A853);
  static const Color secondaryDark = Color(0xFF1E7E34);
  static const Color secondaryLight = Color(0xFFE6F4EA);

  // ─── Background ──────────────────────────────────────────────────────────
  /// Main app background color
  static const Color background = Color(0xFFF8F9FA);

  /// Card and surface background color
  static const Color surface = Color(0xFFFFFFFF);

  // ─── Text ────────────────────────────────────────────────────────────────
  /// Primary text color — headings, important content
  static const Color textPrimary = Color(0xFF202124);

  /// Secondary text color — subtitles, descriptions
  static const Color textSecondary = Color(0xFF5F6368);

  /// Hint text color — placeholder text in input fields
  static const Color textHint = Color(0xFF9AA0A6);

  /// Disabled text color
  static const Color textDisabled = Color(0xFFBDC1C6);

  // ─── Status Colors ───────────────────────────────────────────────────────
  /// Success state — correct answers, completed tasks
  static const Color success = Color(0xFF34A853);
  static const Color successLight = Color(0xFFE6F4EA);

  /// Error state — validation errors, failed actions
  static const Color error = Color(0xFFEA4335);
  static const Color errorLight = Color(0xFFFCE8E6);

  /// Warning state — pending items, attention needed
  static const Color warning = Color(0xFFFBBC04);
  static const Color warningLight = Color(0xFFFEF7E0);

  /// Info state — general information
  static const Color info = Color(0xFF1A73E8);
  static const Color infoLight = Color(0xFFE8F0FE);

  // ─── Border & Divider ────────────────────────────────────────────────────
  /// Border color for input fields, cards
  static const Color border = Color(0xFFDCDFE4);

  /// Divider line color
  static const Color divider = Color(0xFFE8EAED);

  // ─── Overlay ─────────────────────────────────────────────────────────────
  /// Semi-transparent overlay for modals and dialogs
  static const Color overlay = Color(0x80000000);

  // ─── Role Colors ─────────────────────────────────────────────────────────
  /// Color associated with Student role
  static const Color studentColor = Color(0xFF1A73E8);

  /// Color associated with Parent role
  static const Color parentColor = Color(0xFF34A853);

  /// Color associated with Teacher role
  static const Color teacherColor = Color(0xFFFA7B17);
}