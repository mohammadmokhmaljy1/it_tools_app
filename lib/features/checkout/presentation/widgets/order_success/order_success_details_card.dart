import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class OrderSuccessDetailsCard extends StatelessWidget {
  final String deliveryLabel;
  final double totalAmount;

  const OrderSuccessDetailsCard({
    super.key,
    required this.deliveryLabel,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.pageBg,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.borderDefault),
      ),
      child: Column(
        children: [
          _detailRow(label: 'طريقة الاستلام', value: deliveryLabel),
          const SizedBox(height: 12),
          _detailRow(label: 'الدفع', value: 'عند الاستلام'),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('الإجمالي', style: AppTextStyles.bodyStrong),
              Text(
                '\$${totalAmount.toStringAsFixed(2)}',
                style: AppTextStyles.titleLarge,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _detailRow({required String label, required String value}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(value, style: AppTextStyles.bodyStrong),
      ],
    );
  }
}
