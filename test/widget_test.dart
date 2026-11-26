import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:it_tools_app/app/app.dart';
import 'package:it_tools_app/core/auth/auth_status_provider.dart';
import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/features/auth/presentation/pages/login_page.dart';
import 'package:it_tools_app/features/auth/presentation/pages/register_page.dart';
import 'package:it_tools_app/features/cart/presentation/pages/cart_page.dart';
import 'package:it_tools_app/features/checkout/presentation/pages/checkout_page.dart';
import 'package:it_tools_app/features/onboarding/presentation/providers/app_config_provider.dart';
import 'package:it_tools_app/features/orders/presentation/pages/orders_page.dart';

import 'package:it_tools_app/features/home/presentation/pages/home_screen.dart';
import 'package:it_tools_app/features/onboarding/presentation/pages/onboarding_screen.dart';

void main() {
  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
    SharedPreferences.setMockInitialValues({'onboarding_seen': true});
  });

  for (final seenOnboarding in [false, true]) {
    testWidgets(
      'startup uses local onboarding state ($seenOnboarding) while config loads',
      (tester) async {
        SharedPreferences.setMockInitialValues({
          'onboarding_seen': seenOnboarding,
        });
        final pendingConfig = Completer<Never>();
        final container = ProviderContainer(
          overrides: [
            appConfigProvider.overrideWith((ref) => pendingConfig.future),
          ],
        );
        addTearDown(container.dispose);
        await tester.pumpWidget(
          UncontrolledProviderScope(
            container: container,
            child: const ITToolsApp(),
          ),
        );

        await tester.pumpAndSettle();
        await tester.pump(const Duration(seconds: 3));
        await tester.pumpAndSettle();
        expect(
          find.byType(seenOnboarding ? HomeScreen : OnboardingScreen),
          findsOneWidget,
        );
      },
    );
  }

  testWidgets('ITToolsApp opens login and registration routes', (
    WidgetTester tester,
  ) async {
    final container = ProviderContainer(
      overrides: [appConfigProvider.overrideWith((ref) async => null)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ITToolsApp(),
      ),
    );
    final router = container.read(storeRouterProvider);
    expect(find.byType(MaterialApp), findsOneWidget);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    router.go(AppRouter.checkout);
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);

    expect(
      router.routerDelegate.currentConfiguration.uri.queryParameters['from'],
      AppRouter.checkout,
    );
    router.go(AppRouter.register);
    await tester.pumpAndSettle();
    expect(find.byType(RegisterPage), findsOneWidget);

    router.go(AppRouter.cart);
    await tester.pumpAndSettle();
    final cartState = tester.state(find.byType(CartPage));

    router.push<void>(AppRouter.checkout);
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);

    await container
        .read(authStatusProvider)
        .setAuthenticated(
          accessToken: 'test-access',
          refreshToken: 'test-refresh',
        );
    await tester.pumpAndSettle();
    expect(find.byType(CheckoutPage), findsOneWidget);

    router.pop();
    await tester.pumpAndSettle();
    expect(tester.state(find.byType(CartPage)), same(cartState));
  });

  testWidgets('orders require a session and open the selected details', (
    tester,
  ) async {
    final container = ProviderContainer(
      overrides: [appConfigProvider.overrideWith((ref) async => null)],
    );
    addTearDown(container.dispose);
    await tester.pumpWidget(
      UncontrolledProviderScope(
        container: container,
        child: const ITToolsApp(),
      ),
    );
    final router = container.read(storeRouterProvider);

    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    router.go(AppRouter.orders);
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);

    await container
        .read(authStatusProvider)
        .setAuthenticated(
          accessToken: 'test-access',
          refreshToken: 'test-refresh',
        );
    await tester.pumpAndSettle();
    expect(find.byType(OrdersPage), findsOneWidget);

    await tester.tap(find.text('التفاصيل').first);
    await tester.pumpAndSettle();
    expect(find.text('طلب #10482'), findsOneWidget);
    expect(tester.takeException(), isNull);

    router.go('${AppRouter.ratings}/10482');
    await tester.pumpAndSettle();
    expect(find.text('التقييم متاح للطلبات المكتملة فقط'), findsOneWidget);

    router.go('${AppRouter.orders}/10480');
    await tester.pumpAndSettle();
    final rateButton = find.text('قيّم مشترياتك');
    await tester.ensureVisible(rateButton);
    await tester.tap(rateButton);
    await tester.pumpAndSettle();
    expect(find.text('ماوس لاسلكي صامت M331'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
