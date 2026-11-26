import 'package:it_tools_app/core/utils/result.dart';

import '../../domain/entities/app_config_entity.dart';
import '../../domain/repositories/app_config_repository.dart';
import '../datasources/app_config_remote_datasource.dart';

class AppConfigRepositoryImpl implements AppConfigRepository {
  final AppConfigRemoteDataSource _remoteDataSource;

  const AppConfigRepositoryImpl(this._remoteDataSource);

  @override
  Future<Result<AppConfigEntity>> getAppConfig() {
    return _remoteDataSource.getAppConfig();
  }
}
