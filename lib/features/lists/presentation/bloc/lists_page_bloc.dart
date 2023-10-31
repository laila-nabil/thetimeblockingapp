import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_folder.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_all_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_all_in_workspace_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_list_and_its_tasks_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_tasks_in_single_workspace_use_case.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/globals.dart';
import '../../../auth/domain/entities/clickup_access_token.dart';
import '../../../startup/domain/use_cases/save_spaces_use_case.dart';
import '../../../tasks/domain/entities/clickup_space.dart';

part 'lists_page_event.dart';

part 'lists_page_state.dart';

class ListsPageBloc extends Bloc<ListsPageEvent, ListsPageState>
    with GlobalsWriteAccess {
  final GetAllInClickupSpaceUseCase _getAllInClickupSpaceUseCase;
  final GetAllInClickupWorkspaceUseCase _getAllInClickupWorkspaceUseCase;
  final SaveSpacesUseCase _saveSpacesUseCase;
  final GetClickupListAndItsTasksUseCase _getClickupListAndItsTasksUseCase;

  ListsPageBloc(
    this._getAllInClickupSpaceUseCase,
    this._getClickupListAndItsTasksUseCase,
    this._getAllInClickupWorkspaceUseCase,
    this._saveSpacesUseCase,
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
        ClickupList? list;
        List<ClickupTask>? tasks;
        List<Failure>? failures = [];
        getClickupListAndItsTasks?.listResult
            ?.fold((l) => failures.add(l), (r) => list = r);
        getClickupListAndItsTasks?.tasksResult
            .fold((l) => failures.add(l), (r) => tasks = r);
        FailuresList? failuresList = FailuresList(failures: failures);
        printDebug("**** list $list");
        printDebug("**** tasks $tasks");
        printDebug("**** failuresList $failuresList");
        ///FIXME not updating state though breakpoints go to emit
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
      }
    });
  }
}
