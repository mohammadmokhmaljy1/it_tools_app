import 'package:dio/dio.dart';

import 'package:it_tools_app/core/errors/failure.dart';
import 'package:it_tools_app/core/network/error_mapper.dart';
import 'package:it_tools_app/core/utils/result.dart';

import '../../domain/entities/product_search_entities.dart';
import '../models/catalog_models.dart';
import '../models/product_search_models.dart';

abstract interface class CatalogRemoteDataSource {
  Future<Result<HomeModel>> getHome();
  Future<Result<List<CategoryModel>>> getCategories();
  Future<Result<List<BrandModel>>> getBrands();
  Future<Result<PagedProductsModel>> getProducts(ProductQuery query);
  Future<Result<SearchSuggestionsModel>> getSearchSuggestions(
    String q, {
    CancelToken? cancelToken,
  });
}

class CatalogRemoteDataSourceImpl implements CatalogRemoteDataSource {
  final Dio _dio;

  const CatalogRemoteDataSourceImpl(this._dio);

  @override
  Future<Result<HomeModel>> getHome() {
    return guardRequest(() async {
      final response = await _dio.get<Map<String, dynamic>>('/home');
      final rawData = response.data?['data'];

      if (rawData is! Map<String, dynamic>) {
        throw const ServerFailure();
      }

      return HomeModel.fromJson(rawData);
    });
  }

  @override
  Future<Result<List<CategoryModel>>> getCategories() {
    return guardRequest(() async {
      final response = await _dio.get<Map<String, dynamic>>('/categories');
      final rawData = response.data?['data'];

      if (rawData is! List<dynamic>) {
        throw const ServerFailure();
      }

      return rawData
          .whereType<Map<String, dynamic>>()
          .map(CategoryModel.fromJson)
          .toList();
    });
  }

  @override
  Future<Result<List<BrandModel>>> getBrands() {
    return guardRequest(() async {
      final response = await _dio.get<Map<String, dynamic>>('/brands');
      final rawData = response.data?['data'];

      if (rawData is! List<dynamic>) {
        throw const ServerFailure();
      }

      return rawData
          .whereType<Map<String, dynamic>>()
          .map(BrandModel.fromJson)
          .toList();
    });
  }

  @override
  Future<Result<PagedProductsModel>> getProducts(ProductQuery query) {
    return guardRequest(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/products',
        queryParameters: query.toQueryParameters(),
      );
      final rootData = response.data;

      if (rootData == null || rootData['data'] is! List<dynamic>) {
        throw const ServerFailure();
      }

      return PagedProductsModel.fromJson(rootData);
    });
  }

  @override
  Future<Result<SearchSuggestionsModel>> getSearchSuggestions(
    String q, {
    CancelToken? cancelToken,
  }) {
    return guardRequest(() async {
      final response = await _dio.get<Map<String, dynamic>>(
        '/products/suggestions',
        queryParameters: {'q': q.trim()},
        cancelToken: cancelToken,
      );
      final rawData = response.data?['data'];

      if (rawData is! Map<String, dynamic>) {
        throw const ServerFailure();
      }

      return SearchSuggestionsModel.fromJson(rawData);
    });
  }
}
