import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/catalog/domain/entities/catalog_entities.dart';
import 'package:it_tools_app/features/catalog/presentation/providers/product_details_providers.dart';
import 'package:it_tools_app/features/categories/presentation/widgets/product_list/product_grid_card.dart';
import 'package:it_tools_app/features/favorites/presentation/widgets/favorites/favorites_mock_data.dart';
import 'package:it_tools_app/features/offers/presentation/widgets/offer_details_header.dart';

class OfferDetailsPage extends ConsumerWidget {
  final String offerId;
  final String? fallbackTitle;

  const OfferDetailsPage({
    super.key,
    required this.offerId,
    this.fallbackTitle,
  });

  String _formatUsd(num value) =>
      value % 1 == 0 ? '${value.toInt()}\$' : '${value.toStringAsFixed(1)}\$';

  Map<String, dynamic> _toCardMap(
    ProductSummaryEntity product, {
    required bool isOfferExpired,
  }) {
    final effectivePrice = isOfferExpired
        ? product.priceUsd
        : product.finalPriceUsd;
    final showDiscount = !isOfferExpired && product.hasDiscount;

    return {
      'id': product.id,
      'slug': product.slug,
      'name': product.name,
      'category': product.brandName,
      'price': _formatUsd(effectivePrice),
      'oldPrice': showDiscount ? _formatUsd(product.priceUsd) : null,
      'discount': !isOfferExpired && product.discountPercent > 0
          ? '-${product.discountPercent}%'
          : (isOfferExpired ? null : product.badgeTitle),
      'rating': product.ratingAvg.toString(),
      'reviewsCount': product.ratingCount.toString(),
      'image': product.imageUrl,
      'isAvailable': product.inStock,
      'isOutOfStock': !product.inStock,
      'isFavorite': FavoritesMockData.isFavorite(product.name),
    };
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final offerAsync = ref.watch(offerDetailsProvider(offerId));

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        elevation: 0,
        title: Text(
          offerAsync.value?.offer.title ?? (fallbackTitle ?? 'منتجات العرض'),
          style: AppTextStyles.titleLarge,
        ),
      ),
      body: offerAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                err.toString().replaceFirst('Exception: ', ''),
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => ref.invalidate(offerDetailsProvider(offerId)),
                child: const Text('إعادة المحاولة'),
              ),
            ],
          ),
        ),
        data: (details) {
          final endsAt = details.offer.endsAt;
          final isExpired = endsAt != null && endsAt.isBefore(DateTime.now());

          return Column(
            children: [
              OfferDetailsHeader(offer: details.offer, isExpired: isExpired),
              Expanded(
                child: details.products.isEmpty
                    ? Center(
                        child: Text(
                          'لا توجد منتجات متاحة في هذا العرض حالياً',
                          style: AppTextStyles.bodyMedium.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      )
                    : GridView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: details.products.length,
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                              childAspectRatio: 0.64,
                            ),
                        itemBuilder: (context, i) {
                          final product = details.products[i];
                          final cardMap = _toCardMap(
                            product,
                            isOfferExpired: isExpired,
                          );
                          return ProductGridCard(
                            product: cardMap,
                            onTap: () => context.push(
                              AppRouter.productDetails,
                              extra: cardMap,
                            ),
                            onAddToCart: () =>
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                      'تمت إضافة "${product.name}" للسلة',
                                    ),
                                    duration: const Duration(seconds: 1),
                                  ),
                                ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
