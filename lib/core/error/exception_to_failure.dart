import 'package:thetimeblockingapp/core/error/failures.dart';

import 'exceptions.dart';

Failure exceptionToFailure(Exception exception){
  if(exception is ServerException){
    return ServerFailure(message: exception.message ?? "");
  }
  if(exception is EmptyCacheException){
    return const EmptyCacheFailure();
  }
  if(exception is FailedCachingException){
    return const CacheFailure();
  }
  return const UnknownFailure(message: "");
}