import 'package:it_tools_app/core/utils/result.dart';

import '../entities/app_config_entity.dart';
import '../repositories/app_config_repository.dart';

class GetAppConfig {
  final AppConfigRepository _repository;

  const GetAppConfig(this._repository);

  Future<Result<AppConfigEntity>> call() {
    return _repository.getAppConfig();
  }
}
