import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/config/app_router.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/catalog/domain/entities/catalog_entities.dart';
import 'package:it_tools_app/features/catalog/presentation/providers/product_search_providers.dart';
import 'package:it_tools_app/features/categories/presentation/widgets/product_list/product_grid_card.dart';
import 'package:it_tools_app/features/favorites/presentation/widgets/favorites/favorites_mock_data.dart';

class SearchResultsGrid extends StatefulWidget {
  final ProductsState state;
  final String query;
  final ScrollController scrollController;
  final VoidCallback onRetry;

  const SearchResultsGrid({
    super.key,
    required this.state,
    required this.query,
    required this.scrollController,
    required this.onRetry,
  });

  @override
  State<SearchResultsGrid> createState() => _SearchResultsGridState();
}

class _SearchResultsGridState extends State<SearchResultsGrid> {
  String _formatUsd(num value) {
    return value % 1 == 0
        ? '${value.toInt()}\$'
        : '${value.toStringAsFixed(1)}\$';
  }

  Map<String, dynamic> _toCardMap(ProductSummaryEntity product) {
    return {
      'id': product.id,
      'slug': product.slug,
      'name': product.name,
      'category': product.brandName,
      'price': _formatUsd(product.finalPriceUsd),
      'oldPrice': product.hasDiscount ? _formatUsd(product.priceUsd) : null,
      'discount': product.discountPercent > 0
          ? '-${product.discountPercent}%'
          : product.badgeTitle,
      'rating': product.ratingAvg.toString(),
      'reviewsCount': product.ratingCount.toString(),
      'image': product.imageUrl,
      'isAvailable': product.inStock,
      'isOutOfStock': !product.inStock,
      'isFavorite': FavoritesMockData.isFavorite(product.name),
    };
  }

  @override
  Widget build(BuildContext context) {
    if (widget.state.isInitialLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.state.errorMessage != null && widget.state.items.isEmpty) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.state.errorMessage!,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: widget.onRetry,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),
          child: Text(
            'نتائج البحث عن "${widget.query.trim()}" (${widget.state.items.length})',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textTertiary,
              fontSize: 13,
            ),
          ),
        ),
        Expanded(
          child: GridView.builder(
            controller: widget.scrollController,
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
            itemCount: widget.state.items.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.64,
            ),
            itemBuilder: (context, i) {
              final product = widget.state.items[i];
              final cardMap = _toCardMap(product);
              return ProductGridCard(
                product: cardMap,
                onTap: () =>
                    context.push(AppRouter.productDetails, extra: cardMap),

                onToggleFavorite: () => setState(() {
                  FavoritesMockData.toggleFavorite(cardMap);
                }),
                onAddToCart: () => ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('تمت إضافة "${product.name}" للسلة'),
                    duration: const Duration(seconds: 1),
                  ),
                ),
              );
            },
          ),
        ),
        if (widget.state.isLoadingMore)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
      ],
    );
  }
}
