import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';

import '../../../../common/entities/user.dart';
import '../../../../core/error/failures.dart';
import '../../../global/domain/use_cases/get_workspaces_use_case.dart';
import '../../../../common/entities/access_token.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetWorkspacesUseCase _getWorkspacesUseCase;
  final SignInUseCase _signInUseCase;

  AuthBloc(this._getWorkspacesUseCase, this._signInUseCase)
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
          emit(state.copyWith(authState: AuthStateEnum.loading));
          final getWorkspaces = await _getWorkspacesUseCase(GetWorkspacesParams(
              accessToken: r.accessToken,
              userId: r.user.id.toStringOrNull() ?? ""));
          emit(state.copyWith(authState: AuthStateEnum.loading));
          getWorkspaces?.fold(
              (l) => emit(state.copyWith(
                  getWorkspacesFailure: l,
                  authState: AuthStateEnum.getWorkspacesFailed)), (r) {
            emit(state.copyWith(
                workspaces: r, authState: AuthStateEnum.getWorkspacesSuccess));
          });
        });
      }
    });
  }
}
