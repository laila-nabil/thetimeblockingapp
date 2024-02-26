part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final Locale? currentLanguage;
  final ThemeMode themeMode;

  const SettingsState(
      {this.currentLanguage, this.themeMode = Globals.defaultThemeMode});

  @override
  List<Object?> get props => [currentLanguage, themeMode];
}
