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

class CheckAlreadySignedInEvent extends AuthEvent {

  @override
  List<Object?> get props => [];
}

