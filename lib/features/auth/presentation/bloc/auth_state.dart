part of 'auth_bloc.dart';

enum AuthStateEnum {
  initial,
  loading,
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

  bool get isLoading => authStates.contains(AuthStateEnum.loading);

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

  AuthState copyWith({
    Set<AuthStateEnum>? authStates,
    Failure? getClickUpAccessTokenFailure,
    ClickUpAccessToken? clickUpAccessToken,
    ClickupUser? clickupUser,
    Failure? getClickUpUserFailure,
    List<ClickupWorkspace>? clickupWorkspaces,
    Failure? getClickupWorkspacesFailure,
  }) {
    return AuthState(
      authStates: authStates ?? this.authStates,
      getClickUpAccessTokenFailure:
          getClickUpAccessTokenFailure ?? this.getClickUpAccessTokenFailure,
      clickUpAccessToken: clickUpAccessToken ?? this.clickUpAccessToken,
      clickupUser: clickupUser ?? this.clickupUser,
      getClickUpUserFailure:
          getClickUpUserFailure ?? this.getClickUpUserFailure,
      clickupWorkspaces: clickupWorkspaces ?? this.clickupWorkspaces,
      getClickupWorkspacesFailure:
          getClickupWorkspacesFailure ?? this.getClickupWorkspacesFailure,
    );
  }
}
