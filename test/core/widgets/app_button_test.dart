import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:it_tools_app/core/theme/app_theme.dart';
import 'package:it_tools_app/core/widgets/app_button.dart';
import 'package:it_tools_app/core/widgets/app_icon_button.dart';

void main() {
  group('AppButton & AppIconButton Widget Tests', () {
    testWidgets('enabled AppButton triggers onPressed when tapped', (
      tester,
    ) async {
      var tapCount = 0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: Scaffold(
            body: AppButton(label: 'تسجيل الدخول', onPressed: () => tapCount++),
          ),
        ),
      );

      await tester.tap(find.text('تسجيل الدخول'));
      await tester.pump();

      expect(tapCount, 1);
    });

    testWidgets('disabled AppButton does not invoke onPressed', (tester) async {
      const VoidCallback? disabledCallback = null;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: AppButton(
              label: 'إتمام الطلب',
              onPressed: disabledCallback,
              expand: true,
            ),
          ),
        ),
      );

      final filledButton = tester.widget<FilledButton>(
        find.byType(FilledButton),
      );
      expect(filledButton.onPressed, isNull);

      await tester.tap(find.byType(AppButton));
      await tester.pump();
    });

    testWidgets(
      'loading AppButton shows progress indicator and blocks repeated taps',
      (tester) async {
        var tapCount = 0;

        await tester.pumpWidget(
          MaterialApp(
            theme: AppTheme.lightTheme,
            home: Scaffold(
              body: AppButton(
                label: 'جاري الحفظ',
                isLoading: true,
                onPressed: () => tapCount++,
              ),
            ),
          ),
        );

        expect(find.byType(CircularProgressIndicator), findsOneWidget);

        await tester.tap(find.byType(AppButton));
        await tester.pump();

        expect(tapCount, 0);
      },
    );

    testWidgets('AppIconButton has 44x44 size and ignores taps when disabled', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: AppIconButton(
              icon: Icons.favorite_border,
              onPressed: null,
              style: AppIconButtonStyle.tinted,
            ),
          ),
        ),
      );

      final buttonSize = tester.getSize(find.byType(AppIconButton));
      expect(buttonSize, const Size(44, 44));

      final iconButton = tester.widget<IconButton>(find.byType(IconButton));
      expect(iconButton.onPressed, isNull);
    });
  });
}
