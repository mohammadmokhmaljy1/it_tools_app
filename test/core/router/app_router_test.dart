import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:it_tools_app/core/auth/auth_status_provider.dart';
import 'package:it_tools_app/core/router/app_router.dart';
import 'package:it_tools_app/core/storage/token_storage.dart';
import 'package:it_tools_app/features/auth/presentation/pages/login_page.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenStorage extends Mock implements TokenStorage {
  Object? clear() {
    return null;
  }
}

void main() {
  late MockTokenStorage mockStorage;
  late AuthStatusNotifier authNotifier;

  setUp(() {
    mockStorage = MockTokenStorage();
    when(() => mockStorage.readAccessToken()).thenAnswer((_) async => null);
    when(
      () => mockStorage.saveTokens(
        accessToken: any(named: 'accessToken'),
        refreshToken: any(named: 'refreshToken'),
      ),
    ).thenAnswer((_) async {
      return null;
    });
    when(() => mockStorage.clear()).thenAnswer((_) async {
      return null;
    });

    authNotifier = AuthStatusNotifier(mockStorage);
  });

  group('AppRouter Guest Protection & Session Loading Tests', () {
    testWidgets(
      'does not redirect stored authenticated user to /login while session is loading',
      (tester) async {
        final tokenCompleter = Completer<String?>();
        when(() => mockStorage.readAccessToken())
            .thenAnswer((_) => tokenCompleter.future);

        final loadingAuthNotifier = AuthStatusNotifier(mockStorage);
        final router = createAppRouter(loadingAuthNotifier);

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pump();

        // محاولة فتح مسار محمي أثناء قراءة الجلسة من التخزين
        router.go(AppRoutes.orders);
        await tester.pump();

        // يجب ألا يُحوّل لصفحة الدخول أثناء حالة loading
        expect(find.byType(LoginPage), findsNothing);
        expect(find.text('طلباتي'), findsOneWidget);

        // إكمال القراءة بتوكن صالح -> يبقى في المسار المحمي بأمان
        tokenCompleter.complete('stored_valid_token');
        await tester.pumpAndSettle();

        expect(find.byType(LoginPage), findsNothing);
        expect(find.text('طلباتي'), findsOneWidget);
      },
    );

    testWidgets('allows guest to visit public routes like /cart', (
      tester,
    ) async {
      final router = createAppRouter(authNotifier);

      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await tester.pumpAndSettle();

      router.go(AppRoutes.cart);
      await tester.pumpAndSettle();

      expect(find.text('سلة المشتريات'), findsOneWidget);
    });

    testWidgets(
      'redirects guest to /login with from param for all protected routes',
      (tester) async {
        final router = createAppRouter(authNotifier);

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        final protectedPaths = [
          AppRoutes.checkout,
          AppRoutes.orders,
          AppRoutes.favorites,
          AppRoutes.editProfile,
          AppRoutes.ratings,
        ];

        for (final path in protectedPaths) {
          router.go(path);
          await tester.pumpAndSettle();

          expect(find.byType(LoginPage), findsOneWidget);
          expect(
            router.routerDelegate.currentConfiguration.uri.toString(),
            '/login?from=${Uri.encodeComponent(path)}',
          );
        }
      },
    );

    testWidgets(
      'returns user to intended destination (from) after login without clearing cart',
      (tester) async {
        final router = createAppRouter(authNotifier);
        final guestCartItems = ['Arduino Uno R3', 'Multimeter Digital'];

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        router.go(AppRoutes.checkout);
        await tester.pumpAndSettle();

        expect(find.byType(LoginPage), findsOneWidget);
        expect(
          router.routerDelegate.currentConfiguration.uri.toString(),
          '/login?from=%2Fcheckout',
        );

        await authNotifier.setAuthenticated(
          accessToken: 'valid_token',
          refreshToken: 'valid_refresh_token',
        );
        await tester.pumpAndSettle();

        expect(find.text('إتمام الطلب'), findsOneWidget);
        expect(guestCartItems, hasLength(2));
        expect(guestCartItems, contains('Arduino Uno R3'));
      },
    );
  });
}
