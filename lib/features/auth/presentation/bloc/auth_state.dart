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
  triedGetSelectedWorkspacesSpace,
}

class AuthState extends Equatable {
  final Set<AuthStateEnum> authStates;
  final Failure? getClickupAccessTokenFailure;
  final AccessToken? clickupAccessToken;
  final User? clickupUser;
  final Failure? getClickupUserFailure;
  final List<Workspace>? clickupWorkspaces;
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

  bool get canGoSchedulePage {
    return !(isLoading == false && clickupAccessToken?.isEmpty == true ||
        clickupUser == null ||
        clickupWorkspaces?.isNotEmpty == false ||
        authStates.contains(AuthStateEnum.triedGetSelectedWorkspacesSpace) == false);
  }

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
    AccessToken? clickupAccessToken,
    User? clickupUser,
    Failure? getClickupUserFailure,
    List<Workspace>? clickupWorkspaces,
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
