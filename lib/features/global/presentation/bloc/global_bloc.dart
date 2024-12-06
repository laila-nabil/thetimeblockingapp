import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';

import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_priorities_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_statuses_use_case.dart';
import '../../../../common/entities/priority.dart';
import '../../../../common/entities/user.dart';
import '../../domain/use_cases/get_all_in_workspace_use_case.dart';
import '../../domain/use_cases/get_workspaces_use_case.dart';

part 'global_event.dart';

part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState> {
  final GetAllInWorkspaceUseCase _getAllInWorkspaceUseCase;
  final GetStatusesUseCase _getStatusesUseCase;
  final GetPrioritiesUseCase _getPrioritiesUseCase;
  final GetWorkspacesUseCase _getWorkspacesUseCase;

  GlobalBloc(
    this._getAllInWorkspaceUseCase,
    this._getStatusesUseCase,
    this._getWorkspacesUseCase,
    this._getPrioritiesUseCase,
  ) : super(const GlobalState(
            drawerLargerScreenOpen: false, isLoading: false)) {
    on<GlobalEvent>((event, emit) async {
      if (event is ControlDrawerLargerScreen) {
        emit(state.copyWith(
            drawerLargerScreenOpen: event.drawerLargerScreenOpen));
      } else if (event is GetAllInWorkspaceEvent && state.isLoading != true) {
        if (serviceLocator<AppConfig>().isWorkspaceAppWide) {
          emit(state.copyWith(
              selectedWorkspace: event.workspace, isLoading: true));
          final getAllInWorkspaceResult = await _getAllInWorkspaceUseCase(
              GetAllInWorkspaceParams(
                  workspace: event.workspace, user: event.user));
          getAllInWorkspaceResult.fold(
              (l) => emit(state.copyWith(getAllInWorkspaceFailure: l)),
              (r) => emit(state.copyWith(selectedWorkspace: r)));
        }
      } else if (event is GetPrioritiesEvent) {
        emit(state.copyWith(isLoading: true));
        final result = await _getPrioritiesUseCase(event.getPrioritiesParams);
        result.fold((l) => emit(state.copyWith(getPrioritiesFailure: l)),
            (r) => emit(state.copyWith(priorities: r)));
      } else if (event is GetStatusesEvent) {
        emit(state.copyWith(isLoading: true));
        final result = await _getStatusesUseCase(event.getStatusesParams);
        result.fold((l) => emit(state.copyWith(getStatusesFailure: l)),
            (r) => emit(state.copyWith(statuses: r)));
      }else if (event is GetAllWorkspacesEvent) {
        emit(state.copyWith(isLoading: true));
        final result = await _getWorkspacesUseCase(event.params);
        result.fold((l) => emit(state.copyWith(getWorkspacesFailure: l)),
                (r) => emit(state.copyWith(workspaces: r)));
      } else if(event is ClearUserDataEvent){
        emit(state.clearUserData());
      }
    });
  }
}
