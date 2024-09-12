import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/tag.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';

import 'package:thetimeblockingapp/common/entities/space.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_tag_in_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_tag_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/duplicate_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tags_in_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/update_tag_use_case.dart';

import '../../../../core/error/failures.dart';
import '../../../../common/entities/access_token.dart';
import '../../../tasks/domain/entities/task_parameters.dart';
import '../../../tasks/domain/use_cases/create_task_use_case.dart';
import '../../../tasks/domain/use_cases/delete_task_use_case.dart';
import '../../../tasks/domain/use_cases/update_task_use_case.dart';

part 'tags_page_event.dart';

part 'tags_page_state.dart';

class TagsPageBloc extends Bloc<TagsPageEvent, TagsPageState> {
  final GetTagsInWorkspaceUseCase _getTagsInSpaceUseCase;
  final GetTasksInSingleWorkspaceUseCase
      _getTasksInSingleWorkspaceUseCase;
  final CreateTagInWorkspaceUseCase _createTagInSpaceUseCase;
  final UpdateTagUseCase _updateTagUseCase;
  final DeleteTagUseCase _deleteTagUseCase;
  final CreateTaskUseCase _createTaskUseCase;
  final DuplicateTaskUseCase _duplicateTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  TagsPageBloc(
      this._getTagsInSpaceUseCase,
      this._getTasksInSingleWorkspaceUseCase,
      this._createTagInSpaceUseCase,
      this._duplicateTaskUseCase,
      this._updateTagUseCase,
      this._deleteTagUseCase,
      this._createTaskUseCase,
      this._updateTaskUseCase,
      this._deleteTaskUseCase)
      : super(const TagsPageState(tagsPageStatus: TagsPageStatus.initial)) {
    on<TagsPageEvent>((event, emit) async {
      if (event is GetTagsInWorkspaceEvent) {
        emit(state.copyWith(tagsPageStatus: TagsPageStatus.loading));
        final result = await _getTagsInSpaceUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.getTagsFailure,
                getTagsInSpaceFailure: l)),
            (r) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.getTagsSuccess,
                getTagsInSpaceResult: r)));
      } else if (event is GetTasksForTagEvent) {
        emit(state.copyWith(tagsPageStatus: TagsPageStatus.loading));
        final result = await _getTasksInSingleWorkspaceUseCase(
            GetTasksInWorkspaceParams(
                workspaceId: event.workspace.id ?? 0,
                filtersParams: GetTasksInWorkspaceFiltersParams(
                    accessToken: event.accessToken,
                    filterBySpaceIds: [event.space.id ?? ""],
                    filterByTag: event.tag),
                backendMode: serviceLocator<BackendMode>().mode));
        result?.fold(
            (l) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.getTasksForTagFailure,
                getTasksForTagFailure: l)),
            (r) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.getTasksForTagSuccess,
                currentTagTasksResult: r)));
      } else if (event is CreateTagInSpaceEvent) {
        if (event.tryEvent == true) {
          emit(state.copyWith(
              tagsPageStatus: TagsPageStatus.createTagTry,));
        } else if (event.params == null) {
          emit(state.copyWith(
            tagsPageStatus: TagsPageStatus.createTagCancel,
          ));
        } else {
          emit(state.copyWith(tagsPageStatus: TagsPageStatus.loading));
          final result = await _createTagInSpaceUseCase(event.params!);
          result?.fold(
                  (l) => emit(state.copyWith(
                  tagsPageStatus: TagsPageStatus.createTagFailure,
                  createTagFailure: l)), (r) {
            emit(state.copyWith(
              tagsPageStatus: TagsPageStatus.createTagSuccess,
            ));
            add(GetTagsInWorkspaceEvent(GetTagsInWorkspaceParams(
                accessToken: event.params!.accessToken,
                workspace: event.params!.workspace)));
          });
        }
      } else if (event is UpdateTagEvent) {
        if(event.tryEvent == true){
          emit(state.copyWith(
              tagsPageStatus: TagsPageStatus.updateTagTry,
              toUpdateTag: event.params?.newTag));
        } else if (event.params == null) {
          emit(state.copyWith(
            tagsPageStatus: TagsPageStatus.updateTagCanceled,
          ));
        }
        else {
          emit(state.copyWith(tagsPageStatus: TagsPageStatus.loading));
          final result = await _updateTagUseCase(event.params!);
          result?.fold(
              (l) => emit(state.copyWith(
                  tagsPageStatus: TagsPageStatus.updateTagFailure,
                  updateTagFailure: l)), (r) {
            emit(state.copyWith(
              tagsPageStatus: TagsPageStatus.updateTagSuccess,
              updateTagResult: event.params?.newTag
            ));
            if(event.insideTagPage==false){
              add(GetTagsInWorkspaceEvent(GetTagsInWorkspaceParams(
                  accessToken: event.params!.accessToken,
                  workspace: event.params!.workspace)));
            }
          });
        }
      } else if (event is DeleteTagEvent) {
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
          final result = await _deleteTagUseCase(event.params!);
          result?.fold(
              (l) => emit(state.copyWith(
                  tagsPageStatus: TagsPageStatus.deleteTagFailure,
                  deleteTagFailure: l)), (r) {
            emit(state.copyWith(
              tagsPageStatus: TagsPageStatus.updateTaskSuccess,
            ));
            add(GetTagsInWorkspaceEvent(GetTagsInWorkspaceParams(
                accessToken: event.params!.accessToken,
                workspace: event.params!.workspace)));
          });
        }
      } else if (event is CreateTaskEvent) {
        emit(state.copyWith(tagsPageStatus: TagsPageStatus.loading));
        final result = await _createTaskUseCase(event.params,event.workspace.id!);
        result?.fold(
            (l) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.createTaskFailed,
                createTaskFailure: l)), (r) {
          emit(state.copyWith(
            tagsPageStatus: TagsPageStatus.createTaskSuccess,
          ));
          add(GetTasksForTagEvent(
              accessToken: event.params.accessToken,
              space: event.params.space!,
              tag: state.navigateTag!,
              workspace: event.workspace));
        });
      }
        else if (event is DuplicateTaskEvent) {
        emit(state.copyWith(tagsPageStatus: TagsPageStatus.loading));
        final result = await _duplicateTaskUseCase(event.params,event.workspace.id!);
        result?.fold(
            (l) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.createTaskFailed,
                createTaskFailure: l)), (r) {
          emit(state.copyWith(
            tagsPageStatus: TagsPageStatus.createTaskSuccess,
          ));
          add(GetTasksForTagEvent(
              accessToken: event.params.accessToken,
              space: event.params.space!,
              tag: state.navigateTag!,
              workspace: event.workspace));
        });
      } else if (event is UpdateTaskEvent) {
        emit(state.copyWith(tagsPageStatus: TagsPageStatus.loading));
        final result = await _updateTaskUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.updateTaskFailed,
                updateTaskFailure: l)), (r) {
          emit(state.copyWith(
            tagsPageStatus: TagsPageStatus.updateTaskSuccess,
          ));
          add(GetTasksForTagEvent(
              accessToken: event.params.accessToken,
              space: event.params.task!.space!,
              tag: state.navigateTag!,
              workspace: event.workspace));
        });
      } else if (event is DeleteTaskEvent) {
        emit(state.copyWith(tagsPageStatus: TagsPageStatus.loading));
        final result = await _deleteTaskUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                tagsPageStatus: TagsPageStatus.updateTagFailure,
                updateTagFailure: l)), (r) {
          emit(state.copyWith(
            tagsPageStatus: TagsPageStatus.updateTaskSuccess,
          ));
          add(GetTasksForTagEvent(
              accessToken: event.params.accessToken,
              space: event.params.task.space!,
              tag: state.navigateTag!,
              workspace: event.workspace));
        });
      } else if (event is NavigateToTagPageEvent) {
        emit(state.copyWith(
            tagsPageStatus: event.insideTagPage
                ? TagsPageStatus.refreshTag
                : TagsPageStatus.navigateTag,
            navigateTag: event.tag));
      }
    });
  }
}
