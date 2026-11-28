import 'catalog_entities.dart';

class ProductSpecEntity {
  final String name;
  final String value;

  const ProductSpecEntity({required this.name, required this.value});
}

class ProductImageEntity {
  final String id;
  final String url;
  final String mediumUrl;
  final String thumbUrl;
  final String? variantId;

  const ProductImageEntity({
    required this.id,
    required this.url,
    required this.mediumUrl,
    required this.thumbUrl,
    this.variantId,
  });
}

class ProductAttributeValueEntity {
  final String id;
  final String value;
  final String? colorHex;
  final int sortOrder;

  const ProductAttributeValueEntity({
    required this.id,
    required this.value,
    this.colorHex,
    this.sortOrder = 0,
  });
}

class ProductAttributeEntity {
  final String id;
  final String name;
  final String displayType;
  final int sortOrder;
  final List<ProductAttributeValueEntity> values;

  const ProductAttributeEntity({
    required this.id,
    required this.name,
    required this.displayType,
    this.sortOrder = 0,
    required this.values,
  });
}

class ProductVariantEntity {
  final String id;
  final String sku;
  final String label;
  final List<String> attributeValueIds;
  final bool isDefault;
  final num priceUsd;
  final num finalPriceUsd;
  final int discountPercent;
  final OfferEntity? offer;
  final String? badgeTitle;
  final int stockQty;
  final bool inStock;
  final List<String> imageIds;

  const ProductVariantEntity({
    required this.id,
    required this.sku,
    required this.label,
    required this.attributeValueIds,
    required this.isDefault,
    required this.priceUsd,
    required this.finalPriceUsd,
    required this.discountPercent,
    this.offer,
    this.badgeTitle,
    required this.stockQty,
    required this.inStock,
    required this.imageIds,
  });

  bool get hasDiscount => finalPriceUsd < priceUsd;
}

class ProductRatingEntity {
  final double avg;
  final int count;
  final int? myRating;
  final bool canRate;

  const ProductRatingEntity({
    required this.avg,
    required this.count,
    this.myRating,
    required this.canRate,
  });
}

class ProductDetailsEntity {
  final String id;
  final String slug;
  final String name;
  final String description;
  final List<ProductSpecEntity> specs;
  final String brandId;
  final String brandName;
  final String categoryId;
  final String categoryName;
  final List<ProductImageEntity> images;
  final List<ProductAttributeEntity> attributes;
  final List<ProductVariantEntity> variants;
  final bool inStock;
  final ProductRatingEntity rating;
  final bool isFavorite;
  final num exchangeRate;

  const ProductDetailsEntity({
    required this.id,
    required this.slug,
    required this.name,
    required this.description,
    required this.specs,
    required this.brandId,
    required this.brandName,
    required this.categoryId,
    required this.categoryName,
    required this.images,
    required this.attributes,
    required this.variants,
    required this.inStock,
    required this.rating,
    required this.isFavorite,
    required this.exchangeRate,
  });

  ProductVariantEntity? get defaultVariant {
    if (variants.isEmpty) return null;
    for (final variant in variants) {
      if (variant.isDefault) return variant;
    }
    return variants.first;
  }
}

class OfferDetailsEntity {
  final OfferEntity offer;
  final List<ProductSummaryEntity> products;

  const OfferDetailsEntity({required this.offer, required this.products});
}
