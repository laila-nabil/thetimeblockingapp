import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folder_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_tag_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_tag_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/update_tag_use_case.dart';

import '../../../../common/entities/tag.dart';
import '../../../../core/error/failures.dart';
import '../../../../common/entities/folder.dart';
import '../../../../common/entities/tasks_list.dart';
import '../../../../common/entities/task.dart';
import '../entities/task_parameters.dart';
import '../use_cases/create_list_in_folder_use_case.dart';
import '../use_cases/add_tag_to_task_use_case.dart';
import '../use_cases/get_tags_in_space_use_case.dart';
import '../use_cases/get_tasks_in_single_workspace_use_case.dart';
import '../use_cases/remove_tag_from_task_use_case.dart';

abstract class TasksRepo {

  Future<dartz.Either<Failure, List<Task>>> getTasksInWorkspace(
      {required GetTasksInWorkspaceParams params});

  Future<dartz.Either<Failure, dartz.Unit>?> createTaskInList(
      CreateTaskParams params);

  Future<dartz.Either<Failure, dartz.Unit>?> updateTask(CreateTaskParams params);

  Future<dartz.Either<Failure, dartz.Unit>?> deleteTask(
      DeleteTaskParams params);


  Future<dartz.Either<Failure, List<Tag>>> getTags(
      {required GetTagsInSpaceParams params});

  Future<dartz.Either<Failure, dartz.Unit>> removeTagFromTask(
      {required RemoveTagFromTaskParams params});

  Future<dartz.Either<Failure, dartz.Unit>> addTagToTask(
      {required AddTagToTaskParams params});


  Future<dartz.Either<Failure, dartz.Unit>?> createListInFolder(
      CreateListInFolderParams params);

  Future<dartz.Either<Failure, dartz.Unit>?> createFolderlessList(
      CreateFolderlessListParams params);

  Future<dartz.Either<Failure, Folder>?> createFolderInSpace(
      CreateFolderInSpaceParams params);

  Future<dartz.Either<Failure, dartz.Unit>?> deleteList(
      DeleteListParams params);

  Future<dartz.Either<Failure, dartz.Unit>?> deleteFolder(
      DeleteFolderParams params);

  Future<dartz.Either<Failure, dartz.Unit>?> deleteTag(DeleteTagParams params);

  Future<dartz.Either<Failure, dartz.Unit>?> createTagInSpace(
      CreateTagInSpaceParams params);

  Future<dartz.Either<Failure, dartz.Unit>?> updateTag(UpdateTagParams params);

}
