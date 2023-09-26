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
