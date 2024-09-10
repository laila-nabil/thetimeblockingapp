import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/user.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/common/entities/folder.dart';
import 'package:thetimeblockingapp/common/entities/tasks_list.dart';
import 'package:thetimeblockingapp/common/entities/task.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folder_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_list_in_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/duplicate_task_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_all_in_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_tasks_in_single_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/move_task_between_lists_use_case.dart';

import '../../../../core/error/failures.dart';

import '../../../../common/entities/access_token.dart';
import '../../../../common/entities/space.dart';
import '../../../tasks/domain/entities/task_parameters.dart';
import '../../../tasks/domain/use_cases/delete_folder_use_case.dart';
import '../../../tasks/domain/use_cases/delete_task_use_case.dart';
import '../../../tasks/domain/use_cases/update_task_use_case.dart';

part 'lists_page_event.dart';

part 'lists_page_state.dart';

class ListsPageBloc extends Bloc<ListsPageEvent, ListsPageState> {
  final GetTasksInSingleWorkspaceUseCase _getTasksInSingleWorkspaceUseCase;
  final CreateListInFolderUseCase _createListInFolderUseCase;
  final CreateFolderInSpaceUseCase _createFolderInSpaceUseCase;
  final CreateFolderlessListUseCase
      _createFolderlessListUseCase;
  final MoveTaskBetweenListsUseCase _moveTaskBetweenListsUseCase;
  final DeleteFolderUseCase _deleteFolderUseCase;
  final DeleteListUseCase _deleteListUseCase;
  final CreateTaskUseCase _createTaskUseCase;
  final DuplicateTaskUseCase _duplicateTaskUseCase;
  final UpdateTaskUseCase _updateTaskUseCase;
  final DeleteTaskUseCase _deleteTaskUseCase;

