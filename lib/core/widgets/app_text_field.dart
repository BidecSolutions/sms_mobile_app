/// APP_TEXT_FIELD
/// Reusable text input widget with 3 variants:
///   → AppTextField.regular()  — standard text input
///   → AppTextField.password() — obscured with show/hide toggle
///   → AppTextField.email()    — email keyboard type
///
/// All variants support:
///   → Validation via validator callback
///   → Prefix and suffix icons
///   → Hint and label text
///   → Enabled/disabled state
///   → Custom keyboard type
///   → Text input controller
///
/// Usage:
///   AppTextField.regular(
///     controller: _usernameController,
///     hint: 'Enter username',
///     validator: Validators.required,
///   )
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';
import '../theme/app_border_radius.dart';
import '../theme/app_spacing.dart';

class AppTextField extends StatefulWidget {
  /// Text editing controller
  final TextEditingController? controller;

  /// Hint text shown when field is empty
  final String? hint;

  /// Label text shown above the field
  final String? label;

  /// Validation function — return error string or null
  final String? Function(String?)? validator;

  /// Prefix icon shown inside field on the left
  final IconData? prefixIcon;

  /// Suffix icon shown inside field on the right
  final IconData? suffixIcon;

  /// Called when suffix icon is tapped
  final VoidCallback? onSuffixTap;

  /// Keyboard type for this field
  final TextInputType keyboardType;

  /// Whether the field is enabled
  final bool enabled;

  /// Called when field value changes
  final ValueChanged<String>? onChanged;

  /// Called when user submits the field
  final VoidCallback? onSubmitted;

  /// Focus node for this field
  final FocusNode? focusNode;

  /// Max number of lines (default 1)
  final int maxLines;

  /// Text input action (next, done, etc.)
  final TextInputAction textInputAction;

  /// Internal — determines variant behavior
  final _TextFieldVariant _variant;

  // ─── Private Constructor ─────────────────────────────────────────────────

  const AppTextField._({
    required _TextFieldVariant variant,
    this.controller,
    this.hint,
    this.label,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.onSuffixTap,
    this.keyboardType = TextInputType.text,
    this.enabled = true,
    this.onChanged,
    this.onSubmitted,
    this.focusNode,
    this.maxLines = 1,
    this.textInputAction = TextInputAction.next,
  }) : _variant = variant;

  // ─── Named Constructors ──────────────────────────────────────────────────

  /// Regular text field — standard input
  /// Use for: name, username, search
  const factory AppTextField.regular({
    TextEditingController? controller,
    String? hint,
    String? label,
    String? Function(String?)? validator,
    IconData? prefixIcon,
    IconData? suffixIcon,
    VoidCallback? onSuffixTap,
    TextInputType keyboardType,
    bool enabled,
    ValueChanged<String>? onChanged,
    VoidCallback? onSubmitted,
    FocusNode? focusNode,
    int maxLines,
    TextInputAction textInputAction,
  }) = _RegularTextField;

  /// Password field — obscured with show/hide toggle
  /// Use for: password, confirm password
  const factory AppTextField.password({
    TextEditingController? controller,
    String? hint,
    String? label,
    String? Function(String?)? validator,
    IconData? prefixIcon,
    bool enabled,
    ValueChanged<String>? onChanged,
    VoidCallback? onSubmitted,
    FocusNode? focusNode,
    TextInputAction textInputAction,
  }) = _PasswordTextField;

