import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart' as dartz; 
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/folder.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/tasks_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folder_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_list_in_folder_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/create_folderless_list_clickup_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/delete_list_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/duplicate_task_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_all_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_all_in_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_list_and_its_tasks_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/move_clickup_task_between_lists_use_case.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/globals.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../../../startup/domain/use_cases/save_spaces_use_case.dart';
import '../../../tasks/domain/entities/space.dart';
import '../../../tasks/domain/entities/task_parameters.dart';
import '../../../tasks/domain/use_cases/delete_folder_use_case.dart';
import '../../../tasks/domain/use_cases/delete_task_use_case.dart';
import '../../../tasks/domain/use_cases/update_clickup_task_use_case.dart';

part 'lists_page_event.dart';

part 'lists_page_state.dart';

class ListsPageBloc extends Bloc<ListsPageEvent, ListsPageState>
    with GlobalsWriteAccess {
  final GetAllInClickupSpaceUseCase _getAllInClickupSpaceUseCase;
  final GetAllInClickupWorkspaceUseCase _getAllInClickupWorkspaceUseCase;
  final SaveSpacesUseCase _saveSpacesUseCase;
  final GetListAndItsTasksUseCase _getClickupListAndItsTasksUseCase;
  final CreateListInFolderUseCase _createClickupListInFolderUseCase;
  final CreateFolderInSpaceUseCase _createClickupFolderInSpaceUseCase;
  final CreateFolderlessListClickupListUseCase
      _createFolderlessClickupListUseCase;
  final MoveClickupTaskBetweenListsUseCase _moveClickupTaskBetweenListsUseCase;
  final DeleteFolderUseCase _deleteClickupFolderUseCase;
  final DeleteListUseCase _deleteClickupListUseCase;
  final CreateTaskUseCase _createClickupTaskUseCase;
  final DuplicateTaskUseCase _duplicateClickupTaskUseCase;
  final UpdateClickupTaskUseCase _updateClickupTaskUseCase;
  final DeleteTaskUseCase _deleteClickupTaskUseCase;

  ListsPageBloc(
    this._getAllInClickupSpaceUseCase,
    this._getClickupListAndItsTasksUseCase,
    this._getAllInClickupWorkspaceUseCase,
    this._saveSpacesUseCase,
    this._createClickupListInFolderUseCase,
    this._createClickupFolderInSpaceUseCase,
    this._createFolderlessClickupListUseCase,
    this._moveClickupTaskBetweenListsUseCase,
    this._deleteClickupFolderUseCase,
    this._deleteClickupListUseCase,
    this._createClickupTaskUseCase,
    this._duplicateClickupTaskUseCase,
    this._updateClickupTaskUseCase,
    this._deleteClickupTaskUseCase,
  ) : super(const ListsPageState(listsPageStatus: ListsPageStatus.initial)) {
    on<ListsPageEvent>((event, emit) async {
      if (event is NavigateToListPageEvent) {
        emit(state.copyWith(
            listsPageStatus: ListsPageStatus.navigateList,
            navigateList: event.list));
      } else if (event is GetListAndFoldersInListsPageEvent) {
        if (Globals.isSpaceAppWide == false) {
          emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
          final result = await _getAllInClickupWorkspaceUseCase(
              GetAllInClickupWorkspaceParams(
                  clickupAccessToken: event.clickupAccessToken,
                  clickupWorkspace: event.clickupWorkspace));
          await result?.fold(
              (l) async => emit(state.copyWith(
                  listsPageStatus:
                      ListsPageStatus.getSpacesAndListsAndFoldersFailed,
                  getSpacesListsFoldersFailure: l)), (r) async {
            await _saveSpacesUseCase(SaveSpacesParams(r));
            emit(state.copyWith(
                listsPageStatus:
                    ListsPageStatus.getSpacesAndListsAndFoldersSuccess,
                getSpacesListsFoldersResult: r));
          });
        } else if (event.clickupSpace != null) {
          emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
          final result = await _getAllInClickupSpaceUseCase(
              GetAllInClickupSpaceParams(
                  clickupAccessToken: event.clickupAccessToken,
                  clickupSpace: event.clickupSpace!));
          await result?.fold(
              (l) async => emit(state.copyWith(
                  listsPageStatus:
                      ListsPageStatus.getSpacesAndListsAndFoldersFailed,
                  getSpacesListsFoldersFailure: l)), (r) async {
            setSelectedSpace(r);
            if (Globals.clickupSpaces?.isNotEmpty == true) {
              await _saveSpacesUseCase(
                  SaveSpacesParams(Globals.clickupSpaces!));
            }
            emit(state.copyWith(
                listsPageStatus:
                    ListsPageStatus.getSpacesAndListsAndFoldersSuccess,
                getSpacesListsFoldersResult: Globals.clickupSpaces));
          });
        }
      } else if (event is GetListDetailsAndTasksInListEvent) {
        emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
        final getClickupListAndItsTasks =
            await _getClickupListAndItsTasksUseCase(
                event.getClickupListAndItsTasksParams);
        TasksList? list;
        List<Task>? tasks;
        List<Failure>? failures = [];
        getClickupListAndItsTasks?.listResult
            ?.fold((l) => failures.add(l), (r) => list = r);
        getClickupListAndItsTasks?.tasksResult
            .fold((l) => failures.add(l), (r) => tasks = r);
        FailuresList? failuresList = FailuresList(failures: failures);
        printDebug("**** list $list");
        printDebug("**** tasks $tasks");
        printDebug("**** failuresList $failuresList");
        if (getClickupListAndItsTasks?.tasksResult.isRight() == true &&
            getClickupListAndItsTasks?.listResult?.isRight() == true) {
          printDebug("**** both right");
          emit(state.copyWith(
              listsPageStatus: ListsPageStatus.getListDetailsAndTasksSuccess,
              currentList: list,
              currentListTasks: tasks));
        } else {
          printDebug("**** something went wrong");
          emit(state.copyWith(
              listsPageStatus: ListsPageStatus.getListDetailsAndTasksWentWrong,
              currentList: list,
              currentListTasks: tasks,
              getListDetailsAndTasksFailure: failuresList));
        }
      } else if (event is CreateListInFolderEvent) {
        if (event.tryEvent == true) {
          emit(state.copyWith(
              listsPageStatus: ListsPageStatus.createListInFolderTry,
              folderToCreateListIn: event.folderToCreateListIn));
        }else if(event.createClickupListInFolderParams == null){
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.createListInFolderCanceled,));
        } else {
          emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
          final result = await _createClickupListInFolderUseCase(
              event.createClickupListInFolderParams!);
          result?.fold(
              (l) => emit(state.copyWith(
                  listsPageStatus: ListsPageStatus.createListInFolderFailed,
                  createListFailure: l)), (r) {
            emit(state.copyWith(
              listsPageStatus: ListsPageStatus.createListInFolderSuccess,
            ));
            add(GetListAndFoldersInListsPageEvent.inSpace(
                clickupAccessToken:
                    event.createClickupListInFolderParams!.clickupAccessToken,
                clickupWorkspace: event.clickupWorkspace!,
                clickupSpace: event.clickupSpace));
          });
        }
      } else if (event is CreateFolderlessListEvent) {
        if (event.tryEvent == true) {
          emit(state.copyWith(
              listsPageStatus: ListsPageStatus.createListInSpaceTry,
              createFolderlessListClickupParams:
                  event.createFolderlessListClickupParams,
              clickupWorkspace: event.clickupWorkspace,
              clickupSpace: event.clickupSpace));
        } else if(event.createFolderlessListClickupParams == null){
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.createListInSpaceCanceled,));
        }else {
          emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
          final result = await _createFolderlessClickupListUseCase(
              event.createFolderlessListClickupParams!);
          result?.fold(
              (l) => emit(state.copyWith(
                  listsPageStatus: ListsPageStatus.createListInSpaceFailed,
                  createListFailure: l)), (r) {
            emit(state.copyWith(
              listsPageStatus: ListsPageStatus.createListInSpaceSuccess,
            ));
            add(GetListAndFoldersInListsPageEvent.inSpace(
                clickupAccessToken:
                    event.createFolderlessListClickupParams!.clickupAccessToken,
                clickupWorkspace: event.clickupWorkspace!,
                clickupSpace: event.clickupSpace));
          });
        }
      } else if (event is MoveTaskBetweenListsEvent) {
        if (event.tryEvent) {
          emit(state.copyWith(
              listsPageStatus: ListsPageStatus.moveListTry,
              moveClickupTaskBetweenListsParams:
                  event.moveClickupTaskBetweenListsParams,
              clickupWorkspace: event.clickupWorkspace,
              clickupSpace: event.clickupSpace));
        } else {
          emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
          final result = await _moveClickupTaskBetweenListsUseCase(
              event.moveClickupTaskBetweenListsParams);
          result?.fold(
              (l) => emit(state.copyWith(
                  listsPageStatus: ListsPageStatus.moveTaskBetweenListsFailed,
                  moveTaskBetweenListsFailure: l)), (r) {
            emit(state.copyWith(
              listsPageStatus: ListsPageStatus.moveTaskBetweenListsSuccess,
            ));
            add(GetListAndFoldersInListsPageEvent.inSpace(
                clickupAccessToken:
                    event.moveClickupTaskBetweenListsParams.clickupAccessToken,
                clickupWorkspace: event.clickupWorkspace,
                clickupSpace: event.clickupSpace));
          });
        }
      } else if (event is CreateFolderInSpaceEvent) {
        if (event.tryEvent == true) {
          emit(state.copyWith(
              listsPageStatus: ListsPageStatus.createFolderTry,
              createClickupFolderInSpaceParams:
                  event.createClickupFolderInSpaceParams,
              clickupWorkspace: event.clickupWorkspace,
              clickupSpace: event.clickupSpace));
        } else if(event.createClickupFolderInSpaceParams == null){
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.createFolderCanceled,));
        }else {
          emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
          final result = await _createClickupFolderInSpaceUseCase(
              event.createClickupFolderInSpaceParams!);
          result?.fold(
              (l) => emit(state.copyWith(
                  listsPageStatus: ListsPageStatus.createFolderFailed,
                  createFolderFailure: l)), (r) {
            emit(state.copyWith(
              listsPageStatus: ListsPageStatus.createFolderSuccess,
            ));
            add(GetListAndFoldersInListsPageEvent.inSpace(
                clickupAccessToken:
                    event.createClickupFolderInSpaceParams!.clickupAccessToken,
                clickupWorkspace: event.clickupWorkspace!,
                clickupSpace: event.clickupSpace));
          });
        }
      } else if (event is DeleteFolderEvent) {
        if (event.tryEvent == true) {
          emit(state.copyWith(
              listsPageStatus: ListsPageStatus.deleteFolderTry,
              toDeleteFolder: event.toDeleteFolder
          ));
        } else if(event.deleteClickupFolderParams == null){
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.deleteListCanceled,));
        }  else {
          emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
          final result = await _deleteClickupFolderUseCase(
              event.deleteClickupFolderParams!);
          result?.fold(
              (l) => emit(state.copyWith(
                  listsPageStatus: ListsPageStatus.deleteFolderFailed,
                  deleteFolderFailure: l)), (r) {
            emit(state.copyWith(
              listsPageStatus: ListsPageStatus.deleteFolderSuccess,
            ));
            add(GetListAndFoldersInListsPageEvent.inSpace(
                clickupAccessToken:
                    event.deleteClickupFolderParams!.clickupAccessToken,
                clickupWorkspace: event.clickupWorkspace!,
                clickupSpace: event.clickupSpace));
          });
        }
      } else if (event is DeleteListEvent) {
        if (event.tryEvent== true) {
          emit(state.copyWith(
              listsPageStatus: ListsPageStatus.deleteListTry,
              toDeleteList: event.toDeleteList
          ));
        } else if(event.deleteClickupListParams == null){
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.deleteListCanceled,));
        } else {
          emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
          final result =
              await _deleteClickupListUseCase(event.deleteClickupListParams!);
          result?.fold(
              (l) => emit(state.copyWith(
                  listsPageStatus: ListsPageStatus.deleteListFailed,
                  deleteListFailure: l)), (r) {
            emit(state.copyWith(
              listsPageStatus: ListsPageStatus.deleteListSuccess,
            ));
            add(GetListAndFoldersInListsPageEvent.inSpace(
                clickupAccessToken:
                    event.deleteClickupListParams!.clickupAccessToken,
                clickupWorkspace: event.clickupWorkspace!,
                clickupSpace: event.clickupSpace));
          });
        }
      }
      else if (event is CreateTaskEvent) {
        emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
        final result = await _createClickupTaskUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                listsPageStatus: ListsPageStatus.createTaskFailed,
                deleteListFailure: l)), (r) {
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.createTaskSuccess,
          ));
          add(GetListDetailsAndTasksInListEvent(
              getClickupListAndItsTasksParams: GetClickupListAndItsTasksParams(
                  listId: event.params.getListId,
                  clickupAccessToken: event.params.clickupAccessToken)));
        });
      }
      else if (event is DuplicateTaskEvent) {
        emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
        final result = await _duplicateClickupTaskUseCase(event.params);
        result?.fold(
            (l) => emit(state.copyWith(
                listsPageStatus: ListsPageStatus.createTaskFailed,
                deleteListFailure: l)), (r) {
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.createTaskSuccess,
          ));
          add(GetListDetailsAndTasksInListEvent(
              getClickupListAndItsTasksParams: GetClickupListAndItsTasksParams(
                  listId: event.params.getListId,
                  clickupAccessToken: event.params.clickupAccessToken)));
        });
      }
      else if (event is UpdateTaskEvent) {
        emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
        final result = await _updateClickupTaskUseCase(event.params);
        result?.fold(
                (l) => emit(state.copyWith(
                listsPageStatus: ListsPageStatus.updateTaskFailed,
                updateTaskFailure: l)), (r) {
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.updateTaskSuccess,
          ));
          add(GetListDetailsAndTasksInListEvent(
              getClickupListAndItsTasksParams: GetClickupListAndItsTasksParams(
                  listId: event.params.getListId,
                  clickupAccessToken: event.params.clickupAccessToken)));
        });
      }
      else if (event is DeleteTaskEvent) {
        emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
        final result = await _deleteClickupTaskUseCase(event.params);
        result?.fold(
                (l) => emit(state.copyWith(
                listsPageStatus: ListsPageStatus.deleteTaskFailed,
                deleteTaskFailure: l)), (r) {
          emit(state.copyWith(
            listsPageStatus: ListsPageStatus.deleteTaskSuccess,
          ));
          add(GetListDetailsAndTasksInListEvent(
              getClickupListAndItsTasksParams: GetClickupListAndItsTasksParams(
                  listId: event.params.task.list?.id??"",
                  clickupAccessToken: event.params.clickupAccessToken)));
        });
      }
    });
  }
}
