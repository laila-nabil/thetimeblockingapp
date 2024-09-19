import 'package:dartz/dartz.dart' as dartz;
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
    final result = await repo.getAllInWorkspace(params: params);
    printDebug("getAllInWorkspace $result");
    bool listsExist = true;
    if(result.isRight()){
      result.fold((_){}, (r){
        bool noFolderlessLists = r.lists?.isNotEmpty!= true;
        bool noListsInFolders = r.folders?.isNotEmpty!= true;
        r.folders?.forEach((f){
          noListsInFolders = noListsInFolders && f.lists?.isNotEmpty!= true;
        });
        if(noFolderlessLists && noListsInFolders ){
          listsExist = false;
        }});
    }
    if(listsExist == false){
      final resultCreate = await tasksRepo.createFolderlessList(
          CreateFolderlessListParams.defaultList(
              user: params.user, workspace: params.workspace));
      printDebug("resultCreate $resultCreate");
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
