import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/duplicate_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/update_task_use_case.dart';


import '../../../task_popup/presentation/views/task_popup.dart';
import '../../../tasks/domain/entities/task_parameters.dart';
import '../../../tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart' as syncfusion;
part 'schedule_event.dart';

part 'schedule_state.dart';

class ScheduleBloc extends Bloc<ScheduleEvent, ScheduleState> {

  final GetTasksInSingleWorkspaceUseCase
      _getTasksInSingleWorkspaceUseCase;

  final CreateTaskUseCase _createTaskUseCase;
  final DuplicateTaskUseCase _duplicateTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;
  final syncfusion.CalendarController syncfusionCalendarController = syncfusion.CalendarController();

  ScheduleBloc(
      this._getTasksInSingleWorkspaceUseCase,
      this._createTaskUseCase,
      this._duplicateTaskUseCase,
      this._updateTaskUseCase,
    this._deleteTaskUseCase,
  ) : super(ScheduleState._(
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
            await _getTasksInSingleWorkspaceUseCase(event.params);
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
              tasks: r));
        });
      }
      else if (event is CreateTaskEvent) {
        emit(state.copyWith(
          persistingScheduleStateAddRemove:
              const dartz.Right(ScheduleStateEnum.loading),
        ));
        final result = await _createTaskUseCase(event.params,event.workspaceId);
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
        final result = await _duplicateTaskUseCase(event.params,event.workspace);
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
        final result = await _updateTaskUseCase(event.params);
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
        final result = await _deleteTaskUseCase(event.params);
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
      else if(event is ChangeCalendarView){
        emit(state.copyWith(
          viewIndex: event.viewIndex
        ));
      }
    });
  }
}
