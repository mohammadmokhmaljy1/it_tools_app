import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

class NoInternetView extends StatelessWidget {
  final VoidCallback onRetry;
  final bool showBackButton;

  const NoInternetView({
    super.key,
    required this.onRetry,
    this.showBackButton = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // 1. زر الرجوع المربع في الزاوية العلوية اليمنى (كما في Figma)
            if (showBackButton)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: InkWell(
                    onTap: () {
                      if (context.canPop()) context.pop();
                    },
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
                ),
              ),

            // 2. محتوى المنتصف
            Expanded(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/empty_states/no_internet.png',
                        width: 185,
                        height: 185,
                        fit: BoxFit.contain,
                        color: AppColors.surface,
                        colorBlendMode: BlendMode.multiply,
                        errorBuilder: (_, _, _) => const Icon(
                          Icons.wifi_off_rounded,
                          size: 80,
                          color: AppColors.blue,
                        ),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        'لا يوجد اتصال بالإنترنت',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.headingH2,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'تأكد من اتصالك بشبكة Wi-Fi أو بيانات الهاتف ثم حاول مرة أخرى.',
                        textAlign: TextAlign.center,
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                          height: 1.6,
                        ),
                      ),
                      const SizedBox(height: 28),

                      // 3. زر "إعادة المحاولة" الأزرق العريض
                      InkWell(
                        onTap: onRetry,
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          width: double.infinity,
                          height: 50,
                          decoration: BoxDecoration(
                            color: AppColors.actionPrimary,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          alignment: Alignment.center,
                          child: Text(
                            'إعادة المحاولة',
                            style: AppTextStyles.titleMedium.copyWith(
                              color: AppColors.onBrand,
                            ),
                          ),
                        ),
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
