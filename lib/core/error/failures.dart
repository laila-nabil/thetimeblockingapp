import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure({required String message}) : super(message: message);
}

class EmptyCacheFailure extends Failure {
  const EmptyCacheFailure() : super(message: "");

  @override
  List<Object?> get props => [];
}
class CacheFailure extends Failure {
  const CacheFailure() : super(message: "");

  @override
  List<Object?> get props => [];
}

class LocationFailure extends Failure {
  const LocationFailure({required String message}) : super(message: message);
}