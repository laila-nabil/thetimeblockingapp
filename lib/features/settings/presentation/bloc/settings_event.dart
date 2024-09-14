part of 'settings_bloc.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();
}

class ChangeLanguageEvent extends SettingsEvent {
  final ChangeLanguageParams changeLanguageParams;

  const ChangeLanguageEvent(this.changeLanguageParams);

  @override
  List<Object?> get props => [changeLanguageParams];
}

class ChangeThemeEvent extends SettingsEvent {
  final ThemeMode themeMode;

  const ChangeThemeEvent(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class SignOutEvent extends SettingsEvent {
  final AccessToken accessToken;

  const SignOutEvent(this.accessToken);
  @override
  List<Object?> get props => [accessToken];
}