  /// Email field — email keyboard + email icon
  /// Use for: email input
  const factory AppTextField.email({
    TextEditingController? controller,
    String? hint,
    String? label,
    String? Function(String?)? validator,
    bool enabled,
    ValueChanged<String>? onChanged,
    VoidCallback? onSubmitted,
    FocusNode? focusNode,
    TextInputAction textInputAction,
  }) = _EmailTextField;

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

// ─── State ───────────────────────────────────────────────────────────────────

class _AppTextFieldState extends State<AppTextField> {
  /// Controls password visibility for password variant
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        /// Label above field
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: AppTextStyles.labelMedium.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: AppSpacing.xs),
        ],

        /// Text field
        TextFormField(
          controller: widget.controller,
          focusNode: widget.focusNode,
          keyboardType: widget.keyboardType,
          obscureText: _isObscured,
          enabled: widget.enabled,
          maxLines: _isObscured ? 1 : widget.maxLines,
          textInputAction: widget.textInputAction,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textPrimary,
          ),
          validator: widget.validator,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted != null
              ? (_) => widget.onSubmitted!()
              : null,
          decoration: InputDecoration(
            hintText: widget.hint,
            hintStyle: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textHint,
            ),

            /// Prefix icon
            prefixIcon: widget.prefixIcon != null
                ? Icon(
              widget.prefixIcon,
              size: 20.sp,
              color: AppColors.textHint,
            )
                : null,

            /// Suffix icon — password toggle or custom
            suffixIcon: _buildSuffixIcon(),

            /// Border styles
            border: _buildBorder(AppColors.border),
            enabledBorder: _buildBorder(AppColors.border),
            focusedBorder: _buildBorder(AppColors.primary),
            errorBorder: _buildBorder(AppColors.error),
            focusedErrorBorder: _buildBorder(AppColors.error),
            disabledBorder: _buildBorder(AppColors.border.withOpacity(0.5)),

            /// Fill
            filled: true,
            fillColor: widget.enabled
                ? AppColors.inputFill
                : AppColors.inputFill.withOpacity(0.5),

            /// Padding inside field
            contentPadding: EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm,
            ),

            /// Error style
            errorStyle: AppTextStyles.bodySmall.copyWith(
              color: AppColors.error,
            ),
          ),
        ),
      ],
    );
  }

  // ─── Helpers ─────────────────────────────────────────────────────────────

  /// Whether text should be obscured
  bool get _isObscured =>
      widget._variant == _TextFieldVariant.password && _obscureText;

  /// Builds suffix icon based on variant
  Widget? _buildSuffixIcon() {
    /// Password variant — show/hide toggle
    if (widget._variant == _TextFieldVariant.password) {
      return IconButton(
        icon: Icon(
          _obscureText ? Icons.visibility_off_outlined : Icons.visibility_outlined,
          size: 20.sp,
          color: AppColors.textHint,
        ),
        onPressed: () => setState(() => _obscureText = !_obscureText),
      );
    }

    /// Custom suffix icon
    if (widget.suffixIcon != null) {
      return IconButton(
        icon: Icon(
          widget.suffixIcon,
          size: 20.sp,
          color: AppColors.textHint,
        ),
        onPressed: widget.onSuffixTap,
      );
    }

    return null;
  }

  /// Builds input border with given color
  OutlineInputBorder _buildBorder(Color color) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppBorderRadius.md),
      borderSide: BorderSide(color: color, width: 1.5),
    );
  }
}

// ─── Variant Enum ────────────────────────────────────────────────────────────

enum _TextFieldVariant { regular, password, email }

// ─── Variant Implementations ─────────────────────────────────────────────────

class _RegularTextField extends AppTextField {
  const _RegularTextField({
    super.controller,
    super.hint,
    super.label,
    super.validator,
    super.prefixIcon,
    super.suffixIcon,
    super.onSuffixTap,
    super.keyboardType = TextInputType.text,
    super.enabled = true,
    super.onChanged,
    super.onSubmitted,
    super.focusNode,
    super.maxLines = 1,
    super.textInputAction = TextInputAction.next,
  }) : super._(variant: _TextFieldVariant.regular);
}

class _PasswordTextField extends AppTextField {
  const _PasswordTextField({
    super.controller,
    super.hint,
    super.label,
    super.validator,
    super.prefixIcon,
    super.enabled = true,
    super.onChanged,
    super.onSubmitted,
    super.focusNode,
    super.textInputAction = TextInputAction.done,
  }) : super._(variant: _TextFieldVariant.password);
}

class _EmailTextField extends AppTextField {
  const _EmailTextField({
    super.controller,
    super.hint,
    super.label,
    super.validator,
    super.enabled = true,
    super.onChanged,
    super.onSubmitted,
    super.focusNode,
    super.textInputAction = TextInputAction.next,
  }) : super._(
    variant: _TextFieldVariant.email,
    keyboardType: TextInputType.emailAddress,
    prefixIcon: Icons.email_outlined,
  );
}