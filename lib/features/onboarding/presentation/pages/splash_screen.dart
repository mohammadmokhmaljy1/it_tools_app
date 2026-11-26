import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/core/constants/app_assets.dart';
import 'package:it_tools_app/core/theme/app_colors.dart';
import 'package:it_tools_app/core/theme/app_text_styles.dart';

import '../providers/app_config_provider.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  Timer? _splashTimer;
  bool _timerDone = false;
  bool? _seenOnboarding;

  @override
  void initState() {
    super.initState();
    _splashTimer = Timer(const Duration(seconds: 2), () {
      _timerDone = true;
      _navigateIfReady();
    });
    ref.read(appConfigProvider);
    unawaited(_loadOnboardingState());
  }

  Future<void> _loadOnboardingState() async {
    final seenOnboarding = await hasSeenOnboarding();
    if (!mounted) return;
    _seenOnboarding = seenOnboarding;
    _navigateIfReady();
  }

  void _navigateIfReady() {
    if (!mounted || !_timerDone || _seenOnboarding == null) return;
    if (_seenOnboarding!) {
      context.go(AppRouter.home);
    } else {
      context.go(AppRouter.onboarding);
    }
  }

  @override
  void dispose() {
    _splashTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [AppColors.royal, AppColors.navy700],
          ),
        ),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
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
              Text(
                'المحيط',
                style: AppTextStyles.headingH1.copyWith(
                  color: AppColors.onBrand,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'كل إكسسوارات الكمبيوتر بين يديك',
                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.ice),
              ),
              const Spacer(),
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
