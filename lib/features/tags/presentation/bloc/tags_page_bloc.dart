import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_tag_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_tag_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tags_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/update_clickup_tag_use_case.dart';

import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../../../tasks/domain/entities/task_parameters.dart';
import '../../../tasks/domain/use_cases/create_clickup_task_use_case.dart';
import '../../../tasks/domain/use_cases/delete_clickup_task_use_case.dart';
import '../../../tasks/domain/use_cases/update_clickup_task_use_case.dart';

part 'tags_page_event.dart';

part 'tags_page_state.dart';

class TagsPageBloc extends Bloc<TagsPageEvent, TagsPageState> {
  final GetClickupTagsInSpaceUseCase _getClickupTagsInSpaceUseCase;
  final GetClickupTasksInSingleWorkspaceUseCase
      _getClickupTasksInSingleWorkspaceUseCase;
  final CreateClickupTagInSpaceUseCase _createClickupTagInSpaceUseCase;
  final UpdateClickupTagUseCase _updateClickupTagUseCase;
  final DeleteClickupTagUseCase _deleteClickupTagUseCase;
  final CreateClickupTaskUseCase _createClickupTaskUseCase;
  final UpdateClickupTaskUseCase _updateClickupTaskUseCase;
  final DeleteClickupTaskUseCase _deleteClickupTaskUseCase;

  TagsPageBloc(
      this._getClickupTagsInSpaceUseCase,
      this._getClickupTasksInSingleWorkspaceUseCase,
      this._createClickupTagInSpaceUseCase,
      this._updateClickupTagUseCase,
      this._deleteClickupTagUseCase,
      this._createClickupTaskUseCase,
      this._updateClickupTaskUseCase,
      this._deleteClickupTaskUseCase)
      : super(const TagsPageState(tagsPageStatus: TagsPageStatus.initial)) {
    on<TagsPageEvent>((event, emit) async {
      if (event is GetClickupTagsInSpaceEvent) {
        emit(state.copyWith(tagsPageStatus: TagsPageStatus.loading));
        final result = await _getClickupTagsInSpaceUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.getTagsFailure,
                getTagsInSpaceFailure: l)),
            (r) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.getTagsSuccess,
                getTagsInSpaceResult: r)));
      } else if (event is GetClickupTasksForTagEvent) {
        emit(state.copyWith(tagsPageStatus: TagsPageStatus.loading));
        final result = await _getClickupTasksInSingleWorkspaceUseCase(
            GetClickupTasksInWorkspaceParams(
                workspaceId: event.workspace.id ?? "",
                filtersParams: GetClickupTasksInWorkspaceFiltersParams(
                    clickupAccessToken: event.clickupAccessToken,
                    filterBySpaceIds: [event.space.id ?? ""],
                    filterByTags: [event.tag.name ?? ""])));
        result?.fold(
            (l) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.getTasksForTagFailure,
                getTasksForTagFailure: l)),
            (r) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.getTasksForTagSuccess,
                currentTagTasksResult: r)));
      } else if (event is CreateClickupTagInSpaceEvent) {
        emit(state.copyWith(tagsPageStatus: TagsPageStatus.loading));
        final result = await _createClickupTagInSpaceUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.createTagFailure,
                createTagFailure: l)), (r) {
          emit(state.copyWith(
            tagsPageStatus: TagsPageStatus.createTagSuccess,
          ));
          add(GetClickupTagsInSpaceEvent(GetClickupTagsInSpaceParams(
              clickupAccessToken: event.params.clickupAccessToken,
              clickupSpace: event.params.space)));
        });
      } else if (event is UpdateClickupTagEvent) {
        emit(state.copyWith(tagsPageStatus: TagsPageStatus.loading));
        final result = await _updateClickupTagUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.updateTagFailure,
                updateTagFailure: l)), (r) {
          emit(state.copyWith(
            tagsPageStatus: TagsPageStatus.updateTaskSuccess,
          ));
          add(GetClickupTagsInSpaceEvent(GetClickupTagsInSpaceParams(
              clickupAccessToken: event.params.clickupAccessToken,
              clickupSpace: event.params.space)));
        });
      } else if (event is DeleteClickupTagEvent) {
        if (event.tryEvent == true) {
          emit(state.copyWith(
              tagsPageStatus: TagsPageStatus.deleteTagTry,
              toDeleteTag: event.params?.tag));
        } else if (event.params == null) {
          emit(state.copyWith(
            tagsPageStatus: TagsPageStatus.deleteTagCanceled,
          ));
        } else {
          emit(state.copyWith(tagsPageStatus: TagsPageStatus.loading));
          final result = await _deleteClickupTagUseCase(event.params!);
          result?.fold(
              (l) => emit(state.copyWith(
                  tagsPageStatus: TagsPageStatus.updateTagFailure,
                  updateTagFailure: l)), (r) {
            emit(state.copyWith(
              tagsPageStatus: TagsPageStatus.updateTaskSuccess,
            ));
            add(GetClickupTagsInSpaceEvent(GetClickupTagsInSpaceParams(
                clickupAccessToken: event.params!.clickupAccessToken,
                clickupSpace: event.params!.space)));
          });
        }
      } else if (event is CreateClickupTaskEvent) {
        emit(state.copyWith(tagsPageStatus: TagsPageStatus.loading));
        final result = await _createClickupTaskUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.createTaskFailed,
                createTaskFailure: l)), (r) {
          emit(state.copyWith(
            tagsPageStatus: TagsPageStatus.createTaskSuccess,
          ));
          add(GetClickupTasksForTagEvent(
              clickupAccessToken: event.params.clickupAccessToken,
              space: event.params.clickupSpace!,
              tag: state.navigateTag!,
              workspace: event.workspace));
        });
      } else if (event is UpdateClickupTaskEvent) {
        emit(state.copyWith(tagsPageStatus: TagsPageStatus.loading));
        final result = await _updateClickupTaskUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.updateTagFailure,
                updateTagFailure: l)), (r) {
          emit(state.copyWith(
            tagsPageStatus: TagsPageStatus.updateTaskSuccess,
          ));
          add(GetClickupTasksForTagEvent(
              clickupAccessToken: event.params.clickupAccessToken,
              space: event.params.clickupSpace!,
              tag: state.navigateTag!,
              workspace: event.workspace));
        });
      } else if (event is DeleteClickupTaskEvent) {
        emit(state.copyWith(tagsPageStatus: TagsPageStatus.loading));
        final result = await _deleteClickupTaskUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.updateTagFailure,
                updateTagFailure: l)), (r) {
          emit(state.copyWith(
            tagsPageStatus: TagsPageStatus.updateTaskSuccess,
          ));
          add(GetClickupTasksForTagEvent(
              clickupAccessToken: event.params.clickupAccessToken,
              space: event.params.task.space!,
              tag: state.navigateTag!,
              workspace: event.workspace));
        });
      } else if (event is NavigateToTagPageEvent) {
        emit(state.copyWith(
            tagsPageStatus: TagsPageStatus.navigateTag,
            navigateTag: event.tag));
      }
    });
  }
}
