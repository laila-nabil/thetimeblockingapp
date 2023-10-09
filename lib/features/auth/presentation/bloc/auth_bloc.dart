import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';

import '../../../../common/entities/clickup_user.dart';
import '../../../../core/error/failures.dart';
import '../../../tasks/domain/use_cases/get_clickup_workspaces_use_case.dart';
import '../../domain/entities/clickup_access_token.dart';
import '../../domain/use_cases/get_clickup_access_token_use_case.dart';
import '../../domain/use_cases/get_clickup_user_use_case.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetClickupAccessTokenUseCase _getClickupAccessTokenUseCase;
  final GetClickupUserUseCase _getClickupUserUseCase;
  final GetClickupWorkspacesUseCase _getClickupWorkspacesUseCase;

  AuthBloc(this._getClickupAccessTokenUseCase, this._getClickupUserUseCase,
      this._getClickupWorkspacesUseCase)
      : super(const AuthState(authStates: {AuthStateEnum.initial})) {
    on<AuthEvent>((event, emit) async {
      if (event is ShowCodeInputTextField) {
        emit(AuthState(
            authStates:
                state.updatedAuthStates(AuthStateEnum.showCodeInputTextField)));
      } else if (event is GetClickupAccessToken) {
        emit(const AuthState(
            authStates: {AuthStateEnum.loading}));
        final result = await _getClickupAccessTokenUseCase(
            GetClickupAccessTokenParams(event.clickupCode));
        emit(state.copyWith(
            authStates:
                state.updatedAuthStates(AuthStateEnum.loading)));
        result?.fold(
            (l) => emit(AuthState(
                getClickupAccessTokenFailure: l,
                authStates: state.updatedAuthStates(
                    AuthStateEnum.getClickupAccessTokenFailed))), (r) {
          emit(AuthState(
              clickupAccessToken: r,
              authStates: state.updatedAuthStates(
                  AuthStateEnum.getClickupAccessTokenSuccess)));
          add(GetClickupUserWorkspaces(r));
        });
      } else if (event is GetClickupUserWorkspaces) {
        emit(state.copyWith(
            authStates:
            state.updatedAuthStates(AuthStateEnum.loading)));
        final getClickupUser = await _getClickupUserUseCase(
            GetClickupUserParams(event.accessToken));
        getClickupUser?.fold(
            (l) => emit(state.copyWith(
                getClickupUserFailure: l,
                authStates: state.updatedAuthStates(
                    AuthStateEnum.getClickupAUserFailed))), (r) {
          emit(state.copyWith(
              clickupUser: r,
              authStates: state
                  .updatedAuthStates(AuthStateEnum.getClickupUserSuccess)));
        });
        final getClickupWorkspaces = await _getClickupWorkspacesUseCase(
            GetClickupWorkspacesParams(event.accessToken));
        emit(state.copyWith(
            authStates:
            state.updatedAuthStates(AuthStateEnum.loading)));
        getClickupWorkspaces?.fold(
            (l) => emit(state.copyWith(
                getClickupWorkspacesFailure: l,
                authStates: state.updatedAuthStates(
                    AuthStateEnum.getClickupWorkspacesFailed))), (r) {
          emit(state.copyWith(
              clickupWorkspaces: r,
              authStates: state.updatedAuthStates(
                  AuthStateEnum.getClickupWorkspacesSuccess)));
        });
      }
    });
  }
}
