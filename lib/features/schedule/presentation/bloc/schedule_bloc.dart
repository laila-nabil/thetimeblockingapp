import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/update_clickup_task_use_case.dart';

import '../../../tasks/domain/entities/task_parameters.dart';
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

  final CreateClickUpTaskUseCase _createClickUpTaskUseCase;
  final UpdateClickUpTaskUseCase _updateClickUpTaskUseCase;
  final DeleteClickUpTaskUseCase _deleteClickUpTaskUseCase;

  final CalendarController controller = CalendarController();

  ScheduleBloc(
      this._getClickUpTasksInAllWorkspacesUseCase,
      this._getClickUpTasksInSingleWorkspaceUseCase,
      this._createClickUpTaskUseCase,
      this._updateClickUpTaskUseCase,
      this._deleteClickUpTaskUseCase)
      : super(ScheduleState._(
            persistingScheduleStates: const {},
            tasksDueDateEarliestDate: ScheduleState.defaultTasksEarliestDate,
            tasksDueDateLatestDate: ScheduleState.defaultTasksLatestDate)) {
    on<ScheduleEvent>((event, emit) async {
      if (event is GetTasksForSingleWorkspaceScheduleEvent) {
        emit(state.copyWith(
            persistingScheduleStateAddRemove:
                const Right(ScheduleStateEnum.loading),
            getTasksForSingleWorkspaceScheduleEventId: event.id));
        final result =
            await _getClickUpTasksInSingleWorkspaceUseCase(event.params);
        emit(state.copyWith(
            persistingScheduleStateAddRemove:
                const Left(ScheduleStateEnum.loading)));
        result?.fold((l) {
          emit(state.copyWith(
              persistingScheduleStateAddRemove:
                  const Right(ScheduleStateEnum.getTasksSingleWorkspaceFailed),
              getTasksSingleWorkspaceFailure: l));
        }, (r) {
          emit(state.copyWith(
              persistingScheduleStateAddRemove:
                  const Right(ScheduleStateEnum.getTasksSingleWorkspaceSuccess),
              clickUpTasks: r));
        });
      } else if (event is CreateClickUpTaskEvent) {
        emit(state.copyWith(
          persistingScheduleStateAddRemove:
              const Right(ScheduleStateEnum.loading),
        ));
        final result = await _createClickUpTaskUseCase(event.params);
        emit(state.copyWith(
            persistingScheduleStateAddRemove:
                const Left(ScheduleStateEnum.loading)));
        result?.fold((l) {
          emit(state.copyWith(
              nonPersistingScheduleState: ScheduleStateEnum.createTaskFailed,
              createTaskFailure: l));
        }, (r) {
          emit(state.copyWith(
            nonPersistingScheduleState: ScheduleStateEnum.createTaskSuccess,
          ));
        });
      } else if (event is UpdateClickUpTaskEvent) {
        emit(state.copyWith(
          persistingScheduleStateAddRemove:
              const Right(ScheduleStateEnum.loading),
        ));
        final result = await _updateClickUpTaskUseCase(event.params);
        emit(state.copyWith(
            persistingScheduleStateAddRemove:
                const Left(ScheduleStateEnum.loading)));
        result?.fold((l) {
          emit(state.copyWith(
              nonPersistingScheduleState: ScheduleStateEnum.updateTaskFailed,
              updateTaskFailure: l));
        }, (r) {
          emit(state.copyWith(
            nonPersistingScheduleState: ScheduleStateEnum.updateTaskSuccess,
          ));
        });
      } else if (event is DeleteClickUpTaskEvent) {
        emit(state.copyWith(
          persistingScheduleStateAddRemove:
              const Right(ScheduleStateEnum.loading),
        ));
        final result = await _deleteClickUpTaskUseCase(event.params);
        emit(state.copyWith(
            persistingScheduleStateAddRemove:
                const Left(ScheduleStateEnum.loading)));
        result?.fold((l) {
          emit(state.copyWith(
              nonPersistingScheduleState: ScheduleStateEnum.deleteTaskFailed,
              deleteTaskFailure: l));
        }, (r) {
          emit(state.copyWith(
            nonPersistingScheduleState: ScheduleStateEnum.deleteTaskSuccess,
          ));
        });
      }
    });
  }
}
