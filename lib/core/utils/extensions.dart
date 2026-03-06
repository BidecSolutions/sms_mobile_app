/// EXTENSIONS
/// Contains all Dart extension methods used throughout the app.
/// Extensions add helper methods to existing types without modifying them.
/// Import this file wherever these helpers are needed.
///
/// Changes from original:
///   → Removed duplicate hideKeyboard (kept in app_utils.dart as static method)
///   → Removed basic showSnackBar (app_utils.dart has better typed versions)
///   → Removed duplicate date formatting (date_formatter.dart has proper intl support)
///   → Fixed pop() to use go_router instead of Navigator
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// ─── String Extensions ───────────────────────────────────────────────────────
extension StringExtensions on String {
  /// Returns true if the string is empty after trimming whitespace
  bool get isNullOrEmpty => trim().isEmpty;

  /// Capitalizes the first letter of the string
  /// Example: 'hello world' → 'Hello world'
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1).toLowerCase()}';
  }

  /// Capitalizes the first letter of each word
  /// Example: 'hello world' → 'Hello World'
  String get titleCase {
    if (isEmpty) return this;
    return split(' ').map((word) => word.capitalize).join(' ');
  }

  /// Returns true if the string is a valid email address
  bool get isValidEmail {
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(trim());
  }

  /// Truncates the string to a given length and adds '...' if truncated
  /// Example: 'Hello World'.truncate(5) → 'Hello...'
  String truncate(int maxLength) {
    if (length <= maxLength) return this;
    return '${substring(0, maxLength)}...';
  }
}

// ─── Nullable String Extensions ──────────────────────────────────────────────
extension NullableStringExtensions on String? {
  /// Returns true if the string is null or empty after trimming
  bool get isNullOrEmpty => this == null || this!.trim().isEmpty;

  /// Returns the string or a default value if null or empty
  String orDefault([String defaultValue = '']) {
    return isNullOrEmpty ? defaultValue : this!;
  }
}

// ─── BuildContext Extensions ──────────────────────────────────────────────────
extension BuildContextExtensions on BuildContext {
  // ── Screen Size ────────────────────────────────────────────────────────────
  /// Returns the full screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Returns the full screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Returns true if the device is a tablet (width > 600)
  bool get isTablet => screenWidth > 600;

  // ── Theme ──────────────────────────────────────────────────────────────────
  /// Shortcut to access the current ThemeData
  ThemeData get theme => Theme.of(this);

  /// Shortcut to access the current ColorScheme
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// Shortcut to access the current TextTheme
  TextTheme get textTheme => Theme.of(this).textTheme;

  // ── Navigation ─────────────────────────────────────────────────────────────
  /// Pops the current route using go_router
  /// Use this instead of Navigator.of(context).pop()
  /// Correctly handles go_router's navigation stack
  void pop() => GoRouter.of(this).pop();

/// Navigates to a new route using go_router
/// Cle