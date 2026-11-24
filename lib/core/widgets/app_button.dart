import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_radius.dart';
import '../theme/app_spacing.dart';
import '../theme/app_text_styles.dart';

enum AppButtonType { primary, secondary, outline, ghost, accent }

enum AppButtonSize { large, medium, small }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final AppButtonSize size;
  final IconData? icon;
  final bool isLoading;
  final bool expand;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.type = AppButtonType.primary,
    this.size = AppButtonSize.medium,
    this.icon,
    this.isLoading = false,
    this.expand = false,
  });

  double get _height => switch (size) {
    AppButtonSize.large => 52,
    AppButtonSize.medium => 44,
    AppButtonSize.small => 36,
  };

  double get _horizontalPadding => switch (size) {
    AppButtonSize.large => AppSpacing.xl,
    AppButtonSize.medium => AppSpacing.lg,
    AppButtonSize.small => AppSpacing.md,
  };

  double get _iconSize => switch (size) {
    AppButtonSize.large => 20,
    AppButtonSize.medium => 18,
    AppButtonSize.small => 16,
  };

  TextStyle get _textStyle => switch (size) {
    AppButtonSize.large => AppTextStyles.titleMedium,
    AppButtonSize.medium => AppTextStyles.bodyStrong,
    AppButtonSize.small => AppTextStyles.labelMedium,
  };

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isDisabled = onPressed == null;
    final effectiveOnPressed = (isDisabled || isLoading) ? null : onPressed;

    final (
      Color backgroundColor,
      Color foregroundColor,
      BorderSide borderSide,
    ) = _resolveColors(
      colorScheme: colorScheme,
      isDark: isDark,
      isDisabled: isDisabled,
    );

    final buttonStyle = ButtonStyle(
      backgroundColor: WidgetStateProperty.all(backgroundColor),
      foregroundColor: WidgetStateProperty.all(foregroundColor),
      overlayColor: WidgetStateProperty.resolveWith((states) {
        if (states.contains(WidgetState.pressed)) {
          return type == AppButtonType.primary
              ? AppColors.actionPrimaryPressed.withValues(alpha: 0.25)
              : foregroundColor.withValues(alpha: 0.1);
        }
        return null;
      }),
      elevation: WidgetStateProperty.all(0),
      minimumSize: WidgetStateProperty.all(
        Size(expand ? double.infinity : 0, _height),
      ),
      fixedSize: expand
          ? null
          : WidgetStateProperty.all(Size.fromHeight(_height)),
      padding: WidgetStateProperty.all(
        EdgeInsets.symmetric(horizontal: _horizontalPadding),
      ),
      side: WidgetStateProperty.all(borderSide),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: AppRadius.borderMd),
      ),
      textStyle: WidgetStateProperty.all(_textStyle),
    );

    return SizedBox(
      width: expand ? double.infinity : null,
      height: _height,
      child: FilledButton(
        onPressed: effectiveOnPressed,
        style: buttonStyle,
        child: isLoading
            ? SizedBox(
                width: _iconSize,
                height: _iconSize,
                child: CircularProgressIndicator(
                  strokeWidth: 2.2,
                  valueColor: AlwaysStoppedAnimation<Color>(foregroundColor),
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (icon != null) ...[
                    Icon(icon, size: _iconSize, color: foregroundColor),
                    const SizedBox(width: AppSpacing.sm),
                  ],
                  Flexible(
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: _textStyle.copyWith(color: foregroundColor),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  (Color, Color, BorderSide) _resolveColors({
    required ColorScheme colorScheme,
    required bool isDark,
    required bool isDisabled,
  }) {
    if (isDisabled) {
      return switch (type) {
        AppButtonType.outline => (
          Colors.transparent,
          AppColors.textTertiary,
          const BorderSide(color: AppColors.actionDisabled, width: 1),
        ),
        AppButtonType.ghost => (
          Colors.transparent,
          AppColors.textTertiary,
          BorderSide.none,
        ),
        _ => (
          isDark ? const Color(0xFF334155) : AppColors.actionDisabled,
          isDark ? const Color(0xFF94A3B8) : AppColors.textTertiary,
          BorderSide.none,
        ),
      };
    }

    return switch (type) {
      AppButtonType.primary => (
        AppColors.actionPrimary,
        AppColors.onBrand,
        BorderSide.none,
      ),
      AppButtonType.secondary => (
        isDark ? colorScheme.surface : AppColors.subtle,
        isDark ? AppColors.sky : AppColors.blue,
        BorderSide.none,
      ),
      AppButtonType.outline => (
        Colors.transparent,
        isDark ? const Color(0xFFF8FAFC) : AppColors.textPrimary,
        BorderSide(
          color: isDark ? const Color(0xFF334155) : AppColors.borderStrong,
          width: 1,
        ),
      ),
      AppButtonType.ghost => (
        Colors.transparent,
        isDark ? AppColors.sky : AppColors.blue,
        BorderSide.none,
      ),
      AppButtonType.accent => (
        AppColors.actionAccent,
        AppColors.onAccent,
        BorderSide.none,
      ),
    };
  }
}
