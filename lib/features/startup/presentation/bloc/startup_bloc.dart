import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/common/entities/access_token.dart';
import 'package:thetimeblockingapp/common/entities/space.dart';
import '../../../tasks/domain/use_cases/get_all_in_workspace_use_case.dart';

part 'startup_event.dart';

part 'startup_state.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState>  with GlobalsWriteAccess {
  final GetAllInWorkspaceUseCase _getAllInWorkspaceUseCase;
  StartupBloc(
    this._getAllInWorkspaceUseCase,
  ) : super(const StartupState(drawerLargerScreenOpen: false)) {
    on<StartupEvent>((event, emit) async {
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
      }
    });
  }
}
