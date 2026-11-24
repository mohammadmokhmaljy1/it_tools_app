import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class CheckoutPaymentAndSummary extends StatelessWidget {
  final TextEditingController notesController;
  final int totalPieces;
  final double subtotal;
  final double totalDiscount;
  final bool isHomeDelivery;
  final String selectedCity;
  final double deliveryFee;
  final double finalTotal;

  const CheckoutPaymentAndSummary({
    super.key,
    required this.notesController,
    required this.totalPieces,
    required this.subtotal,
    required this.totalDiscount,
    required this.isHomeDelivery,
    required this.selectedCity,
    required this.deliveryFee,
    required this.finalTotal,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 1. قسم طريقة الدفع
        Text('طريقة الدفع', style: AppTextStyles.headingH3),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: AppColors.infoBg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.blue, width: 1.5),
          ),
          child: Row(
            children: [
              Container(
                width: 22,
                height: 22,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.blue,
                ),
                child: Center(
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.surface,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.payments_outlined,
                  size: 20,
                  color: AppColors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'الدفع عند الاستلام',
                      style: AppTextStyles.bodyStrong.copyWith(fontSize: 15),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'نقداً بالدولار أو بالليرة السورية',
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),

        // 2. حقل ملاحظات للطلب (اختياري)
        Text('ملاحظات للطلب (اختياري)', style: AppTextStyles.labelMedium),
        const SizedBox(height: 6),
        TextField(
          controller: notesController,
          style: AppTextStyles.bodyMedium,
          decoration: const InputDecoration(
            hintText: 'الرجاء الاتصال قبل التوصيل',
            prefixIcon: Icon(
              Icons.receipt_long_outlined,
              size: 20,
              color: AppColors.textTertiary,
            ),
          ),
        ),
        const SizedBox(height: 20),

        // 3. بطاقة ملخص الطلب
        Text('ملخص الطلب', style: AppTextStyles.headingH3),
        const SizedBox(height: 12),
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
                label: 'المجموع الفرعي ($totalPieces قطع)',
                value: '\$${subtotal.toStringAsFixed(2)}',
              ),
              const SizedBox(height: 10),
              _summaryRow(
                label: 'الخصومات',
                value: '-\$${totalDiscount.toStringAsFixed(2)}',
                valueColor: AppColors.success,
              ),
              const SizedBox(height: 10),
              _summaryRow(
                label: isHomeDelivery
                    ? 'رسوم التوصيل ($selectedCity)'
                    : 'رسوم التوصيل (استلام من المتجر)',
                value: isHomeDelivery
                    ? '\$${deliveryFee.toStringAsFixed(2)}'
                    : 'مجاناً',
                valueColor: isHomeDelivery
                    ? AppColors.textPrimary
                    : AppColors.success,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 12),
                child: Divider(color: AppColors.borderDefault, height: 1),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('الإجمالي', style: AppTextStyles.titleLarge),
                  Text(
                    '\$${finalTotal.toStringAsFixed(2)}',
                    style: AppTextStyles.headingH3.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),

        // 4. تنبيه سياسة الإلغاء
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
                Icons.info_outline_rounded,
                size: 20,
                color: AppColors.blue,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'بالضغط على «تأكيد الطلب» توافق على سياسة الإلغاء: يمكنك الإلغاء مجاناً طالما الطلب «جديد»، وبعد التأكيد يُرسل طلب إلغاء للإدارة.',
                  style: AppTextStyles.caption.copyWith(
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
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        Text(
          value,
          style: AppTextStyles.bodyStrong.copyWith(
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
