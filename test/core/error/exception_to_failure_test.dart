import 'package:flutter_test/flutter_test.dart';
import 'package:thetimeblockingapp/core/error/exception_to_failure.dart';
import 'package:thetimeblockingapp/core/error/exceptions.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';

void main() {
  group("exceptionToFailure", () {
    test('in case of ServerException,return ServerFailure', () {
      const message = "error for exception";
      final exception = ServerException(message: message);
      expect(
          exceptionToFailure(exception), const ServerFailure(message: message));
    });

    test('in case of EmptyCacheException,return EmptyCacheFailure', () {
      final exception = EmptyCacheException();
      expect(
          exceptionToFailure(exception), const EmptyCacheFailure());
    });

    test('in case of FailedCachingException,return CacheFailure', () {
      final exception = FailedCachingException();
      expect(
          exceptionToFailure(exception), const CacheFailure());
    });
    test('in case of exception that is unknown,return ', () {
      const message = "message of unknown exception";
      final exception = Exception(message);
      expect(
          exceptionToFailure(exception), const UnknownFailure(message: ""));
    });
  });
}
