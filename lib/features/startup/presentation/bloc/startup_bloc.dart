import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/access_token.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/space.dart';
import '../../../tasks/domain/use_cases/get_all_in_space_use_case.dart';
import '../../../tasks/domain/use_cases/get_all_in_workspace_use_case.dart';
import '../../../tasks/domain/use_cases/get_spaces_in_workspace_use_case.dart';
import '../../domain/use_cases/save_spaces_use_case.dart';
import '../../domain/use_cases/select_space_use_case.dart';
import '../../domain/use_cases/select_workspace_use_case.dart';

part 'startup_event.dart';

part 'startup_state.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState>  with GlobalsWriteAccess {
  final GetAllInWorkspaceUseCase _getAllInWorkspaceUseCase;
  final GetSpacesInWorkspacesUseCase _getSpacesInWorkspacesUseCase;
  final GetAllInSpaceUseCase _getAllInSpaceUseCase;
  final SelectWorkspaceUseCase _selectWorkspaceUseCase;
  final SelectSpaceUseCase _selectSpaceUseCase;
  final SaveSpacesUseCase _saveSpacesUseCase;
  StartupBloc(
    this._getAllInWorkspaceUseCase,
    this._getSpacesInWorkspacesUseCase,
    this._getAllInSpaceUseCase,
    this._selectSpaceUseCase,
    this._saveSpacesUseCase,
    this._selectWorkspaceUseCase,
  ) : super(const StartupState(drawerLargerScreenOpen: false)) {
    on<StartupEvent>((event, emit) async {
      if (event is ControlDrawerLargerScreen) {
        emit(state.copyWith(
            drawerLargerScreenOpen: event.drawerLargerScreenOpen));
      }
      else if (event is SelectWorkspaceAndGetSpacesTagsLists) {
        selectedWorkspace = event.workspace;
        if (Globals.isSpaceAppWide == false) {
          emit(state.copyWith(
              selectedClickupWorkspace: event.workspace,
              startupStateEnum: StartupStateEnum.loading));
          await _selectWorkspaceUseCase(
              SelectWorkspaceParams(event.workspace));
          final getAllInClickupWorkspaceResult =
              await _getAllInWorkspaceUseCase(
                  GetAllInWorkspaceParams(
                      accessToken: event.accessToken,
                      workspace: event.workspace));
          await getAllInClickupWorkspaceResult?.fold(
              (l) async => emit(state.copyWith(
                  startupStateEnum: StartupStateEnum.getSpacesFailed,
                  getSpacesFailure: l)),
              (r) async {
                await _saveSpacesUseCase(
                    SaveSpacesParams(r));
                emit(state.copyWith(
                  startupStateEnum: StartupStateEnum.getSpacesSuccess,
                  clickupSpaces: r));
              });
        } else {
          emit(state.copyWith(
              selectedClickupWorkspace: event.workspace,
              startupStateEnum: StartupStateEnum.loading));
          await _selectWorkspaceUseCase(
              SelectWorkspaceParams(event.workspace));
          final getSpacesInClickupWorkspaceResult =
              await _getSpacesInWorkspacesUseCase(
                  GetSpacesInWorkspacesParams(
                      clickupAccessToken: event.accessToken,
                      clickupWorkspace: event.workspace));
          await getSpacesInClickupWorkspaceResult?.fold(
              (l) async=> emit(state.copyWith(
                  startupStateEnum: StartupStateEnum.getSpacesFailed,
                  getSpacesFailure: [
                        {"spaces": l}
                      ])),
              (r) async {
                await _saveSpacesUseCase(
                    SaveSpacesParams(r));
                emit(state.copyWith(
                  startupStateEnum: StartupStateEnum.getSpacesSuccess,
                  clickupSpaces: r));
                printDebug("selectedSpace ${Globals.selectedSpaceId}");
                printDebug("defaultSpace ${Globals.defaultSpace}");
                printDebug("clickupSpaces ${Globals.spaces}");
                final space = Globals.selectedSpace ?? Globals.defaultSpace;
                if (space != null) {
                  add(SelectSpace(
                      space: space,
                      accessToken: event.accessToken));
                }
          });
        }
      }
      else if (event is SelectSpace && Globals.isSpaceAppWide) {
        setSelectedSpace(event.space);
        emit(state.copyWith(
            selectedClickupSpace: event.space,
            startupStateEnum: StartupStateEnum.loading));
        final getAllInClickupSpaceResult =
            await _getAllInSpaceUseCase(GetAllInSpaceParams(
                accessToken: event.accessToken,
                space: event.space));
        getAllInClickupSpaceResult?.fold(
            (l) => emit(state.copyWith(
                startupStateEnum: StartupStateEnum.getAllInSpaceFailed,
                startGetTasks:false,
                getAllInSpaceFailure: l)),
            (r) => emit(state.copyWith(
                startupStateEnum: StartupStateEnum.getAllInSpaceSuccess,
                startGetTasks:true,
                selectedClickupSpace: r)));
        if(Globals.selectedSpace!=null){
          await _selectSpaceUseCase(SelectSpaceParams(Globals.selectedSpace!));
        }
      }
      else if(event is StartGetTasksEvent){
        emit(state.copyWith(startGetTasks: event.startGetTasks));
      }
    });
  }
}
