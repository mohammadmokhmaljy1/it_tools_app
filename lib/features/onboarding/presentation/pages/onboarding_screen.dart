import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/core/constants/app_assets.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/features/onboarding/presentation/widgets/onboarding_item_widget.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  // بيانات صفحات الـ Onboarding الثلاث المستخرجة من الفيجما
  final List<Map<String, String>> _onboardingData = [
    {
      'image': AppAssets.onboarding1,
      'title': 'كل إكسسوارات الكمبيوتر بمكان واحد',
      'description': 'ماوسات، كيبوردات، هبات USB، ماوس باد وستيكرات...\nمنتجات أصلية بأسعار واضحة.',
    },
    {
      'image': AppAssets.onboarding2,
      'title': 'عروض وكوبونات لطلاب الجامعات',
      'description': 'اختر جامعتك أو معهدك عند التسجيل لتصلك عروض وكوبونات خاصة بطلاب المعلوماتية.',
    },
    {
      'image': AppAssets.onboarding3,
      'title': 'استلم من المتجر أو اطلب التوصيل',
      'description': 'استلم من متجرنا في الجميلية بحلب، أو شحن لكل المحافظات السورية والدفع عند الاستلام.',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNextPressed() {
    if (_currentIndex < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // استبدليها بالمسار التالي لاحقاً (مثلاً الشاشة الرئيسية)
      context.go(AppRouter.home);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Column(
          children: [
            // الشريط العلوي (1/3 على اليمين، وتخطي على اليسار في وضع RTL)
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 16.0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // عداد الصفحات على اليمين
                  Text(
                    '${_currentIndex + 1}/3',
                    style: AppTextStyles.labelMedium.copyWith(
                      color: AppColors.textTertiary,
                    ),
                  ),
                  // زر التخطي على اليسار
                  TextButton(
                    onPressed: () {
                      context.go(AppRouter.login);
                    },
                    child: Text(
                      'تخطي',
                      style: AppTextStyles.titleMedium.copyWith(
                        color: AppColors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // محتوى الصفحات عبر الـ PageView
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                itemCount: _onboardingData.length,
                onPageChanged: (index) {
                  setState(() {
                    _currentIndex = index;
                  });
                },
                itemBuilder: (context, index) {
                  return OnboardingItemWidget(
                    imagePath: _onboardingData[index]['image']!,
                    title: _onboardingData[index]['title']!,
                    description: _onboardingData[index]['description']!,
                  );
                },
              ),
            ),

            // مؤشر النقاط التفاعلي (Dots Indicator)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                _onboardingData.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  height: 8.0,
                  width: _currentIndex == index ? 24.0 : 8.0,
                  decoration: BoxDecoration(
                    color: _currentIndex == index
                        ? AppColors.blue
                        : AppColors.borderDefault,
                    borderRadius: BorderRadius.circular(4.0),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),

            // الأزرار السفلية (تم رفعها للأعلى عبر زيادة الـ padding السفلي وإضافة تباعد)
            Padding(
              padding: const EdgeInsets.fromLTRB(24.0, 8.0, 24.0, 32.0),
              child: Column(
                children: [
                  ElevatedButton(
                    onPressed: _onNextPressed,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.arrow_forward_rounded, size: 16),
                        const SizedBox(width: 8),
                        Text(_currentIndex == 2 ? 'ابدأ التسوق' : 'التالي'),
                      ],
                    ),
                  ),
                  if (_currentIndex == 2) ...[
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        context.go(AppRouter.login);
                      },
                      child: Text(
                        'تسجيل الدخول',
                        style: AppTextStyles.titleMedium.copyWith(
                          color: AppColors.blue,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
