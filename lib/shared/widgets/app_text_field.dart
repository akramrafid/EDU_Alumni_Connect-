import 'package:flutter/material.dart';

class AppTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? label;
  final String? hint;
  final FormFieldValidator<String>? validator;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextInputType? keyboardType;
  final ValueChanged<String>? onChanged;
  final bool enabled;
  final int? maxLines;
  final int? minLines;

  AppTextField({
    super.key,
    this.controller,
    this.label,
    this.hint,
    this.validator,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.keyboardType,
    this.onChanged,
    this.enabled = true,
    this.maxLines = 1,
    this.minLines,
  });

  // Local state for password visibility toggle, avoiding setState()
  final ValueNotifier<bool> _obscuredNotifier = ValueNotifier<bool>(true);

  @override
  Widget build(BuildContext context) {
    if (!obscureText) {
      return _buildTextFormField(obscureText: false);
    }

    return ValueListenableBuilder<bool>(
      valueListenable: _obscuredNotifier,
      builder: (context, obscured, child) {
        return _buildTextFormField(
          obscureText: obscured,
          suffix: IconButton(
            icon: Icon(
              obscured ? Icons.visibility_off : Icons.visibility,
            ),
            onPressed: () {
              _obscuredNotifier.value = !_obscuredNotifier.value;
            },
          ),
        );
      },
    );
  }

  Widget _buildTextFormField({required bool obscureText, Widget? suffix}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      enabled: enabled,
      maxLines: obscureText ? 1 : maxLines,
      minLines: minLines,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: prefixIcon,
        suffixIcon: suffix ?? suffixIcon,
      ),
    );
  }
}
