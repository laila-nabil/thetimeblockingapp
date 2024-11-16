import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import 'exceptions.dart';

Failure exceptionToFailure(Exception exception){
  if(exception is ServerException){
    return ServerFailure(message: exception.message ?? "");
  }
  if(exception is TokenTimeOutException){
    return const TokenTimeOutFailure();
  }
  if(exception is EmptyCacheException){
    return const EmptyCacheFailure();
  }
  if(exception is FailedCachingException){
    return const CacheFailure();
  }
  return const UnknownFailure(message: "");
}