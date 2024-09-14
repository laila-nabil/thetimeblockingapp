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
  triedGetSelectedWorkspacesSpace, signOutFailed, signOutSuccess,
}

class AuthState extends Equatable {
  final AuthStateEnum authState;
  final Failure? getAccessTokenFailure;
  final AccessToken? accessToken;
  final Failure? getUserFailure;
  final User? user;
  final Failure? signInFailure;
  final Failure? signOutFailure;

  const AuthState({
    required this.authState,
    this.getAccessTokenFailure,
    this.accessToken,
    this.getUserFailure,
    this.user,
    this.signInFailure,
    this.signOutFailure,
  });

  bool get isLoading => authState == AuthStateEnum.loading;

  bool get canGoSchedulePage {
    return user != null &&
        accessToken != null ;
  }

  @override
  List<Object?> get props => [
        authState,
        getAccessTokenFailure,
        accessToken,
        getUserFailure,
        user,
        signInFailure,
        signOutFailure
      ];

  AuthState copyWith({
    AuthStateEnum? authState,
    Failure? getAccessTokenFailure,
    AccessToken? accessToken,
    Failure? getUserFailure,
    User? user,
    Failure? signInFailure,
    Failure? signOutFailure,
    bool resetState = false,
  }) {
    return AuthState(
      authState: authState ?? this.authState,
      getAccessTokenFailure:
          getAccessTokenFailure ?? this.getAccessTokenFailure,
      accessToken: resetState ? null : (accessToken ?? this.accessToken),
      getUserFailure: getUserFailure ?? this.getUserFailure,
      user: resetState ? null : user ?? this.user,
      signInFailure: signInFailure ?? this.signInFailure,
      signOutFailure: signOutFailure ?? this.signOutFailure,
    );
  }
}
