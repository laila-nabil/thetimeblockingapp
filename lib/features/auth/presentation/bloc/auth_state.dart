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
  deleteAccountSuccess,deleteAccountFailed, updateUserSuccess, updateUserFailed
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
  final Failure? deleteAccountFailure;
  final Failure? updateUserFailure;

  const AuthState({
    required this.authState,
    this.getAccessTokenFailure,
    this.getUserFailure,
    this.user,
    this.signInFailure,
    this.signUpFailure,
    this.signOutFailure,
    this.signUpResult,
    this.deleteAccountFailure,
    this.updateUserFailure,
  });

  AccessToken get accessToken =>  serviceLocator<AppConfig>().accessToken;

  bool get isLoading => authState == AuthStateEnum.loading;

  bool get canGoSchedulePage {
    return user != null &&
        accessToken != const AccessToken(accessToken: '', tokenType: '');
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
        deleteAccountFailure,
        updateUserFailure,
      ];

  AuthState copyWith({
    AuthStateEnum? authState,
    Failure? getAccessTokenFailure,
    Failure? getUserFailure,
    User? user,
    Failure? signInFailure,
    Failure? signUpFailure,
    Failure? updateUserFailure,
    Failure? signOutFailure,
    Failure? deleteAccountFailure,
    bool resetState = false,
    SignUpResult? signUpResult,
  }) {
    if(resetState){
      serviceLocator<AppConfig>().refreshToken = '';
      serviceLocator<AppConfig>().accessToken = const AccessToken(accessToken: '', tokenType: '');
    
    }
    return AuthState(
      authState: authState ?? this.authState,
      getAccessTokenFailure:
          getAccessTokenFailure ?? this.getAccessTokenFailure,
      getUserFailure: getUserFailure ?? this.getUserFailure,
      user: resetState ? null : user ?? this.user,
      signInFailure: signInFailure ?? this.signInFailure,
      signUpFailure: signUpFailure ?? this.signUpFailure,
      updateUserFailure: updateUserFailure ?? this.updateUserFailure,
      signOutFailure: signOutFailure ?? this.signOutFailure,
      signUpResult: signUpResult ?? this.signUpResult,
      deleteAccountFailure: deleteAccountFailure ?? this.deleteAccountFailure,
    );
  }
}
