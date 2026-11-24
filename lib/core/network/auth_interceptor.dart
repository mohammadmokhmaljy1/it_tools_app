import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/token_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  final TokenStorage _tokenStorage;
  final Dio _refreshDio;
  final VoidCallback? onSessionExpired;

  /// عقد تجديد الجلسة الموثّق في API Reference
  static const String refreshEndpoint = '/auth/refresh';
  static const String tokenExpiredCode = 'TOKEN_EXPIRED';
  static const String invalidRefreshTokenCode = 'INVALID_REFRESH_TOKEN';

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

    final errorCode = _extractErrorCode(err.response?.data);
    if (errorCode == invalidRefreshTokenCode) {
      await _handleLogout();
      return handler.next(err);
    }

    // منع محاولة التجديد أكثر من مرة لنفس الطلب
    if (err.requestOptions.extra['isRetry'] == true) {
      await _handleLogout();
      return handler.next(err);
    }

    // معالجة طلبات 401 المتزامنة:
    // إذا كان طلب سابق في الطابور قد جدّد التوكن وحفظه بالفعل، نعيد إرسال هذا الطلب بالتوكن الجديد مباشرةً
    final failedAuthHeader =
        err.requestOptions.headers['Authorization'] as String?;
    final failedToken = failedAuthHeader?.replaceFirst('Bearer ', '');
    final latestAccessToken = await _tokenStorage.readAccessToken();

    if (latestAccessToken != null &&
        latestAccessToken.isNotEmpty &&
        latestAccessToken != failedToken) {
      return _retryRequest(err.requestOptions, latestAccessToken, handler, err);
    }

    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      await _handleLogout();
      return handler.next(err);
    }

    try {
      // طلب تجديد واحد فقط باستخدام نسخة Dio مستقلة (Token Rotation)
      final response = await _refreshDio.post<dynamic>(
        refreshEndpoint,
        data: {'refreshToken': refreshToken},
      );

      final tokens = _parseRefreshTokens(response.data, refreshToken);
      if (tokens == null) {
        await _handleLogout();
        return handler.next(err);
      }

      // حفظ الزوج الجديد (accessToken + refreshToken)؛ في حال فشل التخزين نُنهي الجلسة بأمان
      await _tokenStorage.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );

      return await _retryRequest(
        err.requestOptions,
        tokens.accessToken,
        handler,
        err,
      );
    } catch (_) {
      // عند فشل التجديد أو فشل التخزين: مسح التوكن وتحويل المستخدم لزائر (Guest)
      await _handleLogout();
      return handler.next(err);
    }
  }

  Future<void> _retryRequest(
    RequestOptions requestOptions,
    String newAccessToken,
    ErrorInterceptorHandler handler,
    DioException originalError,
  ) async {
    try {
      requestOptions.headers['Authorization'] = 'Bearer $newAccessToken';
      requestOptions.extra['isRetry'] = true;

      final retryResponse = await _refreshDio.fetch<dynamic>(requestOptions);
      return handler.resolve(retryResponse);
    } on DioException catch (retryError) {
      return handler.next(retryError);
    } catch (_) {
      return handler.next(originalError);
    }
  }

  String? _extractErrorCode(dynamic responseData) {
    if (responseData is Map<String, dynamic>) {
      final error = responseData['error'];
      if (error is Map<String, dynamic>) {
        return error['code'] as String?;
      }
      return responseData['code'] as String?;
    }
    return null;
  }

  ({String accessToken, String refreshToken})? _parseRefreshTokens(
    dynamic responseData,
    String fallbackRefreshToken,
  ) {
    if (responseData is! Map<String, dynamic>) return null;

    final payload = responseData['data'] is Map<String, dynamic>
        ? responseData['data'] as Map<String, dynamic>
        : responseData;

    final accessToken =
        (payload['accessToken'] ?? payload['access_token']) as String?;
    if (accessToken == null || accessToken.isEmpty) return null;

    final refreshToken =
        (payload['refreshToken'] ?? payload['refresh_token']) as String? ??
        fallbackRefreshToken;

    return (accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> _handleLogout() async {
    await _tokenStorage.clear();
    onSessionExpired?.call();
  }
}
