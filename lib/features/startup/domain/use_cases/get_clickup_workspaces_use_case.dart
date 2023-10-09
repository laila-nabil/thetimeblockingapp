import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/startup/domain/repositories/startup_repo.dart';
import '../../../../common/entities/clickup_workspace.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';

class GetClickupWorkspacesUseCase
    implements UseCase<List<ClickupWorkspace>, GetClickupWorkspacesParams> {
  final StartUpRepo repo;

  GetClickupWorkspacesUseCase(this.repo);

  @override
  Future<Either<Failure, List<ClickupWorkspace>>?> call(
      GetClickupWorkspacesParams params) {
    return repo.getClickupWorkspaces(params: params);
  }
}

class GetClickupWorkspacesParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;

  const GetClickupWorkspacesParams(this.clickupAccessToken);

  @override
  List<Object?> get props => [clickupAccessToken];
}
