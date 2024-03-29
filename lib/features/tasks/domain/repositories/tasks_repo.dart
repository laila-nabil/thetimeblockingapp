import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_folder_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_tag_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_clickup_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_tag_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/update_clickup_tag_use_case.dart';

import '../../../../common/entities/clickup_workspace.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase.dart';
import '../../../startup/domain/use_cases/save_spaces_use_case.dart';
import '../../../startup/domain/use_cases/select_space_use_case.dart';
import '../../../startup/domain/use_cases/select_workspace_use_case.dart';
import '../entities/clickup_folder.dart';
import '../entities/clickup_list.dart';
import '../entities/clickup_space.dart';
import '../entities/clickup_task.dart';
import '../entities/task_parameters.dart';
import '../use_cases/create_clickup_list_in_folder_use_case.dart';
import '../use_cases/add_tag_to_task_use_case.dart';
import '../use_cases/add_task_to_list_use_case.dart';
import '../use_cases/get_clickup_folderless_lists_in_space_use_case.dart';
import '../use_cases/get_clickup_folders_in_space_use_case.dart';
import '../use_cases/get_clickup_list_use_case.dart';
import '../use_cases/get_clickup_lists_in_folder_use_case.dart';
import '../use_cases/get_clickup_spaces_in_workspace_use_case.dart';
import '../use_cases/get_clickup_tags_in_space_use_case.dart';
import '../use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import '../use_cases/get_clickup_workspaces_use_case.dart';
import '../use_cases/remove_tag_from_task_use_case.dart';
import '../use_cases/remove_task_from_list_task_use_case.dart';

abstract class TasksRepo{
  Future<Either<Failure,List<ClickupTask>>> getTasksInWorkspace(
      {required GetClickupTasksInWorkspaceParams params});

  Future<Either<Failure, ClickupTask>?> createTaskInList(
      ClickupTaskParams params);

  Future<Either<Failure, ClickupTask>?> updateTask(
      ClickupTaskParams params);

  Future<Either<Failure, Unit>?> deleteTask(
      DeleteClickupTaskParams params);

  Future<Either<Failure, List<ClickupWorkspace>>> getClickupWorkspaces(
      {required GetClickupWorkspacesParams params});

  Future<Either<Failure, List<ClickupSpace>>> getClickupSpacesInWorkspaces(
      {required GetClickupSpacesInWorkspacesParams params});

  Future<Either<Failure, List<ClickupFolder>>> getClickupFolders(
      {required GetClickupFoldersInSpaceParams params});

  Future<Either<Failure, List<ClickupList>>> getClickupListsInFolder(
      {required GetClickupListsInFolderParams params});

  Future<Either<Failure, List<ClickupList>>> getClickupFolderlessLists(
      {required GetClickupFolderlessListsInSpaceParams params});

  Future<Either<Failure, List<ClickupTag>>> getClickupTags(
      {required GetClickupTagsInSpaceParams params});

  Future<Either<Failure, Unit>> removeTagFromTask(
      {required RemoveTagFromTaskParams params});

  Future<Either<Failure, Unit>> addTagToTask(
      {required AddTagToTaskParams params});

  Future<Either<Failure, Unit>> removeTaskFromAdditionalList(
      {required RemoveTaskFromListParams params});

  Future<Either<Failure, Unit>> addTaskToList(
      {required AddTaskToListParams params});

  Future<Either<Failure, Unit>?> selectWorkspace(
      SelectWorkspaceParams params);

  Future<Either<Failure, ClickupWorkspace>?> getSelectedWorkspace(
      NoParams params);

  Future<Either<Failure, Unit>?> selectSpace(
      SelectSpaceParams params);

  Future<Either<Failure, ClickupSpace>?> getSelectedSpace(
      NoParams params);

  Future<Either<Failure, Unit>?> saveSpacesOfSelectedWorkspace(
      SaveSpacesParams params);

  Future<Either<Failure, List<ClickupSpace>>?> getSpacesOfSelectedWorkspace(
      NoParams params);

  Future<Either<Failure, ClickupList>?> getClickupList(
      GetClickupListParams params);

  Future<Either<Failure, ClickupList>?> createClickupListInFolder(
      CreateClickupListInFolderParams params);

  Future<Either<Failure, ClickupList>?> createFolderlessClickupList(
      CreateFolderlessListClickupParams params);

  Future<Either<Failure, ClickupFolder>?> createClickupFolderInSpace(
      CreateClickupFolderInSpaceParams params);

  Future<Either<Failure, Unit>?> deleteList(DeleteClickupListParams params);

  Future<Either<Failure, Unit>?> deleteFolder(
      DeleteClickupFolderParams params);

  Future<Either<Failure, Unit>?> deleteClickupTag(
      DeleteClickupTagParams params);

  Future<Either<Failure, Unit>?> createClickupTagInSpace(
      CreateClickupTagInSpaceParams params);

  Future<Either<Failure, Unit>?> updateClickupTag(
      UpdateClickupTagParams params);
}