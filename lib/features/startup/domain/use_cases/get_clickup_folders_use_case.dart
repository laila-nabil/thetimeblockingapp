import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/startup/domain/repositories/startup_repo.dart';
import '../../../../common/entities/clickup_workspace.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../../../tasks/domain/entities/clickup_folder.dart';

class GetClickupFoldersUseCase
    implements UseCase<List<ClickupFolder>, GetClickupFoldersParams> {
  final StartUpRepo repo;

  GetClickupFoldersUseCase(this.repo);

  @override
  Future<Either<Failure, List<ClickupFolder>>?> call(
      GetClickupFoldersParams params) {
    return repo.getClickupFolders(params: params);
  }
}

class GetClickupFoldersParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final ClickupWorkspace clickupWorkspace;
  final bool? archived;

  const GetClickupFoldersParams({
    required this.clickupAccessToken,
    required this.clickupWorkspace,
    this.archived,
  });

  @override
  List<Object?> get props => [clickupAccessToken, clickupWorkspace,archived];
}
