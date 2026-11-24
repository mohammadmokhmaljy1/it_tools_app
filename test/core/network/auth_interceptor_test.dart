import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:it_tools_app/core/network/auth_interceptor.dart';
import 'package:it_tools_app/core/network/dio_client.dart';
import 'package:it_tools_app/core/storage/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

class MockHttpAdapter implements HttpClientAdapter {
  final Future<ResponseBody> Function(RequestOptions options) handler;
  MockHttpAdapter(this.handler);

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<List<int>>? requestStream,
    Future<void>? cancelFuture,
  ) => handler(options);

  @override
  void close({bool force = false}) {}
}

void main() {
  late MockFlutterSecureStorage mockSecureStorage;
  late TokenStorage tokenStorage;
  late Map<String, String> memoryStore;

  setUp(() {
    memoryStore = {};
    mockSecureStorage = MockFlutterSecureStorage();

    when(() => mockSecureStorage.read(key: any(named: 'key'))).thenAnswer(
      (inv) async => memoryStore[inv.namedArguments[#key] as String],
    );
    when(
      () => mockSecureStorage.write(
        key: any(named: 'key'),
        value: any(named: 'value'),
      ),
    ).thenAnswer((inv) async {
      final key = inv.namedArguments[#key] as String;
      final value = inv.namedArguments[#value] as String?;
      if (value == null) {
        memoryStore.remove(key);
      } else {
        memoryStore[key] = value;
      }
    });
    when(() => mockSecureStorage.delete(key: any(named: 'key'))).thenAnswer(
      (inv) async => memoryStore.remove(inv.namedArguments[#key] as String),
    );

    tokenStorage = TokenStorage(storage: mockSecureStorage);
  });

  group('DioClient & AuthInterceptor Tests', () {
    test('dioProvider registers AuthInterceptor on main Dio client', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      final dio = container.read(dioProvider);
      expect(dio.interceptors.whereType<AuthInterceptor>(), isNotEmpty);
    });

    test(
      'handles concurrent 401 requests with a single refresh call',
      () async {
        await tokenStorage.saveTokens(
          accessToken: 'expired_access',
          refreshToken: 'valid_refresh_1',
        );

        var refreshCallCount = 0;
        final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
        final refreshDio = Dio(BaseOptions(baseUrl: 'https://example.com'));

        Future<ResponseBody> adapter(RequestOptions options) async {
          if (options.path == AuthInterceptor.refreshEndpoint) {
            refreshCallCount++;
            expect(options.data, {'refreshToken': 'valid_refresh_1'});
            return ResponseBody.fromString(
              '{"data": {"accessToken": "new_access_2", "refreshToken": "new_refresh_2"}}',
              200,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
          if (options.headers['Authorization'] == 'Bearer expired_access') {
            return ResponseBody.fromString(
              '{"error": {"code": "TOKEN_EXPIRED"}}',
              401,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
          return ResponseBody.fromString(
            '{"ok": true}',
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        dio.httpClientAdapter = MockHttpAdapter(adapter);
        refreshDio.httpClientAdapter = MockHttpAdapter(adapter);
        dio.interceptors.add(
          AuthInterceptor(tokenStorage: tokenStorage, refreshDio: refreshDio),
        );

        final results = await Future.wait([
          dio.get<dynamic>('/me'),
          dio.get<dynamic>('/cart'),
          dio.get<dynamic>('/orders'),
        ]);

        expect(results.every((r) => r.statusCode == 200), isTrue);
        expect(refreshCallCount, 1);
        expect(await tokenStorage.readAccessToken(), 'new_access_2');
        expect(await tokenStorage.readRefreshToken(), 'new_refresh_2');
      },
    );

    test('an unrelated 401 does not refresh or clear the session', () async {
      await tokenStorage.saveTokens(
        accessToken: 'access',
        refreshToken: 'refresh',
      );
      final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      final refreshDio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      addTearDown(() {
        dio.close();
        refreshDio.close();
      });
      var refreshCalls = 0;
      refreshDio.httpClientAdapter = MockHttpAdapter((_) async {
        refreshCalls++;
        return ResponseBody.fromString('{}', 500);
      });
      dio.httpClientAdapter = MockHttpAdapter(
        (_) async => ResponseBody.fromString(
          '{"error":{"code":"UNAUTHORIZED"}}',
          401,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        ),
      );
      dio.interceptors.add(
        AuthInterceptor(tokenStorage: tokenStorage, refreshDio: refreshDio),
      );

      await expectLater(dio.get<dynamic>('/me'), throwsA(isA<DioException>()));
      expect(refreshCalls, 0);
      expect(await tokenStorage.readRefreshToken(), 'refresh');
    });

    test('handles storage read and write failures gracefully', () async {
      // 1. فشل قراءة التخزين لا يُسقط الطلب العام
      when(() => mockSecureStorage.read(key: any(named: 'key')))
          .thenThrow(Exception('Storage read error'));

      final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      final refreshDio = Dio(BaseOptions(baseUrl: 'https://example.com'));
      dio.httpClientAdapter = MockHttpAdapter(
        (_) async => ResponseBody.fromString('{"ok": true}', 200),
      );
      dio.interceptors.add(
        AuthInterceptor(tokenStorage: tokenStorage, refreshDio: refreshDio),
      );

      final publicRes = await dio.get<dynamic>('/products');
      expect(publicRes.statusCode, 200);

      // 2. فشل كتابة التوكن الجديد عند التجديد يُنهي الجلسة بأمان
      when(() => mockSecureStorage.read(key: any(named: 'key'))).thenAnswer(
        (inv) async => memoryStore[inv.namedArguments[#key] as String],
      );
      await tokenStorage.saveTokens(
        accessToken: 'expired_access',
        refreshToken: 'valid_refresh',
      );
      when(
        () => mockSecureStorage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenThrow(Exception('Storage write error'));

      var sessionExpiredCalled = false;
      final dio2 = Dio(BaseOptions(baseUrl: 'https://example.com'));
      final refreshDio2 = Dio(BaseOptions(baseUrl: 'https://example.com'));

      Future<ResponseBody> failWriteAdapter(RequestOptions options) async {
        if (options.path == AuthInterceptor.refreshEndpoint) {
          return ResponseBody.fromString(
            '{"accessToken": "new_access", "refreshToken": "new_refresh"}',
            200,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }
        return ResponseBody.fromString(
          '{"error": {"code": "TOKEN_EXPIRED"}}',
          401,
          headers: {
            Headers.contentTypeHeader: [Headers.jsonContentType],
          },
        );
      }

      dio2.httpClientAdapter = MockHttpAdapter(failWriteAdapter);
      refreshDio2.httpClientAdapter = MockHttpAdapter(failWriteAdapter);
      dio2.interceptors.add(
        AuthInterceptor(
          tokenStorage: tokenStorage,
          refreshDio: refreshDio2,
          onSessionExpired: () => sessionExpiredCalled = true,
        ),
      );

      await expectLater(dio2.get<dynamic>('/me'), throwsA(isA<DioException>()));
      expect(sessionExpiredCalled, isTrue);
      expect(await tokenStorage.readAccessToken(), isNull);
    });

    test(
      'clears tokens and calls onSessionExpired when refresh fails',
      () async {
        await tokenStorage.saveTokens(
          accessToken: 'expired_access',
          refreshToken: 'revoked_refresh',
        );

        var sessionExpiredCalled = false;
        final dio = Dio(BaseOptions(baseUrl: 'https://example.com'));
        final refreshDio = Dio(BaseOptions(baseUrl: 'https://example.com'));

        Future<ResponseBody> adapter(RequestOptions options) async {
          if (options.path == AuthInterceptor.refreshEndpoint) {
            return ResponseBody.fromString(
              '{"error": {"code": "INVALID_REFRESH_TOKEN"}}',
              401,
              headers: {
                Headers.contentTypeHeader: [Headers.jsonContentType],
              },
            );
          }
          return ResponseBody.fromString(
            '{"error": {"code": "TOKEN_EXPIRED"}}',
            401,
            headers: {
              Headers.contentTypeHeader: [Headers.jsonContentType],
            },
          );
        }

        dio.httpClientAdapter = MockHttpAdapter(adapter);
        refreshDio.httpClientAdapter = MockHttpAdapter(adapter);
        dio.interceptors.add(
          AuthInterceptor(
            tokenStorage: tokenStorage,
            refreshDio: refreshDio,
            onSessionExpired: () => sessionExpiredCalled = true,
          ),
        );

        await expectLater(
          dio.get<dynamic>('/me'),
          throwsA(isA<DioException>()),
        );
        expect(sessionExpiredCalled, isTrue);
        expect(await tokenStorage.readAccessToken(), isNull);
        expect(await tokenStorage.readRefreshToken(), isNull);
      },
    );
  });
}
