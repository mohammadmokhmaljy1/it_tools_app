import 'package:dio/dio.dart';

import 'package:it_tools_app/core/errors/failure.dart';
import 'package:it_tools_app/core/utils/result.dart';

Failure mapDioException(DioException e) {
  switch (e.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
    case DioExceptionType.transformTimeout:
    case DioExceptionType.connectionError:
      return const NetworkFailure();
    case DioExceptionType.badResponse:
      final statusCode = e.response?.statusCode;
      switch (statusCode) {
        case 401:
          return const UnauthorizedFailure();
        case 404:
          return const NotFoundFailure();
        case 422:
          return const ValidationFailure();
        default:
          return ServerFailure(statusCode: statusCode);
      }

    case DioExceptionType.cancel:
    case DioExceptionType.badCertificate:
    case DioExceptionType.unknown:
      return const NetworkFailure();
  }
}

Future<Result<T>> guardRequest<T>(Future<T> Function() call) async {
  try {
    final data = await call();
    return Success<T>(data);
  } on DioException catch (e) {
    return Error<T>(mapDioException(e));
  } catch (_) {
    return Error<T>(UnknownFailure());
  }
}
