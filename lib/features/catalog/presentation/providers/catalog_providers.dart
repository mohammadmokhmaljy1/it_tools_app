import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:it_tools_app/core/auth/auth_status_provider.dart';
import 'package:it_tools_app/core/errors/failure.dart';
import 'package:it_tools_app/core/network/dio_client.dart';
import 'package:it_tools_app/core/utils/result.dart';

import '../../data/datasources/catalog_remote_datasource.dart';
import '../../data/repositories/catalog_repository_impl.dart';
import '../../domain/entities/catalog_entities.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../../domain/usecases/catalog_usecases.dart';

final catalogRemoteDataSourceProvider = Provider<CatalogRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return CatalogRemoteDataSourceImpl(dio);
});

final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final remoteDataSource = ref.watch(catalogRemoteDataSourceProvider);
  return CatalogRepositoryImpl(remoteDataSource);
});

final getHomeDataUseCaseProvider = Provider<GetHomeData>((ref) {
  return GetHomeData(ref.watch(catalogRepositoryProvider));
});

final getCategoriesUseCaseProvider = Provider<GetCategories>((ref) {
  return GetCategories(ref.watch(catalogRepositoryProvider));
});

final getBrandsUseCaseProvider = Provider<GetBrands>((ref) {
  return GetBrands(ref.watch(catalogRepositoryProvider));
});

final homeProvider = FutureProvider<HomeEntity>((ref) async {
  ref.watch(authStatusProvider);
  final getHomeData = ref.watch(getHomeDataUseCaseProvider);
  final result = await getHomeData();

  return switch (result) {
    Success(:final data) => data,
    Error(:final failure) => throw failure,
  };
});

final categoriesProvider = FutureProvider<List<CategoryEntity>>((ref) async {
  final getCategories = ref.watch(getCategoriesUseCaseProvider);
  final result = await getCategories();

  return switch (result) {
    Success(:final data) => data,
    Error(:final failure) => throw failure,
  };
});

final brandsProvider = FutureProvider<List<BrandEntity>>((ref) async {
  final getBrands = ref.watch(getBrandsUseCaseProvider);
  final result = await getBrands();

  return switch (result) {
    Success(:final data) => data,
    Error(:final failure) => throw failure,
  };
});

String mapCatalogFailureMessage(Object error) {
  if (error is NetworkFailure) {
    return 'لا يوجد اتصال بالإنترنت. تحقق من الشبكة وحاول مرة أخرى.';
  }
  return 'تعذّر تحميل البيانات حالياً. يرجى المحاولة لاحقاً.';
}
