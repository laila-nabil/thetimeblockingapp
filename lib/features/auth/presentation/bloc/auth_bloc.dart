import 'dart:async';
import 'dart:collection';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(const AuthState(authStates: {})) {
    on<AuthEvent>((event, emit) {
      if (event is ShowCodeInputTextField) {
        Set<AuthStateEnum> authStates = Set.from(state.authStates);
        try {
          if (event.showCodeInputTextField) {
            authStates.add(AuthStateEnum.showCodeInputTextField);
          } else {
            authStates.remove(AuthStateEnum.showCodeInputTextField);
          }
        } catch (e) {
          printDebug("$e",printLevel: PrintLevel.error);
        }
        emit(AuthState(authStates: authStates));
      }
    });
  }
}
