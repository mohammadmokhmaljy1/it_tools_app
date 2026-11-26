import 'package:it_tools_app/core/utils/result.dart';

import '../entities/catalog_entities.dart';
import '../repositories/catalog_repository.dart';

class GetHomeData {
  final CatalogRepository _repository;

  const GetHomeData(this._repository);

  Future<Result<HomeEntity>> call() {
    return _repository.getHome();
  }
}

class GetCategories {
  final CatalogRepository _repository;

  const GetCategories(this._repository);

  Future<Result<List<CategoryEntity>>> call() {
    return _repository.getCategories();
  }
}

class GetBrands {
  final CatalogRepository _repository;

  const GetBrands(this._repository);

  Future<Result<List<BrandEntity>>> call() {
    return _repository.getBrands();
  }
}
