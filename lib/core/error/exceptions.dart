class ServerException implements Exception {
  String? message;

  ServerException({this.message});
}

class TokenTimeOutException implements Exception {}

class EmptyCacheException implements Exception {}

class FailedCachingException implements Exception {}
