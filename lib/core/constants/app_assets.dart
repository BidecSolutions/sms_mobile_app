/// APP_ASSETS
/// Contains all asset paths used throughout the app.
/// No asset path should ever be hardcoded directly in a widget.
/// As we add assets to the project, their paths are registered here.
class AppAssets {
  AppAssets._(); // Private constructor — prevents instantiation

  // ─── Images ──────────────────────────────────────────────────────────────
  static const String _imagesPath = 'assets/images';
  static const String logo = '$_imagesPath/logo.png';
  static const String placeholder = '$_imagesPath/placeholder.png';

  // ─── Icons ───────────────────────────────────────────────────────────────
  static const String _iconsPath = 'assets/icons';
  static const String appIcon = '$_iconsPath/app_icon.png';

  // ─── Animations ──────────────────────────────────────────────────────────
  static const String _animationsPath = 'assets/animations';
  static const String loadingAnimation = '$_animationsPath/loading.json';
  static const String emptyAnimation = '$_animationsPath/empty.json';
  static const String errorAnimation = '$_animationsPath/error.json';
  static const String successAnimation = '$_animationsPath/success.json';
}