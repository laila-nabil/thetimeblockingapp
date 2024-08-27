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
  final AuthStateEnum authState;
  final Failure? getAccessTokenFailure;
  final AccessToken? accessToken;
  final Failure? getUserFailure;
  final List<Workspace>? workspaces;
  final Failure? getWorkspacesFailure;
  final User? user;
  final Failure? signInFailure;

  const AuthState({
    required this.authState,
    this.getAccessTokenFailure,
    this.accessToken,
    this.getUserFailure,
    this.workspaces,
    this.getWorkspacesFailure,
    this.user,
    this.signInFailure,
  });

  bool get isLoading => authState == AuthStateEnum.loading;

  bool get canGoSchedulePage {
    return user != null &&
        accessToken != null &&
        workspaces?.isNotEmpty == true;
  }

  @override
  List<Object?> get props => [
        authState,
        getAccessTokenFailure,
        accessToken,
        getUserFailure,
        workspaces,
        getWorkspacesFailure,
        user,
        signInFailure,
      ];

  AuthState copyWith({
    AuthStateEnum? authState,
    Failure? getAccessTokenFailure,
    AccessToken? accessToken,
    Failure? getUserFailure,
    List<Workspace>? workspaces,
    Failure? getWorkspacesFailure,
    User? user,
    Failure? signInFailure
  }) {
    return AuthState(
      authState: authState ?? this.authState,
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
