
import 'package:flutter_test/flutter_test.dart';
import 'package:it_tools_app/main.dart';

void main() {
  testWidgets('IT Tools App starts successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ITToolsApp());

    expect(find.text('إنشاء حساب'), findsOneWidget);
  });
}
