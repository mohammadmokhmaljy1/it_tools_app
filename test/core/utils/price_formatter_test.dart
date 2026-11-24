import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:it_tools_app/core/utils/price_formatter.dart';

void main() {
  group('PriceFormatter Tests', () {
    test('formatUsd formats numbers with two decimals and dollar sign', () {
      expect(PriceFormatter.formatUsd(12.5), '12.50 \$');
      expect(PriceFormatter.formatUsd(0), '0.00 \$');
      expect(PriceFormatter.formatUsd(1250.99), '1,250.99 \$');
    });

    test(
      'formatSyp formats numbers with thousand separators and SYP symbol',
      () {
        expect(PriceFormatter.formatSyp(165000), '165,000 ل.س');
        expect(PriceFormatter.formatSyp(500), '500 ل.س');
        expect(PriceFormatter.formatSyp(1250000), '1,250,000 ل.س');
      },
    );
  });

  testWidgets('App defaults to Arabic RTL directionality', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        locale: Locale('ar'),
        supportedLocales: [Locale('ar')],
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: Scaffold(body: Row(children: [Text('الأول'), Text('الثاني')])),
      ),
    );

    final direction = Directionality.of(tester.element(find.byType(Row)));
    expect(direction, TextDirection.rtl);
  });
}
