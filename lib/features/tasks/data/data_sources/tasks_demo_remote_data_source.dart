import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/models/priority_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_folder_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_list_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_space_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_status_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_tag_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_workspace_model.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_priorities_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_statuses_use_case.dart';
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
import '../../domain/use_cases/get_tags_in_space_use_case.dart';
import '../../domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import '../../domain/use_cases/get_workspaces_use_case.dart';
import '../../domain/use_cases/remove_tag_from_task_use_case.dart';
import '../../domain/use_cases/update_tag_use_case.dart';

class TasksDemoRemoteDataSourceImpl implements TasksRemoteDataSource {
  @override
  Future<dartz.Unit> addTagToTask({required AddTagToTaskParams params}) {
    // TODO C implement addTagToTask
    throw UnimplementedError();
  }

  @override
  Future<FolderModel> createFolderInSpace(
      {required CreateFolderInSpaceParams params}) {
    // TODO C implement createFolderInSpace
    throw UnimplementedError();
  }

  @override
  Future<ListModel> createFolderlessList(
      {required CreateFolderlessListParams params}) {
    // TODO C implement createFolderlessList
    throw UnimplementedError();
  }

  @override
  Future<ListModel> createListInFolder(
      {required CreateListInFolderParams params}) {
    // TODO C implement createListInFolder
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> createTagInSpace(
      {required CreateTagInSpaceParams params}) {
    // TODO C implement createTagInSpace
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> createTaskInList({required CreateTaskParams params}) {
    // TODO C implement createTaskInList
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> deleteFolder({required DeleteFolderParams params}) {
    // TODO C implement deleteFolder
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> deleteList({required DeleteListParams params}) {
    // TODO C implement deleteList
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> deleteTag({required DeleteTagParams params}) {
    // TODO C implement deleteTag
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> deleteTask({required DeleteTaskParams params}) {
    // TODO C implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<List<TagModel>> getTags({required GetTagsInSpaceParams params}) {
    // TODO C implement getTags
    throw UnimplementedError();
  }

  @override
  Future<List<TaskModel>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params}) {
    // TODO C implement getTasksInWorkspace
    throw UnimplementedError();
  }

  @override
  Future<List<WorkspaceModel>> getWorkspaces(
      {required GetWorkspacesParams params}) {
    // TODO C implement getWorkspaces
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> removeTagFromTask(
      {required RemoveTagFromTaskParams params}) {
    // TODO C implement removeTagFromTask
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> updateTag({required UpdateTagParams params}) {
    // TODO C implement updateTag
    throw UnimplementedError();
  }

  @override
  Future<TaskModel> updateTask({required CreateTaskParams params}) {
    // TODO C implement updateTask
    throw UnimplementedError();
  }

  @override
  Future<WorkspaceModel> getAllInWorkspace(
      {required GetAllInWorkspaceParams params}) {
    // TODO C implement getAllInWorkspace
    throw UnimplementedError();
  }

  @override
  Future<List<TaskPriorityModel>> getPriorities(GetPrioritiesParams params) {
    // TODO C implement getPriorities
    throw UnimplementedError();
  }

  @override
  Future<List<TaskStatusModel>> getStatuses(GetStatusesParams params) {
    // TODO C implement getStatuses
    throw UnimplementedError();
  }
}
