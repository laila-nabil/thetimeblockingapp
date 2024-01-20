import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  final String message;

  const Failure({required this.message});

  @override
  List<Object?> get props => [message];
}

class UnknownFailure extends Failure {
  const UnknownFailure({required String message}) : super(message: message);
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
class InputFailure extends Failure {
  const InputFailure({required String message}) : super(message: message);
}

class FailuresList extends Failure {
  FailuresList({required List<Failure> failures})
      : super(message: failures.map((e) => "${e.message}\n").toString());
}