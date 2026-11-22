import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:it_tools_app/app/app.dart';

void main() {
  testWidgets('ITToolsApp renders smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const ITToolsApp());
    expect(find.byType(MaterialApp), findsOneWidget);

    // انتظار انتهاء مؤقت شاشة البداية (3 ثوانٍ) حتى لا يبقى Timer معلقاً
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();
  });
}
