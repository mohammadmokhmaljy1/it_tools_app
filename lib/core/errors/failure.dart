sealed class Failure {
  final String message;
  final String? code;

  const Failure({required this.message, this.code});
}

class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'تحقق من اتصالك بالإنترنت وحاول مرة أخرى.',
    super.code,
  });
}

class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({
    super.message = 'حدث خطأ في الخادم، يرجى المحاولة لاحقاً.',
    super.code,
    this.statusCode,
  });
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'غير مصرح لك بالوصول، يرجى تسجيل الدخول مرة أخرى.',
    super.code,
  });
}

class ValidationFailure extends Failure {
  final Map<String, List<String>>? fieldErrors;

  const ValidationFailure({
    super.message = 'البيانات المدخلة غير صحيحة، يرجى التحقق منها.',
    super.code,
    this.fieldErrors,
  });
}

class NotFoundFailure extends Failure {
  const NotFoundFailure({
    super.message = 'العنصر المطلوب غير موجود.',
    super.code,
  });
}

class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى.',
    super.code,
  });
}
