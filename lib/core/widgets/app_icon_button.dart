import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';

enum AppIconButtonStyle { filled, subtle, ghost, tinted }

class AppIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onPressed;
  final AppIconButtonStyle style;
  final String? tooltip;
  final double iconSize;

  const AppIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.style = AppIconButtonStyle.subtle,
    this.tooltip,
    this.iconSize = 20,
  });

  static const double buttonDimension = 44;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = onPressed == null;

    final (Color backgroundColor, Color iconColor) = _resolveColors(
      isDark: isDark,
      isDisabled: isDisabled,
    );

    return SizedBox(
      width: buttonDimension,
      height: buttonDimension,
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        padding: EdgeInsets.zero,
        constraints: const BoxConstraints.tightFor(
          width: buttonDimension,
          height: buttonDimension,
        ),
        style: IconButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: iconColor,
          disabledBackgroundColor: backgroundColor,
          disabledForegroundColor: iconColor,
          shape: RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
        ),
        icon: Icon(icon, size: iconSize, color: iconColor),
      ),
    );
  }

  (Color, Color) _resolveColors({
    required bool isDark,
    required bool isDisabled,
  }) {
    if (isDisabled) {
      return switch (style) {
        AppIconButtonStyle.ghost => (
          Colors.transparent,
          AppColors.textTertiary,
        ),
        _ => (
          isDark ? const Color(0xFF334155) : AppColors.actionDisabled,
          isDark ? const Color(0xFF94A3B8) : AppColors.textTertiary,
        ),
      };
    }

    return switch (style) {
      AppIconButtonStyle.filled => (AppColors.actionPrimary, AppColors.onBrand),
      AppIconButtonStyle.subtle => (
        isDark ? const Color(0xFF1E293B) : AppColors.subtle,
        isDark ? const Color(0xFFF8FAFC) : AppColors.textPrimary,
      ),
      AppIconButtonStyle.ghost => (
        Colors.transparent,
        isDark ? const Color(0xFFF8FAFC) : AppColors.textPrimary,
      ),
      AppIconButtonStyle.tinted => (
        isDark ? AppColors.blue.withValues(alpha: 0.2) : AppColors.infoBg,
        isDark ? AppColors.sky : AppColors.blue,
      ),
    };
  }
}
