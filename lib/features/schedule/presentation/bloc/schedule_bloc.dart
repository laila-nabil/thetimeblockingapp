import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/duplicate_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/update_clickup_task_use_case.dart';

import '../../../../core/globals.dart';
import '../../../startup/presentation/bloc/startup_bloc.dart';
import '../../../task_popup/presentation/views/task_popup.dart';
import '../../../tasks/domain/entities/task_parameters.dart';
import '../../../tasks/domain/use_cases/get_clickup_tasks_in_all_workspaces_use_case.dart';
import '../../../tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';

part 'schedule_event.dart';

part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {

  final GetClickupTasksInSingleWorkspaceUseCase
      _getClickupTasksInSingleWorkspaceUseCase;

  final CreateTaskUseCase _createClickupTaskUseCase;
  final DuplicateTaskUseCase _duplicateClickupTaskUseCase;
  final UpdateClickupTaskUseCase _updateClickupTaskUseCase;
  final DeleteTaskUseCase _deleteClickupTaskUseCase;
  final CalendarController controller = CalendarController();

  ScheduleBloc(
      this._getClickupTasksInSingleWorkspaceUseCase,
      this._createClickupTaskUseCase,
      this._duplicateClickupTaskUseCase,
      this._updateClickupTaskUseCase,
      this._deleteClickupTaskUseCase,)
      : super(ScheduleState._(
            persistingScheduleStates: const {},
            tasksDueDateEarliestDate: ScheduleState.defaultTasksEarliestDate,
            tasksDueDateLatestDate: ScheduleState.defaultTasksLatestDate)) {
    on<ScheduleEvent>((event, emit) async {
      if (event is GetTasksForSingleWorkspaceScheduleEvent &&
          state.persistingScheduleStates.contains(ScheduleStateEnum.loading) ==
              false) {
        emit(state.copyWith(
            persistingScheduleStateAddRemove:
                const dartz.Right(ScheduleStateEnum.loading),
            getTasksForSingleWorkspaceScheduleEventId: event.id));
        final result =
            await _getClickupTasksInSingleWorkspaceUseCase(event.params);
        emit(state.copyWith(
            persistingScheduleStateAddRemove:
                const dartz.Left(ScheduleStateEnum.loading)));
        emit(state.copyWith(
            persistingScheduleStateAddRemove:
            const dartz.Left(ScheduleStateEnum.getTasksSingleWorkspaceFailed),));
        emit(state.copyWith(
          persistingScheduleStateAddRemove:
          const dartz.Left(ScheduleStateEnum.getTasksSingleWorkspaceSuccess),));
        result?.fold((l) {
          emit(state.copyWith(
              persistingScheduleStateAddRemove:
                  const dartz.Right(ScheduleStateEnum.getTasksSingleWorkspaceFailed),
              getTasksSingleWorkspaceFailure: l));
        }, (r) {
          emit(state.copyWith(
              persistingScheduleStateAddRemove:
                  const dartz.Right(ScheduleStateEnum.getTasksSingleWorkspaceSuccess),
              clickupTasks: r));
        });
      }
      else if (event is CreateTaskEvent) {
        emit(state.copyWith(
          persistingScheduleStateAddRemove:
              const dartz.Right(ScheduleStateEnum.loading),
        ));
        final result = await _createClickupTaskUseCase(event.params);
        emit(state.copyWith(
            persistingScheduleStateAddRemove:
                const dartz.Left(ScheduleStateEnum.loading)));
        result?.fold((l) {
          emit(state.copyWith(
              nonPersistingScheduleState: ScheduleStateEnum.createTaskFailed,
              createTaskFailure: l));
        }, (r) {
          emit(state.copyWith(
            nonPersistingScheduleState: ScheduleStateEnum.createTaskSuccess,
          ));
        });
      }
      else if (event is DuplicateTaskEvent) {
        emit(state.copyWith(
          persistingScheduleStateAddRemove:
              const dartz.Right(ScheduleStateEnum.loading),
        ));
        final result = await _duplicateClickupTaskUseCase(event.params);
        emit(state.copyWith(
            persistingScheduleStateAddRemove:
                const dartz.Left(ScheduleStateEnum.loading)));
        result?.fold((l) {
          emit(state.copyWith(
              nonPersistingScheduleState: ScheduleStateEnum.createTaskFailed,
              createTaskFailure: l));
        }, (r) {
          emit(state.copyWith(
            nonPersistingScheduleState: ScheduleStateEnum.createTaskSuccess,
          ));
        });
      }
      else if (event is UpdateTaskEvent) {
        emit(state.copyWith(
          persistingScheduleStateAddRemove:
              const dartz.Right(ScheduleStateEnum.loading),
        ));
        final result = await _updateClickupTaskUseCase(event.params);
        emit(state.copyWith(
            persistingScheduleStateAddRemove:
            const dartz.Left(ScheduleStateEnum.loading)));
        result?.fold((l) {
          emit(state.copyWith(
              nonPersistingScheduleState: ScheduleStateEnum.updateTaskFailed,
              updateTaskFailure: l));
        }, (r) {
          emit(state.copyWith(
            nonPersistingScheduleState: ScheduleStateEnum.updateTaskSuccess,
          ));
        });
      }
      else if (event is DeleteTaskEvent) {
        emit(state.copyWith(
          persistingScheduleStateAddRemove:
              const dartz.Right(ScheduleStateEnum.loading),
        ));
        final result = await _deleteClickupTaskUseCase(event.params);
        emit(state.copyWith(
            persistingScheduleStateAddRemove:
                const dartz.Left(ScheduleStateEnum.loading)));
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
      else if(event is ShowTaskPopupEvent){
        emit(state.copyWith(
            showTaskPopup: event.showTaskPopup,
            taskPopupParams: event.taskPopupParams));
      }
    });
  }
}
