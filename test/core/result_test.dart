import 'package:flutter_test/flutter_test.dart';
import 'package:it_tools_app/core/errors/failure.dart';
import 'package:it_tools_app/core/utils/result.dart';

void main() {
  group('Result & Failure Tests', () {
    test('Success returns data properly using when', () {
      const Result<String> result = Success('تم جلب البيانات بنجاح');

      final output = result.when(
        success: (data) => data,
        error: (failure) => failure.message,
      );

      expect(output, 'تم جلب البيانات بنجاح');
    });

    test('Error returns Failure properly using when', () {
      const Result<String> result = Error(NetworkFailure());

      final output = result.when(
        success: (data) => data,
        error: (failure) => failure,
      );

      expect(output, isA<NetworkFailure>());
      expect((output as Failure).message, isNotEmpty);
    });

    test('ServerFailure holds statusCode and message', () {
      const failure = ServerFailure(statusCode: 500, code: 'ERR_500');

      expect(failure.statusCode, 500);
      expect(failure.code, 'ERR_500');
      expect(failure.message, isNotEmpty);
    });

    test('ValidationFailure holds fieldErrors', () {
      const failure = ValidationFailure(
        fieldErrors: {
          'email': ['البريد الإلكتروني غير صالح'],
        },
      );

      expect(
        failure.fieldErrors?['email'],
        contains('البريد الإلكتروني غير صالح'),
      );
    });
  });
}
