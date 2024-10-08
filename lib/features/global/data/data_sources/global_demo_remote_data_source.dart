import 'dart:convert';

import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/models/priority_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_status_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_workspace_model.dart';
import 'package:thetimeblockingapp/core/demo.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/response_interceptor.dart';
import 'package:thetimeblockingapp/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/create_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_priorities_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_statuses_use_case.dart';

import 'package:thetimeblockingapp/features/global/domain/use_cases/get_all_in_workspace_use_case.dart';

import '../../../../core/network/network.dart';
import '../../../../core/network/supabase_header.dart';
import '../../../../core/print_debug.dart';
import '../../../auth/data/data_sources/auth_remote_data_source.dart';
import '../../../tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import '../../domain/use_cases/delete_workspace_use_case.dart';
import '../../domain/use_cases/get_workspaces_use_case.dart';
import 'global_remote_data_source.dart';


class GlobalDemoRemoteDataSourceImpl implements GlobalRemoteDataSource {
  @override
  Future<dartz.Unit> createWorkspace({required CreateWorkspaceParams params}) {
    throw const DemoFailure(message: "");
  }

  @override
  Future<dartz.Unit> deleteWorkspace({required DeleteWorkspaceParams params}) {
    throw const DemoFailure(message: "");
  }

  @override
  Future<WorkspaceModel> getAllInWorkspace({required GetAllInWorkspaceParams params}) {
    return Future.value(Demo.workspaces.first);
  }

  @override
  Future<List<TaskPriorityModel>> getPriorities(GetPrioritiesParams params) {
    return Future.value(Demo.priorities);
  }

  @override
  Future<List<TaskStatusModel>> getStatuses(GetStatusesParams params) {
    return Future.value(Demo.statuses);
  }

  @override
  Future<List<TaskModel>> getTasksInWorkspace({required GetTasksInWorkspaceParams params}) {
    return Future.value(Demo.tasks);
  }

  @override
  Future<List<WorkspaceModel>> getWorkspaces({required GetWorkspacesParams params}) {
    return Future.value(Demo.workspaces);
  }

}
