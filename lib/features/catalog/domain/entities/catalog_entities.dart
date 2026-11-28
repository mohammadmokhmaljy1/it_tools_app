class BannerEntity {
  final String id;
  final String title;
  final String imageUrl;
  final String linkType;
  final String? linkId;

  const BannerEntity({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.linkType,
    this.linkId,
  });
}

class CategoryEntity {
  final String id;
  final String? parentId;
  final String name;
  final String slug;
  final String? imageUrl;
  final int sortOrder;
  final int productsCount;
  final List<CategoryEntity> children;

  const CategoryEntity({
    required this.id,
    this.parentId,
    required this.name,
    required this.slug,
    this.imageUrl,
    required this.sortOrder,
    required this.productsCount,
    this.children = const [],
  });
}

class BrandEntity {
  final String id;
  final String name;
  final String? logoUrl;

  const BrandEntity({required this.id, required this.name, this.logoUrl});
}

class OfferEntity {
  final String id;
  final String type;
  final String title;
  final String? imageUrl;
  final DateTime? endsAt;

  const OfferEntity({
    required this.id,
    required this.type,
    required this.title,
    this.imageUrl,
    this.endsAt,
  });

  Duration get remainingDuration {
    if (endsAt == null) return Duration.zero;
    final diff = endsAt!.toLocal().difference(DateTime.now());
    return diff.isNegative ? Duration.zero : diff;
  }
}

class ProductSummaryEntity {
  final String id;
  final String slug;
  final String name;
  final String brandName;
  final String imageUrl;
  final num priceUsd;
  final num finalPriceUsd;
  final int discountPercent;
  final bool inStock;
  final int variantsCount;
  final String? defaultVariantId;
  final num ratingAvg;
  final int ratingCount;
  final bool isFavorite;
  final String? badgeTitle;

  const ProductSummaryEntity({
    required this.id,
    required this.slug,
    required this.name,
    required this.brandName,
    required this.imageUrl,
    required this.priceUsd,
    required this.finalPriceUsd,
    required this.discountPercent,
    required this.inStock,
    required this.variantsCount,
    this.defaultVariantId,
    required this.ratingAvg,
    required this.ratingCount,
    required this.isFavorite,
    this.badgeTitle,
  });

  bool get hasDiscount => discountPercent > 0 && finalPriceUsd < priceUsd;
}

class HomeEntity {
  final List<BannerEntity> banners;
  final List<CategoryEntity> categories;
  final List<OfferEntity> offers;
  final List<ProductSummaryEntity> offerProducts;
  final List<ProductSummaryEntity> newArrivals;
  final List<ProductSummaryEntity> bestSellers;
  final num exchangeRate;

  const HomeEntity({
    required this.banners,
    required this.categories,
    required this.offers,
    required this.offerProducts,
    required this.newArrivals,
    required this.bestSellers,
    required this.exchangeRate,
  });
}
