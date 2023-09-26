
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/clickup_workspace.dart';
import 'package:thetimeblockingapp/core/usecase.dart';

import '../../../../common/entities/clickup_user.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/clickup_access_token.dart';
import '../../domain/use_cases/get_clickup_access_token_use_case.dart';
import '../../domain/use_cases/get_clickup_user_use_case.dart';
import '../../domain/use_cases/get_clickup_workspaces_use_case.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetClickUpAccessTokenUseCase _getClickUpAccessTokenUseCase;
  final GetClickUpUserUseCase _getClickUpUserUseCase;
  final GetClickUpWorkspacesUseCase _getClickUpWorkspacesUseCase;

  AuthBloc(this._getClickUpAccessTokenUseCase, this._getClickUpUserUseCase,
      this._getClickUpWorkspacesUseCase)
      : super(const AuthState(authStates: {})) {
    on<AuthEvent>((event, emit) async {
      if (event is ShowCodeInputTextField) {
        // Set<AuthStateEnum> authStates = Set.from(state.authStates);
        // try {
        //   if (event.showCodeInputTextField) {
        //     authStates.add(AuthStateEnum.showCodeInputTextField);
        //   } else {
        //     authStates.remove(AuthStateEnum.showCodeInputTextField);
        //   }
        // } catch (e) {
        //   printDebug("$e",printLevel: PrintLevel.error);
        // }
        emit(AuthState(
            authStates:
                state.updatedAuthStates(AuthStateEnum.showCodeInputTextField)));
      } else if (event is SubmitClickUpCode) {
        final result = await _getClickUpAccessTokenUseCase(
            GetClickUpAccessTokenParams(event.clickUpCode));
        result?.fold(
            (l) => emit(AuthState(
                getClickUpAccessTokenFailure: l,
                authStates: state.updatedAuthStates(
                    AuthStateEnum.getClickUpAccessTokenFailed))), (r) {
          emit(AuthState(
              clickUpAccessToken: r,
              authStates: state.updatedAuthStates(
                  AuthStateEnum.getClickUpAccessTokenSuccess)));
          add(GetClickUpUserWorkspaces(r.accessToken));
        });
      } else if (event is GetClickUpUserWorkspaces) {
        final getClickUpUser = await _getClickUpUserUseCase(NoParams());
        getClickUpUser?.fold(
            (l) => emit(state.copyWith(
                getClickUpUserFailure: l,
                authStates: state.updatedAuthStates(
                    AuthStateEnum.getClickUpAUserFailed)
            )), (r) {
          emit(state.copyWith(
              clickupUser: r,
              authStates: state
                  .updatedAuthStates(AuthStateEnum.getClickUpUserSuccess)));
        });
        final getClickUpWorkspaces =
            await _getClickUpWorkspacesUseCase(NoParams());
        getClickUpWorkspaces?.fold(
            (l) => emit(state.copyWith(
                getClickupWorkspacesFailure: l,
                authStates: state.updatedAuthStates(
                    AuthStateEnum.getClickUpWorkspacesFailed))), (r) {
          emit(state.copyWith(
              clickupWorkspaces: r,
              authStates: state.updatedAuthStates(
                  AuthStateEnum.getClickUpWorkspacesSuccess)));
        });
      }
    });
  }
}
