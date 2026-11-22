import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class CheckoutDeliveryMethodSection extends StatelessWidget {
  final bool isHomeDelivery;
  final ValueChanged<bool> onChanged;

  const CheckoutDeliveryMethodSection({
    super.key,
    required this.isHomeDelivery,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('طريقة الاستلام', style: AppTextStyles.headingH3),
        const SizedBox(height: 12),

        // الخيار 1: استلام من المتجر (مجاناً)
        _optionCard(
          isSelected: !isHomeDelivery,
          icon: Icons.storefront_outlined,
          title: 'استلام من المتجر',
          subtitle: 'الجميلية، حلب · جاهز خلال يوم عمل',
          trailingText: 'مجاناً',
          trailingColor: AppColors.success,
          onTap: () => onChanged(false),
        ),
        const SizedBox(height: 10),

        // الخيار 2: توصيل إلى العنوان ($3.00)
        _optionCard(
          isSelected: isHomeDelivery,
          icon: Icons.local_shipping_outlined,
          title: 'توصيل إلى العنوان',
          subtitle: 'لكل المحافظات السورية · 2-4 أيام عمل',
          trailingText: '\$3.00',
          trailingColor: AppColors.textPrimary,
          onTap: () => onChanged(true),
        ),
      ],
    );
  }

  Widget _optionCard({
    required bool isSelected,
    required IconData icon,
    required String title,
    required String subtitle,
    required String trailingText,
    required Color trailingColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.infoBg : AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.blue : AppColors.borderDefault,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            // 1. دائرة الاختيار (Radio Indicator) على اليمين
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? AppColors.blue : AppColors.surface,
                border: Border.all(
                  color: isSelected ? AppColors.blue : AppColors.borderStrong,
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),

            // 2. مربع الأيقونة
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.surface : AppColors.subtle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                size: 20,
                color: isSelected ? AppColors.blue : AppColors.textSecondary,
              ),
            ),
            const SizedBox(width: 12),

            // 3. العنوان والوصف في الوسط
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.bodyStrong.copyWith(fontSize: 15),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),

            // 4. السعر أو كلمة "مجاناً" على اليسار
            Text(
              trailingText,
              style: AppTextStyles.bodyStrong.copyWith(color: trailingColor),
            ),
          ],
        ),
      ),
    );
  }
}
