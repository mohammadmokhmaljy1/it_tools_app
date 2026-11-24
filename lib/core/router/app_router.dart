import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/auth/presentation/pages/login_page.dart';
import '../auth/auth_status_provider.dart';
import 'app_routes.dart';

GoRouter createAppRouter(AuthStatusNotifier authNotifier) {
  return GoRouter(
    initialLocation: AppRoutes.home,
    refreshListenable: authNotifier,
    redirect: (BuildContext context, GoRouterState state) async {
      await authNotifier.initialized;
      final currentPath = state.uri.path;
      final isGuest = authNotifier.isGuest;
      final isGoingToLogin = currentPath == AppRoutes.login;

      if (isGuest && AppRoutes.isProtected(currentPath)) {
        final fromLocation = Uri.encodeComponent(state.uri.toString());
        return '${AppRoutes.login}?from=$fromLocation';
      }

      if (!isGuest && isGoingToLogin) {
        final fromParam = state.uri.queryParameters['from'];
        final destination = fromParam == null ? null : Uri.tryParse(fromParam);
        if (destination != null &&
            !destination.hasScheme &&
            !destination.hasAuthority &&
            AppRoutes.isProtected(destination.path)) {
          return destination.toString();
        }
        return AppRoutes.home;
      }

      return null;
    },
    routes: [
      StatefulShellRoute.indexedStack(
        builder: (context, state, navigationShell) {
          return Scaffold(
            body: navigationShell,
            bottomNavigationBar: NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              destinations: const [
                NavigationDestination(
                  icon: Icon(Icons.home_outlined),
                  selectedIcon: Icon(Icons.home),
                  label: 'الرئيسية',
                ),
                NavigationDestination(
                  icon: Icon(Icons.category_outlined),
                  selectedIcon: Icon(Icons.category),
                  label: 'التصنيفات',
                ),
                NavigationDestination(
                  icon: Icon(Icons.shopping_cart_outlined),
                  selectedIcon: Icon(Icons.shopping_cart),
                  label: 'السلة',
                ),
                NavigationDestination(
                  icon: Icon(Icons.favorite_border),
                  selectedIcon: Icon(Icons.favorite),
                  label: 'المفضلة',
                ),
                NavigationDestination(
                  icon: Icon(Icons.person_outline),
                  selectedIcon: Icon(Icons.person),
                  label: 'حسابي',
                ),
              ],
            ),
          );
        },
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.home,
                builder: (context, state) => const _TabPage(title: 'الرئيسية'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.categories,
                builder: (context, state) => const _TabPage(title: 'التصنيفات'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.cart,
                builder: (context, state) => const _TabPage(title: 'السلة'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.favorites,
                builder: (context, state) => const _TabPage(title: 'المفضلة'),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.profile,
                builder: (context, state) => const _TabPage(title: 'حسابي'),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('إتمام الطلب'))),
      ),
      GoRoute(
        path: AppRoutes.orders,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('طلباتي'))),
      ),
      GoRoute(
        path: AppRoutes.editProfile,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('تعديل الحساب'))),
      ),
      GoRoute(
        path: AppRoutes.ratings,
        builder: (context, state) =>
            const Scaffold(body: Center(child: Text('التقييم'))),
      ),
    ],
  );
}

class _TabPage extends StatelessWidget {
  final String title;

  const _TabPage({required this.title});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(title, style: Theme.of(context).textTheme.headlineSmall),
    );
  }
}

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authStatusProvider);
  final router = createAppRouter(authNotifier);
  ref.onDispose(router.dispose);
  return router;
});
