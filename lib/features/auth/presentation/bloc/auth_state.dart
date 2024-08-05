part of 'auth_bloc.dart';

enum AuthStateEnum {
  initial,
  loading,
  showCodeInputTextField,
  signInSuccess,
  signInFailed,
  signUpSuccess,
  signUpFailed,
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
  final AccessToken? accessToken;
  final User? clickupUser;
  final Failure? getClickupUserFailure;
  final List<Workspace>? workspaces;
  final Failure? getClickupWorkspacesFailure;
  final User? supabaseUser;
  final Failure? signInFailure;

  const AuthState({
    required this.authStates,
    this.getClickupAccessTokenFailure,
    this.accessToken,
    this.clickupUser,
    this.getClickupUserFailure,
    this.workspaces,
    this.getClickupWorkspacesFailure,
    this.supabaseUser,
    this.signInFailure,
  });

  bool get isLoading {
    printDebug("authStates $authStates");
    printDebug(
        "authStates.contains(AuthStateEnum.loading) ${authStates.contains(AuthStateEnum.loading)}");
    return authStates.contains(AuthStateEnum.loading);
  }

  bool get canGoSchedulePage {
    if(Globals.backendMode == BackendMode.supabase){
      return supabaseUser != null &&
          accessToken != null &&
          workspaces?.isNotEmpty == true;
    }
    return !(isLoading == false && accessToken?.isEmpty == true ||
        clickupUser == null ||
        workspaces?.isNotEmpty == false ||
        authStates.contains(AuthStateEnum.triedGetSelectedWorkspacesSpace) ==
            false);
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
        accessToken,
        clickupUser,
        getClickupUserFailure,
        workspaces,
        getClickupWorkspacesFailure,
        supabaseUser,
        signInFailure,
      ];

  AuthState copyWith({
    Set<AuthStateEnum>? authStates,
    Failure? getClickupAccessTokenFailure,
    AccessToken? accessToken,
    User? clickupUser,
    Failure? getClickupUserFailure,
    List<Workspace>? clickupWorkspaces,
    Failure? getClickupWorkspacesFailure,
    User? supabaseUser,
    Failure? signInFailure
  }) {
    return AuthState(
      authStates: authStates ?? this.authStates,
      getClickupAccessTokenFailure:
          getClickupAccessTokenFailure ?? this.getClickupAccessTokenFailure,
      accessToken: accessToken ??this.accessToken,
      clickupUser: clickupUser ?? this.clickupUser,
      getClickupUserFailure:
          getClickupUserFailure ?? this.getClickupUserFailure,
      workspaces: clickupWorkspaces ?? this.workspaces,
      getClickupWorkspacesFailure:
          getClickupWorkspacesFailure ?? this.getClickupWorkspacesFailure,
      signInFailure: signInFailure ?? this.signInFailure,
      supabaseUser: supabaseUser ?? this.supabaseUser
    );
  }
}
