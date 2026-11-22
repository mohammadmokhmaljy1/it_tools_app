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

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 18),
      decoration: const BoxDecoration(color: AppColors.subtle),
      child: Column(
        children: [
          // 1. الشريط العلوي: زر الرجوع على اليمين + زر القلب على اليسار
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

          // 2. الصورة الرئيسية القابلة للسحب
          SizedBox(
            height: 185,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.images.length,
              onPageChanged: (index) => setState(() => _selectedIndex = index),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Image.asset(widget.images[index], fit: BoxFit.contain),
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // 3. نقاط المؤشر في المنتصف
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              final bool isActive = index == _selectedIndex;
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

          // 4. صف الصور المصغرة الـ 4 في الأسفل
          // 4. صف الصور المصغرة الـ 4 في الأسفل (بدون مسافة بين الصورة والإطار)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.images.length, (index) {
              final bool isSelected = index == _selectedIndex;
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
                    child: Image.asset(widget.images[index], fit: BoxFit.cover),
                  ),
                ),
              );
            }),
          ),
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
