import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/duplicate_clickup_task_use_case.dart';

import '../../../../common/entities/workspace.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../../../tasks/domain/entities/space.dart';
import '../../../tasks/domain/entities/task.dart';
import '../../../tasks/domain/entities/task_parameters.dart';
import '../../../tasks/domain/use_cases/create_clickup_task_use_case.dart';
import '../../../tasks/domain/use_cases/delete_clickup_task_use_case.dart';
import '../../../tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import '../../../tasks/domain/use_cases/update_clickup_task_use_case.dart';

part 'all_tasks_event.dart';

part 'all_tasks_state.dart';

///TODO have upcoming section with any dated, soon section that has tb_soon tag and later section with tb_later tag and auto add to it

class AllTasksBloc extends Bloc<AllTasksEvent, AllTasksState> {
  final GetClickupTasksInSingleWorkspaceUseCase
      _getClickupTasksInSingleWorkspaceUseCase;
  final CreateClickupTaskUseCase _createClickupTaskUseCase;
  final DuplicateClickupTaskUseCase _duplicateClickupTaskUseCase;
  final UpdateClickupTaskUseCase _updateClickupTaskUseCase;
  final DeleteClickupTaskUseCase _deleteClickupTaskUseCase;

  AllTasksBloc(
      this._getClickupTasksInSingleWorkspaceUseCase,
      this._createClickupTaskUseCase,
      this._duplicateClickupTaskUseCase,
      this._updateClickupTaskUseCase,
      this._deleteClickupTaskUseCase)
      : super(const AllTasksState(allTasksStatus: AllTasksStatus.initial)) {
    on<AllTasksEvent>((event, emit) async {
      if (event is GetTasksInSpaceEvent) {
        emit(state.copyWith(allTasksStatus: AllTasksStatus.loading));
        final result = await _getClickupTasksInSingleWorkspaceUseCase(
            GetClickupTasksInWorkspaceParams(
                workspaceId: event.workspace.id ?? "",
                filtersParams: GetClickupTasksInWorkspaceFiltersParams(
                    clickupAccessToken: event.clickupAccessToken,
                    filterBySpaceIds: [event.space.id ?? ""])));
        result?.fold(
            (l) => emit(state.copyWith(
                allTasksStatus: AllTasksStatus.getTasksFailure,
                createTaskFailure: l)),
            (r) => emit(state.copyWith(
                  allTasksStatus: AllTasksStatus.getTasksSuccess,
                  allTasksResult: r

                )));
      } else if (event is CreateTaskEvent) {
        emit(state.copyWith(allTasksStatus: AllTasksStatus.loading));
        final result = await _createClickupTaskUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                allTasksStatus: AllTasksStatus.createTaskFailed,
                createTaskFailure: l)), (r) {
          emit(state.copyWith(
            allTasksStatus: AllTasksStatus.createTaskSuccess,
          ));
          add(GetTasksInSpaceEvent(
              clickupAccessToken: event.params.clickupAccessToken,
              space: event.params.clickupSpace!,
              workspace: event.workspace));
        });
      } else if (event is DuplicateTaskEvent) {
        emit(state.copyWith(allTasksStatus: AllTasksStatus.loading));
        final result = await _duplicateClickupTaskUseCase(event.params);
        result?.fold(
                (l) => emit(state.copyWith(
                allTasksStatus: AllTasksStatus.createTaskFailed,
                createTaskFailure: l)), (r) {
          emit(state.copyWith(
            allTasksStatus: AllTasksStatus.createTaskSuccess,
          ));
          add(GetTasksInSpaceEvent(
              clickupAccessToken: event.params.clickupAccessToken,
              space: event.params.clickupSpace!,
              workspace: event.workspace));
        });
      } else if (event is UpdateTaskEvent) {
        emit(state.copyWith(allTasksStatus: AllTasksStatus.loading));
        final result = await _updateClickupTaskUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                allTasksStatus: AllTasksStatus.updateTaskFailed,
                updateTaskFailure: l)), (r) {
          emit(state.copyWith(
            allTasksStatus: AllTasksStatus.updateTaskSuccess,
          ));
          add(GetTasksInSpaceEvent(
              clickupAccessToken: event.params.clickupAccessToken,
              space: event.params.clickupSpace ?? Globals.selectedSpace!,
              workspace: event.workspace));
        });
      } else if (event is DeleteTaskEvent) {
        emit(state.copyWith(allTasksStatus: AllTasksStatus.loading));
        final result = await _deleteClickupTaskUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                allTasksStatus: AllTasksStatus.deleteTaskFailed,
                deleteTaskFailure: l)), (r) {
          emit(state.copyWith(
            allTasksStatus: AllTasksStatus.updateTaskSuccess,
          ));
          add(GetTasksInSpaceEvent(
              clickupAccessToken: event.params.clickupAccessToken,
              space: event.params.task.space!,
              workspace: event.workspace));
        });
      }
    });
  }
}
