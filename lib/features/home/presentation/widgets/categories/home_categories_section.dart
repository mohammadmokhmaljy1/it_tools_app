// ignore_for_file: unused_label

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/config/app_router.dart';

import 'package:it_tools_app/core/constants/app_assets.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class HomeCategoriesSection extends StatelessWidget {
  const HomeCategoriesSection({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> categories = [
      {'title': 'ماوس', 'image': AppAssets.categoryMouse},
      {'title': 'كيبورد', 'image': AppAssets.categoryKeyboard},
      {'title': 'سماعات', 'image': AppAssets.categoryHeadphones},
      {'title': 'هب USB', 'image': AppAssets.categoryUsbHub},
      {
        'title': 'ستاند',
        'icon': Icons.monitor_outlined,
      }, // أيقونة جاهزة للستاند
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. صف العنوان وزر عرض الكل
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'تسوّق حسب القسم',
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.w600, // SemiBold
                  height: 1.5, // تعادل 150%
                  letterSpacing: 0,
                  color: Color(0xFF02112C),
                ),
              ),
              TextButton(
                onPressed: () {
                  context.go(AppRouter.categories);
                },

                style: TextButton.styleFrom(
                  padding: EdgeInsets.zero,
                  minimumSize: Size.zero,
                  tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
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
                      Icons.arrow_forward_ios_rounded, // يتجه لليسار في RTL
                      size: 12,
                      color: AppColors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // 2. قائمة الأقسام الأفقية
          SizedBox(
            height: 92,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 14),
              itemBuilder: (context, index) {
                final category = categories[index];
                return GestureDetector(
                  onTap: () {
                    context.push(
                      AppRouter.productList,
                      extra: category['title'] as String,
                    );
                  },

                  child: Column(
                    children: [
                      Container(
                        width: 62,
                        height: 62,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(
                            0xFFE6F4FA,
                          ), // أزرق فاتح جداً مطابق للواجهة
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: category.containsKey('image')
                            ? Image.asset(
                                category['image'] as String,
                                color: AppColors.royal,
                                fit: BoxFit.contain,
                              )
                            : CustomPaint(
                                size: const Size(24, 24),
                                painter: _StandIconPainter(
                                  color: AppColors.royal,
                                ),
                              ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        category['title'] as String,
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _StandIconPainter extends CustomPainter {
  final Color color;
  _StandIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.6
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final screenRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(2, 3, size.width - 4, size.height - 9),
      const Radius.circular(3),
    );
    canvas.drawRRect(screenRect, paint);

    canvas.drawLine(
      Offset(size.width / 2, size.height - 6),
      Offset(size.width / 2, size.height - 2),
      paint,
    );

    canvas.drawLine(
      Offset(size.width / 2 - 5, size.height - 2),
      Offset(size.width / 2 + 5, size.height - 2),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
