import 'package:flutter/material.dart';
import '../../core/theme/app_spacing.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final bool isSecondary;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.isSecondary = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Color for the spinner should match the context (white for primary filled, primary for outlined secondary)
    final spinnerColor = isSecondary ? theme.colorScheme.primary : theme.colorScheme.onPrimary;

    final buttonContent = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(spinnerColor),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: AppSpacing.sm),
              ],
              Semantics(
                label: label,
                child: Text(
                  label,
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          );

    final VoidCallback? activeOnPressed = isLoading ? null : onPressed;

    Widget button;
    if (isSecondary) {
      button = OutlinedButton(
        onPressed: activeOnPressed,
        child: buttonContent,
      );
    } else {
      button = FilledButton(
        onPressed: activeOnPressed,
        child: buttonContent,
      );
    }

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: button,
      );
    }

    return button;
  }
}
