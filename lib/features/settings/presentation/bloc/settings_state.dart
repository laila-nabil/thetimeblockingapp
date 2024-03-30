part of 'settings_bloc.dart';

class SettingsState extends Equatable {
  final Locale? currentLanguage;
  final ThemeMode themeMode;
  final bool isLoading;
  final bool signOutSuccess;

  const SettingsState(
      {this.currentLanguage,
      this.themeMode = Globals.defaultThemeMode,
      this.isLoading = false,
      this.signOutSuccess = false});

  @override
  List<Object?> get props =>
      [currentLanguage, themeMode, isLoading, signOutSuccess];
}
