/// APP_BORDER_RADIUS
/// Contains all border radius constants used throughout the app.
/// Currently using placeholder values — will be updated when Figma is shared.
/// NEVER hardcode BorderRadius values directly in any widget.
/// Always use these constants to ensure consistent corner styling.
import 'package:flutter/material.dart';

class AppBorderRadius {
  AppBorderRadius._(); // Private constructor — prevents instantiation

  // ─── Radius Values ───────────────────────────────────────────────────────
  /// 4px — subtle rounding, used for tags and small chips
  static const double xs = 4.0;

  /// 8px — small rounding, used for input fields
  static const double sm = 8.0;

  /// 12px — medium rounding, used for cards
  static const double md = 12.0;

  /// 16px — large rounding, used for bottom sheets, modals
  static const double lg = 16.0;

  /// 24px — extra large rounding, used for dialogs
  static const double xl = 24.0;

  /// 100px — fully rounded, used for buttons and avatars
  static const double full = 100.0;

  // ─── BorderRadius Objects ────────────────────────────────────────────────
  /// Used for small tags, status badges
  static const BorderRadius tag = BorderRadius.all(Radius.circular(xs));

  /// Used for input fields, text fields
  static const BorderRadius input = BorderRadius.all(Radius.circular(sm));

  /// Used for cards, list items
  static const BorderRadius card = BorderRadius.all(Radius.circular(md));

  /// Used for bottom sheets — only top corners rounded
  static const BorderRadius bottomSheet = BorderRadius.only(
    topLeft: Radius.circular(lg),
    topRight: Radius.circular(lg),
  );

  /// Used for dialogs and modals
  static const BorderRadius dialog = BorderRadius.all(Radius.circular(xl));

  /// Used for buttons — fully rounded pill shape
  static const BorderRadius button = BorderRadius.all(Radius.circular(full));

  /// Used for avatars and circular elements
  static const BorderRadius circular = BorderRadius.all(Radius.circular(full));
}