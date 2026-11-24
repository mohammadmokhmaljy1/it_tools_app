import 'package:flutter/material.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class SectionHeaderWithTimer extends StatelessWidget {
  final String title;

  const SectionHeaderWithTimer({super.key, this.title = 'عروض اليوم'});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // 1. اليمين: عنوان القسم مع أيقونة البرق المفرغة
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(
                Icons.bolt_outlined, // أيقونة برق مفرغة مطابقة للتصميم
                size: 22,
                color: AppColors.orange, // #E39F25
              ),
              const SizedBox(width: 6),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'Cairo',
                  fontSize: 18,
                  fontWeight: FontWeight.w600, // SemiBold مطابق لـ Figma
                  height: 1.5,
                  color: Color(0xFF02112C),
                ),
              ),
            ],
          ),

          // 2. اليسار: مربعات الوقت الرقمي (08  45  12)
          // نستخدم LTR للعداد لكي تبقى الساعات 08 على اليمين والثواني 12 على اليسار كما في الصورة
          const Directionality(
            textDirection: TextDirection.ltr,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _TimeUnitBox(timeText: '12'),
                SizedBox(width: 4),
                _TimeUnitBox(timeText: '45'),
                SizedBox(width: 4),
                _TimeUnitBox(timeText: '08'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _TimeUnitBox extends StatelessWidget {
  final String timeText;

  const _TimeUnitBox({required this.timeText});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 28,
      height: 26,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: AppColors.navy900, // #02112C
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        timeText,
        style: AppTextStyles.labelMedium.copyWith(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 12,
          height: 1.0,
        ),
      ),
    );
  }
}
