import '../../domain/entities/catalog_entities.dart';

class BannerModel {
  final String id;
  final String title;
  final String imageUrl;
  final String linkType;
  final String? linkId;

  const BannerModel({
    required this.id,
    required this.title,
    required this.imageUrl,
    required this.linkType,
    this.linkId,
  });

  factory BannerModel.fromJson(Map<String, dynamic> json) {
    return BannerModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String? ?? '',
      linkType: json['linkType'] as String? ?? '',
      linkId: json['linkId']?.toString(),
    );
  }

  BannerEntity toEntity() {
    return BannerEntity(
      id: id,
      title: title,
      imageUrl: imageUrl,
      linkType: linkType,
      linkId: linkId,
    );
  }
}

class CategoryModel {
  final String id;
  final String? parentId;
  final String name;
  final String slug;
  final String? imageUrl;
  final int sortOrder;
  final int productsCount;
  final List<CategoryModel> children;

  const CategoryModel({
    required this.id,
    this.parentId,
    required this.name,
    required this.slug,
    this.imageUrl,
    required this.sortOrder,
    required this.productsCount,
    this.children = const [],
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    final rawChildren = json['children'] as List<dynamic>? ?? const [];
    return CategoryModel(
      id: json['id']?.toString() ?? '',
      parentId: json['parentId']?.toString(),
      name: json['name'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      productsCount: (json['productsCount'] as num?)?.toInt() ?? 0,
      children: rawChildren
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromJson)
          .toList(),
    );
  }

  CategoryEntity toEntity() {
    return CategoryEntity(
      id: id,
      parentId: parentId,
      name: name,
      slug: slug,
      imageUrl: imageUrl,
      sortOrder: sortOrder,
      productsCount: productsCount,
      children: children.map((child) => child.toEntity()).toList(),
    );
  }
}

class BrandModel {
  final String id;
  final String name;
  final String? logoUrl;

  const BrandModel({required this.id, required this.name, this.logoUrl});

  factory BrandModel.fromJson(Map<String, dynamic> json) {
    return BrandModel(
      id: json['id']?.toString() ?? '',
      name: json['name'] as String? ?? '',
      logoUrl: json['logoUrl'] as String?,
    );
  }

  BrandEntity toEntity() {
    return BrandEntity(id: id, name: name, logoUrl: logoUrl);
  }
}

class OfferModel {
  final String id;
  final String type;
  final String title;
  final String? imageUrl;
  final DateTime? endsAt;

  const OfferModel({
    required this.id,
    required this.type,
    required this.title,
    this.imageUrl,
    this.endsAt,
  });

  factory OfferModel.fromJson(Map<String, dynamic> json) {
    final rawEndsAt = json['endsAt'] as String?;
    return OfferModel(
      id: json['id']?.toString() ?? '',
      type: json['type'] as String? ?? '',
      title: json['title'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      endsAt: rawEndsAt != null ? DateTime.tryParse(rawEndsAt) : null,
    );
  }

  OfferEntity toEntity() {
    return OfferEntity(
      id: id,
      type: type,
      title: title,
      imageUrl: imageUrl,
      endsAt: endsAt,
    );
  }
}

class ProductSummaryModel {
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

  const ProductSummaryModel({
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

  factory ProductSummaryModel.fromJson(Map<String, dynamic> json) {
    final brand = json['brand'] as Map<String, dynamic>? ?? const {};
    final badges = json['badges'] as List<dynamic>? ?? const [];
    final firstBadge = badges.isNotEmpty && badges.first is Map<String, dynamic>
        ? badges.first as Map<String, dynamic>
        : null;

    return ProductSummaryModel(
      id: json['id']?.toString() ?? '',
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      brandName: brand['name'] as String? ?? '',
      imageUrl:
          (json['thumbUrl'] as String?) ?? (json['imageUrl'] as String?) ?? '',
      priceUsd: json['priceUsd'] as num? ?? 0,
      finalPriceUsd: json['finalPriceUsd'] as num? ?? 0,
      discountPercent: (json['discountPercent'] as num?)?.toInt() ?? 0,
      inStock: json['inStock'] as bool? ?? true,
      variantsCount: (json['variantsCount'] as num?)?.toInt() ?? 1,
      defaultVariantId: json['defaultVariantId']?.toString(),
      ratingAvg: json['ratingAvg'] as num? ?? 0,
      ratingCount: (json['ratingCount'] as num?)?.toInt() ?? 0,
      isFavorite: json['isFavorite'] as bool? ?? false,
      badgeTitle: firstBadge?['title'] as String?,
    );
  }

  ProductSummaryEntity toEntity() {
    return ProductSummaryEntity(
      id: id,
      slug: slug,
      name: name,
      brandName: brandName,
      imageUrl: imageUrl,
      priceUsd: priceUsd,
      finalPriceUsd: finalPriceUsd,
      discountPercent: discountPercent,
      inStock: inStock,
      variantsCount: variantsCount,
      defaultVariantId: defaultVariantId,
      ratingAvg: ratingAvg,
      ratingCount: ratingCount,
      isFavorite: isFavorite,
      badgeTitle: badgeTitle,
    );
  }
}

class HomeModel {
  final List<BannerModel> banners;
  final List<CategoryModel> categories;
  final List<OfferModel> offers;
  final List<ProductSummaryModel> offerProducts;
  final List<ProductSummaryModel> newArrivals;
  final List<ProductSummaryModel> bestSellers;
  final num exchangeRate;

  const HomeModel({
    required this.banners,
    required this.categories,
    required this.offers,
    required this.offerProducts,
    required this.newArrivals,
    required this.bestSellers,
    required this.exchangeRate,
  });

  factory HomeModel.fromJson(Map<String, dynamic> json) {
    List<ProductSummaryModel> parseProducts(String key) {
      final list = json[key] as List<dynamic>? ?? const [];
      return list
          .whereType<Map<String, dynamic>>()
          .map(ProductSummaryModel.fromJson)
          .toList();
    }

    return HomeModel(
      banners: (json['banners'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(BannerModel.fromJson)
          .toList(),
      categories: (json['categories'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromJson)
          .toList(),
      offers: (json['offers'] as List<dynamic>? ?? const [])
          .whereType<Map<String, dynamic>>()
          .map(OfferModel.fromJson)
          .toList(),
      offerProducts: parseProducts('offerProducts'),
      newArrivals: parseProducts('newArrivals'),
      bestSellers: parseProducts('bestSellers'),
      exchangeRate: json['exchangeRate'] as num? ?? 13000,
    );
  }

  HomeEntity toEntity() {
    return HomeEntity(
      banners: banners.map((b) => b.toEntity()).toList(),
      categories: categories.map((c) => c.toEntity()).toList(),
      offers: offers.map((o) => o.toEntity()).toList(),
      offerProducts: offerProducts.map((p) => p.toEntity()).toList(),
      newArrivals: newArrivals.map((p) => p.toEntity()).toList(),
      bestSellers: bestSellers.map((p) => p.toEntity()).toList(),
      exchangeRate: exchangeRate,
    );
  }
}
