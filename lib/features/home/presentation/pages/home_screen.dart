import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/core/widgets/custom_bottom_nav_bar.dart';
import 'package:it_tools_app/features/catalog/presentation/providers/catalog_providers.dart';
import 'package:it_tools_app/features/home/presentation/widgets/banners/home_banner_slider.dart';
import 'package:it_tools_app/features/home/presentation/widgets/banners/university_offer_banner.dart';
import 'package:it_tools_app/features/home/presentation/widgets/categories/home_categories_section.dart';
import 'package:it_tools_app/features/home/presentation/widgets/header/home_search_bar.dart';
import 'package:it_tools_app/features/home/presentation/widgets/header/home_top_bar.dart';
import 'package:it_tools_app/features/home/presentation/widgets/home_loading_skeleton.dart';
import 'package:it_tools_app/features/home/presentation/widgets/products/home_products_grid.dart';
import 'package:it_tools_app/features/home/presentation/widgets/products/section_header_with_timer.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final homeAsync = ref.watch(homeProvider);

    return Scaffold(
      backgroundColor: AppColors.pageBg,
      body: SafeArea(
        child: homeAsync.when(
          loading: () => const HomeLoadingSkeleton(),
          error: (error, _) => Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.wifi_off_rounded,
                    size: 56,
                    color: AppColors.textTertiary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    mapCatalogFailureMessage(error),
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => ref.invalidate(homeProvider),
                    child: const Text('إعادة المحاولة'),
                  ),
                ],
              ),
            ),
          ),
          data: (homeData) => RefreshIndicator(
            onRefresh: () => ref.refresh(homeProvider.future),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(16.0, 24.0, 16.0, 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const HomeTopBar(),
                  const SizedBox(height: 16),
                  const HomeSearchBar(),
                  const SizedBox(height: 16),
                  HomeBannerSlider(banners: homeData.banners),
                  const SizedBox(height: 16),
                  HomeCategoriesSection(categories: homeData.categories),
                  const SizedBox(height: 16),
                  const UniversityOfferBanner(),
                  const SizedBox(height: 24),
                  SectionHeaderWithTimer(
                    title: 'عروض حصرية',
                    endsAt: homeData.offers.isNotEmpty
                        ? homeData.offers.first.endsAt
                        : null,
                  ),
                  const SizedBox(height: 12),
                  HomeProductsGrid(products: homeData.offerProducts),
                  const SizedBox(height: 24),
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
                            context.push(AppRouter.productList, extra: 'الكل');
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
                  HomeProductsGrid(products: homeData.bestSellers),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: CustomBottomNavBar(
        currentIndex: 0,
        onTap: (index) {
          if (index == 1) {
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
