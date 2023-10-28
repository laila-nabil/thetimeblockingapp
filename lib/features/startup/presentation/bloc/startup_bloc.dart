import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/clickup_access_token.dart';
import 'package:thetimeblockingapp/features/tasks/domain/entities/clickup_space.dart';
import '../../../tasks/domain/use_cases/get_all_in_space_use_case.dart';
import '../../../tasks/domain/use_cases/get_all_in_workspace_use_case.dart';
import '../../../tasks/domain/use_cases/get_clickup_spaces_in_workspace_use_case.dart';
import '../../domain/use_cases/select_space_use_case.dart';
import '../../domain/use_cases/select_workspace_use_case.dart';

part 'startup_event.dart';

part 'startup_state.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState> {
  final GetAllInClickupWorkspaceUseCase _getAllInClickupWorkspaceUseCase;
  final GetClickupSpacesInWorkspacesUseCase _getClickupSpacesInWorkspacesUseCase;
  final GetAllInClickupSpaceUseCase _getAllInClickupSpaceUseCase;
  final SelectWorkspaceUseCase _selectWorkspaceUseCase;
  final SelectSpaceUseCase _selectSpaceUseCase;
  StartupBloc(
    this._getAllInClickupWorkspaceUseCase,
    this._getClickupSpacesInWorkspacesUseCase,
    this._getAllInClickupSpaceUseCase,
    this._selectSpaceUseCase,
    this._selectWorkspaceUseCase,
  ) : super(const StartupState(drawerLargerScreenOpen: false)) {
    on<StartupEvent>((event, emit) async {
      if (event is ControlDrawerLargerScreen) {
        emit(state.copyWith(
            drawerLargerScreenOpen: event.drawerLargerScreenOpen));
      } else if (event is SelectClickupWorkspace) {
        Globals.selectedWorkspace = event.clickupWorkspace;
        if (Globals.isSpaceAppWide == false) {
          emit(state.copyWith(
              selectedClickupWorkspace: event.clickupWorkspace,
              startupStateEnum: StartupStateEnum.loading));
          await _selectWorkspaceUseCase(
              SelectWorkspaceParams(event.clickupWorkspace));
          final getAllInClickupWorkspaceResult =
              await _getAllInClickupWorkspaceUseCase(
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
        } else {
          emit(state.copyWith(
              selectedClickupWorkspace: event.clickupWorkspace,
              startupStateEnum: StartupStateEnum.loading));
          await _selectWorkspaceUseCase(
              SelectWorkspaceParams(event.clickupWorkspace));
          final getSpacesInClickupWorkspaceResult =
              await _getClickupSpacesInWorkspacesUseCase(
                  GetClickupSpacesInWorkspacesParams(
                      clickupAccessToken: event.clickupAccessToken,
                      clickupWorkspace: event.clickupWorkspace));
          getSpacesInClickupWorkspaceResult?.fold(
              (l) => emit(state.copyWith(
                  startupStateEnum: StartupStateEnum.getSpacesFailed,
                  getSpacesFailure: [
                        {"spaces": l}
                      ])),
              (r) {
                emit(state.copyWith(
                  startupStateEnum: StartupStateEnum.getSpacesSuccess,
                  clickupSpaces: r));

                if (Globals.defaultSpace!=null) {
              add(SelectClickupSpace(
                  clickupSpace: Globals.defaultSpace!,
                  clickupAccessToken: event.clickupAccessToken));
            }
              });
        }
      } else if (event is SelectClickupSpace && Globals.isSpaceAppWide) {
        Globals.selectedSpace = event.clickupSpace;
        emit(state.copyWith(
            selectedClickupSpace: event.clickupSpace,
            startupStateEnum: StartupStateEnum.loading));
        final getAllInClickupSpaceResult =
            await _getAllInClickupSpaceUseCase(GetAllInClickupSpaceParams(
                clickupAccessToken: event.clickupAccessToken,
                clickupSpace: event.clickupSpace));
        getAllInClickupSpaceResult?.fold(
            (l) => emit(state.copyWith(
                startupStateEnum: StartupStateEnum.getAllInSpaceFailed,
                getTasks:false,
                getAllInSpaceFailure: l)),
            (r) => emit(state.copyWith(
                startupStateEnum: StartupStateEnum.getAllInSpaceSuccess,
                getTasks:true,
                selectedClickupSpace: r)));
        if(Globals.selectedSpace!=null){
          await _selectSpaceUseCase(SelectSpaceParams(Globals.selectedSpace!));
        }
      }else if(event is GetTasksEvent){
        emit(state.copyWith(getTasks: event.getTasks));
      }
    });
  }
}
