import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class CartSummaryCard extends StatelessWidget {
  final bool isCouponApplied;
  final String appliedCouponCode;
  final double subtotal;
  final double offersDiscount;
  final double couponDiscount;
  final double total;

  const CartSummaryCard({
    super.key,
    required this.isCouponApplied,
    required this.appliedCouponCode,
    required this.subtotal,
    required this.offersDiscount,
    required this.couponDiscount,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderDefault),
          ),
          child: Column(
            children: [
              _summaryRow(
                label: 'المجموع الفرعي',
                value: '\$${subtotal.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 10),
              _summaryRow(
                label: 'خصم العروض',
                value: '-\$${offersDiscount.toStringAsFixed(2)}',
                valueColor: AppColors.success,
              ),
              if (isCouponApplied) ...[
                const SizedBox(height: 10),
                _summaryRow(
                  label: 'كوبون $appliedCouponCode',
                  value: '-\$${couponDiscount.toStringAsFixed(2)}',
                  valueColor: AppColors.success,
                ),
              ],
              const SizedBox(height: 10),
              _summaryRow(
                label: 'التوصيل',
                value: 'يُحدد حسب المحافظة',
                valueColor: AppColors.textTertiary,
                valueSize: 13,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: AppColors.borderDefault, height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'الإجمالي',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    '\$${total.toStringAsFixed(2)}',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.infoBg,
            borderRadius: BorderRadius.circular(14),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(
                Icons.monetization_on_outlined,
                size: 20,
                color: AppColors.blue,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'جميع الأسعار بالدولار الأمريكي. يمكنك الدفع عند الاستلام نقداً بالدولار أو بالليرة السورية حسب سعر الصرف المعتمد في المتجر.',
                  style: AppTextStyles.bodyMedium.copyWith(
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: AppColors.royal,
                    height: 1.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _summaryRow({
    required String label,
    required String value,
    Color? valueColor,
    double valueSize = 14,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyMedium.copyWith(
            fontSize: valueSize,
            fontWeight: FontWeight.bold,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
