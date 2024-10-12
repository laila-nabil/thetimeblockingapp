import 'package:dartz/dartz.dart';
import 'package:thetimeblockingapp/common/models/supabase_workspace_model.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/auth/data/data_sources/auth_local_data_source.dart';
import 'package:thetimeblockingapp/features/global/data/data_sources/global_remote_data_source.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/delete_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_workspaces_use_case.dart';
import 'package:thetimeblockingapp/features/settings/data/data_sources/settings_remote_data_source.dart';
import 'package:thetimeblockingapp/features/settings/domain/repositories/settings_repo.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/report_issue_use_case.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/request_feature_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/data/data_sources/tasks_remote_data_source.dart';

import '../../../../core/repo_handler.dart';
import '../../../auth/domain/use_cases/delete_account_use_case.dart';

class SettingsRepoImpl implements SettingsRepo {
  final SettingsRemoteDataSource settingsRemoteDataSource;
  final GlobalRemoteDataSource globalRemoteDataSource;
  final AuthLocalDataSource authLocalDataSource;

  SettingsRepoImpl(this.settingsRemoteDataSource, this.globalRemoteDataSource,
      this.authLocalDataSource);

  @override
  Future<Either<Failure, Unit>> requestFeature(RequestFeatureParams params) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () async =>
      await settingsRemoteDataSource.requestFeature(params: params),
    );
  }

  @override
  Future<Either<Failure, Unit>> reportIssue(ReportIssueParams params) {
    return repoHandleRemoteRequest(
      remoteDataSourceRequest: () async =>
      await settingsRemoteDataSource.reportIssue(params: params),
    );
  }

}
