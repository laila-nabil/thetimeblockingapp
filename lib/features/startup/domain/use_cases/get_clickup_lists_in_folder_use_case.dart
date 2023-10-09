import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/startup/domain/repositories/startup_repo.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../../../tasks/domain/entities/clickup_folder.dart';
import '../../../tasks/domain/entities/clickup_list.dart';

class GetClickupListsInFolderUseCase
    implements UseCase<List<ClickupList>, GetClickupListsInFolderParams> {
  final StartUpRepo repo;

  GetClickupListsInFolderUseCase(this.repo);

  @override
  Future<Either<Failure, List<ClickupList>>?> call(
      GetClickupListsInFolderParams params) {
    return repo.getClickupListsInFolder(params: params);
  }
}

class GetClickupListsInFolderParams extends Equatable {
  final ClickupAccessToken clickupAccessToken;
  final ClickupFolder clickupFolder;
  final bool? archived;

  const GetClickupListsInFolderParams({
    required this.clickupAccessToken,
    required this.clickupFolder,
    this.archived,
  });

  @override
  List<Object?> get props => [clickupAccessToken, clickupFolder,archived];
}
