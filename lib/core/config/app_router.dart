import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/widgets/custom_bottom_nav_bar.dart';
import 'package:it_tools_app/core/widgets/no_internet_view.dart';
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

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String productList = '/product-list';
  static const String cart = '/cart';
  static const String favorites = '/favorites';
  static const String profile = '/profile';
  static const String search = '/search';
  static const String checkout = '/checkout';
  static const String orderSuccess = '/order-success';
  static const String noInternet = '/no-internet';
  static const String productDetails = '/product-details';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(path: splash, builder: (context, state) => const SplashScreen()),
      GoRoute(
        path: onboarding,
        builder: (context, state) => const OnboardingScreen(),
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
          body: const Center(child: Text('حسابي - قيد التجهيز')),
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
        path: checkout,
        name: 'checkout',
        builder: (context, state) => const CheckoutPage(),
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
