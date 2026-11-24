import 'package:flutter/material.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class OnboardingItemWidget extends StatelessWidget {
  final String imagePath;
  final String title;
  final String description;

  const OnboardingItemWidget({
    super.key,
    required this.imagePath,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // صورة الترحيب ثلاثية الأبعاد
            SizedBox(
              height: 280,
              child: Image.asset(
                imagePath,
                fit: BoxFit.contain,
                color: AppColors.surface,
                colorBlendMode: BlendMode.multiply,
              ),
            ),
            const SizedBox(height: 40),
            // عنوان الصفحة الرئيسي
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTextStyles.headingH1.copyWith(
                color: AppColors.textPrimary,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            // وصف الصفحة الفرعي
            Text(
              description,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
