import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/checkout/presentation/widgets/order_success/order_success_details_card.dart';

class OrderSuccessPage extends StatelessWidget {
  final String deliveryLabel;
  final double totalAmount;

  const OrderSuccessPage({
    super.key,
    this.deliveryLabel = 'توصيل إلى حلب',
    this.totalAmount = 86.47,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 1. صورة الحقيبة الزرقاء مع الدمج الأبيض
                Image.asset(
                  'assets/images/empty_states/order_success.png',
                  width: 175,
                  height: 175,
                  fit: BoxFit.contain,
                  color: AppColors.surface,
                  colorBlendMode: BlendMode.multiply,
                  errorBuilder: (_, _, _) => const Icon(
                    Icons.check_circle_rounded,
                    size: 90,
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 20),

                // 2. العنوان الرئيسي
                Text(
                  'تم استلام طلبك بنجاح!',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingH2,
                ),
                const SizedBox(height: 6),

                // 3. رقم الطلب بالأزرق
                Text(
                  'رقم الطلب #10482',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyStrong.copyWith(
                    color: AppColors.blue,
                  ),
                ),
                const SizedBox(height: 10),

                // 4. النص التوضيحي لسياسة الإلغاء
                Text(
                  'سنراجع طلبك ونتواصل معك لتأكيده. يمكنك إلغاء الطلب مجاناً طالما حالته «جديد».',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textSecondary,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 24),

                // 5. بطاقة تفاصيل الطلب
                OrderSuccessDetailsCard(
                  deliveryLabel: deliveryLabel,
                  totalAmount: totalAmount,
                ),
                const SizedBox(height: 28),

                // 6. زر "متابعة الطلب" الأزرق العريض
                InkWell(
                  onTap: () => context.go(AppRouter.home),
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
                      'متابعة الطلب',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.onBrand,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // 7. رابط "متابعة التسوق" النصي
                GestureDetector(
                  onTap: () => context.go(AppRouter.home),
                  child: Text(
                    'متابعة التسوق',
                    style: AppTextStyles.bodyStrong.copyWith(
                      color: AppColors.link,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
