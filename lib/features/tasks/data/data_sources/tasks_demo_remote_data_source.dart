import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/models/supabase_tag_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_workspace_model.dart';
import 'package:thetimeblockingapp/features/tasks/data/data_sources/tasks_remote_data_source.dart';

import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folder_in_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_all_in_workspace_use_case.dart';

import '../../domain/entities/task_parameters.dart';
import '../../domain/use_cases/create_list_in_folder_use_case.dart';
import '../../domain/use_cases/add_tag_to_task_use_case.dart';
import '../../domain/use_cases/create_tag_in_workspace_use_case.dart';
import '../../domain/use_cases/delete_tag_use_case.dart';
import '../../domain/use_cases/get_tags_in_workspace_use_case.dart';
import '../../domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import '../../domain/use_cases/remove_tag_from_task_use_case.dart';
import '../../domain/use_cases/update_tag_use_case.dart';

class TasksDemoRemoteDataSourceImpl implements TasksRemoteDataSource {
  @override
  Future<dartz.Unit> addTagToTask({required AddTagToTaskParams params}) {
    // TODO  implement addTagToTask
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> createFolderInWorkspace(
      {required CreateFolderInSpaceParams params}) {
    // TODO  implement createFolderInSpace
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> createFolderlessList(
      {required CreateFolderlessListParams params}) {
    // TODO  implement createFolderlessList
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> createListInFolder(
      {required CreateListInFolderParams params}) {
    // TODO  implement createListInFolder
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> createTagInWorkspace(
      {required CreateTagInWorkspaceParams params}) {
    // TODO  implement createTagInSpace
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> createTaskInList({required CreateTaskParams params}) {
    // TODO  implement createTaskInList
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> deleteFolder({required DeleteFolderParams params}) {
    // TODO  implement deleteFolder
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> deleteList({required DeleteListParams params}) {
    // TODO  implement deleteList
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> deleteTag({required DeleteTagParams params}) {
    // TODO  implement deleteTag
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> deleteTask({required DeleteTaskParams params}) {
    // TODO  implement deleteTask
    throw UnimplementedError();
  }

  @override
  Future<List<TagModel>> getTags({required GetTagsInWorkspaceParams params}) {
    // TODO  implement getTags
    throw UnimplementedError();
  }

  @override
  Future<List<TaskModel>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params}) {
    // TODO  implement getTasksInWorkspace
    throw UnimplementedError();
  }


  @override
  Future<dartz.Unit> removeTagFromTask(
      {required RemoveTagFromTaskParams params}) {
    // TODO  implement removeTagFromTask
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> updateTag({required UpdateTagParams params}) {
    // TODO  implement updateTag
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> updateTask({required CreateTaskParams params}) {
    // TODO  implement updateTask
    throw UnimplementedError();
  }

  @override
  Future<WorkspaceModel> getAllInWorkspace(
      {required GetAllInWorkspaceParams params}) {
    // TODO  implement getAllInWorkspace
    throw UnimplementedError();
  }
}
