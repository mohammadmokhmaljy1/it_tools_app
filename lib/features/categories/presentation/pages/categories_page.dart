import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/core/widgets/custom_bottom_nav_bar.dart';
import 'package:it_tools_app/features/categories/presentation/widgets/category/category_card.dart';
import 'package:it_tools_app/features/categories/presentation/widgets/category/category_search_bar.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final List<Map<String, String>> categoriesList = [
    {
      'title': 'ماوس',
      'count': '24 منتج',
      'image': 'assets/images/products/mouse_silent.png',
    },
    {
      'title': 'كيبورد',
      'count': '18 منتج',
      'image': 'assets/images/products/keyboard_mech.png',
    },
    {
      'title': 'سماعات',
      'count': '12 منتج',
      'image': 'assets/images/products/headset_gaming.png',
    },
    {
      'title': 'هب USB ووصلات',
      'count': '15 منتج',
      'image': 'assets/images/products/usb_hub.png',
    },
    {
      'title': 'ستاندات لابتوب',
      'count': '7 منتجات',
      'image': 'assets/images/products/stand_laptop.png',
    },
    {
      'title': 'قواعد تبريد',
      'count': '6 منتجات',
      'image': 'assets/images/products/cooling_pad.png',
    },
    {
      'title': 'ماوس باد',
      'count': '10 منتجات',
      'image': 'assets/images/products/mousepad_xl.png',
    },
    {
      'title': 'ستيكرات',
      'count': '30 منتج',
      'image': 'assets/images/products/stickers_dev.png',
    },
  ];

  String _searchQuery = '';

  List<Map<String, String>> get _filteredCategories {
    if (_searchQuery.trim().isEmpty) return categoriesList;
    return categoriesList
        .where((cat) => cat['title']!.contains(_searchQuery.trim()))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filteredCategories;

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 24),
              Text(
                'الأقسام',
                style: AppTextStyles.bodyLarge.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              CategorySearchBaar(
                onChanged: (val) => setState(() => _searchQuery = val),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: GridView.builder(
                  padding: const EdgeInsets.only(bottom: 24),
                  itemCount: filtered.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.85,
                  ),
                  itemBuilder: (context, index) {
                    final cat = filtered[index];
                    return CategoryCard(
                      title: cat['title']!,
                      productCount: cat['count']!,
                      imagePath: cat['image']!,
                      onTap: () {
                        context.push(
                          AppRouter.productList,
                          extra: cat['title'],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 1,
        onTap: (index) {
          if (index == 0) {
            context.go(AppRouter.home);
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
