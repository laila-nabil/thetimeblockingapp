import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'startup_event.dart';
part 'startup_state.dart';

class StartupBloc extends Bloc<StartupEvent, StartupState> {
  StartupBloc() : super(StartupInitial()) {
    on<StartupEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
