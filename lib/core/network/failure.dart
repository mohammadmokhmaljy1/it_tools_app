sealed class Failure {
  final String message;

  const Failure(this.message);
}

class NetworkFailure extends Failure {
  const NetworkFailure()
      : super('لا يوجد اتصال بالإنترنت، يرجى التحقق من اتصالك.');
}

class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure()
      : super('انتهت صلاحية الجلسة، يرجى تسجيل الدخول مجدداً.');
}

class NotFoundFailure extends Failure {
  const NotFoundFailure()
      : super('البيانات المطلوبة غير موجودة.');
}

class ValidationFailure extends Failure {
  const ValidationFailure()
      : super('البيانات المدخلة غير صحيحة، يرجى التحقق منها.');
}

class ServerFailure extends Failure {
  const ServerFailure()
      : super('حدث خطأ في الخادم، يرجى المحاولة لاحقاً.');
}