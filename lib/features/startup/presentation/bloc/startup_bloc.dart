import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/entities/space.dart';
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
              selectedWorkspace: event.workspace,
              startupStateEnum: StartupStateEnum.loading));
          await _selectWorkspaceUseCase(
              SelectWorkspaceParams(event.workspace));
          final getAllInWorkspaceResult =
              await _getAllInWorkspaceUseCase(
                  GetAllInWorkspaceParams(
                      accessToken: event.accessToken,
                      workspace: event.workspace));
          await getAllInWorkspaceResult?.fold(
              (l) async => emit(state.copyWith(
                  startupStateEnum: StartupStateEnum.getSpacesFailed,
                  getSpacesFailure: l)),
              (r) async {
                await _saveSpacesUseCase(
                    SaveSpacesParams(r));
                emit(state.copyWith(
                  startupStateEnum: StartupStateEnum.getSpacesSuccess,
                  spaces: r));
              });
        } else {
          emit(state.copyWith(
              selectedWorkspace: event.workspace,
              startupStateEnum: StartupStateEnum.loading));
          await _selectWorkspaceUseCase(
              SelectWorkspaceParams(event.workspace));
          final getSpacesInWorkspaceResult =
              await _getSpacesInWorkspacesUseCase(
                  GetSpacesInWorkspacesParams(
                      accessToken: event.accessToken,
                      workspace: event.workspace));
          await getSpacesInWorkspaceResult?.fold(
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
                  spaces: r));
                printDebug("selectedSpace ${Globals.selectedSpaceId}");
                printDebug("defaultSpace ${Globals.defaultSpace}");
                printDebug("spaces ${Globals.spaces}");
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
            selectedSpace: event.space,
            startupStateEnum: StartupStateEnum.loading));
        final getAllInSpaceResult =
            await _getAllInSpaceUseCase(GetAllInSpaceParams(
                accessToken: event.accessToken,
                space: event.space));
        getAllInSpaceResult?.fold(
            (l) => emit(state.copyWith(
                startupStateEnum: StartupStateEnum.getAllInSpaceFailed,
                startGetTasks:false,
                getAllInSpaceFailure: l)),
            (r) => emit(state.copyWith(
                startupStateEnum: StartupStateEnum.getAllInSpaceSuccess,
                startGetTasks:true,
                selectedSpace: r)));
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
