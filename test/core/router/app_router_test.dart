import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:it_tools_app/core/auth/auth_status_provider.dart';
import 'package:it_tools_app/core/router/app_router.dart';
import 'package:it_tools_app/core/storage/token_storage.dart';
import 'package:mocktail/mocktail.dart';

class MockTokenStorage extends Mock implements TokenStorage {}

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
    ).thenAnswer((_) async {});
    when(() => mockStorage.clear()).thenAnswer((_) async {});

    authNotifier = AuthStatusNotifier(mockStorage);
  });

  group('AppRouter Guest Protection Tests', () {
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

          expect(find.text('تسجيل الدخول'), findsOneWidget);
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
        // محاكاة وجود عناصر في سلة الزائر قبل تسجيل الدخول
        final guestCartItems = ['Arduino Uno R3', 'Multimeter Digital'];

        await tester.pumpWidget(MaterialApp.router(routerConfig: router));
        await tester.pumpAndSettle();

        // محاولة الزائر فتح صفحة إتمام الطلب المحمية
        router.go(AppRoutes.checkout);
        await tester.pumpAndSettle();

        expect(find.text('تسجيل الدخول'), findsOneWidget);
        expect(
          router.routerDelegate.currentConfiguration.uri.toString(),
          '/login?from=%2Fcheckout',
        );

        // محاكاة تسجيل الدخول بنجاح
        await authNotifier.setAuthenticated(
          accessToken: 'valid_token',
          refreshToken: 'valid_refresh_token',
        );
        await tester.pumpAndSettle();

        // 1. التحقق من إرجاعه تلقائياً إلى صفحة إتمام الطلب
        expect(find.text('إتمام الطلب'), findsOneWidget);
        // 2. التحقق من بقاء عناصر السلة محفوظة وعدم مسحها
        expect(guestCartItems, hasLength(2));
        expect(guestCartItems, contains('Arduino Uno R3'));
      },
    );
  });
}
