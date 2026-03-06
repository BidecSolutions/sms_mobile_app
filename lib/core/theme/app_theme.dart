/// APP_THEME
/// Defines the complete MaterialTheme for the app.
/// Uses AppColors, AppTextStyles, and AppBorderRadius constants.
/// Applied once in main.dart — affects every widget in the entire app.
/// TODO: Update colors and styles when Figma design is shared.
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_colors.dart';
import 'app_text_styles.dart';
import 'app_border_radius.dart';
import 'app_spacing.dart';

class AppTheme {
  AppTheme._(); // Private constructor — prevents instantiation

  /// Light theme — currently the only theme
  /// Dark theme can be added later if required
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,

      // ─── Color Scheme ──────────────────────────────────────────────────
      /// Defines the core colors used by Material 3 widgets automatically
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        onPrimary: AppColors.surface,
        secondary: AppColors.secondary,
        onSecondary: AppColors.surface,
        error: AppColors.error,
        onError: AppColors.surface,
        surface: AppColors.surface,
        onSurface: AppColors.textPrimary,
      ),

      // ─── Scaffold ──────────────────────────────────────────────────────
      /// Background color for all Scaffold widgets
      scaffoldBackgroundColor: AppColors.background,

      // ─── AppBar ────────────────────────────────────────────────────────
      /// Defines default AppBar styling across all screens
      appBarTheme: AppBarTheme(
        backgroundColor: AppColors.surface,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: AppTextStyles.heading3,
        iconTheme: const IconThemeData(color: AppColors.textPrimary),
        systemOverlayStyle: SystemUiOverlayStyle.dark,
      ),

      // ─── Elevated Button ───────────────────────────────────────────────
      /// Default styling for ElevatedButton widgets
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.surface,
          textStyle: AppTextStyles.button,
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.button,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(double.infinity, 52),
          elevation: 0,
        ),
      ),

      // ─── Text Button ───────────────────────────────────────────────────
      /// Default styling for TextButton widgets
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.primary,
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
        ),
      ),

      // ─── Outlined Button ───────────────────────────────────────────────
      /// Default styling for OutlinedButton widgets
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
          textStyle: AppTextStyles.button.copyWith(color: AppColors.primary),
          shape: RoundedRectangleBorder(
            borderRadius: AppBorderRadius.button,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.xl,
            vertical: AppSpacing.md,
          ),
          minimumSize: const Size(double.infinity, 52),
        ),
      ),

      // ─── Input Decoration ──────────────────────────────────────────────
      /// Default styling for all TextField and TextFormField widgets
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.inputPadding,
          vertical: AppSpacing.inputPadding,
        ),
        hintStyle: AppTextStyles.inputHint,
        labelStyle: AppTextStyles.inputLabel,
        errorStyle: AppTextStyles.error,
        border: OutlineInputBorder(
          borderRadius: AppBorderRadius.input,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.input,
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.input,
          borderSide: const BorderSide(color: AppColors.primary, width: 2),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.input,
          borderSide: const BorderSide(color: AppColors.error),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: AppBorderRadius.input,
          borderSide: const BorderSide(color: AppColors.error, width: 2),
        ),
      ),

      // ─── Card ──────────────────────────────────────────────────────────
      /// Default styling for Card widgets
      cardTheme: CardTheme(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: AppBorderRadius.card,
          side: const BorderSide(color: AppColors.border),
        ),
        margin: const EdgeInsets.all(0),
      ),

      // ─── Divider ───────────────────────────────────────────────────────
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: 1,
      ),

      // ─── Bottom Navigation Bar ─────────────────────────────────────────
      /// Default styling for BottomNavigationBar
      /// Will be updated with role-specific colors from Figma
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        backgroundColor: AppColors.surface,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.textHint,
        elevation: 8,
        type: BottomNavigationBarType.fixed,
      ),

      // ─── Text Theme ────────────────────────────────────────────────────
      /// Maps our custom text styles to Material text theme roles
      textTheme: const TextTheme(
        displayLarge: AppTextStyles.heading1,
        displayMedium: AppTextStyles.heading2,
        displaySmall: AppTextStyles.heading3,
        titleLarge: AppTextStyles.subtitle1,
        titleMedium: AppTextStyles.subtitle2,
        bodyLarge: AppTextStyles.body1,
        bodyMedium: AppTextStyles.body2,
        labelLarge: AppTextStyles.button,
        bodySmall: AppTextStyles.caption,
      ),
    );
  }
}