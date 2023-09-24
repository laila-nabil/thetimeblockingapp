import 'package:bloc/bloc.dart';

import 'print_debug.dart';

class MyBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc<dynamic,dynamic> bloc, Object? event) {
    super.onEvent(bloc, event);
    printDebug('MyBlocObserver ${bloc.runtimeType} Event $event');
  }

  @override
  void onError(BlocBase<dynamic> bloc, Object error, StackTrace stackTrace) {
    printDebug('MyBlocObserver ${bloc.runtimeType} $error $stackTrace');
    super.onError(bloc, error, stackTrace);
  }

  @override
  void onChange(BlocBase<dynamic> bloc, Change<dynamic> change) {
    super.onChange(bloc, change);
    printDebug(
        'MyBlocObserver ${bloc.runtimeType} Change\n currentState: ${change.currentState} \n nextState: ${change.nextState}');
  }

  @override
  void onTransition(Bloc<dynamic,dynamic> bloc, Transition<dynamic,dynamic> transition) {
    super.onTransition(bloc, transition);
    printDebug('MyBlocObserver ${bloc.runtimeType} $transition');
  }
}
