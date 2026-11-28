import 'package:flutter/material.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class ProductDetailsBottomBar extends StatelessWidget {
  final int quantity;
  final bool canAddToCart;
  final bool canIncrement;
  final VoidCallback onIncrement;
  final VoidCallback onDecrement;
  final VoidCallback onAddToCart;

  const ProductDetailsBottomBar({
    super.key,
    required this.quantity,
    this.canAddToCart = true,
    this.canIncrement = true,
    required this.onIncrement,
    required this.onDecrement,
    required this.onAddToCart,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          top: BorderSide(color: AppColors.borderDefault, width: 0.8),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.borderDefault),
              ),
              child: Row(
                children: [
                  _qtyBtn(
                    icon: Icons.add_rounded,
                    bgColor: canIncrement ? AppColors.blue : AppColors.subtle,
                    iconColor: canIncrement
                        ? AppColors.onBrand
                        : AppColors.textTertiary,
                    onTap: canIncrement ? onIncrement : null,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Text('$quantity', style: AppTextStyles.titleLarge),
                  ),
                  _qtyBtn(
                    icon: Icons.remove_rounded,
                    bgColor: AppColors.pageBg,
                    iconColor: quantity > 1
                        ? AppColors.textPrimary
                        : AppColors.textTertiary,
                    onTap: quantity > 1 ? onDecrement : null,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: InkWell(
                onTap: canAddToCart ? onAddToCart : null,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    color: canAddToCart
                        ? AppColors.actionPrimary
                        : AppColors.actionDisabled,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        canAddToCart
                            ? Icons.shopping_cart_outlined
                            : Icons.block_rounded,
                        size: 20,
                        color: AppColors.onBrand,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        canAddToCart ? 'أضف إلى السلة' : 'غير متوفر حالياً',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.onBrand,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _qtyBtn({
    required IconData icon,
    required Color bgColor,
    required Color iconColor,
    required VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        width: 34,
        height: 36,
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}
