import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'startup_event.dart';

part 'startup_state.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState> {
  StartupBloc() : super(const StartupState(drawerLargerScreenOpen: false)) {
    on<StartupEvent>((event, emit) {
      if (event is ControlDrawerLargerScreen) {
        emit(
            StartupState(drawerLargerScreenOpen: event.drawerLargerScreenOpen));
      }
    });
  }
}
