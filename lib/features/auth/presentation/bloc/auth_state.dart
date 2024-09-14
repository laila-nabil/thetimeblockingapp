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
  final Failure? signUpFailure;
  final Failure? signOutFailure;
  final SignUpResult? signUpResult;

  const AuthState({
    required this.authState,
    this.getAccessTokenFailure,
    this.accessToken,
    this.getUserFailure,
    this.user,
    this.signInFailure,
    this.signUpFailure,
    this.signOutFailure,
    this.signUpResult,
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
        signUpResult,
        signInFailure,
        signUpFailure,
        signOutFailure,
      ];

  AuthState copyWith({
    AuthStateEnum? authState,
    Failure? getAccessTokenFailure,
    AccessToken? accessToken,
    Failure? getUserFailure,
    User? user,
    Failure? signInFailure,
    Failure? signUpFailure,
    Failure? signOutFailure,
    bool resetState = false,
    SignUpResult? signUpResult,
  }) {
    return AuthState(
      authState: authState ?? this.authState,
      getAccessTokenFailure:
          getAccessTokenFailure ?? this.getAccessTokenFailure,
      accessToken: resetState ? null : (accessToken ?? this.accessToken),
      getUserFailure: getUserFailure ?? this.getUserFailure,
      user: resetState ? null : user ?? this.user,
      signInFailure: signInFailure ?? this.signInFailure,
      signUpFailure: signUpFailure ?? this.signUpFailure,
      signOutFailure: signOutFailure ?? this.signOutFailure,
      signUpResult: signUpResult ?? this.signUpResult,
    );
  }
}
