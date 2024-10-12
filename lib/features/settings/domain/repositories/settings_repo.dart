import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/features/settings/domain/use_cases/report_issue_use_case.dart';
import 'package:thetimeblockingapp/features/settings/domain/use_cases/request_feature_use_case.dart';

import '../../../../core/error/failures.dart';
import '../../../auth/domain/use_cases/delete_account_use_case.dart';

abstract class SettingsRepo {
  Future<dartz.Either<Failure, dartz.Unit>> requestFeature(
      RequestFeatureParams params);

  Future<dartz.Either<Failure, dartz.Unit>> reportIssue(ReportIssueParams params);
}
