import 'catalog_entities.dart';

class ProductQuery {
  final int page;
  final int limit;
  final String? sort;
  final String? q;
  final String? categoryId;
  final String? brandId;
  final num? minPrice;
  final num? maxPrice;
  final bool? inStock;
  final bool? onOffer;
  final String? offerId;

  const ProductQuery({
    this.page = 1,
    this.limit = 20,
    this.sort,
    this.q,
    this.categoryId,
    this.brandId,
    this.minPrice,
    this.maxPrice,
    this.inStock,
    this.onOffer,
    this.offerId,
  });

  Map<String, dynamic> toQueryParameters() {
    return {
      'page': page,
      'limit': limit,
      if (sort != null && sort!.isNotEmpty) 'sort': sort,
      if (q != null && q!.trim().isNotEmpty) 'q': q!.trim(),
      if (categoryId != null && categoryId!.isNotEmpty)
        'categoryId': categoryId,
      if (brandId != null && brandId!.isNotEmpty) 'brandId': brandId,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      if (inStock != null) 'inStock': inStock,
      if (onOffer != null) 'onOffer': onOffer,
      if (offerId != null && offerId!.isNotEmpty) 'offerId': offerId,
    };
  }

  ProductQuery copyWith({
    int? page,
    int? limit,
    String? sort,
    String? q,
    String? categoryId,
    String? brandId,
    num? minPrice,
    num? maxPrice,
    bool? inStock,
    bool? onOffer,
    String? offerId,
  }) {
    return ProductQuery(
      page: page ?? this.page,
      limit: limit ?? this.limit,
      sort: sort ?? this.sort,
      q: q ?? this.q,
      categoryId: categoryId ?? this.categoryId,
      brandId: brandId ?? this.brandId,
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      inStock: inStock ?? this.inStock,
      onOffer: onOffer ?? this.onOffer,
      offerId: offerId ?? this.offerId,
    );
  }
}

class PagedList<T> {
  final List<T> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;

  const PagedList({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
  });
}

class SearchSuggestionsEntity {
  final List<ProductSummaryEntity> products;
  final List<CategoryEntity> categories;

  const SearchSuggestionsEntity({
    required this.products,
    required this.categories,
  });
}
