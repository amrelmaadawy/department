import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;
  const Failure([this.message = '']);

  @override
  List<Object> get props => [message];
}

// Connection Failures
class OfflineFailure extends Failure {
  const OfflineFailure([super.message = 'لا يوجد اتصال بالإنترنت']);
}
class NoInternetFailure extends Failure {
  const NoInternetFailure([super.message = 'متصل بشبكة ولكن لا يوجد إنترنت']);
}
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = 'انتهت مهلة الاتصال']);
}
class ServerUnreachableFailure extends Failure {
  const ServerUnreachableFailure([super.message = 'الخادم لا يستجيب']);
}
class SSLFailure extends Failure {
  const SSLFailure([super.message = 'فشل في الاتصال الآمن']);
}
class DNSFailure extends Failure {
  const DNSFailure([super.message = 'فشل في تحليل اسم النطاق']);
}
class RequestCancelledFailure extends Failure {
  const RequestCancelledFailure([super.message = 'تم إلغاء الطلب']);
}
class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'حدث خطأ في الشبكة']);
}

// Auth Failures
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = 'غير مصرح لك بالوصول']);
}
class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message = 'مرفوض الوصول']);
}

// Server Failures
class ServerFailure extends Failure {
  final int? code;
  const ServerFailure([super.message = 'خطأ في الخادم', this.code]);

  @override
  List<Object> get props => [message, ?code];
}
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'البيانات غير موجودة']);
}

// Data Failures
class CacheFailure extends Failure {
  const CacheFailure([super.message = 'خطأ في الذاكرة المؤقتة']);
}
class PartialResponseFailure extends Failure {
  const PartialResponseFailure([super.message = 'استجابة غير مكتملة']);
}
class UnknownFailure extends Failure {
  const UnknownFailure([super.message = 'حدث خطأ غير معروف']);
}
