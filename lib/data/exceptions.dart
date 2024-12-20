abstract class Failure implements Exception {
  const Failure();

  String get message;

  @override
  String toString() {
    return '$runtimeType Exception';
  }
}

class GeneralException extends Failure {
  const GeneralException();

  @override
  String get message => 'Алдаа гарлаа. Дараа дахин оролдоно уу.';
}

//API Exceptions

class APIException extends Failure {
  const APIException({
    required this.code,
    this.textCode,
  });

  final int code;
  final String? textCode;

  @override
  String get message {
    if (textCode != null) {
      switch (textCode) {
        case 'invalid-headers':
        case 'validation-failed':
          return 'Буруу хүсэлт. Хүсэлтээ шалгаж, дахин оролдоно уу.';
        default:
          return 'Дотоод алдаа гарлаа. Дараа дахин оролдоно уу.';
      }
    }
    switch (code) {
      case 400:
        return 'Буруу хүсэлт. Хүсэлтээ шалгаж, дахин оролдоно уу.';
      case 401:
        return 'Энэ нөөцөд хандах эрхгүй байна. Та дахин нэвтрэх хэрэгтэй.';
      case 404:
        return 'Энэ үйлдлийг дуусгаж чадсангүй. Дараа дахин оролдоно уу.';
      case 503:
        return 'Үйлчилгээ одоогоор боломжгүй байна. Дараа дахин оролдоно уу.';
      default:
        return 'Дотоод алдаа гарлаа. Дараа дахин оролдоно уу.';
    }
  }
}

//Services Exceptions
class AuthException extends Failure {
  const AuthException({
    required this.code,
  });

  final String code;

  @override
  String get message {
    switch (code) {
      case 'session-expired':
      case 'invalid-jwt':
      case 'invalid-headers':
      case 'user-not-authenticated':
        return 'Таны сесс дууссан байна. Дахин нэвтэрнэ үү.';
      case 'email-already-exists':
        return 'Оруулсан имэйл аль хэдийн ашиглагдаж байна. Өөр мэдээлэл оруулах эсвэл шинэ бүртгэл үүсгэнэ үү.';
      case 'user-not-found':
      case 'wrong-password':
        return 'Имэйл эсвэл нууц үг буруу байна. Мэдээллээ шалгаж эсвэл шинэ бүртгэл үүсгэнэ үү.';
      case 'network-request-failed':
        return 'Алсын сервертэй холбогдож чадсангүй. Холболтоо шалгаж, дахин оролдоно уу.';
      case 'too-many-requests':
        return 'Олон удаагийн алдаатай оролдлогын улмаас та одоогоор нэвтэрч чадахгүй байна. Түр хүлээгээд дахин оролдоно уу.';
      case 'internal':
        return 'Таны бүртгэлийг үүсгэж чадсангүй. Мэдээллээ шалгаж, дахин оролдоно уу.';
      default:
        return 'Нэвтрэх үед алдаа гарлаа. Дараа дахин оролдоно уу.';
    }
  }
}

class SecureStorageException extends Failure {
  const SecureStorageException();

  @override
  String get message => 'Нууц хадгалагдсан мэдээлэл авахад алдаа гарлаа.';
}

class CacheException extends Failure {
  const CacheException();

  @override
  String get message => 'Орон нутгийн сангаас мэдээлэл авахад алдаа гарлаа.';
}

//System Exceptions
class ConnectionException extends Failure {
  const ConnectionException({
    required this.code,
  });

  final String code;

  @override
  String get message {
    switch (code) {
      case 'connection-error':
        return 'Алсын сервертэй холбогдож чадсангүй. Холболтоо шалгаж, дахин оролдоно уу.';
      default:
        return 'Дотоод алдаа гарлаа. Дараа дахин оролдоно уу.';
    }
  }
}
