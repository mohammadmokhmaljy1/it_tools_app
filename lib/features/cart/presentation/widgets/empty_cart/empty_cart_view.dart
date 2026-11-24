import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class EmptyCartView extends StatelessWidget {
  const EmptyCartView({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // 1. صورة السلة الفارغة مع دمج الخلفية البيضاء
            Image.asset(
              'assets/images/empty_states/empty_cart.png',
              width: 185,
              height: 185,
              fit: BoxFit.contain,
              color: AppColors.surface,
              colorBlendMode: BlendMode.multiply,
              errorBuilder: (_, _, _) => const Icon(
                Icons.shopping_cart_outlined,
                size: 80,
                color: AppColors.blue,
              ),
            ),
            const SizedBox(height: 20),

            // 2. العنوان الرئيسي
            Text(
              'سلّتك فارغة',
              textAlign: TextAlign.center,
              style: AppTextStyles.headingH2,
            ),
            const SizedBox(height: 8),

            // 3. النص التوضيحي
            Text(
              'لم تُضف أي منتج بعد. تصفّح الأقسام واكتشف أحدث الإكسسوارات.',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 28),

            // 4. زر "ابدأ التسوق" الأزرق العريض
            InkWell(
              onTap: () => context.go(AppRouter.categories),
              borderRadius: BorderRadius.circular(14),
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  color: AppColors.actionPrimary,
                  borderRadius: BorderRadius.circular(14),
                ),
                alignment: Alignment.center,
                child: Text(
                  'ابدأ التسوق',
                  style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.onBrand,
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
