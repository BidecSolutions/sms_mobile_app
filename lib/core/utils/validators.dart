/// VALIDATORS
/// Contains all form field validation functions used throughout the app.
/// Never write validation logic directly inside a widget.
/// Always use these functions to ensure consistent validation rules.
///
/// Usage:
///   TextFormField(validator: Validators.required)
///   TextFormField(validator: Validators.email)
///   TextFormField(validator: Validators.password)
class Validators {
  Validators._(); // Private constructor — prevents instantiation

  // ─── Required ────────────────────────────────────────────────────────────
  /// Validates that a field is not empty
  /// Used for any required field
  static String? required(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  // ─── Email ───────────────────────────────────────────────────────────────
  /// Validates that a field contains a valid email address
  static String? email(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  // ─── Password ────────────────────────────────────────────────────────────
  /// Validates that a password meets minimum requirements
  /// Minimum 8 characters
  static String? password(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters';
    }
    return null;
  }

  // ─── Username ────────────────────────────────────────────────────────────
  /// Validates that a username is not empty
  static String? username(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Username is required';
    }
    if (value.trim().length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  // ─── Phone ───────────────────────────────────────────────────────────────
  /// Validates that a field contains a valid phone number
  static String? phone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Phone number is required';
    }
    final phoneRegex = RegExp(r'^\+?[\d\s-]{8,}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  // ─── Combined ────────────────────────────────────────────────────────────
  /// Accepts either a valid email OR a valid username
  /// Used for login field that accepts both email and username
  static String? emailOrUsername(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email or username is required';
    }
    if (value.trim().length < 3) {
      return 'Please enter a valid email or username';
    }
    return null;
  }
}