import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';

class ProductImageGallery extends StatefulWidget {
  final List<String> images;
  final bool isFavorite;
  final VoidCallback onToggleFavorite;

  const ProductImageGallery({
    super.key,
    required this.images,
    required this.isFavorite,
    required this.onToggleFavorite,
  });

  @override
  State<ProductImageGallery> createState() => _ProductImageGalleryState();
}

class _ProductImageGalleryState extends State<ProductImageGallery> {
  int _selectedIndex = 0;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _selectImage(int index) {
    setState(() => _selectedIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 280),
      curve: Curves.easeInOut,
    );
  }

  Widget _buildImage(String path, {required BoxFit fit, int? cacheWidth}) {
    if (path.startsWith('http')) {
      return CachedNetworkImage(
        imageUrl: path,
        memCacheWidth: cacheWidth,
        fit: fit,
        placeholder: (_, _) => const Center(
          child: SizedBox(
            width: 24,
            height: 24,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
        errorWidget: (_, _, _) => const Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: AppColors.textTertiary,
            size: 36,
          ),
        ),
      );
    }
    return Image.asset(
      path,
      fit: fit,
      errorBuilder: (_, _, _) => const Center(
        child: Icon(
          Icons.image_not_supported_outlined,
          color: AppColors.textTertiary,
          size: 36,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final safeImages = widget.images.isEmpty
        ? ['assets/images/products/keyboard.png']
        : widget.images;
    final currentIndex = _selectedIndex >= safeImages.length
        ? 0
        : _selectedIndex;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: const BoxDecoration(color: AppColors.subtle),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _topIconButton(
                icon: Icons.arrow_back_ios_new_rounded,
                iconColor: AppColors.textPrimary,
                onTap: () {
                  if (context.canPop()) context.pop();
                },
              ),
              _topIconButton(
                icon: widget.isFavorite
                    ? Icons.favorite_rounded
                    : Icons.favorite_border_rounded,
                iconColor: widget.isFavorite
                    ? AppColors.danger
                    : AppColors.textPrimary,
                onTap: widget.onToggleFavorite,
              ),
            ],
          ),
          const SizedBox(height: 8),
          SizedBox(
            height: 185,
            child: PageView.builder(
              controller: _pageController,
              itemCount: safeImages.length,
              onPageChanged: (index) => setState(() => _selectedIndex = index),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: _buildImage(
                    safeImages[index],
                    fit: BoxFit.contain,
                    cacheWidth: 800,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          if (safeImages.length > 1) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(safeImages.length, (index) {
                final bool isActive = index == currentIndex;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: isActive ? 16 : 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: isActive ? AppColors.blue : AppColors.borderStrong,
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
            const SizedBox(height: 14),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(safeImages.length, (index) {
                final bool isSelected = index == currentIndex;
                return GestureDetector(
                  onTap: () => _selectImage(index),
                  child: Container(
                    width: 56,
                    height: 56,
                    margin: const EdgeInsets.symmetric(horizontal: 5),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.blue
                            : AppColors.borderDefault,
                        width: isSelected ? 2 : 1,
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: _buildImage(
                        safeImages[index],
                        fit: BoxFit.cover,
                        cacheWidth: 200,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ],
        ],
      ),
    );
  }

  Widget _topIconButton({
    required IconData icon,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.borderDefault),
        ),
        child: Icon(icon, size: 18, color: iconColor),
      ),
    );
  }
}
