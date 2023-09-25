part of 'startup_bloc.dart';

abstract class StartupState extends Equatable {
  const StartupState();
}

class StartupInitial extends StartupState {
  @override
  List<Object> get props => [];
}
