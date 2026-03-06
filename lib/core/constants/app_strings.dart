/// APP_STRINGS
/// Contains all static text strings used throughout the app.
/// This ensures no hardcoded strings exist in UI code.
/// As we build each feature, strings will be added here.
/// These will also serve as keys when we add Arabic localization.
class AppStrings {
  AppStrings._(); // Private constructor — prevents instantiation

  // ─── App General ─────────────────────────────────────────────────────────
  static const String appName = 'SMS';
  static const String loading = 'Loading...';
  static const String retry = 'Retry';
  static const String cancel = 'Cancel';
  static const String confirm = 'Confirm';
  static const String save = 'Save';
  static const String edit = 'Edit';
  static const String delete = 'Delete';
  static const String yes = 'Yes';
  static const String no = 'No';
  static const String ok = 'OK';
  static const String back = 'Back';
  static const String next = 'Next';
  static const String done = 'Done';
  static const String search = 'Search';
  static const String noDataFound = 'No data found';
  static const String somethingWentWrong = 'Something went wrong';
  static const String noInternetConnection = 'No internet connection';
  static const String sessionExpired = 'Session expired. Please login again';

// ─── Auth ─────────────────────────────────────────────────────────────────
/// Auth strings will be added when we start the Auth feature
}