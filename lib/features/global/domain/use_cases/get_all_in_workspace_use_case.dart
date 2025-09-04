import 'package:dartz/dartz.dart' as dartz;
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';

import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_use_case.dart';
import '../repositories/global_repo.dart';

class GetAllInWorkspaceUseCase implements UseCase<Workspace, GetAllInWorkspaceParams> {
  final GlobalRepo repo;
  final TasksRepo tasksRepo;
  GetAllInWorkspaceUseCase(this.repo,this.tasksRepo);

  @override
  Future<dartz.Either<Failure, Workspace>> call(
      GetAllInWorkspaceParams params) async{
    Either<Failure, Workspace> result =
        await repo.getAllInWorkspace(params: params);
    printDebug("getAllInWorkspace $result");
    if(result.isRight()){
      await result.fold((_){}, (r) async {
        bool noFolderlessLists = r.lists?.isNotEmpty!= true;
        bool noListsInFolders = r.folders?.isNotEmpty!= true;
        r.folders?.forEach((f){
          noListsInFolders = noListsInFolders && f.lists?.isNotEmpty!= true;
        });
        printDebug("noFolderlessLists $noFolderlessLists");
        printDebug("noListsInFolders $noListsInFolders");
        printDebug("r.lists ${r.lists}");
        if (r.lists?.isNotEmpty != true) {
          final resultCreate = await tasksRepo.createFolderlessList(
              CreateFolderlessListParams.defaultList(
                  user: params.user, workspace: params.workspace));
          printDebug("resultCreateList $resultCreate");
          result =
          await repo.getAllInWorkspace(params: params);
        }
      });
    }

    return result;
  }
}

class GetAllInWorkspaceParams extends Equatable {

  final Workspace workspace;
  final User user;
  const GetAllInWorkspaceParams({
    required this.workspace,
    required this.user,
  });

  @override
  List<Object?> get props => [
        workspace,
         user,
      ];
}
