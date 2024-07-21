import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folder_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_tag_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_clickup_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_tag_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/update_clickup_tag_use_case.dart';

import '../../../../common/entities/workspace.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecase.dart';
import '../../../startup/domain/use_cases/save_spaces_use_case.dart';
import '../../../startup/domain/use_cases/select_space_use_case.dart';
import '../../../startup/domain/use_cases/select_workspace_use_case.dart';
import '../entities/folder.dart';
import '../entities/tasks_list.dart';
import '../entities/space.dart';
import '../entities/task.dart';
import '../entities/task_parameters.dart';
import '../use_cases/create_list_in_folder_use_case.dart';
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

abstract class TasksRepo{
  Future<dartz.Either<Failure,List<Task>>> getTasksInWorkspace(
      {required GetClickupTasksInWorkspaceParams params});

  Future<dartz.Either<Failure, Task>?> createTaskInList(
      ClickupTaskParams params);

  Future<dartz.Either<Failure, Task>?> updateTask(
      ClickupTaskParams params);

  Future<dartz.Either<Failure, dartz.Unit>?> deleteTask(
      DeleteClickupTaskParams params);

  Future<dartz.Either<Failure, List<Workspace>>> getClickupWorkspaces(
      {required GetClickupWorkspacesParams params});

  Future<dartz.Either<Failure, List<Space>>> getClickupSpacesInWorkspaces(
      {required GetClickupSpacesInWorkspacesParams params});

  Future<dartz.Either<Failure, List<Folder>>> getClickupFolders(
      {required GetClickupFoldersInSpaceParams params});

  Future<dartz.Either<Failure, List<TasksList>>> getClickupListsInFolder(
      {required GetClickupListsInFolderParams params});

  Future<dartz.Either<Failure, List<TasksList>>> getClickupFolderlessLists(
      {required GetClickupFolderlessListsInSpaceParams params});

  Future<dartz.Either<Failure, List<Tag>>> getClickupTags(
      {required GetClickupTagsInSpaceParams params});

  Future<dartz.Either<Failure, dartz.Unit>> removeTagFromTask(
      {required RemoveTagFromTaskParams params});

  Future<dartz.Either<Failure, dartz.Unit>> addTagToTask(
      {required AddTagToTaskParams params});


  Future<dartz.Either<Failure, dartz.Unit>> addTaskToList(
      {required AddTaskToListParams params});

  Future<dartz.Either<Failure, dartz.Unit>?> selectWorkspace(
      SelectWorkspaceParams params);

  Future<dartz.Either<Failure, Workspace>?> getSelectedWorkspace(
      NoParams params);

  Future<dartz.Either<Failure, dartz.Unit>?> selectSpace(
      SelectSpaceParams params);

  Future<dartz.Either<Failure, Space>?> getSelectedSpace(
      NoParams params);

  Future<dartz.Either<Failure, dartz.Unit>?> saveSpacesOfSelectedWorkspace(
      SaveSpacesParams params);

  Future<dartz.Either<Failure, List<Space>>?> getSpacesOfSelectedWorkspace(
      NoParams params);

  Future<dartz.Either<Failure, TasksList>?> getClickupList(
      GetClickupListParams params);

  Future<dartz.Either<Failure, TasksList>?> createClickupListInFolder(
      CreateListInFolderParams params);

  Future<dartz.Either<Failure, TasksList>?> createFolderlessClickupList(
      CreateFolderlessListClickupParams params);

  Future<dartz.Either<Failure, Folder>?> createClickupFolderInSpace(
      CreateFolderInSpaceParams params);

  Future<dartz.Either<Failure, dartz.Unit>?> deleteList(DeleteClickupListParams params);

  Future<dartz.Either<Failure, dartz.Unit>?> deleteFolder(
      DeleteClickupFolderParams params);

  Future<dartz.Either<Failure, dartz.Unit>?> deleteClickupTag(
      DeleteClickupTagParams params);

  Future<dartz.Either<Failure, dartz.Unit>?> createClickupTagInSpace(
      CreateClickupTagInSpaceParams params);

  Future<dartz.Either<Failure, dartz.Unit>?> updateClickupTag(
      UpdateClickupTagParams params);
}