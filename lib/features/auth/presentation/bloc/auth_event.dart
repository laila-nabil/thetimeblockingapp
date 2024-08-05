part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class TryGetSelectedWorkspaceSpaceEvent extends AuthEvent{
  @override
  List<Object?> get props => [];
}
class SignInEvent extends AuthEvent{
  final SignInParams signInParams;

  const SignInEvent(this.signInParams);
  @override
  List<Object?> get props => [signInParams];
}

