import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class ProductCardImageSection extends StatelessWidget {
  final String imageUrl;
  final String? discount;
  final bool isOutOfStock;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;

  const ProductCardImageSection({
    super.key,
    required this.imageUrl,
    this.discount,
    required this.isOutOfStock,
    required this.isFavorite,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: Container(
            height: 155,
            width: double.infinity,
            color: AppColors.pageBg,
            child: Opacity(
              opacity: isOutOfStock ? 0.45 : 1.0,
              child: Image.asset(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) => const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textTertiary,
                    size: 32,
                  ),
                ),
              ),
            ),
          ),
        ),

        // زر الإضافة للمفضلة (القلب)
        Positioned(
          top: 8,
          left: 8,
          child: GestureDetector(
            onTap: onFavoriteToggle,
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.06),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: 16,
                color: isFavorite ? AppColors.danger : AppColors.textSecondary,
              ),
            ),
          ),
        ),

        // وسم الخصم (-20%)
        if (discount != null && !isOutOfStock)
          Positioned(
            top: 8,
            right: 8,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: AppColors.orange,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                discount!,
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.navy900,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),

        // نص "غير متوفر حالياً"
        if (isOutOfStock)
          Positioned(
            top: 10,
            right: 10,
            child: Text(
              'غير متوفر حالياً',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
}
