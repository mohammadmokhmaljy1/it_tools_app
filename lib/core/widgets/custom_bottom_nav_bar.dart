import 'package:flutter/material.dart';
import 'package:it_tools_app/core/constants/app_assets.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;
  final int cartItemsCount;

  const CustomBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
    this.cartItemsCount = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          border: const Border(
            top: BorderSide(color: AppColors.borderDefault, width: 0.8),
          ),
          boxShadow: [
            BoxShadow(
              color: AppColors.navy900.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          top: false,
          child: Container(
            height: 68,
            padding: const EdgeInsets.only(top: 4, bottom: 4),
            child: BottomNavigationBar(
              currentIndex: currentIndex,
              onTap: onTap,
              type: BottomNavigationBarType.fixed,
              backgroundColor: Colors.transparent,
              elevation: 0,
              selectedItemColor: AppColors.blue,
              unselectedItemColor: AppColors.textTertiary,
              selectedLabelStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: FontWeight.bold,
                height: 1.4,
              ),
              unselectedLabelStyle: const TextStyle(
                fontFamily: 'Cairo',
                fontSize: 11,
                fontWeight: FontWeight.w500,
                height: 1.4,
              ),
              items: [
                // 1. الرئيسية
                const BottomNavigationBarItem(
                  icon: _NavIcon(
                    assetPath: AppAssets.navHomeOutline,
                    color: AppColors.textTertiary,
                  ),
                  activeIcon: _NavIcon(
                    assetPath: AppAssets.navHomeFilled,
                    color: AppColors.blue,
                  ),
                  label: 'الرئيسية',
                ),

                // 2. الأقسام
                const BottomNavigationBarItem(
                  icon: _NavIcon(
                    assetPath: AppAssets.navCategoriesOutline,
                    color: AppColors.textTertiary,
                  ),
                  activeIcon: _NavIcon(
                    assetPath: AppAssets.navCategoriesFilled,
                    color: AppColors.blue,
                  ),
                  label: 'الأقسام',
                ),

                // 3. السلة مع الشارة الذهبية
                BottomNavigationBarItem(
                  icon: _CartBadgeNavIcon(
                    assetPath: AppAssets.navCartOutline,
                    color: AppColors.textTertiary,
                    count: cartItemsCount,
                  ),
                  activeIcon: _CartBadgeNavIcon(
                    assetPath: AppAssets.navCartFilled,
                    color: AppColors.blue,
                    count: cartItemsCount,
                  ),
                  label: 'السلة',
                ),

                // 4. المفضلة
                const BottomNavigationBarItem(
                  icon: _NavIcon(
                    assetPath: AppAssets.navFavoritesOutline,
                    color: AppColors.textTertiary,
                  ),
                  activeIcon: _NavIcon(
                    assetPath: AppAssets.navFavoritesFilled,
                    color: AppColors.blue,
                  ),
                  label: 'المفضلة',
                ),

                // 5. حسابي
                const BottomNavigationBarItem(
                  icon: _NavIcon(
                    assetPath: AppAssets.navProfileOutline,
                    color: AppColors.textTertiary,
                  ),
                  activeIcon: _NavIcon(
                    assetPath: AppAssets.navProfileFilled,
                    color: AppColors.blue,
                  ),
                  label: 'حسابي',
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _NavIcon extends StatelessWidget {
  final String assetPath;
  final Color color;

  const _NavIcon({required this.assetPath, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Image.asset(
        assetPath,
        width: 23,
        height: 23,
        color: color,
        fit: BoxFit.contain,
      ),
    );
  }
}

class _CartBadgeNavIcon extends StatelessWidget {
  final String assetPath;
  final Color color;
  final int count;

  const _CartBadgeNavIcon({
    required this.assetPath,
    required this.color,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Image.asset(
            assetPath,
            width: 23,
            height: 23,
            color: color,
            fit: BoxFit.contain,
          ),
          if (count > 0)
            Positioned(
              top: -5,
              right: -7,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: AppColors.orange,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Text(
                  '$count',
                  style: const TextStyle(
                    fontFamily: 'Cairo',
                    color: AppColors.navy900,
                    fontSize: 9.5,
                    fontWeight: FontWeight.bold,
                    height: 1.0,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
