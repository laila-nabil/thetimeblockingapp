part of 'startup_bloc.dart';

class StartupState extends Equatable {
  final bool drawerLargerScreenOpen;
  final ClickupWorkspace? selectedClickupWorkspace;

  const StartupState(
      {required this.drawerLargerScreenOpen, this.selectedClickupWorkspace});



  @override
  List<Object?> get props => [drawerLargerScreenOpen, selectedClickupWorkspace];

  StartupState copyWith({
    bool? drawerLargerScreenOpen,
    ClickupWorkspace? selectedClickupWorkspace,
  }) {
    return StartupState(
      drawerLargerScreenOpen:
          drawerLargerScreenOpen ?? this.drawerLargerScreenOpen,
      selectedClickupWorkspace:
          selectedClickupWorkspace ?? this.selectedClickupWorkspace,
    );
  }
}
