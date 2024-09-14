part of 'auth_bloc.dart';


abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignInEvent extends AuthEvent{
  final SignInParams signInParams;

  const SignInEvent(this.signInParams);
  @override
  List<Object?> get props => [signInParams];
}
class SignUpEvent extends AuthEvent{
  final SignUpParams params;

  const SignUpEvent(this.params);
  @override
  List<Object?> get props => [params];
}

class CheckAlreadySignedInEvent extends AuthEvent {

  @override
  List<Object?> get props => [];
}

class SignOutEvent extends AuthEvent {
  final AccessToken accessToken;

  const SignOutEvent(this.accessToken);
  @override
  List<Object?> get props => [accessToken];
}

