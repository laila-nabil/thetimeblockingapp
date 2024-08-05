import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:thetimeblockingapp/common/entities/workspace.dart';
import 'package:thetimeblockingapp/common/enums/backend_mode.dart';
import 'package:thetimeblockingapp/core/extensions.dart';
import 'package:thetimeblockingapp/core/globals.dart';
import 'package:thetimeblockingapp/core/print_debug.dart';
import 'package:thetimeblockingapp/core/usecase.dart';
import 'package:thetimeblockingapp/features/auth/domain/use_cases/sign_in_use_case.dart';
import 'package:thetimeblockingapp/features/startup/domain/use_cases/get_selected_space_use_case.dart';
import 'package:thetimeblockingapp/features/startup/domain/use_cases/get_spaces_of_selected_workspace_use_case.dart';

import '../../../../common/entities/user.dart';
import '../../../../core/error/failures.dart';
import '../../../startup/domain/use_cases/get_selected_workspace_use_case.dart';
import '../../../tasks/domain/use_cases/get_workspaces_use_case.dart';
import '../../../../common/entities/access_token.dart';
import '../../domain/use_cases/get_access_token_use_case.dart';
import '../../domain/use_cases/get_user_use_case.dart';

part 'auth_event.dart';

part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final GetAccessTokenUseCase _getAccessTokenUseCase;
  final GetUserUseCase _getUserUseCase;
  final GetWorkspacesUseCase _getWorkspacesUseCase;
  final GetSelectedWorkspaceUseCase _getSelectedWorkspaceUseCase;
  final GetSelectedSpaceUseCase _getSelectedSpaceUseCase;
  final SignInUseCase _signInUseCase;
  final GetSpacesOfSelectedWorkspaceUseCase
      _getSpacesOfSelectedWorkspaceUseCase;

  AuthBloc(
      this._getAccessTokenUseCase,
      this._getUserUseCase,
      this._getWorkspacesUseCase,
      this._getSelectedWorkspaceUseCase,
      this._getSelectedSpaceUseCase,
      this._getSpacesOfSelectedWorkspaceUseCase,
      this._signInUseCase)
      : super(const AuthState(authStates: {AuthStateEnum.initial})) {
    on<AuthEvent>((event, emit) async {
      if (event is ShowCodeInputTextField) {
        emit(AuthState(
            authStates:
                state.updatedAuthStates(AuthStateEnum.showCodeInputTextField)));
      } else if (event is GetAccessToken) {
        emit(const AuthState(authStates: {AuthStateEnum.loading}));
        final result = await _getAccessTokenUseCase(
            GetAccessTokenParams(event.clickupCode));
        emit(state.copyWith(
            authStates: state.updatedAuthStates(AuthStateEnum.loading)));
        result?.fold(
            (l) => emit(AuthState(
                getClickupAccessTokenFailure: l,
                authStates: state.updatedAuthStates(
                    AuthStateEnum.getClickupAccessTokenFailed))), (r) {
          emit(AuthState(
              accessToken: r,
              authStates: state.updatedAuthStates(
                  AuthStateEnum.getClickupAccessTokenSuccess)));
          add(GetUserWorkspaces(r, Globals.user?.id.toStringOrNull() ?? ""));
        });
      } else if (event is GetUserWorkspaces) {
        emit(state.copyWith(
            authStates: state.updatedAuthStates(AuthStateEnum.loading)));
        final getClickupUser =
            await _getUserUseCase(GetClickupUserParams(event.accessToken));
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
        final getClickupWorkspaces = await _getWorkspacesUseCase(
            GetWorkspacesParams(
                accessToken: event.accessToken, userId: event.userId));
        emit(state.copyWith(
            authStates: state.updatedAuthStates(AuthStateEnum.loading)));
        getClickupWorkspaces?.fold(
            (l) => emit(state.copyWith(
                getClickupWorkspacesFailure: l,
                authStates: state.updatedAuthStates(
                    AuthStateEnum.getWorkspacesFailed))), (r) {
          emit(state.copyWith(
              workspaces: r,
              authStates: state.updatedAuthStates(
                  AuthStateEnum.getWorkspacesSuccess)));
          add(TryGetSelectedWorkspaceSpaceEvent());
        });
      } else if (event is TryGetSelectedWorkspaceSpaceEvent) {
        await _getSelectedWorkspaceUseCase(NoParams());
        await _getSpacesOfSelectedWorkspaceUseCase(NoParams());
        if (Globals.isSpaceAppWide) {
          await _getSelectedSpaceUseCase(NoParams());
        }
        emit(state.copyWith(
            authStates: state.updatedAuthStates(
                AuthStateEnum.triedGetSelectedWorkspacesSpace)));
      } else if (event is SignInEvent) {
        final result = await _signInUseCase(event.signInParams);
        await result?.fold(
            (l) async=> emit(state.copyWith(
                signInFailure: l,
                authStates:
                    state.updatedAuthStates(AuthStateEnum.signInFailed))),
            (r) async {
              emit(state.copyWith(
                supabaseUser: r.user,
                accessToken: r.accessToken,
                authStates:
                    state.updatedAuthStates(AuthStateEnum.signInSuccess)));
              final getClickupWorkspaces = await _getWorkspacesUseCase(
                  GetWorkspacesParams(
                      accessToken: r.accessToken, userId: r.user.id??""));
              emit(state.copyWith(
                  authStates: state.updatedAuthStates(AuthStateEnum.loading)));
              getClickupWorkspaces?.fold(
                      (l) => emit(state.copyWith(
                      getClickupWorkspacesFailure: l,
                      authStates: state.updatedAuthStates(
                          AuthStateEnum.getWorkspacesFailed))), (r) {
                emit(state.copyWith(
                    workspaces: r,
                    authStates: state.updatedAuthStates(
                        AuthStateEnum.getWorkspacesSuccess)));
              });
            });
      }
    });
  }
}
