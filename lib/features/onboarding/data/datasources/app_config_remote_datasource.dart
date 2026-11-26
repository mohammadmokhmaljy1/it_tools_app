import 'package:dio/dio.dart';

import 'package:it_tools_app/core/errors/failure.dart';
import 'package:it_tools_app/core/network/error_mapper.dart';
import 'package:it_tools_app/core/utils/result.dart';

import '../models/app_config_model.dart';

abstract interface class AppConfigRemoteDataSource {
  Future<Result<AppConfigModel>> getAppConfig();
}

class AppConfigRemoteDataSourceImpl implements AppConfigRemoteDataSource {
  final Dio _dio;

  const AppConfigRemoteDataSourceImpl(this._dio);

  @override
  Future<Result<AppConfigModel>> getAppConfig() {
    return guardRequest(() async {
      final response = await _dio.get<Map<String, dynamic>>('/app/config');
      final body = response.data ?? const <String, dynamic>{};
      final rawData = body['data'];

      if (rawData is! Map<String, dynamic>) {
        throw const ServerFailure();
      }

      return AppConfigModel.fromJson(rawData);
    });
  }
}
