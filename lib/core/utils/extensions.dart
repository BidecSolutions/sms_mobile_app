/// EXTENSIONS
/// Contains all Dart extension methods used throughout the app.
/// Extensions add helper methods to existing types without modifying them.
/// Import this file wherever these helpers are needed.
import 'package:flutter/material.dart';

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

// ─── DateTime Extensions ─────────────────────────────────────────────────────
extension DateTimeExtensions on DateTime {
  /// Formats date as 'DD MMM YYYY'
  /// Example: 25 Dec 2024
  String get formattedDate {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '$day ${months[month - 1]} $year';
  }

  /// Formats time as 'HH:MM AM/PM'
  /// Example: 09:30 AM
  String get formattedTime {
    final hour = this.hour > 12 ? this.hour - 12 : this.hour;
    final minute = this.minute.toString().padLeft(2, '0');
    final period = this.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  /// Formats date and time together
  /// Example: 25 Dec 2024, 09:30 AM
  String get formattedDateTime => '$formattedDate, $formattedTime';

  /// Returns true if the date is today
  bool get isToday {
    final now = DateTime.now();
    return day == now.day && month == now.month && year == now.year;
  }

  /// Returns true if the date is yesterday
  bool get isYesterday {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return day == yesterday.day &&
        month == yesterday.month &&
        year == yesterday.year;
  }

  /// Returns a human-readable relative time
  /// Example: 'Today', 'Yesterday', '25 Dec 2024'
  String get relativeDate {
    if (isToday) return 'Today';
    if (isYesterday) return 'Yesterday';
    return formattedDate;
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
  /// Pops the current route off the navigator
  void pop<T>([T? result]) => Navigator.of(this).pop(result);

  // ── Snackbar ───────────────────────────────────────────────────────────────
  /// Shows a simple snackbar with a message
  void showSnackBar(String message) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  // ── Keyboard ───────────────────────────────────────────────────────────────
  /// Hides the keyboard
  void hideKeyboard() => FocusScope.of(this).unfocus();
}

// ─── Number Extensions ────────────────────────────────────────────────────────
extension NumberExtensions on num {
  /// Converts number to a readable file size string
  /// Example: 1024.toFileSize() → '1 KB'
  String toFileSize() {
    if (this < 1024) return '$this B';
    if (this < 1024 * 1024) return '${(this / 1024).toStringAsFixed(1)} KB';
    if (this < 1024 * 1024 * 1024) {
      return '${(this / (1024 * 1024)).toStringAsFixed(1)} MB';
    }
    return '${(this / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
  }
}