part of 'auth_bloc.dart';

enum AuthStateEnum {
  initial,
  loading,
  showCodeInputTextField,
  signInSuccess,
  signInFailed,
  signUpSuccess,
  signUpFailed,
  getAccessTokenSuccess,
  getAccessTokenFailed,
  getAUserFailed,
  getWorkspacesSuccess,
  getWorkspacesFailed,
  triedGetSelectedWorkspacesSpace,
}

class AuthState extends Equatable {
  final Set<AuthStateEnum> authStates;
  final Failure? getAccessTokenFailure;
  final AccessToken? accessToken;
  final Failure? getUserFailure;
  final List<Workspace>? workspaces;
  final Failure? getWorkspacesFailure;
  final User? user;
  final Failure? signInFailure;

  const AuthState({
    required this.authStates,
    this.getAccessTokenFailure,
    this.accessToken,
    this.getUserFailure,
    this.workspaces,
    this.getWorkspacesFailure,
    this.user,
    this.signInFailure,
  });

  bool get isLoading {
    printDebug("authStates $authStates");
    printDebug(
        "authStates.contains(AuthStateEnum.loading) ${authStates.contains(AuthStateEnum.loading)}");
    return authStates.contains(AuthStateEnum.loading);
  }

  bool get canGoSchedulePage {
    return user != null &&
        accessToken != null &&
        workspaces?.isNotEmpty == true;
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
        getAccessTokenFailure,
        accessToken,
        getUserFailure,
        workspaces,
        getWorkspacesFailure,
        user,
        signInFailure,
      ];

  AuthState copyWith({
    Set<AuthStateEnum>? authStates,
    Failure? getAccessTokenFailure,
    AccessToken? accessToken,
    Failure? getUserFailure,
    List<Workspace>? workspaces,
    Failure? getWorkspacesFailure,
    User? user,
    Failure? signInFailure
  }) {
    return AuthState(
      authStates: authStates ?? this.authStates,
      getAccessTokenFailure:
          getAccessTokenFailure ?? this.getAccessTokenFailure,
      accessToken: accessToken ??this.accessToken,
      getUserFailure:
          getUserFailure ?? this.getUserFailure,
      workspaces: workspaces ?? this.workspaces,
      getWorkspacesFailure:
          getWorkspacesFailure ?? this.getWorkspacesFailure,
      signInFailure: signInFailure ?? this.signInFailure,
      user: user ?? this.user
    );
  }
}
