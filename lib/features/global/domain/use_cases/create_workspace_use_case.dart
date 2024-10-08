import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/global/domain/repositories/global_repo.dart';

class CreateWorkspaceUseCase
    implements UseCase<dartz.Unit, CreateWorkspaceParams> {
  final GlobalRepo repo;

  CreateWorkspaceUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, dartz.Unit>> call(
      CreateWorkspaceParams params) async {
    final result = await repo.createWorkspace(params: params);
    return result;
  }
}

class CreateWorkspaceParams extends Equatable {

  final String userId;
  String? name;
  CreateWorkspaceParams({ required this.userId,required String this.name});

  CreateWorkspaceParams.defaultWorkspace({required this.userId,});

  Map<String, dynamic> toJson() {
    return {
      if(name?.isNotEmpty == true)'name': name,
      'user_id': userId,
    };
  }

  @override
  List<Object?> get props => [ userId,name];
}
