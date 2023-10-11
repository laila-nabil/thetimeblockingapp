import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/clickup_access_token.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import 'package:thetimeblockingapp/features/tasks/domain/use_cases/get_clickup_all_lists_in_folders_use_case.dart';

import '../../../tasks/domain/use_cases/get_all_in_workspace_use_case.dart';
import '../../../tasks/domain/use_cases/get_clickup_folderless_lists_in_space_use_case.dart';
import '../../../tasks/domain/use_cases/get_clickup_folders_in_space_use_case.dart';
import '../../../tasks/domain/use_cases/get_clickup_spaces_in_workspace_use_case.dart';
import '../../domain/use_cases/get_selected_workspace_use_case.dart';
import '../../domain/use_cases/select_workspace_use_case.dart';

part 'startup_event.dart';

part 'startup_state.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState> {
  final GetClickupFoldersInSpaceUseCase _getClickupFoldersUseCase;
  final GetClickupAllListsInFoldersUseCase _getClickupAllListsUseCase;
  final GetClickupFolderlessListsInSpaceUseCase
      _getClickupFolderlessListsUseCase;
  final GetClickupSpacesInWorkspacesUseCase
      _getClickupSpacesInWorkspacesUseCase;
  final GetAllInClickupWorkspaceUseCase _getAllInClickupWorkspaceUseCase;

  final SelectWorkspaceUseCase _selectWorkspaceUseCase;
  final GetSelectedWorkspaceUseCase _getSelectedWorkspaceUseCase;
  StartupBloc(
      this._getClickupFoldersUseCase,
      this._getClickupAllListsUseCase,
      this._getClickupFolderlessListsUseCase,
      this._getAllInClickupWorkspaceUseCase,
      this._getClickupSpacesInWorkspacesUseCase,
      this._selectWorkspaceUseCase,
      this._getSelectedWorkspaceUseCase)
      : super(const StartupState(drawerLargerScreenOpen: false)) {
    on<StartupEvent>((event, emit) async {
      if (event is ControlDrawerLargerScreen) {
        emit(state.copyWith(
            drawerLargerScreenOpen: event.drawerLargerScreenOpen));
      } else if (event is SelectClickupWorkspace) {
        Globals.selectedWorkspace = event.clickupWorkspace;
        emit(state.copyWith(
            selectedClickupWorkspace: event.clickupWorkspace,
            startupStateEnum: StartupStateEnum.loading));
        final saveResult = _selectWorkspaceUseCase(SelectWorkspaceParams());
        final getAllInClickupWorkspaceResult = await _getAllInClickupWorkspaceUseCase(
            GetAllInClickupWorkspaceParams(
                clickupAccessToken: event.clickupAccessToken,
                clickupWorkspace: event.clickupWorkspace));
        getAllInClickupWorkspaceResult?.fold(
            (l) => emit(state.copyWith(
                startupStateEnum: StartupStateEnum.getSpacesFailed,
                getSpacesFailure: l)),
            (r) => emit(state.copyWith(
                startupStateEnum: StartupStateEnum.getSpacesSuccess,
                clickupSpaces: r)));
      }
    });
  }
}
