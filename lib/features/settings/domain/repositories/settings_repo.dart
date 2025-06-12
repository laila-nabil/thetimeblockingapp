import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/features/settings/domain/use_cases/report_issue_use_case.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/request_feature_use_case.dart';

import '../../../../common/entities/access_token.dart';
import '../../../../common/entities/settings.dart';
import '../../../../common/models/access_token_model.dart';
import '../../../../common/models/supabase_settings_model.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/use_cases/delete_account_use_case.dart';
import '../use_cases/update_settings_use_case.dart';

abstract class SettingsRepo {
  Future<dartz.Either<Failure, dartz.Unit>> requestFeature(
      RequestFeatureParams params);

  Future<dartz.Either<Failure, dartz.Unit>> reportIssue(
      ReportIssueParams params);

  Future<dartz.Either<Failure, dartz.Unit>> createUpdateSettings(
      {required CreateUpdateSettingsParams createUpdateSettingsParams});
}
