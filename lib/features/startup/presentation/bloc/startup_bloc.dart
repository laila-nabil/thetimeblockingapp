import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';

part 'startup_event.dart';

part 'startup_state.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState> {
  StartupBloc() : super(const StartupState(drawerLargerScreenOpen: false)) {
    on<StartupEvent>((event, emit) {
      if (event is ControlDrawerLargerScreen) {
        emit(state.copyWith(
            drawerLargerScreenOpen: event.drawerLargerScreenOpen));
      } else if (event is SelectClickupWorkspace) {
        emit(state.copyWith(selectedClickupWorkspace: event.clickupWorkspace));
      }
    });
  }
}
