part of 'startup_bloc.dart';

class StartupState extends Equatable {
  final bool drawerLargerScreenOpen;

  const StartupState({required this.drawerLargerScreenOpen});

  @override
  List<Object?> get props => [drawerLargerScreenOpen];
}