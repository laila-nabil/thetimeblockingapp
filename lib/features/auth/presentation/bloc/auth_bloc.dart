import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/core/injection_container.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/entities/sign_up_result.dart';

import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_up_use_case.dart';

import '../../../../common/entities/user.dart';
import '../../../../core/error/failures.dart';
import '../../../../common/entities/access_token.dart';
import '../../../settings/domain/use_cases/sign_out_use_case.dart';
import '../../domain/use_cases/delete_account_use_case.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signInUseCase;
  final SignOutUseCase _signOutUseCase;
  final SignUpUseCase _signUpUseCase;
  final DeleteAccountUseCase _deleteAccountUseCase;
  AuthBloc( this._signInUseCase,this._signOutUseCase, this._signUpUseCase, this._deleteAccountUseCase)
      : super(const AuthState(authState: AuthStateEnum.initial)) {
    on<AuthEvent>((event, emit) async {
      if (event is SignInEvent) {
        emit(state.copyWith(authState: AuthStateEnum.loading));
        final result = await _signInUseCase(event.signInParams);
        await result?.fold(
            (l) async => emit(state.copyWith(
                signInFailure: l,
                authState: AuthStateEnum.signInFailed)), (r) async {
                   serviceLocator<AppConfig>().refreshToken = r.refreshToken;
                serviceLocator<AppConfig>().accessToken = r.accessToken;
        
          emit(state.copyWith(
              user: r.user,
              authState: AuthStateEnum.signInSuccess));
        });
      }else if (event is SignUpEvent) {
        emit(state.copyWith(authState: AuthStateEnum.loading));
        final result = await _signUpUseCase(event.params);
        await result?.fold(
                (l) async => emit(state.copyWith(
                    signUpFailure: l,
                authState: AuthStateEnum.signUpFailed)), (r) async {
          emit(state.copyWith(
              signUpResult: r,
              authState: AuthStateEnum.signUpSuccess));
        });
      }else if (event is CheckAlreadySignedInEvent) {
        emit(state.copyWith(authState: AuthStateEnum.loading));
        final result = await _signInUseCase(const SignInParams(
            email: '',
            password: '',
            accessToken: AccessToken(accessToken: '', tokenType: '')));
        result?.fold(
            (l) => emit(state.copyWith(
                signInFailure: l,
                authState: AuthStateEnum.signInFailed)), (r) {
                  serviceLocator<AppConfig>().accessToken = r.accessToken;
                  serviceLocator<AppConfig>().refreshToken = r.refreshToken;
          emit(state.copyWith(
              user: r.user,
              authState: AuthStateEnum.signInSuccess));
        });
      } else if(event is SignOutEvent){
        emit(state.copyWith(authState: AuthStateEnum.loading));
        final result = await _signOutUseCase(NoParams());
        result?.fold(
                (l) => emit(state.copyWith(
                signInFailure: l,
                authState: AuthStateEnum.signOutFailed)), (r) {
          emit(state.copyWith(
              resetState: true,
              authState: AuthStateEnum.signOutSuccess));
        });
      } else if (event is DeleteAccount) {
        emit(state.copyWith(authState: AuthStateEnum.loading));
        final result = await _deleteAccountUseCase(event.deleteAccountParams);
        printDebug("_deleteAccountUseCase $result");
        result.fold(
            (l) => emit(state.copyWith(
                authState: AuthStateEnum.deleteAccountFailed,
                deleteAccountFailure: l)),
            (r) => emit(
                state.copyWith(
                    resetState: true,
                    authState: AuthStateEnum.deleteAccountSuccess)));
      }
    });
  }
}
