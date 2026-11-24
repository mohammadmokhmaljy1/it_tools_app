import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class ProductSpecsSection extends StatelessWidget {
  final String description;
  final List<Map<String, String>> specs;

  const ProductSpecsSection({
    super.key,
    required this.description,
    required this.specs,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('الوصف', style: AppTextStyles.titleLarge),
        const SizedBox(height: 8),
        Text(
          description,
          style: AppTextStyles.bodyMedium.copyWith(
            color: AppColors.textSecondary,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 20),

        // جدول المواصفات (خط Body/Medium Regular المطابق لـ Figma)
        ClipRRect(
          borderRadius: BorderRadius.circular(14),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.borderDefault),
            ),
            child: Column(
              children: List.generate(specs.length, (index) {
                final spec = specs[index];
                final bool isLast = index == specs.length - 1;
                final bool isEvenRow = index % 2 == 0;
                return Column(
                  children: [
                    Container(
                      color: isEvenRow ? AppColors.pageBg : AppColors.surface,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            spec['label'] ?? '',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                          Text(
                            spec['value'] ?? '',
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (!isLast)
                      const Divider(height: 1, color: AppColors.borderDefault),
                  ],
                );
              }),
            ),
          ),
        ),
        const SizedBox(height: 16),

        // بطاقة تنبيه التقييم (Caption 12px Regular بلون brand/royal)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: AppColors.infoBg,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.subtle),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.star_outline_rounded,
                size: 18,
                color: AppColors.royal,
              ),
              const SizedBox(width: 8),
              Text(
                'يمكنك تقييم المنتج بالنجوم بعد استلام طلبك',
                style: AppTextStyles.caption.copyWith(color: AppColors.royal),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
