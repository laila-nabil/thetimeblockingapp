import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';

import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import '../../../../common/entities/access_token.dart';
import '../repositories/global_repo.dart';

class GetAllInWorkspaceUseCase implements UseCase<Workspace, GetAllInWorkspaceParams> {
  final GlobalRepo repo;

  GetAllInWorkspaceUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, Workspace>> call(
      GetAllInWorkspaceParams params) async{
    final result = await repo.getAllInWorkspace(params: params);
    printDebug("getAllInWorkspace $result");
    return result;
  }
}

class GetAllInWorkspaceParams extends Equatable {
  final AccessToken accessToken;
  final Workspace workspace;

  const GetAllInWorkspaceParams({
    required this.accessToken,
    required this.workspace,
  });

  @override
  List<Object?> get props => [
        accessToken,
        workspace,
      ];
}
