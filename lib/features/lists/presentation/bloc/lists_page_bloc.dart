import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_folder.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_list.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_task.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_all_in_space_use_case.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_all_in_workspace_use_case.dart';
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
  final GetClickupTasksInSingleWorkspaceUseCase
      _getClickupTasksInSingleWorkspaceUseCase;
  final SaveSpacesUseCase _saveSpacesUseCase;

  ListsPageBloc(
      this._getAllInClickupSpaceUseCase,
      this._getClickupTasksInSingleWorkspaceUseCase,
      this._getAllInClickupWorkspaceUseCase,
      this._saveSpacesUseCase)
      : super(const ListsPageState(listsPageStatus: ListsPageStatus.initial)) {
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
      } else if (event is GetTasksInListEvent) {
        emit(state.copyWith(listsPageStatus: ListsPageStatus.isLoading));
        final result = await _getClickupTasksInSingleWorkspaceUseCase(
            GetClickupTasksInWorkspaceParams(
                workspaceId: Globals.selectedWorkspace?.id??"",
                filtersParams: state.defaultTasksInWorkspaceFiltersParams
                    .copyWith(filterByListsIds: [event.list.id??""])));
        result?.fold(
            (l) => emit(state.copyWith(
                listsPageStatus:
                    ListsPageStatus.getTasksFailed,
                getTasksFailure: l)),
            (r) => emit(state.copyWith(
                listsPageStatus:
                    ListsPageStatus.getTasksSuccess,
                getTasksResult: r)));
      }
    });
  }
}
