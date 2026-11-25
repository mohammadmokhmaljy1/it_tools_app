import 'package:it_tools_app/core/utils/result.dart';

import '../entities/app_config_entity.dart';

abstract interface class AppConfigRepository {
  Future<Result<AppConfigEntity>> getAppConfig();
}
