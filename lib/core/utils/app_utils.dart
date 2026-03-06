/// APP_UTILS
/// Contains general utility helper functions used throughout the app.
/// These are standalone functions that don't belong in extensions or validators.
/// Import this file wherever these helpers are needed.
///
/// Changes from original:
///   → Removed duplicate hideKeyboard — use context.hideKeyboard() from extensions.dart
///   → Removed private capitalize extension — now imports from extensions.dart
///   → showSuccessSnackbar/showErrorSnackbar will be replaced by app_snackbar.dart
///     but kept here temporarily until app_snackbar.dart is created
///   → getRoleLabel now uses .capitalize getter from extensions.dart
import 'package:flutter/material.dart';
import 'extensions.dart';

class AppUtils {
  AppUtils._(); // Private constructor — prevents instantiation

  // ─── Text Helpers ────────────────────────────────────────────────────────

  /// Extracts initials from a full name
  /// Used for avatar placeholders when no profile image is available
  /// Examples:
  ///   'John Doe'        → 'JD'
  ///   'Muhammad Ali'    → 'MA'
  ///   'John'            → 'J'
  static String getInitials(String name) {
    if (name.trim().isEmpty) return '';
    final parts = name.trim().split(' ');
    if (parts.length == 1) return parts[0][0].toUpperCase();
    return '${parts[0][0]}${parts[parts.length - 1][0]}'.toUpperCase();
  }

  // ─── Language Helpers ────────────────────────────────────────────────────

  /// Detects if a given text contains Arabic characters
  /// Used to automatically set text direction for dynamic content
  /// Example: a student name entered in Arabic should be RTL
  static bool isArabic(String text) {
    final arabicRegex = RegExp(r'[\u0600-\u06FF]');
    return arabicRegex.hasMatch(text);
  }

  /// Returns the correct TextDirection based on content
  /// Used for dynamic text that could be either Arabic or English
  static TextDirection getTextDirection(String text) {
    return isArabic(text) ? TextDirection.rtl : TextDirection.ltr;
  }

  // ─── Color Helpers ───────────────────────────────────────────────────────

  /// Converts a hex color string to a Flutter Color object
  /// Supports both '#FF0000' and 'FF0000' formats
  /// Used when backend returns color values as hex strings
  static Color hexToColor(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  // ─── Snackbar Helpers ────────────────────────────────────────────────────
  /// NOTE: These will be replaced by app_snackbar.dart reusable widget
  /// once core/widgets/ files are created.
  /// Kept here temporarily for use before app_snackbar.dart is ready.

  /// Shows a success snackbar with green background
  /// TODO: Replace with AppSnackbar.showSuccess() once app_snackbar.dart is created
  static void showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Shows an error snackbar with red background
  /// TODO: Replace with AppSnackbar.showError() once app_snackbar.dart is created
  static void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ─── Role Helpers ────────────────────────────────────────────────────────

  /// Returns a human-readable role label from role string
  /// Uses .capitalize getter from extensions.dart
  /// Example: 'student' → 'Student', 'teacher' → 'Teacher'
  static String getRoleLabel(String role) {
    switch (role.toLowerCase()) {
      case 'student':
        return 'Student';
      case 'parent':
        return 'Parent';
      case 'teacher':
        return 'Teacher';
      default:
      /// Falls back to capitalize from extensions.dart
        return role.capitalize;
    }
  }
}