import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class ProductDetailsHeaderSection extends StatelessWidget {
  final String category;
  final String name;
  final double price;
  final double oldPrice;
  final int stockQty;
  final bool inStock;

  const ProductDetailsHeaderSection({
    super.key,
    required this.category,
    required this.name,
    required this.price,
    required this.oldPrice,
    required this.stockQty,
    required this.inStock,
  });

  @override
  Widget build(BuildContext context) {
    final String categoryLabel = category.contains('·')
        ? category
        : '$category · Redragon';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              categoryLabel,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: AppColors.orange,
                ),
                const SizedBox(width: 4),
                Text('4.7', style: AppTextStyles.captionStrong),
                const SizedBox(width: 4),
                Text('(86 تقييم)', style: AppTextStyles.caption),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(name, style: AppTextStyles.headingH2),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: AppTextStyles.priceLarge,
            ),
            Row(
              children: [
                Text(
                  '\$${oldPrice.toStringAsFixed(2)}',
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.textTertiary,
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.orange,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '-20%',
                    style: AppTextStyles.captionStrong.copyWith(
                      color: AppColors.navy900,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: inStock ? AppColors.successBg : AppColors.dangerBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                inStock
                    ? Icons.check_circle_outline_rounded
                    : Icons.error_outline_rounded,
                size: 16,
                color: inStock ? AppColors.success : AppColors.danger,
              ),
              const SizedBox(width: 8),
              Text(
                inStock
                    ? (stockQty <= 5
                          ? 'متوفر · بقي $stockQty قطع فقط من هذا الخيار'
                          : 'متوفر في المخزون')
                    : 'غير متوفر حالياً',
                style: AppTextStyles.captionStrong.copyWith(
                  color: inStock ? AppColors.success : AppColors.danger,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
