// ignore_for_file: prefer_final_fields, unused_field

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/core/widgets/custom_bottom_nav_bar.dart';
import 'package:it_tools_app/features/home/presentation/widgets/banners/home_banner_slider.dart';
import 'package:it_tools_app/features/home/presentation/widgets/categories/home_categories_section.dart';
import 'package:it_tools_app/features/home/presentation/widgets/data/home_mock_data.dart';
import 'package:it_tools_app/features/home/presentation/widgets/home_loading_skeleton.dart';
import 'package:it_tools_app/features/home/presentation/widgets/products/home_products_grid.dart';
import 'package:it_tools_app/features/home/presentation/widgets/header/home_search_bar.dart';
import 'package:it_tools_app/features/home/presentation/widgets/header/home_top_bar.dart';
import 'package:it_tools_app/features/home/presentation/widgets/products/section_header_with_timer.dart';
import 'package:it_tools_app/features/home/presentation/widgets/banners/university_offer_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(milliseconds: 900), () {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: SafeArea(
        child: _isLoading
            ? const HomeLoadingSkeleton()
            : SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const HomeTopBar(),
                    const SizedBox(height: 16),
                    const HomeSearchBar(),
                    const SizedBox(height: 16),
                    const HomeBannerSlider(),
                    const SizedBox(height: 16),
                    const HomeCategoriesSection(),
                    const SizedBox(height: 16),
                    const UniversityOfferBanner(),
                    const SizedBox(height: 24),

                    // قسم عروض حصرية
                    const SectionHeaderWithTimer(title: 'عروض حصرية'),
                    const SizedBox(height: 12),
                    HomeProductsGrid(products: HomeMockData.dailyDeals),
                    const SizedBox(height: 24),

                    // قسم الأكثر مبيعاً
                    Directionality(
                      textDirection: TextDirection.rtl,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'الأكثر مبيعاً',
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: Color(0xFF02112C),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              context.push(
                                AppRouter.productList,
                                extra: 'الكل',
                              );
                            },

                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'عرض الكل',
                                  style: AppTextStyles.labelMedium.copyWith(
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                const Icon(
                                  Icons.arrow_forward_ios_rounded,
                                  size: 12,
                                  color: AppColors.blue,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    HomeProductsGrid(products: HomeMockData.bestSellers),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0, // 0 لأننا في الرئيسية
        onTap: (index) {
          if (index == 0) {
            // نحن أساساً في الهوم
          } else if (index == 1) {
            context.go(AppRouter.categories);
            // <--- هنا يتم الانتقال لصفحة الأقسام عند الضغط على أيقونتها في الهوم!
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
