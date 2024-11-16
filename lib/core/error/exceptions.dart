import 'package:equatable/equatable.dart';

class ServerException extends Equatable implements Exception  {
  final String? message;

  ServerException({this.message});

  @override
  List<Object?> get props => [message];
}

class TokenTimeOutException implements Exception {}

class EmptyCacheException implements Exception {}

class FailedCachingException implements Exception {}
