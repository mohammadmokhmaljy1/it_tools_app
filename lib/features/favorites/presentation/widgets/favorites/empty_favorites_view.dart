import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class EmptyFavoritesView extends StatelessWidget {
  const EmptyFavoritesView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. صورة علبة القلب الزرقاء
            Image.asset(
              'assets/images/empty_states/empty_favorites.png',
              width: 170,
              height: 170,
              fit: BoxFit.contain,
              color: AppColors.surface,
              colorBlendMode: BlendMode.multiply,

              errorBuilder: (context, error, stackTrace) => Container(
                width: 120,
                height: 120,
                decoration: const BoxDecoration(
                  color: AppColors.infoBg,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.favorite_border_rounded,
                  size: 56,
                  color: AppColors.blue,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // 2. العنوان الرئيسي
            Text(
              'لا يوجد منتجات مفضلة',
              style: AppTextStyles.bodyLarge.copyWith(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),

            // 3. النص التوضيحي الفرعي
            Text(
              'اضغط على ♡ في أي منتج لحفظه هنا والرجوع إليه لاحقاً.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                fontSize: 13,
                color: AppColors.textTertiary,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),

            // 4. زر تصفّح المنتجات الأزرق
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () => context.go(AppRouter.categories),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.actionPrimary,
                  foregroundColor: AppColors.onBrand,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: Text(
                  'تصفّح المنتجات',
                  style: AppTextStyles.bodyLarge.copyWith(
                    color: AppColors.onBrand,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
