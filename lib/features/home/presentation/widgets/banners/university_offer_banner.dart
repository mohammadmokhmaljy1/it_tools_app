import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class UniversityOfferBanner extends StatelessWidget {
  const UniversityOfferBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        decoration: BoxDecoration(
          color: AppColors.navy900, // #02112C الخلفية الكحلية الداكنة
          borderRadius: BorderRadius.circular(18),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // 1. أقصى اليمين: مربع أيقونة الهدية الذهبية
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.06),
                  width: 1,
                ),
              ),
              child: const Icon(
                Icons.card_giftcard_rounded,
                color: AppColors.orange, // #E39F25
                size: 22,
              ),
            ),
            const SizedBox(width: 12),

            // 2. المنتصف: النصوص التوضيحية للعرض
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'عرض طلاب كلية المعلوماتية - جامعة حلب',
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.onBrand, // أبيض
                      fontWeight: FontWeight.bold,
                      height: 1.4,
                    ),
                    textAlign: TextAlign.right,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'خصم 15% على طلبك بالكوبون · حتى 30 تشرين الثاني',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textTertiary, // #7D96AD
                      height: 1.4,
                    ),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // 3. أقصى اليسار: زر كود الخصم القابل للنسخ (UNI15)
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Clipboard.setData(const ClipboardData(text: 'UNI15'));
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'تم نسخ كود الخصم UNI15 بنجاح',
                        textAlign: TextAlign.right,
                        style: TextStyle(fontFamily: 'Cairo'),
                      ),
                      duration: Duration(seconds: 2),
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 9,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.orange, // #E39F25
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'UNI15',
                        style: AppTextStyles.labelMedium.copyWith(
                          color: AppColors.navy900, // نص داكن كما في Figma
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(
                        Icons.copy_rounded,
                        size: 15,
                        color: AppColors.navy900, // أيقونة نسخ داكنة
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
