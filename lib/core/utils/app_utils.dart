/// APP_UTILS
/// Contains general utility helper functions used throughout the app.
/// These are standalone functions that don't belong in extensions or validators.
/// Import this file wherever these helpers are needed.
import 'package:flutter/material.dart';

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

  // ─── Keyboard Helpers ────────────────────────────────────────────────────

  /// Hides the software keyboard
  /// Call this before navigating away from a form screen
  static void hideKeyboard(BuildContext context) {
    FocusScope.of(context).unfocus();
  }

  // ─── Snackbar Helpers ────────────────────────────────────────────────────

  /// Shows a success snackbar with green background
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
        return role.capitalize();
    }
  }
}

/// Private extension used only inside this file
extension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}