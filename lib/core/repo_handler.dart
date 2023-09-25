import 'package:dartz/dartz.dart';

import 'error/exception_to_failure.dart';
import 'error/exceptions.dart';
import 'error/failures.dart';

Future<Either<Failure, T>> repoHandler<T>(
    Future<T> Function() dataSourceRequest) async {
  try {
    final result = await dataSourceRequest();
    return Right(result);
  } on ServerException {
    return const Left(ServerFailure(message: ''));
  } catch (error) {
    if (error is Exception) {
      return Left(exceptionToFailure(error));
    }
    return Left(UnknownFailure(message: error.toString()));
  }
}
