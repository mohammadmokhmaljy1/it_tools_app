import 'package:flutter/material.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/widgets/skeleton_box.dart';

class HomeLoadingSkeleton extends StatelessWidget {
  const HomeLoadingSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. الهيدر العلوي (الشعار + سطرا الترحيب + زر الإشعارات)
          const Row(
            children: [
              SkeletonBox(width: 42, height: 42, borderRadius: 12),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SkeletonBox(width: 90, height: 10, borderRadius: 6),
                    SizedBox(height: 8),
                    SkeletonBox(width: 140, height: 12, borderRadius: 6),
                  ],
                ),
              ),
              SkeletonBox(width: 42, height: 42, borderRadius: 12),
            ],
          ),
          const SizedBox(height: 18),

          // 2. شريط البحث
          const SkeletonBox(
            width: double.infinity,
            height: 48,
            borderRadius: 14,
          ),
          const SizedBox(height: 18),

          // 3. البانر الإعلاني الكبير
          const SkeletonBox(
            width: double.infinity,
            height: 155,
            borderRadius: 18,
          ),
          const SizedBox(height: 20),
          // عنوان قسم التصنيفات (السطر الأول الناقص)
          const SkeletonBox(width: 110, height: 12, borderRadius: 6),
          const SizedBox(height: 12),
          // 4. صف التصنيفات الخمسة
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(
              5,
              (_) => const SkeletonBox(width: 56, height: 56, borderRadius: 14),
            ),
          ),
          const SizedBox(height: 22),

          // عنوان قسم المنتجات (السطر الثاني الناقص)
          const SkeletonBox(width: 120, height: 12, borderRadius: 6),
          const SizedBox(height: 12),
          // 5. بطاقتا المنتجات في الأسفل
          Row(
            children: [
              Expanded(child: _productCardSkeleton()),
              const SizedBox(width: 12),
              Expanded(child: _productCardSkeleton()),
            ],
          ),
        ],
      ),
    );
  }

  Widget _productCardSkeleton() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.borderDefault, width: 0.6),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SkeletonBox(width: double.infinity, height: 135, borderRadius: 14),
          SizedBox(height: 12),
          SkeletonBox(width: 115, height: 11, borderRadius: 6),
          SizedBox(height: 8),
          SkeletonBox(width: 85, height: 11, borderRadius: 6),
          SizedBox(height: 10),
          SkeletonBox(width: 55, height: 13, borderRadius: 6),
        ],
      ),
    );
  }
}
