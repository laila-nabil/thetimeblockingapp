part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();
}

class ShowCodeInputTextField extends AuthEvent{
  final bool showCodeInputTextField;

  const ShowCodeInputTextField(this.showCodeInputTextField);

  @override
  List<Object?> get props => [showCodeInputTextField];
}
class GetAccessToken extends AuthEvent{
  final String clickupCode;

  const GetAccessToken.clickUp(this.clickupCode);
  const GetAccessToken.supabase():clickupCode = '';

  @override
  List<Object?> get props => [clickupCode];
}
class GetUserWorkspaces extends AuthEvent{
  final AccessToken accessToken;
  final String userId;
  const GetUserWorkspaces(this.accessToken, this.userId);

  @override
  List<Object?> get props => [accessToken,userId];
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

