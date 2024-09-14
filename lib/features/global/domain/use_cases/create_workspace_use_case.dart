import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/global/domain/repositories/global_repo.dart';
import '../../../../common/entities/workspace.dart';
import '../../../../common/entities/access_token.dart';

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
  final AccessToken accessToken;
  final String userId;
  final String name;
  const CreateWorkspaceParams({required this.accessToken, required this.userId,required this.name});

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'user_id': userId,
    };
  }

  @override
  List<Object?> get props => [accessToken, userId];
}
