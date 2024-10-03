import 'dart:convert';

import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/models/priority_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_status_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_task_model.dart';
import 'package:thetimeblockingapp/common/models/supabase_workspace_model.dart';
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
    // TODO: implement createWorkspace
    throw UnimplementedError();
  }

  @override
  Future<dartz.Unit> deleteWorkspace({required DeleteWorkspaceParams params}) {
    // TODO: implement deleteWorkspace
    throw UnimplementedError();
  }

  @override
  Future<WorkspaceModel> getAllInWorkspace({required GetAllInWorkspaceParams params}) {
    // TODO: implement getAllInWorkspace
    throw UnimplementedError();
  }

  @override
  Future<List<TaskPriorityModel>> getPriorities(GetPrioritiesParams params) {
    // TODO: implement getPriorities
    throw UnimplementedError();
  }

  @override
  Future<List<TaskStatusModel>> getStatuses(GetStatusesParams params) {
    // TODO: implement getStatuses
    throw UnimplementedError();
  }

  @override
  Future<List<TaskModel>> getTasksInWorkspace({required GetTasksInWorkspaceParams params}) {
    // TODO: implement getTasksInWorkspace
    throw UnimplementedError();
  }

  @override
  Future<List<WorkspaceModel>> getWorkspaces({required GetWorkspacesParams params}) {
    // TODO: implement getWorkspaces
    throw UnimplementedError();
  }

}
