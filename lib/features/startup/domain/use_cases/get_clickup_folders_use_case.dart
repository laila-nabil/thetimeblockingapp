import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/startup/domain/repositories/startup_repo.dart';
import '../../../../common/entities/clickup_workspace.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../../../tasks/domain/entities/clickup_folder.dart';

class GetClickUpFoldersUseCase
    implements UseCase<List<ClickupFolder>, GetClickUpFoldersParams> {
  final StartUpRepo repo;

  GetClickUpFoldersUseCase(this.repo);

  @override
  Future<Either<Failure, List<ClickupFolder>>?> call(
      GetClickUpFoldersParams params) {
    return repo.getClickUpFolders(params: params);
  }
}

class GetClickUpFoldersParams extends Equatable {
  final ClickUpAccessToken clickUpAccessToken;
  final ClickupWorkspace clickupWorkspace;
  final bool? archived;

  const GetClickUpFoldersParams({
    required this.clickUpAccessToken,
    required this.clickupWorkspace,
    this.archived,
  });

  @override
  List<Object?> get props => [clickUpAccessToken, clickupWorkspace,archived];
}
