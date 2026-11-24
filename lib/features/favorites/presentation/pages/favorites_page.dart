import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/core/widgets/custom_bottom_nav_bar.dart';
import 'package:it_tools_app/features/categories/presentation/widgets/product_list/product_grid_card.dart';
import 'package:it_tools_app/features/favorites/presentation/widgets/favorites/empty_favorites_view.dart';
import 'package:it_tools_app/features/favorites/presentation/widgets/favorites/favorites_mock_data.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  final List<Map<String, dynamic>> _favorites = FavoritesMockData.items;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _favorites.isEmpty
          ? AppColors.surface
          : AppColors.pageBg,

      body: SafeArea(
        child: Column(
          children: [
            // الشريط العلوي: المفضلة + العداد (يختفي العداد عند الفراغ كالتصميم)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'المفضلة',
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (_favorites.isNotEmpty)
                    Text(
                      '${_favorites.length} منتجات',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textTertiary,
                        fontSize: 13,
                      ),
                    ),
                ],
              ),
            ),

            // عرض الحالة الفارغة أو شبكة المنتجات
            Expanded(
              child: _favorites.isEmpty
                  ? const EmptyFavoritesView()
                  : GridView.builder(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                      itemCount: _favorites.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.64,
                          ),
                      itemBuilder: (context, index) {
                        final item = _favorites[index];
                        return ProductGridCard(
                          product: item,
                          onToggleFavorite: () {
                            setState(() {
                              FavoritesMockData.toggleFavorite(item);
                            });
                          },
                          onAddToCart: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'تمت إضافة "${item['name']}" للسلة',
                                ),
                                duration: const Duration(seconds: 1),
                              ),
                            );
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          if (index == 0) {
            // نحن أساساً في الهوم
          } else if (index == 1) {
            context.go(AppRouter.categories);
          } else if (index == 2) {
            context.go(AppRouter.cart);
          } else if (index == 3) {
            context.go(AppRouter.favorites);
          } else if (index == 4) {
            context.go(AppRouter.profile);
          }
        },
      ),
    );
  }
}
