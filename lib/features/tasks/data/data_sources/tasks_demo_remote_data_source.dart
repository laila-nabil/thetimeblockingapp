
import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/core/demo.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/data/data_sources/tasks_remote_data_source.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_space_model.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_folder_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_clickup_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';

import '../../../../common/models/clickup_workspace_model.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/create_clickup_list_in_folder_use_case.dart';
import '../../domain/use_cases/add_task_to_list_use_case.dart';
import '../../domain/use_cases/add_tag_to_task_use_case.dart';
import '../../domain/use_cases/create_clickup_tag_in_space_use_case.dart';
import '../../domain/use_cases/delete_clickup_tag_use_case.dart';
import '../../domain/use_cases/get_clickup_folderless_lists_in_space_use_case.dart';
import '../../domain/use_cases/get_clickup_folders_in_space_use_case.dart';
import '../../domain/use_cases/get_clickup_list_use_case.dart';
import '../../domain/use_cases/get_clickup_lists_in_folder_use_case.dart';
import '../../domain/use_cases/get_clickup_spaces_in_workspace_use_case.dart';
import '../../domain/use_cases/get_clickup_tags_in_space_use_case.dart';
import '../../domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import '../../domain/use_cases/get_clickup_workspaces_use_case.dart';
import '../../domain/use_cases/remove_task_from_list_task_use_case.dart';
import '../../domain/use_cases/remove_tag_from_task_use_case.dart';
import '../../domain/use_cases/update_clickup_tag_use_case.dart';
import '../models/clickup_folder_model.dart';
import '../models/clickup_list_model.dart';

class TasksDemoRemoteDataSourceImpl implements TasksRemoteDataSource {
  @override
  Future<List<ClickupTaskModel>> getTasksInWorkspace(
      {required GetClickupTasksInWorkspaceParams params}) async {
    if (params.filtersParams.filterByListsIds?.isNotEmpty == true) {
      return Demo.tasks
              .where((element) =>
                  element.list?.id ==
                  params.filtersParams.filterByListsIds?.first)
              .toList() ??
          [];
    }
    return Demo.tasks;
  }

  @override
  Future<ClickupTaskModel> createTaskInList(
      {required ClickupTaskParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<ClickupTaskModel> updateTask(
      {required ClickupTaskParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<Unit> deleteTask({required DeleteClickupTaskParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<List<ClickupWorkspaceModel>> getClickupWorkspaces(
      {required GetClickupWorkspacesParams params}) async {
    return Demo.workspaces;
  }

  @override
  Future<List<ClickupFolderModel>> getClickupFolders(
      {required GetClickupFoldersInSpaceParams params}) async {
    return Demo.folders;
  }

  @override
  Future<List<ClickupListModel>> getClickupListsInFolder(
      {required GetClickupListsInFolderParams params}) async {
    return Demo.folderlessLists;
  }

  @override
  Future<List<ClickupListModel>> getClickupFolderlessLists(
      {required GetClickupFolderlessListsInSpaceParams params}) async {
    return Demo.folderlessLists;
  }

  @override
  Future<List<ClickupSpaceModel>> getClickupSpacesInWorkspaces(
      {required GetClickupSpacesInWorkspacesParams params}) async {
    return Demo.spaces;
  }

  @override
  Future<List<ClickupTagModel>> getClickupTags(
      {required GetClickupTagsInSpaceParams params}) async {
    return Demo.tags;
  }

  @override
  Future<Unit> removeTagFromTask(
      {required RemoveTagFromTaskParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<Unit> addTagToTask({required AddTagToTaskParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<Unit> addTaskToList({required AddTaskToListParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<Unit> removeTaskFromAdditionalList(
      {required RemoveTaskFromListParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<ClickupListModel> getClickupList(
      {required GetClickupListParams params}) async {
    return Demo.folderlessLists
        .where((element) => params.listId == element.id)
        .first;
  }

  @override
  Future<ClickupListModel> createClickupListInFolder(
      {required CreateClickupListInFolderParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<ClickupListModel> createFolderlessClickupList(
      {required CreateFolderlessListClickupParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<ClickupFolderModel> createClickupFolderInSpace(
      {required CreateClickupFolderInSpaceParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<Unit> deleteList({required DeleteClickupListParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<Unit> deleteFolder({required DeleteClickupFolderParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<Unit> createClickupTagInSpace(
      {required CreateClickupTagInSpaceParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<Unit> deleteClickupTag(
      {required DeleteClickupTagParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<Unit> updateClickupTag(
      {required UpdateClickupTagParams params}) async {
    throw const DemoFailure(message: "");
  }
}
