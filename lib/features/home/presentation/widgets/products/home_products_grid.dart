import 'package:flutter/material.dart';
import 'package:it_tools_app/features/favorites/presentation/widgets/favorites/favorites_mock_data.dart';
import 'package:it_tools_app/features/home/presentation/widgets/products/product_card.dart';

class HomeProductsGrid extends StatefulWidget {
  final List<Map<String, dynamic>> products;

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

  @override
  Widget build(BuildContext context) {
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
          final item = widget.products[index];
          final String title = item['title'] as String;
          final bool isFav = FavoritesMockData.isFavorite(title);

          return ProductCard(
            title: title,
            category: item['category'] as String,
            price: item['price'] as String,
            oldPrice: item['oldPrice'] as String?,
            imageUrl: item['image'] as String,
            discount: item['discount'] as String?,
            isFavorite: isFav,
            isOutOfStock: (item['isOutOfStock'] as bool?) ?? false,
            onAddToCart: () => _showAddedToCartSnackBar(title),
            onFavoriteToggle: () {
              setState(() {
                FavoritesMockData.toggleFavorite({
                  'name': title,
                  'category': item['category'],
                  'price': item['price'],
                  'oldPrice': item['oldPrice'],
                  'discount': item['discount'],
                  'rating': '4.8',
                  'reviewsCount': '128',
                  'image': item['image'],
                  'isAvailable': !((item['isOutOfStock'] as bool?) ?? false),
                });
              });
            },
          );
        },
      ),
    );
  }
}
