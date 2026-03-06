/// DATE_FORMATTER
/// Provides localized date and time formatting using the intl package.
/// Supports both English and Arabic (RTL) locales.
/// Use this instead of manual date formatting anywhere in the app.
///
/// Usage:
///   DateFormatter.formatDate(dateTime)
///   DateFormatter.formatTime(dateTime)
///   DateFormatter.formatRelative(dateTime)
import 'package:intl/intl.dart';

class DateFormatter {
  DateFormatter._(); // Private constructor — prevents instantiation

  // ─── Date Formats ────────────────────────────────────────────────────────

  /// Formats as '25 Dec 2024'
  /// Used for: homework due dates, class schedules
  static String formatDate(DateTime date, {String locale = 'en'}) {
    return DateFormat('dd MMM yyyy', locale).format(date);
  }

  /// Formats as 'Monday, 25 Dec 2024'
  /// Used for: detailed schedule views
  static String formatFullDate(DateTime date, {String locale = 'en'}) {
    return DateFormat('EEEE, dd MMM yyyy', locale).format(date);
  }

  /// Formats as '25/12/2024'
  /// Used for: compact date display
  static String formatShortDate(DateTime date, {String locale = 'en'}) {
    return DateFormat('dd/MM/yyyy', locale).format(date);
  }

  // ─── Time Formats ────────────────────────────────────────────────────────

  /// Formats as '09:30 AM'
  /// Used for: class start times, live class times
  static String formatTime(DateTime date, {String locale = 'en'}) {
    return DateFormat('hh:mm a', locale).format(date);
  }

  /// Formats as '09:30'
  /// Used for: compact time display
  static String formatTime24(DateTime date, {String locale = 'en'}) {
    return DateFormat('HH:mm', locale).format(date);
  }

  // ─── DateTime Formats ────────────────────────────────────────────────────

  /// Formats as '25 Dec 2024, 09:30 AM'
  /// Used for: notification timestamps, submission times
  static String formatDateTime(DateTime date, {String locale = 'en'}) {
    return DateFormat('dd MMM yyyy, hh:mm a', locale).format(date);
  }

  // ─── Relative Formats ────────────────────────────────────────────────────

  /// Returns a human-readable relative date string
  /// Examples:
  ///   - 'Just now' (less than 1 minute ago)
  ///   - '5 minutes ago'
  ///   - '2 hours ago'
  ///   - 'Today'
  ///   - 'Yesterday'
  ///   - '25 Dec 2024' (older dates)
  static String formatRelative(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      final minutes = difference.inMinutes;
      return '$minutes ${minutes == 1 ? 'minute' : 'minutes'} ago';
    } else if (difference.inHours < 24) {
      final hours = difference.inHours;
      return '$hours ${hours == 1 ? 'hour' : 'hours'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return formatDate(date);
    }
  }

  // ─── Due Date Helpers ────────────────────────────────────────────────────

  /// Returns formatted due date with urgency indicator
  /// Examples:
  ///   - 'Due Today'
  ///   - 'Due Tomorrow'
  ///   - 'Due in 3 days'
  ///   - 'Due 25 Dec 2024'
  ///   - 'Overdue' (past due date)
  static String formatDueDate(DateTime dueDate) {
    final now = DateTime.now();
    final difference = dueDate.difference(now);

    if (difference.isNegative) {
      return 'Overdue';
    } else if (difference.inDays == 0) {
      return 'Due Today';
    } else if (difference.inDays == 1) {
      return 'Due Tomorrow';
    } else if (difference.inDays <= 7) {
      return 'Due in ${difference.inDays} days';
    } else {
      return 'Due ${formatDate(dueDate)}';
    }
  }

  // ─── Duration Helpers ────────────────────────────────────────────────────

  /// Formats a duration in seconds to 'MM:SS' format
  /// Used for: video progress display
  /// Example: 272 seconds → '04:32'
  static String formatDuration(int seconds) {
    final duration = Duration(seconds: seconds);
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final secs = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }
}