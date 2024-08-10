import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/duplicate_task_use_case.dart';

import '../../../../common/entities/workspace.dart';
import '../../../../core/error/failures.dart';
import '../../../../common/entities/access_token.dart';
import '../../../../common/entities/space.dart';
import '../../../../common/entities/task.dart';
import '../../../tasks/domain/entities/task_parameters.dart';
import '../../../tasks/domain/use_cases/create_task_use_case.dart';
import '../../../tasks/domain/use_cases/delete_task_use_case.dart';
import '../../../tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import '../../../tasks/domain/use_cases/update_task_use_case.dart';

part 'all_tasks_event.dart';

part 'all_tasks_state.dart';

///TODO have upcoming section with any dated, soon section that has tb_soon tag and later section with tb_later tag and auto add to it

class AllTasksBloc extends Bloc<AllTasksEvent, AllTasksState> {
  final GetTasksInSingleWorkspaceUseCase
      _getTasksInSingleWorkspaceUseCase;
  final CreateTaskUseCase _createTaskUseCase;
  final DuplicateTaskUseCase _duplicateTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  AllTasksBloc(
      this._getTasksInSingleWorkspaceUseCase,
      this._createTaskUseCase,
      this._duplicateTaskUseCase,
      this._updateTaskUseCase,
      this._deleteTaskUseCase)
      : super(const AllTasksState(allTasksStatus: AllTasksStatus.initial)) {
    on<AllTasksEvent>((event, emit) async {
      if (event is GetTasksInSpaceEvent) {
        emit(state.copyWith(allTasksStatus: AllTasksStatus.loading));
        final result = await _getTasksInSingleWorkspaceUseCase(
            GetTasksInWorkspaceParams(
                workspaceId: event.workspace.id ?? 0,
                filtersParams: GetTasksInWorkspaceFiltersParams(
                    accessToken: event.accessToken,
                    filterBySpaceIds: [event.space.id ?? ""]),
                backendMode: Globals.backendMode
            ));
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
        final result = await _createTaskUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                allTasksStatus: AllTasksStatus.createTaskFailed,
                createTaskFailure: l)), (r) {
          emit(state.copyWith(
            allTasksStatus: AllTasksStatus.createTaskSuccess,
          ));
          add(GetTasksInSpaceEvent(
              accessToken: event.params.accessToken,
              space: event.params.space!,
              workspace: event.workspace));
        });
      } else if (event is DuplicateTaskEvent) {
        emit(state.copyWith(allTasksStatus: AllTasksStatus.loading));
        final result = await _duplicateTaskUseCase(event.params);
        result?.fold(
                (l) => emit(state.copyWith(
                allTasksStatus: AllTasksStatus.createTaskFailed,
                createTaskFailure: l)), (r) {
          emit(state.copyWith(
            allTasksStatus: AllTasksStatus.createTaskSuccess,
          ));
          add(GetTasksInSpaceEvent(
              accessToken: event.params.accessToken,
              space: event.params.space!,
              workspace: event.workspace));
        });
      } else if (event is UpdateTaskEvent) {
        emit(state.copyWith(allTasksStatus: AllTasksStatus.loading));
        final result = await _updateTaskUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                allTasksStatus: AllTasksStatus.updateTaskFailed,
                updateTaskFailure: l)), (r) {
          emit(state.copyWith(
            allTasksStatus: AllTasksStatus.updateTaskSuccess,
          ));
          add(GetTasksInSpaceEvent(
              accessToken: event.params.accessToken,
              space: event.params.space ?? Globals.selectedSpace!,
              workspace: event.workspace));
        });
      } else if (event is DeleteTaskEvent) {
        emit(state.copyWith(allTasksStatus: AllTasksStatus.loading));
        final result = await _deleteTaskUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                allTasksStatus: AllTasksStatus.deleteTaskFailed,
                deleteTaskFailure: l)), (r) {
          emit(state.copyWith(
            allTasksStatus: AllTasksStatus.updateTaskSuccess,
          ));
          add(GetTasksInSpaceEvent(
              accessToken: event.params.accessToken,
              space: Globals.selectedSpace!,
              workspace: event.workspace));
        });
      }
    });
  }
}
