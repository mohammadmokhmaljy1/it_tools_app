import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:it_tools_app/core/network/dio_client.dart';
import 'package:it_tools_app/core/utils/result.dart';

import '../../data/datasources/app_config_remote_datasource.dart';
import '../../data/repositories/app_config_repository_impl.dart';
import '../../domain/entities/app_config_entity.dart';
import '../../domain/repositories/app_config_repository.dart';
import '../../domain/usecases/get_app_config.dart';

const String _onboardingSeenKey = 'onboarding_seen';

final appConfigRemoteDataSourceProvider = Provider<AppConfigRemoteDataSource>((
  ref,
) {
  final dio = ref.watch(dioProvider);
  return AppConfigRemoteDataSourceImpl(dio);
});

final appConfigRepositoryProvider = Provider<AppConfigRepository>((ref) {
  final dataSource = ref.watch(appConfigRemoteDataSourceProvider);
  return AppConfigRepositoryImpl(dataSource);
});

final getAppConfigUseCaseProvider = Provider<GetAppConfig>((ref) {
  final repository = ref.watch(appConfigRepositoryProvider);
  return GetAppConfig(repository);
});

final appConfigProvider = FutureProvider<AppConfigEntity?>((ref) async {
  final getAppConfig = ref.watch(getAppConfigUseCaseProvider);
  final result = await getAppConfig();

  return switch (result) {
    Success(:final data) => data,
    Error() => null,
  };
});

Future<bool> hasSeenOnboarding() async {
  final prefs = await SharedPreferences.getInstance();
  return prefs.getBool(_onboardingSeenKey) ?? false;
}

Future<void> setOnboardingSeen() async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setBool(_onboardingSeenKey, true);
}
