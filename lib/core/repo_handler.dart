import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import 'error/exception_to_failure.dart';
import 'error/exceptions.dart';
import 'error/failures.dart';

Future<Either<Failure, T>> repoHandler<T>({
  required Future<T> Function() remoteDataSourceRequest,
  Future<T> Function()? tryGetFromLocalStorage,
  Future<void> Function(T result)? trySaveResult,
}) async {
  late T result;
  try {
    if (tryGetFromLocalStorage != null) {
      try {
        result = await tryGetFromLocalStorage();
      } catch (e) {
        printDebug("tryGetFromLocalStorage error $e");
        result = await remoteDataSourceRequest();
      }
    } else {
      result = await remoteDataSourceRequest();
    }
  } on ServerException {
    printDebug("repo ServerException", printLevel: PrintLevel.error);
    return const Left(ServerFailure(message: ''));
  } catch (error) {
    printDebug(error, printLevel: PrintLevel.error);
    if (error is Exception) {
      return Left(exceptionToFailure(error));
    }
    return Left(UnknownFailure(message: error.toString()));
  }
  if (trySaveResult != null) {
    try {
      await trySaveResult(result);
    } catch (error) {
      printDebug("repo $error", printLevel: PrintLevel.error);
    }
  }
  return Right(result);
}
