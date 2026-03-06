/// APP_CONSTANTS
/// Contains general app-wide constants that don't belong in other files.
/// Includes role identifiers, durations, limits, and other app-wide values.
class AppConstants {
  AppConstants._(); // Private constructor — prevents instantiation

  // ─── User Roles ──────────────────────────────────────────────────────────
  /// Role identifiers returned by the API after login
  /// These must match exactly what the backend returns in the login response
  static const String studentRole = 'student';
  static const String parentRole = 'parent';
  static const String teacherRole = 'teacher';

  // ─── Secure Storage Keys ─────────────────────────────────────────────────
  /// Keys used to store/retrieve values from flutter_secure_storage
  /// Centralizing these prevents typo bugs when reading/writing storage
  static const String tokenKey = 'auth_token';
  static const String roleKey = 'user_role';
  static const String userIdKey = 'user_id';
  static const String userNameKey = 'user_name';

  // ─── Splash ──────────────────────────────────────────────────────────────
  /// Duration in seconds the splash screen is shown
  static const int splashDuration = 3;

  // ─── Video ───────────────────────────────────────────────────────────────
  /// How often (in seconds) video progress is saved to the backend
  /// Example: every 10 seconds of watching, we save the position
  static const int videoProgressSaveInterval = 10;

  // ─── Pagination ──────────────────────────────────────────────────────────
  /// Default number of items per page for all paginated lists
  static const int defaultPageSize = 15;

  // ─── Localization ────────────────────────────────────────────────────────
  /// Supported language codes
  static const String englishCode = 'en';
  static const String arabicCode = 'ar';

  // ─── Animation Durations ─────────────────────────────────────────────────
  /// Standard animation duration used across the app
  static const int animationDurationMs = 300;

  /// Slow animation duration for complex transitions
  static const int slowAnimationDurationMs = 500;
}