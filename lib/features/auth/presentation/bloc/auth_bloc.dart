import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';

import '../../../../common/entities/user.dart';
import '../../../../core/error/failures.dart';
import '../../../../common/entities/access_token.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signInUseCase;

  AuthBloc( this._signInUseCase)
      : super(const AuthState(authState: AuthStateEnum.initial)) {
    on<AuthEvent>((event, emit) async {
      if (event is SignInEvent) {
        emit(state.copyWith(authState: AuthStateEnum.loading));
        final result = await _signInUseCase(event.signInParams);
        await result?.fold(
            (l) async => emit(state.copyWith(
                signInFailure: l,
                authState: AuthStateEnum.signInFailed)), (r) async {
          emit(state.copyWith(
              user: r.user,
              accessToken: r.accessToken,
              authState: AuthStateEnum.signInSuccess));
        });
      }else if (event is CheckAlreadySignedInEvent) {
        emit(state.copyWith(authState: AuthStateEnum.loading));
        final result =
            await _signInUseCase(const SignInParams(email: '', password: ''));
        await result?.fold(
            (l) async => emit(state.copyWith(
                signInFailure: l,
                authState: AuthStateEnum.signInFailed)), (r) async {
          emit(state.copyWith(
              user: r.user,
              accessToken: r.accessToken,
              authState: AuthStateEnum.signInSuccess));
        });
      }
    });
  }
}
