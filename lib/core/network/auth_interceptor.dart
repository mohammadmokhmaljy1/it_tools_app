import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/token_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  final TokenStorage _tokenStorage;
  final Dio _refreshDio;
  final VoidCallback? onSessionExpired;

  // TODO: تثبيت مسار التجديد وشكل الرد من صفحة API Reference عند جاهزية الـ Backend
  static const String _refreshEndpoint = '/auth/refresh';

  AuthInterceptor({
    required this._tokenStorage,
    required this._refreshDio,
    this.onSessionExpired,
  });

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final accessToken = await _tokenStorage.readAccessToken();

    if (accessToken != null && accessToken.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $accessToken';
    }

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    // منع محاولة التجديد أكثر من مرة لنفس الطلب
    if (err.requestOptions.extra['isRetry'] == true) {
      await _handleLogout();
      return handler.next(err);
    }

    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _handleLogout();
      return handler.next(err);
    }

    try {
      // محاولة واحدة لتجديد التوكن باستخدام نسخة Dio مستقلة
      final response = await _refreshDio.post(
        _refreshEndpoint,
        data: {'refresh_token': refreshToken},
      );

      final data = response.data as Map<String, dynamic>;
      final newAccessToken = data['access_token'] as String;
      final newRefreshToken =
          (data['refresh_token'] as String?) ?? refreshToken;

      await _tokenStorage.saveTokens(
        accessToken: newAccessToken,
        refreshToken: newRefreshToken,
      );

      // إعادة إرسال الطلب الأصلي بالتوكن الجديد
      final retryOptions = err.requestOptions;
      retryOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      retryOptions.extra['isRetry'] = true;

      final retryResponse = await _refreshDio.fetch(retryOptions);
      return handler.resolve(retryResponse);
    } catch (_) {
      // في حال فشل التجديد: مسح التوكن وتحويل المستخدم لزائر (Guest)
      await _handleLogout();
      return handler.next(err);
    }
  }

  Future<void> _handleLogout() async {
    await _tokenStorage.clear();
    onSessionExpired?.call();
  }
}
