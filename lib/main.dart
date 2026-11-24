import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'core/auth/auth_status_provider.dart';
import 'core/network/dio_client.dart';
import 'core/router/app_router.dart';

void main() {
  runApp(
    ProviderScope(
      overrides: [
        sessionExpiredCallbackProvider.overrideWith(
          (ref) => ref.read(authStatusProvider).sessionExpired,
        ),
      ],
      child: const ItToolsApp(),
    ),
  );
}

class ItToolsApp extends ConsumerWidget {
  const ItToolsApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'IT Tools',
      debugShowCheckedModeBanner: false,
      locale: const Locale('ar'),
      supportedLocales: const [Locale('ar')],
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      routerConfig: router,
    );
  }
}
