import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../config/app_config.dart';
import '../storage/token_storage.dart';
import 'auth_interceptor.dart';

final tokenStorageProvider = Provider<TokenStorage>((ref) {
  return TokenStorage();
});

final sessionExpiredCallbackProvider = Provider<VoidCallback?>((ref) => null);

final dioProvider = Provider<Dio>((ref) {
  final baseOptions = BaseOptions(
    baseUrl: AppConfig.apiBaseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    headers: {'Accept': 'application/json', 'Accept-Language': 'ar'},
  );

  final client = Dio(baseOptions);
  final refreshDio = Dio(baseOptions);

  final tokenStorage = ref.watch(tokenStorageProvider);
  final onSessionExpired = ref.watch(sessionExpiredCallbackProvider);

  client.interceptors.add(
    AuthInterceptor(
      tokenStorage: tokenStorage,
      refreshDio: refreshDio,
      onSessionExpired: onSessionExpired,
    ),
  );

  if (kDebugMode) {
    client.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: false,
        requestBody: false,
        responseHeader: false,
        responseBody: false,
        error: false,
      ),
    );
  }

  ref.onDispose(() {
    client.close(force: true);
    refreshDio.close(force: true);
  });

  return client;
});
