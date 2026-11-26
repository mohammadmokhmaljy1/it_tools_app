import 'package:flutter/material.dart';

import 'package:it_tools_app/features/catalog/domain/entities/catalog_entities.dart';
import 'package:it_tools_app/features/favorites/presentation/widgets/favorites/favorites_mock_data.dart';
import 'package:it_tools_app/features/home/presentation/widgets/products/product_card.dart';

class HomeProductsGrid extends StatefulWidget {
  final List<ProductSummaryEntity> products;

  const HomeProductsGrid({super.key, required this.products});

  @override
  State<HomeProductsGrid> createState() => _HomeProductsGridState();
}

class _HomeProductsGridState extends State<HomeProductsGrid> {
  void _showAddedToCartSnackBar(String productTitle) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'تمت إضافة "$productTitle" إلى السلة',
          textAlign: TextAlign.right,
          style: const TextStyle(fontFamily: 'Cairo'),
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _formatUsd(num value) {
    return value % 1 == 0
        ? '${value.toInt()}\$'
        : '${value.toStringAsFixed(1)}\$';
  }

  @override
  Widget build(BuildContext context) {
    if (widget.products.isEmpty) return const SizedBox.shrink();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: widget.products.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.56,
        ),
        itemBuilder: (context, index) {
          final product = widget.products[index];
          final String priceText = _formatUsd(product.finalPriceUsd);
          final String? oldPriceText = product.hasDiscount
              ? _formatUsd(product.priceUsd)
              : null;
          final String? discountText = product.discountPercent > 0
              ? '-${product.discountPercent}%'
              : product.badgeTitle;
          final bool isFav = FavoritesMockData.isFavorite(product.name);

          return ProductCard(
            title: product.name,
            category: product.brandName,
            price: priceText,
            oldPrice: oldPriceText,
            imageUrl: product.imageUrl,
            rating: product.ratingAvg.toString(),
            reviewsCount: product.ratingCount.toString(),
            discount: discountText,
            isFavorite: isFav,
            isOutOfStock: !product.inStock,
            onAddToCart: () => _showAddedToCartSnackBar(product.name),
            onFavoriteToggle: () {
              setState(() {
                FavoritesMockData.toggleFavorite({
                  'name': product.name,
                  'category': product.brandName,
                  'price': priceText,
                  'oldPrice': oldPriceText,
                  'discount': discountText,
                  'rating': product.ratingAvg.toString(),
                  'reviewsCount': product.ratingCount.toString(),
                  'image': product.imageUrl,
                  'isAvailable': product.inStock,
                });
              });
            },
          );
        },
      ),
    );
  }
}
