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

  const GetAccessToken(this.clickupCode);

  @override
  List<Object?> get props => [clickupCode];
}
class GetClickupUserWorkspaces extends AuthEvent{
  final AccessToken accessToken;

  const GetClickupUserWorkspaces(this.accessToken);

  @override
  List<Object?> get props => [accessToken];
}
class TryGetSelectedWorkspaceSpaceEvent extends AuthEvent{
  @override
  List<Object?> get props => [];
}

