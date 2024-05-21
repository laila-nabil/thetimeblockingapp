import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import 'error/exception_to_failure.dart';
import 'error/exceptions.dart';
import 'error/failures.dart';
import 'injection_container.dart';

Future<Either<Failure, T>> repoHandleRemoteRequest<T>({
  required Future<T> Function() remoteDataSourceRequest,
  Future<T> Function()? tryGetFromLocalStorage,
  Future<void> Function(T result)? trySaveResult,
  AnalyticsEvents? analyticsEvent,
  Map<String, Object?>? analyticsEventParameters,
}) async {
  late T result;
  try {
    if (tryGetFromLocalStorage != null) {
      try {
        result = await tryGetFromLocalStorage();
      } catch (e) {
        printDebug("tryGetFromLocalStorage error $e");
        result = await remoteDataSourceRequest();
        if(analyticsEvent!=null){
          serviceLocator<Analytics>().logEvent(analyticsEvent.name,
              parameters: analyticsEventParameters);
        }
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

Future<Either<Failure, T>> repoHandleLocalGetRequest<T>({
  required Future<T> Function() tryGetFromLocalStorage,
}) async {
  late T result;
  try {
    result = await tryGetFromLocalStorage();
  } catch (error) {
    printDebug("repo $error", printLevel: PrintLevel.error);
    if (error is Exception) {
      return Left(exceptionToFailure(error));
    }
    return Left(UnknownFailure(message: error.toString()));
  }
  return Right(result);

}

Future<Either<Failure, Unit>> repoHandleLocalSaveRequest<T>({
  required Future<void> Function() trySaveResult,
}) async {
    try {
      await trySaveResult();
    }  on ServerException {
      printDebug("repo ServerException", printLevel: PrintLevel.error);
      return const Left(ServerFailure(message: ''));
    } catch (error) {
      printDebug("repo $error", printLevel: PrintLevel.error);
      if (error is Exception) {
        return Left(exceptionToFailure(error));
      }
      return Left(UnknownFailure(message: error.toString()));
    }
    return const Right(unit);
}
