import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/models/supabase_folder_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_list_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_space_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_tag_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_workspace_model.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/data/data_sources/tasks_remote_data_source.dart';

import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folder_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_all_in_workspace_use_case.dart';

import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/create_list_in_folder_use_case.dart';
import '../../domain/use_cases/add_tag_to_task_use_case.dart';
import '../../domain/use_cases/create_tag_in_space_use_case.dart';
import '../../domain/use_cases/delete_tag_use_case.dart';
import '../../domain/use_cases/get_folderless_lists_in_space_use_case.dart';
import '../../domain/use_cases/get_folders_in_space_use_case.dart';
import '../../domain/use_cases/get_list_use_case.dart';
import '../../domain/use_cases/get_lists_in_folder_use_case.dart';
import '../../domain/use_cases/get_tags_in_space_use_case.dart';
import '../../domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import '../../domain/use_cases/get_workspaces_use_case.dart';
import '../../domain/use_cases/remove_tag_from_task_use_case.dart';
import '../../domain/use_cases/update_tag_use_case.dart';

class TasksDemoRemoteDataSourceImpl implements TasksRemoteDataSource {
  @override
  Future<dartz.Unit> addTagToTask({required AddTagToTaskParams params}) {
    // TODO: implement addTagToTask
    throw UnimplementedError();
  }

  @override
  Future<FolderModel> createFolderInSpace(
      {required CreateFolderInSpaceParams params}) {
    // TODO: implement createFolderInSpace
    throw UnimplementedError();
  }

  @override
  Future<ListModel> createFolderlessList(
      {required CreateFolderlessListParams params}) {
    // TODO: implement createFolderlessList
    throw UnimplementedError();
  }

  @override
  Future<ListModel> createListInFolder(
      {required CreateListInFolderParams params}) {
    // TODO: implement createListInFolder
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> createTagInSpace(
      {required CreateTagInSpaceParams params}) {
    // TODO: implement createTagInSpace
    throw UnimplementedError();
  }

  @override
  Future<TaskModel> createTaskInList({required CreateTaskParams params}) {
    // TODO: implement createTaskInList
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> deleteFolder({required DeleteFolderParams params}) {
    // TODO: implement deleteFolder
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> deleteList({required DeleteListParams params}) {
    // TODO: implement deleteList
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> deleteTag({required DeleteTagParams params}) {
    // TODO: implement deleteTag
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> deleteTask({required DeleteTaskParams params}) {
    // TODO: implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<List<ListModel>> getFolderlessLists(
      {required GetFolderlessListsInSpaceParams params}) {
    // TODO: implement getFolderlessLists
    throw UnimplementedError();
  }

  @override
  Future<List<FolderModel>> getFolders(
      {required GetFoldersInSpaceParams params}) {
    // TODO: implement getFolders
    throw UnimplementedError();
  }

  @override
  Future<ListModel> getList({required GetListParams params}) {
    // TODO: implement getList
    throw UnimplementedError();
  }

  @override
  Future<List<ListModel>> getListsInFolder(
      {required GetListsInFolderParams params}) {
    // TODO: implement getListsInFolder
    throw UnimplementedError();
  }


  @override
  Future<List<TagModel>> getTags({required GetTagsInSpaceParams params}) {
    // TODO: implement getTags
    throw UnimplementedError();
  }

  @override
  Future<List<TaskModel>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params}) {
    // TODO: implement getTasksInWorkspace
    throw UnimplementedError();
  }

  @override
  Future<List<WorkspaceModel>> getWorkspaces(
      {required GetWorkspacesParams params}) {
    // TODO: implement getWorkspaces
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> removeTagFromTask(
      {required RemoveTagFromTaskParams params}) {
    // TODO: implement removeTagFromTask
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> updateTag({required UpdateTagParams params}) {
    // TODO: implement updateTag
    throw UnimplementedError();
  }

  @override
  Future<TaskModel> updateTask({required CreateTaskParams params}) {
    // TODO: implement updateTask
    throw UnimplementedError();
  }

  @override
  Future<WorkspaceModel> getAllInWorkspace(
      {required GetAllInWorkspaceParams params}) {
    // TODO: implement getAllInWorkspace
    throw UnimplementedError();
  }
}
