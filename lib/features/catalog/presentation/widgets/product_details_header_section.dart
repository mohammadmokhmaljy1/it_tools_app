import 'package:flutter/material.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/catalog/domain/entities/product_details_entities.dart';
import 'package:it_tools_app/features/catalog/presentation/providers/product_details_providers.dart';

class ProductDetailsHeaderSection extends StatelessWidget {
  final ProductDetailsEntity details;
  final VariantSelectionState selection;

  const ProductDetailsHeaderSection({
    super.key,
    required this.details,
    required this.selection,
  });

  @override
  Widget build(BuildContext context) {
    final variant = selection.selectedVariant;
    final price = variant?.finalPriceUsd ?? 0;
    final oldPrice = variant?.priceUsd ?? price;
    final hasDiscount = variant?.hasDiscount ?? false;
    final discountPercent = variant?.discountPercent ?? 0;
    final stockQty = selection.maxStock;
    final isAvailable = selection.canAddToCart;

    final categoryLabel = details.brandName.isNotEmpty
        ? '${details.categoryName} · ${details.brandName}'
        : details.categoryName;

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
                Text(
                  details.rating.avg.toStringAsFixed(1),
                  style: AppTextStyles.captionStrong,
                ),
                const SizedBox(width: 4),
                Text(
                  '(${details.rating.count} تقييم)',
                  style: AppTextStyles.caption,
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(details.name, style: AppTextStyles.headingH2),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '\$${price.toStringAsFixed(2)}',
              style: AppTextStyles.priceLarge,
            ),
            if (hasDiscount)
              Row(
                children: [
                  Text(
                    '\$${oldPrice.toStringAsFixed(2)}',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textTertiary,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                  if (discountPercent > 0) ...[
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
                        '-$discountPercent%',
                        style: AppTextStyles.captionStrong.copyWith(
                          color: AppColors.navy900,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isAvailable ? AppColors.successBg : AppColors.pageBg,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                isAvailable
                    ? Icons.check_circle_outline_rounded
                    : Icons.cancel_outlined,
                size: 16,
                color: isAvailable ? AppColors.success : AppColors.danger,
              ),
              const SizedBox(width: 8),
              Text(
                isAvailable
                    ? 'متوفر · بقي $stockQty قطع من هذا الخيار'
                    : 'نفدت الكمية من هذا الخيار',
                style: AppTextStyles.captionStrong.copyWith(
                  color: isAvailable ? AppColors.success : AppColors.danger,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
