
import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/data/data_sources/tasks_remote_data_source.dart';


import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folder_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';


import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/create_list_in_folder_use_case.dart';
import '../../domain/use_cases/add_tag_to_task_use_case.dart';
import '../../domain/use_cases/create_tag_in_space_use_case.dart';
import '../../domain/use_cases/delete_tag_use_case.dart';
import '../../domain/use_cases/get_folderless_lists_in_space_use_case.dart';
import '../../domain/use_cases/get_folders_in_space_use_case.dart';
import '../../domain/use_cases/get_list_use_case.dart';
import '../../domain/use_cases/get_lists_in_folder_use_case.dart';
import '../../domain/use_cases/get_spaces_in_workspace_use_case.dart';
import '../../domain/use_cases/get_tags_in_space_use_case.dart';
import '../../domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import '../../domain/use_cases/get_workspaces_use_case.dart';
import '../../domain/use_cases/remove_tag_from_task_use_case.dart';
import '../../domain/use_cases/update_tag_use_case.dart';

class TasksDemoRemoteDataSourceImpl implements TasksRemoteDataSource {
  @override
  Future<List<ClickupTaskModel>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params}) async {
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
      {required GetWorkspacesParams params}) async {
    return Demo.workspaces;
  }

  @override
  Future<List<ClickupFolderModel>> getClickupFolders(
      {required GetFoldersInSpaceParams params}) async {
    return Demo.folders;
  }

  @override
  Future<List<ClickupListModel>> getClickupListsInFolder(
      {required GetListsInFolderParams params}) async {
    return Demo.folderlessLists;
  }

  @override
  Future<List<ClickupListModel>> getClickupFolderlessLists(
      {required GetFolderlessListsInSpaceParams params}) async {
    return Demo.folderlessLists;
  }

  @override
  Future<List<ClickupSpaceModel>> getClickupSpacesInWorkspaces(
      {required GetSpacesInWorkspacesParams params}) async {
    return Demo.spaces;
  }

  @override
  Future<List<ClickupTagModel>> getClickupTags(
      {required GetTagsInSpaceParams params}) async {
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
  Future<ClickupListModel> getClickupList(
      {required GetListParams params}) async {
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
      {required CreateFolderlessListParams params}) async {
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
      {required UpdateTagParams params}) async {
    throw const DemoFailure(message: "");
  }

  @override
  Future<List<SupabaseWorkspaceModel>> getSupabaseWorkspaces({required GetWorkspacesParams params}) {
    // TODO: implement getSupabaseWorkspaces
    throw UnimplementedError();
  }
}
