import 'package:dartz/dartz.dart' as dartz;
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tags_in_space_use_case.dart';
import '../../../../common/entities/access_token.dart';
import '../../../../common/entities/space.dart';
import 'get_folderless_lists_in_space_use_case.dart';
import 'get_folders_in_space_use_case.dart';
import 'get_spaces_in_workspace_use_case.dart';

class GetAllInWorkspaceUseCase
    with GlobalsWriteAccess
    implements UseCase<Workspace, GetAllInWorkspaceParams> {
  final TasksRepo repo;

  GetAllInWorkspaceUseCase(this.repo);

  @override
  Future<dartz.Either<Failure, Workspace>> call(
      GetAllInWorkspaceParams params) async{
    final result = await repo.getAllInWorkspace(params: params);
    if(result.isRight()) {
      result.fold((_) {}, (r) => selectedWorkspace = r);
    }
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