  ListsPageBloc(
    this._getTasksInSingleWorkspaceUseCase,
    this._createListInFolderUseCase,
    this._createFolderInSpaceUseCase,
    this._createFolderlessListUseCase,
    this._moveTaskBetweenListsUseCase,
    this._deleteFolderUseCase,
    this._deleteListUseCase,
    this._createTaskUseCase,
    this._duplicateTaskUseCase,
    this._updateTaskUseCase,
    this._deleteTaskUseCase,
  ) : super(const ListsPageState(listsPageStatus: ListsPageStatus.initial, triedGetData: false)) {
    on<ListsPageEvent>((event, emit) async {
      if (event is NavigateToListPageEvent) {
        emit(state.copyWith(
            listsPageStatus: ListsPageStatus.navigateList,
            navigateList: event.list));
      }else if (event is CreateListInFolderEvent) {
        if (event.tryEvent == true) {
          emit(state.copyWith(
              listsPageStatus: ListsPageStatus.createListInFolderTry,
              folderToCreateListIn: event.folderToCreateListIn));
        }else if(event.createListInFolderParams == null){
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.createListInFolderCanceled,));
        } else {
          emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
          final result = await _createListInFolderUseCase(
              event.createListInFolderParams!);
          result?.fold(
              (l) => emit(state.copyWith(
                  listsPageStatus: ListsPageStatus.createListInFolderFailed,
                  createListFailure: l)), (r) {
            emit(state.copyWith(
              listsPageStatus: ListsPageStatus.createListInFolderSuccess,
            ));
            event.onSuccess();
          });
        }
      } else if (event is CreateFolderlessListEvent) {
        if (event.tryEvent == true) {
          emit(state.copyWith(
              listsPageStatus: ListsPageStatus.createListInSpaceTry,
              createFolderlessListParams:
                  event.createFolderlessListParams,
              workspace: event.workspace,
              space: event.space));
        } else if(event.createFolderlessListParams == null){
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.createListInSpaceCanceled,));
        }else {
          emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
          final result = await _createFolderlessListUseCase(
              event.createFolderlessListParams!);
          result?.fold(
              (l) => emit(state.copyWith(
                  listsPageStatus: ListsPageStatus.createListInSpaceFailed,
                  createListFailure: l)), (r) {
            emit(state.copyWith(
              listsPageStatus: ListsPageStatus.createListInSpaceSuccess,
            ));
            event.onSuccess();
          });
        }
      } else if (event is MoveTaskBetweenListsEvent) {
        if (event.tryEvent) {
          emit(state.copyWith(
              listsPageStatus: ListsPageStatus.moveListTry,
              moveTaskBetweenListsParams:
                  event.moveTaskBetweenListsParams,
              workspace: event.workspace,
              space: event.space));
        } else {
          emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
          final result = await _moveTaskBetweenListsUseCase(
              event.moveTaskBetweenListsParams);
          result?.fold(
              (l) => emit(state.copyWith(
                  listsPageStatus: ListsPageStatus.moveTaskBetweenListsFailed,
                  moveTaskBetweenListsFailure: l)), (r) {
            emit(state.copyWith(
              listsPageStatus: ListsPageStatus.moveTaskBetweenListsSuccess,
            ));
            printDebug("GetListAndFoldersInListsPageEvent"); //TODO A ??
            // add(GetListAndFoldersInListsPageEvent.inSpace(
            //     accessToken:
            //         event.moveTaskBetweenListsParams.accessToken,
            //     workspace: event.workspace,
            //     space: event.space));
          });
        }
      } else if (event is CreateFolderInSpaceEvent) {
        if (event.tryEvent == true) {
          emit(state.copyWith(
              listsPageStatus: ListsPageStatus.createFolderTry,
              createFolderInSpaceParams:
                  event.createFolderInSpaceParams,
              workspace: event.workspace,
              space: event.space));
        } else if(event.createFolderInSpaceParams == null){
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.createFolderCanceled,));
        }else {
          emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
          final result = await _createFolderInSpaceUseCase(
              event.createFolderInSpaceParams!);
          result?.fold(
              (l) => emit(state.copyWith(
                  listsPageStatus: ListsPageStatus.createFolderFailed,
                  createFolderFailure: l)), (r) {
            emit(state.copyWith(
              listsPageStatus: ListsPageStatus.createFolderSuccess,
            ));
            event.onSuccess();
          });
        }
      } else if (event is DeleteFolderEvent) {
        if (event.tryEvent == true) {
          emit(state.copyWith(
              listsPageStatus: ListsPageStatus.deleteFolderTry,
              toDeleteFolder: event.toDeleteFolder
          ));
        } else if(event.deleteFolderParams == null){
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.deleteListCanceled,));
        }  else {
          emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
          final result = await _deleteFolderUseCase(
              event.deleteFolderParams!);
          result?.fold(
              (l) => emit(state.copyWith(
                  listsPageStatus: ListsPageStatus.deleteFolderFailed,
                  deleteFolderFailure: l)), (r) {
            emit(state.copyWith(
              listsPageStatus: ListsPageStatus.deleteFolderSuccess,
            ));
            event.onSuccess();
          });
        }
      } else if (event is DeleteListEvent) {
        if (event.tryEvent== true) {
          emit(state.copyWith(
              listsPageStatus: ListsPageStatus.deleteListTry,
              toDeleteList: event.toDeleteList
          ));
        } else if(event.deleteListParams == null){
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.deleteListCanceled,));
        } else {
          emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
          final result =
              await _deleteListUseCase(event.deleteListParams!);
          result?.fold(
              (l) => emit(state.copyWith(
                  listsPageStatus: ListsPageStatus.deleteListFailed,
                  deleteListFailure: l)), (r) {
            emit(state.copyWith(
              listsPageStatus: ListsPageStatus.deleteListSuccess,
            ));
            event.onSuccess();
          });
        }
      }
      else if (event is CreateTaskEvent) {
        emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
        final result = await _createTaskUseCase(event.params,event.workspaceId);
        result?.fold(
            (l) => emit(state.copyWith(
                listsPageStatus: ListsPageStatus.createTaskFailed,
                deleteListFailure: l)), (r) {
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.createTaskSuccess,
          ));
          event.onSuccess();
        });
      }
      else if (event is DuplicateTaskEvent) {
        emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
        final result = await _duplicateTaskUseCase(event.params,event.workspace.id!);
        result?.fold(
            (l) => emit(state.copyWith(
                listsPageStatus: ListsPageStatus.createTaskFailed,
                deleteListFailure: l)), (r) {
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.createTaskSuccess,
          ));
          event.onSuccess();
        });
      }
      else if (event is UpdateTaskEvent) {
        emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
        final result = await _updateTaskUseCase(event.params);
        result?.fold(
                (l) => emit(state.copyWith(
                listsPageStatus: ListsPageStatus.updateTaskFailed,
                updateTaskFailure: l)), (r) {
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.updateTaskSuccess,
          ));
          event.onSuccess();
        });
      }
      else if (event is DeleteTaskEvent) {
        emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
        final result = await _deleteTaskUseCase(event.params);
        result?.fold(
                (l) => emit(state.copyWith(
                listsPageStatus: ListsPageStatus.deleteTaskFailed,
                deleteTaskFailure: l)), (r) {
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.deleteTaskSuccess,
          ));
          event.onSuccess();
        });
      }
      else if (event is TryGetDataEvent){
        emit(state.copyWith(listsPageStatus: ListsPageStatus.initial,triedGetData: true));
      }
      else if(event is GetTasksInListEvent){
        emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
        final result = await _getTasksInSingleWorkspaceUseCase(event.params);
        result?.fold(
                (l) => emit(state.copyWith(
                listsPageStatus: ListsPageStatus.getTasksFailed,
                getTasksFailure: l,
                deleteTaskFailure: l)), (r) => emit(state.copyWith(
                listsPageStatus: ListsPageStatus.getTasksSuccess,
                currentList: event.list,
                currentListTasks: r
                    .where((task) => task.list == event.list)
                    .toList())));
      }
    });
  }
}
