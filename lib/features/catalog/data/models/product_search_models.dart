import 'package:it_tools_app/features/catalog/domain/entities/catalog_entities.dart';

import '../../domain/entities/product_search_entities.dart';

import 'catalog_models.dart';

class PagedProductsModel {
  final List<ProductSummaryModel> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  final bool hasNext;

  const PagedProductsModel({
    required this.items,
    required this.page,
    required this.limit,
    required this.total,
    required this.totalPages,
    required this.hasNext,
  });

  factory PagedProductsModel.fromJson(Map<String, dynamic> rootJson) {
    final rawItems = rootJson['data'] as List<dynamic>? ?? const [];
    final meta = rootJson['meta'] as Map<String, dynamic>? ?? const {};

    return PagedProductsModel(
      items: rawItems
          .whereType<Map<String, dynamic>>()
          .map(ProductSummaryModel.fromJson)
          .toList(),
      page: (meta['page'] as num?)?.toInt() ?? 1,
      limit: (meta['limit'] as num?)?.toInt() ?? 20,
      total: (meta['total'] as num?)?.toInt() ?? rawItems.length,
      totalPages: (meta['totalPages'] as num?)?.toInt() ?? 1,
      hasNext: meta['hasNext'] as bool? ?? false,
    );
  }

  PagedList<ProductSummaryEntity> toEntity() {
    return PagedList<ProductSummaryEntity>(
      items: items.map((e) => e.toEntity()).toList(),
      page: page,
      limit: limit,
      total: total,
      totalPages: totalPages,
      hasNext: hasNext,
    );
  }
}

class SearchSuggestionsModel {
  final List<ProductSummaryModel> products;
  final List<CategoryModel> categories;

  const SearchSuggestionsModel({
    required this.products,
    required this.categories,
  });

  factory SearchSuggestionsModel.fromJson(Map<String, dynamic> json) {
    final rawProducts = json['products'] as List<dynamic>? ?? const [];
    final rawCategories = json['categories'] as List<dynamic>? ?? const [];

    return SearchSuggestionsModel(
      products: rawProducts
          .whereType<Map<String, dynamic>>()
          .map(ProductSummaryModel.fromJson)
          .toList(),
      categories: rawCategories
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromJson)
          .toList(),
    );
  }

  SearchSuggestionsEntity toEntity() {
    return SearchSuggestionsEntity(
      products: products.map((e) => e.toEntity()).toList(),
      categories: categories.map((e) => e.toEntity()).toList(),
    );
  }
}
