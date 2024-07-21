
import 'package:dartz/dartz.dart' as dartz; 
import 'package:thetimeblockingapp/core/demo.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/data/data_sources/tasks_remote_data_source.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_space_model.dart';
import 'package:thetimeblockingapp/features/tasks/data/models/clickup_task_model.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folder_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_clickup_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';

import '../../../../common/models/clickup_workspace_model.dart';
import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/create_list_in_folder_use_case.dart';
import '../../domain/use_cases/add_task_to_list_use_case.dart';
import '../../domain/use_cases/add_tag_to_task_use_case.dart';
import '../../domain/use_cases/create_tag_in_space_use_case.dart';
import '../../domain/use_cases/delete_tag_use_case.dart';
import '../../domain/use_cases/get_folderless_lists_in_space_use_case.dart';
import '../../domain/use_cases/get_folders_in_space_use_case.dart';
import '../../domain/use_cases/get_clickup_list_use_case.dart';
import '../../domain/use_cases/get_clickup_lists_in_folder_use_case.dart';
import '../../domain/use_cases/get_clickup_spaces_in_workspace_use_case.dart';
import '../../domain/use_cases/get_clickup_tags_in_space_use_case.dart';
import '../../domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import '../../domain/use_cases/get_clickup_workspaces_use_case.dart';
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
              .toList();
    }
    return Demo.tasks;
  }

  @override
  Future<ClickupTaskModel> createTaskInList(
      {required CreateTaskParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<ClickupTaskModel> updateTask(
      {required CreateTaskParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<dartz.Unit> deleteTask({required DeleteTaskParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<List<ClickupWorkspaceModel>> getClickupWorkspaces(
      {required GetClickupWorkspacesParams params}) async {
    return Demo.workspaces;
  }

  @override
  Future<List<ClickupFolderModel>> getClickupFolders(
      {required GetFoldersInSpaceParams params}) async {
    return Demo.folders;
  }

  @override
  Future<List<ClickupListModel>> getClickupListsInFolder(
      {required GetClickupListsInFolderParams params}) async {
    return Demo.folderlessLists;
  }

  @override
  Future<List<ClickupListModel>> getClickupFolderlessLists(
      {required GetFolderlessListsInSpaceParams params}) async {
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
  Future<dartz.Unit> removeTagFromTask(
      {required RemoveTagFromTaskParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<dartz.Unit> addTagToTask({required AddTagToTaskParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<dartz.Unit> addTaskToList({required AddTaskToListParams params}) async {
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
      {required CreateListInFolderParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<ClickupListModel> createFolderlessClickupList(
      {required CreateFolderlessListClickupParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<ClickupFolderModel> createClickupFolderInSpace(
      {required CreateFolderInSpaceParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<dartz.Unit> deleteList({required DeleteListParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<dartz.Unit> deleteFolder({required DeleteFolderParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<dartz.Unit> createClickupTagInSpace(
      {required CreateTagInSpaceParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<dartz.Unit> deleteClickupTag(
      {required DeleteTagParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<dartz.Unit> updateClickupTag(
      {required UpdateClickupTagParams params}) async {
    throw const DemoFailure(message: "");
  }
}
