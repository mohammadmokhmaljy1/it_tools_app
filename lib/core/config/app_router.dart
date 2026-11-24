import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/widgets/custom_bottom_nav_bar.dart';
import 'package:it_tools_app/core/widgets/no_internet_view.dart';
import 'package:it_tools_app/features/auth/presentation/pages/login_page.dart';
import 'package:it_tools_app/features/auth/presentation/pages/register_page.dart';
import 'package:it_tools_app/features/cart/presentation/pages/cart_page.dart';
import 'package:it_tools_app/features/catalog/presentation/pages/product_details_page.dart';
import 'package:it_tools_app/features/categories/presentation/pages/categories_page.dart';
import 'package:it_tools_app/features/categories/presentation/pages/product_list_page.dart';
import 'package:it_tools_app/features/checkout/presentation/pages/checkout_page.dart';
import 'package:it_tools_app/features/checkout/presentation/pages/order_success_page.dart';
import 'package:it_tools_app/features/favorites/presentation/pages/favorites_page.dart';
import 'package:it_tools_app/features/search/presentation/pages/search_page.dart';
import 'package:it_tools_app/features/home/presentation/pages/home_screen.dart';

import 'package:it_tools_app/features/onboarding/presentation/pages/splash_screen.dart';
import 'package:it_tools_app/features/onboarding/presentation/pages/onboarding_screen.dart';

import '../auth/auth_status_provider.dart';

import '../../features/orders/presentation/models/order_preview.dart';
import '../../features/orders/presentation/pages/order_details_page.dart';
import '../../features/orders/presentation/pages/orders_page.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String productList = '/product-list';
  static const String cart = '/cart';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String orders = '/orders';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String noInternet = '/no-internet';
  static const String productDetails = '/product-details';

  static bool _isOrderPath(String path) =>
      path == orders || path.startsWith('$orders/');

  static bool _canResume(String path) => path == checkout || _isOrderPath(path);

  static GoRouter create(AuthStatusNotifier auth) => GoRouter(
    refreshListenable: auth,
    redirect: (_, state) async {
      final path = state.uri.path;
      final protected = _canResume(path) || path == orderSuccess;
      if (!protected && path != login) return null;

      await auth.initialized;
      if (protected && auth.isGuest) {
        return Uri(
          path: login,
          queryParameters: {'from': state.uri.toString()},
        ).toString();
      }
      if (path == login && auth.isAuthenticated) {
        final from = state.uri.queryParameters['from'];
        final destination = from == null ? null : Uri.tryParse(from);
        if (destination != null &&
            !destination.hasScheme &&
            !destination.hasAuthority &&
            _canResume(destination.path)) {
          return destination.toString();
        }
        return home;
      }
      return null;
    },
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
      ),
      GoRoute(
        path: login,
        builder: (context, state) {
          final route = ModalRoute.of(context);
          final destination = Uri.tryParse(
            state.uri.queryParameters['from'] ?? '',
          );
          if (destination == null ||
              destination.hasScheme ||
              destination.hasAuthority ||
              !_canResume(destination.path)) {
            return const LoginPage();
          }
          return ListenableBuilder(
            listenable: auth,
            child: const LoginPage(),
            builder: (context, child) {
              if (auth.isAuthenticated) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (context.mounted && route?.isCurrent == true) {
                    context.pushReplacement(destination.toString());
                  }
                });
              }
              return child!;
            },
          );
        },
      ),
      GoRoute(
        path: register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: '/home', // أو جعله المسار الافتتاحي '/' حسب هيكلة تطبيقكم
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),
      GoRoute(
        path: '/categories',
        name: 'categories',
        builder: (context, state) => const CategoriesPage(),
      ),
      GoRoute(
        path: cart,
        name: 'cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: favorites,
        name: 'favorites',
        builder: (context, state) => const FavoritesPage(),
      ),
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => Scaffold(
          body: Center(
            child: TextButton(
              onPressed: () => context.push(orders),
              child: const Text('طلباتي'),
            ),
          ),
          bottomNavigationBar: CustomBottomNavBar(
            currentIndex: 4,
            onTap: (index) {
              if (index == 0) context.go(AppRouter.home);
              if (index == 1) context.go(AppRouter.categories);
              if (index == 2) context.go(AppRouter.cart);
              if (index == 3) context.go(AppRouter.favorites);
              if (index == 4) context.go(AppRouter.profile);
            },
          ),
        ),
      ),

      GoRoute(
        path: productList,
        name: 'product-list',
        builder: (context, state) {
          final categoryName = state.extra as String? ?? 'ماوس';
          return ProductListPage(categoryName: categoryName);
        },
      ),
      GoRoute(
        path: search,
        name: 'search',
        builder: (context, state) => const SearchPage(),
      ),
      GoRoute(
        path: orders,
        builder: (context, state) => ListenableBuilder(
          listenable: auth,
          builder: (context, _) =>
              auth.isAuthenticated ? const OrdersPage() : const LoginPage(),
        ),
        routes: [
          GoRoute(
            path: ':id',
            builder: (context, state) {
              final order = OrderPreview.fromId(state.pathParameters['id']);
              return ListenableBuilder(
                listenable: auth,
                builder: (context, _) {
                  if (!auth.isAuthenticated) return const LoginPage();
                  if (order == null) {
                    return const Scaffold(
                      body: Center(child: Text('الطلب غير موجود')),
                    );
                  }
                  return OrderDetailsPage(order: order);
                },
              );
            },
          ),
        ],
      ),
      GoRoute(
        path: checkout,
        name: 'checkout',
        builder: (context, state) => ListenableBuilder(
          listenable: auth,
          builder: (context, _) =>
              auth.isAuthenticated ? const CheckoutPage() : const LoginPage(),
        ),
      ),
      GoRoute(
        path: orderSuccess,
        name: 'order-success',
        builder: (context, state) {
          final data = state.extra as Map<String, dynamic>?;
          return OrderSuccessPage(
            deliveryLabel:
                (data?['deliveryLabel'] as String?) ?? 'توصيل إلى حلب',
            totalAmount: (data?['totalAmount'] as double?) ?? 86.47,
          );
        },
      ),
      GoRoute(
        path: noInternet,
        name: 'no-internet',
        builder: (context, state) => NoInternetView(
          onRetry: () {
            if (context.canPop()) context.pop();
          },
        ),
      ),
      GoRoute(
        path: productDetails,
        name: 'product-details',
        builder: (context, state) {
          final product = state.extra as Map<String, dynamic>?;
          return ProductDetailsPage(product: product);
        },
      ),
    ],
  );
}

final storeRouterProvider = Provider<GoRouter>((ref) {
  final router = AppRouter.create(ref.watch(authStatusProvider));
  ref.onDispose(router.dispose);
  return router;
});
