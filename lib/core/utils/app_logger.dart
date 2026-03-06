/// APP_LOGGER
/// A wrapper around the logger package for structured, formatted logging.
/// Use this instead of print() anywhere in the app.
/// Logs are color-coded by type and automatically disabled in production.
///
/// Usage:
///   AppLogger.debug('message')   → grey,  for detailed debug info
///   AppLogger.info('message')    → blue,  for general information
///   AppLogger.warning('message') → yellow, for potential issues
///   AppLogger.error('message')   → red,   for errors and exceptions
import 'package:logger/logger.dart';

class AppLogger {
  AppLogger._(); // Private constructor — prevents instantiation

  /// Logger instance with pretty printing enabled
  /// Only shows logs in debug mode — silent in production
  static final Logger _logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2,        // Number of method calls in stack trace
      errorMethodCount: 8,   // Number of method calls for errors
      lineLength: 120,       // Width of log output
      colors: true,          // Colorful log messages
      printEmojis: true,     // Emojis for log level indicators
      dateTimeFormat: DateTimeFormat.onlyTimeAndSinceStart,
    ),
    // Disable logs in production/release mode
    level: Level.debug,
  );

  // ─── Log Methods ─────────────────────────────────────────────────────────

  /// Debug log — for detailed development information
  /// Use during development to trace data flow
  static void debug(dynamic message) {
    _logger.d(message);
  }

  /// Info log — for general information
  /// Use for important app events like navigation, user actions
  static void info(dynamic message) {
    _logger.i(message);
  }

  /// Warning log — for potential issues that are not errors
  /// Use when something unexpected happens but app can continue
  static void warning(dynamic message) {
    _logger.w(message);
  }

  /// Error log — for errors and exceptions
  /// Always pass the actual error object and stack trace when available
  static void error(
      dynamic message, {
        dynamic error,
        StackTrace? stackTrace,
      }) {
    _logger.e(message, error: error, stackTrace: stackTrace);
  }
}