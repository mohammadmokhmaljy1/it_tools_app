import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:it_tools_app/main.dart';

void main() {
  setUp(() => FlutterSecureStorage.setMockInitialValues({}));
  testWidgets('App displays the five bottom navigation tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const ProviderScope(child: ItToolsApp()));
    await tester.pumpAndSettle();

    expect(find.text('الرئيسية'), findsWidgets);
    expect(find.text('التصنيفات'), findsOneWidget);
    expect(find.text('السلة'), findsOneWidget);
    expect(find.text('المفضلة'), findsOneWidget);
    expect(find.text('حسابي'), findsOneWidget);
  });
}
