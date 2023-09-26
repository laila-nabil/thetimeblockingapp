part of 'auth_bloc.dart';

enum AuthStateEnum {
  showCodeInputTextField,
  getClickUpAccessTokenSuccess,
  getClickUpAccessTokenFailed,
  getClickUpUserSuccess,
  getClickUpAUserFailed,
  getClickUpWorkspacesSuccess,
  getClickUpWorkspacesFailed,
}

class AuthState extends Equatable {
  final Set<AuthStateEnum> authStates;
  final Failure? getClickUpAccessTokenFailure;
  final ClickUpAccessToken? clickUpAccessToken;
  final ClickupUser? clickupUser;
  final Failure? getClickUpUserFailure;
  final List<ClickupWorkspace>? clickupWorkspaces;
  final Failure? getClickupWorkspacesFailure;

  const AuthState({
    required this.authStates,
    this.getClickUpAccessTokenFailure,
    this.clickUpAccessToken,
    this.clickupUser,
    this.getClickUpUserFailure,
    this.clickupWorkspaces,
    this.getClickupWorkspacesFailure,
  });

  Set<AuthStateEnum> updatedAuthStates(AuthStateEnum state) {
    Set<AuthStateEnum> updatedAuthStates = Set.from(authStates);
    if (updatedAuthStates.contains(state)) {
      updatedAuthStates.remove(state);
    } else {
      updatedAuthStates.add(state);
    }

    return updatedAuthStates;
  }

  @override
  List<Object?> get props => [
        authStates,
        getClickUpAccessTokenFailure,
        clickUpAccessToken,
        clickupUser,
        getClickUpUserFailure,
        clickupWorkspaces,
        getClickupWorkspacesFailure,
      ];
}
