import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/home/presentation/widgets/products/product_card_image_section.dart';

class ProductCard extends StatelessWidget {
  final String title;
  final String category;
  final String price;
  final String? oldPrice;
  final String imageUrl;
  final String rating;
  final String reviewsCount;
  final String? discount;
  final bool isOutOfStock;
  final VoidCallback onAddToCart;
  final VoidCallback onFavoriteToggle;
  final bool isFavorite;

  const ProductCard({
    super.key,
    required this.title,
    required this.category,
    required this.price,
    this.oldPrice,
    required this.imageUrl,
    this.rating = '4.8',
    this.reviewsCount = '128',
    this.discount,
    this.isOutOfStock = false,
    required this.onAddToCart,
    required this.onFavoriteToggle,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final double numericPrice =
        double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 38.0;
    final double numericOldPrice = oldPrice != null
        ? (double.tryParse(oldPrice!.replaceAll(RegExp(r'[^0-9.]'), '')) ??
              numericPrice)
        : numericPrice;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GestureDetector(
        onTap: () {
          context.push(
            AppRouter.productDetails,
            extra: {
              'name': title,
              'category': category,
              'price': numericPrice,
              'oldPrice': numericOldPrice,
              'image': imageUrl,
            },
          );
        },
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.borderDefault, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ProductCardImageSection(
                imageUrl: imageUrl,
                discount: discount,
                isOutOfStock: isOutOfStock,
                isFavorite: isFavorite,
                onFavoriteToggle: onFavoriteToggle,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textTertiary,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        title,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: isOutOfStock
                              ? AppColors.textSecondary
                              : AppColors.textPrimary,
                          fontWeight: FontWeight.bold,
                          fontSize: 13.5,
                          height: 1.35,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          const Icon(
                            Icons.star_rounded,
                            size: 14,
                            color: AppColors.orange,
                          ),
                          const SizedBox(width: 2),
                          Text(
                            rating,
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.textPrimary,
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '($reviewsCount)',
                            style: AppTextStyles.labelMedium.copyWith(
                              color: AppColors.textTertiary,
                              fontSize: 11,
                            ),
                          ),
                        ],
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                price,
                                style: AppTextStyles.titleMedium.copyWith(
                                  color: isOutOfStock
                                      ? AppColors.textTertiary
                                      : AppColors.textPrimary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                              if (oldPrice != null)
                                Text(
                                  oldPrice!,
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: AppColors.textTertiary,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 11,
                                  ),
                                ),
                            ],
                          ),
                          GestureDetector(
                            onTap: isOutOfStock ? null : onAddToCart,
                            child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: isOutOfStock
                                    ? AppColors.borderDefault
                                    : AppColors.blue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.add_rounded,
                                color: AppColors.onBrand,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
