part of 'auth_bloc.dart';

///TODO A check if already signed in using SignInUseCase


abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class SignInEvent extends AuthEvent{
  final SignInParams signInParams;

  const SignInEvent(this.signInParams);
  @override
  List<Object?> get props => [signInParams];
}

