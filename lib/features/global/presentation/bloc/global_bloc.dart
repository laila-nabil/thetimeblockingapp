import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/status.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/entities/space.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_priorities_use_case.dart';
import 'package:thetimeblockingapp/features/global/domain/use_cases/get_statuses_use_case.dart';
import '../../../../common/entities/priority.dart';
import '../../domain/use_cases/get_all_in_workspace_use_case.dart';

part 'global_event.dart';

part 'global_state.dart';

class GlobalBloc extends Bloc<GlobalEvent, GlobalState>  with GlobalsWriteAccess {
  final GetAllInWorkspaceUseCase _getAllInWorkspaceUseCase;
  final GetStatusesUseCase _getStatusesUseCase;
  final GetPrioritiesUseCase _getPrioritiesUseCase;
  GlobalBloc(
    this._getAllInWorkspaceUseCase, this._getStatusesUseCase, this._getPrioritiesUseCase,
  ) : super(const GlobalState(drawerLargerScreenOpen: false)) {
    on<GlobalEvent>((event, emit) async {
      if (event is ControlDrawerLargerScreen) {
        emit(state.copyWith(
            drawerLargerScreenOpen: event.drawerLargerScreenOpen));
      }
      else if (event is GetAllInWorkspaceEvent) {
        if (Globals.isWorkspaceAndSpaceAppWide ) {
          emit(state.copyWith(
              selectedWorkspace: event.workspace,
              startupStateEnum: StartupStateEnum.loading));
          final getAllInWorkspaceResult =
              await _getAllInWorkspaceUseCase(
                  GetAllInWorkspaceParams(
                      accessToken: event.accessToken,
                      workspace: event.workspace));
          getAllInWorkspaceResult.fold(
              (l) => emit(state.copyWith(
                  startupStateEnum: StartupStateEnum.getAllInWorkspaceFailed,
                  getAllInWorkspaceFailure: l)),
              (r) => emit(state.copyWith(
                  startupStateEnum: StartupStateEnum.getAllInWorkspaceSuccess,
                  selectedWorkspace: r)));
        }
      } else if (event is GetPrioritiesEvent) {
        emit(state.copyWith(
            startupStateEnum: StartupStateEnum.loading));
        final result =
        await _getPrioritiesUseCase(
            GetPrioritiesParams(
              event.accessToken,));
        result.fold(
                (l) => emit(state.copyWith(
                startupStateEnum: StartupStateEnum.getPrioritiesFailed,
                getPrioritiesFailure: l)),
                (r) => emit(state.copyWith(
                startupStateEnum: StartupStateEnum.getPrioritiesSuccess,
                priorities: r)));
      } else if (event is GetStatusesEvent) {
        emit(state.copyWith(
            startupStateEnum: StartupStateEnum.loading));
        final result =
        await _getStatusesUseCase(
            GetStatusesParams(
              event.accessToken,));
        result.fold(
                (l) => emit(state.copyWith(
                startupStateEnum: StartupStateEnum.getStatusesFailed,
                getStatusesFailure: l)),
                (r) => emit(state.copyWith(
                startupStateEnum: StartupStateEnum.getStatusesSuccess,
                statuses: r)));
      }
    });
  }
}
