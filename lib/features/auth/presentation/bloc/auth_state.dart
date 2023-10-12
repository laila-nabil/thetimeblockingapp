part of 'auth_bloc.dart';

enum AuthStateEnum {
  initial,
  loading,
  showCodeInputTextField,
  getClickupAccessTokenSuccess,
  getClickupAccessTokenFailed,
  getClickupUserSuccess,
  getClickupAUserFailed,
  getClickupWorkspacesSuccess,
  getClickupWorkspacesFailed,
  triedGetSelectedWorkspace,
}

class AuthState extends Equatable {
  final Set<AuthStateEnum> authStates;
  final Failure? getClickupAccessTokenFailure;
  final ClickupAccessToken? clickupAccessToken;
  final ClickupUser? clickupUser;
  final Failure? getClickupUserFailure;
  final List<ClickupWorkspace>? clickupWorkspaces;
  final Failure? getClickupWorkspacesFailure;

  const AuthState({
    required this.authStates,
    this.getClickupAccessTokenFailure,
    this.clickupAccessToken,
    this.clickupUser,
    this.getClickupUserFailure,
    this.clickupWorkspaces,
    this.getClickupWorkspacesFailure,
  });

  bool get isLoading {
    printDebug("authStates $authStates");
    printDebug("authStates.contains(AuthStateEnum.loading) ${authStates.contains(AuthStateEnum.loading)}");
    return authStates.contains(AuthStateEnum.loading);
  }

  bool get canGoSchedulePage =>
      isLoading != false &&
          clickupAccessToken?.accessToken.isNotEmpty == true &&
          clickupUser != null &&
      clickupWorkspaces?.isNotEmpty == true &&
      authStates.contains(AuthStateEnum.triedGetSelectedWorkspace) == true;

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
        getClickupAccessTokenFailure,
        clickupAccessToken,
        clickupUser,
        getClickupUserFailure,
        clickupWorkspaces,
        getClickupWorkspacesFailure,
      ];

  AuthState copyWith({
    Set<AuthStateEnum>? authStates,
    Failure? getClickupAccessTokenFailure,
    ClickupAccessToken? clickupAccessToken,
    ClickupUser? clickupUser,
    Failure? getClickupUserFailure,
    List<ClickupWorkspace>? clickupWorkspaces,
    Failure? getClickupWorkspacesFailure,
  }) {
    return AuthState(
      authStates: authStates ?? this.authStates,
      getClickupAccessTokenFailure:
          getClickupAccessTokenFailure ?? this.getClickupAccessTokenFailure,
      clickupAccessToken: clickupAccessToken ?? this.clickupAccessToken,
      clickupUser: clickupUser ?? this.clickupUser,
      getClickupUserFailure:
          getClickupUserFailure ?? this.getClickupUserFailure,
      clickupWorkspaces: clickupWorkspaces ?? this.clickupWorkspaces,
      getClickupWorkspacesFailure:
          getClickupWorkspacesFailure ?? this.getClickupWorkspacesFailure,
    );
  }
}
