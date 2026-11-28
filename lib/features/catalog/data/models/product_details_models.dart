import '../../domain/entities/product_details_entities.dart';
import 'catalog_models.dart';
import 'product_variant_models.dart';

class ProductDetailsModel {
  final String id;
  final String slug;
  final String name;
  final String description;
  final List<ProductSpecModel> specs;
  final String brandId;
  final String brandName;
  final String categoryId;
  final String categoryName;
  final List<ProductImageModel> images;
  final List<ProductAttributeModel> attributes;
  final List<ProductVariantModel> variants;
  final bool inStock;
  final double ratingAvg;
  final int ratingCount;
  final int? myRating;
  final bool canRate;
  final bool isFavorite;
  final num exchangeRate;

  const ProductDetailsModel({
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
    required this.ratingAvg,
    required this.ratingCount,
    this.myRating,
    required this.canRate,
    required this.isFavorite,
    required this.exchangeRate,
  });

  factory ProductDetailsModel.fromJson(Map<String, dynamic> json) {
    final brand = json['brand'] as Map<String, dynamic>? ?? const {};
    final category = json['category'] as Map<String, dynamic>? ?? const {};
    final rating = json['rating'] as Map<String, dynamic>? ?? const {};

    final rawSpecs = json['specs'] as List<dynamic>? ?? const [];
    final rawImages = json['images'] as List<dynamic>? ?? const [];
    final rawAttributes = json['attributes'] as List<dynamic>? ?? const [];
    final rawVariants = json['variants'] as List<dynamic>? ?? const [];

    final parsedAttrs =
        rawAttributes
            .whereType<Map<String, dynamic>>()
            .map(ProductAttributeModel.fromJson)
            .toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return ProductDetailsModel(
      id: json['id'] as String? ?? '',
      slug: json['slug'] as String? ?? '',
      name: json['name'] as String? ?? '',
      description: json['description'] as String? ?? '',
      specs: rawSpecs
          .whereType<Map<String, dynamic>>()
          .map(ProductSpecModel.fromJson)
          .toList(),
      brandId: brand['id'] as String? ?? '',
      brandName: brand['name'] as String? ?? '',
      categoryId: category['id'] as String? ?? '',
      categoryName: category['name'] as String? ?? '',
      images: rawImages
          .whereType<Map<String, dynamic>>()
          .map(ProductImageModel.fromJson)
          .toList(),
      attributes: parsedAttrs,
      variants: rawVariants
          .whereType<Map<String, dynamic>>()
          .map(ProductVariantModel.fromJson)
          .toList(),
      inStock: json['inStock'] as bool? ?? false,
      ratingAvg: (rating['avg'] as num?)?.toDouble() ?? 0.0,
      ratingCount: (rating['count'] as num?)?.toInt() ?? 0,
      myRating: (rating['myRating'] as num?)?.toInt(),
      canRate: rating['canRate'] as bool? ?? false,
      isFavorite: json['isFavorite'] as bool? ?? false,
      exchangeRate: json['exchangeRate'] as num? ?? 1,
    );
  }

  ProductDetailsEntity toEntity() {
    return ProductDetailsEntity(
      id: id,
      slug: slug,
      name: name,
      description: description,
      specs: specs.map((s) => s.toEntity()).toList(),
      brandId: brandId,
      brandName: brandName,
      categoryId: categoryId,
      categoryName: categoryName,
      images: images.map((i) => i.toEntity()).toList(),
      attributes: attributes.map((a) => a.toEntity()).toList(),
      variants: variants.map((v) => v.toEntity()).toList(),
      inStock: inStock,
      rating: ProductRatingEntity(
        avg: ratingAvg,
        count: ratingCount,
        myRating: myRating,
        canRate: canRate,
      ),
      isFavorite: isFavorite,
      exchangeRate: exchangeRate,
    );
  }
}

class OfferDetailsModel {
  final OfferModel offer;
  final List<ProductSummaryModel> products;

  const OfferDetailsModel({required this.offer, required this.products});

  factory OfferDetailsModel.fromJson(Map<String, dynamic> json) {
    final offerMap = json['offer'] is Map<String, dynamic>
        ? json['offer'] as Map<String, dynamic>
        : json;
    final rawProducts =
        json['products'] as List<dynamic>? ??
        (json['items'] as List<dynamic>? ?? const []);

    return OfferDetailsModel(
      offer: OfferModel.fromJson(offerMap),
      products: rawProducts
          .whereType<Map<String, dynamic>>()
          .map(ProductSummaryModel.fromJson)
          .toList(),
    );
  }

  OfferDetailsEntity toEntity() {
    return OfferDetailsEntity(
      offer: offer.toEntity(),
      products: products.map((p) => p.toEntity()).toList(),
    );
  }
}
