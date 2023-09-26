part of 'auth_bloc.dart';

enum AuthStateEnum {
  showCodeInputTextField,
}

class AuthState extends Equatable {
  final Set<AuthStateEnum> authStates;

  const AuthState({required this.authStates});

  @override
  List<Object?> get props => [authStates];
}