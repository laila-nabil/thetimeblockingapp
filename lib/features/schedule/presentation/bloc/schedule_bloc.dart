import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_clickup_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_clickup_task_use_case.dart';
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
  final GetClickupTasksInAllWorkspacesUseCase
      // ignore: unused_field
      _getClickupTasksInAllWorkspacesUseCase;

  final GetClickupTasksInSingleWorkspaceUseCase
      _getClickupTasksInSingleWorkspaceUseCase;

  final CreateClickupTaskUseCase _createClickupTaskUseCase;
  final UpdateClickupTaskUseCase _updateClickupTaskUseCase;
  final DeleteClickupTaskUseCase _deleteClickupTaskUseCase;
  final CalendarController controller = CalendarController();

  ScheduleBloc(
      this._getClickupTasksInAllWorkspacesUseCase,
      this._getClickupTasksInSingleWorkspaceUseCase,
      this._createClickupTaskUseCase,
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
                const Right(ScheduleStateEnum.loading),
            getTasksForSingleWorkspaceScheduleEventId: event.id));
        final result =
            await _getClickupTasksInSingleWorkspaceUseCase(event.params);
        emit(state.copyWith(
            persistingScheduleStateAddRemove:
                const Left(ScheduleStateEnum.loading)));
        emit(state.copyWith(
            persistingScheduleStateAddRemove:
            const Left(ScheduleStateEnum.getTasksSingleWorkspaceFailed),));
        emit(state.copyWith(
          persistingScheduleStateAddRemove:
          const Left(ScheduleStateEnum.getTasksSingleWorkspaceSuccess),));
        result?.fold((l) {
          emit(state.copyWith(
              persistingScheduleStateAddRemove:
                  const Right(ScheduleStateEnum.getTasksSingleWorkspaceFailed),
              getTasksSingleWorkspaceFailure: l));
        }, (r) {
          emit(state.copyWith(
              persistingScheduleStateAddRemove:
                  const Right(ScheduleStateEnum.getTasksSingleWorkspaceSuccess),
              clickupTasks: r));
        });
      }
      else if (event is CreateClickupTaskEvent) {
        emit(state.copyWith(
          persistingScheduleStateAddRemove:
              const Right(ScheduleStateEnum.loading),
        ));
        final result = await _createClickupTaskUseCase(event.params);
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
      }
      else if (event is UpdateClickupTaskEvent) {
        emit(state.copyWith(
          persistingScheduleStateAddRemove:
              const Right(ScheduleStateEnum.loading),
        ));
        final result = await _updateClickupTaskUseCase(event.params);
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
      }
      else if (event is DeleteClickupTaskEvent) {
        emit(state.copyWith(
          persistingScheduleStateAddRemove:
              const Right(ScheduleStateEnum.loading),
        ));
        final result = await _deleteClickupTaskUseCase(event.params);
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
      else if(event is ShowTaskPopupEvent){
        emit(state.copyWith(
            showTaskPopup: event.showTaskPopup,
            taskPopupParams: event.taskPopupParams));
      }
    });
  }
}
