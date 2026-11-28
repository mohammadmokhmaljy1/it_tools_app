import 'package:dio/dio.dart';

import 'package:it_tools_app/core/utils/result.dart';

import '../entities/catalog_entities.dart';
import '../entities/product_search_entities.dart';

abstract interface class CatalogRepository {
  Future<Result<HomeEntity>> getHome();
  Future<Result<List<CategoryEntity>>> getCategories();
  Future<Result<List<BrandEntity>>> getBrands();
  Future<Result<PagedList<ProductSummaryEntity>>> getProducts(
    ProductQuery query,
  );
  Future<Result<SearchSuggestionsEntity>> getSearchSuggestions(
    String q, {
    CancelToken? cancelToken,
  });
}
