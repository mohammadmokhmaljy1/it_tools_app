import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class ProductGridCardImage extends StatelessWidget {
  final String? imagePath;
  final bool isAvailable;
  final bool isFavorite;
  final String? discount;
  final VoidCallback? onToggleFavorite;

  const ProductGridCardImage({
    super.key,
    required this.imagePath,
    required this.isAvailable,
    required this.isFavorite,
    this.discount,
    this.onToggleFavorite,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: AppColors.pageBg,
            child: Opacity(
              opacity: isAvailable ? 1.0 : 0.45,
              child: Image.asset(
                imagePath ?? 'assets/images/products/mouse_silent.png',
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const Center(
                  child: Icon(
                    Icons.image_not_supported_outlined,
                    color: AppColors.textTertiary,
                    size: 36,
                  ),
                ),
              ),
            ),
          ),
        ),
        PositionedDirectional(
          top: 8,
          end: 8,
          child: InkWell(
            onTap: onToggleFavorite,
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(color: Colors.black.withAlpha(15), blurRadius: 4),
                ],
              ),
              child: Icon(
                isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                size: 16,
                color: isFavorite ? AppColors.danger : AppColors.textTertiary,
              ),
            ),
          ),
        ),
        PositionedDirectional(
          top: 8,
          start: 8,
          child: isAvailable
              ? (discount != null
                    ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.orange,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          discount!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.onBrand,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      )
                    : const SizedBox.shrink())
              : Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 3,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.subtle,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'غير متوفر حالياً',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                    ),
                  ),
                ),
        ),
      ],
    );
  }
}
