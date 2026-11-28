import '../../domain/entities/product_details_entities.dart';
import 'catalog_models.dart';

class ProductSpecModel {
  final String name;
  final String value;

  const ProductSpecModel({required this.name, required this.value});

  factory ProductSpecModel.fromJson(Map<String, dynamic> json) {
    return ProductSpecModel(
      name: json['name'] as String? ?? '',
      value: json['value'] as String? ?? '',
    );
  }

  ProductSpecEntity toEntity() => ProductSpecEntity(name: name, value: value);
}

class ProductImageModel {
  final String id;
  final String url;
  final String mediumUrl;
  final String thumbUrl;
  final String? variantId;

  const ProductImageModel({
    required this.id,
    required this.url,
    required this.mediumUrl,
    required this.thumbUrl,
    this.variantId,
  });

  factory ProductImageModel.fromJson(Map<String, dynamic> json) {
    final mainUrl = json['url'] as String? ?? '';
    return ProductImageModel(
      id: json['id'] as String? ?? '',
      url: mainUrl,
      mediumUrl: json['mediumUrl'] as String? ?? mainUrl,
      thumbUrl: json['thumbUrl'] as String? ?? mainUrl,
      variantId: json['variantId'] as String?,
    );
  }

  ProductImageEntity toEntity() {
    return ProductImageEntity(
      id: id,
      url: url,
      mediumUrl: mediumUrl,
      thumbUrl: thumbUrl,
      variantId: variantId,
    );
  }
}

class ProductAttributeValueModel {
  final String id;
  final String value;
  final String? colorHex;
  final int sortOrder;

  const ProductAttributeValueModel({
    required this.id,
    required this.value,
    this.colorHex,
    this.sortOrder = 0,
  });

  factory ProductAttributeValueModel.fromJson(Map<String, dynamic> json) {
    return ProductAttributeValueModel(
      id: json['id'] as String? ?? '',
      value: json['value'] as String? ?? '',
      colorHex: json['colorHex'] as String?,
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
    );
  }

  ProductAttributeValueEntity toEntity() {
    return ProductAttributeValueEntity(
      id: id,
      value: value,
      colorHex: colorHex,
      sortOrder: sortOrder,
    );
  }
}

class ProductAttributeModel {
  final String id;
  final String name;
  final String displayType;
  final int sortOrder;
  final List<ProductAttributeValueModel> values;

  const ProductAttributeModel({
    required this.id,
    required this.name,
    required this.displayType,
    this.sortOrder = 0,
    required this.values,
  });

  factory ProductAttributeModel.fromJson(Map<String, dynamic> json) {
    final rawValues = json['values'] as List<dynamic>? ?? const [];
    final parsedValues =
        rawValues
            .whereType<Map<String, dynamic>>()
            .map(ProductAttributeValueModel.fromJson)
            .toList()
          ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));

    return ProductAttributeModel(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      displayType: json['displayType'] as String? ?? 'text',
      sortOrder: (json['sortOrder'] as num?)?.toInt() ?? 0,
      values: parsedValues,
    );
  }

  ProductAttributeEntity toEntity() {
    return ProductAttributeEntity(
      id: id,
      name: name,
      displayType: displayType,
      sortOrder: sortOrder,
      values: values.map((v) => v.toEntity()).toList(),
    );
  }
}

class ProductVariantModel {
  final String id;
  final String sku;
  final String label;
  final List<String> attributeValueIds;
  final bool isDefault;
  final num priceUsd;
  final num finalPriceUsd;
  final int discountPercent;
  final OfferModel? offer;
  final String? badgeTitle;
  final int stockQty;
  final bool inStock;
  final List<String> imageIds;

  const ProductVariantModel({
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

  factory ProductVariantModel.fromJson(Map<String, dynamic> json) {
    final offerJson = json['offer'];
    final badges = json['badges'] as List<dynamic>? ?? const [];
    String? firstBadge;
    if (badges.isNotEmpty && badges.first is Map<String, dynamic>) {
      firstBadge = (badges.first as Map<String, dynamic>)['title'] as String?;
    }

    final rawAttrIds = json['attributeValueIds'] as List<dynamic>? ?? const [];
    final rawImgIds = json['imageIds'] as List<dynamic>? ?? const [];

    return ProductVariantModel(
      id: json['id'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      label: json['label'] as String? ?? '',
      attributeValueIds: rawAttrIds.whereType<String>().toList(),
      isDefault: json['isDefault'] as bool? ?? false,
      priceUsd: json['priceUsd'] as num? ?? 0,
      finalPriceUsd:
          json['finalPriceUsd'] as num? ?? (json['priceUsd'] as num? ?? 0),
      discountPercent: (json['discountPercent'] as num?)?.toInt() ?? 0,
      offer: offerJson is Map<String, dynamic>
          ? OfferModel.fromJson(offerJson)
          : null,
      badgeTitle: firstBadge,
      stockQty: (json['stockQty'] as num?)?.toInt() ?? 0,
      inStock: json['inStock'] as bool? ?? false,
      imageIds: rawImgIds.whereType<String>().toList(),
    );
  }

  ProductVariantEntity toEntity() {
    return ProductVariantEntity(
      id: id,
      sku: sku,
      label: label,
      attributeValueIds: attributeValueIds,
      isDefault: isDefault,
      priceUsd: priceUsd,
      finalPriceUsd: finalPriceUsd,
      discountPercent: discountPercent,
      offer: offer?.toEntity(),
      badgeTitle: badgeTitle,
      stockQty: stockQty,
      inStock: inStock,
      imageIds: imageIds,
    );
  }
}
