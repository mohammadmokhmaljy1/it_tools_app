import 'package:dio/dio.dart';

import 'package:it_tools_app/core/utils/result.dart';

import '../../domain/entities/catalog_entities.dart';
import '../../domain/entities/product_details_entities.dart';
import '../../domain/entities/product_search_entities.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_remote_datasource.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource _remoteDataSource;

  const CatalogRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<HomeEntity>> getHome() async {
    final result = await _remoteDataSource.getHome();
    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Error(:final failure) => Error(failure),
    };
  }

  @override
  Future<Result<List<CategoryEntity>>> getCategories() async {
    final result = await _remoteDataSource.getCategories();
    return switch (result) {
      Success(:final data) => Success(
        data.map((model) => model.toEntity()).toList(),
      ),
      Error(:final failure) => Error(failure),
    };
  }

  @override
  Future<Result<List<BrandEntity>>> getBrands() async {
    final result = await _remoteDataSource.getBrands();
    return switch (result) {
      Success(:final data) => Success(
        data.map((model) => model.toEntity()).toList(),
      ),
      Error(:final failure) => Error(failure),
    };
  }

  @override
  Future<Result<PagedList<ProductSummaryEntity>>> getProducts(
    ProductQuery query,
  ) async {
    final result = await _remoteDataSource.getProducts(query);
    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Error(:final failure) => Error(failure),
    };
  }

  @override
  Future<Result<SearchSuggestionsEntity>> getSearchSuggestions(
    String q, {
    CancelToken? cancelToken,
  }) async {
    final result = await _remoteDataSource.getSearchSuggestions(
      q,
      cancelToken: cancelToken,
    );
    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Error(:final failure) => Error(failure),
    };
  }

  @override
  Future<Result<ProductDetailsEntity>> getProductDetails(
    String idOrSlug,
  ) async {
    final result = await _remoteDataSource.getProductDetails(idOrSlug);
    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Error(:final failure) => Error(failure),
    };
  }

  @override
  Future<Result<OfferDetailsEntity>> getOfferDetails(String offerId) async {
    final result = await _remoteDataSource.getOfferDetails(offerId);
    return switch (result) {
      Success(:final data) => Success(data.toEntity()),
      Error(:final failure) => Error(failure),
    };
  }
}
