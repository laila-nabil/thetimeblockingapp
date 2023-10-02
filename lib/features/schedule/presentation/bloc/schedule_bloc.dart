import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';

import '../../../tasks/domain/use_cases/get_clickup_tasks_in_all_workspaces_use_case.dart';
import '../../../tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';

part 'schedule_event.dart';

part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {
  final GetClickUpTasksInAllWorkspacesUseCase
      // ignore: unused_field
      _getClickUpTasksInAllWorkspacesUseCase;

  final GetClickUpTasksInSingleWorkspaceUseCase
      _getClickUpTasksInSingleWorkspaceUseCase;

  final CalendarController controller = CalendarController();
  ScheduleBloc(this._getClickUpTasksInAllWorkspacesUseCase,
      this._getClickUpTasksInSingleWorkspaceUseCase)
      : super(const ScheduleState._(scheduleStates: {})) {
    on<ScheduleEvent>((event, emit) async {
      if (event is GetTasksForSingleWorkspaceScheduleEvent) {
        emit(state.copyWith(
            stateAddRemove: const Right(ScheduleStateEnum.loading)));
        final result =
            await _getClickUpTasksInSingleWorkspaceUseCase(event.params);
        emit(state.copyWith(
            stateAddRemove: const Left(ScheduleStateEnum.loading)));
        result?.fold((l) {
          emit(state.copyWith(
              stateAddRemove:
                  const Right(ScheduleStateEnum.getTasksSingleWorkspaceFailed),
              getTasksSingleWorkspaceFailure: l));
        }, (r) {
          emit(state.copyWith(
              stateAddRemove:
                  const Right(ScheduleStateEnum.getTasksSingleWorkspaceSuccess),
              clickUpTasks: r));
        });
      }
    });
  }
}
