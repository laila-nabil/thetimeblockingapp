import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/core/error/failures.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/features/startup/domain/use_cases/get_clickup_all_lists_in_folders_use_case.dart';

import '../../../tasks/domain/entities/clickup_folder.dart';
import '../../../tasks/domain/entities/clickup_list.dart';
import '../../domain/use_cases/get_clickup_folders_use_case.dart';

part 'startup_event.dart';

part 'startup_state.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState> {
  final GetClickupFoldersUseCase _getClickupFoldersUseCase;
  final GetClickupAllListsInFoldersUseCase _getClickupAllListsUseCase;

  StartupBloc(
      this._getClickupFoldersUseCase, this._getClickupAllListsUseCase)
      : super(const StartupState(drawerLargerScreenOpen: false)) {
    on<StartupEvent>((event, emit) async {
      if (event is ControlDrawerLargerScreen) {
        emit(state.copyWith(
            drawerLargerScreenOpen: event.drawerLargerScreenOpen));
      } else if (event is SelectClickupWorkspace) {
        Globals.selectedWorkspace = event.clickupWorkspace;
        emit(state.copyWith(selectedClickupWorkspace: event.clickupWorkspace));
        emit(state.copyWith(startupStateEnum: StartupStateEnum.loading));
        final getClickupFolders =
            await _getClickupFoldersUseCase(event.getClickupFoldersParams);
        getClickupFolders?.fold(
            (l) => emit(state.copyWith(
                startupStateEnum: StartupStateEnum.getFoldersFailed,
                getFoldersFailure: l)),
            (r) {
              emit(state.copyWith(
                startupStateEnum: StartupStateEnum.getFoldersSuccess,
                clickupFolders: r));
            });
        if(getClickupFolders?.isRight() == true){
          emit(state.copyWith(startupStateEnum: StartupStateEnum.loading));
          final listsInFoldersResult = await _getClickupAllListsUseCase(
              GetClickupAllListsInFoldersParams(
                  clickupAccessToken: event.getClickupFoldersParams.clickupAccessToken,
                  clickupFolders: state.clickupFolders??[]));
          listsInFoldersResult?.fold(
                  (l) => emit(state.copyWith(
                  startupStateEnum: StartupStateEnum.getListsInFoldersFailed,
                  getFoldersFailure: l)),
                  (r) {
                emit(state.copyWith(
                    startupStateEnum: StartupStateEnum.getListsInFoldersSuccess,
                    clickupListsInFolders: r));
              });
        }
      }
    });
  }
}
