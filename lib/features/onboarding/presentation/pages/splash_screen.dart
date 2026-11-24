import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:it_tools_app/core/config/app_router.dart';

import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';
import 'package:it_tools_app/core/constants/app_assets.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late final Timer _onboardingTimer;
  @override
  void initState() {
    super.initState();
    // الانتقال تلقائياً لشاشة الـ Onboarding بعد 3 ثوانٍ كمثال
    _onboardingTimer = Timer(const Duration(seconds: 3), () {
      context.go(AppRouter.onboarding);
    });
  }

  @override
  void dispose() {
    _onboardingTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // استبدلنا اللون الواحد بتدرج لوني مطابق لـ Figma تماماً
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              AppColors.royal, // اللون العلوي: #0543AE
              AppColors.navy700, // اللون السفلي الداكن: #011755
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              // أيقونة / شعار التطبيق داخل مربّع أبيض بزوايا دائرية
              Container(
                width: 100,
                height: 100,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Image.asset(
                  AppAssets.logo,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error, color: Colors.red, size: 40);
                  },
                ),
              ),
              const SizedBox(height: 24),
              // اسم التطبيق (المحيط)
              Text(
                'المحيط',
                style: AppTextStyles.headingH1.copyWith(
                  color: AppColors.onBrand,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // النص الفرعي (كل إكسسوارات الكمبيوتر بين يديك)
              Text(
                'كل إكسسوارات الكمبيوتر بين يديك',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.ice),
              ),
              const Spacer(),
              // حقوق التأسيس في الأسفل (by Devmmnd)
              Padding(
                padding: const EdgeInsets.only(bottom: 24.0),
                child: Text(
                  'by Devmmnd',
                  style: AppTextStyles.caption.copyWith(color: AppColors.sky),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
