import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:it_tools_app/app/app.dart';

import 'core/auth/auth_status_provider.dart';
import 'core/network/dio_client.dart';

void main() {
  // التأكد من تهيئة بيئة الفلاتر قبل تشغيل التطبيق
  WidgetsFlutterBinding.ensureInitialized();

  // تثبيت الاتجاه العمودي فقط للشاشات (Portrait Mode) لتلائم تصميم الموبايل
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]).then((_) {
    runApp(
      ProviderScope(
        overrides: [
          sessionExpiredCallbackProvider.overrideWith(
            (ref) => ref.read(authStatusProvider).sessionExpired,
          ),
        ],
        child: const ITToolsApp(),
      ),
    );
  });
}
