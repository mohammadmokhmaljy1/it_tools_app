import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:it_tools_app/core/network/error_mapper.dart';
import 'package:it_tools_app/core/network/failure.dart';
import 'package:it_tools_app/core/network/result.dart';

void main() {
  group('mapDioException', () {
    final requestOptions = RequestOptions(path: '/test');

    test('connection error returns NetworkFailure', () {
      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionError,
      );

      expect(mapDioException(exception), isA<NetworkFailure>());
    });

    test('timeout returns NetworkFailure', () {
      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.connectionTimeout,
      );

      expect(mapDioException(exception), isA<NetworkFailure>());
    });

    test('401 returns UnauthorizedFailure', () {
      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 401,
        ),
      );

      expect(mapDioException(exception), isA<UnauthorizedFailure>());
    });

    test('404 returns NotFoundFailure', () {
      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 404,
        ),
      );

      expect(mapDioException(exception), isA<NotFoundFailure>());
    });

    test('422 returns ValidationFailure', () {
      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 422,
        ),
      );

      expect(mapDioException(exception), isA<ValidationFailure>());
    });

    test('500 returns ServerFailure', () {
      final exception = DioException(
        requestOptions: requestOptions,
        type: DioExceptionType.badResponse,
        response: Response(
          requestOptions: requestOptions,
          statusCode: 500,
        ),
      );

      expect(mapDioException(exception), isA<ServerFailure>());
    });
  });

  group('guardRequest', () {
    test('returns Success when request succeeds', () async {
      final result = await guardRequest<String>(() async => 'Success');

      expect(result, isA<Success<String>>());
      expect((result as Success<String>).data, 'Success');
    });

    test('returns Error when request throws DioException', () async {
      final result = await guardRequest<String>(() async {
        throw DioException(
          requestOptions: RequestOptions(path: '/test'),
          type: DioExceptionType.connectionError,
        );
      });

      expect(result, isA<Error<String>>());
      expect(
        (result as Error<String>).failure,
        isA<NetworkFailure>(),
      );
    });
  });
}