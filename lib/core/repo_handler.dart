import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/print_debug.dart';

import 'error/exception_to_failure.dart';
import 'error/exceptions.dart';
import 'error/failures.dart';

Future<dartz.Either<Failure, T>> repoHandleRemoteRequest<T>({
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
        printDebug("tryGetFromLocalStorage error $e",printLevel: PrintLevel.error);
        result = await remoteDataSourceRequest();
      }
    } else {
      result = await remoteDataSourceRequest();
    }
  } catch (error) {
    printDebug(error, printLevel: PrintLevel.error);
    if (error is Exception) {
      return dartz.Left(exceptionToFailure(error));
    }
    return dartz.Left(UnknownFailure(message: error.toString()));
  }
  if (trySaveResult != null) {
    try {
      await trySaveResult(result);
    } catch (error) {
      printDebug("repo $error", printLevel: PrintLevel.error);
    }
  }
  return dartz.Right(result);
}

Future<dartz.Either<Failure, T>> repoHandleLocalGetRequest<T>({
  required Future<T> Function() tryGetFromLocalStorage,
}) async {
  late T result;
  try {
    result = await tryGetFromLocalStorage();
  } catch (error) {
    printDebug("repo $error", printLevel: PrintLevel.error);
    if (error is Exception) {
      return dartz.Left(exceptionToFailure(error));
    }
    return dartz.Left(UnknownFailure(message: error.toString()));
  }
  return dartz.Right(result);

}

Future<dartz.Either<Failure, dartz.Unit>> repoHandleLocalSaveRequest<T>({
  required Future<void> Function() trySaveResult,
}) async {
    try {
      await trySaveResult();
    }  on ServerException {
      printDebug("repo ServerException", printLevel: PrintLevel.error);
      return const dartz.Left(ServerFailure(message: ''));
    } catch (error) {
      printDebug("repo $error", printLevel: PrintLevel.error);
      if (error is Exception) {
        return dartz.Left(exceptionToFailure(error));
      }
      return dartz.Left(UnknownFailure(message: error.toString()));
    }
    return const dartz.Right(dartz.unit);
}
