import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:it_tools_app/app/app.dart';
import 'package:it_tools_app/core/config/app_router.dart';
import 'package:it_tools_app/features/auth/presentation/pages/login_page.dart';
import 'package:it_tools_app/features/auth/presentation/pages/register_page.dart';

void main() {
  testWidgets('ITToolsApp opens login and registration routes', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ITToolsApp());
    expect(find.byType(MaterialApp), findsOneWidget);

    // انتظار انتهاء مؤقت شاشة البداية (3 ثوانٍ) حتى لا يبقى Timer معلقاً
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    AppRouter.router.go(AppRouter.login);
    await tester.pumpAndSettle();
    expect(find.byType(LoginPage), findsOneWidget);

    AppRouter.router.go(AppRouter.register);
    await tester.pumpAndSettle();
    expect(find.byType(RegisterPage), findsOneWidget);
  });
}
