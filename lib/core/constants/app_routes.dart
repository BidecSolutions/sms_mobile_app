/// APP_ROUTES
/// Contains all route path constants used by go_router.
/// Every navigation call in the app must use these constants.
/// Never hardcode a route string directly in any widget or cubit.
class AppRoutes {
  AppRoutes._(); // Private constructor — prevents instantiation

  // ─── Splash ──────────────────────────────────────────────────────────────
  /// Initial screen shown on app launch
  static const String splash = '/';

  // ─── Auth ────────────────────────────────────────────────────────────────
  /// Login screen — shown when no token is found
  static const String login = '/login';

  /// Parent children selection screen
  /// Shown after parent login to select which child to view
  static const String childrenList = '/children-list';

  // ─── Dashboard ───────────────────────────────────────────────────────────
  /// Main dashboard — shown after successful login
  /// Same route for all roles (student, parent, teacher)
  /// Content differs based on role stored in secure storage
  static const String dashboard = '/dashboard';

  // ─── Classes ─────────────────────────────────────────────────────────────
  static const String classes = '/classes';
  static const String classDetail = '/classes/:id';

  // ─── Subjects ────────────────────────────────────────────────────────────
  static const String subjects = '/subjects';
  static const String subjectDetail = '/subjects/:id';

  // ─── Homework ────────────────────────────────────────────────────────────
  static const String homework = '/homework';
  static const String homeworkDetail = '/homework/:id';

  // ─── Live Classes ────────────────────────────────────────────────────────
  static const String liveClasses = '/live-classes';

  // ─── Video ───────────────────────────────────────────────────────────────
  static const String videoPlayer = '/video/:id';

  // ─── Notifications ───────────────────────────────────────────────────────
  static const String notifications = '/notifications';

  // ─── Profile ─────────────────────────────────────────────────────────────
  static const String profile = '/profile';
}