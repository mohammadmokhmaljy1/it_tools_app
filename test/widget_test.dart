import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import 'package:it_tools_app/features/auth/presentation/pages/login_page.dart';
import 'package:it_tools_app/main.dart';

void main() {
  testWidgets('ItToolsApp renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ItToolsApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });

  testWidgets('Login route opens in Arabic RTL', (tester) async {
    await tester.pumpWidget(const ItToolsApp());
    await tester.pumpAndSettle();

    final home = tester.element(find.byType(Scaffold));
    GoRouter.of(home).go('/login');
    await tester.pumpAndSettle();

    final login = find.byType(LoginPage);
    expect(login, findsOneWidget);
    expect(Directionality.of(tester.element(login)), TextDirection.rtl);
  });
}
