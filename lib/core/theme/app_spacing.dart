/// APP_SPACING
/// Contains all spacing constants used throughout the app.
/// Based on a base-8 grid system — the industry standard for UI design.
/// NEVER hardcode padding/margin/gap values directly in widgets.
/// Always use these constants to ensure consistent spacing.
class AppSpacing {
  AppSpacing._(); // Private constructor — prevents instantiation

  // ─── Base Unit ───────────────────────────────────────────────────────────
  /// Base spacing unit — all values are multiples of this
  static const double base = 8.0;

  // ─── Spacing Scale ───────────────────────────────────────────────────────
  /// 4px — extra small spacing, used for tight gaps between related elements
  static const double xs = 4.0;

  /// 8px — small spacing, used for gaps between closely related elements
  static const double sm = 8.0;

  /// 16px — medium spacing, used for standard padding inside cards/containers
  static const double md = 16.0;

  /// 24px — large spacing, used for section gaps
  static const double lg = 24.0;

  /// 32px — extra large spacing, used for major section separations
  static const double xl = 32.0;

  /// 48px — 2x extra large, used for large screen sections
  static const double xxl = 48.0;

  /// 64px — 3x extra large, used for hero sections
  static const double xxxl = 64.0;

  // ─── Screen Padding ──────────────────────────────────────────────────────
  /// Standard horizontal padding for all screens
  static const double screenHorizontal = 16.0;

  /// Standard vertical padding for all screens
  static const double screenVertical = 24.0;

  // ─── Component Specific ──────────────────────────────────────────────────
  /// Standard padding inside cards
  static const double cardPadding = 16.0;

  /// Standard gap between list items
  static const double listItemGap = 12.0;

  /// Standard padding inside buttons
  static const double buttonPadding = 16.0;

  /// Standard gap between icon and text
  static const double iconTextGap = 8.0;

  /// Standard padding inside input fields
  static const double inputPadding = 16.0;

  /// Standard gap between form fields
  static const double formFieldGap = 16.0;

  /// Bottom navigation bar height
  static const double bottomNavHeight = 60.0;

  /// App bar height
  static const double appBarHeight = 56.0;
}