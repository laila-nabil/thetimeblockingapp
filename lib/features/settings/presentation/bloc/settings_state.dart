part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final Locale? currentLanguage;

  const SettingsState({this.currentLanguage});

  @override
  List<Object?> get props => [currentLanguage];
}
