import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

import '../storage/token_storage.dart';

class AuthInterceptor extends QueuedInterceptor {
  final TokenStorage _tokenStorage;
  final Dio _refreshDio;
  final VoidCallback? onSessionExpired;
  String? _lastExpiredToken;
  String? _lastRotatedToken;

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
    if (options.uri.origin != Uri.parse(_refreshDio.options.baseUrl).origin) {
      return handler.next(options);
    }
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
    final request = err.requestOptions;
    final authorization = request.headers['Authorization'];
    if (errorCode != tokenExpiredCode ||
        request.uri.origin != Uri.parse(_refreshDio.options.baseUrl).origin ||
        authorization is! String ||
        !authorization.startsWith('Bearer ') ||
        request.data is Stream ||
        request.data is FormData) {
      return handler.next(err);
    }

    final failedToken = authorization.substring('Bearer '.length);
    final latestAccessToken = await _tokenStorage.readAccessToken();
    if (latestAccessToken == null || latestAccessToken.isEmpty) {
      return handler.next(err);
    }
    if (latestAccessToken != failedToken) {
      if (failedToken == _lastExpiredToken &&
          latestAccessToken == _lastRotatedToken) {
        return _retryRequest(request, latestAccessToken, handler, err);
      }
      return handler.next(err);
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

      final tokens = _parseRefreshTokens(response.data);
      if (await _tokenStorage.readAccessToken() != failedToken) {
        return handler.next(err);
      }
      if (tokens == null) {
        await _handleLogout();
        return handler.next(err);
      }

      // حفظ الزوج الجديد (accessToken + refreshToken)؛ في حال فشل التخزين نُنهي الجلسة بأمان
      await _tokenStorage.saveTokens(
        accessToken: tokens.accessToken,
        refreshToken: tokens.refreshToken,
      );

      _lastExpiredToken = failedToken;
      _lastRotatedToken = tokens.accessToken;
      return await _retryRequest(
        err.requestOptions,
        tokens.accessToken,
        handler,
        err,
      );
    } on DioException catch (refreshError) {
      if (_extractErrorCode(refreshError.response?.data) ==
              invalidRefreshTokenCode &&
          await _tokenStorage.readAccessToken() == failedToken) {
        await _handleLogout();
      }
      return handler.next(err);
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
      final retryOptions = requestOptions.copyWith(
        headers: {
          ...requestOptions.headers,
          'Authorization': 'Bearer $newAccessToken',
        },
      );
      final retryResponse = await _refreshDio.fetch<dynamic>(retryOptions);
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
        final code = error['code'];
        return code is String ? code : null;
      }
      final code = responseData['code'];
      return code is String ? code : null;
    }
    return null;
  }

  ({String accessToken, String refreshToken})? _parseRefreshTokens(
    dynamic responseData,
  ) {
    if (responseData is! Map<String, dynamic>) return null;

    final payload = responseData['data'] is Map<String, dynamic>
        ? responseData['data'] as Map<String, dynamic>
        : responseData;

    final accessToken = payload['accessToken'];
    final refreshToken = payload['refreshToken'];
    if (accessToken is! String ||
        accessToken.isEmpty ||
        refreshToken is! String ||
        refreshToken.isEmpty) {
      return null;
    }

    return (accessToken: accessToken, refreshToken: refreshToken);
  }

  Future<void> _handleLogout() async {
    _lastExpiredToken = null;
    _lastRotatedToken = null;
    await _tokenStorage.clear();
    onSessionExpired?.call();
  }
}
