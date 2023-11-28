import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../common/entities/clickup_workspace.dart';
import '../../../../core/error/failures.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../../../tasks/domain/entities/clickup_space.dart';
import '../../../tasks/domain/entities/clickup_task.dart';
import '../../../tasks/domain/entities/task_parameters.dart';
import '../../../tasks/domain/use_cases/create_clickup_task_use_case.dart';
import '../../../tasks/domain/use_cases/delete_clickup_task_use_case.dart';
import '../../../tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import '../../../tasks/domain/use_cases/update_clickup_task_use_case.dart';

part 'all_tasks_event.dart';

part 'all_tasks_state.dart';

class AllTasksBloc extends Bloc<AllTasksEvent, AllTasksState> {
  final GetClickupTasksInSingleWorkspaceUseCase
      _getClickupTasksInSingleWorkspaceUseCase;
  final CreateClickupTaskUseCase _createClickupTaskUseCase;
  final UpdateClickupTaskUseCase _updateClickupTaskUseCase;
  final DeleteClickupTaskUseCase _deleteClickupTaskUseCase;

  AllTasksBloc(
      this._getClickupTasksInSingleWorkspaceUseCase,
      this._createClickupTaskUseCase,
      this._updateClickupTaskUseCase,
      this._deleteClickupTaskUseCase)
      : super(const AllTasksState(allTasksStatus: AllTasksStatus.initial)) {
    on<AllTasksEvent>((event, emit) async {
      if (event is GetClickupTasksInSpaceEvent) {
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
      } else if (event is CreateClickupTaskEvent) {
        emit(state.copyWith(allTasksStatus: AllTasksStatus.loading));
        final result = await _createClickupTaskUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                allTasksStatus: AllTasksStatus.createTaskFailed,
                createTaskFailure: l)), (r) {
          emit(state.copyWith(
            allTasksStatus: AllTasksStatus.createTaskSuccess,
          ));
          add(GetClickupTasksInSpaceEvent(
              clickupAccessToken: event.params.clickupAccessToken,
              space: event.params.clickupSpace!,
              workspace: event.workspace));
        });
      } else if (event is UpdateClickupTaskEvent) {
        emit(state.copyWith(allTasksStatus: AllTasksStatus.loading));
        final result = await _updateClickupTaskUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                allTasksStatus: AllTasksStatus.updateTaskFailed,
                updateTaskFailure: l)), (r) {
          emit(state.copyWith(
            allTasksStatus: AllTasksStatus.updateTaskSuccess,
          ));
          add(GetClickupTasksInSpaceEvent(
              clickupAccessToken: event.params.clickupAccessToken,
              space: event.params.clickupSpace!,
              workspace: event.workspace));
        });
      } else if (event is DeleteClickupTaskEvent) {
        emit(state.copyWith(allTasksStatus: AllTasksStatus.loading));
        final result = await _deleteClickupTaskUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                allTasksStatus: AllTasksStatus.deleteTaskFailed,
                deleteTaskFailure: l)), (r) {
          emit(state.copyWith(
            allTasksStatus: AllTasksStatus.updateTaskSuccess,
          ));
          add(GetClickupTasksInSpaceEvent(
              clickupAccessToken: event.params.clickupAccessToken,
              space: event.params.task.space!,
              workspace: event.workspace));
        });
      }
    });
  }
}
