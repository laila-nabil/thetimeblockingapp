import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';

import '../../../tasks/domain/entities/clickup_folder.dart';
import '../../../tasks/domain/entities/clickup_task.dart';
import '../../domain/use_cases/get_clickup_folders_use_case.dart';

part 'startup_event.dart';

part 'startup_state.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState> {
  final GetClickUpFoldersUseCase _getClickUpFoldersUseCase;

  StartupBloc(this._getClickUpFoldersUseCase)
      : super(const StartupState(drawerLargerScreenOpen: false)) {
    on<StartupEvent>((event, emit) async {
      if (event is ControlDrawerLargerScreen) {
        emit(state.copyWith(
            drawerLargerScreenOpen: event.drawerLargerScreenOpen));
      } else if (event is SelectClickupWorkspace) {
        Globals.selectedWorkspace = event.clickupWorkspace;
        emit(state.copyWith(selectedClickupWorkspace: event.clickupWorkspace));
        emit(state.copyWith(startupStateEnum: StartupStateEnum.loading));
        final getClickUpFolders =
            await _getClickUpFoldersUseCase(event.getClickUpFoldersParams);
        getClickUpFolders?.fold(
            (l) => emit(state.copyWith(
                startupStateEnum: StartupStateEnum.getFoldersFailed,
                getFoldersFailure: l)),
            (r) => emit(state.copyWith(
                startupStateEnum: StartupStateEnum.getFoldersSuccess,
                clickUpFolders: r)));
      }
    });
  }
}
