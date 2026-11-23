import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:it_tools_app/main.dart';

void main() {
  testWidgets('ItToolsApp renders environment configuration smoke test', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ItToolsApp());
    await tester.pumpAndSettle();

    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
