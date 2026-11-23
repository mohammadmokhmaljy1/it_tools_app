class AppRoutes {
  AppRoutes._();

  // Main navigation tabs
  static const String home = '/';
  static const String categories = '/categories';
  static const String cart = '/cart';
  static const String favorites = '/favorites';
  static const String profile = '/profile';

  // Authentication
  static const String login = '/login';

  // Other screens
  static const String checkout = '/checkout';
  static const String orders = '/orders';
  static const String editProfile = '/profile/edit';
  static const String ratings = '/ratings';

  // Routes that require authentication
  static const Set<String> protectedRoutes = {
    checkout,
    orders,
    favorites,
    editProfile,
    ratings,
  };

  static bool isProtected(String location) {
    return protectedRoutes.any(
      (route) => location == route || location.startsWith('$route/'),
    );
  }
}
