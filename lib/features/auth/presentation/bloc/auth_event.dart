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

class SignUpAnonymouslyEvent extends AuthEvent{
  final SignUpAnonymouslyParams params;

  const SignUpAnonymouslyEvent(this.params);
  @override
  List<Object?> get props => [params];
}

class UpdateUserEvent extends AuthEvent{
  final UpdateUserParams params;

  const UpdateUserEvent(this.params);
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

class DeleteAccount extends AuthEvent {
  final DeleteAccountParams deleteAccountParams;

  const DeleteAccount(this.deleteAccountParams);
  @override
  List<Object?> get props => [deleteAccountParams];
}