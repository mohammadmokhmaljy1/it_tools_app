import 'package:flutter/material.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';

class AppTextStyles {
  // Headings & Titles
  static TextStyle headingH1 = const TextStyle(
    fontFamily: 'Cairo',
    fontSize: 24,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle headingH2 = const TextStyle(
    fontFamily: 'Cairo',
    fontSize: 20,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle headingH3 = const TextStyle(
    fontFamily: 'Cairo',
    fontSize: 18,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
  );

  static TextStyle titleLarge = const TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );

  static TextStyle titleMedium = const TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
  );

  // Body Styles
  static TextStyle bodyLarge = const TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16,
    fontWeight: FontWeight.normal, // Regular
    color: AppColors.textPrimary,
  );

  static TextStyle bodyMedium = const TextStyle(
    fontFamily: 'Cairo',
    fontSize: 14,
    fontWeight: FontWeight.normal, // Regular
    color: AppColors.textPrimary,
  );

  static TextStyle bodyStrong = const TextStyle(
    fontFamily: 'Cairo',
    fontSize: 14,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textPrimary,
  );

  // Labels & Captions
  static TextStyle labelMedium = const TextStyle(
    fontFamily: 'Cairo',
    fontSize: 13,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textSecondary,
  );

  static TextStyle caption = const TextStyle(
    fontFamily: 'Cairo',
    fontSize: 12,
    fontWeight: FontWeight.normal, // Regular
    color: AppColors.textTertiary,
  );

  static TextStyle captionStrong = const TextStyle(
    fontFamily: 'Cairo',
    fontSize: 12,
    fontWeight: FontWeight.w600, // SemiBold
    color: AppColors.textSecondary,
  );

  static TextStyle overline = const TextStyle(
    fontFamily: 'Cairo',
    fontSize: 10,
    fontWeight: FontWeight.bold,
    color: AppColors.textTertiary,
  );

  // Price Styles
  static TextStyle priceLarge = const TextStyle(
    fontFamily: 'Cairo',
    fontSize: 22,
    fontWeight: FontWeight.w800, // ExtraBold
    color: AppColors.textPrimary,
  );

  static TextStyle priceMedium = const TextStyle(
    fontFamily: 'Cairo',
    fontSize: 16,
    fontWeight: FontWeight.bold,
    color: AppColors.textPrimary,
  );
}
