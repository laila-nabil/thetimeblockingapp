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
  final Failure? getUserFailure;
  final User? user;
  final Failure? signInFailure;
  final Failure? signUpFailure;
  final Failure? signOutFailure;
  final SignUpResult? signUpResult;

  const AuthState({
    required this.authState,
    this.getAccessTokenFailure,
    this.getUserFailure,
    this.user,
    this.signInFailure,
    this.signUpFailure,
    this.signOutFailure,
    this.signUpResult,
  });

  ///TODO B fix workaround
  AccessToken get accessToken =>  serviceLocator<AccessToken>(
      instanceName: ServiceLocatorName.accessToken.name);

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
    Failure? getUserFailure,
    User? user,
    Failure? signInFailure,
    Failure? signUpFailure,
    Failure? signOutFailure,
    bool resetState = false,
    SignUpResult? signUpResult,
  }) {
    if(resetState){
      serviceLocator.registerSingleton<String>('',
          instanceName: ServiceLocatorName.refreshToken.name);
      serviceLocator.registerSingleton<AccessToken>(
          const AccessToken(accessToken: '', tokenType: ''),
          instanceName: ServiceLocatorName.accessToken.name);
    }
    return AuthState(
      authState: authState ?? this.authState,
      getAccessTokenFailure:
          getAccessTokenFailure ?? this.getAccessTokenFailure,
      getUserFailure: getUserFailure ?? this.getUserFailure,
      user: resetState ? null : user ?? this.user,
      signInFailure: signInFailure ?? this.signInFailure,
      signUpFailure: signUpFailure ?? this.signUpFailure,
      signOutFailure: signOutFailure ?? this.signOutFailure,
      signUpResult: signUpResult ?? this.signUpResult,
    );
  }
}
