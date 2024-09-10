import 'package:dartz/dartz.dart' as dartz;
import 'package:thetimeblockingapp/common/entities/tag.dart';
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/common/models/supabase_tag_model.dart';
import 'package:thetimeblockingapp/core/analytics/analytics.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/entities/space.dart';
import 'package:thetimeblockingapp/features/tasks/domain/repositories/tasks_repo.dart';

class CreateTagInWorkspaceUseCase
    implements UseCase<dartz.Unit, CreateTagInWorkspaceParams> {
  final TasksRepo repo;

  CreateTagInWorkspaceUseCase(this.repo);

  static bool readyToSubmit(String tagName) =>
      tagName?.isNotEmpty == true &&
          tagName?.endsWith("?") == false &&
          tagName?.endsWith("؟") == false;

  @override
  Future<dartz.Either<Failure, dartz.Unit>?> call(CreateTagInWorkspaceParams params) async{
    if(readyToSubmit(params.tagName) == false){
      await serviceLocator<Analytics>()
          .logEvent(AnalyticsEvents.createTag.name, parameters: {
        AnalyticsEventParameter.status.name: false,
        AnalyticsEventParameter.error.name: "must not contain ? at the end",
      });
      return const dartz.Left(InputFailure(message: "must not contain ? at the end"));
    }
    final result = await repo.createTagInWorkspace(params);
    await result?.fold(
            (l) async =>await serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.createTag.name, parameters: {
          AnalyticsEventParameter.status.name: false,
          AnalyticsEventParameter.error.name: l.toString(),
        }),
            (r) async =>await  serviceLocator<Analytics>()
            .logEvent(AnalyticsEvents.createTag.name, parameters: {
          AnalyticsEventParameter.status.name: true,
        }));
    return result;
  }
}

class CreateTagInWorkspaceParams {
  final Workspace workspace;
  final AccessToken accessToken;
  final String tagName;
  final User user;
  Map<String, dynamic> toJson() {
    return {
      'workspace_id': workspace.id,
      'name': tagName,
      'user_id': user.id,
    };
  }

  CreateTagInWorkspaceParams(
      {required this.workspace,
      required this.accessToken,
      required this.user,
      required this.tagName});
}
