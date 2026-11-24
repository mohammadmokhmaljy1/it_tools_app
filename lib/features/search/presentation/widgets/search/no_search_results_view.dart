import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class NoSearchResultsView extends StatelessWidget {
  final String query;
  final VoidCallback onClearSearch;

  const NoSearchResultsView({
    super.key,
    required this.query,
    required this.onClearSearch,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // الشريط العلوي مع مسافة مريحة من الأعلى (top: 20)
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
          child: Row(
            children: [
              InkWell(
                onTap: onClearSearch,
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surface,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.borderDefault),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  'نتائج البحث',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodyLarge.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              const SizedBox(width: 40),
            ],
          ),
        ),

        // محتوى المنتصف مطابق لقياسات Figma
        Expanded(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/empty_states/no_search_results.png',
                    width: 175,
                    height: 175,
                    fit: BoxFit.contain,
                    color: AppColors.surface,
                    colorBlendMode: BlendMode.multiply,
                    errorBuilder: (_, _, _) => const Icon(
                      Icons.search_off_rounded,
                      size: 64,
                      color: AppColors.blue,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Heading/H2 - 20px Bold - text/primary
                  Text(
                    'لا توجد نتائج',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge.copyWith(
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      height: 1.4,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Body/Medium - 14px Regular - text/secondary
                  Text(
                    'لم نجد منتجات تطابق "$query". جرّب كلمات أخرى أو تصفّح الأقسام.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyMedium.copyWith(
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      height: 1.6,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Title/Medium - 16px SemiBold - brand/royal
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () => context.go(AppRouter.categories),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.subtle,
                        foregroundColor: AppColors.royal,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        'تصفّح الأقسام',
                        style: AppTextStyles.bodyLarge.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.5,
                          color: AppColors.royal,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Body/Strong - 14px SemiBold - text/link
                  TextButton(
                    onPressed: onClearSearch,
                    child: Text(
                      'مسح البحث',
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        height: 1.6,
                        color: AppColors.link,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
