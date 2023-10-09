import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../entities/clickup_list.dart';

///FIXME A {"err":"Team not authorized","ECODE":"OAUTH_027"}

class GetClickupFolderlessListsUseCase
    implements UseCase<List<ClickupList>, GetClickupFolderlessListsParams> {
  final TasksRepo repo;

  GetClickupFolderlessListsUseCase(this.repo);

  @override
  Future<Either<Failure, List<ClickupList>>?> call(
      GetClickupFolderlessListsParams params) {
    return repo.getClickupFolderlessLists(params: params);
  }
}

class GetClickupFolderlessListsParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final ClickupWorkspace clickupWorkspace;
  final bool? archived;

  const GetClickupFolderlessListsParams({
    required this.clickupAccessToken,
    required this.clickupWorkspace,
    this.archived,
  });

  @override
  List<Object?> get props => [clickupAccessToken, clickupWorkspace,archived];
}
