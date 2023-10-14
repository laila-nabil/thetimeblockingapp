import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';

import '../../../../common/entities/clickup_workspace.dart';
import '../../../../core/error/failures.dart';
import '../entities/clickup_folder.dart';
import '../entities/clickup_list.dart';
import '../entities/clickup_space.dart';
import '../entities/clickup_task.dart';
import '../entities/task_parameters.dart';
import '../use_cases/get_clickup_folderless_lists_in_space_use_case.dart';
import '../use_cases/get_clickup_folders_in_space_use_case.dart';
import '../use_cases/get_clickup_lists_in_folder_use_case.dart';
import '../use_cases/get_clickup_spaces_in_workspace_use_case.dart';
import '../use_cases/get_clickup_tags_in_space_use_case.dart';
import '../use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import '../use_cases/get_clickup_workspaces_use_case.dart';

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
}