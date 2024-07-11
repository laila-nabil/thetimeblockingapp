import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';

import 'error/failures.dart';

abstract class UseCase<Output, Params> {
  Future<dartz.Either<Failure, Output>?> call(Params params);
}

class NoParams extends Equatable {
  @override
  List<Object?> get props => [];
}

