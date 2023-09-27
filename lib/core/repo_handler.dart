import 'package:dartz/dartz.dart';

import 'error/exception_to_failure.dart';
import 'error/exceptions.dart';
import 'error/failures.dart';

Future<Either<Failure, T>> repoHandler<T>({
  required Future<T> Function() remoteDataSourceRequest,
  Future<void> Function(T result)? trySaveResult,
}) async {
  late T result;
  try {
    result = await remoteDataSourceRequest();
  } on ServerException {
    return const Left(ServerFailure(message: ''));
  } catch (error) {
    if (error is Exception) {
      return Left(exceptionToFailure(error));
    }
    return Left(UnknownFailure(message: error.toString()));
  }
  if (trySaveResult!=null) {
    try {
      await trySaveResult(result);
    } catch (error) {
      if (error is Exception) {
        return Left(exceptionToFailure(error));
      }
      return Left(UnknownFailure(message: error.toString()));
    }
  }
  return Right(result);
}
