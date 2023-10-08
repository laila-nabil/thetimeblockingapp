import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/startup/domain/repositories/startup_repo.dart';
import '../../../../common/entities/clickup_workspace.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';

class GetClickUpWorkspacesUseCase
    implements UseCase<List<ClickupWorkspace>, GetClickUpWorkspacesParams> {
  final StartUpRepo repo;

  GetClickUpWorkspacesUseCase(this.repo);

  @override
  Future<Either<Failure, List<ClickupWorkspace>>?> call(
      GetClickUpWorkspacesParams params) {
    return repo.getClickUpWorkspaces(params: params);
  }
}

class GetClickUpWorkspacesParams extends Equatable {
  final ClickUpAccessToken clickUpAccessToken;

  const GetClickUpWorkspacesParams(this.clickUpAccessToken);

  @override
  List<Object?> get props => [clickUpAccessToken];
}
