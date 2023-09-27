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
class SubmitClickUpCode extends AuthEvent{
  final String clickUpCode;

  const SubmitClickUpCode(this.clickUpCode);

  @override
  List<Object?> get props => [clickUpCode];
}
class GetClickUpUserWorkspaces extends AuthEvent{
  final ClickUpAccessToken accessToken;

  const GetClickUpUserWorkspaces(this.accessToken);

  @override
  List<Object?> get props => [accessToken];
}
