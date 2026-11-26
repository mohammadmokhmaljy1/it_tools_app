import 'package:it_tools_app/core/utils/result.dart';

import '../entities/catalog_entities.dart';

abstract interface class CatalogRepository {
  Future<Result<HomeEntity>> getHome();
  Future<Result<List<CategoryEntity>>> getCategories();
  Future<Result<List<BrandEntity>>> getBrands();
}
